# 2026-03-20 (Friday)

Major Z3Wire infrastructure day: rewrote Weave from Python to C++, overhauled formatter/linter stack, added BuildBuddy remote cache, and extended CMake build. Also explored Lean 4 for formalization and designed a P4 eDSL concept.

## Sessions

- **session-00**: Daily log — SMT Arena brainstorm (differential fuzzing of SMT solvers, shelved), Lean 4 deep dive (self-hosting, eDSLs including Sparkle HDL and Lean-SMT), P4 eDSL design in Lean (deep embedding with type-safe headers and parser state machines), dprint chosen as formatter
- **session-01**: Z3Wire CI and tooling overhaul — Z3 version pinning (4.15.2), formatter/linter stack replacement (black to ruff, mdformat to dprint, pip to uv), BuildBuddy remote cache, PR check workflows
- **session-02**: Weave Python to C++ rewrite (~800 to ~1200 lines), Codecov removal, CMake build extended for Weave (find_package over FetchContent), test directory reorg, lint overhaul with cmake compile_commands.json

## Agent index

- DECISION: Weave rewritten from Python to C++ using Abseil + protobuf C++ API; removed all Python infrastructure (rules_python, ruff, uv, pytest) (session-02)
- DECISION: formatter stack — ruff format (Python), dprint (markdown/json/yaml/toml), clang-format (proto); dprint 2-space list indent accepted (no config for 4-space) (session-01)
- DECISION: BuildBuddy remote cache replaces disk cache in CI; `config:ci` in `.bazelrc`, `BUILDBUDDY_API_KEY` secret (session-01)
- DECISION: Codecov removed — overkill for small solo library; `bazel coverage //...` locally when needed (session-02)
- DECISION: CMake deps via `find_package` over FetchContent (matches devcontainer pattern) (session-02)
- DECISION: test reorg — `compile_fail_tests/` to `tests/compile_fail/`, `fuzz_tests/` to `tests/fuzz/` (session-02)
- DECISION: lint.sh made self-contained — runs cmake configure + proto build internally (session-02)
- IDEA-SHELVED: SMT Arena — differential testing of SMT solvers; similar projects exist (Yin-Yang, Murxla, StringFuzz) (session-00)
- IDEA-PAUSED: P4 eDSL in Lean 4 — deep embedding, type-safe headers/parsers, code generation; promising direction (session-00)
- GOTCHA: `--host_cxxopt=-std=c++20` needed in .bazelrc for exec config (genrule tools need C++20) (session-02)
- GOTCHA: clang-tidy HeaderFilterRegex needs negative lookbehind `(?<!\.pb)\.h$` to exclude generated .pb.h files (session-02)
