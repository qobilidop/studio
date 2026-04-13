# 2026 W15 (Apr 6–12)

Zensical adoption and Z3Wire tooling/branding migration, sail-xisa docs restructuring then massive MAP ISA push (opcodes 26-62, differential fuzz testing, 7 bugs fixed), deep Gemini exploration of Rust+MLIR, BPF/eBPF ecosystem, packet parsing architectures, P4-subset IDL / Packet Parsing IR brainstorm, theorem prover survey (Lean/Rocq/F*), repo rename cyborg→studio, Racket LOP deep dive, formal verification primitives survey (MoonBit/Dafny/Ada), AI+mathematics philosophy (proof compression, Avigad paper), human-AI symbiosis reading (Haraway, Hayles), blogging/documentation stack evaluation, and custom note app architecture (VS Code extension for software sovereignty).

## Days

- [04-06-mon](04-06-mon/README.md): Zensical deep dive + Z3Wire tooling migration (MkDocs Material to Zensical, pip to uv), sail-xisa docs restructuring (Starlight reverted, spec/plan cleanup), MAP ISA expansion (opcodes 26-43, all self-contained done), Rust+MLIR/BPF/P4 backend exploration
- [04-07-tue](04-07-tue/README.md): Packet parsing ecosystem deep dive (P4-to-eBPF, TCAM limits, DPDK/VPP/OVS, P4-subset IDL brainstorm, Packet Parsing IR design), sail-xisa MAP ISA batch (opcodes 44-62, LFLAG subsystem, diff fuzz testing, 7 bugs fixed, CP instructions)
- [04-08-wed](04-08-wed/README.md): Theorem prover survey (Lean 4, Rocq, Isabelle, Dafny, F*), deep Lean 4 Q&A, "machine building assistant / human learning practitioner" identity, open hardware NICs, website migration to monorepo, repo rename cyborg→studio
- [04-09-thu](04-09-thu/README.md): Racket language-oriented programming deep dive (readers, source-to-source compilation, Rosette→SMT), Python eDSL comparison, Z3Wire branding (logo + tagline + zensical.toml migration), studio repo skill path fixes
- [04-10-fri](04-10-fri/README.md): MoonBit formal verification primitives (Dafny/Ada/Eiffel/D comparison), AI data modality diagram (Moravec's paradox), blogging stack evaluation (Zola vs Hugo), enhancement proposal ecosystem survey, MkDocs/Zensical frontmatter capabilities
- [04-11-sat](04-11-sat/README.md): AI+mathematics philosophy (Avigad paper on "drive-by proving", proof compression and lemma extraction), human-AI symbiosis deep dive (Haraway, Hayles, Latour, Lovelock), systems language survey bookmark
- [04-12-sun](04-12-sun/README.md): Custom note app architecture (Obsidian alternative as VS Code extension, AST-based graph engine, software sovereignty motivation)

## Agent index

- ZENSICAL: comprehensive comparison vs MkDocs/Docusaurus/Hugo/Sphinx. Migration: MkDocs Material → Zensical (reads mkdocs.yml natively), pip → uv. Zensical best for docs-as-code (Rust core, Python extensibility, standard Markdown) (Mon)
- SAIL-XISA-MAP: opcodes 0-43 (all self-contained) on Mon, then opcodes 44-62 on Tue (PMEM struct mgmt, LFLAG subsystem, bitwise, hash, copy-to-packet). Total: 68 instruction variants across 0-62. Differential fuzz testing found 7 bugs (shift overflows, bounds behavior divergences). Studied sail-riscv/sail-arm subsystem patterns. 54 Sail tests, 117+ Rust tests (Mon, Tue)
- SAIL-XISA-DOCS: adopted z3wire docs/dev pattern, tried and reverted Starlight, deleted 43 spec/plan files (-18740 lines), extracted reference content to docs/, flattened docs/dev → docs/ (Mon)
- PACKET-PARSING-IR: brainstormed P4-subset IDL (bit/struct/header → cross-language parsers + validators + SMT constraints) and then "LLVM IR of packet parsing" (MLIR dialect vs Rust IR). Concluded: pure Rust source-to-source transpilation likely best for eBPF/DPDK targets (p4c-ebpf, BCC, Kaitai precedents) (Tue)
- EBPF-LIMITATIONS: P4Runtime bridged via user-space agent. Ternary match needs TSS (~128 mask cap), range unsupported (must expand). 512B stack, fixed map sizes, spinlock restrictions (Tue)
- RUST-MLIR: melior (most mature, TableGen+FFI), pliron (native Rust), circt-rs. Projects: Burn/CubeCL, LLZK, CIRCT integrations (Mon)
- BPF-MLIR: no upstream BPF dialect in MLIR, P4MLIR proposal on Discourse, p4c backends (p4c-ebpf, p4c-dpdk, p4c-ubpf) (Mon)
- THEOREM-PROVERS: Lean 4 (eDSL host, extensible parser, FBIP perf), Rocq (CompCert/seL4), Isabelle (Sledgehammer), Dafny (SMT-backed), F* (refinement types + Z3). User wants to learn Lean + Rocq. Lean deep dive: opaque/mutual/typeclasses for declarations, StateM + FBIP for state (Wed)
- REPO-RENAME: cyborg→studio. studio/study pair from Latin studium. Website migrated to monorepo (Astro→studio/website/, CI deploy via Ed25519 key to gh-pages). Deferred: local dir rename, AGENTS.md identity update (Wed)
- IDENTITY: "machine building assistant, human learning practitioner" — orchestrate agents for building, free cognitive load for learning (Wed)
- OPEN-NICS: Corundum (Verilog, 10/25/100G, PTP), AMD OpenNIC (AXI4-Stream, DPDK drivers). FPGA-based, potential compilation targets (Wed)
- RACKET-LOP: Reader→Syntax Objects→Expander→bytecode. `#lang` enables custom syntax. Compared to Python eDSL: syntactic freedom vs ecosystem integration. Python AST→IR→backend more pragmatic for most domains (Thu)
- SOURCE-TO-SOURCE: Rosette (Racket→SMT-LIB/Z3), Pollen (→HTML), C++ boilerplate gen. No runtime overhead/lock-in (Thu)
- Z3WIRE-BRANDING: `<W>` logo (Z/3/W encoded on 16x16 grid, adaptive SVG), tagline "Compile-time safe bit-vectors for Z3", mkdocs.yml→zensical.toml (Thu)
- FORMAL-VERIFICATION-PRIMITIVES: MoonBit `proof_ensure` + `moon prove`. Built-in verification club: Dafny (Z3-backed, compiles to 5 languages, AWS production), Ada 2012/SPARK (Pre/Post aspects), Eiffel (Design by Contract pioneer), D (runtime contracts). Key distinction: compiler+prover shared semantics vs external annotations (Fri)
- MORAVEC-PARADOX: AI capabilities mapped on data availability × abstraction level. NLP+math "blessed" (pre-abstracted tokens). Vision/physics high-data but continuous→discrete compression hard. Robotics double-cursed. Ziming Liu "everything-is-language" blog (Fri, Sat)
- BLOGGING-SSG: Zola (Rust, Tera, strict @/ link checking, custom .sublime-syntax) vs Hugo (Go Templates, massive ecosystem, external data). Both extend CommonMark: shortcodes, syntax highlighting, math. MkDocs/Zensical: frontmatter for metadata but not URL routing (Fri)
- ENHANCEMENT-PROPOSALS: survey of PEPs, KEEP, Rust RFCs, Swift Evolution, JEPs, KEPs, KIPs etc. Doc systems: mdBook, Jekyll, GitHub-native, xml2rfc, Confluence (Fri)
- PROOF-COMPRESSION: syntactic ("proof golf") vs structural (lemma extraction). Structural = real math contribution. Mathlib (Lean) as reusable lemma library. Active research: Test-Time RL, auto-formalization (Sat)
- AVIGAD-PAPER: arXiv:2603.03684 — Math Inc. "Gauss" scooped Viazovska formalization. "Close to worthless" because truth not in doubt + no reusable library. "Drive-by proving" critique (Sat)
- HUMAN-AI-SYMBIOSIS: AI as distinct species with its own intelligence, human intelligence biologically locked. Haraway (cyborg, making kin), Hayles (posthuman, cognisphere, distributed cognition), Latour (ANT), Lovelock (Novacene, vertical succession). Haraway↔Hayles complementary pair. User plans to read both (Sat)
- SYSTEMS-LANG-SURVEY: bookmarked wiki.alopex.li/SurveyOfSystemLanguages2024. Ada, Zig (comptime, C interop), Rust tradeoffs. Future language learning reference (Sat)
- CUSTOM-NOTE-APP: Obsidian alternative as VS Code extension. Software sovereignty motivation (own core systems, immunity to enshittification). VS Code eliminates editor problem, provides file watching + Tree View + Webview APIs. Architecture: background AST parser → in-memory directed graph, Webview for visualization. Hardcoded workspace topology vs generic plugin system. Open: TypeScript vs LSP backend in performant language (Sun)
- SOFTWARE-SOVEREIGNTY: user values owning core daily-use systems over third-party dependency. Raw Markdown as future-proof format. Custom opinionated tools enforce exact personal workflow (Sun)
