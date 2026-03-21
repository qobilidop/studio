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

## Wednesday - Z3Wire API gaps, docs refinement, SInt storage (half day)

- Bili sick in morning, back online ~2:43 PM
- **API gap analysis**: compared against Z3 C++, Rust z3, Bitwuzla, cvc5, STP — multiply is top priority gap
- **Weave register arrays**: concrete → `std::array`, symbolic → default-zero, proto → `map<uint32, RegType>`
- **SInt storage**: changed to signed storage, removed `.bits()`, `.value()` sole accessor
- **Naming**: `checked()` → `Checked()`, PascalCase for factory methods, snake_case for functions
- **Docs overhaul**: removed redundant pages, restructured all usage docs with overview tables
- **New page**: type-conversions.md (was casting.md), created examples/usage/ .cc files
- **Safety issues**: `SymBool(z3::expr)` no sort check, `BitVec(uint64_t)` silent truncation — tracked in roadmap

## Thursday - Z3Wire API hardening, wide BitVec, fuzz testing, rotations

- **Z3W_CHECK macro**: internal assertion macro (Abseil CHECK-compatible), guards uninitialized symbolic access
- **FromExpr API**: `std::optional`-returning safe public API for z3::expr construction with sort/width validation
- **Bool catch-all delete**: rejects all non-bool types (floats, pointers, nullptr)
- **Concrete type cleanup**: Storage→ValueType, bits_→value_, mask()→truncate(), type_traits.h extraction
- **Wide BitVec (W > 64)**: byte-array storage, unsigned-first then signed enabled, concat/extract Z3 bridge
- **Google FuzzTest**: integrated, pinned Bazel to 8.2.1 (flatbuffers/Bazel 9 conflict), 24 width/signedness combos
- **Fuzzer-found bug**: SInt<64> `to_concrete` — `get_numeral_int64()` throws when MSB set; fixed to uint64
- **Extract fix**: symbolic-offset with wide index caused unsigned underflow; fixed with max(W, IdxW) extension
- **Rotation ops**: rotl/rotr with 6 overloads, Z3 C API for variable rotation, preserves signedness
- Fuzz tests for extract and rotation roundtrips
- 35/35 tests pass, lint clean

## Friday - Z3Wire infrastructure overhaul + explorations

- **Weave Python → C++ rewrite**: ~800 lines Python → ~1200 lines C++ (Abseil + protobuf C++ API), golden tests byte-identical, removed all Python infrastructure
- **Formatter/linter overhaul**: black → ruff format, mdformat → dprint, pip → uv; added dprint, ruff check, proto formatting via clang-format
- **Z3 version pinning**: CMake switched to pre-built Z3 4.15.2 (was system 4.8.12)
- **BuildBuddy remote cache**: `.bazelrc` `config:remote` (later renamed `config:ci`), `BUILDBUDDY_API_KEY` secret
- **CMake extended for weave**: GoogleTest, Abseil, Protobuf from source; `find_package` over FetchContent; 8 tests
- **Lint overhaul**: cmake `compile_commands.json` replaces Bazel-based header hunting
- **Test reorg**: `compile_fail_tests/` → `tests/compile_fail/`, `fuzz_tests/` → `tests/fuzz/`
- **Codecov removed**: overkill for small solo library
- **Explorations**: SMT Arena idea (shelved), Lean 4 for formalization (P4 eDSL design in Lean), dprint chosen as project-wide formatter, pre-commit framework research

## Open items

- Weave: Unpack(), Bazel rule, multi-file imports
- Z3Wire: multiply implementation, division/remainder, safety fixes for z3::expr constructors
- SMT Arena: differential testing of SMT solvers — idea shelved, revisit later
- P4 eDSL in Lean: promising direction, paused
