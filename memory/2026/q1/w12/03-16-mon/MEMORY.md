# 2026-03-16 (Monday)

## Z3Wire: Weave codegen tool — full design + implementation

- **Weave**: codegen tool generating C++ structs and protobuf messages from RDL (Register Description Language)
- SoT format: Protobuf `.txtpb` (renamed `.rdl.txtpb`)
- Schema: Module > Struct > Field, with EnumDef, FieldType, BoolType, BitVecType
- Three outputs: single `.h` (enum constants + concrete + symbolic structs + inline impl), `.proto` (wire format)
- Conversion chain: Symbolic <-> Concrete <-> Proto
- Python codegen: resolver.py (validates, computes widths/offsets, LSB/MSB_FIRST), emit_proto.py, emit_header.py
- CLI: weave.py with --input and --output_dir
- Core library changes: default constructors for Bool, BitVec (via std::optional<z3::expr>), Int (zero-init), constexpr Int
- Key decision: no name transformation in codegen, users write C++ names directly in RDL
- Key decision: header-only generated code, `reserved` flag on Field (not name-based)
- Integration test + verification example + golden tests
- Key files: `z3wire/weave/`, `examples/weave/`, `docs/design/weave.md`

## Z3Wire: Type naming redesign

- Symbolic types get `Sym` prefix: Bool->SymBool, Ubv->SymUInt, Sbv->SymSInt
- Concrete types get natural C++ names: Bool (new), UInt, SInt
- Template: BitVec->SymBitVec (symbolic), Int->BitVec (concrete)
- BitVec over Int: avoids C++ signed-int ambiguity
- Headers renamed: bool.h->sym_bool.h, bitvec.h->sym_bit_vec.h, int.h->bit_vec.h
- New concrete Bool: type-safe, deleted integral constructor, explicit operator bool()
- ~40+ files touched
- Design doc lifecycle: standalone -> merged into overview.md -> deleted standalone

## Z3Wire: CI improvements

- Bazel --disk_cache + actions/cache for Z3 build caching
- Migrated all CI to devcontainers/ci@v0.3 (separate steps per invocation)
- Devcontainer image built/pushed to GHCR on .devcontainer/ changes
- Added cmake, make, pkg-config, libz3-dev to Dockerfile

## Z3Wire: dev.sh -> devcontainer CLI

- Replaced raw Docker (docker buildx build + docker run) with devcontainer up + devcontainer exec
- Simplified dev.sh from 32 lines to 8
- Moved bazel cache volume mount and port forwarding into devcontainer.json
- Fixed: .bazelignore for build/ and site/, excluded from format/lint, .cache ownership, git safe.directory

## Daily log highlights

- WFH week (Monday)
- Concept: "structural correctness" in agentic coding — project structure constrains agent updates, components constrain each other (CSP framing)

## Commits

- Weave: full design + implementation session
- Type naming: 4 squashed commits (f5158a8, 51f29df, c003872, ce8ded5)
- dev.sh: commit b5a3a0c

## User preferences confirmed

- Auto-commit and push (don't ask before each commit)
- Cares about readability of generated code
- Wants syntax highlighting for golden files (.expected.h not .h.golden)
- file_prefix over deriving filenames from input path
- YAGNI principle
- Devcontainer as single dev environment

## Open items

- Weave: Unpack() for symbolic struct from flat bit-vector
- Weave: Bazel rule integration (replace genrule)
- Weave: multi-file imports
