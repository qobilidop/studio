# 2026 W12 (Mar 16–22)

## Monday - Z3Wire Weave + type naming + CI + devcontainer

- **Weave codegen tool**: full design + implementation (RDL -> C++ headers + protobuf, Python codegen)
  - Schema: Module > Struct > Field, Protobuf .rdl.txtpb as SoT
  - Resolver + proto emitter + header emitter + CLI + golden tests
  - Key: no name transformation, header-only output, `reserved` flag on Field
- **Type naming redesign**: Sym prefix for symbolic (SymBool, SymUInt, SymSInt), natural C++ for concrete (Bool, UInt, SInt)
  - Template renamed: BitVec (was Int) for concrete, SymBitVec (was BitVec) for symbolic
  - New concrete Bool with type safety (deleted integral ctor)
  - ~40+ files, design doc lifecycle (standalone -> merged -> deleted)
- **CI**: devcontainers/ci@v0.3, Bazel --disk_cache, GHCR image
- **dev.sh**: devcontainer CLI replaces raw Docker (32 -> 8 lines)
- Concept: "structural correctness" for agentic coding (CSP framing)

## Open items

- Weave: Unpack(), Bazel rule, multi-file imports
