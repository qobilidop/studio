# Session: z3wire extract fix + rotation ops

- Repo: github.com/qobilidop/z3wire
- Branch: main
- Tool: Claude Code (Opus 4.6)

## Work done

### 1. Fixed symbolic-offset extract for wide indices (79d50f6)
- Bug: `extract<TW>(val, idx)` when `IdxW > W` caused unsigned underflow in `z3::zext(start_idx.expr(), W - IdxW)`, producing a multi-billion-bit bitvector
- Discussed semantics: zero-extension (out-of-range offsets yield zeros), not circular buffer
- Discussed truncation approach — user caught that truncating the index loses information for solver (solver could find large offsets that map to small ones after truncation)
- Fix: compute `ShiftW = max(W, IdxW)`, extend whichever operand is narrower
- Test: `SymbolicExtractWideIndex` — in-range offset, out-of-range yields zero, solver can't find out-of-range offset producing non-zero

### 2. Documented zero-extension semantics (ab7e709)
- Added note to `docs/usage/operations.md` in symbolic-offset extract section

### 3. Added fuzz test for symbolic-offset extract (3b8f3bd)
- `fuzz_tests/sym_bit_vec_extract_test.cc`
- Property: symbolic extract on concrete values matches `(val >> offset) & mask`
- Covers IdxW < W, IdxW == W, IdxW > W, full-width extract, signed sources
- User pointed out: C++ `>>` on signed is implementation-defined, so reference uses unsigned only

### 4. Added rotation operations rotl/rotr (2bd47ea)
- `z3wire/sym_bit_vec.h`: 6 overloads (constant/symbolic/concrete x rotl/rotr)
- Z3 C++ API only has constant rotation (`expr::rotate_left/right`); used C API `Z3_mk_ext_rotate_left/right` for variable rotation
- Result preserves input type `SymBitVec<W, S>`, amounts wrap modulo W
- Docs added to `docs/usage/operations.md`

### 5. Added fuzz test for rotation roundtrip (4b95149)
- `fuzz_tests/sym_bit_vec_rotate_test.cc`
- Property: `rotr(rotl(val, amt), amt) == val`
- Covers K < W, K == W, K > W

## Key decisions
- Extract semantics: zero-extension, not circular buffer — matches hardware conventions
- When IdxW > W: extend source to match index width, not truncate index
- Rotation API mirrors shift API pattern (constant/symbolic/concrete overloads)
- Rotation preserves signedness (unlike extract which always returns SymUInt)

## Final state
- 35/35 tests pass, lint clean, docs build
