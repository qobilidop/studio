# 2026-03-16 (Monday)

Massive Z3Wire day: designed and implemented the Weave codegen tool from scratch, overhauled type naming across 40+ files, modernized CI with devcontainers, and simplified the dev environment. Also coined the "structural correctness" concept for agentic coding.

## Sessions

- **session-00**: Daily log — WFH Monday, brainstormed "structural correctness" concept (project structure as CSP constraining agent updates), discussed custom safe Bool type in C++
- **session-01**: Weave codegen tool — full design + implementation: RDL proto schema, resolver, proto emitter, header emitter, CLI, integration tests, golden tests
- **session-02**: Type naming redesign (Sym prefix for symbolic, natural C++ for concrete) across 40+ files, plus CI modernization with devcontainers/ci and Bazel disk cache
- **session-03**: Switched dev.sh from raw Docker to devcontainer CLI (32 to 8 lines), verified dev commands, added .bazelignore

## Agent index

- DECISION: Weave codegen SoT is Protobuf `.rdl.txtpb`, Python codegen, three outputs: `.h` (4-section layout), `.proto`; no name transformation in RDL — users write C++ names directly (session-01)
- DECISION: `std::optional<z3::expr>` for Bool/BitVec storage — tradeoff: loses compile-time non-null, enables default construction for generated structs (session-01)
- DECISION: type naming — `Sym` prefix for symbolic (SymBool, SymUInt, SymSInt), natural C++ for concrete (Bool, UInt, SInt); `BitVec` over `Int` for template (avoids signed ambiguity) (session-02)
- DECISION: concrete Bool — deleted integral constructor, `explicit operator bool()`, type-safe (session-02)
- DECISION: design doc lifecycle — standalone spec -> merged into overview.md -> deleted standalone (session-02)
- DECISION: devcontainer as single dev environment, dev.sh uses devcontainer CLI (session-03)
- CONCEPT: "structural correctness" — architecture as CSP for agents, components constrain each other, compiler-driven agent alignment (session-00)
- PREF: auto-commit+push without asking; readability of generated code; `.expected.h` for golden files; `file_prefix` over path derivation; YAGNI (session-01)
- OPEN: Weave — Unpack(), Bazel rule integration, multi-file imports (session-01)
