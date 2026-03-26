# 2026-03-19 (Thursday)

Full day of Z3Wire development — API hardening, wide type support, fuzz testing infrastructure, and new operations.

## Highlights

- Z3W_CHECK macro and FromExpr safe API for z3::expr construction
- Wide BitVec (W > 64) fully implemented for both unsigned and signed
- Google FuzzTest integrated, found and fixed a real bug (SInt<64> to_concrete)
- Symbolic-offset extract fixed for wide indices
- Rotation operations (rotl/rotr) added with full overload set

## Sessions

- **session-00**: Daily log — Z3 Python API context discussion, bookmarked Leo de Moura's "Who Watches the Provers?" post on formal verification trust
- **session-01**: Z3Wire API review and cleanup — Z3W_CHECK macro, z3::expr constructor sort validation, FromExpr API, Bool catch-all delete, concrete type renaming, type_traits.h extraction
- **session-02**: Wide BitVec implementation (W > 64) — byte-array storage, unsigned-only, concat/extract Z3 bridge, subagent-driven development
- **session-03**: Wide signed BitVec + fuzz testing — enabled SInt for W > 64, Google FuzzTest setup (Bazel 8.2.1 pin), fuzz-found SInt<64> bug fixed, 3 squashed commits
- **session-04**: Extract fix for wide symbolic indices + rotation ops (rotl/rotr) with constant/symbolic/concrete overloads, fuzz tests for both
