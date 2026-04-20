# Session 01 — Z3Wire: ac_int comparison research

Repo: https://github.com/qobilidop/z3wire

## What happened

1. **Tagline update**: Changed "Compile-time safe bit-vectors for Z3" → "Compile-time type-safe bit-vectors for Z3" in `README.md` and `zensical.toml`. Committed and pushed.

2. **ac_int comparison research**: User learned about `ac_int<W,S>` from hlslibs/ac_types (Siemens/Mentor HLS library) and wanted to understand how it compares to Z3Wire's types.

3. **Operator semantic comparison**: Detailed analysis of where Z3Wire and ac_int agree (add/sub/mul width rules, comparison, right shift) and differ (left shift: ac_int truncates vs Z3Wire widens; bitwise NOT: ac_int grows vs Z3Wire preserves; bitwise ops: ac_int auto-promotes vs Z3Wire requires exact match).

4. **ac_int testing methodology**: Researched how ac_int tests correctness. Finding: the open-source repo ships zero tests for ac_int itself. ac_math companion has tests using exhaustive enumeration at small widths + structured sampling + `to_double()` as oracle. No other project tests against ac_int as oracle — cross-testing would be novel.

5. **Width parameterization for testing**: Since W is compile-time, explored patterns for testing across widths:
   - Pattern A: `TYPED_TEST` + `integral_constant` (simplest, fits Google Test) — likely fit
   - Pattern B: C++20 `for_range` with `integer_sequence` (compact, all widths in one test)
   - Pattern C: Cartesian product type list (Kokkos-FFT, most sophisticated)

## Decisions / outcomes

- Tagline shipped.
- ac_int cross-testing is an interesting idea but not implemented yet. User ran out of energy.
- Memory saved to `project_ac_int_comparison.md` for continuation.

## Key files touched

- `README.md` — tagline
- `zensical.toml` — tagline
