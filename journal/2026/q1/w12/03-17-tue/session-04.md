# Session 04 — Z3Wire Docs Consolidation, Packet Gen Example, API Naming

Repo: https://github.com/qobilidop/z3wire

## Work Done

### 1. Consolidated example docs into self-contained .cc programs
- Deleted 3 redundant `docs/examples/*.md` pages (safe-adder, alu, bit-manipulation)
- Created `examples/README.md` as index table for GitHub browsing
- Changed doc site "Examples" nav to link directly to GitHub (`https://github.com/qobilidop/z3wire/tree/main/examples`) — simplest solution after trying and abandoning `include-markdown` approach (broken due to relative links not resolving in mkdocs, and Material button syntax needing `attr_list`/`pymdownx.emoji` extensions)
- Enriched all 5 `.cc` files with `// Run:` commands and improved header comments
- Updated stale references in getting-started.md, cast-rename.md, shift-redesign.md
- Commit: `c08ec88`

### 2. README improvements
- Tightened quick example wording
- Simplified license section
- Commit: `1fa49da`

### 3. New packet_gen example
- 54-byte (432-bit) symbolic packet buffer, solved twice for IPv4 and IPv6
- IPv4: constrained dst in 10.0.0.0/8, TTL > 0, protocol=253 (RFC 3692 experimental)
- IPv6: version=6, next_header=59 (No Next Header), hop_limit > 0
- Prints hex strings verifiable at https://hpd.gasmi.net/
- Key fix: had to set ipv4_protocol to 253 instead of leaving unconstrained (Z3 picked 0 = Hop-by-Hop, which confused the decoder)
- Commit: `381fa22`

### 4. Added `to_concrete` for SymBitVec and SymBool
- Symmetric counterpart to `to_symbolic`
- Return type auto-derived from symbolic type (no explicit template parameter needed)
- Uses `get_numeral_uint64()` for unsigned, `get_numeral_int64()` for signed (discovered via TDD that `get_numeral_int64` throws for values > INT64_MAX)
- `static_assert(W <= 64)` since BitVec doesn't support wider
- Commit: `0d287dd`

### 5. API naming cleanup
- Renamed `as_ubv1` → `as_uint1` (mirrors `SymUInt<1>` type alias)
- Renamed `to_concrete` parameter from `val` to `symbolic` (symmetric with `to_symbolic`)
- Commit: `45ab61a`

### 6. Removed `exact_eq`
- After extensive research across HDLs (Verilog, VHDL, Chisel, SpinalHDL, Amaranth, Clash), SMT solvers (Z3, Rosette), and libraries (Haskell bv, foonathan/type_safe, Rust crates)
- Concluded: two equality functions is confusing, and widening never produces wrong answers
- Only Haskell's `bv` package offers both strict (`==.`) and relaxed (`==`) equality
- Explored `assert_same_type` as composable alternative but decided it's unidiomatic in C++ (void function as compile guard)
- Commit: `c6c87b2`

## Key Design Discussions

### Naming conventions established
- `to_` = conversion (changes representation): `to_symbolic`, `to_concrete`
- `as_` = reinterpretation (same bits): `as_unsigned`, `as_signed`, `as_bool`, `as_uint1`
- `_cast` = type conversion with safety tiers: `unsafe_cast`, `safe_cast`, `checked_cast`

### Rejected ideas
- Byte-oriented `extract` API — user can build a trivial wrapper; keeps core unopinionated
- Constructor for concrete→symbolic — free function `to_symbolic` better because of type deduction
- `U<W>`/`S<W>` short type aliases — too terse for a library; `UInt<W>`/`SInt<W>` already short and self-documenting
- Extending BitVec to >64 bits — put on roadmap as "maybe"

### User preferences observed
- Strongly prefers simplest solution (e.g., direct GitHub link over include-markdown machinery)
- Values API minimalism — actively removes features that don't strongly justify themselves
- Likes to iterate on naming carefully with research
