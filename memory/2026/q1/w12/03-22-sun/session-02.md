# Session: Z3Wire Operations Doc Overhaul + Implementation Fixes

**Repo:** github.com/qobilidop/z3wire
**Branch:** main
**Commits:** c9c0e46, a048155, 597df55, d18e92b, a96e814

## What happened

Major overhaul of `docs/usage/operations.md` — added per-operation typing rule tables to every section, then synced implementation and examples to match.

### Doc improvements
- Added typing rule tables to all 8 operation categories (Logical, Bitwise, Comparison, Arithmetic, Shifting, Rotation, Bit manipulation, Conditional selection)
- Adopted consistent structure: section intro → typing rules table → "Examples:" → code block
- Renamed "Mux" → "Conditional selection", "Unary negate" → "Arithmetic negation", "Ordered comparison" subsection kept as-is (considered "Relational" but stayed)
- Split Comparison into "Boolean comparison" and "Integer comparison" subsections
- Used `A`, `B` for different-width params, `W` for same-width params
- Arithmetic tables show "Syntax:" line above the table, separate from typing rules
- Discussed arity-based categorization (unary/binary/ternary × domain) — rejected as adding navigation layer without clarity
- Discussed shorthand notation for types — rejected in favor of full type names for self-contained sections

### Implementation changes
1. **Fixed arithmetic typing (CIRCT hwarith rules):** Added `arith_result_width()` in `sym_bit_vec.h` for mixed-signedness cases. `ui<A> op si<B>` → width `A+2` if `A>=B`, else `B+1`. Old rule `max(W1,W2)+1` was too narrow — verified with concrete example: `SymSInt<4> - SymUInt<6>` needs range -71..7, doesn't fit in `SymSInt<7>`.
2. **Removed `bit<N>()`:** Was just `extract<N,N>()`. Removed from header, test, design overview. Will not add `set_bit` either — `replace` covers it.
3. **Added `replace` operation:** Inverse of `extract`. Static (`replace<LO>(src, field)`) and symbolic-offset (`replace(src, field, lo)`) variants. Result preserves source signedness. Field is always `SymUInt`.
4. **Added `SymBool` support to `concat`:** Used `internal::sym_width` trait + `internal::to_bv_expr` overloads. Concept-constrained templates replace old `SymBitVec`-only templates.
5. **Added `SymBool` support to `ite`:** Simple inline overload.

### Key design discussions
- Bitwise ops: support on both signed/unsigned (matches Chisel, VHDL, Yosys). Result preserves signedness. Cross-signedness forbidden.
- `bit` function: agreed to remove now, not add `set_bit`. Core bit manipulation = extract, replace, concat.
- `replace` semantics: "Low bit offset" naming. Out-of-range replacement bits have no effect (parallels extract's zero-extension).
- `implies` operator: deferred to roadmap (just `!a || b`).
- NAND/NOR/XNOR: YAGNI, trivially composed.

### Subtraction "Same type as `b - a`" issue
Noted that this phrasing is semantically wrong (subtraction isn't commutative), but it means "same typing rule with swapped operand types." User will verify the mixed-signedness formulas independently.

## Files changed
- `docs/usage/operations.md` — major rewrite
- `docs/design/overview.md` — feature table updates
- `z3wire/sym_bit_vec.h` — arith_result_width, remove bit, add replace, SymBool concat/ite
- `z3wire/sym_bit_vec_test.cc` — updated/added tests
- `examples/usage/operations.cc` — full rewrite to match doc
- `examples/usage/BUILD.bazel` — removed bit_vec dep

## Memory updates
- Updated `project_sub_typing_bug.md` → now records the fix, not the bug
- Updated `MEMORY.md` index accordingly
