# Session 02 - Wide BitVec Implementation

**Repo:** github.com/qobilidop/z3wire
**Branch:** `wide-bit-vec` (6 commits on top of `main`)
**Duration:** Full design + implementation session

## What happened

Designed and implemented support for concrete `BitVec<W, false>` with W > 64 in Z3Wire. Motivated by Weave use case: generating paired concrete/symbolic structs for hardware registers wider than 64 bits (e.g., 120-bit, 128-bit registers).

## Design decisions

- **Unsigned only for W > 64.** Signed wide types rejected at compile time. Rationale: wide signed values only appear in DSP accumulators (niche); Weave register modeling is unsigned. YAGNI.
- **Storage:** `std::array<uint8_t, (W+7)/8>` little-endian (byte 0 = LSB). Chosen because it maps naturally to Z3's bit ordering.
- **ValueType split:** Native int for W <= 64 (unchanged), `std::array` for W > 64.
- **Unused high bits invariant:** Always zero, enforced at construction (same pattern as existing `truncate()`).
- **No concrete arithmetic for W > 64.** Only: construction, equality, value access, to/from symbolic.
- **Z3 bridge:** Pure C++ API (concat for to_symbolic, extract for to_concrete). Initially planned to use `Z3_mk_bv_numeral` / `Z3_get_numeral_binary_string` (C API), but `z3_api.h` can't be included standalone and include-cleaner flagged it. The concat/extract approach avoids the issue entirely.

## Key files changed

- `z3wire/bit_vec.h` - Core storage change, `make_value()`, split static_asserts, `Checked(array)` overload, constrained `operator==`
- `z3wire/bit_vec_test.cc` - Wide construction, literal, checked, equality tests
- `z3wire/sym_bit_vec.h` - Wide `to_symbolic` (concat bytes), wide `to_concrete` (extract bytes)
- `z3wire/sym_bit_vec_test.cc` - Wide conversion + round-trip tests
- `compile_fail_tests/` - Updated expected messages, `SInt<65>` now tested instead of `UInt<65>`
- `docs/usage/types.md` - Documented wide types

## Implementation details worth remembering

- `truncate()` guarded with `requires(W <= 64)` to avoid instantiation for wide types
- `make_value()` dispatches between wide (byte fill) and narrow (truncate) paths
- `to_symbolic` builds Z3 expr by starting with MSB byte (possibly < 8 bits), then concatenating remaining bytes MSB-to-LSB
- `to_concrete` extracts each byte via `evaluated.extract(hi, lo).simplify().get_numeral_uint()`
- Cognitive complexity lint threshold is 25; loop + EXPECT_EQ inside a test can exceed it

## Process notes

- Used subagent-driven development: dispatched sonnet subagents per task, reviewed between
- Plan was written with reviewer loop (caught 3 blocking issues: truncate W>=64 bug, compile-fail message mismatch, nonexistent Z3 C++ API overload)
- Lint fixes required switching from C API to C++ API approach for Z3 interop
- All 32 tests pass, lint clean, docs build

## Commits

```
be856c9 Fix lint issues and update docs for wide BitVec
49ae6ed Add symbolic-to-concrete conversion for wide BitVec
53f702c Add concrete-to-symbolic conversion for wide BitVec
36291ee Add equality for wide unsigned BitVec
4d23622 Add byte-array Checked construction for wide BitVec
3b36ae8 Support concrete unsigned BitVec with width > 64
```
