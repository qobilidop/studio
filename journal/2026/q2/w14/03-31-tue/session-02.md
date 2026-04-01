# you asked

I'm thinking about combining an XISA (https://xsightlabs.com/switches/xisa) simulator with a Corundum NIC (https://github.com/corundum/corundum). Goal is to be able to install binary XISA programs to the NIC, and using the XISA simulator logic to process packet. Is that possible?

---

# claude response

This is an interesting systems integration question. Let me research both projects to understand their architectures and assess feasibility.

Now let me get the XISA white paper for more technical detail on the ISA itself:

This is a fascinating idea, and the short answer is: **it's conceptually possible but would be a significant engineering project with some fundamental architectural mismatches to work around.** Let me break down why.

## What each project actually is

**XISA** is the programming specification for Xsight's X-Switch silicon — an instruction set architecture for programmable Ethernet switches. It consists of two instruction sets: a Parser ISA for packet parsing and header extraction, and a MAP ISA for the programmable match-action pipeline, both executing in parallel across dedicated micro-engines. Xsight provides an instruction-accurate simulator for the X2, along with drivers, APIs, and an assembler.

**Corundum** is an open-source, high-performance FPGA-based NIC and platform for in-network compute. Crucially, it provides an application section for implementing custom logic, with a dedicated PCIe BAR for control and interfaces that provide access to the core datapath and DMA infrastructure. The app block exposes AXI-lite for register access, DMA interfaces, MAC-synchronous streaming, datapath-synchronous streaming, and interface-level streaming.

## Why it's appealing but hard

The idea of loading XISA binaries into a Corundum NIC to get a "programmable switch-like NIC" is creative, but there are several layers of difficulty:

**1. Architectural mismatch — switch vs. NIC.** XISA is designed for a *switch ASIC* with a matrix of programmable data-path units (DPUs) surrounded by interface units (IFUs) containing Ethernet MAC and SerDes blocks. The X-Switch has tens of MAP cores along with instruction and scratchpad memories running thousands of threads in parallel to maintain line rate. A Corundum NIC on an FPGA has a fundamentally different topology — it's a host-attached endpoint, not a multi-port forwarding device.

**2. No public XISA simulator source code.** The XISA ISA specification is open, and the assembler has been opened, but the instruction-accurate simulator is supplied by Xsight — it's not clear it's open-source or available as something you could re-implement on an FPGA. You'd likely need to build your own XISA execution engine (parser + MAP core) in RTL.

**3. Execution model translation.** The XISA MAP complex uses parallel threads and async accelerators with flexible instruction ordering and elastic resource allocation. Implementing even a single MAP core faithfully in Verilog within Corundum's application section would be a substantial RTL project. You'd be building a soft-core processor that executes XISA instructions.

## What *could* work

If you're willing to scope the project appropriately, here's a realistic path:

