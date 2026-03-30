# P4Py arch-agnostic refactoring + module cleanup

Repo: github.com/qobilidop/p4py
Branch: main
Base: 5f8b656, Head: de490be (13 commits)

## What happened

Major refactoring session to make P4Py arch-agnostic. Started with brainstorming, produced a design spec, then implementation plan, then executed via subagent-driven development.

### Arch-agnostic refactoring (9 commits)

**Problem:** Arch-specific code (v1model, eBPF) leaked into compiler, emitter, simulator through isinstance checks, hardcoded externs (`mark_to_drop`), and dual IR types (`Program`/`EbpfProgram`).

**Solution:**
- Unified IR: `Package` replaces `Program`/`EbpfProgram`. `BlockEntry` wraps named pipeline blocks. `ChecksumVerify`/`ChecksumUpdate` removed (now `FunctionCall` + `ListExpression`).
- `Architecture` ABC in `arch/base.py`: `include`, `pipeline` (ordered `BlockSpec`), `block_signature()`, `main_instantiation()`, `emit_boilerplate()`, `process_packet()`.
- `SimEngine` in `sim/engine.py`: shared execution primitives + extern registry. Archs call `engine.register_extern(name, handler)`.
- Compiler iterates `arch.pipeline`, returns `Package`. Zero arch imports.
- Emitter delegates signatures/boilerplate/main to arch. Zero arch imports.
- `simulate()` is thin wrapper: `package.arch.process_packet(package, SimEngine, ...)`.
- v1model: 6-stage pipeline, `mark_to_drop`/`verify_checksum`/`update_checksum` externs.
- eBPF: 2-stage pipeline (parser + filter), bool output for accept/drop.

**Key design decisions:**
- `core.p4` (extract, emit, isValid) = language built-ins, stay in engine. Arch externs go in arch modules.
- Extern call convention: handler receives `(engine, stmt)` where stmt is raw `FunctionCall` IR node. Handler calls `engine.eval_expression()` etc. as needed.
- `std_meta` field paths still pattern-matched in engine (routes to metadata dict). Acceptable leakage for now.
- `_get_block(package, name)` helper duplicated in v1model.py and ebpf_model.py (3 lines, not worth abstracting).

### Module cleanup (2 commits)

Flattened single-file packages:
- `ir/nodes.py` → `ir.py`
- `lang/__init__.py + _blocks.py + _types.py` → `lang.py`
- `compiler/compiler.py` → `compiler.py`
- `backend/p4.py` → `emitter/p4.py` (renamed to allow future targets)
- `sim/simulator.py` merged into `sim/__init__.py`

Scrubbed all "P4Mini" references.

### Cleanup + docs (2 commits)

- Removed stale `__all__`, renamed `tests/unit/backend/` → `tests/unit/emitter/`
- Updated `architecture.md`, `p4-spec-coverage.md`, `v1model-coverage.md`
- Created `ebpf-model-coverage.md`

## Artifacts

- Design spec: `.agent_workspace/specs/2026-03-29-arch-agnostic-design.md`
- Implementation plan: `.agent_workspace/plans/2026-03-29-arch-agnostic.md`

## Test status

29/29 tests pass (24 unit/infra + 5 E2E golden/p4testgen/STF).

## Gotchas encountered

- Golden tests failed after refactoring because emitter output ordering changed (blocks emitted before boilerplate instead of interleaved in pipeline order). Fixed by iterating `arch.pipeline` in order.
- Checksum call formatting changed (single-line vs multi-line). Added `_emit_multiline_function_call()` for FunctionCall nodes containing ListExpression.
- `v1model.HashAlgorithm.csum16` module prefix leaked into emitted P4. Fixed by stripping module prefix from keyword arg FieldAccess values in compiler.
- `p4testgen_runner.py` still imported `EbpfProgram`. Fixed to use `isinstance(program.arch, EbpfFilterArch)`.
- Tests can't run outside devcontainer (no pytest). Use `./dev.sh bazel test //...`.
