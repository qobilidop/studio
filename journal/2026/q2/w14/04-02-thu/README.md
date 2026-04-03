# 2026-04-02 (Thursday)

XISA Web Playground designed and fully implemented (Rust/WASM + Astro/Svelte), then polished with GitHub Pages deployment fix, /spec page with WaveDrom encoding diagrams, CI refactor, and naming cleanup. Daily log explored rclone and Z3 SMT encoding strategies.

## Sessions

- **session-00**: Daily log — Gemini Q&A: cloud storage sync tools (rclone gold standard, FreeFileSync, Cyberduck/Mountain Duck), stability comparison (rclone best for unattended), rclone is MIT-licensed Go. Also: Z3 SMT encoding of if-elif-else functions (nested ite vs flat implications vs UF with macro-finder vs arrays/bitvectors), one-hot optimization for mutually exclusive conditions
- **session-01**: sail-xisa web playground — Rust simulator (43 instructions, decode/encode/execute, WASM bridge), Svelte UI (CodeMirror editor, controls, state viewer), Astro site, GitHub Pages CI/CD. Design decisions: Rust over TS/Sail-C for correctness (exhaustive match), Astro+Svelte over React, CodeMirror over Monaco
- **session-02**: sail-xisa web polish — GitHub Pages base path fix, /spec page (sail --doc → doc.json, WaveDrom encoding diagrams, coverage tables, pexecute/mexecute source), CI refactor (web.yml now uses dev container image), renamed execute→pexecute (24 files), nav bar with GitHub icon. Architecture discussions: playground refactor (separate core lib from WASM), diff testing (Rust sim vs Sail C sim), test generation (proptest→Isla→formal), legal (XISA spec is MPLv2, project code Apache 2.0)

## Agent index

- XISA-WEB-PLAYGROUND: repo sail-xisa, 16 commits s01 (89883c9..60e62ce) + ~15 commits s02 (2809f30..18fe159). Rust WASM simulator + Astro/Svelte frontend. Port 4322 (s01)
- SPEC-PAGE: /sail-xisa/spec — sail --doc → doc.json (generated, not checked in), WaveDrom encoding diagrams from encdec/mencdec mappings, coverage tables per spec section, pexecute/mexecute source. MPLv2 notice. Dark theme WaveDrom CSS overrides (s02)
- GHPAGES-FIX: Astro needed `site`+`base` config for /sail-xisa/ subpath, all href→BASE_URL, playground CSS moved from Svelte to Astro slot (client:only can't use BASE_URL). GitHub Pages max-age=600 cache caused stale version (s02)
- CI-REFACTOR: web.yml now uses dev container image (was installing Rust/Node/Sail from scratch), renamed workflows, merged tools/→scripts/, added workflow_dispatch to devcontainer (s02)
- NAMING: execute→pexecute (24 files), P/M prefix convention (parser=P, MAP=M, shared=unprefixed). Sail has no namespaces (s02)
- ARCHITECTURE-DECISIONS: separate core Rust lib from WASM bindings (playground/ + web/simulator/), diff testing (assemble→run both sims→compare JSON), proptest first then Isla then formal, generated artifacts not checked in (s02)
- LEGAL: XISA spec is MPLv2 (white paper p2). Project code Apache 2.0. ISA-derived docs need MPLv2 notice (s02)
- TECH-CHOICES: Rust (exhaustive enum match > TS discriminated unions), Astro (zero-JS doc pages + hydrated islands), Svelte (lightweight), CodeMirror 6 (10-20x smaller than Monaco), plain CSS (public project readability) (s01)
- WASM-GOTCHAS: serde arrays >32 can't derive Serialize (use StateSnapshot bridge), Cargo.toml bin target ordering, example programs had wrong assembler syntax (s01)
- Z3-ITE-ENCODING: 4 approaches — nested ite (priority mux, AST depth=N), flat implications (fresh var R + conjunction, pushes to SAT core), UF with forall+macro-finder (for repeated calls), arrays (for index checks). One-hot optimization drops accumulated negations (s00)
- RCLONE: MIT-licensed Go CLI, gold standard for multi-cloud sync (S3+GDrive+70 providers), aggressive retry, checksum verification, union remote feature (s00)
- REMAINING: UI polish, remaining assembler mnemonics, MAP ISA support, Lezer grammar, conformance tests, playground refactor (separate core lib)
