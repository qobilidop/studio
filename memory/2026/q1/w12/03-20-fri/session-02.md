# Z3Wire: Weave C++ Rewrite + Infrastructure Overhaul

Repo: https://github.com/qobilidop/z3wire

## Major work done

### 1. Lint fix (Z3 header path change)
- `tools/lint.sh` had hardcoded `*/z3_static/include/z3++.h` path for Z3 headers
- Z3 moved to source build: `*/z3+/src/api/c++/z3++.h` + `*/z3+/src/api/z3.h` (two dirs needed since `z3++.h` includes `<z3.h>`)
- Fixed by searching for both headers and adding both include paths

### 2. Codecov removal
- Removed Codecov, coverage CI step, `tools/coverage.sh`, `.bazelrc` coverage config, `lcov` and `llvm` packages
- Removed license badge from README
- Decision: coverage tracking is overkill for a small solo library; `bazel coverage //...` locally when needed

### 3. Weave Python → C++ rewrite
- Full port of weave code generator: resolver, emit_proto, emit_header, CLI entry point
- ~800 lines Python → ~1200 lines C++ (using Abseil string utilities + protobuf C++ API)
- Added `abseil-cpp` as direct `bazel_dep` (already transitive via protobuf)
- Golden tests confirm byte-identical output
- Removed all Python infrastructure: `rules_python`, `ruff`, `uv`, `pytest`, `ruff.toml`, `__init__.py`
- Updated design doc `docs/design/weave.md`

### 4. CMake build extended to cover weave
- Installed GoogleTest v1.17.0, Abseil 20260107.1, Protobuf v34.0 from source in Dockerfile
- Switched CMake from FetchContent to `find_package` for all deps
- Created `z3wire/weave/CMakeLists.txt` with proto compilation via `protobuf_generate()`
- Key detail: `PROJECT_BINARY_DIR` (not `CMAKE_CURRENT_BINARY_DIR`) for proto include path so `z3wire/weave/rdl.pb.h` resolves
- Added `check_test` and usage examples to CMake build
- CMake now has 8 tests (5 core + 3 weave)

### 5. Test directory reorganization
- `compile_fail_tests/` → `tests/compile_fail/`
- `fuzz_tests/` → `tests/fuzz/`
- Decision based on re2 and flatbuffers patterns; top-level `tests/` for heavier test infrastructure

### 6. Lint overhaul: CMake compile_commands.json
- Replaced fragile Bazel-based header path hunting with `CMAKE_EXPORT_COMPILE_COMMANDS`
- Weave files now linted by clang-tidy (were previously excluded)
- Fixed all clang-tidy issues in weave: `.contains()`, enum base types, braces, cognitive complexity refactoring
- `.clang-tidy` HeaderFilterRegex updated to exclude `.pb.h`: `z3wire/.*(?<!\.pb)\.h$`
- `--host_cxxopt=-std=c++20` added to `.bazelrc` (exec config for genrule tools needs C++20 too)
- `lint.sh` made self-contained: runs cmake configure + proto build internally

### 7. Build config cleanup
- `.bazelrc`: renamed `config:remote` → `config:ci`, switched `--remote_cache` to `common:ci`, relative disk cache path
- Dockerfile: simplified all comments, fixed dprint no-op sed, added `python3-pip`, updated non-root user comment
- CI: fixed lint.yml `config=remote` → `config=ci`, glob for cmake ccache key, docs concurrency fix

## Key decisions and discussions
- vcpkg packaging discussed but deferred as premature; would need `install()` targets + CMake config files first
- Weave should ship as part of the library (not just core headers) for the productivity gain
- `find_package` chosen over FetchContent for CMake deps (matches dev container pattern, faster configure)
- CI workflow structure researched extensively (LLVM, fmt, rocksdb, scylladb patterns)
- clang-tidy in CI: most projects use separate workflow with cmake configure-only; Z3Wire needs proto build for rdl.pb.h
- lint.sh made self-contained (cmake configure + proto build internally) so no prerequisite commands needed
- Format check separate from lint in workflow (fast fail) but both in same lint.yml

## Technical gotchas encountered
- Bazel `--cxxopt` doesn't apply to exec/host configuration (genrule tools); need `--host_cxxopt` separately
- `protobuf_generate()` puts files in `CMAKE_CURRENT_BINARY_DIR` but includes use `z3wire/weave/rdl.pb.h` prefix; expose `PROJECT_BINARY_DIR` instead
- clang-tidy HeaderFilterRegex `z3wire/.*\.h$` also matches `build/z3wire/weave/rdl.pb.h`; use negative lookbehind `(?<!\.pb)\.h$`
- `devcontainer.json` doesn't support `$HOME` or env var expansion in mount paths
