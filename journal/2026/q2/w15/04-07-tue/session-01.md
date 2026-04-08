# Session 01 — MAP instruction batch implementation

Repo: `qobilidop/sail-xisa`

## Context

User asked "what's next?" — I audited MAP instruction coverage against the XISA spec PDF (fetched from Sanity CDN). Found 44 implemented, ~100 in spec. Categorized remaining into tiers by subsystem dependency.

## Research: other Sail projects

Investigated how sail-riscv and sail-arm handle external subsystems:
- **sail-riscv**: address-dispatch for MMIO, extern to C for softfloat, callback hooks with default no-ops, config-based parameterization, scattered enums for extensions
- **sail-arm**: stub functions returning `__UNKNOWN_*()` for IMPLEMENTATION DEFINED behavior, swappable device files at build time, centralized impdefs file

Key takeaway: model the instruction's register-level effects, stub the external engine. This informed the LFLAG + HASH approach.

## Implementation (19 new instructions, opcodes 44-57)

### Commits (all on main)
1. `f1f8c66` — PMEM struct mgmt: MSTALLOC, MSTRGET, MSTRSET, MSTRGETCUR, MSTRSETCUR, MSTRSETCURI (opcodes 44-49). Added `str_cursor` register.
2. `5c97cb7` — MLDID, MLDRTC (opcodes 50-51). Added `map_hw_id`, `rtc` registers.
3. `c8d8639` — Docs: opcodes 44-51, modeling decisions for PMEM/RTC/HWID.
4. `30ba0c2` — LFLAG subsystem (8 x 2-bit flags: complete+result) + MSYNC/MSYNCALL (opcodes 52-53). Helpers `set_lflag`/`start_lflag`.
5. `e048700` — MWAIT (NOP in sync model), MDROP (returns RETIRE_DROP), MBW with 5 ops AND/OR/XOR/SHR/SHL (opcodes 54-56). Added `read_ram_small`/`write_ram_small`, `bw_op` enum, `decode_bw_size`.
6. `b00d3a4` — MHASH with stub XOR-fold (opcode 57). First instruction using LFLAG.

### Key files modified
- `model/map/types.sail` — 13 new union clauses, `bw_op` enum
- `model/map/decode.sail` — 14 new `mencdec` mappings, `encdec_bwop` sub-mapping
- `model/map/state.sail` — `str_cursor`, `map_hw_id`, `rtc`, `lflag_complete`, `lflag_result` registers; `set_lflag`/`start_lflag` helpers
- `model/map/insts.sail` — 14 new execute clauses, `sync_execute` shared fn, `read_ram_small`/`write_ram_small`/`decode_bw_size`
- `model/prelude.sail` — already had `RETIRE_DROP`
- 7 new test files in `test/map/`
- `test/CMakeLists.txt` — 7 new test registrations

### Sail gotchas encountered
- No `/` operator — use `get_slice_int(8, rounded, 2)` for shift-based division
- `mod` is a keyword — use `tmod_int(a, b)`
- Hex literals like `0x1234` have implicit width (16 bits) — use `sail_mask(14, 0x1234)` for narrower types
- `bits(7)` literal needs `0b0000000` not `0x00`
- Enums used in scattered union fields must be declared before `scattered union`
- Can't apply `& mask` directly after `match` expression — need intermediate variable
- Encoding padding: manually count field bits and verify `fields + padding = 58`

## Tiering analysis

**Tier 1 (no new subsystems):** STALLOC, STRGET/SET, cursor ops, LDID, LDRTC, WAIT, BW*, JTL, CAS/TAS, RAND — mostly done now except JTL, CAS/TAS, RAND.

**Tier 2 (need LFLAG, now ready):** SYNC/SYNCALL (done), HASH (done), COUNTER, CHKSUMTST/UPD/CALC — next targets.

**Tier 3 (need external stubs):** LKP*, SENDOUT/DROP(done)/SENDQID/SENDDATA, METER, DLB, CP*, AQMEG/AQMLD, interrupts, buffer mgmt, REPARSE, SIZEQUERY, MCREQUEST/MCDONE.

## Decision: next session

Agreed to focus on **differential testing** — the Rust simulator doesn't know about any of the new instructions. Need to add them to the Rust side + proptest coverage before adding more Sail instructions. Then update web spec page coverage tables.

## Stats
- MAP instructions: 44 → 63 implemented
- Tests: 49 → 53 (all passing)
- Opcodes: 0-43 → 0-57
