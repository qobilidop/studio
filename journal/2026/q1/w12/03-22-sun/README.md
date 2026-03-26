# 2026-03-22 (Sunday)

Z3Wire operations doc overhaul with typing rule tables for all 8 categories, fixed arithmetic typing for mixed-signedness, added `replace` operation, and designed multi-repo organization with 5 meta-layer repos. Productivity limited by physical condition.

## Sessions

- **session-00**: Daily log — focus day on Z3Wire, but productivity hampered by headache from late night; pre-work routine (brunch, dinner prep, shower, nap)
- **session-01**: Repo organization design — defined 5 meta-layer repos (Cyborg, Artisan, Hermit, Clert, Website) with decision tests, personal website roadmap (identity to blog to portfolio to digital garden)
- **session-02**: Z3Wire operations doc overhaul — per-operation typing rule tables for all 8 categories, fixed arith_result_width() for mixed-signedness (CIRCT hwarith rules), added replace operation, SymBool concat/ite support, removed bit<N>()

## Agent index

- DECISION: arithmetic result width for mixed-signedness — `ui<A> op si<B>` yields width `A+2` if `A>=B`, else `B+1` (CIRCT hwarith rules); old rule `max(W1,W2)+1` was too narrow (session-02)
- DECISION: `replace` operation added as inverse of `extract`; static + symbolic-offset variants; result preserves source signedness (session-02)
- DECISION: removed `bit<N>()` (just `extract<N,N>`); core bit manipulation = extract, replace, concat (session-02)
- DECISION: bitwise ops on both signed/unsigned (matches Chisel, VHDL, Yosys); cross-signedness forbidden (session-02)
- DECISION: `implies` deferred to roadmap (just `!a || b`); NAND/NOR/XNOR YAGNI (session-02)
- DESIGN: multi-repo organization — Cyborg (agentic), Artisan (human-first creative), Hermit (voice/legacy), Clert (logistics), Website (public-facing); decision tests for each (session-01)
- DESIGN: Cyborg vs Artisan separated to prevent agent infrastructure polluting creative space; Hermit vs Clert — has voice = Hermit, structured data = Clert; dotfiles go in Cyborg (session-01)
- DESIGN: personal website roadmap — identity page, then blog, portfolio, digital garden; content in website repo initially (session-01)
- BLOCKER: physical condition (headache) reduced productivity (session-00)
