# 2026-03-11 (Wed)

## Sessions

### session-00: Placeholder
- No content yet.

### session-01: Z3Wire feature work + API design (Claude)
- Ergonomics brainstorm: identified 4 pain points (.raw() noise, literal verbosity, scoped solver checks, struct construction); deferred helpers (YAGNI)
- Competitive analysis: ~12 projects surveyed; Z3Wire is unique in compile-time width checking (no other project does this, not even Rust's z3.rs)
- Unary negate: bit-growth (width+1, always signed), `-ext` for symbolic, `~x+1` for concrete
- Single-bit extraction: `bit<N>(val)` delegates to `extract<N,N>(val)`
- Combinational logic framing doc: primitives table in design overview, Bool XOR identified as gap
- SInt::value() returns unsigned — needs `signed_value()` accessor (deferred)

## Key decisions
- Bit-growth for unary negate (consistency with binary subtraction)
- Reduction operators deferred (expressible via comparisons)
- Bool XOR deferred (expressible as `!=`)
- No global Z3 context (thread safety), no solver/context wrapping

## Open items
- `SInt::signed_value()` accessor
- Bool XOR (`^`) operator
- Reduction operators, `Ubv<1>`/`Bool` friction (when use case arises)
