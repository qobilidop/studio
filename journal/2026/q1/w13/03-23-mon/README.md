# 2026-03-23 (Monday)

Major Z3Wire cleanup day: removed Weave codegen to keep the library focused, refined API naming and constructors, fixed a symbolic-offset bug, and set up dual markdown formatting. First day in new office building.

## Sessions

- **session-00**: Daily log — first day in new office, confidential employer work, evening reading on DeepSeek MoE/NCCL bypass and PCIe ordering
- **session-01**: Z3Wire docs formatting (mdformat-mkdocs split), symbolic-offset replace bugfix, `BitVec::FromValue` rename, Weave improvements (--include_prefix, WireSpec rename, Abseil flags)
- **session-02**: Z3Wire proto naming cleanup — `EnumDef` → `Enum` in wire_spec.proto
- **session-03**: Z3Wire API review — SymBitVec constructor decisions, wide BitVec `std::span` API, Weave removal, design/philosophy.md, docs assessment

## Agent index

- decision: remove Weave from Z3Wire — keep core library focused on type-safe Z3 wrapper; codegen is different concern/audience (session-03)
- decision: `BitVec::FromValue` / `SymBitVec::FromExpr` naming — simple, parallel, return types communicate fallibility (session-01)
- decision: `WireSpec` over `Module`/`Schema`/`RDL` — self-documenting, ties to project name; `.wire_spec.txtpb` uses `<name>.<format>.<encoding>` convention (session-01)
- decision: keep both `SymBitVec(z3::expr)` (aborting) and `FromExpr` (optional) public — making aborting ctor private requires 20+ friend declarations, not worth churn (session-03)
- decision: keep default constructor for `SymBitVec` — enables `std::array` init + loop assignment; no `is_initialized()`, use `std::optional` instead (session-03)
- decision: `FromValue(std::span<const uint8_t>)` for wide BitVec (W>64) — shorter spans zero-pad, longer detect truncation; return `{result, truncated}` (session-03)
- decision: mdformat-mkdocs for `docs/`, dprint for rest — MkDocs compat > Google-style 4-space list indent (only remark supports it) (session-01)
- decision: `EnumDef` → `Enum` — `Enum` not reserved in proto3, package namespace avoids collisions; kept `EnumValue` (too generic as just `Value`) (session-02)
- bugfix: symbolic-offset replace `WS - WL` underflows `size_t` when `WL > WS`; fixed with `std::max(WS, WL)` pattern matching extract (session-01)
- simplification: C++20 `requires(W > 64)` works on non-template members of class templates — removed `Dummy` trick (session-03)
- design/overview.md → design/philosophy.md: ~414 → ~73 lines, keeps motivation/goals/scope/principles (session-03)
- blocker: no Getting Started / quickstart page — blocked on packaging story (BCR or vcpkg), both on roadmap (session-03)
- removed memory file `project_weave_include_paths.md`, updated MEMORY.md to drop Weave refs (session-03)
- formatting: `<code>\|</code>` renders pipe in tables on both GitHub and MkDocs; mdformat normalizes to this form (session-01)
- reading: DeepSeek bypassed NCCL for MoE communication; PCIe strict vs relaxed ordering, DMA race conditions, RO bit on data but not completion packets (session-00)
