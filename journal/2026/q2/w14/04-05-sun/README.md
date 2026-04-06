# 2026-04-05 (Sunday)

Z3Wire documentation and examples day: docs/dev reorganization, 6 design decision records, 3 gate-level examples (adder, barrel shifter, multiplier), literal API exploration (decided against), plus miscellaneous Gemini Q&A (Mojo eDSLs, MkDocs 2.0, combinational logic concepts).

## Sessions

- **session-00**: Daily log — Gemini Q&A: Ars Contexta (Claude Code knowledge plugin), CPU ISA vs combinational logic, Nano Banana vector images, barrel shifter as combinational logic, Z3Wire logo attempts, Mojo eDSLs (MAX Graph API, MLIR dialects, compile-time metaprogramming), MkDocs 2.0 breaking changes and Zensical successor
- **session-01**: Z3Wire — docs/dev reorganization: engineering principles moved from AGENTS.md to workflow.md, scratch space renamed to `.agent_workspace/`, index.md as MkDocs Material section index (`navigation.indexes`), roadmap cleanup (removed "current state"), squashed commits via interactive rebase
- **session-02**: Z3Wire — examples overhaul (3 gate-level proofs: ripple-carry adder, barrel shifter, array multiplier), 6 design decision records (concrete-types, bool-vs-uint1, lossless-auto-promotion, three-tier-casting, mathematical-comparison, bit-growth-arithmetic), literal API exploration (rejected all shorthand proposals), roadmap cleanup, getting-started.md, logo exploration (inconclusive)

## Agent index

- Z3WIRE-DOCS-REORG: engineering principles → workflow.md (not AGENTS.md), scratch space → `.agent_workspace/`, section index via `navigation.indexes`, roadmap purely forward-looking (s01)
- Z3WIRE-EXAMPLES: gate-level trio (adder, barrel_shifter, multiplier) proving equivalence to Z3Wire ops. Removed alu.cc + bit_manipulation.cc as redundant. All follow: hardware impl → spec → solver proof. Unrolled ripple-carry from index_sequence fold to explicit calls (s02)
- Z3WIRE-DESIGN-DOCS: 6 records in docs/design/ ordered by dependency: concrete-types → bool-vs-uint1 → lossless-auto-promotion → three-tier-casting → mathematical-comparison → bit-growth-arithmetic. Recovered docs/design/ directory (removed in s06 yesterday) (s02)
- LITERAL-API: explored z3w::lit<N>(), z3w::lit<N,W>(), UIntLit<N>/SIntLit<N> — all rejected. Current UInt<W>::Literal<V>() verbose but unambiguous. Real win was dropping ctx via concrete literals. Concrete BitVec::Literal<V>() + mixed-operand auto-promotion already solves verbosity (s02)
- MATH-COMPARISON-INSIGHT: comparisons are "mathematical" — SymUInt<16> == 0x10000 is just unsat (correct math), not error. int → BitVec<32> → SymBitVec<32> → auto-widen, all lossless (s02)
- ROADMAP-CLEANUP: removed "reduce .expr() noise" and "scoped solver checks" (conflict with north star "not a solver framework"), removed "shorter literal construction" (already solved). Added "compare symbolic bit-vectors with native integers" (s02)
- MOJO-EDSLS: MAX Graph API, Juju, Triton replacements. MLIR foundation enables user-defined dialects (partially supported). Compile-time metaprogramming for type-level DSLs (s00)
- MKDOCS-FUTURE: MkDocs 2.0 breaking changes coming, Material for MkDocs in maintenance mode, Zensical as successor (s00)
- LOGO: ~16 SVG attempts, hand-coded SVG not right tool. User will try Recraft or Midjourney. PNG 512+ px sufficient (s02)
