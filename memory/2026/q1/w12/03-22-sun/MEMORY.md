# 2026-03-22 (Sunday)

## Z3Wire operations doc overhaul + implementation fixes

Major overhaul of `docs/usage/operations.md` — added per-operation typing rule tables to all 8 operation categories. Synced implementation and examples to match.

### Doc improvements
- Added typing rule tables to: Logical, Bitwise, Comparison, Arithmetic, Shifting, Rotation, Bit manipulation, Conditional selection
- Renamed: "Mux" → "Conditional selection", "Unary negate" → "Arithmetic negation"
- Split Comparison into "Boolean comparison" and "Integer comparison"
- Used `A`, `B` for different-width params, `W` for same-width

### Implementation changes
- **Fixed arithmetic typing (CIRCT hwarith rules)**: `arith_result_width()` for mixed-signedness. `ui<A> op si<B>` → width `A+2` if `A>=B`, else `B+1`.
- **Removed `bit<N>()`**: just `extract<N,N>()`. Won't add `set_bit` either — `replace` covers it.
- **Added `replace` operation**: inverse of `extract`. Static + symbolic-offset variants. Result preserves source signedness.
- **Added `SymBool` support to `concat`**: `internal::sym_width` trait + `internal::to_bv_expr` overloads.
- **Added `SymBool` support to `ite`**: inline overload.

### Design decisions
- Bitwise ops on both signed/unsigned (matches Chisel, VHDL, Yosys). Cross-signedness forbidden.
- Core bit manipulation = extract, replace, concat.
- `implies` operator: deferred (just `!a || b`).
- NAND/NOR/XNOR: YAGNI.

### Files changed
- `docs/usage/operations.md`, `docs/design/overview.md`
- `z3wire/sym_bit_vec.h`, `z3wire/sym_bit_vec_test.cc`
- `examples/usage/operations.cc`, `examples/usage/BUILD.bazel`

## Repo organization design

Clarified purpose/boundaries for multi-repo setup (design conversation, no code).

### Meta-layer (5 stable repos)

| Repo | Visibility | Purpose | Decision test |
|------|-----------|---------|---------------|
| Cyborg | Public | Agentic workspace | Am I working *with* agents? |
| Artisan | Public | Human-first workspace | Am I the sole creative driver? |
| Hermit | Private | Legacy — journal, reflections | Would I keep this after I die? |
| Clert | Private | Logistics — life management | Do I just need this done? |
| Website | Public | Personal website | Is this for the world to see *now*? |

### Key decisions
- Cyborg vs Artisan: separate to prevent agent infrastructure from polluting creative space
- Hermit vs Clert: has voice → Hermit; structured data → Clert
- Dotfiles → Cyborg
- Personal website roadmap: identity page → blog → portfolio → digital garden

## Daily log
- Focus day on Z3Wire, but productivity hampered by physical condition (headache, stayed up late previous night)
- Pre-work routine: brunch, dinner prep, shower, water prep, 30-min nap
- Made progress but didn't complete all planned Z3Wire work
