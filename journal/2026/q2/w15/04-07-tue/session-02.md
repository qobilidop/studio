# Session 02 — Differential fuzz testing + CP instructions

**Repo:** github.com/qobilidop/sail-xisa
**Duration:** ~2 hours
**Commits:** fce0443, 770cd36, 8b48943, f4f9587

## What happened

### 1. Single-instruction differential fuzz test

Added proptest-based fuzzer to `playground/tests/diff_test.rs` that generates random parser instructions + random packets, runs on both Rust and Sail, asserts agreement (both succeed with same state, or both fail).

Key design: `arb_fuzzable_instruction()` strategy in `common/mod.rs` excludes branches (infinite loops), Nop/Halt (trivial), NXTP-dependent (need table setup). Error-agreement pattern: `catch_unwind` on Rust side, exit code on Sail side.

**7 bugs found and fixed:**
- `execute.rs`: shift overflows in N-flag (`size > 128`), CnctBy/Bi (shift >= 128), STC (shift >= 8)
- `state.rs`: `extract_bits`/`insert_bits` rejected `offset+size > 128` instead of clamping
- `state.rs`: `extract_packet_bits` silently returned 0 for out-of-bounds (Sail asserts)
- `execute.rs`: Sth/Stch/Sthc silently ignored `pid/oid >= 32` (Sail asserts)
- `model/parser/state.sail`: Sail `extract_bits`/`insert_bits` overflowed when `offset+size > 128` — added clamping with `assert(eff_size > 0)`

Sail type checker quirk: can't prove `if a < b then a else b >= 0` even when both branches are >= 0. Workaround: separate if-else branches with `assert`.

### 2. CP instructions (opcodes 58-62)

Implemented 5 MAP instructions: MCPR, MCP, MCPI, MCPS, MCPIS (section 4.13.23).
Copy data from register range or PMEM struct to packet header at `pcursor + SignedOffset`.

Key helper: `copy_regs_to_packet(rs_idx, re_idx, nbytes, dest_addr)` — reads bytes MSB-first across register range, writes to packet header.

Subagent deviations from plan: used subtraction loop instead of `/` (Sail lacks it), `tmod_int` instead of `mod`, `foreach` instead of `while` for PMEM reads.

### 3. Spec review

Read XISA white paper PDF (pages 71-92) for remaining MAP instructions. Categorized by complexity:
- Self-contained: JTL, CPH/CPIH
- Need checksum algo: CHKSUMTST/UPD/CALC
- Need new subsystems: LKP variants, COUNTER, SENDOUT variants

## State at end

- 54 Sail tests passing, 117+ Rust tests passing
- MAP ISA: 68 instruction variants across opcodes 0-62
- Parser ISA: complete
- Working tree: clean
