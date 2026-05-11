# Session 01 — z3wire From/TryFrom Construction API Redesign

**Repo:** github.com/qobilidop/z3wire
**Branch:** `feat/from-tryfrom-redesign` (from main, clean tree)
**PR:** https://github.com/qobilidop/z3wire/pull/21
**HEAD:** `f96cbfe` (12 commits)
**Spec:** `.agent_scratch/2026-05-05-construction-api-redesign-design.md` (gitignored)
**Plan:** `.agent_scratch/2026-05-05-construction-api-redesign-plan.md` (gitignored)

## Task

Redesign type-safe constructors for `BitVec`/`SymBitVec`/`SymBool` from C++ native types and `z3::expr`. Replace `FromValue` (returned `tuple<BitVec,bool>`) and `FromExpr` (returned `optional`) with uniform `Literal*` / `From*` / `TryFrom*` triple.

## Final API surface

| Layer | Concrete `BitVec<W,S>` | Symbolic `SymBitVec<W,S>` / `SymBool` |
|---|---|---|
| Compile-time | `Literal<V>()` (NTTP, static_assert) | `Literal<V>(ctx)` |
| Runtime, abort | `From(v)` / `From(span)` (W>64) | `From(z3::expr)` |
| Runtime, fallible | `TryFrom(v) -> TryFromResult { value, truncated }` | `TryFrom(z3::expr) -> optional<T>` |

`TryFromResult` is `[[nodiscard]]` aggregate, structured-bindable: `auto [v, t] = X::TryFrom(x);`. `From` aborts via `Z3W_CHECK` with messages `"construction value out of range"` (concrete) or `"Expected Bool sort"` / sort+width msg (symbolic).

## Key design decisions (with rationale)

