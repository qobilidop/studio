# Session 08 — eBPF Architecture Vertical Slice

Repo: `qobilidop/p4py` (github.com)
Base: `bec139b` → Head: `5f8b656` (13 commits)

## What happened

Added complete eBPF architecture support to P4Py as the second arch (after v1model). Full vertical slice: DSL → compile → emit → simulate → P4Testgen E2E validation.

### Key decisions

- **North star program**: `init_ebpf.p4` from p4c corpus (63 lines, stable P4Testgen support). Rejected `calc-ebpf.p4` — richer features but flaky in P4Testgen CI.
- **Approach B (lightweight dispatch)**: compiler, emitter, simulator all dispatch on pipeline type (`V1Switch` vs `ebpfFilter`). No abstract base class — YAGNI with only 2 arches. Shared infrastructure (AST→IR, parser, control execution) stays shared.
- **`pass_` not `pass`**: P4 original uses `pass` as control output param, but that's a Python keyword. Used `pass_` (valid in both Python and P4). Accepted the minor naming difference.
- **`p4.hex()` over heuristics**: User preferred explicit `p4.hex(0x0800)` for hex literal formatting rather than auto-detecting from value magnitude. Python AST loses hex/dec distinction, so explicit annotation is the only reliable approach.
- **Bazel patch for p4c**: BCR p4c module hardcodes `TESTGEN_TARGETS = ["bmv2"]`. Local patch (`bazel/patches/p4c_testgen_ebpf.patch`) adds `"ebpf"`. Filed p4lang/p4c#5573 upstream.

### New DSL/lang features (arch-neutral)

- `p4.bool` — P4's bool type (action params)
- `p4.NoAction` — built-in action sentinel
- `p4.hex(value)` — hex-formatted integer literal
- `const_entries` kwarg on `p4.table()`
- `implementation` kwarg on `p4.table()`

### New IR nodes

- `BoolType`, `ConstEntry`, `EbpfProgram`
- `TableDecl` extended with `const_entries` and `implementation` fields
- `IntLiteral` extended with `hex` flag
- `ActionParam.type` widened to `BitType | BoolType`

### Architecture module

- `src/p4py/arch/ebpf_model.py`: `hash_table()`, `array_table()`, `ebpfFilter` dataclass
- Pattern mirrors `v1model.py`: `_TableImpl` ↔ `_Extern`, `ebpfFilter` ↔ `V1Switch`

### Simulator changes

- `simulate()` dispatches → `_simulate_v1model()` / `_simulate_ebpf()`
- `control_locals` dict on `_SimState` for eBPF `pass_` output parameter
- `const_entries` matching in `_exec_table_apply`
- `NoAction` handled as built-in no-op
- `Assignment` handled in `_exec_control_statement` (eBPF apply body)
- `_run_parser` now returns terminal state string ("accept"/"reject")
- Field path resolution generalized (no longer hardcoded to `hdr.*`)

### Test results

- 21 local tests (unit + golden) all pass
- 4 P4Testgen-generated STF tests pass E2E in devcontainer
- p4c frontend validates emitted P4 (exit 0)

### Known gaps (cosmetic only)

- `pass_` vs `pass` in emitted P4 (Python keyword limitation)
- Brace/whitespace formatting differs from upstream style
- No copyright header emission

### Files created/modified

Key new files:
- `src/p4py/arch/ebpf_model.py`
- `tests/e2e/p4_16_samples/init_ebpf.py` + `.p4`
- `tests/unit/arch/test_ebpf_model.py`
- `tests/unit/sim/test_ebpf_sim.py`
- `bazel/patches/p4c_testgen_ebpf.patch`

Key modified files:
- `src/p4py/{compiler,backend,sim,ir,lang}` — all layers extended
- `MODULE.bazel` — `single_version_override` for p4c patch

### Future direction noted

User and I agreed: arch semantics (pipeline shape, execution model) should eventually live in `p4py.arch.*` as the single source of truth, not scattered across compiler/emitter/simulator dispatch. Need 3+ arches before the right abstraction is obvious.
