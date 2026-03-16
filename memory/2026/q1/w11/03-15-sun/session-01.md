# P4kt: Architecture-as-Library, DSL Reorganization, p4include

**Repo:** github.com/qobilidop/p4kt
**Duration:** Long session, ~4 hours of iterative design + implementation
**Model:** Claude Opus 4.6 (1M context)

## What happened

Three major features implemented via iterative design discussion and TDD:

### 1. Architecture-as-library (`042013c`)
- Added `ProgramBuilder.declare()` to register pre-built IR nodes
- Added `P4Const.ref` property for referencing constants outside builders
- Created `P4.Library` abstract base class that tracks declarations in source order, with `typedef()`, `const_()`, `struct()`, `header()`, `extern()`, `errors()` methods and `toP4()`
- Converted `vss_arch` from inline `p4Program {}` to `object vss_arch : P4.Library()`
- `vss_example` imports shared types via qualified refs (`vss_arch.PortId`, `vss_arch::InControl`, `vss_arch.DROP_PORT.ref`)
- Converted from `extra_srcs` to proper Bazel library target for vss_arch

### 2. P4 object facade + file reorganization (`73e4464`)
- Created `P4` object as single entry point for DSL: factories (`P4.bit`, `P4.lit`), constants (`P4.IN`, `P4.LPM`), base classes (`P4.StructRef`, `P4.HeaderRef`, `P4.Library`)
- Moved operators from extension functions to member functions on `P4Expr` (eq, ne, minus, call)
- `P4.StructRef` also has member `call()` for ergonomics
- Reorganized into 3 files by audience: P4.kt (user API), Builders.kt (internals), Emit.kt (rendering)
- Removed Ir.kt and Dsl.kt (contents split between P4.kt and Builders.kt)
- Made `P4Program.toP4()` a member function (no import needed)
- Removed unused P4kt.kt version constant
- All imports now explicit (`import p4kt.P4`, `import p4kt.p4Program`) per Google Kotlin style

### 3. p4kt.p4include (`9cbc204`, `a221c03`)
- Created `p4kt.p4include` package mirroring p4c's p4include/
- `Core` object (P4.Library): error codes, packet_in/packet_out externs
- `V1model` object (P4.Library): PortId_t typedef, standard_metadata_t struct, action_profile/action_selector externs
- Most V1model constructs noted as TODO (need type parameters, enum IR)
- `vss_example` updated to use `Core.packet_in`/`Core.packet_out`
- Golden tests for both (core.p4, v1model.p4)
- Enabled TODO comments in detekt config

## Key design decisions

- **P4Expr stays outside P4 object**: Kotlin typealiases don't support nested type access (`P4Expr.Ref` wouldn't work via typealias to `P4.Expr`). Users write `P4Expr` not `P4.Expr`.
- **Single p4kt package**: Tried `p4kt` + `p4kt.dsl` split but IR types leak into user API, creating artificial boundary. Flattened back to one package.
- **File organization by audience**: P4.kt = user-facing, Builders.kt = internal, Emit.kt = rendering. No Ir.kt needed.
- **P4Program.toP4() as member function**: Avoids needing `import p4kt.toP4` since member functions don't need import. P4.Library.toP4() chains through it.
- **p4include naming**: `Core` (PascalCase per Kotlin convention), golden files use P4 naming (core.p4, v1model.p4)

## Commit history (clean, squashed)

```
a221c03 Add p4kt.p4include.V1model with supported subset of v1model.p4
9cbc204 Add p4kt.p4include.Core mirroring core.p4
73e4464 Add P4 object facade and reorganize into clean file layout
042013c Add architecture-as-library with P4.Library base class
```

## What's next

- Type parameters (`<H>`, `<T>`) for generic declarations (blocks most p4include progress)
- Enum IR support (needed for V1model CounterType, MeterType, etc.)
- Abstract parser/control/package declarations
- `#include` directive generation
- Hex literal rendering

## Test count: 20

14 unit tests + 2 example golden tests + 2 CoreTest/V1modelTest + 2 golden tests (core.p4, v1model.p4)
