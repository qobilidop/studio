# 2026-03-20 (Friday)

## Z3Wire CI & tooling overhaul (session-01)

- **Z3 version pinning**: CMake switched from system `libz3-dev` (4.8.12) to pre-built Z3 4.15.2 from GitHub releases — fixes const-correctness build failure for `rotate_left`/`rotate_right`
- **Formatter/linter overhaul**: black → ruff format, mdformat → dprint, pip → uv; added dprint (markdown/json/yaml/toml), ruff check (lint), proto formatting via clang-format
  - Config: `ruff.toml` (Google Python Style, line-length=80), `dprint.json` (80-char wrap)
  - dprint 2-space list indent accepted (no config for 4-space)
  - Dockerfile: ruff + dprint as pre-built binaries, uv via `COPY --from=`
- **BuildBuddy remote cache**: `.bazelrc` `config:remote`, CI writes `ci.bazelrc` (gitignored), `BUILDBUDDY_API_KEY` secret
- **Codecov**: added `CODECOV_TOKEN` secret for protected branch
- **PR checks**: devcontainer workflow builds on PRs touching `.devcontainer/**`, docs workflow runs `mkdocs build --strict` on PRs
- Unpushed commit `e9cca78`: PR checks + naming normalization

## Z3Wire Weave C++ rewrite + infrastructure (session-02)

- **Lint fix**: Z3 moved to source build, updated header paths in `tools/lint.sh`
- **Codecov removal**: removed coverage CI, `tools/coverage.sh`, `.bazelrc` coverage config, `lcov`/`llvm` packages
- **Weave Python → C++ rewrite**: ~800 lines Python → ~1200 lines C++ (Abseil + protobuf C++ API), golden tests byte-identical, removed all Python infrastructure
- **CMake extended for weave**: GoogleTest v1.17.0, Abseil 20260107.1, Protobuf v34.0 from source in Dockerfile; `find_package` over FetchContent; 8 CMake tests (5 core + 3 weave)
- **Test directory reorg**: `compile_fail_tests/` → `tests/compile_fail/`, `fuzz_tests/` → `tests/fuzz/`
- **Lint overhaul**: CMake `compile_commands.json` replaces Bazel-based header hunting; weave files now linted; `.clang-tidy` HeaderFilterRegex excludes `.pb.h`
- **Build config**: `config:remote` → `config:ci`, relative disk cache path
- vcpkg packaging discussed but deferred

## Explorations (session-00)

- **SMT Arena idea**: differential testing/fuzzing of SMT solvers using synthesized SMT-LIB scripts — existing projects: Yin-Yang, Murxla, StringFuzz; idea shelved for now
- **Lean 4 for formalization**: explored Lean 4 as tool for formalizing math/physics, self-hosting via C bootstrap, eDSLs in Lean (Sparkle HDL, Lean-SMT, AMO-Lean)
- **P4 eDSL in Lean**: designed deep-embedded P4 DSL with type-safe headers, strongly-typed state machine parser using parameterized types and total functions — promising direction, paused for later
- **Formatting tools research**: dprint vs rumdl vs mdformat comparison; dprint chosen for projects; mdformat-mkdocs for MkDocs docs/ folder; pre-commit framework deep dive (Git hooks, isolated toolchains, devcontainer integration)
