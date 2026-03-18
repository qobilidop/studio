# 2026-03-17 (Tuesday)

Deep Z3Wire API maturation day — shift redesign, cast improvements, naming conventions, docs consolidation, and new examples.

## Highlights

- Designed and implemented shift API redesign (named functions, composable primitives)
- Established `to_`/`as_`/`_cast` naming conventions
- Removed `exact_eq` after extensive cross-ecosystem research
- New midpoint overflow README example and packet_gen example
- Added `to_concrete` as symmetric counterpart to `to_symbolic`
- Consolidated example docs into self-contained .cc programs

## Sessions

- **session-00**: Daily log — left shift vs arithmetic shift (no difference), misc thoughts
- **session-01**: Z3Wire — symbolic types doc refinement, `cast` -> `unsafe_cast` rename, CI fix after devcontainer migration
- **session-02**: Z3Wire — shift API redesign (shl/shr named functions, removed operators), cast improvements (checked_cast polarity, as_signed/as_unsigned), `raw()` -> `expr()` rename
- **session-03**: Z3Wire — midpoint overflow README example, shr API improvements (shr<N>, relaxed amount type, mixed overloads), tooling (mdformat, clang-tidy, clang-include-cleaner), dev/guide.md
- **session-04**: Z3Wire — docs consolidation (examples as .cc programs), packet_gen example, `to_concrete`, API naming cleanup (as_ubv1->as_uint1), removed `exact_eq`
