# 2026 W12 (Mar 16–22)

Back to Z3Wire after the P4kt sprint. Major infrastructure and API maturation.

## Highlights

- Weave codegen tool: from design to working implementation in one session, then rewritten to C++
- Complete type naming overhaul across 40+ files
- CI modernized with devcontainers/ci and Bazel caching
- Dev environment simplified with devcontainer CLI
- Shift API redesigned with composable primitives
- Naming conventions established: `to_`/`as_`/`_cast`
- `to_concrete` completes the symbolic<->concrete round-trip
- Comprehensive API gap analysis against 5 libraries
- SInt storage simplified to signed type
- All usage docs restructured with overview tables and example files
- Wide BitVec (W > 64) for both unsigned and signed types
- Google FuzzTest integrated — found and fixed a real bug
- Rotation operations added (rotl/rotr)
- Formatter/linter stack overhauled: black→ruff, mdformat→dprint, pip→uv
- BuildBuddy remote cache for CI
- Explored Lean 4 for formalization and P4 eDSL design

## Days

- [03-16-mon](03-16-mon/README.md): Z3Wire Weave codegen tool, type naming redesign, CI overhaul, devcontainer CLI switch
- [03-17-tue](03-17-tue/README.md): Z3Wire API maturation — shift redesign, cast improvements, naming conventions, docs consolidation, new examples
- [03-18-wed](03-18-wed/README.md): Half sick day — Z3Wire API gap analysis, SInt signed storage simplification, docs refinement with overview tables and example files
- [03-19-thu](03-19-thu/README.md): Z3Wire API hardening (Z3W_CHECK, FromExpr), wide BitVec implementation, Google FuzzTest integration, extract fix, rotation ops
- [03-20-fri](03-20-fri/README.md): Z3Wire Weave C++ rewrite, formatter/linter overhaul (dprint), BuildBuddy remote cache, Lean 4 explorations, pre-commit framework research
- [03-21-sat](03-21-sat/README.md): Rest day — Weave module separated from core (CMake gating), P4buf concept brainstorm (deferred), DisplayLink docking station research
- [03-22-sun](03-22-sun/README.md): Repo organization design — defined 5 meta-layer repos with decision tests, personal website roadmap
