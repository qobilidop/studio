# 2026-03-19 (Thu) — Z3Wire API hardening, wide BitVec, fuzz testing, rotations

## Session 00 — Daily log (Gemini)
- Z3 Python API: expressions without explicit context use global `main_ctx`, fully functional; mixing explicit/default contexts throws `Z3Exception`
- Bookmarked: https://leodemoura.github.io/blog/2026-3-16-who-watches-the-provers/ — Leo de Moura on formal verification trust, monolith problem in Z3/Rocq, Lean's separation of proof discovery vs verification, multiple independent kernels

## Session 01 — Z3Wire API review and cleanup
- **Z3W_CHECK macro**: `z3wire/check.h`, Abseil CHECK-compatible streaming API, guards uninitialized symbolic access
- **z3::expr constructor safety**: sort/width validation via Z3W_CHECK, `FromExpr` returning `std::optional` as safe public API
- **Bool implicit conversion**: `template <typename T> Bool(T) = delete` catch-all (rejects floats, pointers, nullptr)
- **Concrete type cleanup**: `Storage` → `ValueType`, `bits_` → `value_`, `mask()` → `truncate()`, `std::cmp_equal` for cross-type equality
- **type_traits.h**: `is_concrete<T>`, `is_symbolic<T>`, forward declarations + specializations in single file
- Removed redundant `operator!=` (C++20 synthesizes), simplified template aliases
- 7 squashed commits, docs + examples updated

## Session 02 — Wide BitVec (W > 64)
- Branch: `wide-bit-vec` (6 commits)
- Unsigned only for W > 64 (signed rejected at compile time — YAGNI)
- Storage: `std::array<uint8_t, (W+7)/8>` little-endian
- No concrete arithmetic for wide types; only construction, equality, value access, to/from symbolic
- Z3 bridge: pure C++ API (concat for to_symbolic, extract for to_concrete) — avoided C API due to include issues
- Used subagent-driven development with reviewer loop

## Session 03 — Wide signed BitVec + fuzz testing
- Merged wide-bit-vec to main, enabled SInt for W > 64
- Simplified concrete equality: single same-type `operator==`, removed `std::cmp_equal`
- **Google FuzzTest setup**: `fuzztest` dep in MODULE.bazel, pinned Bazel to 8.2.1 (flatbuffers/Bazel 9 conflict)
- Two fuzz tests: bit_vec_roundtrip (concrete→sym→concrete), bit_vec_checked (Checked round-trip)
- 24 width/signedness combinations per fuzz test (W=1,7,8,15,16,31,32,63,64,65,100,128 × UInt/SInt)
- **Bug found by fuzzer**: `to_concrete` for SInt<64> — `get_numeral_int64()` throws when MSB set; fixed to use `get_numeral_uint64()`
- Squashed to 3 commits: e454e6e, cea347d, 0cf39f7

## Session 04 — Extract fix + rotation ops
- **Extract fix (79d50f6)**: symbolic-offset extract with IdxW > W caused unsigned underflow; fix: `ShiftW = max(W, IdxW)`, extend narrower operand
- Zero-extension semantics documented (ab7e709)
- Fuzz test for symbolic-offset extract (3b8f3bd): covers IdxW < W, == W, > W
- **Rotation ops (2bd47ea)**: rotl/rotr with 6 overloads (constant/symbolic/concrete), Z3 C API `Z3_mk_ext_rotate_left/right` for variable rotation
- Fuzz test for rotation roundtrip (4b95149): rotr(rotl(val, amt), amt) == val
- 35/35 tests pass, lint clean

## Key decisions
- Z3W_CHECK macro for internal assertions (Abseil-compatible API)
- FromExpr (std::optional) as safe public API for z3::expr construction
- Wide BitVec: unsigned-first, byte-array storage, C++ API only for Z3 bridge
- Same-type only concrete equality (cross-type at symbolic level via extension)
- Bazel 8.2.1 pinned due to fuzztest/flatbuffers/Bazel 9 conflict
- Extract semantics: zero-extension (not circular buffer)
- Rotation preserves signedness (unlike extract → always SymUInt)