**Build a simplified XISA execution engine in Corundum's app block.** You would write an RTL module that implements a subset of the XISA Parser and MAP instruction sets, place it inside `mqnic_app_block`, and connect it to the AXI-stream datapath interfaces so it sees packets before they're delivered to the host (or after they're submitted for TX). The XISA binary would be loaded into on-FPGA block RAM via the dedicated PCIe BAR. Incoming packets flow through your XISA engine, get processed according to the loaded program, and then either get forwarded, modified, or dropped.

This would give you something like a **single-port, reduced-capability XISA processor on a NIC** — useful for prototyping XISA programs, testing custom packet processing logic, or doing in-network compute experiments. You wouldn't get the parallelism or line-rate guarantees of the real X2 silicon, but you'd have a functional platform.

## Key challenges to plan for

**Parser stage**: The XISA parser processes up to 256 bytes of header in a deterministic timeframe using a protocol graph. Implementing this in RTL is the more tractable half — it's largely a state machine walking packet headers.

**MAP stage**: This is the harder part. You'd need to implement the instruction decoder, ALU operations, memory access patterns (table lookups, scratchpad), and potentially some of the async accelerator interfaces. Even a single-threaded implementation would be useful for functional testing, though it wouldn't match the real chip's throughput.

**Table/memory infrastructure**: XISA programs expect lookup tables (TCAM, hash tables, etc.) that the X-Switch provides in hardware. You'd need to map these to FPGA resources (BRAM-based tables, or simplified lookup structures).

## Bottom line

It's a cool research project, not a weekend hack. The most realistic version would be: take the publicly documented XISA instruction encoding, build a minimal soft-core interpreter for it in Verilog, and plug it into Corundum's application section as a packet-processing engine. You'd get a functional testbed for XISA programs on real hardware with real packets, but at a fraction of the performance of actual X-Switch silicon. If Xsight ever releases the simulator source code or an FPGA reference implementation of the execution engine, that would dramatically change the feasibility equation.

---

# you asked

So for the Corundum NIC, I have to write RTL for any application? I can't assume it has a "CPU", and just run my XISA simulator program in that "CPU"?

---

# claude response

Great question — let me clarify what Corundum actually gives you to work with.

You're right to push on this — it's the key architectural question. The answer is: **Corundum by itself does not include a CPU.** It's pure RTL — custom Verilog logic running on FPGA fabric. There's no processor sitting there waiting for you to load a binary.

But that doesn't mean your idea is dead. You have a few options, and they range from "add a CPU yourself" to "use a board that already has one."

## Option 1: Add a soft-core CPU into Corundum's app block

You could instantiate a RISC-V soft-core processor (like NEORV32, which is a platform-independent VHDL-based RISC-V SoC that can be synthesized for AMD, Intel, and other FPGAs, and is available as a Vivado IP block) inside Corundum's application section. You'd wire it up to the AXI-stream packet interfaces so the CPU can see incoming packets. Then you'd write your XISA simulator/interpreter as a C program running on that RISC-V core — it reads a packet from the datapath, interprets the loaded XISA binary against it, and writes out the result.

This is the closest to what you're imagining: a CPU on the NIC that runs software. The downside is performance — a soft-core RISC-V running at ~100–250 MHz interpreting XISA instructions per-packet will be orders of magnitude slower than line rate. You'd be limited to maybe tens or hundreds of thousands of packets per second rather than millions.

## Option 2: Use a Zynq-based Corundum board

Corundum supports boards like the BittWare 250-SoC (Xilinx Zynq UltraScale+ XCZU19EG) and Xilinx ZCU102 and ZCU106. These Zynq devices have **hard ARM Cortex-A53 cores** built into the silicon alongside the FPGA fabric. This is your most practical path — the ARM cores are real, fast CPUs running Linux. You could run your XISA simulator as a userspace program on the ARM cores, with Corundum's FPGA logic handling the NIC datapath and forwarding packets to/from the ARM side via shared memory or AXI interfaces.

This gives you a real CPU at ~1 GHz+, capable of running a C/C++ XISA interpreter at reasonable speed, with the Corundum NIC handling the actual Ethernet I/O. It's not line-rate processing, but it's a realistic development and prototyping platform.

## Option 3: The PsPIN / PANIC approach

There's academic precedent here. PsPIN is a RISC-V-based in-network compute architecture where clusters of RISC-V "handler processing units" process packets, with scratchpad memories and a modular design implemented in synthesizable HDL. The PANIC project built on Corundum's MAC and PHY infrastructure and used RISC-V cores as offload engines. You could follow a similar pattern — use Corundum for the NIC plumbing and add a cluster of RISC-V cores as the "XISA execution engine."

## Bottom line

Your instinct is sound: you'd rather write software than RTL. The path of least resistance is to **target a Zynq-based Corundum board**, use the hard ARM cores to run your XISA simulator in software, and have Corundum's datapath feed packets to the ARM side for processing. You wouldn't need to write any custom RTL beyond the glue to route packets between Corundum's datapath and the processing system — and even that may be largely handled by existing Zynq PS-PL integration infrastructure.

The tradeoff is throughput: software interpretation of XISA on a general-purpose CPU will always be much slower than native execution on X-Switch silicon. But for development, testing, and proving out your XISA programs against real traffic, it could work well.

---

# you asked

How easy / difficult is it to test a Corundum NIC? Can I do it on my CPUs? Do I have to use real FPGAs? Say I only care about functional correctness. I don't care about performance.

---

# claude response

Great news on this front — Corundum was specifically designed with simulation in mind. Let me check the details.

This is actually one of Corundum's strongest points. **You can test everything on your regular CPU — no FPGA needed.**

Corundum ships with an extensive simulation framework that covers the entire system from a simulation model of the driver and PCIe interface on one side to the Ethernet interfaces on the other side. The whole thing runs on your laptop or workstation using free, open-source tools.

## What you need (all free, all run on a normal Linux machine)

The simulation stack is cocotb + Icarus Verilog, with Python-based test infrastructure. The required packages are cocotb, cocotbext-axi, cocotbext-eth, cocotbext-pcie, scapy, and Icarus Verilog. Those cocotb extensions are written by the same author (Alex Forencich) and they simulate the PCIe host interface, AXI buses, and Ethernet MAC/PHY — so you get a full end-to-end simulation of the NIC without any hardware.

## How it works in practice

cocotb drives stimulus onto the inputs of the design and monitors outputs directly from Python — no extra RTL test harness needed. The Python testbench acts as both the "host machine" (simulating the PCIe driver side) and the "network" (injecting/capturing Ethernet frames). The Verilog RTL is simulated cycle-by-cycle by Icarus Verilog, and cocotb orchestrates everything.

Running the tests is straightforward. You can run all tests via `tox` in the repo root, which sets up a Python virtual environment and installs all dependencies automatically, or run `pytest -n auto` to run tests in parallel across multiple CPU cores. You can also run individual tests via `make`, which provides the capability of overriding parameters and enabling waveform dumps in FST format viewable in GTKWave.

## What this means for your XISA integration

This is actually great for your use case. Your development loop would look like:

1. Write your custom logic in Corundum's application block (whether that's an XISA interpreter in RTL, a soft-core CPU, or whatever approach you choose)
2. Write a Python cocotb test that injects Ethernet packets on the simulated network side, with your XISA binary loaded via the simulated PCIe BAR
3. Run `pytest` on your workstation — Icarus Verilog simulates the entire NIC cycle-by-cycle, your custom logic processes the packets, and your Python test checks the output
4. Inspect waveforms in GTKWave if something goes wrong

No FPGA board, no Vivado synthesis, no bitstream generation. For functional correctness testing, this is exactly the right approach. The simulation will be slow (maybe seconds or minutes per packet depending on complexity), but since you said you don't care about performance, that's fine.

