# 2026-03-12 (Thu)

## Sessions

### session-00: Daily log (Gemini)
- Woke up well-rested at 8:12 AM — finally recovered from recent tiredness
- Watched/bookmarked Terence Tao video on formalizing proofs in Lean using Claude Code (https://youtu.be/JHEO7cplfk8)
- Learned about OpenType and OpenType Math font formats
- Brainstormed "P4PER" acronym for P4 technical proposals — top candidates: P4 Proposed Enhancement Request, P4 Protocol Extension Request
- Needs to spend time on P4 GSoC repo this weekend (has made promises)
- Preference: timestamps in responses, no accumulated log

### session-01: Z3Wire concrete type safety + API simplification (Claude)
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
- `UInt<8>::checked(-1)` → runtime truncation (not compile error)
- Kept `ite` mixed overloads separate from concept pattern
- `exact_eq` fills gap between relaxed `==` (extends widths) and strict type matching

## Open items
- P4 GSoC repo work this weekend
- P4PER acronym finalization