1. **Keep `Literal<V>()`** — NTTP gives clean static_assert errors; consteval ctor would lose that (function params aren't constant expressions even inside consteval; throw / undefined-consteval-fn workarounds give worse messages).
2. **`From*`/`TryFrom*` naming, not `FromValue`/`FromExpr`** — Bare `From` matches Rust idiom; overloading on parameter type disambiguates. Same name on concrete + symbolic enables uniform mental model.
3. **`From*` aborts (Rust divergence accepted)** — Rust's `From` is trait-infallible. Ours aborts via Z3W_CHECK. Documented divergence; common-case ergonomics > strict trait fidelity in C++.
4. **Asymmetric `TryFrom` returns** — Concrete uses named struct (recovery value useful), symbolic uses `optional` (no useful recovery on sort mismatch). Faithful to each side's failure mode.
5. **Bit-truncation, not clamping** — Matches HDL conventions, Z3 BV `extract`, and z3wire's own arithmetic. Roadmap entry "Clamp on truncation" reframed as future explicit `saturating_cast` operation.
6. **No Abseil dep** — Heavyweight for one feature in a focused template lib. `StatusOr`/`DCHECK` rejected.
7. **No `consteval` ctor** — See #1.
8. **No symbolic `From(ctx, native_int)` gap-fill** — YAGNI; today's `to_symbolic(BitVec, ctx)` path is one extra step.
9. **`SymBitVec(z3::expr)` ctor stays public** — `From(z3::expr)` is a static alias; ctor stays for internal use to avoid massive friend-declaration refactor.

## Migration scope (12 commits)

```
76816ee feat: add From/TryFrom on BitVec
3844bc1 refactor: migrate BitVec::FromValue callers to From/TryFrom
4cbd214 refactor: remove BitVec::FromValue in favor of TryFrom
6803e6e feat: add SymBitVec::From and SymBitVec::TryFrom
d33603d refactor: migrate SymBitVec::FromExpr callers to TryFrom
9ce52dd refactor: remove SymBitVec::FromExpr in favor of TryFrom
589684b feat: add SymBool::From and SymBool::TryFrom
0797099 refactor: migrate SymBool::FromExpr callers to TryFrom
529f220 refactor: remove SymBool::FromExpr in favor of TryFrom
297ee77 docs: update types.md for From/TryFrom construction API
8d2a405 docs: update remaining FromValue/FromExpr references; rename fixture
f96cbfe chore: format
```

Pattern: per type, three commits (add → migrate → remove). Each commit is bisectable.

## Notable discoveries during execution

- **`to_concrete` deviation** (`z3wire/sym_bit_vec.h:to_concrete`): plan said use `From()`. Implementer correctly switched to `TryFrom(...).value`. Reason: Z3's `get_numeral_uint64()` returns bit pattern as unsigned. For signed types, valid negative values produce uint64 > max_signed → `From()` would spuriously abort. Original code was `std::get<0>(FromValue(...))` which silently discarded the (incorrect) truncation flag. `TryFrom(...).value` preserves that semantic.
- **Bazel `:check` visibility**: had visibility `//z3wire:__subpackages__`. `bit_vec` is in same package, needed widening to also include `//z3wire:__pkg__`. CMake mirror: added `z3wire_check` INTERFACE library, linked into `z3wire_bit_vec`.
- **`bit_vec_roundtrip_test` flaky timeout**: pre-existing sizing issue. Bazel warns "tests whose specified size is too big". Re-runs pass in ~24s. Not introduced by this work.
- **LSP/clangd noise**: clangd doesn't have Bazel's include paths. Many "file not found" / "unknown identifier" diagnostics appeared throughout — all spurious. Bazel/CMake build confirms reality.
- **Test fixture rename**: `FromExprTest` (in `sym_bit_vec_test.cc`) became misleading after rename. Renamed to `SymBitVecFromTest`.
- **`<tuple>` cleanup**: removed from `bit_vec.h`, `bit_vec_checked_test.cc`, `bit_vec_roundtrip_test.cc` after `FromValue` removal.

## Process

- Used skills in sequence: `superpowers:brainstorming` → `superpowers:writing-plans` → `superpowers:subagent-driven-development` → `superpowers:finishing-a-development-branch`.
- Subagent dispatches: 12 implementer + 11 reviewer (skipped formal review on Task 10 docs single-file change). Used sonnet model for all (sufficient for mechanical refactor with detailed plan).
- Final whole-branch review via `superpowers:code-reviewer` agent: ready to merge, 5 minor cosmetic notes (none blocking).

## Session learnings

- **Long brainstorming pays off.** User had real questions about Rust's `From` semantics, Go's `Must` convention, consteval limitations, Abseil tradeoffs. Each clarification shifted the design. Final spec is much better than what I would have written from the initial prompt.
- **Spec → plan → execute pipeline works at scale.** 12-task mechanical execution went smoothly. Each task's plan had complete code blocks, exact commands, expected outputs, ready-made commit messages. Subagents needed no questions; implementations matched plan.
- **Implementer deviation can be right.** The `to_concrete` case is a clean example: plan was based on naive read of code; implementer caught a real semantic issue. Trust subagent judgment when reasoning is sound.
- **Review depth scales to commit risk.** Full spec+quality review for header changes; combined single-pass review for follow-up commits; skipped formal review for self-contained docs change.
- **`.agent_scratch/` convention works.** Keeping spec and plan in gitignored scratch dir avoids polluting docs/ with intermediate artifacts. AGENTS.md mandates this for the project.

## Files touched (for grep recovery)

Library: `z3wire/bit_vec.h`, `bit_vec_test.cc`, `sym_bit_vec.h`, `sym_bit_vec_test.cc`, `sym_bool.h`, `sym_bool_test.cc`, `BUILD.bazel`, `CMakeLists.txt`.
Tests: `tests/fuzz/bit_vec_checked_test.cc`, `bit_vec_roundtrip_test.cc`, `sym_bit_vec_extract_test.cc`, `sym_bit_vec_rotate_test.cc`. `tests/compile_fail/README.md`.
Examples: `examples/usage/types.cc`.
Docs: `docs/usage/types.md`, `docs/design/concrete-types.md`, `docs/dev/style.md`, `docs/dev/roadmap.md`.

## Commands used

```sh
./dev.sh bazel build //...
./dev.sh bazel test //...
./dev.sh cmake -B build && ./dev.sh cmake --build build
./dev.sh ctest --test-dir build --output-on-failure
./dev.sh ./tools/lint.sh
./dev.sh ./tools/docs.sh
./dev.sh ./tools/format.sh
```

All commands use the `./dev.sh` wrapper (runs in dev container).

## Open follow-ups

- Roadmap entry: `saturating_cast<T>(v)` as explicit operation if a real use case appears.
- Possible fixture rename pattern in other test files if any old naming feels stale.
- Doc polish: optionally add explicit "unlike Rust's `From`, ours aborts" sentence in `docs/usage/types.md` (final reviewer flagged this as borderline gap).