One thing to note: Corundum's core logic is 100% open-source Verilog, and the simulation uses open-source tools. The only time you need vendor tools (Vivado, Quartus) is when you want to synthesize a bitstream for an actual FPGA board. For simulation and functional testing, everything is free and runs on a standard x86 Linux machine.

---

# you asked

Cool. Actually this is an X, Y problem. Using Corundum is the Y here. My X is, I'm building an XISA simulator, but I want to test it in a more realistic e2e setup. For example, by building a toy NIC that runs the XISA simulator. But the NIC PCIe interface has a lot of nuances. I'd like to have a simple solution that my NIC looks somewhat like a realistic device to the host. And ideally there should be a way to program the XISA simulator, by installing binary programs to it, through PCIe probably. Thoughts?

---

# claude response

Ah, that changes things significantly! You don't actually need Corundum's full NIC stack — you need a **realistic-looking PCIe device that your host can interact with**, which internally runs your XISA simulator to process packets. Let me think about the options more carefully.

Now I see the real problem much more clearly. You want your XISA simulator to live inside something that looks like a PCIe NIC to the host, without having to implement all the PCIe plumbing yourself. Here are your realistic options, ranked from easiest to hardest:

## Option 1: Custom QEMU PCIe device (easiest, most practical)

This is probably your best bet. You write a custom QEMU PCI device in C that:

- Presents itself to the guest OS as a NIC (with the right PCI class code, BARs, etc.)
- Exposes a BAR region where the host driver can upload XISA binaries
- Exposes another BAR or ring buffer structure for submitting/receiving packets
- Internally calls your XISA simulator to process packets
- Connects to QEMU's network backend (TAP, socket, etc.) for actual packet I/O

The pciemu project on GitHub provides an example of PCIe device emulation in QEMU, aimed at helping people explore PCIe devices without real hardware or test ideas for new devices. There are also several tutorials and examples that show how to create a PCI-e device in QEMU with just a few things: registering BARs, handling MMIO reads/writes, and connecting to QEMU's infrastructure.

The workflow looks like: your XISA simulator is compiled as part of QEMU (or linked as a library), the custom device's MMIO handlers dispatch to it, and the guest VM sees a real PCIe NIC that it can write a kernel driver for. You get PCIe config space, BARs, MSI/MSI-X interrupts, and DMA — all handled by QEMU's mature infrastructure. You just implement the device-specific logic.

**Effort**: maybe a few hundred lines of C for a minimal device, plus whatever glue you need to hook in your XISA simulator. You inherit all of QEMU's PCIe correctness for free.

## Option 2: vfio-user (your device as a separate process)

If you don't want to compile your code into QEMU, vfio-user is a protocol that allows a device to be emulated in a separate process outside of a VMM, communicating over a UNIX domain socket. QEMU includes a vfio-user client, and the specification allows implementing arbitrary PCI devices in userspace outside of QEMU.

You'd write a standalone process (in whatever language you like) that implements the vfio-user server protocol, presents PCIe BARs and handles MMIO, and runs your XISA simulator internally. QEMU connects to it and presents it to the guest as a PCIe device.

**Upside**: your simulator lives in its own process, can be written in any language, and you can restart/debug it independently from QEMU. **Downside**: vfio-user is more complex to implement than a simple QEMU device, and the ecosystem is less mature with fewer examples.

## Option 3: PCIem (no VM needed at all)

This is a newer, interesting option. PCIem is a Linux kernel framework that creates virtual PCIe devices by populating synthetic cards as legitimate PCI devices, with the device logic implemented entirely in userspace. It already has examples including an E1000-compatible NIC implementation that supports communication redirection to/from your real NIC.

This would let you run directly on your host machine — no VM, no QEMU. The kernel sees a real PCI device, you write a driver for it, and the device behavior is your userspace XISA simulator. This is the most "realistic" from the host's perspective, but the project is newer and less battle-tested.

## My recommendation

**Go with Option 1 (custom QEMU device).** Here's why it fits your X problem best:

- QEMU handles all PCIe nuances for you (config space, BAR allocation, interrupt routing, DMA translation)
- You can connect the device's network side to a TAP interface, so real packets flow through your XISA simulator
- The guest OS sees a normal PCIe NIC — you write a small kernel driver that uploads XISA binaries via MMIO to one BAR and submits/receives packets via descriptor rings in another BAR
- Your XISA simulator is just a C function that QEMU calls: "here's a packet buffer, here's the loaded XISA program, give me the output"
- You can test with a stock Linux VM, use Wireshark on both sides, and validate functional correctness end to end

The minimal architecture would be something like: BAR0 for control registers and XISA binary upload, BAR1 (or a ring-buffer in guest memory accessed via DMA) for packet descriptors, and MSI-X for completion interrupts. That's a fairly standard NIC device model, and QEMU gives you all the building blocks.

---

# you asked

One step up probably, how do people test a networking device like a NIC?

---

# claude response

This is a great question that broadens the picture. NIC testing happens at several layers, and understanding them will help you pick the right level for your XISA simulator work.

## The layers of NIC testing

**Layer 1: RTL / Pre-silicon simulation.** This is what Corundum's cocotb testbench does, and what ASIC companies use UVM/SystemVerilog for. You simulate the actual hardware design cycle-by-cycle, with models of PCIe, DMA, and Ethernet on both sides. It's the most thorough but slowest — you're verifying the hardware itself. This is overkill for you since you're not building hardware.

