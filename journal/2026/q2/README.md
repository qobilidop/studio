# 2026 Q2

Quarter opens with rapid sail-xisa progress (full Parser ISA, MAP ISA, web playground, then Cargo workspace refactor + proptest + diff testing + bug fixes). Z3Wire gains multiplication, gets a major docs/dev refactor, adds 6 design decision records, gate-level examples, and branding (`<W>` logo). P4Py tor.p4 translation completed. Personal website launched and migrated to monorepo. Repo renamed cyborg→studio. Deep exploration of agentic dev workflow standards, theorem provers (Lean/Rocq), Racket LOP, packet parsing IR design, formal verification primitives (MoonBit/Dafny/Ada), blogging stacks (Zola/Hugo), human-AI symbiosis philosophy (Haraway, Hayles), custom note app architecture (VS Code extension, software sovereignty), hardware formal specification (Sail, C++-to-RTL equivalence, ac_types, open-source HLS), comptime/CTFE landscape, ISA instruction fuzzer methodology, and type theory foundations.

## Weeks

- [W14](w14/README.md): SMT/Zig exploration, sail-xisa from bootstrap to full Parser ISA + MAP ISA + web playground + refactor + diff testing (116 Rust tests), Z3Wire (multiplication + docs/dev refactor + 6 design records + gate-level examples), P4Py tor.p4 complete (59 tests), personal website, agentic workflow design (repo doc standards, v0.1.0 protocol)
- [W15](w15/README.md): Zensical adoption + Z3Wire tooling/branding migration, sail-xisa docs restructuring + MAP ISA push (opcodes 26-62, diff fuzz testing, 7 bugs fixed), packet parsing IR design, Rust+MLIR/BPF exploration, theorem prover survey (Lean/Rocq/F*), Racket LOP deep dive, repo rename cyborg→studio, website migration to monorepo, formal verification primitives (MoonBit/Dafny/Ada), blogging stack eval (Zola vs Hugo), AI+math philosophy (Avigad, proof compression), human-AI symbiosis reading (Haraway, Hayles), custom note app architecture (VS Code extension, software sovereignty)
- [W16](w16/README.md): HW formal spec deep dive (Sail, FormalRTL, Jasper/HECTOR), C++-to-RTL equivalence checking (algorithmic subset C++, ac_types, bit-blasting), open-source HLS (Bambu, Dynamatic), Lean for HW, Webb's Theorem, C preprocessor alternatives, comptime survey (D/C++/Zig/Jai/Rust), symbolic execution naming, ISA instruction fuzzer methodology, type theory (division by zero)

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
- THEOREM-PROVERS: survey of Lean 4, Rocq, Isabelle/HOL, Dafny, F*. User wants to learn Lean + Rocq. Lean 4 deep dive: opaque/mutual/typeclasses, StateM + FBIP. Identity: "machine building assistant, human learning practitioner" (W15)
- REPO-RENAME: cyborg→studio (studio/study pair from Latin studium). Website migrated to monorepo with CI deploy. Racket LOP deep dive (Reader→Expander, source-to-source via Rosette). Z3Wire branding (`<W>` logo, zensical.toml migration) (W15)
- FORMAL-VERIFICATION: MoonBit `proof_ensure`/`moon prove` (2026). Built-in verification: Dafny (Z3-backed, AWS production), Ada 2012/SPARK, Eiffel (Design by Contract pioneer). Compiler+prover shared semantics vs external annotations (W15)
- BLOGGING-SSG: Zola (Rust, Tera, strict link checking) vs Hugo (Go, massive ecosystem). MkDocs/Zensical frontmatter for metadata not URL routing. Enhancement proposal doc systems surveyed (mdBook, Jekyll, xml2rfc, Confluence) (W15)
- AI-MATH: Avigad arXiv:2603.03684 — "drive-by proving" critique (AI formalization worthless without reusable library). Proof compression: syntactic (shorter) vs structural (lemma extraction = real math). Mathlib as reusable foundation. Active research: Test-Time RL (W15)
- HUMAN-AI-SYMBIOSIS: AI as distinct species, human intelligence biologically locked. Haraway (cyborg, making kin), Hayles (posthuman, cognisphere), Latour (ANT), Lovelock (Novacene). Haraway↔Hayles complementary (material vs informational). User plans to read both. Wife (historian) recommended Haraway (W15)
- CUSTOM-NOTE-APP: Obsidian alternative as VS Code extension for software sovereignty. AST parser → directed graph, Webview visualization, hardcoded workspace topology. Open: TypeScript vs LSP backend (W15)
- SOFTWARE-SOVEREIGNTY: user values owning core daily-use systems. Raw Markdown as future-proof format. Immunity to enshittification (W15)
- HW-FORMAL-SPEC: correct-by-construction via eDSLs, deep SMT during construction, verified codegen. Sail = ISA gold standard. FormalRTL uses C/C++ ref models + hw-cbmc. Commercial: Jasper/HECTOR. C++-to-RTL equivalence via algorithmic subset C++ (ac_int types, bounded loops) → bit-blast → SAT/SMT (W16)
- AC_TYPES-Z3WIRE: user considering ac_int for Z3Wire. Natural growth arithmetic at compile time (ac_int<4> + ac_int<5> → ac_int<6>). Ecosystem: NVIDIA MatchLib, Intel oneAPI FPGAs, CERN da4ml (W16)
- LEAN-HW: Lean FRO HW verification mandate. Dependent types for bit-width, time-warping simulation (>100M cycles/sec). Community HDL "Sparkle" (W16)
- HLS-OPEN-SOURCE: Bambu/PandA (C/C++ → Verilog/VHDL), Dynamatic (EPFL, MLIR-based, dynamically scheduled). Both take algorithmic subset C++ (W16)
- WEBBS-THEOREM: functional completeness — Webb (N-valued logic), Sheffer (Boolean NAND/NOR), Sierpinski (infinite sets), Odrzywołek (continuous eml operator) (W16)
- COMPTIME-LANDSCAPE: D pioneered CTFE (2007), C++ constexpr→consteval, Zig flagship, Jai #run, Rust const fn (restricted), Circle @meta. Compiler-as-VM challenge, dependent type theory territory (W16)
- ISA-FUZZERS: coverage-guided + differential testing methodology. DifuzzRTL, Cascade, RFuzz, ProcessorFuzz, PreSiFuzz. Grammar-aware generation, HW-specific coverage (toggle/FSM/CSR), intentional hazard generation. Applicable to XISA (W16)
- SYMBOLIC-EXECUTION: naming conventions — PathGroup (active), PathSet (output), ExecutionFrontier (search). angr/KLEE patterns (W16)
- TYPE-THEORY-TOTALITY: Buzzard FAQ on 1/0=0 in Lean/Rocq — total functions, burden shifts from syntax to theorem (W16)
