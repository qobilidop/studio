# 2026-04-20 (Monday)

Deep symbolic execution architecture design session via Gemini. Covered execution state/path data structures, stepping function, execution tree, state extraction, and terminal/undefined state types.

## Sessions

- **session-00**: Daily log (Gemini) — Detailed symbolic execution engine architecture design. Execution state (PC, symbolic store, path condition) vs execution path (sequence of states). Stepping function as pattern matcher over instruction types (assign, branch, halt). Engine loop (worklist + search strategy). Parent pointer tree for structural sharing vs naive path copying. Terminal state as projected DTO (output variables + path condition + path). Undefined state for intentional UB capture (reason, faulting instruction, path condition). Rejected path-as-input-to-stepper anti-pattern (O(N) duplication, violates semantic locality). Final architecture: stepper works on state, states form tree via parent pointers, executor builds tree, extractor projects terminal/undefined states with embedded paths

## Agent index

- SYMEX-ARCHITECTURE: canonical design settled — Stepper (local evaluator, ExecutionState in, list of ExecutionState out) → Executor (worklist loop, builds tree via parent pointers) → Extractor (walks parent pointers, projects to TerminalState/UndefinedState). Key decisions: parent pointer tree for O(1) structural sharing, not fat path copying. TerminalState = projected output vars + path condition + path. UndefinedState = reason + faulting instruction + path condition + path. Path-as-stepper-input rejected (O(N) duplication, breaks semantic locality). Persistent/CoW data structures for production (s00)
- SYMEX-DATA-STRUCTURES: ExecutionState (PC, memory dict, path_condition list, parent pointer). TerminalState (output_variables, path_condition, path). UndefinedState (reason, faulting_instruction, path_condition, path). ExecutionPath (state_history, branch_decisions). SMTSolver.is_satisfiable() as feasibility oracle at branches (s00)
