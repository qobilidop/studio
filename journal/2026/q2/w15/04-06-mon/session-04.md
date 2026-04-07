# Session 04 — sail-xisa: MLDS/MSTS, insert_bits refactor, doc audit

Repo: github.com/qobilidop/sail-xisa

## What happened

### 1. Surveyed remaining MAP ISA work
- Read XISA white paper PDF (via WebFetch + Read tool) to get full 4.13 TOC
- Mapped implemented vs missing MAP instructions
- Missing: JTL (4.13.15), HASH (4.13.19), LKP (4.13.20), SYNC (4.13.21), CPR (4.13.23), CHKSUM (4.13.24), SENDOUT/DROP (4.13.25), plus LDS/STS from 4.13.13/14
- Conclusion: LDS/STS were the last self-contained instructions; all others need external subsystems

### 2. Implemented MLDS/MSTS (PMEM structure load/store)
- Brainstormed → spec → plan → TDD execution, all inline
- New state in `model/map/state.sail`: `str_present` (bits(14)), `str_offset` (14×8-bit), `pmem` (1024 bytes), `read_pmem`/`write_pmem` helpers
- Opcodes 42 (MLDS) and 43 (MSTS) in types/decode/insts
- 6 tests in `test/map/test_lds_sts.sail`
- Documented STR.OFFSET spec ambiguity in `docs/modeling-decisions.md`: section 4.4 says "4B granularity" but 4.13.13/14 says "Units: Bytes" — we model as byte offsets
- Commits: `0f8e770` (feature), `249855c` (format)

### 3. Refactored insert_bits to use Sail stdlib
- Investigated replacing `extract_bits`/`insert_bits` with Sail stdlib equivalents
- `insert_bits` → `set_slice_bits` ✅ (cleaner, 2 lines vs 3)
- `extract_bits` → `slice()` ❌ (returns `bits('s)`, needs `128 >= 's` constraint that callers can't prove)
- Updated todo.md to document this as resolved/deliberate
- Commit: `f5e1295`

### 4. Documentation audit
- Explored agent checked all 9 doc files against codebase
- Found 2 issues:
  - `docs/style.md`: "MAP R0-R13" → "MAP R0-R15"
  - `docs/map-reference.md`: .CD modifier missing SHLI, SHRI
- Commit: `d6bd642`

### 5. Read HASH spec (4.13.19)
- Needs hash function engine (implementation-defined HW), multi-register input spanning, profile IDs
- Confirmed: all remaining MAP instructions need external subsystems

## Key facts
- MAP ISA: 44 opcodes implemented (0-43), all self-contained ones done
- Diff testing: fully operational for parser ISA (55+ tests), MAP ISA not yet covered in Rust simulator
- Spec PDF accessible via: `https://cdn.sanity.io/files/eqivwe42/production/affd0d0005566d4d8c50e05eff7fb60a43049a9f.pdf`
- PMEM size: 1024 bytes (implementation-chosen)

## Updated memories
- `project_endianness_bug.md` → renamed scope to "diff testing status", noted it's fully operational, parser-only coverage
