# 2026-03-20 (Friday)

Massive Z3Wire infrastructure day plus wide-ranging explorations.

## Highlights

- Weave rewritten from Python to C++ (~800 → ~1200 lines)
- Formatter/linter stack overhauled: black→ruff, mdformat→dprint, pip→uv
- BuildBuddy remote cache added for CI
- CMake build extended to cover weave (8 tests total)
- Explored Lean 4 for formalization and P4 eDSL design
- Decided on dprint as project-wide formatter
- Learned about pre-commit framework

## Sessions

- **session-00**: Daily log — SMT Arena brainstorm (shelved), Lean 4 deep dive (self-hosting, eDSLs, P4 DSL design), formatting tools research (dprint chosen, mdformat-mkdocs for docs, pre-commit framework)
- **session-01**: Z3Wire CI & tooling overhaul — Z3 version pinning, formatter/linter stack replacement, BuildBuddy remote cache, Codecov fix, PR check workflows
- **session-02**: Z3Wire Weave C++ rewrite, CMake build extension, test reorg, lint overhaul with cmake compile_commands.json, build config cleanup
