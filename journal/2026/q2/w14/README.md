# 2026 W14 (Mar 30 - Apr 5)

Week opens with SMT solver exploration and Zig investigation, then launches sail-xisa project (20→42 Parser instructions + full binary encoding + MAP ISA foundation), builds personal website, creates browser-based XISA playground, and culminates in a massive multi-project Saturday (sail-xisa refactor + proptest + diff testing + bug fixes, Z3Wire multiplication, P4Py routing completion, agentic workflow design).

## Days

- [03-30-mon](03-30-mon/README.md): Gemini Q&A — SMT bit concreteness/freedom algorithms, Zig comptime vs Python AST, CIRCT/MLIR docs, residue project (Knuth's Claude's Cycles), Tao paper on AI and math
- [03-31-tue](03-31-tue/README.md): XISA formal modeling day — Sail language exploration, Sail XISA project bootstrap (20 Parser instructions + fetch-decode-execute), XISA-in-NIC concepts (SimBricks, Corundum, XiNIC), hardware formal modeling landscape (SAIL/Rosette/K/Lean/Kami/Chisel)
- [04-01-wed](04-01-wed/README.md): Massive day — sail-xisa Parser ISA completed (42 variants, binary encoding), .CD modifier batch, MAP ISA foundation (28 variants), personal website built (qobilidop.github.io), Z3/hash exploration
- [04-02-thu](04-02-thu/README.md): XISA Web Playground (Rust/WASM + Astro/Svelte) + polish (/spec page with WaveDrom diagrams, GitHub Pages fix, CI refactor, naming cleanup), rclone research, Z3 SMT encoding strategies
- [04-03-fri](04-03-fri/README.md): Rest day — went to work, evening recovery
- [04-04-sat](04-04-sat/README.md): Multi-project sprint — sail-xisa (Cargo workspace refactor, proptest, diff testing, bit-endianness bug cascade fix, 116 tests), Z3Wire (multiplication op + docs/dev refactor), P4Py (Slice 5 routing + refinement, tor.p4 complete), agentic workflow deep dive (repo doc standards, v0.1.0 transition protocol)

## Agent index

- SMT-DEEP-DIVE: bit concreteness (iterative masking), entanglement taxonomy, freedom (3-tier pipeline: COI + simulation + SAT). Relevant to Z3Wire and symbolic execution work (Mon)
- ZIG-EXPLORATION: native arbitrary bit-widths, comptime type generation, no AST macros — compared against Python for eDSL design (Mon)
- READING: Tao paper on AI/math (odorless proofs, citogenesis), residue project (structured multi-agent math collaboration) (Mon), ProVerB program verification taxonomy PV1-PV6 (Sat)
- NEW-PROJECT: sail-xisa — formal XISA spec in Sail, bootstrapped Tue, Parser ISA completed Wed, MAP ISA started Wed, web playground Thu, refactor+testing Sat
- SAIL-XISA-PROGRESS: 20 instructions (Tue) → 42 Parser variants + binary encoding (Wed) → MAP foundation 28 variants (Wed) → web playground (Thu) → Cargo workspace refactor + proptest + diff testing + bug fixes (Sat). 36 Sail tests, 116 Rust tests
- SAIL-XISA-BUGS: bit-endianness (bit 0=MSB vs LSB), MOVI doff *8, STH/STCH/STHC store cursor not oid, MOVLII/MOVRII semantics, u8 wrapping overflow → widened to u16 (Sat)
- SAIL-XISA-TOOLCHAIN: GNU ld 2.42 bug → clang+lld, .cargo/config.toml (Sat)
- XISA-FORMAL-STRATEGY: Sail model as ground truth → testing oracle for future Python eDSL (differential fuzzing via C emulator, symbolic equivalence via Isla+Z3) (Tue)
- XISA-BENCHMARK-CONCEPT: dual SAIL+Rosette implementation repo for tool comparison, testing corpus, bug finding (Tue)
- ISLA: Sail's symbolic execution engine (Rust+OCaml+Z3), .ir snapshot enables OCaml-free runtime (Tue)
- XINIC-CONCEPT: XISA simulator as programmable NIC datapath via SimBricks i40e interception, "XDP in the NIC" framing (Tue)
- SIMBRICKS: modular sim framework (QEMU/gem5 + NIC sims + ns-3), PCIe/Ethernet message passing, i40e behavioral model (Tue)
- HW-FORMAL-LANDSCAPE: SAIL/ASL (ISA), Rosette (solver-aided), Kami (Coq), Chisel (RTL gen), SymbiYosys (model check), SMT (bottom) (Tue)
- PERSONAL-WEBSITE: qobilidop.github.io — Astro, Selenized theme, dev container, GitHub Pages (Wed)
- WEB-PLAYGROUND: Rust WASM simulator (43 instructions), Astro+Svelte, CodeMirror 6, port 4322 (Thu)
- SPEC-PAGE: /sail-xisa/spec — sail --doc → doc.json, WaveDrom encoding diagrams, coverage tables, pexecute/mexecute source, MPLv2 notice (Thu)
- CI-REFACTOR: web.yml uses dev container image now (was installing from scratch), merged tools/→scripts/ (Thu)
- NAMING: execute→pexecute (24 files), P/M prefix convention (parser=P, MAP=M) — Sail has no namespaces (Thu)
- Z3WIRE-MUL: SymBitVec operator*, W1+W2 bit growth, signed-if-either-signed, bvmul sign-agnostic (signedness via extension), TDD, worktree (Sat)
- Z3WIRE-DOCS: split guide.md → 8 focused files in docs/dev/, removed docs/design/, north_star.md refined to 19-line boundary doc, README rewritten with "combinational logic verification" tagline + Z3 comparison example (Sat)
- P4PY-TOR-COMPLETE: Slice 5 routing (7 new features) + refinement pass (p4.var, @p4runtime_translation, @name). 59 tests, tor.p4 fully translated. p4testgen blocked by p4c version (Sat)
- AGENTIC-WORKFLOW: docs/dev/{north_star,arch,todo,rules}.md, AGENTS.md as single control file (not llms.txt — website standard, not repo). justfile inside dev container. v0.1.0 = transition direct-to-main→PR workflow. design.md with rejected alternatives (Chesterton's Fence). 3-project parallel with strict 1:1 agent:project mapping. Dropped Z3Wire Weave (Sat)
- IR-DESIGN: language-agnostic IR hourglass model — protobuf/FlatBuffers, MLIR/CIRCT, BMv2 JSON, SMT-LIB/Btor2, WASM (Sat)
- Z3-ITE-ENCODING: nested ite vs flat implications vs UF+macro-finder vs arrays. One-hot optimization for mutually exclusive conditions (Thu)
- RCLONE: MIT Go CLI, gold standard multi-cloud sync, union remote, aggressive retry+checksum (Thu)
- SAIL-GOTCHAS: loop bounds need assert helpers, `val` reserved, bits4 needs prelude, encdec bit-width errors only in `sail -c`, `unsigned()` for comparison (Wed)
- LEGAL: XISA spec is MPLv2 (white paper p2), project code Apache 2.0, ISA-derived docs need MPLv2 notice (Thu)
- THEME: Mon = theory, Tue = bootstrap, Wed = build sprint, Thu = playground + polish, Fri = rest, Sat = multi-project blitz + workflow design
