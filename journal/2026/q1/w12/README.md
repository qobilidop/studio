# 2026 W12 (Mar 16–22)

Back to Z3Wire after the P4kt sprint. Major infrastructure and API maturation.

## Highlights

- Weave codegen tool: from design to working implementation in one session, then rewritten to C++
- Complete type naming overhaul across 40+ files
- CI modernized with devcontainers/ci and Bazel caching
- Dev environment simplified with devcontainer CLI
- Shift API redesigned with composable primitives
- Naming conventions established: `to_`/`as_`/`_cast`
- `to_concrete` completes the symbolic<->concrete round-trip
- Comprehensive API gap analysis against 5 libraries
- SInt storage simplified to signed type
- All usage docs restructured with overview tables and example files
- Wide BitVec (W > 64) for both unsigned and signed types
- Google FuzzTest integrated — found and fixed a real bug
- Rotation operations added (rotl/rotr)
- Formatter/linter stack overhauled: black→ruff, mdformat→dprint, pip→uv
- BuildBuddy remote cache for CI
- Explored Lean 4 for formalization and P4 eDSL design

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

## Saturday - Rest day + Weave module separation + P4buf brainstorm

- **Weave module separation**: moved `z3wire/weave/` to top-level `z3wire_weave/`, gated behind `option(Z3WIRE_BUILD_WEAVE OFF)` in CMake so core consumers never see abseil/protobuf deps. 4 commits (a226569..0172e60).
- **P4buf concept**: subset of P4 as IDL. Input: .p4 with type/extern declarations. Output: Protobuf + language-native data structures. Externs → rpc/interfaces. Deferred until Z3Wire v0.1.0 ships.
- **DisplayLink research**: Alt Mode = native GPU (zero latency), DisplayLink = software USB video. Decided on Alt Mode product for triple-monitor M1 setup.
- Rest day, no other coding

## Sunday - Z3Wire operations overhaul + repo organization design

- **Z3Wire operations doc overhaul**: added per-operation typing rule tables to all 8 operation categories. Consistent structure: intro → typing rules table → examples → code block.
- **Arithmetic typing fix (CIRCT hwarith rules)**: `arith_result_width()` for mixed-signedness. `ui<A> op si<B>` → width `A+2` if `A>=B`, else `B+1`.
- **Added `replace` operation**: inverse of `extract`. Static + symbolic-offset variants. Result preserves source signedness.
- **Removed `bit<N>()`**: just `extract<N,N>()`. Core bit manipulation = extract, replace, concat.
- **`SymBool` support**: added to `concat` (via `internal::sym_width` trait) and `ite`.
- **Design decisions**: bitwise on signed+unsigned (cross-signedness forbidden), `implies` deferred, NAND/NOR/XNOR YAGNI.
- **Multi-repo organization**: clarified purpose/boundaries for all repos. 5 meta-layer repos (Cyborg, Artisan, Hermit, Clert, Website) each with a decision test, plus dynamic standalone project repos.
- **Key distinctions**: Cyborg (agentic) vs Artisan (human-first creative direction); Hermit (has voice, keep after death) vs Clert (structured data, get it done); dotfiles → Cyborg.
- **Personal website roadmap**: identity page → blog → portfolio → digital garden. Start simple, content in website repo initially.
- Productivity limited by physical condition (headache from late night).

## Open items

- Weave: Unpack(), Bazel rule, multi-file imports
- Z3Wire: multiply implementation, division/remainder, safety fixes for z3::expr constructors, `implies` operator, v0.1.0 release
- P4buf: P4 subset as IDL — deferred until Z3Wire v0.1.0
- SMT Arena: differential testing of SMT solvers — idea shelved, revisit later
- P4 eDSL in Lean: promising direction, paused
