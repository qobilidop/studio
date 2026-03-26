# 2026-03-16 (Monday)

Massive Z3Wire day — Weave codegen tool from design to working implementation, complete type naming redesign, CI overhaul, and dev environment simplification.

## Highlights

- Designed and implemented **Weave** codegen tool (RDL -> C++ headers + protobuf)
- Complete type naming redesign: Sym prefix for symbolic types, natural C++ names for concrete
- New concrete `Bool` type with type safety (deleted integral constructor)
- CI migrated to devcontainers/ci with Bazel disk cache
- dev.sh simplified from 32 lines to 8 via devcontainer CLI
- Coined "structural correctness" concept for agentic coding

## Sessions

- **session-00**: Daily log — WFH Monday, "structural correctness" concept (project structure as CSP for agents)
- **session-01**: Weave codegen tool — design (brainstorming, schema, naming) + full implementation (RDL proto schema, resolver, emitters, CLI, integration tests, golden tests)
- **session-02**: Type naming redesign (SymBool/SymUInt/SymSInt + Bool/UInt/SInt, ~40+ files) + CI improvements (devcontainers/ci, Bazel disk cache)
- **session-03**: Switch dev.sh from raw Docker to devcontainer CLI, verified all dev commands, added .bazelignore
