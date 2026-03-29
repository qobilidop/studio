# Session 03 — P4Py project org + LPM/metadata/switch features

Repo: github.com/qobilidop/p4py

## Project organization changes

- Added CI badges to README (Dev Container, Bazel, Lint, Docs)
- Replaced `docs/roadmap.md` with `docs/p4-spec-coverage.md` + `docs/v1model-coverage.md` — tables mapping supported P4 constructs to spec sections, with links to P4-16 spec anchors
- Included `docs/` in dprint formatting (was previously excluded; MyST toctree survives fine)
- Migrated devcontainer from pip/virtualenv to uv: `uv tool install` for ruff/sphinx, `uv run --group test pytest` for testing
- Added `[dependency-groups] test = ["pytest>=8.0"]` to pyproject.toml
- Fixed build-backend from `setuptools.backends._legacy:_Backend` to `setuptools.build_meta`
- Rebased merge commit in git history to linear; set `git config pull.rebase true`
- Reorganized `e2e_tests/` → `examples/` (curated programs) + `tests/infra/` (STF runner, macros)
- Reorganized `tests/` into `tests/unit/`, `tests/e2e/`, `tests/infra/`
- E2e tests fully decoupled from examples (own copies of .py/.p4 files)
- Added `tests/e2e/README.md` documenting test types (golden, diff, testgen, sim)
- Created `tests/e2e/p4_16_samples/` for tests adapted from p4lang/p4c corpus
- Cleaned up `.gitignore` (removed stale superpowers/worktrees entries, added uv.lock/.venv, reordered Python section)
- CLAUDE.md now references shared AGENTS.md via `@AGENTS.md`

## New language features

### LPM match kind
- `p4.lpm` sentinel in lang surface
- IR/compiler/backend already handled arbitrary match kinds generically
- Simulator: refactored `_exec_table_apply` to return action name, added `_entry_matches()` with match-kind-aware logic, `_resolve_field_width()` for prefix mask computation
- LPM entries use `prefix_len` dict in table_entries format

### Metadata struct with bit<W> fields
- `struct` now accepts both header subclasses and `BitType` annotations
- `StructMember.type` changed from `str` (`header_type_name`) to `BitType | str`
- Compiler uses `hasattr(ann, "width")` to distinguish lang BitType from header classes (two separate BitType classes exist in lang vs IR)
- Simulator initializes metadata dict from struct definitions, supports `meta.field` read/write
- Backend emits `bit<W>` or header type name per member

### Switch on action_run
- DSL syntax: `match table.apply(): case "action_name": ...`
- New IR nodes: `SwitchAction`, `SwitchActionCase`
- Compiler recognizes `ast.Match` with `Call` subject (`table.apply()`)
- Backend emits `switch (table.apply().action_run) { action_name: { ... } }`
- Simulator: `_exec_table_apply` returns action name, `SwitchAction` handler branches on it

### Empty actions
- `pass` in action body → compiler returns None, filtered out in body tuple

## basic_routing-bmv2 aspirational target
- File: `tests/e2e/p4_16_samples/basic_routing_bmv2/basic_routing_bmv2.py`
- Adapted from `p4lang/p4c testdata/p4_16_samples/basic_routing-bmv2.p4`
- Currently implements: ethernet/ipv4 parsing, ipv4_fib exact → ipv4_fib_lpm fallback via switch on action_run, nexthop table with metadata field, TTL decrement
- Remaining TODOs in file: egress control, port_mapping/bd tables (std_meta as table key), checksum externs
- Tests: golden test + 4 simulator e2e tests (exact hit, LPM fallback, no route, non-IPv4)

## p4c corpus assessment
- Most p4c test programs use features beyond P4Mini (casts, slicing, LPM, typedef, header_union, varbit)
- `basic_routing-bmv2.p4` was the best aspirational target
- STF runner doesn't support LPM prefix notation (`/24`) yet — BMv2 diff/testgen tests blocked

## Test count: 67 → 101

## Key decisions
- No separate `examples/` for new features; use e2e tests for p4c corpus
- Flat `examples/` rejected; nested dirs better because each example has multiple artifacts
- `tests/e2e/` not `tests/integration/` — "e2e" is unambiguous
- Logo design attempted (SVG) but hand-coded SVG doesn't look good; deferred to Figma/AI tools
- dprint safe for docs/ — only risk was MyST toctree, which survived
- uv.lock not committed (library-ish project)