**Layer 2: Device-level emulation (QEMU-style).** You implement the device's register interface, DMA behavior, and interrupt logic in software. A real OS (in a VM) interacts with your emulated device using a real driver. This is what we discussed last time — good for testing the software/hardware interface contract.

**Layer 3: Software model / executable specification.** This is the most interesting one for your case. The Cambridge uvNIC project captures this well: hardware and software engineers work together to produce an executable specification of the new network hardware, covering the control register layout, DMA mechanisms, interrupt strategy and so forth, which hardware engineers use to produce test bench stimuli and software engineers use to build and test a real device driver against the virtual hardware. The key insight is that uvNIC forwards interactions with hardware to a virtual NIC application, which implements a software emulation of the hardware NIC and responds by sending and receiving packets over a commodity device operated in raw socket mode.

**Layer 4: Driver-level / functional testing.** Here you don't care about the PCIe details at all — you test at the packet I/O level. Tools like DPDK, iperf, or packet generators send traffic through the NIC and verify what comes out. This tests the data plane, not the control plane.

**Layer 5: System/integration testing.** Real hardware, real cables, real traffic generators (like Spirent, Ixia/Keysight), real network topologies. This is what NIC vendors do for performance validation, carefully setting up NUMA-aware topology with the NIC as the bottleneck.

## What you actually need

Since your real goal is testing an XISA simulator, not building NIC hardware, you probably want **something between Layer 3 and Layer 4**. You need:

1. A way to feed packets into your XISA simulator
2. A way to load XISA programs into it
3. Something that makes it look "realistic" enough that you're confident the XISA simulator would work in a real device

Here's the thing — you might not need the PCIe layer at all. Consider what "realistic e2e" actually means for your simulator:

**Option A: Just use raw sockets or TAP interfaces (simplest).** Write your XISA simulator as a userspace program that opens a TAP device (or a raw socket, or an AF_XDP socket). The host sees a normal network interface (`xisa0`). Packets flow in, your simulator processes them according to the loaded XISA binary, packets flow out. You load XISA programs via a Unix socket, a config file, or even just command-line arguments. No PCIe, no drivers, no QEMU — but the packet processing is completely realistic. You can `ping` through it, run `iperf` through it, put it in a network namespace and build real topologies.

**Option B: The uvNIC approach (realistic device model without hardware).** In addition to basic PCI read and write operations, uvPCI implements x86 specific PCIe restrictions such as 64-bit register reads/writes, MSI generation, and 128-byte 32-bit aligned DMA operations, with DMA appearing to the driver as it would in reality. You write a virtual NIC specification in userspace, a matching kernel driver talks to it, and packets flow through raw sockets. This gives you PCI realism without QEMU or FPGAs.

**Option C: QEMU custom device (full PCIe realism).** As discussed before — highest fidelity for the PCIe interface, but also the most work.

## My honest recommendation

For testing an XISA simulator specifically, **Option A (TAP/raw sockets) is probably the right call.** Here's why:

The XISA simulator's job is to process packets according to XISA programs. The PCIe transport is orthogonal to that — whether the packet arrives via DMA descriptor rings or a `read()` on a file descriptor, the XISA execution is identical. What matters is that real packets go in, your XISA program runs, and correct packets come out.

A TAP-based setup lets you test with real tools: Wireshark, tcpdump, scapy, iperf, ping, network namespaces for multi-hop topologies, and even connect to real networks. You could build a setup where two network namespaces are connected through your XISA simulator, load a forwarding program, and verify it handles ARP, ICMP, TCP flows, VLAN tags, etc. correctly.

If later you want to prove the XISA simulator works correctly when driven by PCIe DMA descriptors (i.e. the NIC integration), that's when you'd move to QEMU or uvNIC. But for functional correctness of the XISA execution engine itself, TAP is the fastest path to real testing.

---

# you asked

Do you know SimBricks? Is that relevant?

---

# claude response

Yes — SimBricks is *very* relevant to what you're trying to do. It might actually be the best fit for your problem.

## What SimBricks is

SimBricks is an open-source simulation framework that modularly combines and connects battle-tested simulators for different components: machines (e.g. QEMU, gem5, Simics), hardware components (e.g. Verilator, Tofino, FEMU SSD), and networks (e.g. ns-3, OMNeT++). The key idea is that the structure of the simulation corresponds to the structure of the simulated system, interfacing different component simulators at natural interfaces — specifically PCIe and Ethernet.

## Why it fits your problem almost perfectly

Here's what makes SimBricks a great match for your XISA simulator:

**It gives you the PCIe interface for free.** SimBricks defines interfaces for interconnecting simulators based on natural component boundaries in physical systems, specifically PCIe and Ethernet links. You don't implement PCIe yourself — SimBricks provides a well-defined PCIe message protocol (MMIO reads/writes, DMA, interrupts) that your simulator just speaks. QEMU or gem5 on the host side already has the adapter.

**Your XISA simulator runs as a separate process.** SimBricks runs individual component simulators as separate independent processes, communicating through message passing via optimized shared-memory queues. So your XISA simulator would be its own program, written in whatever language you want, that receives PCIe messages on one side and Ethernet messages on the other. It doesn't need to be compiled into QEMU or linked against anything heavy.

**It already supports NIC-shaped devices.** The framework integrates QEMU and gem5 as host simulators, Verilator as an RTL hardware simulator, and ns-3 and OMNeT++ as network simulators. They've already built an Intel i40e NIC simulator as a reference. Your XISA simulator would slot in at the same position — it's a "device simulator" that has a PCIe interface facing the host and an Ethernet interface facing the network.

