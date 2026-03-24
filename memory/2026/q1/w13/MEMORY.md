# 2026 W13 (Mar 23–29)

## Monday - Z3Wire API cleanup, Weave removal, docs refinement

- **Weave removed from Z3Wire**: removed `z3wire_weave/`, `examples/weave/`, `docs/design/weave.md`. Dropped abseil-cpp, protobuf, rules_proto deps. Tests 35 → 29. Keeps Z3Wire focused on core type-safe wrapper library.
- **design/overview.md → design/philosophy.md**: old overview mixed stable rationale with drifting API reference (~414 → ~73 lines). New file keeps motivation, goals, scope, principles.
- **Wide BitVec `FromValue(std::span<const uint8_t>)`**: replaces `std::array` for W > 64. Shorter spans zero-pad, longer detect truncation. Return: `{result, truncated}`.
- **`BitVec::Checked` → `BitVec::FromValue`**: parallels `SymBitVec::FromExpr`. 18 files changed.
- **C++20 requires simplification**: removed `template <size_t Dummy = W> requires(...)` trick — plain `requires(W > 64)` works on non-template members of class templates.
- **SymBitVec constructor decisions**: keep both `SymBitVec(z3::expr)` (aborting) and `FromExpr` (optional-returning) public. Keep default constructor for array init. No `is_initialized()` — use `std::optional`.
- **mdformat-mkdocs**: split formatting — mdformat for `docs/`, dprint for everything else. `format.sh` orchestrates.
- **Symbolic-offset replace bugfix**: `WS - WL` underflow when `WL > WS`. Fixed with `std::max` pattern.
- **Weave improvements** (before removal): `--include_prefix`, RDL → WireSpec rename, Abseil flags, `EnumDef` → `Enum`.
- **Docs assessment**: usage docs thorough, main gap is Getting Started (blocked on packaging: BCR or vcpkg).
- First day in new office building. Evening: DeepSeek MoE/NCCL bypass, PCIe ordering deep dive.
