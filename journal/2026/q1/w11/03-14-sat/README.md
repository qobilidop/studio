# 2026-03-14 (Saturday) - Pi Day

## P4kt launch day

Kicked off P4kt (github.com/qobilidop/p4kt) - Kotlin eDSL for P4. Six sessions spanning project setup through full VSS coverage.

### Session 00: Daily log
- Habermas died (age 96) - discussed his philosophy, mapped concepts to open source (public sphere, communicative action, discourse ethics)
- Pi Day declared as fun project day - duties deferred to Sunday
- Started P4kt with Claude Code
- Formatter choice: dprint over prettier (avoids Node.js dependency)
- README review with Gemini: good design doc but weak README - needs code examples, quick start, status section
- VibeTensor paper (arxiv:2601.16238) - AI-generated deep learning runtime, validates agentic coding + testing harness approach
- DSL ergonomics challenge: autocomplete-friendly field access requires native Kotlin classes, not builder pattern
- Property delegation (`by`) bridges native classes and AST - JetBrains Exposed uses same pattern

### Session 01: Project setup
- Bazel + Bzlmod (rules_kotlin 2.3.10, Bazel 8.6.0), JUnit 4 (not 5 - kt_jvm_test gotcha)
- Flat Google-style layout, devcontainer as primary dev env (Colima, Ubuntu 24.04, JDK 21)
- `./dev` wrapper script forwarding to devcontainer exec
- No lock files (solo project, YAGNI)

### Session 02: Design + implementation + tooling + docs
- v0.1 scope: P4 functions + supporting types
- Architecture: DSL builders (mutable) -> IR (immutable) -> Renderer (P4 text)
- TDD: identity function end-to-end test first
- Tooling: ktfmt, buildifier, shfmt, dprint, detekt, shellcheck, hadolint
- CI: format -> lint -> build -> test (devcontainers/ci action)
- Claude Code hooks: PostToolUse auto-format, Stop lint check
- Golden tests: examples/ with .kt + .p4 pairs, Bazel macro
- MkDocs Material docs site with auto-generated examples page

### Session 03: VSS milestone - types, expressions, statements, actions
- VSS (P4 spec section 5) as concrete milestone
- Implemented: typedef, header, struct, P4Program, delegated properties, expressions, statements, const, actions
- `provideDelegate` pattern for eager delegation (came up 3 times)
- 5 golden tests: identity, max, ttl_decrement, vss_types, vss_actions

### Session 04: Typed field access, controls, tables
- Big ergonomics shift: P4 structs become Kotlin classes with real properties
- Constructor references (`::ClassName`) over reflection - local classes with captures break reflection
- Removed kotlin-reflect dependency entirely
- Controls, tables, match kinds, method calls implemented
- Parentheses optimization: only wrap nested BinOps
- Split Dsl.kt into Dsl.kt + Builders.kt
- Consolidated to 2 golden tests matching VSS reference programs

### Session 05: Complete VSS coverage
- Parser states with deferred evaluation for forward references
- Method calls: `call()` for statements, `.call()` for expressions
- error_ naming to avoid Kotlin stdlib collision
- Subagent-driven development: 18 tasks across 6 dispatches
- All new constructs: parser, extern, error, deparser, package instantiation
- Pre-commit hook added after discovering subagents bypass Stop hook
- Final: 17/17 tests pass (15 unit + 2 golden), full VSS program generated

## Key decisions
- Bazel + Bzlmod + devcontainer + Colima (not Docker Desktop)
- DSL architecture: builders -> IR -> renderer
- Native Kotlin classes for P4 types (not builder pattern) - enables IDE autocomplete
- Constructor references over reflection
- `provideDelegate` for eager delegation
- Pre-commit hook as hard gate (subagents don't trigger Stop hooks)

## Lessons
- Local Kotlin classes capturing outer lambda vars break reflection; constructor refs handle this
- Subagents bypass parent's Stop hook - need structural guarantees (pre-commit hooks, AGENTS.md rules)
- Property delegation bridges native classes and AST registration
- `provideDelegate` is the correct pattern for eager delegation in Kotlin

## Sessions

- **session-00**: Daily log - Habermas, Pi Day declaration, P4kt kickoff, README review, VibeTensor, DSL ergonomics discussion
- **session-01**: P4kt project setup - Bazel, devcontainer, flat layout, `./dev` script
- **session-02**: Design, implementation, tooling, docs - v0.1 eDSL, TDD, formatters/linters, CI, golden tests, MkDocs
- **session-03**: VSS milestone - types, expressions, statements, actions (5 golden tests)
- **session-04**: Typed field access, controls, tables - native Kotlin classes, constructor refs, refactoring
- **session-05**: Complete VSS coverage - parser, extern, error, deparser, package instantiation (17/17 tests)