**Full-system, unmodified software stacks.** SimBricks simulations run unmodified full-system stacks, including applications, operating systems such as Linux, and hardware RTL. So you could run a real Linux VM with a real driver that talks to your XISA NIC device, load XISA binaries over the simulated PCIe BAR, and send real traffic through ns-3 on the network side.

**You can scale it.** They combined four instances of gem5 with four instances of their i40e NIC simulator, each pair connected through PCIe, all connected to an ns-3 network — running full Ubuntu with unmodified NIC drivers and iperf. You could build a topology with multiple XISA-powered NICs and test how XISA programs behave in a multi-node setup.

## What the architecture would look like

```
[gem5/QEMU host VM]  <--PCIe messages-->  [Your XISA NIC simulator]  <--Eth messages-->  [ns-3 network]
     (Linux + driver)                      (loads XISA binary,                          (switches, links,
                                            processes packets)                           other hosts)
```

Your XISA NIC simulator process would:
1. Receive PCIe MMIO writes when the driver uploads an XISA binary or configures the device
2. Receive PCIe DMA descriptors pointing to packet buffers when the driver submits packets for TX
3. Run your XISA program against each packet
4. Send Ethernet messages to ns-3 (or receive them from ns-3 for RX)
5. DMA processed packets back to the host and raise MSI-X interrupts

Integrating a simulator into SimBricks only requires the developer to add adapters for the specific interfaces, matching them up with that simulator's internal abstractions. The PCIe and Ethernet message formats are already defined — you just implement the device behavior.

## SimBricks vs. the other options we discussed

The advantage over plain QEMU: you don't modify or rebuild QEMU. Your XISA simulator is a standalone process. You also get ns-3 for realistic network simulation (latency, loss, topologies), and gem5 if you ever care about host CPU timing accuracy.

The advantage over TAP/raw sockets: you get a *real* PCIe device model with proper DMA, interrupts, and BAR semantics, so you're actually testing the full device interface — how a driver would install XISA programs and submit packets over PCIe — not just the packet processing logic in isolation.

The advantage over Corundum cocotb: you're not simulating RTL, so it's much faster, and you write your simulator in C/C++/Python rather than Verilog.

This is probably the tool you were looking for before discovering Corundum. I'd start with the SimBricks examples repository and their i40e NIC simulator as a reference for how to build your own device simulator.

---

# you asked

Are there curated testing corpus involving NICs using the SimBricks?

---

# claude response

The honest answer is: SimBricks doesn't ship a curated "NIC test corpus" in the way you might be hoping for — there's no folder of "here are 500 packet sequences to validate your NIC handles edge cases correctly." But what it does provide is quite useful as a starting point.

## What SimBricks actually ships with

**Built-in workload examples.** The examples repository contains a Jupyter Notebook that walks through setting up two hosts with i40e NICs connected through a switch, running iperf between them. The networking case study folder demonstrates increasingly complex virtual prototypes of network topologies.

**The SIGCOMM'22 artifact.** The artifact repository contains scripts and instructions for running all experiments from the paper, along with JSON output files from their runs. The specific experiments they reproduced include:

- Key findings from prior work in congestion control, NIC architecture, and in-network computing
- netperf TCP benchmarks (TCP_STREAM for throughput, TCP_RR for latency) between pairs of simulated hosts
- Corundum NIC simulation via Verilator, as well as a behavioral Corundum model in C++, both fully compatible with unmodified Linux drivers
- iperf UDP benchmarks at scale (up to 1000 hosts)
- DCTCP congestion control validation against physical testbed results

**NIC simulator building blocks.** The repo includes `lib/simbricks/nicbm`, a helper C++ library for implementing behavioral NIC simulation models, offering similar abstractions as device models in gem5. Their i40e behavioral NIC model and the Corundum behavioral model serve as reference implementations you can study.

## What's missing for your use case

There's no pre-built packet-level test corpus like "send these 200 crafted packets and check the output matches this expected result." SimBricks is oriented around *system-level* workloads (run iperf, run a real application, measure throughput/latency), not unit-level NIC verification with curated edge-case packets.

For the kind of functional correctness testing you want for an XISA simulator, you'd likely need to build that test corpus yourself. But the good news is that within a SimBricks simulation, the hosts run real Linux, so you can leverage existing packet-crafting tools:

**scapy** — craft arbitrary packets with weird header combinations, VLAN tags, fragmentation, etc., and send them through your simulated XISA NIC. This is probably the most useful tool for building an XISA test corpus because you can programmatically generate packets that exercise every parser path.

**packetdrill** — Google's tool for scripted TCP/UDP test scenarios with precise timing. Useful if your XISA programs need to handle TCP offload or stateful processing.

**tcpreplay** — replay pcap captures from real network traffic through your simulated setup. You can find public pcap datasets (CAIDA, MAWI, various CTF captures) for diverse traffic mixes.

**The Linux networking test suite** (`tools/testing/selftests/net/` in the kernel tree) — exercises a wide range of networking behaviors (fragmentation, VLAN, tunneling, multicast, etc.) that would stress-test a NIC's packet processing.

## Pragmatic recommendation

Use SimBricks as the *infrastructure* — it gives you the PCIe + Ethernet plumbing and realistic host interaction. Then build your test corpus in layers:

