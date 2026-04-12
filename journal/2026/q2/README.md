# 2026 Q2

Quarter opens with rapid sail-xisa progress (full Parser ISA, MAP ISA, web playground, then Cargo workspace refactor + proptest + diff testing + bug fixes). Z3Wire gains multiplication, gets a major docs/dev refactor, adds 6 design decision records, gate-level examples, and branding (`<W>` logo). P4Py tor.p4 translation completed. Personal website launched and migrated to monorepo. Repo renamed cyborg→studio. Deep exploration of agentic dev workflow standards, theorem provers (Lean/Rocq), Racket LOP, packet parsing IR design, formal verification primitives (MoonBit/Dafny/Ada), blogging stacks (Zola/Hugo), and human-AI symbiosis philosophy (Haraway, Hayles).

## Weeks

- [W14](w14/README.md): SMT/Zig exploration, sail-xisa from bootstrap to full Parser ISA + MAP ISA + web playground + refactor + diff testing (116 Rust tests), Z3Wire (multiplication + docs/dev refactor + 6 design records + gate-level examples), P4Py tor.p4 complete (59 tests), personal website, agentic workflow design (repo doc standards, v0.1.0 protocol)
- [W15](w15/README.md): Zensical adoption + Z3Wire tooling/branding migration, sail-xisa docs restructuring + MAP ISA push (opcodes 26-62, diff fuzz testing, 7 bugs fixed), packet parsing IR design, Rust+MLIR/BPF exploration, theorem prover survey (Lean/Rocq/F*), Racket LOP deep dive, repo rename cyborg→studio, website migration to monorepo, formal verification primitives (MoonBit/Dafny/Ada), blogging stack eval (Zola vs Hugo), AI+math philosophy (Avigad, proof compression), human-AI symbiosis reading (Haraway, Hayles)

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
