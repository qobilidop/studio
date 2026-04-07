# Session 03 — MAP ISA: Load/Store, MOD, CALL/RET, LDH/STH

Repo: `git@github.com:qobilidop/sail-xisa.git`, branch: `main`

## What happened

Implemented 16 new MAP ISA instructions (opcodes 26-41) with 43 new tests, plus cleanup. All work committed directly to main, 43/43 Sail tests passing.

### Instructions added

| Group | Instructions | Opcodes | Tests |
|---|---|---|---|
| Scratchpad (CCM) | LDSP, LDSPI, STSP, STSPI | 26-29 | 10 |
| RAM (absolute) | MLD, MST | 30-31 | 10 |
| Global Data (GDMR) | MLDD, MLDDI, MSTD, MSTDI | 32-35 | 6 |
| Modulo | MMOD, MMODI | 36-37 | 6 |
| Subroutines | MCALL, MRET | 38-39 | 5 |
| Packet Header | MLDH, MSTH | 40-41 | 6 |

### New state modeled

- `scratchpad`: 1024 x 4B words (4096 bytes), `bits(12)` address, 4B-aligned
- `device_ram`: 65536 bytes, byte-addressable, 32B line alignment enforced
- `gdmr`: 32-bit base address for global data section
- Reused parser's `packet_hdr`, `hdr_offset` for LDH/STH

### Include order change

`model/main.sail` reordered: MAP types/decode/state → parser (full) → MAP insts/exec → parser insts/exec. This allows MAP insts to access parser's `packet_hdr`/`hdr_offset` while `parser_init` can still call `map_init`.

### Cleanup

Replaced verbose literal array init functions (`init_hdr_present`, `init_hdr_offset`, `init_tt_*`, `init_pseek_*`, `init_map_regs`) with `foreach` loops. ~450 lines removed.

## Sail quirks learned

- Hex literals (`0x100`) are bitvectors, not ints — use decimal for int-typed function args like `read_ram(256, 4)`
- No `/` or `%` operators — use bitvector masking (`& 0xFFFFFFE0`) and `tmod_int` for modulo
- `foreach` loops satisfy type checker for vector index bounds; `while` loops don't
- `range(0, N)` type annotation helps prove bounds but not always sufficient; `unsigned(bv[hi..lo])` with `assert` works

## Deferred

- JTL (jump table lookup) — compound bitmap-driven multi-call, depends on CALL/RET (now done)
- LDS/STS (PMEM structures) — needs STR.PRESENT/STR.OFFSET subsystem
- 32B LD transfers — multi-register spanning
- .LB modifier on MOD/MODI — HW optimization, functionally identical

## Commits (17 total)

e77a259, 80a60a7, c45bd6f, 46f49bb (scratchpad), 195edf4, 5ff3d52, 7340ea2 (RAM), 23a7b28, 35f51d8, bcdcdd1 (global data), 12aacfd, c42d46e (MOD), 3bad6c7 (CALL/RET), 21ae900, f65d9d6 (LDH/STH), 507234b, be7a4ee (cleanup)
