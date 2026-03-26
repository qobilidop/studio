# Z3Wire: Concrete Type Safety + API Simplification

Project: Z3Wire (https://github.com/qobilidop/z3wire), branch: main

## Changes Made (5 commits)

### 1. Make Int constructor private + C++20 concepts (`f73ebd0`)
- Made `Int(uint64_t)` constructor private — forces `Literal<>()` or `checked()`
- Replaced two `checked()` overloads (uint64_t + enable_if int64_t) with single `template <std::integral T>`
- Added `build --cxxopt=-std=c++20` to `.bazelrc` (was defaulting to C++17)
- Replaced all raw constructor calls in `int_test.cc` (~20) and `bitvec_test.cc` (~15) with `Literal<>()`
- Deleted `compile_fail_tests/int_checked_int64_on_unsigned_test.cc` (no longer valid)
- Updated docs: `types.md`, `cheatsheet.md`

### 2. Add missing static_assert message (`0c64646`)
- `bitvec.h:110` `internal::extend` had `static_assert(TargetWidth >= SrcWidth)` without message
- Added descriptive message for consistency with all other static_asserts

### 3. Remove bitfield_eq, add exact_eq (`63e5cf3`)
- Removed entire `bitfield.h` module — `concat` + `==` covers same use case
- Removed `bitfield_test.cc`, compile-fail test, design doc, BUILD targets, mkdocs nav entry
- Added `exact_eq(a, b)` to both `bitvec.h` (returns Bool) and `int.h` (returns bool)
- `exact_eq` requires same width+signedness via template params (compile-time enforcement)
- Net -410 lines

### 4. Replace mixed overloads with concepts (`db5739a`)
- 25 mixed concrete+symbolic operator overloads → 13 concept-constrained templates
- Added `mixed_operands` concept: `(is_symbolic_v<L> && is_concrete_v<R>) || vice versa`
- Added `internal::promote()` and `internal::get_ctx()` helpers
- `ite` overloads kept as-is (3-way mix doesn't fit binary concept)
- Used `requires` clause syntax (not abbreviated concept in template params) for binary concepts

### 5. Add XOR for Bool (`23beaed`)
- `operator^` on Bool, implemented as `!=` (boolean inequality = XOR)
- Updated cheatsheet

## Key Decisions
- `static_assert` preferred over `requires` for "this is always wrong" constraints (custom messages, no SFINAE intent)
- `std::integral` concept for `checked()` — accepts any integer, handles truncation at runtime
- `UInt<8>::checked(-1)` → runtime truncation (not compile error) — `checked()` is the "tell me if it fits" API
- Kept `ite` mixed overloads separate from concept pattern (Bool condition + two value args)
- `.bazelrc` now sets C++20 globally

## Design Discussion
- Audited all static_assert vs concepts usage — everything follows best practice
- User asked about further API simplification → removed bitfield_eq, added exact_eq, consolidated mixed overloads
- `exact_eq` fills gap: `==` is relaxed (extends mismatched widths), `exact_eq` enforces same type at compile time
