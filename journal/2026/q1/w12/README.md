# 2026 W12 (Mar 16–22)

Back to Z3Wire after the P4kt sprint. Massive week of API maturation, infrastructure modernization, and Weave codegen evolution from Python prototype to separated C++ module.

## Days

- [03-16-mon](03-16-mon/README.md): Weave codegen tool design+implementation, type naming overhaul (40+ files), CI modernization, devcontainer CLI
- [03-17-tue](03-17-tue/README.md): Shift API redesign, naming conventions (to_/as_/_cast), to_concrete, exact_eq removal, docs overhaul
- [03-18-wed](03-18-wed/README.md): Half day (sick); API gap analysis, SInt signed storage, usage docs restructured with overview tables
- [03-19-thu](03-19-thu/README.md): API hardening (Z3W_CHECK, FromExpr), wide BitVec (W > 64), Google FuzzTest (found real bug), rotation ops
- [03-20-fri](03-20-fri/README.md): Weave Python-to-C++ rewrite, formatter/linter overhaul, BuildBuddy remote cache, Lean 4 exploration
- [03-21-sat](03-21-sat/README.md): Rest day; Weave module separation from core, P4buf concept brainstorm, DisplayLink research
- [03-22-sun](03-22-sun/README.md): Operations doc overhaul with typing rules, replace op, mixed-signedness arithmetic fix, multi-repo organization design

## Agent index

- EVOLUTION: Weave codegen — Mon: designed+implemented in Python -> Fri: rewritten to C++ (Abseil+protobuf) -> Sat: separated to top-level `z3wire_weave/` with CMake gating
- EVOLUTION: type system — Mon: naming overhaul (Sym prefix) -> Tue: naming conventions (to_/as_/_cast) -> Wed: SInt signed storage -> Thu: wide BitVec + type_traits.h -> Sun: mixed-signedness arithmetic rules
- EVOLUTION: CI/tooling — Mon: devcontainers/ci + disk cache -> Fri: ruff/dprint/uv replace black/mdformat/pip, BuildBuddy remote cache, cmake compile_commands for lint
- PATTERN: API minimalism throughout week — removed exact_eq (Tue), removed bit<N>() (Sun), removed Codecov (Fri), checked shifts (Tue); YAGNI principle consistently applied
- PATTERN: fuzz testing pays off — Thu: Google FuzzTest found real SInt<64> to_concrete bug on first integration
- CROSS-REF: naming conventions established Tue (to_/as_/_cast) used consistently through rest of week
- CROSS-REF: wide BitVec (Thu) motivated by Weave use case (registers > 64 bits)
- OPEN: Weave — Unpack(), Bazel rule, multi-file imports
- OPEN: Z3Wire v0.1.0 release — multiply, division/remainder, safety fixes, `implies` operator
- OPEN: P4buf — P4 subset as IDL, deferred until Z3Wire v0.1.0
- OPEN: SMT Arena — differential testing of SMT solvers, shelved
- OPEN: P4 eDSL in Lean 4 — promising direction, paused
- DESIGN: multi-repo organization (Sun) — 5 meta-layer repos (Cyborg, Artisan, Hermit, Clert, Website) with decision tests
- HEALTH: Wed sick half day, Sun headache reduced productivity — physical condition affected output twice this week
