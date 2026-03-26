# Session: Separate Weave Module from Core Z3Wire

**Repo:** github.com/qobilidop/z3wire
**Branch:** main
**Commits:** a226569..0172e60 (4 commits, pushed)

## Context

User was concerned about heavy dependencies (abseil, protobuf) in the core Z3Wire CMake project. These are only needed by the Weave code generator, not the core library (sym_bool, sym_bit_vec, etc.). Bazel already isolates them per-target, but CMake's root `find_package` forced all consumers to install them.

## Design Discussion

Explored several approaches through conversation:
- Separate CMake `project()` for Weave vs gated `option()`
- Moving Weave to its own top-level directory vs keeping it nested
- Namespace: decided `z3wire_weave` (matching directory, per Google C++ Style Guide)
- Considered Python rewrite for Weave — decided against splitting into separate package because same-repo bundling guarantees version compatibility
- Discussed vcpkg features (`z3wire[weave]`) and Homebrew formulae (two separate: `z3wire` + `z3wire-weave`) for future packaging — deferred to later

## Key Decision

Keep Weave in the same repo, but:
1. Move `z3wire/weave/` to top-level `z3wire_weave/`
2. Gate behind `option(Z3WIRE_BUILD_WEAVE OFF)` in CMake
3. Core CMake consumers never see abseil/protobuf

## Implementation

4 commits:
1. `a226569` — Move directory, update Bazel package refs, namespace `z3wire::weave` → `z3wire_weave`, include paths `z3wire/weave/` → `z3wire_weave/`
2. `bd97e58` — Restructure CMake: remove abseil/protobuf from root, add `Z3WIRE_BUILD_WEAVE` option, move `find_package` into `z3wire_weave/CMakeLists.txt`
3. `2eee493` — Update `tools/lint.sh`: enable weave for compile_commands, add `z3wire_weave` to find path
4. `0172e60` — Update `docs/design/weave.md` directory layout

## Verification

- Bazel: 35/35 tests pass
- CMake core-only (weave OFF): builds without abseil/protobuf
- CMake full (weave ON): all 8 tests pass
- Lint, docs, format: all pass

## Artifacts

- Spec: `docs/superpowers/specs/2026-03-21-separate-weave-module-design.md` (gitignored)
- Plan: `docs/superpowers/plans/2026-03-21-separate-weave-module.md` (gitignored)

## Gotcha

When renaming Bazel package `//z3wire/weave` to `//z3wire_weave`, the default target name changes. Had to use explicit `//z3wire_weave:weave` in `examples/weave/BUILD.bazel` since the binary target is named `weave`, not `z3wire_weave`.
