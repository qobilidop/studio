# Session 03 — P4Py tor.p4 Slice 5 (Routing)

Repo: `github.com:qobilidop/p4py.git`

## What happened

Designed, planned, and implemented tor.p4 Slice 5 — the routing pipeline (routing_lookup + routing_resolution). This was the hardest remaining slice, requiring 7 new language features.

## Brainstorming & design

- Fetched upstream `sai_p4/fixed/routing.p4` from sonic-net/sonic-pins via WebFetch.
- Scope decisions: TOR-expanded only (all `#if defined` resolved), macros inlined as expressions (not a compile-time eval system), annotations omitted.
- Decomposed into 2 sub-slices: 5a (routing_lookup, 5 new features) and 5b (routing_resolution, 2 new features).
- Macro handling discussion: decided to inline expressions with comments rather than building a preprocessor or compile-time function evaluation. User agreed this is YAGNI — preprocessor macros are a hard problem not worth solving yet.
- Spec: `.agent_workspace/specs/2026-04-04-tor-p4-slice5-design.md`
- Plan: `.agent_workspace/plans/2026-04-04-tor-p4-slice5-plan.md`

## Implementation (10 commits, all on main)

Used git worktree at `.agent_workspace/worktrees/slice5-routing/`, fast-forward merged to main.

### New language features
1. **`.apply().hit`** — `TableApplyHit` IR node + compiler (must precede generic Attribute handler in `_ast_to_expression`) + emitter
2. **`inout` action params** — `direction` field on `ActionParam`, compiler handles `p4.inout(type)` in action annotations (including `p4.bit(W)` inside directed type)
3. **File-scope actions** — `_ActionDecorator` in lang.py (extends `_Sentinel` + callable), `file_scope_actions` on Package IR + V1Switch, `_emit_file_scope_action` (no indent)
4. **Partial action application** — `ast.Call` in table action lists → `"name(arg)"` string in `TableDecl.actions`
5. **Action calling action** — already worked (verified with test)
6. **`action_selector`** — `ActionSelector` IR node, `_ActionSelector` in lang.py, `action_selectors` on ControlDecl, `_emit_action_selector` in emitter, `HashAlgorithm.identity` added to v1model
7. **`selector` match kind** — `p4.selector` added to lang.py

### Translations
- `tests/e2e/sai_p4/fixed/routing.py` — routing_lookup (5 tables, 7 actions, complex nested if/else with inline macros) + routing_resolution (5 tables, 10 actions, 6 local vars, action_selector)
- Wired into `tor.py` ingress: routing_lookup after l3_admit, routing_resolution after acl_ingress

### Gotchas
- Compiler reads Python AST, not runtime values. Variable references (e.g., `WCMP_GROUP_SUM_OF_WEIGHTS_SIZE_TOR`) in `p4.action_selector()` args fail because `ast.Name` has no `.value`. Fix: use literal values in the translation.
- Same issue for `p4.bit(BITWIDTH_CONSTANT)` in local var declarations and `p4.cast(p4.bit(PORT_BITWIDTH), ...)`. All replaced with literals.
- Bazel OOM in dev container when running `//...` — fell back to `//tests/unit/... //tests/e2e/sai_p4:tor_golden_test //tests/e2e/sai_p4:wbb_golden_test`.

## Final state

- 59 tests passing (was 53), golden file 1351 lines (was 1069)
- 16 controls in tor.p4 (was 14)
- Only Slice 6 (egress) remains
- Memory updated: `project_tor_p4_progress.md`, `project_p4mini_complete.md`

## Decisions for future reference

- Inline macros approach was right — keeps compiler simple, YAGNI on preprocessor
- TOR-expanded-only avoids designing a conditional compilation system
- Worktree workflow worked well for isolation + clean merge
- User prefers linear history (fast-forward merge)
