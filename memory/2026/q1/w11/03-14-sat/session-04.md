# P4kt: Typed Field Access, Controls, Tables, and Polish

Repo: github.com/qobilidop/p4kt

## What happened

Major ergonomics overhaul of the P4kt DSL in a single long session. Started with the user's complaint that `outCtrl.dot("outputPort")` is ugly compared to P4's `outCtrl.outputPort`.

### Typed field access (the big design shift)

- Brainstormed approaches: string-based, code generation, Kotlin classes directly, Verik-style transpiler
- Researched Jetpack Compose (scoped receivers, no codegen for type safety) and Verik (Kotlin-to-SystemVerilog transpiler, stub classes with real properties)
- Settled on Option A: P4 struct/header types become Kotlin classes extending `StructRef`/`HeaderRef` with real properties
- Key design: `class OutControl(base: P4Expr) : StructRef(base) { val outputPort by field(PortId) }`

### Reflection vs constructor references (critical discovery)

- Initially used `kotlin-reflect` with `T::class.constructors.first().call(base)` for instantiation
- Hit a wall: local classes that capture variables from enclosing lambda scope get extra hidden constructor parameters, breaking reflection
- Solution: replaced reflection with constructor references (`::ClassName`). These handle captures correctly because the compiler binds captured variables automatically
- Removed `kotlin-reflect` dependency entirely, reverted `@PublishedApi internal` back to `private`
- API: `struct(::OutControl)`, `param(::OutControl, INOUT)` instead of `struct<OutControl>()`, `param<OutControl>(INOUT)`

### TypedFieldDelegate for nested structs

- Added `fun <T : StructRef> field(factory: (P4Expr) -> T)` on StructRef
- Enables `headers.ip.ttl` chained access through real Kotlin properties
- `Parsed_packet` can now use `val ip by field(::Ipv4_h)` instead of `val ip by field(typeName("Ipv4_h"))`

### Control blocks and tables

- Added `P4Control`, `P4Table`, `P4KeyEntry`, `MatchKind`, `P4LocalVar` IR nodes
- Added `P4Statement.MethodCall` and made `P4Statement.Return.expr` nullable
- Built `ControlBuilder`, `TableBuilder`, `P4TableRef`, delegates
- `apply_()` is a `StatementBuilder` extension on `P4TableRef` - adds directly to body like `assign()` and `return_()`

### Output polish

- Removed redundant parentheses: `BinOp` only wraps in parens when nested inside another `BinOp`
- `if (outCtrl.outputPort == DROP_PORT)` instead of `if ((outCtrl.outputPort == DROP_PORT))`

### Refactoring

- Split `Dsl.kt` (445 lines) into `Dsl.kt` (120 lines, user-facing API) + `Builders.kt` (280 lines, implementation)
- Consolidated 5 ad-hoc examples into 2 matching VSS reference programs: `vss_arch.kt` and `vss_example.kt`
- Consolidated 12 milestone docs into single `docs/design.md` with construct status table
- Added design principles: ergonomics first, IDE support non-negotiable, small and useful over complete

## Key files

- `p4kt/Dsl.kt` - user-facing DSL: constants, factories, operators, StatementBuilder, StructRef/HeaderRef
- `p4kt/Builders.kt` - implementation: delegates, builders, ProgramBuilder
- `p4kt/Ir.kt` - IR nodes including P4Control, P4Table, MatchKind, P4LocalVar
- `p4kt/Emit.kt` - renderers for all IR nodes
- `examples/vss_example.kt` - full TopPipe control with 5 actions, 4 tables, apply block
- `docs/design.md` - design doc with VSS construct status table

## What's next

Parser, extern, and deparser to complete VSS coverage:
- Parser blocks (states, transitions, select)
- Extern declarations and instantiation (Ck16 checksum)
- Method-call expressions (`ck.get()` returning a value)
- Error declarations
- Package instantiation

## Lessons

- Local classes capturing outer lambda variables break reflection-based instantiation. Constructor references (`::ClassName`) are the correct Kotlin pattern for this.
- `@file:Suppress("TooManyFunctions")` for Emit.kt when it grows past detekt's threshold
- `docs/superpowers/` is gitignored - use it for spec/plan working documents
- User strongly values ergonomics and IDE support. String-based APIs are unacceptable. Every API decision should optimize for how natural the DSL reads.