1. **Basic smoke tests**: iperf TCP/UDP through your XISA NIC (SimBricks already has this wired up)
2. **Protocol coverage**: scapy scripts that send crafted packets targeting each XISA parser path (IPv4, IPv6, VLAN, MPLS, tunneled, fragmented, etc.)
3. **Real traffic replay**: tcpreplay with public pcap datasets
4. **Regression suite**: capture expected output packets for each test, diff against actual output

None of this is XISA-specific or SimBricks-specific — it's the same approach you'd use to validate any programmable NIC or software switch. The XISA-specific part is making sure your test corpus covers each XISA instruction and program flow, which only you can design based on the ISA specification.

---

# you asked

system-level workloads is fine. It's actually preferred if I can show that some realistic workloads work with my XISA simulator NIC. Are there such testing corpus?

---

# claude response

There isn't a single curated "NIC testing corpus" that the community rallies around the way, say, SPEC CPU or MLPerf works for their domains. But there *is* a well-established set of realistic workloads that networking and systems researchers consistently use to evaluate NICs, SmartNICs, and programmable network devices. These are the workloads that reviewers expect to see in papers, and they'd all run inside SimBricks.

## The standard datacenter networking workloads

**iperf3** — The bare minimum. TCP and UDP throughput and latency between hosts. SimBricks already has this wired up in their examples. If your XISA NIC can pass iperf3 traffic correctly, that's your first "it works" milestone.

**netperf** — Similar to iperf but with more test types. The SimBricks paper itself uses netperf TCP_STREAM (throughput) and TCP_RR (request-response latency) as their primary benchmarking workload. This is a good baseline because TCP_RR exercises the full packet-processing path for small messages.

**memcached / Redis + YCSB or mutilate** — This is the go-to "realistic application" workload in NIC research. A memcached or Redis server handles key-value requests from clients generating load via YCSB (Yahoo Cloud Serving Benchmark) or mutilate (a memcached load generator from MIT). It generates realistic small-packet, request-response traffic patterns typical of datacenter workloads. Nearly every SmartNIC and programmable NIC paper uses this.

**nginx / Apache + wrk / ab** — HTTP serving workload. A web server handles requests from a load generator. Exercises TCP connection setup/teardown, varied packet sizes, and concurrent flows.

**Sockperf** — Low-latency UDP benchmarking, commonly used in trading/HFT NIC evaluations.

**TRex (Cisco)** — A realistic traffic generator that enables smart replay of actual traffic templates, supporting stateful and stateless DPDK-powered traffic generation with per-stream jitter, latency, and statistics reporting. Commonly used for stress-testing firewalls, NATs, and load balancers.

## What SimBricks specifically validated in their paper

The SimBricks SIGCOMM'22 paper reproduced key findings from prior work in congestion control, NIC architecture, and in-network computing. Their artifact repository contains scripts and instructions for running all experiments from the paper, along with output logs. The specific scenarios include DCTCP congestion control validation, NIC architecture comparisons (Corundum vs. i40e), and multi-host iperf/netperf benchmarks.

## What I'd suggest for your XISA simulator demo

Build a progression of increasingly impressive demos, all runnable in SimBricks:

1. **"It boots"**: Linux loads your XISA NIC driver, `ip link` shows the interface up, `ping` works between two hosts. This proves basic L2/L3 forwarding in your XISA program works.

2. **"It handles real TCP"**: iperf3 TCP stream between two hosts through your XISA NIC. Shows your XISA program handles full TCP flows without corrupting checksums, reordering, or dropping.

3. **"It runs a real application"**: memcached server on one host, mutilate or YCSB client on another, traffic flowing through your XISA NIC. This is the "money shot" for reviewers — it's a real datacenter workload generating thousands of small request-response transactions.

4. **"It does something a normal NIC can't"**: Write an XISA program that does something programmable — a simple firewall, a load balancer, traffic classification, or header rewriting — and show it working with one of the above workloads. This demonstrates the whole point of XISA: that you can program custom network functions.

None of these require a special "corpus." They're all standard open-source tools that run on any Linux machine, and they generate their own traffic. The workloads *are* the test corpus. The beauty of system-level testing is that if memcached works correctly over your XISA NIC, that implicitly validates hundreds of packet-level edge cases (TCP handshakes, retransmissions, window scaling, Nagle's algorithm, delayed ACKs, etc.) that you'd never enumerate by hand.

---

# you asked

Are they using the i40e NIC in those evaluations? Are the extensive tests for i40e NIC? I wonder if I should program my XISA simulator to behave like i40e, and just reuse all these tests.

---

# claude response

That's a really clever idea — piggyback on an existing NIC's driver and test infrastructure rather than building everything from scratch. Let me check how deeply SimBricks's i40e model is tested and whether this strategy is practical.

Yes — the i40e is SimBricks's primary NIC and this strategy has real merit, but let me give you the honest picture of what you'd gain and what you'd be signing up for.

## What SimBricks's i40e model actually implements

The SimBricks i40e behavioral model lives at `sims/nic/i40e_bm` in the repo. It's a C++ behavioral model (not RTL) that is compatible with unmodified drivers and implements important NIC features such as multiple descriptor queues, TCP and IP checksum offload, receive-side scaling, large segment offload, interrupt moderation, and support for MSI and MSI-X.

