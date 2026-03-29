# P4Py: Diff testing and p4testgen integration

Repo: `github.com/qobilidop/p4py` (branch: `main`)

## What happened

Built two kinds of e2e diff tests that verify P4Py simulator matches BMv2:

1. **Hand-written STF diff test** (`e2e_tests/basic_forward/basic_forward_diff_test.py`)
   - Created `basic_forward.py` — P4Py DSL equivalent of `basic_forward.p4` (L2 forwarder)
   - Added `stf_to_sim_inputs()` adapter in `stf_runner.py` — translates STF commands into simulator's `table_entries`/packet format, stripping `MyIngress.` control-block prefixes
   - Diff test compiles P4Py → IR → P4-16, runs `basic_forward.stf` through both simulator and BMv2, asserts agreement
   - Commit: `76d182a`

2. **p4testgen diff test** (`e2e_tests/basic_forward/basic_forward_testgen_test.py`)
   - Runs `p4testgen --target bmv2 --arch v1model --test-backend stf --max-tests 0` on emitted P4-16
   - Generates 5 STF tests covering all program paths (forward, drop, default action, parse failure)
   - Runs each generated STF through both simulator and BMv2
   - Fixed `$` end-of-packet marker handling in both `stf_to_sim_inputs` and `run_stf_test`
   - Commit: `00d83ba`

## Key decisions

- `.stf` file is the single source of truth for test scenarios (not generated from Python)
- STF-to-sim adapter strips control-block prefixes (`MyIngress.foo` → `foo`) since simulator uses short names
- p4testgen available in devcontainer via `p4lang-p4c` apt package
- QEMU core dumps happen intermittently (ARM Mac + amd64 container) — `core` file appeared, deleted manually

## Files created/modified

- `e2e_tests/stf_runner.py` — `SimPacket`, `SimExpect`, `SimInputs` dataclasses + `stf_to_sim_inputs()` + `$` fix in `run_stf_test`
- `e2e_tests/stf_runner_test.py` — 5 new tests for adapter
- `e2e_tests/basic_forward/basic_forward.py` — P4Py DSL program
- `e2e_tests/basic_forward/basic_forward_diff_test.py` — hand-written STF diff test (~8s)
- `e2e_tests/basic_forward/basic_forward_testgen_test.py` — p4testgen diff test (~38s)
- `e2e_tests/basic_forward/BUILD.bazel` — new Bazel targets

## Notes

- 3 pre-existing test failures on main (TTL assertion in IPv4 forwarder sim tests) — unrelated to this work
- `pytest testpaths` only includes `tests/`, not `e2e_tests/` — e2e tests run explicitly
- Consider adding `core` to `.gitignore`
