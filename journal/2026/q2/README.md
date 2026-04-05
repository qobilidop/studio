# 2026 Q2

Quarter opens with rapid sail-xisa progress (full Parser ISA, MAP ISA, web playground, then Cargo workspace refactor + proptest + diff testing + bug fixes). Z3Wire gains multiplication and gets a major docs/dev refactor. P4Py tor.p4 translation completed. Personal website launched. Deep exploration of agentic dev workflow standards.

## Weeks

- [W14](w14/README.md): SMT/Zig exploration, sail-xisa from bootstrap to full Parser ISA + MAP ISA + web playground + refactor + diff testing (116 Rust tests), Z3Wire (multiplication + docs refactor), P4Py tor.p4 complete (59 tests), personal website, agentic workflow design (repo doc standards, v0.1.0 protocol)

## Agent index

- SMT: deep dive into bit concreteness (iterative masking), entanglement, freedom (3-tier pipeline) — extends Z3Wire work from Q1 (W14)
- LANGUAGE-SURVEY: Zig comptime vs Python AST for eDSL design (W14)
- SAIL-XISA: formal XISA spec in Sail — Parser ISA complete (42 variants), MAP ISA started (28 variants), 64-bit binary encoding, web playground (Rust/WASM) + /spec page, Cargo workspace refactor, proptest + diff testing (116 Rust tests), bit-endianness bug cascade fixed. Strategy: Sail as ground truth oracle. XISA spec MPLv2, project Apache 2.0 (W14)
- Z3WIRE: multiplication operator* (W1+W2 bit growth, TDD, worktree). Dropped Weave to keep scope focused. Major docs/dev refactor (8 focused files, north_star.md as boundary doc, README rewritten) (W14)
- P4PY: tor.p4 fully translated — Slice 5 routing (7 new features), refinement pass, 59 tests. p4testgen blocked by p4c version (W14)
- XISA-NIC: SimBricks i40e model + XISA simulator = programmable NIC datapath (XiNIC concept). Also explored Corundum, QEMU virtual PCIe device (W14)
- HW-FORMAL-LANDSCAPE: SAIL/ASL, Rosette, K Framework, Kami, Chisel, SymbiYosys — surveyed for XISA modeling tool selection (W14)
- PERSONAL-WEBSITE: qobilidop.github.io — Astro SSG, Selenized theme, GitHub Pages (W14)
- AGENTIC-WORKFLOW: standardized repo docs (docs/dev/{north_star,arch,todo,rules}.md), AGENTS.md as control file, justfile, v0.1.0 = transition to PR workflow, design.md with rejected alternatives, 1:1 agent:project mapping (W14)