It's the default NIC in essentially all SimBricks examples and evaluations. They used it with gem5 running full Ubuntu with unmodified Linux i40e NIC drivers and iperf, and showed their simulation approximates the behavior of a physical testbed much more closely than ns-3 alone. The examples use `system.IntelI40eNIC` and `simulation.I40eNicSim` as the standard NIC component.

## What tests already work with it

Everything SimBricks has ever demonstrated runs through the i40e model: netperf TCP_STREAM/TCP_RR, iperf TCP/UDP, DCTCP congestion control experiments, and multi-host topologies up to 1000 nodes. The Linux disk images they distribute already include the i40e kernel driver. It also works with DPDK, since the i40e is one of DPDK's most mature PMDs.

## Why this strategy is clever but has a catch

The clever part: you get a working NIC model, a working driver, working disk images, and working test scripts for free. You fork `sims/nic/i40e_bm`, gut the packet processing internals, and replace them with your XISA simulator. The PCIe interface, descriptor ring management, interrupt logic, and driver interactions all stay the same. From the host's perspective, it's still an i40e. From the network's perspective, packets are now processed by your XISA engine.

The catch: **the i40e's control plane is complex.** The real i40e has an admin queue protocol, firmware emulation, VSI (Virtual Station Interface) management, and a bunch of register-level interactions that the Linux driver expects. SimBricks's behavioral model implements enough of this to make the driver happy, but it's still a substantial amount of device-specific logic. If you fork it and start modifying the datapath, you need to be careful not to break the control plane interactions that the driver depends on.

## A more practical approach

Rather than making your XISA simulator *pretend to be* an i40e, consider this architecture:

**Keep the i40e model as-is, but intercept packets in the datapath.** The i40e behavioral model has a clear point where packets enter (from the Ethernet side) and exit (via DMA to host memory), and vice versa for TX. You could insert your XISA simulator as a processing stage at that point — packets arrive, pass through your XISA program, then continue through the normal i40e descriptor/DMA machinery. This way you don't need to reimplement any i40e control plane logic, and all existing tests work unchanged.

Concretely: the host still sees an i40e, the driver is unmodified, all SimBricks tests and workloads work as-is. But every packet transits your XISA engine. You add a new PCIe BAR (or repurpose an admin queue command) to load XISA binaries. The result is an "i40e with XISA programmable datapath" — which is actually a reasonable approximation of what a real XISA-powered NIC would look like from a system perspective.

This gives you exactly what you want: all the existing SimBricks workloads (iperf, netperf, DCTCP, etc.) running through your XISA simulator, with zero work on driver development or PCIe plumbing.

---

# you asked

Ah, is this like an XDP in the NIC?

---

# claude response

Yes, that's a great analogy! XDP (eXpress Data Path) lets you hook a BPF program into the kernel's network stack right at the driver level, before the normal stack processes the packet. What you'd be doing is conceptually the same thing, but one level down — inside the NIC model itself, before the packet even reaches the driver.

The parallel is quite clean:

| | XDP | Your XISA-in-NIC approach |
|---|---|---|
| Where it runs | In the kernel, at the driver RX path | In the NIC model, before DMA to host |
| Program format | eBPF bytecode | XISA binary |
| How programs are loaded | `bpf()` syscall | PCIe BAR write or admin queue command |
| Actions on packets | Pass, drop, redirect, modify | Whatever your XISA program does |
| What sees the result | The kernel networking stack | The i40e driver, which thinks it's a normal packet |

And in fact, this "programmable processing in the NIC before the host sees the packet" is exactly what the industry calls **NIC-offloaded XDP** or **hardware XDP**. Some real NICs (like Netronome and Mellanox/NVIDIA ConnectX) already support running XDP/eBPF programs in the NIC hardware. What you're building is the same concept but with XISA as the ISA instead of eBPF — which makes sense, since XISA is designed for exactly this kind of packet processing, with a richer instruction set than eBPF (a full parser stage, match-action pipeline, table lookups, etc.).

This framing also makes for a compelling story when you present it: "We take an existing, well-tested NIC model, inject an XISA programmable datapath at the packet processing boundary, and show that realistic workloads run correctly through it." Reviewers immediately understand the architecture because everyone knows what XDP is.

---

# you asked

What's special about i40e? Why does SimBricks choose it?

---

# claude response

Good question. It's a pragmatic choice rather than a deeply technical one.

The i40e (Intel X710/XL710 family) became the de facto standard NIC in systems and networking research roughly around 2016–2020 because of a convergence of practical factors.

**It was everywhere.** Intel 700-series NICs were the most commonly deployed NICs in academic and industry testbeds during that era. CloudLab, Emulab, and many university clusters shipped with them. When you wrote a paper, your reviewers likely had i40e hardware too, so results were reproducible.

**The Linux driver is upstream and mature.** The `i40e` kernel driver has been in mainline Linux for years, is well-maintained, and exercises a broad set of NIC features (RSS, checksum offload, TSO, MSI-X, etc.) without requiring any out-of-tree patches. This matters for simulation — you want the driver in your simulated Linux image to "just work" without custom kernel builds.

**DPDK support is first-class.** The i40e PMD is one of the most complete and battle-tested drivers in DPDK. If you want to demonstrate kernel-bypass scenarios or high-performance userspace networking in simulation, i40e is the path of least resistance.

**The device interface is well-documented.** Intel published detailed datasheets for the X710/XL710. Compared to, say, Mellanox/NVIDIA ConnectX NICs (which have a much more opaque firmware/command interface), the i40e's register-level interface is tractable to reimplement in a behavioral model. This is probably the most important reason SimBricks chose it — someone actually *could* write a C++ model of it in a reasonable amount of time.

