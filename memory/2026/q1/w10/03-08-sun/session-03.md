Z3Wire session — continued from session-01 (concrete types implementation). This session focused on cleanup, a new feature, and build restructuring.

Key work:

1. **Unified `size_t` width parameter** — `Int` used `unsigned W`, `BitVec` used `size_t W`. Unified to `size_t` everywhere, which eliminated the `std::enable_if_t` workaround and `NOLINT` suppressions for mixed concrete+symbolic overloads. Root cause: clang-18 couldn't handle `requires` clauses when template parameter types differed (`size_t` vs `unsigned`).

2. **Merged plan docs into design doc** — Concrete types design content merged into `docs/dev/design.md`. Deleted `docs/dev/plans/` directory and both plan files. Updated `AGENTS.md` repo map.

3. **Relaxed comparison operators** — Comparisons (`==`, `!=`, `<`, `<=`, `>`, `>=`) now allow different widths and signedness. Both operands extend to a common type: signed if either is signed, `max(W1,W2)+1` if mixing signedness. Implemented across concrete, symbolic, and mixed layers with 14 new tests.

4. **Split build targets** — Single `z3wire` target split into `int` (no Z3 dep), `bool`, `bitvec`. Enforces at build level that concrete types are standalone. Removed convenience `z3wire` aggregator target. Updated examples to depend on `//z3wire:bitvec` directly. CMake follows dependency order (int → bool → bitvec), Bazel uses alphabetical with library+test grouped together.

5. **Added coverage checklist** — `docs/dev/coverage.md` tracks which template instantiations are tested, since line coverage is misleading for template-heavy code. Key gaps identified: signed operations under-tested, W=1/W=64 boundaries sparse, mixed bitwise only tests AND.

Design discussions:
- Comparison relaxation: user correctly pointed out that signed/unsigned comparison is mathematically unambiguous (unlike C++ implicit promotion), so there's no "trap" — we control the semantics
- Build splitting: user pushed back on convenience target (defeats purpose of splitting), on CMake ordering (follow CMake convention not Bazel), and on my incorrect claim about `.cc` files (all libraries are header-only INTERFACE)
- Coverage doc naming: evolved from `test_coverage_checklist.md` → `coverage.md` to match project's short naming convention
