# Session: Weave Codegen Tool — Design Through Implementation

**Repo:** github.com/qobilidop/z3wire
**Branch:** main
**Duration:** Full design + implementation session

## What happened

Designed and implemented **Weave**, a codegen tool for Z3Wire that generates C++ structs and protobuf messages from RDL (Register Description Language) bit field descriptions.

### Design phase
- Brainstormed the SoT format, naming, schema, and generated output through iterative Q&A
- Key naming decisions: `weave` (codegen tool), `z3wire_rdl` (proto package), `Module` (top-level), `Struct`/`Field` (not BitStruct/BitField), `FieldPackOrder` (not bit_order), `field_pack_order` (not bit_order)
- Chose Protobuf `.txtpb` as SoT format, Python for codegen
- Designed three outputs: single `.h` (enum constants + concrete + symbolic structs + inline implementations), `.proto` (wire format)
- Conversion chain: Symbolic ↔ Concrete ↔ Proto
- Design doc written to `docs/design/weave.md`, reviewed by subagent

### Implementation
- **RDL schema** (`z3wire/weave/rdl.proto`): Module, Struct, Field, EnumDef, FieldType, BoolType, BitVecType
- **Resolver** (`resolver.py`): validates refs, computes widths/offsets, handles LSB_FIRST and MSB_FIRST pack orders
- **Proto emitter** (`emit_proto.py`): generates `.proto` files, omits reserved fields
- **Header emitter** (`emit_header.py`): four-section layout (enum constants, concrete types, symbolic types, inline implementations), out-of-line inline methods
- **CLI** (`weave.py`): `--input` and `--output_dir`, filenames from `file_prefix` field
- **Integration test** (`status_register_test.cc`): compiles and exercises all generated methods
- **Verification example** (`status_register_verification.cc`): hardware design rules demo
- **Golden tests**: codegen output diff + verification stdout

### Core library changes
- Added default constructors to `Bool`, `BitVec` (via `std::optional<z3::expr>`) and `Int` (zero-init)
- Made `Int` a literal type (`constexpr` constructor, `Literal`, `bits`, `value`)
- Enum constants use `UInt<W>::Literal<V>()` (constexpr-friendly)
- Fixed `ToConcrete` to use `model.eval(expr, true)` for model completion

### Polish
- `file_prefix` field in Module for output filename control
- Renamed `.txtpb` → `.rdl.txtpb`
- MSB_FIRST field pack order support
- Lint fixes (suppressed `bugprone-unchecked-optional-access`, excluded generated files from clang-tidy)
- Multiple commit history cleanups via interactive rebase

## Key files
- `z3wire/weave/` — all weave source (rdl.proto, resolver, emitters, CLI, tests)
- `examples/weave/` — example RDL, golden files, integration test, verification demo
- `docs/design/weave.md` — design doc
- `z3wire/bool.h`, `z3wire/bitvec.h`, `z3wire/int.h` — core library changes (default ctors)

## Decisions & rationale
- **No name transformation** in codegen — users write C++ names directly in RDL
- **`std::optional<z3::expr>`** for Bool/BitVec storage — tradeoff: loses compile-time non-null guarantee, but enables default construction needed by generated structs
- **Header-only generated code** — simpler for users, no extra `.cc` to wire into build
- **`reserved` flag on Field** (not name-based detection) — explicit, unambiguous
- **Four-section header layout** — declarations up top for scanning, implementations at bottom

## User preferences learned
- Prefers not to be asked before each commit — auto-commit and push
- Cares about readability of generated code
- Wants syntax highlighting for golden files (`.expected.h` not `.h.golden`)
- Likes `file_prefix` over deriving filenames from input path
- Values YAGNI — start simple, add features when needed

## Remaining roadmap
- `Unpack()` — construct symbolic struct from flat bit-vector
- Bazel rule integration (replace genrule)
- Multi-file imports
