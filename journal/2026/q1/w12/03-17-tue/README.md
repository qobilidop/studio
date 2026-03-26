# 2026-03-17 (Tuesday)

Z3Wire API maturation day: redesigned shift API with composable primitives, established naming conventions (`to_`/`as_`/`_cast`), added `to_concrete`, removed `exact_eq`, and overhauled docs with real-world examples. Claude API 500 outage hit mid-session.

## Sessions

- **session-00**: Daily log — logical vs arithmetic left shift (no difference), Verilog `<<<` for sign-extension context, Claude API 500 outage, multi-agent resilience (Claude+Codex+Gemini), Z3 signed truncation discussion
- **session-01**: Z3Wire — refined symbolic types doc/example, `cast` to `unsafe_cast` rename, CI fix after devcontainer migration (recovered from lost session)
- **session-02**: Shift API redesign (shl/shr named functions, removed operators, composable primitives), cast improvements (checked_cast polarity flip, as_signed/as_unsigned), `raw()` to `expr()` rename (255 occurrences)
- **session-03**: Midpoint overflow README example, shr API improvements (shr<N>, relaxed amount type, mixed overloads), tooling (mdformat, clang-tidy tuning, clang-include-cleaner), dev/guide.md
- **session-04**: Docs consolidation (examples as self-contained .cc programs), packet_gen example, `to_concrete` for SymBitVec/SymBool, API naming cleanup (as_ubv1 to as_uint1), removed `exact_eq`

## Agent index

- DECISION: naming convention — `to_` = conversion (changes representation), `as_` = reinterpretation (same bits), `_cast` = type conversion with safety tiers (session-02, session-04)
- DECISION: shift API — named functions only (`shl`/`shr`), removed operators; `shl` always lossless (auto-widening); `shr` is arithmetic; checked shifts redundant (composable) (session-02)
- DECISION: `checked_cast` polarity flip — `value_preserved` (positive) over `overflowed` (negative) (session-02)
- DECISION: removed `exact_eq` — cross-ecosystem research showed two equality functions is confusing, widening never wrong (session-04)
- DECISION: examples as self-contained .cc programs, doc site links directly to GitHub (simplest after mkdocs issues) (session-04)
- DECISION: `to_concrete` uses `get_numeral_uint64()` for unsigned, `get_numeral_int64()` for signed; `static_assert(W <= 64)` (session-04)
- LESSON: Claude API 500 outage — should not rely on single agent provider; plan: Claude+Codex+Gemini (session-00)
- PREF: explicit `z3w::` qualification in examples (no ADL); explicit result types over `auto`; API minimalism — actively removes unjustified features (session-03, session-04)
