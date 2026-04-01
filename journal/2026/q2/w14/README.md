# 2026 W14 (Mar 30 - Apr 5)

Week opens with deep SMT solver exploration and Zig language investigation, then pivots hard into XISA formal modeling: Sail language deep dive, Sail XISA project bootstrapped (20 Parser instructions), XISA-in-NIC concepts (SimBricks, Corundum, XiNIC), and hardware formal modeling landscape survey.

## Days

- [03-30-mon](03-30-mon/README.md): Gemini Q&A — SMT bit concreteness/freedom algorithms, Zig comptime vs Python AST, CIRCT/MLIR docs, residue project (Knuth's Claude's Cycles), Tao paper on AI and math
- [03-31-tue](03-31-tue/README.md): XISA formal modeling day — Sail language exploration, Sail XISA project bootstrap (20 Parser instructions + fetch-decode-execute), XISA-in-NIC concepts (SimBricks, Corundum, XiNIC), hardware formal modeling landscape (SAIL/Rosette/K/Lean/Kami/Chisel)

## Agent index

- SMT-DEEP-DIVE: bit concreteness (iterative masking), entanglement taxonomy, freedom (3-tier pipeline: COI + simulation + SAT). Relevant to Z3Wire and symbolic execution work (Mon)
- ZIG-EXPLORATION: native arbitrary bit-widths, comptime type generation, no AST macros — compared against Python for eDSL design (Mon)
- READING: Tao paper on AI/math (odorless proofs, citogenesis), residue project (structured multi-agent math collaboration) (Mon)
- NEW-PROJECT: sail-xisa — formal XISA spec in Sail, 20 Parser instructions implemented, devcontainer+CMake+CI, 15 test suites (Tue)
- XISA-FORMAL-STRATEGY: Sail model as ground truth → testing oracle for future Python eDSL (differential fuzzing via C emulator, symbolic equivalence via Isla+Z3) (Tue)
- XISA-BENCHMARK-CONCEPT: dual SAIL+Rosette implementation repo for tool comparison, testing corpus, bug finding (Tue)
- ISLA: Sail's symbolic execution engine (Rust+OCaml+Z3), .ir snapshot enables OCaml-free runtime (Tue)
- XINIC-CONCEPT: XISA simulator as programmable NIC datapath via SimBricks i40e interception, "XDP in the NIC" framing (Tue)
- SIMBRICKS: modular sim framework (QEMU/gem5 + NIC sims + ns-3), PCIe/Ethernet message passing, i40e behavioral model (Tue)
- HW-FORMAL-LANDSCAPE: SAIL/ASL (ISA), Rosette (solver-aided), Kami (Coq), Chisel (RTL gen), SymbiYosys (model check), SMT (bottom) (Tue)
- THEME: Mon = theoretical exploration (SMT, Zig, readings), Tue = new project action (XISA formal modeling + NIC integration concepts)
