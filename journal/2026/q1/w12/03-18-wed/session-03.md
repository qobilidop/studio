# Session 03 — Z3Wire usage docs refinement

Repo: https://github.com/qobilidop/z3wire

## What happened

Comprehensive refinement of all three usage doc pages and creation of matching example files. Three commits pushed to main.

### Commit 1: `d8f2038` — Refine usage/types.md and split out casting page

- Added overview table showing symbolic/concrete type pairs at a glance
- Split casting content into new `usage/casting.md` (later renamed)
- Organized symbolic and concrete sections with parallel structure (Construction, Value access / Z3 interop)
- Unified terminology: "native value" (not "plain value"), "thin wrappers" (not "zero-overhead" — actually uses `std::optional<z3::expr>`)
- Removed redundant type tables, `BitVec` template details, design principle section (already in design/overview.md)
- Unified `static_assert` messages for Literal range errors to "Literal value does not fit in bit-width." across `sym_bit_vec.h`, `bit_vec.h`, and compile-fail tests
- Moved `examples/types.cc` → `examples/usage/types.cc`, synced with docs
- Added `z3::expr` constructor safety concern to roadmap

### Commit 2: `4cf8055` — Refine casting page into type-conversions.md

- Renamed page to "Type Conversions" covering all conversion APIs (not just casting)
- Added overview table with 7 conversion mechanisms and From→To column
- Added missing conversions: `as_unsigned`/`as_signed`, `to_concrete`, expanded `to_symbolic`
- Reordered: casting → signedness → sort conversion → concrete/symbolic (core first, boundary last)
- Simplified sort conversion example (removed `extract` distraction)
- Renamed file `casting.md` → `type-conversions.md` (hyphen convention for docs)
- Created `examples/usage/type_conversions.cc`

### Commit 3: `10baf65` — Refine usage/operations.md and add example

- Added overview table with categories, operations, and operand rules
- Reordered: Logical → Bitwise → Comparison → Arithmetic → Shifting → Bit manipulation → Mux
- Added missing SymBool XOR (`^`) and moved SymBool `==`/`!=` to Comparison section
- Consistent section intros: "[Category] operations on [type]. [Key rule]."
- Removed em dashes, Z3 internals (bvult/bvslt), CIRCT reference
- Fixed Mux example: replaced `UInt<8>(42)` (raw constructor) with `UInt<8>::Literal<42>()`
- Added `BitVec(uint64_t)` constructor safety concern to roadmap
- Created `examples/usage/operations.cc`

## Key decisions

- Doc filenames use hyphens (`type-conversions.md`); C++ filenames use underscores (`type_conversions.cc`)
- Overview tables on every usage page for quick reference
- "All examples assume `z3::context ctx` is in scope" note on pages that don't show ctx declaration
- Section order in operations: user preference for Logical → Bitwise → Comparison → Arithmetic (simple to complex, logical/bitwise paired)
- `SymBool` equality belongs in Comparison, not Logical (consistent with C++/industry convention)
- Example `.cc` files suppress `-Wno-unused-variable` and `-Wno-unused-result` via `copts` to keep code clean

## Safety issues identified

1. `SymBool(z3::expr)` / `SymBitVec(z3::expr)` — no sort/width verification, silent corruption
2. `BitVec(uint64_t)` — explicit but silently truncates, bypasses Literal/Checked safety

Both added to `docs/dev/roadmap.md` under Safety section and tracked in project memory.

## Files touched

- `docs/usage/types.md` — restructured
- `docs/usage/type-conversions.md` — new (was `casting.md`)
- `docs/usage/operations.md` — restructured
- `docs/dev/roadmap.md` — Safety section added
- `mkdocs.yml` — nav updated
- `z3wire/sym_bit_vec.h` — static_assert message
- `z3wire/bit_vec.h` — static_assert message
- `compile_fail_tests/BUILD.bazel` — expected messages updated
- `examples/usage/types.cc` — new (moved from examples/)
- `examples/usage/type_conversions.cc` — new
- `examples/usage/operations.cc` — new
- `examples/usage/BUILD.bazel` — new
- `examples/BUILD.bazel` — removed old types target
