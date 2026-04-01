# 2026-03-31 (Tuesday)

Massive exploration day: Gemini deep dive into XISA formal modeling (Sail language, Isla symbolic execution, Rosette comparison, benchmarking dual-implementation repo concept), monorepo vs polyrepo for agents, hardware formal modeling landscape (SAIL/Rosette/K/Lean/Chisel/Kami). Claude session bootstrapped Sail XISA project (20 Parser instructions implemented). Also explored XISA-in-NIC concepts (SimBricks, Corundum, QEMU virtual NIC, XiNIC naming) and NIC architecture (MMIO/DMA/AXI-Lite, PCIe program loading).

## Sessions

- **session-00**: Daily log — Gemini chat: monorepo vs polyrepo for agents, XISA formal modeling brainstorm (Sail vs Rosette vs K vs Lean vs C++/Z3), readable formal specs as PDF replacement, XISA benchmarking repo concept (dual SAIL+Rosette implementation), hardware formal modeling landscape (ASL, Rosette, Kami, Chisel, SymbiYosys), Sail instruction representation (scattered defs, encdec mapping, Jib IR, Isla symbolic execution), Sail outside CPU ISAs (eBPF, WASM, CHERI), Isla architecture (Rust+OCaml+Z3, .ir snapshot), Python frontend for Isla concept, alternatives (KLEE, Angr, Rosette), dev container vs prod container (multi-stage Dockerfile), NIC architecture (MMIO/DMA/AXI-Lite), XISA+Corundum integration concept
- **session-01**: Sail XISA project bootstrap — full project from empty repo to 20 Parser instructions with fetch-decode-execute loop. Sail language, devcontainer (Ubuntu 24.04 + opam + OCaml 5.1.0 + Sail 0.20.1), CMake, no binary encoding (deferred), 256-slot instruction memory, scattered union/function, 15 test suites. Instructions: NOP, HALT, HALTDROP, MOV, MOVI, EXT, ADD/ADDI, SUB/SUBI/SUBII, AND/ANDI, OR/ORI, CMP/CMPIBY/CMPIBI, CNCTBY/CNCTBI, BR (7 conditions), BRBTST
- **session-02**: XISA-in-NIC exploration — Claude chat: Corundum NIC (FPGA, cocotb sim, no built-in CPU), QEMU custom PCIe device, vfio-user, PCIem, SimBricks (modular simulation, PCIe+Ethernet interfaces, i40e model), XDP-like NIC datapath concept, i40e as research standard, XiNIC project naming, NIC testing layers, TAP/raw socket approach, SimBricks workloads (iperf, netperf, memcached), hXDP/Netronome/OXDP precedents

## Agent index

- SAIL-XISA-PROJECT: new repo github.com:qobilidop/sail-xisa.git — formal XISA spec in Sail, 20 Parser instructions, fetch-decode-execute loop, devcontainer, CMake+CTest, CI via GHCR (session-01)
- SAIL-XISA-REMAINING: STCI/STC (cursor), HDR+STH+STCH/STHC (header metadata), ST/STI (struct storage), EXTMAP/MOVMAP (MAP bridge), MOVL/MOVR (dynamic offset), NXTP/PSEEK (transition table — hardest) (session-01)
- SAIL-LESSONS: sub_bits() not minus, sail_shiftleft/right not operators, scattered union+function for extensibility, enum equality needs manual overload, vector registers need literal defaults, get_slice_int for int→bits (session-01)
- XISA-FORMAL-STRATEGY: build Sail model as ground truth baseline first, then use as testing oracle for future Python eDSL via differential fuzzing (Sail C emulator) or symbolic equivalence (Isla+Z3) (session-00)
- XISA-BENCHMARK-IDEA: dual SAIL+Rosette implementation repo — compare tools, serve as testing corpus, identify framework bugs, performance benchmark. Considered adding K Framework, Lean 4, bare-metal C++/Z3 (session-00)
- ISLA: Sail's symbolic execution engine, Rust core + OCaml bridge + Z3 backend. Handles SSA, path forking, symbolic memory. .ir snapshot file enables OCaml-free runtime (session-00)
- PYTHON-ISLA-FRONTEND: concept — Python eDSL → Jib IR → Isla. Alternative to OCaml dependency. Ambitious but feasible (session-00)
- HW-FORMAL-LANDSCAPE: SAIL/ASL (ISA spec), Rosette (solver-aided eDSL), Kami (Coq RTL), Chisel/FIRRTL (RTL gen), SymbiYosys (model checking), SMT solvers (bottom) (session-00)
- XINIC-CONCEPT: XISA simulator as programmable NIC datapath via SimBricks i40e model interception. "XDP in the NIC" framing. SimBricks provides PCIe+Ethernet plumbing (session-02)
- SIMBRICKS: modular simulation framework — QEMU/gem5 hosts + NIC/device sims + ns-3 networks, connected via shared-memory PCIe/Ethernet messages. i40e behavioral model as reference (session-02)
- NIC-TESTING-LAYERS: RTL sim → device emulation (QEMU) → software model (uvNIC) → driver/functional (DPDK/iperf) → system/integration (Spirent/Ixia). TAP+raw socket simplest for XISA sim testing (session-02)
- NIC-ARCH: MMIO (control, light switch), DMA (throughput, freight train), AXI-Lite (internal addressing). Program loading: host allocates buffer → MMIO doorbell → NIC DMA fetches binary (session-00)
- DECISION: targeted Sail-only XISA project first, not overcomplicated benchmark. Long-term artifacts. MVP: devcontainer, register file + PC + packet buffer, 2 instructions, C emulator (session-00)
- DECISION: no binary instruction encoding yet — instruction memory stores union values directly. Binary decode deferred until XISA publishes encodings (session-01)
- DECISION: Sail for formal spec despite readability concerns — artifacts have long-term value as testing oracle, Python eDSL for readability comes later (session-00)
