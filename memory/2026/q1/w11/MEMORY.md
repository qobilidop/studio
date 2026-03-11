# 2026 W11 (Mar 9–15)

## What happened

- Reflected on agentic coding best practices (Boris Tane's Claude Code blog post)
- Explored personal website hosting: GitHub Pages vs custom domain, digital longevity concerns
- Built `sync-memory` skill — re-reads today+yesterday sessions, updates summaries up the chain
- Simplified `record-session` skill — now only writes session file (single responsibility)
- Z3Wire compile-fail tests (24 targets), scope narrowed to combinational logic primitives
- Z3Wire README rewrite with hardware verification framing, tooling overhaul (buildifier, mdformat, shfmt, shellcheck)
- Bazel 9 upgrade, removed mult/div/mod from roadmap (YAGNI)
- Deep dive into combinational logic: ITE as fundamental routing primitive
- C++ vs Python tradeoff for hardware verification tooling
- Recorded notable projects: HashMath, AutoCLRS, Bjarke Roune's AI chip design doc
- Implemented `bitfield_eq` in z3wire with full tests and docs
- mdformat-mkdocs fix, naming audit, project polish in z3wire

## Key decisions

- Skill separation: record-session = raw memory, sync-memory = summaries
- sync-memory is repo-local (not global) — tied to this repo's memory structure
- Personal website: leaning toward github.io for zero-cost permanence
- macOS: disabled auto-punctuation
- z3wire: keep snake_case (matches Z3 C++ API), LSB-first for bitfields
