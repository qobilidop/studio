# 2026-03-18 (Wed) — Z3Wire API gaps, docs refinement, SInt storage

Bili was sick in the morning, took a half day off. Back online ~2:43 PM.

## Session 01 — API gap analysis + Weave roadmap
- **Bit-vector API gap analysis**: compared z3wire against Z3 C++, Rust z3, Bitwuzla, cvc5, STP
- Roadmap: multiply (`*`) highest priority gap; division/remainder, rotate, repeat also added
- nand/nor/xnor and overflow detection low priority (composable/already handled)
- **Weave register array research**: concrete → `std::array`, symbolic → default-zero arrays, proto → `map<uint32, RegType>` for sparsity
- Committed roadmap updates: c07607d (arithmetic), 078e413 (proto map optimization)

## Session 02 — Docs cleanup, SInt storage, naming conventions
- Docs restructured: removed limitations.md, cheatsheet.md; merged getting-started into README
- **SInt storage**: changed from unsigned to signed storage, removed `.bits()`, `.value()` is sole accessor
- Removed `sign_extend()` / `sign_extend_value()` helpers
- **Naming conventions research**: snake_case for functions (SMT/hardware ecosystem standard), PascalCase for static factory methods
- Renamed `checked()` → `Checked()` across 12 files
- Documented all naming deviations in `docs/dev/guide.md`
- `docs/superpowers/` is gitignored scratch space for agent working docs
- 11 commits on main (d2bc67c through de31398)

## Session 03 — Usage docs refinement + examples
- Refined all three usage pages: types.md, type-conversions.md (new, was casting.md), operations.md
- Added overview tables to every usage page
- Created matching `examples/usage/` .cc files (types, type_conversions, operations)
- Unified terminology: "native value", "thin wrappers"
- Section order preference: Logical → Bitwise → Comparison → Arithmetic
- **Safety issues identified**: `SymBool(z3::expr)` no sort verification, `BitVec(uint64_t)` silent truncation — both added to roadmap
- 3 commits on main (d8f2038, 4cf8055, 10baf65)

## Key decisions
- Multiply is highest-priority missing bit-vector operation
- Proto register arrays use `map` for sparsity, concrete uses `std::array`
- SInt stores as signed; `.value()` is the only accessor
- snake_case functions, PascalCase factory methods — documented deviations from Google style
- Doc filenames: hyphens; C++ filenames: underscores
- `SymBool` equality belongs in Comparison (not Logical)

## Sessions

- **session-00**: Daily log — sick morning, back online afternoon
- **session-01**: Z3Wire API gap analysis (multiply = top priority), Weave register array representation research (concrete arrays, sparse proto maps)
- **session-02**: Docs cleanup (removed redundant pages, merged getting-started), SInt signed storage simplification, naming convention alignment (snake_case + PascalCase factories)
- **session-03**: Usage docs refinement — types, type-conversions (new page), operations; created example .cc files; identified `z3::expr` constructor safety issues
