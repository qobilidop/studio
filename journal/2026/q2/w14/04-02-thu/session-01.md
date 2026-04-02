# Session 01 — XISA Web Playground: Design → Implementation

**Repo:** `github.com/qobilidop/sail-xisa`
**Branch:** `main` (direct commits, no feature branch)
**Commits:** `89883c9..60e62ce` (16 commits)

## What happened

Full brainstorm → design → plan → implementation cycle for a browser-based XISA Parser ISA playground.

### Brainstorming decisions

- **Rust simulator over Sail C→WASM**: Sail C backend requires Emscripten + GMP cross-compilation — overkill for a 43-instruction ISA. Rust `enum` + `match` gives exhaustive handling (compile error if instruction missed), closest to Sail's scattered functions.
- **Rust over TypeScript for simulator**: TS lacks exhaustive match on discriminated unions. Missing a case is runtime error, not compile error. Rust's correctness guarantee matters for a conformance implementation.
- **Assembler in Rust, not TS**: Shares types with simulator (same `Instruction` enum). One implementation for both browser (WASM) and CLI. Avoids maintaining two assemblers.
- **Astro over Vite-only**: Site will have both docs pages and interactive playground. Astro ships zero JS for doc pages, hydrates only playground islands.
- **Svelte over React/Preact**: Lightweight enough for 3 interactive panels. Smaller bundle.
- **CodeMirror 6 over Monaco**: 10-20x smaller. Better custom language support (Lezer grammars). Monaco is overkill.
- **Plain CSS over Tailwind**: Public project — clean HTML without utility class clutter is more readable.
- **Port 4322**: User's personal site occupies 4321.

### Design spec

`docs/specs/2026-04-01-web-playground-design.md`

### Implementation plan

`docs/plans/2026-04-01-web-playground-plan.md` — 13 tasks, 7 phases.

### Implementation (subagent-driven)

Used subagent-driven-development skill. One subagent per task, sonnet model for all implementation tasks. No spec/quality reviews done (skipped for speed). All tasks completed in one session.

**Rust simulator** (`web/simulator/`):
- `types.rs`: 43 `Instruction` variants, `Reg`, `Condition`, `BitTestCond`, `StepResult`, `ExecResult`
- `state.rs`: `SimState` with all parser state, `extract_bits`/`insert_bits`/`extract_packet_bits` helpers
- `decode.rs`: 64-bit binary → Instruction (44 opcodes)
- `encode.rs`: Instruction → 64-bit binary (inverse of decode, roundtrip tested)
- `execute.rs`: All 43 instruction semantics + `step()` function
- `assembler.rs`: Core subset (NOP, HALT, MOV, MOVI, EXT, ADD, SUB, AND, OR, CMP, BR, BRBTST, STCI, STH) with label support
- `lib.rs`: WASM bridge via `wasm-bindgen` — `Simulator` struct with init/step/get_state/assemble_and_load/reset
- `bin/xisa-asm.rs`: CLI assembler
- 43 Rust tests passing

**Web UI** (`web/src/`):
- Astro site with Svelte islands
- `Playground.svelte`: wires editor + controls + state viewer
- `Editor.svelte`: CodeMirror 6 with one-dark theme, 3 example programs
- `Controls.svelte`: Assemble/Step/Run/Reset buttons
- `StateViewer.svelte`: registers, flags, PC, cursor, packet header hex dump

**CI/CD**: `.github/workflows/web.yml` — Rust tests + WASM build + Astro build + GitHub Pages deploy.

### Issues encountered & fixed

- **Serde on SimState**: Arrays >32 elements can't derive Serialize. Fix: removed Serialize from SimState, WASM bridge uses separate `StateSnapshot` struct.
- **Cargo.toml bin target**: Referenced `xisa-asm.rs` before it existed. Temporarily commented out, uncommented after Task 8.
- **Dockerfile missing curl**: Ubuntu 24.04 base doesn't include curl. Added `curl ca-certificates` to apt-get.
- **Port conflict**: Port 4321 occupied by user's personal Astro site. Used 4322 + `appPort` in devcontainer.json.
- **devcontainer exec doesn't forward ports**: Need `appPort` in devcontainer.json + container recreation. `devcontainer exec` shares network namespace but background processes don't persist well.
- **Example programs wrong syntax**: Subagent wrote examples with wrong assembler syntax (MOVI missing size arg, BNZ instead of BR.NZ, EXT wrong operands). Fixed manually.

## Remaining work

- Polish playground UI (user mentioned this)
- Add remaining assembler mnemonics (SUBII, ANDI, ORI, CNCTBY, CNCTBI, MOVL/MOVR variants, STC, STCH, STHC, ST, STI, EXTMAP, MOVMAP, NXTP, PSEEK, etc.)
- MAP ISA support (deferred by design)
- Documentation pages
- CodeMirror Lezer grammar for XISA syntax highlighting
- Verify GitHub Pages deployment works
- Conformance tests against Sail model test cases
