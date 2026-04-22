# 2026 W17 (Apr 20-26)

Symbolic execution deep dive continues: full engine architecture design (stepper/executor/extractor pattern, terminal and undefined states) and survey paper review (Baldoni et al. remains gold standard).

## Days

- [04-20-mon](04-20-mon/README.md): Deep symbolic execution engine architecture design via Gemini — execution state/path data structures, stepping function, worklist engine loop, parent pointer tree for structural sharing, terminal state (projected DTO) and undefined state types, rejected path-as-stepper-input
- [04-21-tue](04-21-tue/README.md): Reading Baldoni et al. symbolic execution survey (arXiv:1610.00502), checked newer surveys, concluded original still best for engine design. Busy period

## Agent index

- SYMEX-ENGINE-DESIGN: canonical architecture settled — Stepper (ExecutionState→list[ExecutionState]) → Executor (worklist, tree via parent pointers) → Extractor (projects TerminalState/UndefinedState). O(1) structural sharing via parent pointers, CoW for production. TerminalState = projected output vars + path condition + path. UndefinedState = reason + faulting instruction + path condition + path (Mon)
- SYMEX-SURVEY: Baldoni et al. 2016 (arXiv:1610.00502) confirmed as gold standard for SE engine design. Post-2016 surveys focus on domain applications, not engine architecture. Emerging directions: LLM-symbolic hybrid, CPS-based parallel compilation (Tue)
- CONTINUATION: builds on W16 practical symbolic executor design (flat path list, copy-and-continue, CoW) — now solidified into full stepper/executor/extractor architecture
