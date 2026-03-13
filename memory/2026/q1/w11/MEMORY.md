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

## Lessons

- Provide the right context to agents — they figure it out, often better than manual attempts

## Open items

- P4 GSoC repo work this weekend
- P4PER acronym finalization
- `SInt::signed_value()` accessor
