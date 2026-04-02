# Session 01 — sail-xisa parser ISA batch implementation

**Repo:** https://github.com/qobilidop/sail-xisa
**Duration:** Extended session, 3 instruction groups implemented end-to-end.

## What was done

Implemented 7 parser ISA instructions across 3 groups, following the brainstorm → spec → plan → TDD execution pipeline each time:

### 1. STC/STCI (cursor manipulation, spec 3.12.8)
- **Spec:** `docs/specs/2026-03-31-stc-stci-design.md`
- **Plan:** `docs/plans/2026-03-31-stc-stci-plan.md`
- STC: `Cursor += ((SrcReg[i:j] + AdditionalIncr) << SrcShift)` — bits8 arithmetic throughout
- STCI: `Cursor += IncrValue` — immediate up to 256, truncated to bits8
- JumpMode deferred (needs transition table). .SCSM/.ECSM deferred (checksum subsystem).
- 8 tests in `test/parser/test_stc.sail`

### 2. HDR model + STH/STCH/STHC (header metadata, specs 3.12.7/3.12.9)
- **Spec:** `docs/specs/2026-04-01-hdr-sth-stch-design.md`
- **Plan:** `docs/plans/2026-04-01-hdr-sth-stch-plan.md`
- New state: `hdr_present : vector(32, bool)`, `hdr_offset : vector(32, bits8)` — 32 entries is assumed default (white paper doesn't specify).
- Helper: `set_hdr(present_id, offset_id)` with assert-based bounds checking.
- Init used literal vector functions (`init_hdr_present`, `init_hdr_offset`) because Sail's type checker can't prove while-loop index bounds for vector access.
- STH: set header present+offset at cursor. .H supported.
- STCH: STCI then STH (offset = new cursor). .H supported.
- STHC: STH then STCI (offset = old cursor). No .H per spec.
- 8 tests in `test/parser/test_sth.sail`, including ordering test (STCH vs STHC).

### 3. Struct-0 + ST/STI (store to struct, spec 3.12.10)
- **Spec:** `docs/specs/2026-04-01-st-sti-design.md`
- **Plan:** `docs/plans/2026-04-01-st-sti-plan.md`
- New state: `struct0 : bits128` — Standard Metadata register.
- HW-controlled bits 6-31 restriction not enforced (hardware detail, not instruction semantics).
- ST: copy register sub-field to struct0. .H supported.
- STI: store immediate (up to 16 bits) to struct0.
- Reuses existing `extract_bits`/`insert_bits` helpers.
- 7 tests in `test/parser/test_st.sail`.

## Key decisions
- **HDR array size = 32**: Assumption, noted in spec. White paper says "HDR.PRESENT and HDR.OFFSET0/1" but doesn't give exact count.
- **Struct-0 HW bits 6-31 not enforced**: Model focuses on instruction semantics, not hardware protection.
- **JumpMode deferred everywhere**: STC, STCI, STH, STCH, STHC all have JumpMode operand deferred to transition table work (step 3 in remaining roadmap).
- **.H modifier included**: Simple enough (one-line halt) and practical for tests. Included on STH, STCH, ST.
- **White paper link added to coverage.md**: User suggestion, good for discoverability.

## Sail gotcha
- Sail type checker is flow-insensitive with while loops — can't prove loop variable bounds for vector indexing even with assert. Workaround: use literal vector init functions (like `init_pimem` pattern).

## Coverage after session
27 of ~38 parser instruction variants done. 18 test files, all passing.

## Remaining roadmap
1. EXTMAP/MOVMAP — needs MAP register file (14 x 128-bit)
2. MOVL/MOVR (6 sub-variants) — dynamic offset moves
3. NXTP/PSEEK + deferred BRs — transition table (most complex)

## Workflow note
User prefers inline execution for small sequential plans (confirmed). Brainstorm → spec → plan → inline TDD execution works well for these mechanical instruction groups.
