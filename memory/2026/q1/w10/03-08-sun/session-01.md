# Session 01 — Z3Wire infrastructure and docs polish

Project: Z3Wire (https://github.com/qobilidop/z3wire)

## What we did

### CI organization
- Split monolithic CI into four focused workflows: **Checks** (format, lint), **Bazel** (build, test, coverage), **CMake** (build, test), **Docs** (MkDocs deploy)
- Renamed workflow files to match: `checks.yml`, `bazel.yml`, `cmake.yml`, `docs.yml`
- Updated README badges and AGENTS.md to be consistent

### CMake build system
- Added CMake as a secondary build system (Bazel remains primary)
- Root `CMakeLists.txt`, `z3wire/CMakeLists.txt` (INTERFACE library), `examples/CMakeLists.txt`
- Z3 discovery via CMake config with pkg-config fallback
- Tests via FetchContent GoogleTest

### Coverage and dependency management
- Integrated Codecov: upload LCOV data from Bazel CI, added coverage badge
- Set up Renovate (chosen over Dependabot for Bazel `MODULE.bazel` support)
- Renovate immediately opened PRs for actions/checkout v6, actions/setup-python v6, etc.

### Documentation overhaul
- Refined project tagline: "Z3 bit-vectors with compile-time width safety and overflow-proof arithmetic."
- Deduplicated README and docs/index.md using `mkdocs-include-markdown-plugin` with `<!-- docs-start/end -->` markers
- Minimized README to: badges, tagline, why, who, features, quick example, building, docs link, license
- Applied sentence-case headings consistently across all docs
- Reorganized nav: Home → Getting started → Examples → User guide → Developer guide
- Added `docs/roadmap.md` for future directions
- Cleaned up design doc: removed redundant sections (project identity, MVP scope)
- Fixed `--` to em dash `—` for consistency, added missing intro paragraphs

### Repo cleanup
- Removed unused root `BUILD.bazel` (not required for `bazel build //...`)
- Documented clang-only compiler support
- Added terminology/spelling section to AGENTS.md (bit-vector, bit-width, bit-growth, Ubv, Sbv)
- Added headings convention (sentence case) to AGENTS.md
- Fixed Bazelisk version (v1.25.0 → v1.28.1) after CI failure from stale download URL
- Reordered README badges: build → quality → docs

## Decisions made
- **Clang only** — GCC support deferred until user demand
- **No branch protection ruleset** — Not useful without PR requirement; CI runs on push are informational
- **Codecov over Coveralls** — More popular, better PR integration
- **Renovate over Dependabot** — Supports Bazel MODULE.bazel, .bazelversion
- **Coverage in Bazel workflow only** — Same test suite regardless of build system, no need to duplicate
- **Sentence-case headings** — Following Google/Apple/MkDocs Material convention
- **README as single source of truth** — docs/index.md includes it via plugin

## Roadmap items captured
- Multiplication, division, modulo (next features)
- First release v0.1.0
- Publish to Bazel Central Registry
- Improve test coverage based on Codecov reports
