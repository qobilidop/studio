# Session 02 — Z3Wire examples overhaul + design docs + literal API exploration

Repo: `github.com/qobilidop/z3wire`

## Examples

- Replaced `examples/safe_adder.cc` → `examples/adder.cc`: gate-level ripple-carry adder (half_adder → full_adder → 8-bit chain) proved equivalent to Z3Wire bit-growth `a + b` + `checked_cast`. Uses `SymUInt<1>` throughout for gate logic (`&`, `|`, `^`), not `SymBool`.
- Added `examples/barrel_shifter.cc`: 3-layer mux-based barrel shifter proved equivalent to `shl(data, amt)` + `checked_cast`.
- Added `examples/multiplier.cc`: 4×4 array multiplier from AND gates + half/full adders, proved equivalent to `a * b`. Reuses adder primitives.
- Removed `examples/alu.cc` and `examples/bit_manipulation.cc` — redundant with the gate-level trio.
- All three gate-level examples follow same structure: hardware impl → spec in Z3Wire → solver equivalence proof.
- README descriptions unified to "matches intended semantics" instead of leaking implementation details.
- Unrolled the ripple-carry adder from `index_sequence` fold to explicit 8 `full_adder` calls — much clearer for an example.

## Roadmap cleanup

- Removed "Reduce `.expr()` noise" and "Scoped solver checks" — both conflict with north star's "not a solver framework" boundary. `.expr()` is the designed interface between Z3Wire and raw Z3.
- Removed "Shorter literal construction" — discovered concrete `BitVec::Literal<V>()` + mixed-operand auto-promotion already solves the verbosity. Updated `packet_gen.cc` to use `UInt<N>::Literal<V>()` instead of `SymUInt<N>::Literal<V>(ctx)`.
- Added roadmap item: "Compare symbolic bit-vectors with native integers" — `ethertype == 0x0800` via lossless promotion chain. Blocked on auto-promotion strategy review.

## Literal API design exploration (decided NOT to add)

Explored several shorthand APIs, all rejected:
- `z3w::lit<N>()` (auto-width): signedness ambiguous (C++ `0xFF` is `int`/signed), surprising auto-widths (`lit<0>()` → `UInt<1>`).
- `z3w::lit<N, W>()` (explicit width): just a different spelling of `Literal`, marginal improvement.
- `z3w::UIntLit<N>` / `z3w::SIntLit<N>`: solves signedness but auto-width surprise remains, adds API surface.
- Conclusion: current `UInt<W>::Literal<V>()` is verbose but unambiguous. The real win was dropping `ctx` via concrete literals.

Key insight: for comparisons, native integers could work because Z3Wire comparisons are "mathematical" — they compare values, not types. `SymUInt<16> == 0x10000` is just unsat (correct math), not an error. No lossy conversion occurs: int → BitVec<32> (native width, lossless) → SymBitVec<32> (lossless) → auto-widen comparison (lossless).

## Design docs (`docs/design/`)

Recovered `docs/design/` directory. Created 6 design decision records:

1. `concrete-types.md` — why concrete types exist (compile-time width, range checking, C++ implicit conversion firewall), why minimal ops (computation belongs in symbolic/native domains)
2. `bool-vs-uint1.md` — why separate types despite value set bijection (different Z3 sorts, different semantic domains, different operator sets). Conversion explicit via `as_bool()`/`as_uint1()` for domain clarity.
3. `lossless-auto-promotion.md` — comprehensive type tier analysis (native/concrete/symbolic), value set inclusion criterion, all promotion dimensions (concreteness, width, signedness, kind), current behavior tables, rejected alternatives
4. `three-tier-casting.md` — safe_cast (compile-time), checked_cast (solver-verified), unsafe_cast (unchecked). Why safe_cast forbids signed→unsigned (value set never subset). checked_cast round-trip implementation.
5. `mathematical-comparison.md` — why all 6 comparison ops accept any width/signedness combination. Widening rule: same sign = max(W1,W2), mixed = max(W1,W2)+1. Contrast with bitwise (strict match) and arithmetic (bit-growth).
6. `bit-growth-arithmetic.md` — why `+`/`-`/`*`/`shl` widen results. Overflow impossible by construction, truncation explicit via checked_cast. Width table for each op. References CIRCT hwarith.

Ordered by dependency: types → promotion → operators.

## Docs structure

- Added `docs/getting-started.md` — reading guide for new visitors (types → operations → examples → design → contribute).
- Added `docs/usage/index.md` for consistency with other sections.
- Added Design section to mkdocs nav.
- Added `@docs/design/index.md` and `@docs/usage/index.md` to AGENTS.md as "Extra reference".
- Fixed `UInt\<1>` rendering in MkDocs — use backticks in headings, quotes in YAML nav.

## AGENTS.md

- Simplified scratch space instruction: "Write all temporary files (plans, specs, drafts) to `.agent_scratch/`. It is gitignored. Never write temporary files to `docs/` or other tracked directories."
- Reorganized: Scratch space (constraint) → Must reads (dev docs) → Extra reference (design/usage indexes).
- Added `<!-- dprint-ignore -->` to Reference section for consistency.

## Logo exploration

Tried ~16 SVG logo concepts. Conclusion: hand-coded SVG isn't the right tool for logo polish. User will try Recraft or Midjourney. Rasterized PNG at 512+ px is sufficient for GitHub/docs use cases.

## User preferences observed

- Prefers "intended semantics" over implementation-specific descriptions in user-facing text.
- Values minimal API surface — rejected multiple shorthand proposals that added surface without adding capability.
- Wants docs to be self-sufficient (not dependent on GitHub README being read first).
- Tagline in README may have been changed in a prior session and reverted — to be fixed in a future session.