**It hits the sweet spot of complexity.** It's complex enough to be realistic (multiple queues, RSS, offloads, MSI-X, admin queue), but not so complex that modeling it is a multi-year effort. Older NICs like the e1000 are simpler but don't represent modern NIC features. Newer NICs like ConnectX-5/6 have much more complex firmware interfaces (mailbox commands, capability negotiation, etc.) that would be far harder to model.

So the short answer is: SimBricks chose i40e because it was the most common NIC in research testbeds, with the best combination of open documentation, driver maturity, and feature richness that was still feasible to model. It wasn't because the i40e is architecturally special — it's just the NIC that the systems research community standardized on, the way everyone uses x86 for host simulation even though ARM exists.

For your purposes, this is good news. It means that by building on the i40e model, you're automatically compatible with the ecosystem that the research community already uses and expects.

---

# you asked

Have people tried making i40e programmable in some way? Like making it a SmartNIC?

---

# claude response

Yes, and this is directly relevant to your project. The i40e itself isn't programmable — it's a fixed-function NIC. But there's a whole body of work on making NICs programmable using the XDP/eBPF model, and several projects have built on top of i40e-class hardware or used i40e as the baseline to compare against.

## The landscape of "programmable i40e-like NICs"

**The i40e supports XDP in driver mode only.** The Linux i40e driver supports XDP at the driver level — meaning eBPF programs run on the *host CPU* at the earliest point in the driver's RX path, before the packet enters the kernel networking stack. But the i40e hardware itself doesn't execute eBPF. The packet processing still happens on the CPU.

**Netronome was the pioneer in hardware eBPF offload.** The Netronome NFP4000 SmartNIC has 60 programmable network processing cores (microengines) clocked at 800MHz, and was the first NIC to support offloading eBPF/XDP programs to the NIC hardware itself. But Netronome is essentially defunct now.

**hXDP put XDP on an FPGA NIC.** The hXDP project (OSDI'20) implemented a system to run Linux XDP programs on FPGA NICs, using the Corundum/NetFPGA platform. They compared against a server equipped with an Intel XL710 40GbE NIC running Linux with i40e drivers as the baseline. This is essentially what you're proposing — except with XISA instead of eBPF as the program ISA.

**OXDP** explicitly tackled offloading XDP to SmartNICs for accelerating packet processing.

## Why this matters for your project

The architecture you're converging on — "i40e NIC model with an XISA programmable datapath inserted at the packet processing boundary" — is exactly the pattern that hXDP, Netronome, and OXDP established. The research framing writes itself:

- hXDP did it with eBPF on FPGAs
- Netronome did it with eBPF on custom ASIC microengines
- You're doing it with XISA, which is a *switch* ISA being repurposed as a NIC datapath ISA

That's actually a novel and interesting angle. XISA was designed for multi-terabit switch pipelines with parallel MAP cores and a dedicated parser stage — it's a much richer packet-processing ISA than eBPF (which is a general-purpose restricted VM that happens to be used for packets). Showing that the XISA execution model works in a NIC context, not just a switch context, would be a meaningful contribution.

And the evaluation methodology is already established by these prior papers: take the i40e as baseline, show the same workloads (iperf, memcached, etc.) run correctly through the XISA-programmable version, then demonstrate something the plain i40e can't do (custom header parsing, in-NIC load balancing, protocol-specific acceleration, etc.).

So to directly answer your question: nobody has made the i40e itself programmable, but the i40e is the standard baseline that *everyone* compares their programmable NIC against. Your approach of extending the SimBricks i40e model with an XISA datapath slots perfectly into this existing research narrative.

---

# you asked

How would you name this project?

---

# claude response

Fun question. Let me think about what the project actually is and what name would communicate that clearly.

The core idea is: take the XISA switch ISA, run it as a programmable datapath inside a NIC, simulated end-to-end in SimBricks using the i40e device model as the foundation. So the name should capture some combination of XISA + NIC + simulation/prototyping.

A few directions:

**Descriptive / academic style:**
- **XiNIC** — "XISA-in-NIC." Short, pronounceable ("zi-nik"), immediately tells you what it is. My favorite.
- **NIC-XISA** — straightforward but less catchy.
- **XISA-NF** — XISA Network Function, emphasizing that you're running network functions written in XISA.

**Emphasizing the "switch ISA meets NIC" angle:**
- **SwitchNIC** — captures the core novelty (switch ISA running in a NIC), but too generic and probably already taken.
- **X-NIC** — clean, short, but maybe too vague.

**Emphasizing the simulation/prototyping aspect:**
- **SimXISA** — highlights it's a simulated XISA platform.
- **vXISA** — "virtual XISA," in the spirit of vSwitch, vNIC, etc.

**Playful / memorable:**
- **Xenic** — mashup of XISA + NIC, sounds like "xenic" (relating to a host/guest, which is a nice double meaning for a PCIe device). Pronounce it "zen-ik" or "zee-nik."

I'd go with **XiNIC**. It's short, memorable, googlable, and immediately communicates "XISA in a NIC" to anyone who knows either term. It also has a nice visual parallel with XiLinx, XiSight — the "Xi" prefix feels natural in the hardware/FPGA world. And it doesn't overcommit to the simulation aspect, so the name still works if you eventually move to real hardware.