# Session 03 — Z3Wire: README Example, shr API, Tooling Improvements

Repo: https://github.com/qobilidop/z3wire

## What happened

### README quick start example overhaul
- Replaced the carry-flag example with a **midpoint overflow** example proving the classic binary search bug `(a + b) >> 1` and verifying the bit-hack fix `(a & b) + ((a ^ b) >> 1)`.
- References: Joshua Bloch's 2006 blog post, Raymond Chen's bit-hack explanation.
- Created `examples/midpoint_overflow.cc` as a runnable program.
- Iterated heavily on style: explicit `z3w::` qualification (no ADL, no `using`), explicit result types instead of `auto`, concrete `UInt<32>::Literal<1>()` for shift amount.

### shr API improvements
- Added `shr<N>(val)` constant shift (mirrors existing `shl<N>`).
- Changed `shr(val, amt)` to accept `SymUInt<K>` with any width K (was same-type only).
- Added mixed concrete+symbolic overloads for both `shl` and `shr` (accept `BitVec<K, false>` amount, auto-promote via `to_symbolic`).
- Updated docs: `operations.md`, `cheatsheet.md`.

### Tooling improvements
- **mdformat**: Added `.mdformat.toml` with `wrap = 80` for consistent markdown line width.
- **clang-tidy**: Disabled `modernize-use-auto`, `modernize-return-braced-init-list`, `modernize-avoid-c-arrays` — they conflict with Google C++ Style Guide.
- **clang-include-cleaner**: Added to `tools/lint.sh` using `--print=changes` per-file (must run per-file, not batch). Fixed IWYU violations: removed unused `<concepts>`, added missing `<utility>`, `<type_traits>`, `sym_bool.h`.
- **CI rename**: Renamed "Checks" workflow to "Lint" — formatting is a subset of linting.
- Removed stale `docs/dev/test-coverage.md` (maintenance burden, always out of sync).

### dev/guide.md
- New consolidated development guide for both humans and agents.
- Resolved TODO: no separate devcontainer setup needed (`./dev.sh` handles it).
- Quality checks section: format, lint, bazel build, bazel test, docs (no CMake — that's CI-only).
- Commit style section moved from AGENTS.md.
- Added to mkdocs nav.

## Key decisions
- Prefer explicit `z3w::` namespace qualification over ADL in examples (Google style alignment).
- `shr` amount is always unsigned (`SymUInt<K>` or `UInt<K, false>`) — shift amounts are inherently unsigned.
- Mixed concrete+symbolic shift overloads delegate to `to_symbolic()` then call the symbolic version — same pattern as other mixed operators.
- CI workflow naming: "Lint" > "Format & Lint" > "Checks" > "Style" > "Code Quality" — lint is the conventional superset.

## Commit history (cleaned up)
- `shr<N>` constant shift and relaxed shr amount type
- Replace README quick start with midpoint overflow example
- Enforce 80-column wrap for markdown files
- Disable modernize checks conflicting with Google C++ Style Guide
- Add mixed concrete+symbolic overloads for shl and shr
- Add clang-include-cleaner to lint and fix IWYU violations
- Rename Checks CI workflow to Lint
- Remove test-coverage.md
