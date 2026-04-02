# Session 04 — sail-xisa: .CD batch + MAP ISA foundation + bit manipulation

Repo: `git@github.com:qobilidop/sail-xisa.git` (branch: main)

## What happened

Three major work items completed in one long session:

### 1. Parser .CD modifier batch
- Added `bool` (clear_dest) field to 13 parser instructions: MOV, MOVI, ADD, ADDI, SUB, SUBI, SUBII, AND, ANDI, OR, ORI, CNCTBY, CNCTBI
- Pattern: types.sail (union tuple), decode.sail (encdec_bool + 1 padding bit), insts.sail (conditional zero)
- Updated ~45 test call sites across 9 test files, added 13 new .CD tests
- Spec reviewer caught missing test_subii_with_clear_dest — fixed
- Moved .CD from "Current" to "Resolved" in todo.md

### 2. MAP ISA foundation (sub-project 1 of MAP)
- Read XISA white paper Section 4 (pages 42-85) for MAP spec
- Designed MAP architecture: 16 registers (128-bit, word-addressable as 4x32-bit), ZNCV flags, 64-bit encoding
- Key differences from parser: word-oriented (32-bit) operations, 4 condition flags (vs 2), richer modifiers (.F, .SX, .SH, .CD)
- Built state model: extended map/state.sail (16 regs, word accessors, ZNCV, PC, imem)
- Sail type system challenges: loop index bounds (solved with assert-wrapped helpers), bitvector comparison (use `unsigned()` not `<`), `sail_ones()` needs `nat` not `int`
- 22 instruction variants: ADD/ADDI, SUB/SUBI, CMP/CMPI, AND/ANDI, OR/ORI, XOR/XORI, NOT, MOV/MOVI, BR/BRI/BRBTST, HALT, NOP
- size=0 convention for bits(5) fields meaning size=32
- Named MAP bool mapping `encdec_mbool` to avoid conflict with parser's `encdec_bool`
- ANDI/ORI/XORI encoding had padding off by 1 — caught during build

### 3. MAP bit manipulation (sub-project 2 of MAP)
- SHL, SHLI, SHR, SHRI (4B mode only), CONCAT, FFI
- FFI was tricky: Sail type checker can't track `nat` through while loops — solved by using shift+mask instead of `map_extract` inside loops
- `result_offset` had to be `int` not `nat` since loop variable `pos` is `int`

## Key decisions
- MAP uses 64-bit instruction encoding (same as parser), opcodes 0-25
- Parser .CD modifier: `if clear_dest then sail_zeros(128) else read_preg(rd)` pattern
- MAP operand model: extract from 32-bit word, compute 32-bit result, write back
- `.SH` (short mode): operate on 16 bits, preserve upper 16 of dest word
- CMP always sets Z,C flags (no .F needed)
- `map_load_program` uses `list(bits(64))` not `vector('n, ...)` (Sail type var issue)

## Final state
- 36 tests passing (24 parser + 12 MAP)
- 28 MAP instruction variants implemented
- All synchronous register-to-register MAP instructions done
- Commits: b5a5038 → b6f785d (many commits on main)

## Next steps
- MAP subroutines (CALL, RET) or load/store (LD/ST — needs PMEM/RAM model)
- Remaining parser modifiers (.PR, .SCSM/.ECSM) depend on MAP infrastructure
