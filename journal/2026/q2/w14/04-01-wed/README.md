# 2026-04-01 (Wednesday)

Massive productivity day: sail-xisa Parser ISA nearly completed (7 new instructions + full binary encoding + .CD modifier batch + MAP ISA foundation + bit manipulation), personal website built from scratch, and Z3/hash function exploration via Gemini.

## Sessions

- **session-00**: Daily log — wrong laptop mix-up, Gemini Q&A on Z3 + hash functions (Toeplitz is non-cryptographic, linear over GF(2)), SMT approaches to hash problems (UF abstraction vs BitVec encoding)
- **session-01**: sail-xisa — STC/STCI (cursor manipulation), HDR model + STH/STCH/STHC (header metadata), ST/STI (store to struct). 7 instructions, 3 design specs, 23 tests. Coverage: 27/~38 parser variants
- **session-02**: sail-xisa — Completed entire Parser ISA (EXTMAP/MOVMAP, MOVL/MOVR, transition table + NXTP/BRNS/BRNXTP, compound instructions, PSEEK/PSEEKNXTP) + 64-bit binary encoding for all 43 instructions. 24/24 tests. Created modeling-decisions.md, conventions.md
- **session-03**: Personal website (qobilidop.github.io) — Astro SSG, Selenized White/Black theme, dev container on Ubuntu 24.04, GitHub Pages CI/CD. Full brainstorm→design→plan→subagent execution
- **session-04**: sail-xisa — .CD modifier batch (13 parser instructions), MAP ISA foundation (22 instruction variants: arithmetic, logic, branch, control), MAP bit manipulation (SHL/SHR/CONCAT/FFI). 36 tests total

## Agent index

- SAIL-XISA-PARSER-COMPLETE: all 20 spec sections done, ~42 instruction variants, 64-bit binary encoding, 24 test files (s01→s02)
- SAIL-XISA-MAP-ISA: foundation (22 variants) + bit manipulation (6 variants), 16x128-bit register file, ZNCV flags, word-oriented ops (s04)
- SAIL-ENCODING: 64-bit fixed-width, 6-bit opcode, pimem changed to bits(64) vector (NOP=0x0), encdec mapping pattern. 4 off-by-one padding bugs caught by `sail -c` not `--just-check` (s02)
- SAIL-GOTCHAS: loop index bounds need assert-wrapped helpers, `val` reserved keyword, bits4 needs prelude alias, `unsigned()` for bitvec comparison, `sail_ones()` needs `nat`, encdec bit-width errors only caught during C compilation (s01,s02,s04)
- PERSONAL-WEBSITE: qobilidop.github.io built — Astro, Selenized theme, system-ui fonts, dev container quirks (appPort not forwardPorts, --host 0.0.0.0), Colima runtime (s03)
- Z3-HASHES: UF abstraction for crypto hashes in verification (network/blockchain), BitVec for non-crypto (Toeplitz trivially invertible — linear GF(2)). Toeplitz: RSS/ECMP standard, not cryptographic (s00)
- CD-MODIFIER-PATTERN: `if clear_dest then sail_zeros(128) else read_preg(rd)` — applied to 13 parser instructions (s04)
- REMAINING: MAP subroutines (CALL/RET), MAP load/store (needs PMEM/RAM), parser .PR/.SCSM/.ECSM modifiers, MAP ISA section 4 (~54 total instructions)
