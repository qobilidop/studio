# 2026 W11 (Mar 9–15)

Settling into routines after the intense birth week. Mix of reflection, reading, productive z3wire development, P4kt conception and launch, and wiregen architecture design.

## Highlights

- Read Boris Tane's Claude Code blog post - validated plan-first workflow
- Explored personal website hosting with digital longevity as a priority
- Built `sync-memory` skill and simplified `record-session` - clean separation of concerns
- Deep dive into hardware design philosophy: combinational logic, C++ vs Python, ITE routing
- Implemented `bitfield_eq` feature in z3wire (16 commits of docs reorg and project polish)
- Major Z3Wire API cleanup: C++20 concepts, removed bitfield_eq (-410 lines), added exact_eq, consolidated mixed overloads
- Conceived P4kt - Kotlin eDSL for P4-16, with deep language comparison and p4c test strategy
- Designed **wiregen** - Z3Wire code generation module using Protobuf txtpb meta-schema, triad output architecture
- Explored type system boundaries: OCaml, Rust, Zig, Idris/Agda
- **Pi Day: launched P4kt from scratch to full VSS coverage in one day** (6 sessions, native Kotlin classes for IDE autocomplete, subagent-driven development)
- **Sunday: P4kt core.p4 100% complete**, added Gradle build, architecture-as-library pattern, `#include` support

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

## Saturday (Pi Day) - P4kt launch

- Launched P4kt (github.com/qobilidop/p4kt) on Pi Day - from empty repo to full VSS coverage in one day
- 6 sessions: project setup, design, implementation, tooling, docs, complete VSS
- Architecture: DSL builders (mutable) -> IR (immutable) -> Renderer (P4 text)
- Key design: P4 structs as native Kotlin classes for IDE autocomplete (not builder pattern)
- Constructor references (`::ClassName`) over reflection - local classes with captures break reflection
- `provideDelegate` for eager delegation (came up 3 times across different features)
- Tooling: Bazel+Bzlmod, devcontainer (Colima), ktfmt, dprint, detekt, CI, MkDocs Material docs site
- Golden tests: examples/ with .kt + .p4 pairs as both regression tests and user docs
- Subagent-driven development for VSS completion (18 tasks, 6 dispatches)
- Lesson: subagents bypass parent's Stop hook - added pre-commit hook as structural guarantee
- Discussed Habermas's philosophy mapped to open source communities
- VibeTensor paper (arxiv:2601.16238) validates agentic coding + testing harness approach

## Sunday - P4kt continued: architecture-as-library, Gradle, core.p4 completion

- Dual build: added Gradle 8.13 alongside Bazel, both pass
- `P4.Library` base class for reusable architecture definitions (vss_arch -> P4.Library object)
- `P4` object as single DSL entry point (factories, constants, base classes)
- File reorg by audience: P4.kt (user API), Builders.kt (internals), Emit.kt (rendering)
- `p4kt.p4include` package: Core and V1model objects mirroring p4c's p4include/
- **core.p4 100% complete** — every construct from upstream p4c implemented
- Type parameters (`P4Type.Var`, `typeParam()` delegate), delegate-based naming throughout
- `@P4DslMarker` added to all builder classes
- `P4TypeDecl` IR for abstract parser/control/package type declarations
- `P4Include` IR for `#include` directives, hex literals (`P4.hex()`), `SignedLit`
- `v1model_basic.kt` example from p4lang/tutorials + ergonomics assessment in docs
- Renamed `vss_arch` -> `vss` for consistency
- Kotlin learning: sealed classes, delegation (for P4kt work)
- Read Leo de Moura ETAPS interview, bookmarked 谢赛宁 7-hour marathon interview
- Completed all Teyvat quests (Genshin Impact)

## Open items

- P4 GSoC repo work
- P4PER acronym finalization
- P4kt: extern-level type params, enum IR, v1model.p4 completion
- P4kt: future examples blocked by header stacks, registers, hash, multi-field select
- wiregen implementation (architecture designed, not yet built)
- `SInt::signed_value()` accessor
