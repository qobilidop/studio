# 2026 W14 (Mar 30 - Apr 5)

Week opens with SMT solver exploration and Zig investigation, then launches sail-xisa project (20→42 Parser instructions + full binary encoding + MAP ISA foundation in 3 days), builds personal website, and creates browser-based XISA playground.

## Days

- [03-30-mon](03-30-mon/README.md): Gemini Q&A — SMT bit concreteness/freedom algorithms, Zig comptime vs Python AST, CIRCT/MLIR docs, residue project (Knuth's Claude's Cycles), Tao paper on AI and math
- [03-31-tue](03-31-tue/README.md): XISA formal modeling day — Sail language exploration, Sail XISA project bootstrap (20 Parser instructions + fetch-decode-execute), XISA-in-NIC concepts (SimBricks, Corundum, XiNIC), hardware formal modeling landscape (SAIL/Rosette/K/Lean/Kami/Chisel)
- [04-01-wed](04-01-wed/README.md): Massive day — sail-xisa Parser ISA completed (42 variants, binary encoding), .CD modifier batch, MAP ISA foundation (28 variants), personal website built (qobilidop.github.io), Z3/hash exploration
- [04-02-thu](04-02-thu/README.md): XISA Web Playground — Rust/WASM simulator + Astro/Svelte frontend, browser-based assembler + step debugger

## Agent index

- SMT-DEEP-DIVE: bit concreteness (iterative masking), entanglement taxonomy, freedom (3-tier pipeline: COI + simulation + SAT). Relevant to Z3Wire and symbolic execution work (Mon)
- ZIG-EXPLORATION: native arbitrary bit-widths, comptime type generation, no AST macros — compared against Python for eDSL design (Mon)
- READING: Tao paper on AI/math (odorless proofs, citogenesis), residue project (structured multi-agent math collaboration) (Mon)
- NEW-PROJECT: sail-xisa — formal XISA spec in Sail, bootstrapped Tue, Parser ISA completed Wed, MAP ISA started Wed, web playground Thu
- SAIL-XISA-PROGRESS: 20 instructions (Tue) → 42 Parser variants + binary encoding (Wed) → MAP foundation 28 variants (Wed) → web playground (Thu). 36 Sail tests, 43 Rust tests
- XISA-FORMAL-STRATEGY: Sail model as ground truth → testing oracle for future Python eDSL (differential fuzzing via C emulator, symbolic equivalence via Isla+Z3) (Tue)
- XISA-BENCHMARK-CONCEPT: dual SAIL+Rosette implementation repo for tool comparison, testing corpus, bug finding (Tue)
- ISLA: Sail's symbolic execution engine (Rust+OCaml+Z3), .ir snapshot enables OCaml-free runtime (Tue)
- XINIC-CONCEPT: XISA simulator as programmable NIC datapath via SimBricks i40e interception, "XDP in the NIC" framing (Tue)
- SIMBRICKS: modular sim framework (QEMU/gem5 + NIC sims + ns-3), PCIe/Ethernet message passing, i40e behavioral model (Tue)
- HW-FORMAL-LANDSCAPE: SAIL/ASL (ISA), Rosette (solver-aided), Kami (Coq), Chisel (RTL gen), SymbiYosys (model check), SMT (bottom) (Tue)
- PERSONAL-WEBSITE: qobilidop.github.io — Astro, Selenized theme, dev container, GitHub Pages (Wed)
- WEB-PLAYGROUND: Rust WASM simulator (43 instructions), Astro+Svelte, CodeMirror 6, port 4322 (Thu)
- SAIL-GOTCHAS: loop bounds need assert helpers, `val` reserved, bits4 needs prelude, encdec bit-width errors only in `sail -c`, `unsigned()` for comparison (Wed)
- THEME: Mon = theory (SMT, Zig), Tue = project bootstrap (sail-xisa), Wed = massive build sprint (ISA completion + website), Thu = web playground
