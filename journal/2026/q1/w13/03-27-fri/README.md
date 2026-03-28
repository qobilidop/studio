# 2026-03-27 (Friday)

Massive P4Py day: architecture brainstorm with Gemini, project initialization, docs + e2e test infra, and full P4Mini spec-to-implementation. Also planned personal website on GitHub Pages.

## Sessions

- **session-00**: Daily log — late night "能工智人" joke, arxiv paper marked, extensive P4Py architecture brainstorm with Gemini (Lean eDSL, Rust eDSL, Python AST VM vs tracing, extern registry, naming, P4Mini/P4Lite subsets, v1model testing), "boundary architect" concept, Goedel-Code-Prover discovery
- **session-01**: P4Py project initialization — src-layout, Bazel 9, switched MkDocs→Sphinx+MyST+Furo after ecosystem research, devcontainer, CI, ruff/buildifier/shfmt/dprint tooling
- **session-02**: Personal website planning — GitHub Pages for digital longevity, no custom domain (renewal risk after death), static site, `username.github.io` repo
- **session-03**: P4Py docs + e2e test infra — roadmap/architecture docs, STF test runner with BMv2 veth pairs, Bazel P4 deps attempted then reverted (QEMU emulation unreliable on ARM Mac), subagent-driven development
- **session-04**: P4Mini spec → implementation — designed P4 language subset spec, implemented full milestone via subagent-driven development in worktree (IR nodes, lang types, compiler, P4-16 backend, simulator, integration test), 12 tests passing, merged to main

## Agent index

- P4PY-ARCHITECTURE: converged on Python eDSL using AST Virtual Machine (Path 2) over tracing (Path 1). Inspired by Triton, Taichi, MyHDL (session-00)
- P4PY-SCOPE: useful subset of P4, not full spec. Two tiers: P4Mini (minimal toy) and P4Lite (useful subset). Validation via capability profiles (session-00)
- P4PY-TESTING: subset v1model architecture (not custom MiniArch) to leverage p4testgen + BMv2 diff testing for free (session-00)
- P4PY-EXTERNS: ExternRegistry pattern — Python implements P4 externs, VM crosses boundary to call them, emitter generates extern declarations only (session-00)
- P4PY-NAMING: package=p4py, brand=P4Py, avoid "p4" namespace (Perforce collision). `import p4py as p4` convention (session-00)
- P4PY-ERGONOMICS: builder pattern + decorators (@p4.parser, @p4.control, @p4.table, @p4.action, @p4.extern). Python classes for headers/structs (session-00)
- P4PY-BACKENDS: hub-and-spoke — single AST, multiple backends: Python simulator, P4 emitter, future C/eBPF emitter (session-00)
- P4PY-INIT: src-layout, Bazel 9 + rules_python, Sphinx+MyST+Furo (MkDocs ecosystem fragmenting), ruff/buildifier/shfmt/dprint, devcontainer Ubuntu 24.04, CI via devcontainers/ci (session-01)
- P4PY-DOCS-CHOICE: MkDocs→Sphinx+MyST+Furo after research — MkDocs core unmaintained, Material maintenance mode Nov 2025, 3 forks (session-01)
- P4PY-NO-DOC-FORMATTER: no good MyST/rST formatter exists; sphinx-build -W is quality gate (session-01)
- WEBSITE: GitHub Pages, no custom domain, static site, `username.github.io` repo — optimized for digital longevity (session-02)
- WEBSITE-LONGEVITY: git repo + Internet Archive as passive backup; public repo required for free Pages (session-02)
- P4PY-ROADMAP: P4Mini (v0.1.0) and P4Lite (v1.0.0) milestones documented (session-03)
- P4PY-ARCHITECTURE-DOC: hub-and-spoke around P4 AST, AST-parsing approach chosen over tracing (session-03)
- P4PY-E2E: STF format for testing (following 4ward), stf_runner.py with BMv2 veth pairs + Thrift CLI, Ubuntu 22.04 required for p4lang apt packages (session-03)
- P4PY-BAZEL-BLOCKED: building p4c from source under QEMU on ARM Mac unreliable — reverted, plan saved for future (session-03)
- P4MINI-SPEC: bit<W>, header, struct, parser states, exact-match tables, assignment + arithmetic actions, isValid() conditions, V1SwitchMini(Parser,Ingress,Deparser) (session-04)
- P4MINI-IMPL: 7 commits — IR nodes (25 frozen dataclasses), lang types (bit with lru_cache, header/struct via __init_subclass__), compiler (Python AST parsing), P4-16 backend, simulator (bit-level), integration test (session-04)
- P4MINI-ISSUES: `from __future__ import annotations` breaks __init_subclass__, pytest import breaks Bazel sandbox, subagent commit reliability issues (session-04)
- CONCEPT: "boundary architect" key skill = identify most constraining parts of boundary to specify intended system behavior (session-00)
- REFERENCE: Goedel-Code-Prover (goedelcodeprover.github.io) — 8B Lean 4 theorem prover (session-00)
- REFERENCE: arxiv 2602.06923 "From Kepler to Newton" — marked to read (session-00)
