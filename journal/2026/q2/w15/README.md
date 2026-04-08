# 2026 W15 (Apr 6–12)

Zensical adoption and Z3Wire tooling migration, sail-xisa docs restructuring then massive MAP ISA push (opcodes 26-62, differential fuzz testing, 7 bugs fixed), deep Gemini exploration of Rust+MLIR, BPF/eBPF ecosystem, packet parsing architectures, and brainstorming a P4-subset IDL / Packet Parsing IR.

## Days

- [04-06-mon](04-06-mon/README.md): Zensical deep dive + Z3Wire tooling migration (MkDocs Material to Zensical, pip to uv), sail-xisa docs restructuring (Starlight reverted, spec/plan cleanup), MAP ISA expansion (opcodes 26-43, all self-contained done), Rust+MLIR/BPF/P4 backend exploration
- [04-07-tue](04-07-tue/README.md): Packet parsing ecosystem deep dive (P4-to-eBPF, TCAM limits, DPDK/VPP/OVS, P4-subset IDL brainstorm, Packet Parsing IR design), sail-xisa MAP ISA batch (opcodes 44-62, LFLAG subsystem, diff fuzz testing, 7 bugs fixed, CP instructions)

## Agent index

- ZENSICAL: comprehensive comparison vs MkDocs/Docusaurus/Hugo/Sphinx. Migration: MkDocs Material → Zensical (reads mkdocs.yml natively), pip → uv. Zensical best for docs-as-code (Rust core, Python extensibility, standard Markdown) (Mon)
- SAIL-XISA-MAP: opcodes 0-43 (all self-contained) on Mon, then opcodes 44-62 on Tue (PMEM struct mgmt, LFLAG subsystem, bitwise, hash, copy-to-packet). Total: 68 instruction variants across 0-62. Differential fuzz testing found 7 bugs (shift overflows, bounds behavior divergences). Studied sail-riscv/sail-arm subsystem patterns. 54 Sail tests, 117+ Rust tests (Mon, Tue)
- SAIL-XISA-DOCS: adopted z3wire docs/dev pattern, tried and reverted Starlight, deleted 43 spec/plan files (-18740 lines), extracted reference content to docs/, flattened docs/dev → docs/ (Mon)
- PACKET-PARSING-IR: brainstormed P4-subset IDL (bit/struct/header → cross-language parsers + validators + SMT constraints) and then "LLVM IR of packet parsing" (MLIR dialect vs Rust IR). Concluded: pure Rust source-to-source transpilation likely best for eBPF/DPDK targets (p4c-ebpf, BCC, Kaitai precedents) (Tue)
- EBPF-LIMITATIONS: P4Runtime bridged via user-space agent. Ternary match needs TSS (~128 mask cap), range unsupported (must expand). 512B stack, fixed map sizes, spinlock restrictions (Tue)
- RUST-MLIR: melior (most mature, TableGen+FFI), pliron (native Rust), circt-rs. Projects: Burn/CubeCL, LLZK, CIRCT integrations (Mon)
- BPF-MLIR: no upstream BPF dialect in MLIR, P4MLIR proposal on Discourse, p4c backends (p4c-ebpf, p4c-dpdk, p4c-ubpf) (Mon)
