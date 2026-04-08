# 2026 Q2

Quarter opens with rapid sail-xisa progress (full Parser ISA, MAP ISA, web playground, then Cargo workspace refactor + proptest + diff testing + bug fixes). Z3Wire gains multiplication, gets a major docs/dev refactor, adds 6 design decision records and gate-level examples. P4Py tor.p4 translation completed. Personal website launched. Deep exploration of agentic dev workflow standards. W15 pushes sail-xisa MAP ISA to 68 variants (opcodes 0-62) with differential fuzz testing, adopts Zensical, and explores packet parsing IR design and Rust+MLIR/BPF ecosystem.

## Weeks

- [W14](w14/README.md): SMT/Zig exploration, sail-xisa from bootstrap to full Parser ISA + MAP ISA + web playground + refactor + diff testing (116 Rust tests), Z3Wire (multiplication + docs/dev refactor + 6 design records + gate-level examples), P4Py tor.p4 complete (59 tests), personal website, agentic workflow design (repo doc standards, v0.1.0 protocol)
- [W15](w15/README.md): Zensical adoption + Z3Wire tooling migration, sail-xisa docs restructuring + MAP ISA push (opcodes 26-62, diff fuzz testing, 7 bugs fixed), packet parsing IR design, Rust+MLIR/BPF/P4 backend exploration

## Agent index

- SMT: deep dive into bit concreteness (iterative masking), entanglement, freedom (3-tier pipeline) — extends Z3Wire work from Q1 (W14)
- LANGUAGE-SURVEY: Zig comptime vs Python AST for eDSL design (W14)
- SAIL-XISA: formal XISA spec in Sail — Parser ISA complete (42 variants), MAP ISA 28 variants (W14) → 68 variants across opcodes 0-62 (W15). LFLAG subsystem, PMEM struct ops, diff fuzz testing (7 bugs fixed, 54 Sail + 117 Rust tests). 64-bit binary encoding, web playground (Rust/WASM) + /spec page, Cargo workspace refactor. Docs restructured (Starlight reverted, spec/plans deleted, docs/ flattened). Strategy: Sail as ground truth oracle. XISA spec MPLv2, project Apache 2.0 (W14, W15)
- Z3WIRE: multiplication operator* (W1+W2 bit growth, TDD, worktree). Dropped Weave to keep scope focused. Major docs/dev refactor (8 focused files, north_star.md as boundary doc, README rewritten). 6 design decision records (concrete-types through bit-growth-arithmetic). Gate-level examples (adder, barrel shifter, multiplier) proving equivalence to Z3Wire ops. Literal API shorthand explored and rejected. Tooling migrated: MkDocs Material → Zensical, pip → uv (W14, W15)
- P4PY: tor.p4 fully translated — Slice 5 routing (7 new features), refinement pass, 59 tests. p4testgen blocked by p4c version (W14)
- XISA-NIC: SimBricks i40e model + XISA simulator = programmable NIC datapath (XiNIC concept). Also explored Corundum, QEMU virtual PCIe device (W14)
- HW-FORMAL-LANDSCAPE: SAIL/ASL, Rosette, K Framework, Kami, Chisel, SymbiYosys — surveyed for XISA modeling tool selection (W14)
- PERSONAL-WEBSITE: qobilidop.github.io — Astro SSG, Selenized theme, GitHub Pages (W14)
- AGENTIC-WORKFLOW: standardized repo docs (docs/dev/{north_star,arch,todo,rules}.md), AGENTS.md as control file, justfile, v0.1.0 = transition to PR workflow, design.md with rejected alternatives, 1:1 agent:project mapping (W14)
- RUST-MLIR: melior (most mature), pliron (native Rust), circt-rs. Projects: Burn/CubeCL, LLZK, CIRCT integrations (W15)
- BPF-MLIR: no upstream BPF dialect, P4MLIR proposal, p4c backends for eBPF/DPDK/uBPF (W15)
- ZENSICAL: Rust core + Python extensibility, reads mkdocs.yml natively, differential builds. Best Markdown-based doc solution for docs-as-code workflows (W15)
- PACKET-PARSING-IR: brainstormed P4-subset IDL and "LLVM IR of packet parsing". Concluded: pure Rust source-to-source transpilation likely best for eBPF/DPDK (p4c-ebpf, BCC, Kaitai precedents). Dual MLIR+Rust IR considered but MLIR overhead not justified for this domain (W15)
