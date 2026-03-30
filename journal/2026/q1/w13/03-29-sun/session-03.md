# Session 03 — P4Py: sai_p4 wbb.p4 translation

Repo: github.com:qobilidop/p4py.git
Branch: main
Commits: e1fb4fe..4bf5ece (25+ commits)
Duration: long session, full feature implementation cycle

## Goal

Translate sonic-net/sonic-pins `sai_p4/instantiations/google/wbb.p4` into P4Py as a north star for production-grade P4 programs.

## What was built

### New DSL features (Slice 1: data model)
- `p4.typedef(bit, name)` → `TypedefDecl` IR → emits `typedef bit<W> name;`
- `p4.newtype(bit, name)` → `NewtypeDecl` IR → emits `type bit<W> name;`
- `p4.enum(bit)` base class → `EnumDecl` IR → emits `enum bit<W> Name { ... };`
- `p4.const(type, value, name)` → `ConstDecl` IR → emits `const type name = value;`
- `Package.declarations` field for explicit registration of types for emission
- `HeaderField.type_name` for emitting named types (`ethernet_addr_t` instead of `bit<48>`)
- `StructMember` extended to accept `BoolType` and named types
- `V1Switch.declarations` parameter

### New DSL features (Slice 2: table features)
- `p4.optional` match kind
- `v1model.direct_counter(type)`, `v1model.direct_meter(result_type, type)`
- `v1model.clone(CloneType, session_id)`, `v1model.CloneType.I2E`
- `ControlDecl.direct_counters`, `direct_meters`, `local_vars` fields
- `TableDecl.counters`, `meters` fields
- `LocalVarDecl` IR node for control-scoped variables
- Generalized `IfElse.condition` (was `IsValid`-only, now any `Expression`)
- `else if` chain emission
- `isValid()` as table key (`TableKey.field` accepts `IsValid`)

### Parameter directions and sub-controls
- `p4.in_`, `p4.out_`/`p4.out`, `p4.inout_`/`p4.inout` direction wrappers
- `p4.in` via module `__getattr__` (keyword workaround)
- `V1Switch.sub_controls` for controls referenced by pipeline blocks
- `Package.sub_controls` IR field
- Sub-control compilation, emission with direction-annotated signatures
- Sub-control simulation (dispatches `_run_control` on sub-control apply)

### Clone simulation
- `SimResult.clone_outputs` for multiple output packets
- `simulate()` accepts `clone_session_map: dict[int, int]`
- v1model clone handler: records intent during ingress, produces clone output after
- STF runner: parses `mirroring_add`, handles multiple expects
- `init_state()` extended for BoolType, typedef, newtype, enum metadata members

### Test files
- `tests/e2e/sai_p4/` directory structure mirroring upstream:
  - `fixed/headers.py` (14 headers, 5 typedefs, 2 consts)
  - `fixed/metadata.py` (2 enums, 10 newtypes, 4 typedefs, 1 const, 3 structs incl ~50-field local_metadata_t)
  - `instantiations/google/bitwidths.py`, `acl_wbb_ingress.py`, `wbb.py`
  - `wbb.p4` golden file, `wbb.stf` hand-written STF test
- Hand-written STF tests for all p4_16_samples (5 new files)
- Unit tests: `test_declarations.py`, `test_typedef.py`, `test_declarations_emit.py`

### Lint fixes
- Updated `pyproject.toml` ruff per-file-ignores for P4 naming conventions (N801, N802, N806, N815, N816, E741, E501, SIM102, SIM114)

## Key decisions

- **PLATFORM_BMV2 target**: wider bitwidths (256-bit for translated types), packet_in_header in headers_t
- **Explicit declaration registration** (not automatic discovery) — user lists types in `V1Switch(declarations=(...))`. Automatic discovery deferred.
- **Annotations deferred** — no `@id`, `@sai_action`, `@controller_header`, `@field_list`, etc.
- **`p4.newtype` over `p4.type`** — avoids shadowing Python builtin `type`
- **Counters/meters on v1model** — they're v1model externs, not core P4
- **Sub-control approach**: explicit `sub_controls` on V1Switch, compiler/emitter handle them separately from pipeline blocks
- **Clone sim**: deferred execution model (record intent, produce output after ingress)
- **Module constants in DSL**: use literal values directly (compiler can't resolve Python module-level names from AST); `COPY_TO_CPU_SESSION_ID = 255` → just use `255`

## Compiler fixes discovered during integration
- `acl_wbb_ingress_meter.read()` was hitting "module-qualified function" path → added `control_locals` set to distinguish object method calls from module calls
- `v1model.CloneType.I2E` in args not stripped of module prefix → added arg-level prefix stripping
- `p4.NoAction` as `default_action` → `ast.Attribute` not handled (only `ast.Name`)
- Header deduplication needed (same header class used in multiple struct positions)
- `$valid$` → `isValid()` normalization in STF key names
- `init_state()` only handled `BitType` metadata → missed `BoolType`, named types, enum

## Test suite: 38 → 48 tests

## Files changed (key)
- `src/p4py/ir.py` — TypedefDecl, NewtypeDecl, EnumMember, EnumDecl, ConstDecl, DirectCounter, DirectMeter, LocalVarDecl; extended HeaderField, StructMember, TableKey, TableDecl, ControlDecl, Package
- `src/p4py/lang.py` — _NamedType, typedef, newtype, enum, const, _Direction, _DirectedType, optional match kind; extended header/struct validation
- `src/p4py/compiler.py` — declarations, sub-controls, named types, control locals, else-if, isValid table keys, counters/meters
- `src/p4py/emitter/p4.py` — declarations emission, sub-control emission, named type fields, BoolType structs, counters/meters/else-if
- `src/p4py/arch/v1model.py` — direct_counter, direct_meter, clone, CloneType, sub_controls, clone_session_map
- `src/p4py/sim/engine.py` — optional match, clone/counter/meter handling, sub-control apply, isValid table keys, control local widths, named type init

## Next steps identified
- Sub-control instantiation could be automated (discover from AST instead of explicit list)
- Automatic declaration discovery (walk type references transitively)
- Parameter directions consistently in all P4Py programs
- P4 annotations support (needs own design)
- Conditional compilation for second sai_p4 instantiation (tor.p4)
- Clone simulation could be richer (E2E, field preservation)
- Upstream p4c eBPF testgen patch: p4lang/p4c#5575
