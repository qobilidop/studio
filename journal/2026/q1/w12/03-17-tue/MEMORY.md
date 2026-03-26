# 2026-03-17 (Tuesday)

## Z3Wire: API naming conventions established

- `to_` = conversion (changes representation): `to_symbolic`, `to_concrete`
- `as_` = reinterpretation (same bits): `as_unsigned`, `as_signed`, `as_bool`, `as_uint1`
- `_cast` = type conversion with safety tiers: `unsafe_cast`, `safe_cast`, `checked_cast`

## Z3Wire: Shift API redesign

- Named functions over operator overloading: `shl`, `shr` (removed `operator<<`, `operator>>`)
- `shl` is always lossless (auto-widening); compose with `unsafe_cast`/`checked_cast` for same-width
- `shr` is arithmetic; logical right shift composable via `shr(as_unsigned(val), as_unsigned(amt))`
- `shr<N>` constant shift added; `shr(val, amt)` relaxed to accept any-width unsigned amount
- Mixed concrete+symbolic overloads for both `shl` and `shr`
- Checked shifts removed (redundant — composable from primitives)
- Design doc: `docs/design/shift-redesign.md`

## Z3Wire: Cast API changes

- `checked_cast` polarity flip: `overflowed` -> `value_preserved` (positive polarity reads better)
- `as_signed(val)` / `as_unsigned(val)`: same-width reinterpretation with type deduction
- `cast` renamed to `unsafe_cast` (design doc: `docs/design/cast-rename.md`)

## Z3Wire: Renames

- `raw()` -> `expr()` (255 occurrences across 21 files)
- `to_bool`/`to_ubv1` -> `as_bool`/`as_ubv1` (unified `as_` prefix)
- `as_ubv1` -> `as_uint1` (mirrors `SymUInt<1>` type alias)

## Z3Wire: `to_concrete` for SymBitVec and SymBool

- Symmetric counterpart to `to_symbolic`
- Return type auto-derived, no explicit template parameter
- `get_numeral_uint64()` for unsigned, `get_numeral_int64()` for signed
- `static_assert(W <= 64)` since BitVec doesn't support wider

## Z3Wire: `exact_eq` removed

- Research across HDLs (Verilog, VHDL, Chisel, SpinalHDL, Amaranth, Clash), SMT solvers, libraries
- Conclusion: two equality functions is confusing, widening never produces wrong answers

## Z3Wire: Docs & examples

- README quick start: replaced carry-flag with midpoint overflow example (Joshua Bloch 2006 bug)
- Consolidated example docs into self-contained `.cc` programs (deleted 3 redundant `.md` pages)
- Doc site "Examples" nav links directly to GitHub (simplest after mkdocs include-markdown issues)
- New `packet_gen` example: 54-byte symbolic packet buffer, IPv4 + IPv6 constraints
- New `dev/guide.md`: consolidated development guide for humans and agents

## Z3Wire: Tooling

- mdformat: `.mdformat.toml` with `wrap = 80`
- clang-tidy: disabled modernize checks conflicting with Google C++ Style Guide
- clang-include-cleaner: added to `tools/lint.sh`
- CI: renamed "Checks" to "Lint"
- Removed stale `docs/dev/test-coverage.md`

## Z3Wire: CI fix

- Fixed Bazel permission errors in Docker after devcontainer CLI migration
- Removed stale `entrypoint.sh`, fixed lint target, fixed clang-format in types example

## Style preferences

- Explicit `z3w::` namespace qualification in examples (no ADL, no `using`)
- Explicit result types instead of `auto` in examples
- Strongly prefers simplest solution (direct GitHub link over include-markdown)
- Values API minimalism — actively removes features that don't justify themselves

## Daily log

- Left shift: logical vs arithmetic makes no difference (only matters for right shift)
