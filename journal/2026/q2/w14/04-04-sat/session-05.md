# Session 05 — Fix Rust simulator bugs, expand diff tests, switch to clang+lld

**Repo:** github.com:qobilidop/sail-xisa.git
**Branch:** main
**Commits:** a8fa485, 5e86357, 55c5565

## What happened

Picked up from blocking bit-endianness bug identified in previous session. Fixed a cascade of Rust simulator bugs found by comparing `playground/src/execute.rs` against `model/parser/insts.sail`, validated by differential tests against the Sail C emulator.

### Bug fixes (4 categories)

1. **Bit-endianness** (`state.rs`): `extract_bits`/`insert_bits` flipped from bit 0=MSB to bit 0=LSB, matching Sail's `sail_shiftright(reg_val, offset)` convention.

2. **Offset/value confusion:**
   - MOVI: `doff` is byte offset, needs `*8` for bit offset (Sail: `unsigned(dest_offset_bytes) * 8`)
   - STH/STCH/STHC: `oid` is an index into `hdr_offset[]`, value stored is `state.cursor` (was storing `oid` as value)

3. **Wrong semantics (MOVLII, MOVRII):**
   - MOVLII: should extract dest offset from register, insert immediate at that offset. Was extracting data from register.
   - MOVRII: should extract offset from register, index into immediate, insert at offset 0. Was treating like MOVRI.

4. **u8 wrapping arithmetic:** Sail uses unbounded `nat` for offset computation. Rust was doing `u8::wrapping_add/wrapping_mul` causing silent wrap on overflow. Widened `extract_bits`/`insert_bits` offset param to `impl Into<u16>`, handle offset+size>128 as no-op. Fixed MOVI, MOVL, MOVLI, CmpIBy, CnctBy to use u16 intermediate arithmetic.

### Diff test expansion

Added `diff_test_instrs()` helper for binary-level tests (instructions not in assembler). Grew from 12 to 55 diff tests covering: all MOV variants, arithmetic, logic, compare, branch, header/cursor, struct-0, concatenation, plus 2 proptest fuzz tests.

### Dev container toolchain fix

GNU ld 2.42 has "access beyond end of merged section" bug with Rust's many-section object files. Fix:
- `.devcontainer/Dockerfile`: replaced `gcc` with `clang lld`, added `ENV CC=clang`
- `.cargo/config.toml` (new): `rustflags = ["-C", "link-arg=-fuse-ld=lld"]`, `incremental = false` (bind-mount race fix)

## Key files

- `playground/src/state.rs` — `extract_bits`/`insert_bits` with `impl Into<u16>` offset
- `playground/src/execute.rs` — all instruction executor fixes
- `playground/tests/diff_test.rs` — 55 diff tests, `diff_test_instrs()` helper
- `.devcontainer/Dockerfile` — clang+lld
- `.cargo/config.toml` — lld linker config

## Test counts

116 total: 43 lib unit + 55 diff + 17 proptest assemble + 1 proptest encode/decode

## Next

Implement more MAP instructions (~20 remaining). Diff tests are the safety net.
