# 2026-03-12 (Thu)

## Sessions

### session-00: Daily log (Gemini)
- Woke up well-rested at 8:12 AM — finally recovered from recent tiredness
- Watched/bookmarked Terence Tao video on formalizing proofs in Lean using Claude Code (https://youtu.be/JHEO7cplfk8)
- Learned about OpenType and OpenType Math font formats
- Brainstormed "P4PER" acronym for P4 technical proposals — top candidates: P4 Proposed Enhancement Request, P4 Protocol Extension Request
- Needs to spend time on P4 GSoC repo this weekend (has made promises)
- Preference: timestamps in responses, no accumulated log
- **P4kt project conceived** — Kotlin eDSL for P4-16 networking language
  - Generates .p4 files from type-safe Kotlin builders (receiver lambdas, @DslMarker)
  - Test strategy: generate P4 from P4kt, swap into p4c testdata, verify tests pass
  - Bit-width validation at elaboration time (runtime), structural safety at compile time
  - Kotlin chosen over Python (no structural safety), C++ (ugly DSL syntax), Rust (macro complexity)
  - Scala 3 would be ideal (structural + bit-width safety) but not supported at Google
  - Zig, Nim also considered for compile-time bit-width tracking
  - System prompt drafted for Pi Day (3/14) agent coding session
- MLIR integration explored — no official Kotlin bindings; options: FFM API via jextract, JavaCPP presets, or textual MLIR generation via buildString
- Google language constraint: C++, Java, Python, Go, Dart, Kotlin, Rust

### session-01: Z3Wire concrete type safety + API simplification (Claude)
- Project: Z3Wire (https://github.com/qobilidop/z3wire), branch: main
- Made `Int(uint64_t)` constructor private — forces `Literal<>()` or `checked()`
- Replaced overloads with C++20 `std::integral` concept for `checked()`
- Removed `bitfield_eq` entirely — `concat` + `==` covers same use case (-410 lines net)
- Added `exact_eq(a, b)` — compile-time same-width+signedness enforcement
- Replaced 25 mixed operator overloads → 13 concept-constrained templates using `mixed_operands` concept
- Added `operator^` (XOR) for Bool (implemented as `!=`)
- Enabled C++20 globally via `.bazelrc`

## Key decisions
- `static_assert` preferred over `requires` for "always wrong" constraints (custom messages, no SFINAE intent)
- `std::integral` concept for `checked()` — accepts any integer, handles truncation at runtime
- `exact_eq` fills gap between relaxed `==` (extends widths) and strict type matching
- Kotlin chosen for P4kt — best balance of DSL syntax, structural safety, and Google support
- P4kt test strategy: use p4c testdata as ground truth oracle
- Start with "Level 1 curriculum" — simplest p4c test files to bootstrap AST nodes

## Open items
- P4 GSoC repo work this weekend
- P4PER acronym finalization
- P4kt Pi Day (3/14) kickoff — Kotlin eDSL for P4-16
- MLIR integration path for P4kt (deferred)

## Sessions

- **session-00** (Gemini): Daily log — recovered from tiredness, OpenType learning, P4PER brainstorm, P4kt project conception (Kotlin eDSL for P4-16, language comparison, test strategy via p4c testdata, system prompt drafted for Pi Day), MLIR exploration
- **session-01** (Claude): Z3Wire — concrete type safety (private constructor, C++20 concepts), API simplification (removed bitfield_eq, added exact_eq, consolidated mixed overloads with concepts, Bool XOR)
