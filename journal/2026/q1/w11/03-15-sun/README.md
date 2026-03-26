# 2026-03-15 (Sunday)

Continued P4kt development: added architecture-as-library pattern, Gradle build support, completed core.p4 100%, added type parameters, `#include` support, and hex literals. Leisurely daily log with reading and Genshin Impact milestone.

## Sessions

- **session-00**: Daily log (Gemini) -- morning P4kt coding, Leo de Moura ETAPS interview (Z3 to Lean journey), minimal instruction sets exploration (OISC/Subleq, LMC, CHIP-8 -- shelved), Kotlin sealed classes and delegation learning, completed all Teyvat quests (Genshin Impact), bookmarked 谢赛宁 7-hour interview
- **session-01**: P4kt -- architecture-as-library (`P4.Library` base class), `P4` object facade as single entry point, file reorg by audience (P4.kt/Builders.kt/Emit.kt), `p4kt.p4include` package (Core + V1model), explicit imports per Google Kotlin style
- **session-02**: P4kt -- Gradle 8.13 build support (dual Bazel+Gradle), `@P4DslMarker`, factory functions into P4 object, type parameters (`P4Type.Var`, `typeParam()`), delegate-based naming, `ErrorDecl`/`MatchKindDecl` with member(), method overloads via `MethodRef`, `P4ExternFunction`, core.p4 100% complete
- **session-03**: P4kt -- `v1model_basic.kt` example from p4lang/tutorials, `P4TypeDecl` IR for abstract declarations, `P4Include` for `#include` directives, `IntBase` enum (DEC/HEX/OCT/BIN), `P4.hex()` factories, removed PacketIn/PacketOut (they're core.p4 externs), ergonomics assessment in docs

## Agent index

- P4.Library base class: tracks declarations in source order; typedef/const_/struct/header/extern/errors methods; toP4() chains through P4Program (session-01)
- P4 object facade: single entry point for DSL (factories, constants, base classes); operators moved to member functions on P4Expr (session-01)
- file organization by audience: P4.kt (user-facing), Builders.kt (internal), Emit.kt (rendering); Ir.kt and Dsl.kt removed (session-01)
- P4Expr stays outside P4 object -- Kotlin typealiases don't support nested type access (session-01)
- single p4kt package -- tried split but IR types leak into user API (session-01)
- p4include: `core` and `v1model` objects mirroring p4c's p4include/; unit tests use P4.typeName() not p4include refs to avoid dependency (session-01, session-02)
- Gradle 8.13 alongside Bazel: restructured to Gradle-convention layout (src/main/kotlin/, src/test/kotlin/); golden tests rewritten in Kotlin (session-02)
- @P4DslMarker added to all builder classes; surveyed 9 Kotlin DSL projects for patterns (session-02)
- P4 naming convention for domain objects (lowercase/snake_case) per kotlinx.html precedent (session-02)
- ErrorDecl/MatchKindDecl: nested objects with register() in init{} -- needed because nested objects can't use delegate pattern; multiple init{} blocks control declaration ordering (session-02)
- MethodRef wrapper enables overload(extract, ...) without strings (session-02)
- core.p4 100% complete -- every construct from upstream p4c (session-02)
- P4TypeDecl: abstract parser/control/package type declarations with type params; implements P4TypeReference; invoke operator for parameterized types (session-03)
- P4Include as P4Declaration -- includes emitted in source order; libraries declare include path via constructor (session-03)
- removed P4Type.PacketIn/PacketOut -- they're core.p4 externs, not language built-ins (session-03)
- open: extern-level type params, enum IR, v1model.p4 completion, future examples blocked by header stacks/registers/hash/multi-field select (session-03)
- Leo de Moura ETAPS interview: Z3 to Lean journey, formal methods + AI intersection (session-00)
- Genshin Impact: completed all Teyvat quests (session-00)
