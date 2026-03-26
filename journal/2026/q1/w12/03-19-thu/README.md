# 2026-03-19 (Thursday)

Heavy Z3Wire implementation day: hardened API with Z3W_CHECK and FromExpr, implemented wide BitVec (W > 64) for both unsigned and signed, integrated Google FuzzTest (which found a real bug), and added rotation operations.

## Sessions

- **session-00**: Daily log — Z3 Python API default context behavior, bookmarked Leo de Moura's "Who Watches the Provers?" post on formal verification trust and independent kernel verification
- **session-01**: Z3Wire API review and cleanup — Z3W_CHECK macro, z3::expr constructor sort validation + FromExpr API, Bool catch-all delete, concrete type renaming (Storage to ValueType), type_traits.h extraction
- **session-02**: Wide BitVec (W > 64) implementation — byte-array storage, unsigned-only initially, concat/extract Z3 bridge (pure C++ API), subagent-driven development
- **session-03**: Wide signed BitVec enabled, Google FuzzTest setup (Bazel pinned to 8.2.1), fuzz-found SInt<64> to_concrete bug fixed, 24 width/signedness test combinations
- **session-04**: Fixed symbolic-offset extract for wide indices (ShiftW = max(W, IdxW)), added rotl/rotr with 6 overloads, fuzz tests for both

## Agent index

- DECISION: Z3W_CHECK macro — Abseil CHECK-compatible streaming API, `//z3wire:__subpackages__` visibility (internal only) (session-01)
- DECISION: z3::expr constructor kept public with Z3W_CHECK validation; `FromExpr` returning `std::optional` as safe public API; private ctor rejected (~27 friends for SymBitVec) (session-01)
- DECISION: Bool catch-all `template <typename T> Bool(T) = delete` replaces integral-only delete — rejects floats, pointers, nullptr (session-01)
- DECISION: type_traits.h — single file with forward declarations + all specializations; `is_concrete<T>`, `is_symbolic<T>` (session-01)
- DECISION: wide BitVec storage `std::array<uint8_t, (W+7)/8>` little-endian; unsigned-first then signed enabled; no concrete arithmetic for W > 64 (session-02, session-03)
- DECISION: Bazel pinned 8.2.1 — flatbuffers transitive dep issue with Bazel 9 (google/flatbuffers#8901) (session-03)
- BUG-FIXED: `to_concrete` for SInt<64> — `get_numeral_int64()` throws when MSB set; fixed to always use `get_numeral_uint64()` (session-03)
- BUG-FIXED: symbolic-offset extract with IdxW > W — unsigned underflow in zext; fix: extend narrower operand to `max(W, IdxW)` (session-04)
- DECISION: extract semantics — zero-extension (not circular buffer), matches hardware conventions (session-04)
- DECISION: rotation preserves signedness (unlike extract which always returns SymUInt); Z3 C API for variable rotation (session-04)
- REF: Leo de Moura post — Lean kernel arena, multiple independent kernels for verification trust (session-00)
