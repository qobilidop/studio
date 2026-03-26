# 2026-03-15 (Sunday)

## P4kt continued - architecture-as-library, Gradle, core.p4 completion, examples

### Session 01: Architecture-as-library, P4 object facade, p4include
- `P4.Library` base class for reusable architecture definitions
- `P4` object as single entry point (factories, constants, base classes)
- Reorganized: P4.kt (user API), Builders.kt (internals), Emit.kt (rendering)
- `p4kt.p4include` package: Core and V1model objects mirroring p4c's p4include/
- Operators moved from extension functions to member functions on P4Expr
- All imports explicit per Google Kotlin style
- Commits: 042013c, 73e4464, 9cbc204, a221c03

### Session 02: Gradle support, DSL improvements, core.p4 completion
- Dual build: Gradle 8.13 + Bazel both pass
- Restructured to Gradle-convention layout (src/main/kotlin/, src/test/kotlin/)
- Added `@P4DslMarker` to all builder classes
- Factory functions moved into P4 object: `p4Program` -> `P4.program` etc.
- Type parameters: `P4Type.Var`, `typeParam()` delegate, `returnType()`
- Delegate-based naming throughout Library and ExternBuilder
- `P4.ErrorDecl` with member(), `P4.MatchKindDecl` with member()
- `overload()` for method overloads via `MethodRef`
- `P4ExternFunction` for standalone extern functions
- **core.p4 is now 100% complete** — every construct from upstream p4c
- 10 commits: a221c03..c8cfd46

### Session 03: Examples, VSS arch completion, new DSL features
- `v1model_basic.kt` example from p4lang/tutorials
- Documented 4 future examples + blocking features in docs/examples.md
- `P4TypeDecl` IR for abstract parser/control/package type declarations
- `P4Include` IR for `#include` directives
- `IntBase` enum (DEC, HEX, OCT, BIN), `P4.hex()` factories, `SignedLit`
- Removed `P4Type.PacketIn/PacketOut` (they're core.p4 externs, not built-ins)
- Renamed `vss_arch` -> `vss` for consistency
- Added ergonomics assessment to docs/design.md
- 8 commits: 7361be6..5318dbd

### Session 00: Daily log
- Morning: long P4kt coding session
- Read Leo de Moura ETAPS interview (Z3 to Lean journey)
- Explored minimal instruction sets: OISC/Subleq, LMC, CHIP-8 (shelved for future)
- Learned Kotlin sealed classes and delegation (for P4kt work)
- Completed all Teyvat quests (Genshin Impact milestone)
- Bookmarked 谢赛宁 7-hour marathon interview (world models, AMI Labs, Ilya, LeCun, Fei-Fei Li)
- Ran out of energy, early sleep

## Key design decisions
- P4Expr stays outside P4 object (Kotlin typealiases don't support nested type access)
- Single p4kt package (tried split, IR types leak into user API)
- File organization by audience: P4.kt (user), Builders.kt (internal), Emit.kt (rendering)
- P4 naming convention for domain objects (lowercase/snake_case) per kotlinx.html precedent
- `ErrorDecl`/`MatchKindDecl` as nested objects with `register()` in `init {}`
- Multiple `init {}` blocks to control declaration ordering
- `P4Include` as `P4Declaration` - includes emitted in source order
- Libraries declare include path via constructor: `P4.Library(P4.systemInclude("core.p4"))`
- Unit tests use `P4.typeName()` not p4include refs to avoid dependency

## Open items
- Extern-level type params (register<T, I>, meter<I>)
- Enum IR (CounterType, MeterType)
- v1model.p4 completion
- Future examples: source_routing, firewall, calc, advanced_tunnel (blocked by header stacks, registers, hash, multi-field select)

## Sessions

- **session-00**: Daily log — morning P4kt coding, Leo de Moura interview, Kotlin learning (sealed classes, delegation), Teyvat completion, 谢赛宁 interview bookmark
- **session-01**: P4kt architecture-as-library, P4 object facade, p4include package (Core + V1model)
- **session-02**: Gradle build support, @P4DslMarker, type parameters, delegate-based naming, core.p4 100% complete
- **session-03**: v1model_basic example, P4TypeDecl, P4Include, hex literals, VSS arch completion, ergonomics assessment
