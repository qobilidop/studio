# 2026-04-09 (Thursday)

Racket language-oriented programming deep dive (readers, s-expressions, source-to-source compilation, Rosette for SMT), Python eDSL comparison, Z3Wire branding and config migration, and studio repo skill path fixes.

## Sessions

- **session-00**: Daily log (Gemini) — Racket as s-expressions + language-oriented programming (LOP), custom Readers (parser → Syntax Objects → Expander), Racket interop (C FFI dynamic loading, limited high-level language interop), source-to-source compilation examples (C++ boilerplate gen, Rosette → SMT-LIB/Z3, Pollen → HTML), comparison: Racket LOP vs Python eDSL (AST → IR → backend), tradeoffs: syntactic freedom vs ecosystem integration
- **session-01**: Z3Wire branding — designed `<W>` logo (encodes Z/3/W on 16x16 grid, adaptive SVG with prefers-color-scheme), README styling (Vite-style centered layout with picture element), tagline refined ("Compile-time safe bit-vectors for Z3"), mkdocs.yml → zensical.toml migration, dprint TOML plugin 0.6.4 → 0.7.0, TOML v1.0 inline table formatting limitations

## Agent index

- RACKET-LOP: Reader (custom parser → Syntax Objects with scope+location metadata) → Expander (macros → core Racket) → bytecode. `#lang` directive enables completely custom syntax. Homoiconicity (code=data) enables powerful macros. Compared to Python eDSL: Racket has full syntactic freedom but worse tooling/ecosystem (s00)
- SOURCE-TO-SOURCE: Racket as offline compiler — emit C++/Python/SMT-LIB from custom DSL. Key example: Rosette (solver-aided programming, translates Racket to SMT assertions for Z3). Pollen for document compilation. No runtime overhead or ecosystem lock-in (s00)
- PYTHON-EDSL-VS-RACKET: Python eDSL wins on tooling (highlighting, autocomplete, linters, AI support) and ecosystem. Racket wins on syntactic freedom and error reporting (Syntax Objects carry source locations through expansion). Python AST→IR→backend is pragmatic choice for most domains (s00)
- Z3WIRE-BRANDING: `<W>` logo — left zigzag=Z, right zigzag=3, center=W, embedded `<>` brackets. SVG prefers-color-scheme works in img tags and favicons. GitHub picture element for theme-aware README images (s01)
- ZENSICAL-TOML: mkdocs.yml→zensical.toml mapping (top-level→[project], palette→[[project.theme.palette]], extensions→[project.markdown_extensions.X]). dprint TOML excluded zensical.toml because taplo inlines arrays of inline tables (TOML v1.0 spec limitation) (s01)
