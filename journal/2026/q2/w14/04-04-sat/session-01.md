# Session 01 — sail-xisa: playground refactor, proptest, diff testing

Repo: `github.com:qobilidop/sail-xisa`
Branch: `main` (all committed, not pushed)
Commits: `b65447a..106d5a4` (14 commits)

## What happened

Three full design→plan→implement cycles in one session:

### 1. Playground refactor
- Separated core Rust crate (`playground/`, name `xisa`) from WASM bindings (`web/wasm/`, name `xisa-wasm`)
- Set up Cargo workspace at repo root linking both crates
- Added `xisa-sim` CLI binary (loads binary, runs to halt, dumps SimState as JSON)
- Moved examples from `examples/parser/` to `playground/examples/`
- Updated CI workflow (`web.yml`), Astro WASM import path, `.gitignore`
- Added `Serialize` to `SimState` with custom `array_ser` module for large fixed arrays

### 2. Property-based testing (proptest)
- `playground/tests/common/mod.rs` — shared `arb_instruction()` strategy covering all 44 instruction variants
- `playground/tests/proptest_encode_decode.rs` — `decode(encode(instr)) == instr` roundtrip
- `playground/tests/proptest_assemble.rs` — 17 tests for assembler-supported instructions, accounting for assembler defaults (size: 128, doff: 0)

### 3. Differential testing infrastructure
- `test/diff/harness.c` — C harness linking Sail-generated emulator, reads binary+packet, dumps JSON state
- `test/diff/main.sail` — dummy Sail main that references `parser_init`/`write_pimem_raw`/`parser_run` to prevent dead code elimination
- CMake target `sail-c-emu-harness` with `main=__sail_generated_main` rename trick
- `playground/src/diff.rs` — `DiffState` struct for parser-observable state comparison
- `playground/tests/diff_test.rs` — 12 tests (1 passing, 11 ignored), includes proptest packet fuzzing
- Added `tempfile` dev-dependency

### 4. Bug found: bit-endianness mismatch
- Rust `insert_bits`/`extract_bits` use bit 0 = MSB; Sail uses bit 0 = LSB
- Comment in `state.rs:148` claims "matches Sail model" — incorrect
- Affects all register-manipulating instructions
- Root cause fully traced; fix approach identified (flip Rust to match Sail)
- Saved to memory: `project_endianness_bug.md`

## Key decisions
- Cargo workspace with `resolver = "2"`
- Core crate name `xisa`, WASM crate name `xisa-wasm`
- Sail calls C backend output "emulator" not "simulator" → binary named `sail-c-emu-harness`
- Proptest over quickcheck (better shrinking, community standard)
- C harness approach over Sail harness (Sail has no file I/O)
- Diff test JSON format: hex strings for 128-bit values, decimal for small ints, native JSON bools

## Specs and plans written
- `docs/specs/2026-04-04-playground-refactor-design.md`
- `docs/specs/2026-04-04-playground-refactor-plan.md`
- `docs/specs/2026-04-04-proptest-design.md`
- `docs/specs/2026-04-04-proptest-plan.md`
- `docs/specs/2026-04-04-diff-testing-design.md`
- `docs/specs/2026-04-04-diff-testing-plan.md`

## Next session
- Fix bit-endianness bug in `playground/src/state.rs` (flip to bit 0 = LSB)
- Update all unit tests in state.rs, execute.rs
- Un-ignore diff tests, verify all 12 pass
- Then: subroutines (CALL/RET/JTL)
