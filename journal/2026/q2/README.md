# 2026 Q2

Quarter opens with rapid sail-xisa progress: full Parser ISA (42 variants + binary encoding), MAP ISA foundation (28 variants), web playground (Rust/WASM + Astro/Svelte). Personal website launched. Continued SMT/Zig exploration from Q1.

## Weeks

- [W14](w14/README.md): SMT/Zig exploration, sail-xisa from bootstrap to full Parser ISA + MAP ISA + web playground + /spec page, personal website (qobilidop.github.io) built

## Agent index

- SMT: deep dive into bit concreteness (iterative masking), entanglement, freedom (3-tier pipeline) — extends Z3Wire work from Q1 (W14)
- LANGUAGE-SURVEY: Zig comptime vs Python AST for eDSL design (W14)
- SAIL-XISA: formal XISA spec in Sail — Parser ISA complete (42 variants, 24 tests), MAP ISA started (28 variants, 12 tests), 64-bit binary encoding, web playground (Rust/WASM) + /spec page (WaveDrom diagrams, sail --doc). Strategy: Sail as ground truth oracle for future Python eDSL. XISA spec is MPLv2, project Apache 2.0 (W14)
- XISA-NIC: SimBricks i40e model + XISA simulator = programmable NIC datapath (XiNIC concept). Also explored Corundum, QEMU virtual PCIe device (W14)
- HW-FORMAL-LANDSCAPE: SAIL/ASL, Rosette, K Framework, Kami, Chisel, SymbiYosys — surveyed for XISA modeling tool selection (W14)
- PERSONAL-WEBSITE: qobilidop.github.io — Astro SSG, Selenized theme, GitHub Pages (W14)
