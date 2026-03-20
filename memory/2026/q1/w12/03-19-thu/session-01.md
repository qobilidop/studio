# Z3Wire API Review and Cleanup

Repo: github.com/qobilidop/z3wire

## Context

Long session reviewing whether C++ API surface is complete, well-designed, and minimal. Started from a doc coverage audit, evolved into deep API design discussions and implementation.

## Three Main Questions Discussed and Resolved

### 1. Default constructor creating uninitialized values
- **Decision**: Keep default constructors (needed by Weave codegen structs), but guard `expr()` with `Z3W_CHECK` that aborts with a clear message.
- Explored alternatives: lazy sentinel with global context (rejected — Z3 contexts can't mix), `std::optional` wrapper (rejected — Weave needs bare fields).
- Created `z3wire/check.h` with `Z3W_CHECK` macro — Abseil `CHECK`-compatible streaming API (`Z3W_CHECK(cond) << "message"`), uses `CheckFailMessage` + `CheckVoidify` pattern for ternary void compatibility.
- `check` target is `//z3wire:__subpackages__` visibility (internal only).

### 2. Raw z3::expr constructor safety
- **Decision**: Keep public constructor with `Z3W_CHECK` sort/width validation. Add `FromExpr` returning `std::optional` as the recommended safe public API.
- SymBool checks `expr.is_bool()`, SymBitVec checks `expr.get_sort().is_bv() && bv_size() == W`.
- Discussed making constructor private + friend list (~27 friends for SymBitVec) — rejected as too much maintenance.
- Discussed removing constructor entirely and using only FromExpr — rejected because internal operators would need `.value()` unwraps everywhere for checks that never fail.

### 3. Bool implicit conversion rules
- **Decision**: Replace `template <std::integral T> Bool(T) = delete` with catch-all `template <typename T> Bool(T) = delete`. Now rejects floats, pointers, nullptr — not just integers.
- Added compile-fail tests: `bool_from_float_test`, `bool_from_pointer_test`, `bool_from_nullptr_test`.
- Removed redundant `operator!=` and mixed `operator==(Bool, bool)` overloads — C++20 synthesizes these.

## Additional Cleanup

### Concrete type API surface
- Removed `Bool::operator<<`, then added it back (Weave debug output readability). Used ternary `? "true" : "false"` instead of `std::boolalpha` (avoids stream state side effects).
- Renamed `Storage` → `ValueType`, `bits_` → `value_`, `mask()` → `truncate()`.
- Replaced `internal::extend` + manual equality with `std::cmp_equal` for BitVec cross-type equality (handles mixed-signedness correctly at width 32+).
- Removed redundant `BitVec::operator!=` (C++20 synthesizes from template `operator==` too).
- Simplified private `UnsignedValueType`/`SignedValueType` template aliases to plain aliases `Unsigned`/`Signed` (only ever instantiated with class's own `W`).
- Consistent `W` template parameter (SymBitVec had `Width`, now `W`).

### type_traits.h extraction
- Explored 4 patterns: detection/markers, forward-declare-all (Eigen), std::hash-style (scattered specializations), centralized.
- **Final decision**: Single `type_traits.h` with forward declarations + all specializations. Forward declarations inline (no separate `forward_declarations.h`). Comment explains circular include constraint (sym_bit_vec.h uses traits internally for `mixed_operands`).
- `is_concrete<T>` matches Bool, BitVec (and aliases UInt, SInt). `is_symbolic<T>` matches SymBool, SymBitVec (and aliases SymUInt, SymSInt).

### Docs
- Updated types.md: Bool constructor comment, FromExpr in Z3 interop section, type traits section.
- Updated examples/usage/types.cc: FromExpr demo, type traits demo, fixed stale comments.
- All three usage docs verified in sync with code.

## Commits (final squashed history)
1. Add Z3W_CHECK macro and guard uninitialized symbolic access
2. Add sort validation to z3::expr constructors and FromExpr API
3. Tighten Bool constructor to reject all non-bool types
4. Clean up concrete type API surface
5. Improve naming and comments in concrete types
6. Extract type_traits.h with is_concrete and is_symbolic
7. Document type traits in usage docs

## Key Files Changed
- New: `z3wire/check.h`, `z3wire/check_test.cc`, `z3wire/type_traits.h`
- Modified: `z3wire/bool.h`, `z3wire/bit_vec.h`, `z3wire/sym_bool.h`, `z3wire/sym_bit_vec.h`, all test files, `z3wire/BUILD.bazel`, `docs/usage/types.md`, `examples/usage/types.cc`

## User Preferences Observed
- Likes to discuss design thoroughly before implementing
- Prefers auto-commit and auto-push
- Values consistency in naming, comments, and code style
- Wants honest assessments including downsides of proposed approaches
- Prefers squashing back-and-forth commits into clean logical units
- Cares about readability for library users (comments explaining aliases, etc.)
