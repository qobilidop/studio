# P4Mini: Spec → Implementation

Repo: https://github.com/qobilidop/p4py (branch: main)

## What happened

Designed and implemented the complete P4Mini milestone for P4Py — from brainstorming the language spec through to working code on main.

### Phase 1: P4Mini spec (brainstorming)

Wrote `docs/superpowers/specs/2026-03-27-p4mini-design.md` defining the P4 language subset:

- **Types**: `bit<W>`, `header` (flat, bit fields only), `struct` (contains headers, or empty)
- **Parser**: named states, `extract`, `transition`, `transition select` (single field, literals + default)
- **Tables**: `exact` match only, action list, `default_action`. No `size`, no `const entries`.
- **Actions**: direction-less params, assignment, `+`/`-` arithmetic
- **Control apply**: `table.apply()`, `if`/`else` (condition restricted to `isValid()`), direct action calls
- **v1model**: `V1SwitchMini(Parser, Ingress, Deparser)` — emitter generates full V1Switch boilerplate. `standard_metadata_t` with `ingress_port`/`egress_spec`. `mark_to_drop` as only extern.
- **core.p4**: `packet_in.extract()`, `packet_out.emit()`, `match_kind.exact` as built-ins

Key design decisions from discussion:
- `import p4py.lang as p4` idiomatic import → `p4.bit(48)`, `p4.header`, etc.
- Lowercase type names (`header`, `struct`) matching P4 keywords, not Python PascalCase
- IR (not AST) as the canonical internal representation name
- Code org: `p4py.lang`, `p4py.ir`, `p4py.compiler`, `p4py.arch`, `p4py.backend`, `p4py.sim`
- `mark_to_drop` stays as extern (not replaced by raw metadata assignment) — we don't hardcode BMv2 internals
- Test program: IPv4 forwarder with 2 headers, transition select, isValid + if/else, exact table, TTL decrement

### Phase 2: Implementation plan

Wrote `docs/superpowers/plans/2026-03-27-p4mini.md` with 8 tasks, complete code in each.

### Phase 3: Subagent-driven development

Executed plan using subagent-driven-development in a git worktree (`.worktrees/p4mini`, branch `feature/p4mini`). Per task: dispatch implementer → spec review → code quality review.

Commits (all now on main via merge commit `461e8bc`):
1. `a1bbabc` IR node types — 25 frozen dataclasses
2. `fa3988b` Language types — bit(W) with lru_cache, header/struct via __init_subclass__
3. `5b1aa0d` Language surface + v1model — decorators capture source, sentinels for AST recognition
4. `359c48a` Compiler — Python AST parsing, match→TransitionSelect, @p4.action→ActionDecl, p4.table()→TableDecl
5. `05c7dd7` P4-16 backend — IR traversal to valid v1model .p4 source
6. `9658093` Simulator — bit-level packet parsing, exact-match table lookup, deparsing
7. `62c6533` Integration test — IPv4 forwarder end-to-end (compile + emit + simulate)

12 tests total, all passing.

## Issues encountered

- Subagent implementers sometimes failed to `git commit` — had to commit manually after verifying files were present
- `import pytest` breaks in Bazel `py_test` sandbox — no `@pip//pytest` dep exists. Use `try/except` instead of `pytest.raises()`
- `from __future__ import annotations` breaks `header.__init_subclass__` because annotations become strings instead of runtime BitType instances
- Code quality reviewer caught: `ArithOp` silently mapped all non-Add operators to `"-"` — fixed to explicitly check `ast.Sub` and raise on others
- Pylance warnings on `bit(9)` as type annotation in `standard_metadata_t` — expected, DSL design trade-off

## Artifacts

- Spec: `docs/superpowers/specs/2026-03-27-p4mini-design.md`
- Plan: `docs/superpowers/plans/2026-03-27-p4mini.md`
- Memory updated: `project_p4mini_complete.md`, `feedback_bazel_pytest.md`
