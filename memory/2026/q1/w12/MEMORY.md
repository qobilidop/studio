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

## Tuesday - Z3Wire API maturation (shifts, casts, naming, docs)

- **Shift API redesign**: named functions (`shl`/`shr`) replace operators, `shl` always lossless, composable primitives
  - `shr<N>` constant shift, relaxed amount type, mixed concrete+symbolic overloads
  - Removed `operator<<`, `operator>>`, `checked_shl`, `checked_shr`
- **Cast improvements**: `checked_cast` polarity flip (value_preserved), `as_signed`/`as_unsigned`, `cast` -> `unsafe_cast`
- **Naming conventions**: `to_` (conversion), `as_` (reinterpretation), `_cast` (type conversion with safety tiers)
- **Renames**: `raw()` -> `expr()` (255 occurrences), `to_bool`/`to_ubv1` -> `as_bool`/`as_uint1`
- **`to_concrete`**: symmetric counterpart to `to_symbolic`, auto-derived return type
- **`exact_eq` removed**: after cross-ecosystem research, two equality functions is confusing
- **Docs**: midpoint overflow README example, packet_gen example, consolidated example docs into .cc programs, dev/guide.md
- **Tooling**: mdformat (wrap=80), clang-tidy tuning, clang-include-cleaner, CI renamed to "Lint"

## Open items

- Weave: Unpack(), Bazel rule, multi-file imports
