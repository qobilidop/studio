# 2026-03-14 (Saturday)

Pi Day: launched P4kt from empty repo to full VSS (Very Simple Switch) coverage in a single day across six sessions. Native Kotlin classes for IDE autocomplete, subagent-driven development, pre-commit hook as structural guarantee.

## Sessions

- **session-00**: Daily log (Gemini) -- Habermas died (mapped his philosophy to open source), Pi Day declared as fun project day, P4kt kickoff, dprint over prettier, README feedback, VibeTensor paper, DSL ergonomics discussion (property delegation via `by`)
- **session-01**: P4kt project setup -- Bazel+Bzlmod, devcontainer (Colima, Ubuntu 24.04, JDK 21), flat Google-style layout, `./dev` wrapper script
- **session-02**: P4kt design + implementation + tooling + docs -- v0.1 eDSL architecture (builders -> IR -> renderer), TDD, formatters/linters (ktfmt, dprint, detekt, shellcheck, hadolint), CI, golden tests (.kt+.p4 pairs), MkDocs Material docs site, README with language comparison
- **session-03**: P4kt VSS milestone -- types, expressions, statements, actions; `provideDelegate` pattern for eager delegation; 5 golden tests
- **session-04**: P4kt typed field access, controls, tables -- P4 structs as native Kotlin classes (big ergonomics shift), constructor refs over reflection (local captures break reflection), removed kotlin-reflect, parentheses optimization, split Dsl.kt into Dsl.kt+Builders.kt
- **session-05**: P4kt complete VSS coverage -- parser states with deferred evaluation for forward refs, method calls, error declarations, subagent-driven development (18 tasks, 6 dispatches), pre-commit hook added, 17/17 tests pass

## Agent index

- P4kt repo: github.com/qobilidop/p4kt (session-01)
- P4kt architecture: DSL builders (mutable) -> IR (immutable data classes) -> Renderer (P4 text) (session-02)
- Bazel+Bzlmod: rules_kotlin 2.3.10, Bazel 8.6.0; JUnit 4 not 5 (kt_jvm_test gotcha) (session-01)
- devcontainer: Colima not Docker Desktop; Ubuntu 24.04 has `ubuntu` user at UID 1000 not `vscode`; build-essential needed for Bazel CC toolchain (session-01)
- golden tests: examples/ with .kt+.p4 pairs; Bazel macro in tools/golden_test.bzl; dual purpose: regression + docs (session-02)
- Claude Code hooks: PostToolUse auto-format, Stop lint check (session-02)
- `provideDelegate` is correct Kotlin pattern for eager delegation -- came up 3 times (declarations, varDecl, params) (session-03)
- native Kotlin classes for P4 structs/headers: `class OutControl(base: P4Expr) : StructRef(base)` with real properties; enables IDE autocomplete (session-04)
- constructor references (`::ClassName`) over reflection -- local classes capturing outer lambda vars get hidden constructor params, breaking reflection; removed kotlin-reflect dependency (session-04)
- parser states: deferred evaluation via storing lambda, executing at build(); `provideDelegate` creates P4StateRef immediately; allows forward references (session-05)
- subagents bypass parent's Stop hook -- lint errors slipped through; fix: pre-commit hook as hard structural gate + AGENTS.md rules (session-05)
- Habermas -> open source: public sphere = OSS communities, communicative action = PRs/code review, discourse ethics = RFC processes, system colonization = corporate influence on FOSS (session-00)
- VibeTensor paper (arxiv:2601.16238): AI-generated deep learning runtime, validates agentic coding + testing harness approach (session-00)
- dprint chosen over prettier: avoids Node.js dependency (session-00)
