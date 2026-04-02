# 2026-04-02 (Thursday)

XISA Web Playground designed and implemented: browser-based XISA assembler + simulator using Rust/WASM + Astro/Svelte, with full brainstorm→design→plan→subagent execution cycle.

## Sessions

- **session-01**: sail-xisa web playground — Rust simulator (43 instructions, decode/encode/execute, WASM bridge), Svelte UI (CodeMirror editor, controls, state viewer), Astro site, GitHub Pages CI/CD. Design decisions: Rust over TS/Sail-C for correctness (exhaustive match), Astro+Svelte over React, CodeMirror over Monaco

## Agent index

- XISA-WEB-PLAYGROUND: repo sail-xisa, 16 commits (89883c9..60e62ce). Rust WASM simulator + Astro/Svelte frontend. Port 4322 (4321 occupied by personal site)
- TECH-CHOICES: Rust (exhaustive enum match > TS discriminated unions), Astro (zero-JS doc pages + hydrated islands), Svelte (lightweight), CodeMirror 6 (10-20x smaller than Monaco), plain CSS (public project readability)
- WASM-GOTCHAS: serde arrays >32 can't derive Serialize (use StateSnapshot bridge), Cargo.toml bin target ordering, example programs had wrong assembler syntax
- REMAINING: UI polish, remaining assembler mnemonics, MAP ISA support, Lezer grammar for syntax highlighting, conformance tests vs Sail model
