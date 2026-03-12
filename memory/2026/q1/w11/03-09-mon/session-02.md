# Z3Wire: Compile-Fail Tests + Tagline Update

## Project
Z3Wire (https://github.com/qobilidop/z3wire) — C++20 type-safe wrapper around Z3 bit-vectors.

## What happened

### Compile-fail tests (continued from prior session)
- Executed implementation plan for compile-fail tests covering all `static_assert` and SFINAE guards
- Created `compile_fail_tests/` at top level (24 test targets, custom Starlark rule in `defs.bzl`)
- Key patterns: `template class` for class-level guards, `checked<>()` with explicit template args for SFINAE
- Co-located docs: `compile_fail_tests/README.md` as source of truth, `docs/dev/compile-fail-tests.md` uses `include-markdown`

### Structural decisions
- Added "Flat structure" engineering principle to AGENTS.md
- Strengthened devcontainer rule in AGENTS.md: "Run ALL commands through `./dev.sh`"
- Added 72-char commit subject line limit to AGENTS.md

### Terminology fix
- Renamed test files from overflow/underflow to above_max/below_min (underflow is a float concept)

### CI fix
- Fixed clang-format violations in `int.h` and `bitvec.h` (include ordering, parameter alignment)

### Tagline update
- Old: "Z3 bit-vectors with compile-time width safety and overflow-proof arithmetic. A C++20 template library."
- New: "Z3 bit-vectors with compile-time type safety and explicit overflow. For C++20 and above."
- Rationale: "type safety" > "width safety" (covers signedness+sort too); "explicit overflow" emphasizes the problem solved not the approach; "For C++20 and above" keeps C++ visible but secondary
- Updated in: `README.md`, `mkdocs.yml`

## Commits
1. `b7659fe` — Add compile-fail tests for all static_assert and SFINAE guards
2. `3a0bc23` — Add commit subject line length limit to AGENTS.md
3. `256d366` — Co-locate compile-fail-tests docs with code
4. `ae7aa01` — Rename literal range test files for precision
5. `8a0b08d` — Fix clang-format violations in int.h and bitvec.h
6. `752eff4` — Update project tagline to emphasize type safety

## Lessons
- Type aliases (`using`) don't instantiate class templates — need `template class Foo<>;` for static_assert
- `checked(int64_t{42})` silently picks `checked(uint64_t)` via implicit conversion; use `checked<>(int64_t{42})` to force SFINAE
- "Underflow" is a floating-point term; for integers, use "below min"
