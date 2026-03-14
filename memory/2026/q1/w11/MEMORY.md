# 2026 W11 (Mar 9–15)

## What happened

- Reflected on agentic coding best practices (Boris Tane's Claude Code blog post)
- Explored personal website hosting: GitHub Pages vs custom domain, digital longevity concerns
- Built `sync-memory` skill — re-reads today+yesterday sessions, updates summaries up the chain
- Simplified `record-session` skill — now only writes session file (single responsibility)
- Z3Wire compile-fail tests (24 targets), scope narrowed to combinational logic primitives
- Z3Wire README rewrite with hardware verification framing, tooling overhaul (buildifier, mdformat, shfmt, shellcheck)
- Bazel 9 upgrade, removed mult/div/mod from roadmap (YAGNI)
- Deep dive into combinational logic: ITE as fundamental routing primitive
- C++ vs Python tradeoff for hardware verification tooling
- Recorded notable projects: HashMath, AutoCLRS, Bjarke Roune's AI chip design doc
- Implemented `bitfield_eq` in z3wire with full tests and docs
- mdformat-mkdocs fix, naming audit, project polish in z3wire
- Competitive analysis: Z3Wire unique in compile-time width checking (no other project does this)
- Implemented unary negate (bit-growth, always signed) and single-bit extraction
- Combinational logic primitives table added to design docs
- Major API cleanup: private Int constructor, C++20 concepts (`std::integral`, `mixed_operands`)
- Removed `bitfield_eq` entirely (-410 lines), replaced with `exact_eq`
- Consolidated 25 mixed operator overloads → 13 concept-constrained templates
- Added Bool XOR (`^` as `!=`)
- Brainstormed "P4PER" acronym for P4 technical proposals
- Bookmarked Terence Tao video on formalizing proofs in Lean with Claude Code
- Conceived P4kt project — Kotlin eDSL for P4-16 networking language
- Deep language comparison for eDSL hosting (Kotlin, C++, Rust, Scala 3, Zig, Nim)
- Explored MLIR integration options for Kotlin (FFM/jextract, JavaCPP, textual generation)
- Designed **wiregen** — Z3Wire code generation module
  - Protobuf txtpb meta-schema as single source of truth
  - Triad output: symbolic Z3Wire struct, concrete C++ struct, Protobuf message
  - Supports nested structs, fixed-size arrays, enums ("Smart Enum" pattern)
  - Surveyed hardware register formats (SystemRDL, IP-XACT, CMSIS-SVD, OpenTitan reggen)
- Type system exploration: OCaml GADTs, Rust const generics, Zig comptime, Idris/Agda dependent types

## Key decisions

- Skill separation: record-session = raw memory, sync-memory = summaries
- sync-memory is repo-local (not global) — tied to this repo's memory structure
- Personal website: leaning toward github.io for zero-cost permanence
- macOS: disabled auto-punctuation
- z3wire: keep snake_case (matches Z3 C++ API), LSB-first for bitfields
- z3wire: bit-growth for unary negate, no global Z3 context, no solver/context wrapping
- z3wire: reduction operators deferred (expressible via existing ops)
- z3wire: `static_assert` over `requires` for "always wrong" constraints
- z3wire: `std::integral` concept for `checked()`, runtime truncation for out-of-range
- z3wire: `exact_eq` for strict type matching vs relaxed `==`
- z3wire: C++20 enabled globally via `.bazelrc`
- z3wire wiregen: `tools/wiregen/` directory, Protobuf txtpb meta-schema approach
- z3wire wiregen: triad output (symbolic + concrete + protobuf), separate C++ enum from Protobuf enum
- z3wire wiregen: "Smart Enum" pattern — struct wrapping `z3wire::UInt<W>` with `is_valid()`
- P4kt: Kotlin chosen — best balance of DSL syntax, structural safety, and Google support
- P4kt: test strategy uses p4c testdata as ground truth oracle
- P4kt: start with "Level 1 curriculum" of simplest p4c test files
- Google language constraint: C++, Java, Python, Go, Dart, Kotlin, Rust

## Lessons

- Provide the right context to agents — they figure it out, often better than manual attempts
- Recognize when to take breaks from intense agentic coding — stepping away helps ideas solidify

## Open items

- P4 GSoC repo work this weekend
- P4PER acronym finalization
- P4kt Pi Day (3/14) kickoff
- wiregen implementation (architecture designed, not yet built)
- `SInt::signed_value()` accessor
