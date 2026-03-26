# Z3Wire Feature Work + API Design Discussion

Project: Z3Wire (https://github.com/qobilidop/z3wire)
Commits: e533934, d6b94cf, e461a77, 5515d9e

## What happened

### 1. Ergonomics brainstorm
- Discussed struct construction friction (symbolic types need z3::context)
- Decided YAGNI — defer helpers until real usage patterns emerge
- Identified 4 ergonomic pain points: `.raw()` noise, literal verbosity, scoped solver checks, struct construction
- Added Ergonomics section to roadmap (commit e533934)

### 2. Competitive analysis
- Researched ~12 similar projects (z3++.h, cpp-smt-wrapper, Smt-Switch, metaSMT, Bitwuzla, cvc5, z3.rs, Z3Py, isla-lib, STP, Pono, Boolector)
- Key finding: Z3Wire is unique in compile-time width checking — no other project does this, not even Rust's z3.rs
- Considered debug/printing solver idea from cpp-smt-wrapper, but rejected since Z3Wire doesn't wrap solver/context
- No new roadmap items from competitive analysis

### 3. Unary negate implementation (commit d6b94cf)
- Design decision: bit-growth (width+1, always signed), consistent with binary subtraction
- Implemented for both BitVec (symbolic) and Int (concrete)
- Symbolic uses `-ext` (z3::expr unary minus), concrete uses `~x + 1` with masking
- 8 tests total (4 concrete, 4 symbolic including consistency with `0 - x`)

### 4. Single-bit extraction (commit e461a77)
- `bit<N>(val)` — trivial delegate to `extract<N, N>(val)`
- Decided to defer `Ubv<1>`/`Bool` friction reduction (YAGNI)

### 5. Combinational logic framing doc (commit 5515d9e)
- Added primitives table to design overview listing all categories and status
- Identified Bool XOR as a gap (expressible as `!=` but no dedicated `^` operator)
- Linked README "combinational logic primitives" to design doc

### 6. SInt::value() discussion (unresolved)
- Problem: `SInt<8>::Literal<-1>().value()` returns `0xFF`, not `-1` — leaky abstraction
- Preferred approach: keep unsigned internal storage (avoids UB), add `signed_value()` returning `int64_t`
- User was tired, deferred to next session

## Key decisions
- Bit-growth for unary negate (not hardware-width) — consistency with binary subtraction
- Reduction operators deferred — `reduce_and`/`reduce_or` expressible via comparisons
- Bool XOR deferred — expressible as `!=`
- No global Z3 context — thread safety concern, hides real dependency
- No solver/context wrapping — users use Z3 directly

## Open items
- `SInt::signed_value()` accessor — next session
- Bool XOR (`^`) operator
- Reduction operators (when use case arises)
- `Ubv<1>`/`Bool` friction (when use case arises)
