# 2026-04-04 (Saturday)

Massive multi-project day: sail-xisa (playground refactor, proptest, diff testing, bug fixes), Z3Wire (multiplication + docs/dev refactor), P4Py (Slice 5 routing + refinement), plus a deep Gemini discussion on agentic dev workflow (repo doc standards, versioning, PR workflow).

## Sessions

- **session-00**: Daily log — Gemini Q&A: language-agnostic IR (hourglass model, protobuf/MLIR/CIRCT references), ProVerB program verification book, HDMI vs DisplayPort, 3-agent parallel workflow discussion, deep dive on repo documentation standards (north_star.md, arch.md, todo.md, rules.md, AGENTS.md vs llms.txt, justfile, v0.1.0 transition protocol, design.md with rejected alternatives, Chesterton's Fence principle)
- **session-01**: sail-xisa — playground refactor (Cargo workspace, core `xisa` crate + `xisa-wasm`), proptest (encode/decode roundtrip + assembler), diff testing infrastructure (C harness for Sail emulator, DiffState comparison), discovered bit-endianness bug (bit 0=MSB vs LSB)
- **session-02**: Z3Wire — multiplication support (`operator*` for SymBitVec, W1+W2 bit-growth, TDD, 3 commits). Proved correctness for all signedness combos. Worktree workflow.
- **session-03**: P4Py — tor.p4 Slice 5 (routing pipeline), 7 new language features (`.apply().hit`, `inout` params, file-scope actions, partial action application, `action_selector`, `selector` match kind), 10 commits, 59 tests
- **session-04**: P4Py — tor.p4 refinement pass. Bug fixes (duplicate table key, p4c type errors). New features (`p4.var(named_type)`, `@p4runtime_translation`, `@name` on table keys). Code quality (ruff, noqa, inout annotations). p4testgen setup (blocked by p4c version). tor.p4 translation complete.
- **session-05**: sail-xisa — fixed bit-endianness cascade (bit 0=LSB, offset/value confusion in MOVI/STH/STCH/STHC, MOVLII/MOVRII semantics, u8 wrapping overflow). Expanded diff tests to 55. Switched dev container to clang+lld (GNU ld 2.42 bug).
- **session-06**: Z3Wire — major docs/dev/ refactor (split monolithic guide.md into 8 focused files), removed docs/design/, refined north_star.md extensively (19 lines, boundary-defining only), rewrote README (new tagline, Z3 vs Z3Wire comparison example), updated AGENTS.md with @-links and dprint-ignore.

## Agent index

- SAIL-XISA-REFACTOR: Cargo workspace, core crate `xisa` + WASM crate `xisa-wasm`, `xisa-sim` CLI binary, Serialize on SimState via custom array_ser module (s01)
- PROPTEST: encode/decode roundtrip + 17 assembler tests. `arb_instruction()` strategy covering all 44 variants (s01)
- DIFF-TESTING: C harness linking Sail C emulator, DiffState for parser-observable state, 12→55 tests. Proptest packet fuzzing. `diff_test_instrs()` helper for binary-level tests (s01, s05)
- BIT-ENDIANNESS-BUG: bit 0=MSB in Rust vs bit 0=LSB in Sail. Affected all register ops. Fixed in s05 with cascade of related fixes (s01 discovery, s05 fix)
- OFFSET-BUGS: MOVI doff needs *8, STH/STCH/STHC store cursor not oid, MOVLII/MOVRII wrong semantics (s05)
- U8-OVERFLOW: Sail uses unbounded nat, Rust u8 wraps. Widened to u16 intermediate arithmetic, offset+size>128 → no-op (s05)
- TOOLCHAIN: GNU ld 2.42 bug with Rust many-section objects → switched to clang+lld, .cargo/config.toml with rustflags (s05)
- Z3WIRE-MUL: `operator*` for SymBitVec, W1+W2 bit growth, signed-if-either-signed. bvmul is sign-agnostic, signedness flows through extension. TDD, 3 commits, worktree workflow (s02)
- P4PY-SLICE5: routing_lookup + routing_resolution, 7 new features (.apply().hit, inout params, file-scope actions, partial action application, action_selector, selector match kind). 59 tests, 1351-line golden file (s03)
- P4PY-REFINEMENT: tor.p4 complete. p4.var(named_type), @p4runtime_translation on all newtypes, @name on table keys (limited by p4c). p4testgen blocked by p4c 1.2.5.11 catch-22 (s04)
- AGENTIC-WORKFLOW: deep discussion on repo doc standards. Decided: docs/dev/{north_star,arch,todo,rules}.md + AGENTS.md (not llms.txt). justfile inside dev container. v0.1.0 = transition from direct-to-main to PR workflow. design.md with rejected alternatives (Chesterton's Fence). llms.txt is website standard, not repo standard (s00)
- IR-DESIGN: language-agnostic IR discussion — hourglass model, protobuf/FlatBuffers for serialization, MLIR/CIRCT for compiler infra, BMv2 JSON as P4 example, SMT-LIB/Btor2, WASM (s00)
- PROVERB: bookmarked slebok.github.io/proverb — program verification tool taxonomy PV1-PV6 (s00)
- 3-PROJECT-PARALLEL: sail-xisa + p4py + z3wire, strict 1:1 agent:project mapping. Dropped Z3Wire Weave to keep scope focused (s00)
- Z3WIRE-DOCS-REFACTOR: split guide.md → 8 files (index, north_star, architecture, setup, commands, style, workflow, roadmap). Removed docs/design/ (philosophy redundant, compile-fail-tests moved to code). AGENTS.md @-links all docs/dev/ except setup.md. `<!-- dprint-ignore -->` for @-directives (s06)
- Z3WIRE-NORTH-STAR: 19 lines, 3 sections (what it is, what it's not, design principles). Test: "if it could change without changing what Z3Wire *is*, it doesn't belong." Removed feature checklists/operation lists/distribution plans → roadmap (s06)
- Z3WIRE-README: tagline "Type-safe Z3 for combinational logic verification." Mixed-sign multiplication as example (demonstrates width+signedness+overflow safety). Removed getting started commands. Fixed em dashes → plain hyphens (s06)
- Z3WIRE-NAMING: "combinational logic verification" over "hardware verification" — more accurate scope, justifies operation set (s06)
- TEST-COUNTS: sail-xisa 116 total (43 lib + 55 diff + 17 proptest-asm + 1 proptest-enc/dec). p4py 59 tests (was 53→56→59). z3wire 25 tests (s01,s03,s04,s05)
