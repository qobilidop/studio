# 2026-03-23 (Monday)

## Z3Wire docs, formatting, bugfix, and Weave improvements

### Markdown pipe rendering
- `<code>\|</code>` works in both GitHub and MkDocs table cells. mdformat normalizes to this form.

### mdformat-mkdocs setup
- Split formatting: mdformat-mkdocs for `docs/` (MkDocs-rendered), dprint for everything else (GitHub-rendered).
- `.mdformat.toml` with `wrap = 80`, `end_of_line = "lf"`.
- `dprint.json` excludes `docs/` from markdown scope.
- `format.sh` runs mdformat on `docs/` then dprint on rest.
- Google 4-space list indent: only `remark` supports it, stuck with mdformat for MkDocs compatibility.

### Bug fix: symbolic-offset replace with wide offset
- `WS - WL` underflows for `size_t` when `WL > WS`. Fixed with `std::max(WS, WL)` pattern (same as extract).
- TDD: test-first approach confirmed the bug.

### API naming
- `BitVec::Checked` renamed to `BitVec::FromValue` (parallels `SymBitVec::FromExpr`). 18 files changed.

### Weave improvements
- `--include_prefix <path>` flag for root-relative proto includes.
- `rdl.proto` renamed to `wire_spec.proto`, `Module` to `WireSpec`, package `z3wire_rdl` to `z3wire_weave`.
- `.rdl.txtpb` → `.wire_spec.txtpb` (semantic: `<name>.<format>.<encoding>`).
- Abseil flags replaced hand-rolled arg parsing.

## Z3Wire proto naming cleanup
- `EnumDef` → `Enum` in `wire_spec.proto` (no technical reason for Def suffix; `Enum` not reserved in proto3).
- Kept `EnumValue` (not shortened to `Value` — too generic).

## Z3Wire API review and Weave removal

### SymBitVec constructors
- `CreateSymbolicVariable` mutating method: rejected — struct constructors are idiomatic.
- Making `SymBitVec(z3::expr)` private: not worth churn (20+ friend declarations needed).
- Default constructor kept (enables `std::array` init + loop assignment). No `is_initialized()` — use `std::optional` instead.

### Concrete BitVec API
- `FromValue(std::span<const uint8_t>)` for wide BitVec (W > 64). Shorter spans zero-pad, longer detect truncation.
- Return: `{result, truncated}`.

### Simplified requires clause
- Replaced `template <size_t Dummy = W> requires(...)` trick with plain `requires(W > 64)` — C++20 allows this on non-template members of class templates.

### Weave removed from Z3Wire
- Removed: `z3wire_weave/`, `examples/weave/`, `docs/design/weave.md`.
- Simplified: MODULE.bazel (dropped abseil-cpp, protobuf, rules_proto), CMakeLists.txt, Dockerfile, tools/lint.sh, mkdocs.yml, roadmap.md.
- Tests: 35 → 29. Rationale: keep Z3Wire focused on core type-safe wrapper.

### design/overview.md replaced with design/philosophy.md
- Old overview mixed stable rationale with drifting API reference (~414 lines → ~73 lines).
- Keeps: motivation, core goals, scope, design principles.

### Docs assessment
- Usage docs (types, operations, type-conversions) are thorough.
- Main gap: no Getting Started / quickstart — blocked on packaging (BCR or vcpkg).

## Daily log
- First day in new office building.
- Work is confidential — no details logged.
- Evening reading: DeepSeek bypassing NCCL for MoE communication, PCIe ordering issues (strict vs relaxed ordering, DMA race conditions).

## Sessions

- **session-00**: Daily log — first day in new office, confidential work, evening reading on DeepSeek MoE communication and PCIe ordering
- **session-01**: Z3Wire docs formatting (mdformat-mkdocs split), symbolic-offset replace bugfix, `BitVec::FromValue` rename, Weave improvements (--include_prefix, WireSpec rename, Abseil flags)
- **session-02**: Z3Wire proto naming cleanup — `EnumDef` → `Enum` in wire_spec.proto
- **session-03**: Z3Wire API review — SymBitVec constructor decisions, wide BitVec `std::span` API, Weave removal from Z3Wire, design/philosophy.md, docs assessment
