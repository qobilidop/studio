# Session 02 — P4kt: Design, Implementation, Tooling, Docs, README

Repo: github.com/qobilidop/p4kt

## v0.1 eDSL Design

- Drafted high-level design for P4kt v0.1 scope: P4 functions + supporting types
- Architecture: DSL builders (mutable) → IR (immutable data classes) → Renderer (P4 text)
- Scope: bit/int/bool/void types, arithmetic/bitwise/comparison/logical expressions, variable declaration/assignment/if-else/return statements, function declarations with in/out/inout params
- DSL style: Kotlin-idiomatic with delegated properties (`val a by param(bit(8), IN)`), named operators (`gt`, `band`, `eq`), trailing underscores for keyword collisions (`if_`, `return_`)
- Key decisions: builder-centric (not IR-first), flat package layout in `p4kt/`, untyped integer literals (P4 compiler handles coercion), `if_` returns value for `.else_` chaining
- Design doc saved to `docs/design.md` and committed

## Minimal Implementation

- TDD: wrote end-to-end test for identity function first, then implemented
- Three files: `Ir.kt` (sealed class hierarchies), `Dsl.kt` (builders with ReadOnlyProperty delegates), `Emit.kt` (toP4() extension functions)
- Identity function works end-to-end: `p4Function("id", bit(8)) { val x by param(bit(8), IN); return_(x) }` → `function bit<8> id(in bit<8> x) { return x; }`

## Developer Tooling

### Formatters
- ktfmt 0.54 (--google-style), buildifier 8.0.3, shfmt 3.11.0, dprint 0.52.0 (markdown, json, yaml, dockerfile)
- Initially used mdformat + yamlfmt + yamllint (Python), then consolidated to dprint (Rust binary) — removed Python dependency from devcontainer
- `./dev format` and `./dev format --check`, `tools/format.sh`

### Linters
- detekt 1.23.8, shellcheck (apt), buildifier -lint=warn, hadolint 2.14.0
- `./dev lint`, `tools/lint.sh`
- detekt.yml: relaxed PackageNaming (disabled), FunctionNaming (allow underscores), MagicNumber (common widths), WildcardImport (excluded examples/)
- .hadolint.yaml: ignore DL3008 (apt version pinning)
- hadolint architecture gotcha: uses arm64/x86_64 naming with lowercase `linux` in download URL

### CI
- `.github/workflows/ci.yml`: format check → lint → build → test (devcontainers/ci action)
- CI badge in README

### Claude Code Hooks
- PostToolUse (Edit|Write): `./dev format` — auto-format after every edit
- Stop: `./dev lint` — lint check before finishing

### `dev` Script
- Evolved from simple passthrough to dispatcher: format, lint, docs, plus passthrough

## Golden Tests
- `examples/` directory with `.kt` + `.p4` file pairs
- `tools/golden_test.bzl`: Bazel macro generates kt_jvm_binary + sh_test per example
- `tools/golden_test.sh`: runs binary, compares stdout to .p4 file
- First example: identity function
- Uses rules_shell for sh_test (added to MODULE.bazel)
- Serves dual purpose: regression tests + user-facing documentation

## Documentation Site
- MkDocs Material, deployed to GitHub Pages via `.github/workflows/docs.yml`
- `./dev docs` (serve) and `./dev docs build`
- Auto-generated examples page from `examples/` directory via `tools/generate_examples_doc.sh`
- Side-by-side grid layout (CSS grid) for P4kt code alongside P4 output, responsive
- Pages: Home (index.md), Examples (generated), Design (design.md), Development (dev.md)
- Added Python + mkdocs-material back to devcontainer for docs
- dprint excludes `docs/examples.md` (generated file)
- Docs badge in README

## README
- Expanded with three sections: Why eDSL for P4, How it works, Why Kotlin
- Why Kotlin: honest comparisons to Haskell (Clash), Scala (Chisel, SpinalHDL), OCaml (Petr4, Hardcaml), Rust, C++ (P4C, Boost.Spirit), Python (Amaranth HDL)
- Key insight from research: Python eDSLs like Amaranth do rich elaboration-time type checking; even Scala eDSLs like Chisel check bit widths at elaboration time not compile time. Honest about Kotlin's advantage being structural errors + IDE feedback, not domain-specific checks.
- Python positioned as legitimate peer with different tradeoffs, not inferior
- Tone: respectful to all languages, acknowledge strengths before explaining why not chosen
- Terminology standardized: eDSL (not DSL), builder eDSLs, P4C (uppercase)
- Kotlin features linked to official docs: lambda receivers, operator overloading, @DslMarker, type-safe builders

## Commit History (final state)
Clean logical commits on main, force-pushed multiple times to maintain clean history. User prefers fewer logical commits over many tiny ones.
