# 2026-03-09 (Monday)

First day of W11. Four sessions.

## Key events

- Late night (2 AM) into morning — stayed up exploring agentic coding, read Boris Tane's Claude Code blog post
- Noted superpowers plugin aligns with Boris' structured planning-before-execution philosophy
- Commute: Lex Fridman Podcast with Peter Steinberger
- Evening: agentic coding session — built sync-memory skill, simplified record-session
- Major z3wire work: compile-fail tests, scope clarification, README rewrite, tooling overhaul

## Readings

- Boris Tane's blog post on Claude Code usage: plan-first, document-driven workflow
- Compared superpowers plugin to Boris' manual discipline approach — same pattern, automated

## Personal website considerations

- Evaluated GitHub Pages vs standalone hosting with custom .dev domain
- Key concern: digital longevity after death — custom domains expire without renewal
- Alternatives explored: Neocities, Cloudflare Pages, Arweave
- Leaning toward github.io for zero-cost permanence

## Skills work (session-01)

- Created `sync-memory` skill (repo-local): re-reads today+yesterday session files, updates summaries up the chain
- Simplified `record-session` skill: now only writes session file, no summary updates
- Separation of concerns: record-session = raw memory, sync-memory = summaries
- Design: "today+yesterday" sidesteps timezone ambiguity; idempotent; handles cross-week boundaries

## Z3Wire work (sessions 02–03)

### session-02: Compile-fail tests + tagline update
- 24 compile-fail test targets in `compile_fail_tests/` with custom Starlark rule
- Key patterns: `template class` for class-level guards, `checked<>()` with explicit template args for SFINAE
- Tagline: "Type-safe Z3 bit-vectors for hardware verification. C++20 and above."
- Renamed overflow/underflow → above_max/below_min (underflow is a float concept)
- Added flat structure principle, 72-char commit subject limit to AGENTS.md

### session-03: Scope clarification, README rewrite, tooling overhaul
- **Removed mult/div/mod from roadmap** — Z3Wire covers combinational logic primitives; YAGNI
- Adopted "combinational logic primitives" as scope framing
- README rewrite: hardware verification framing, carry flag example
- Added formatters/linters: buildifier (Bazel), mdformat (Markdown), shfmt + shellcheck (Shell)
- Unified in `tools/format.sh` and `tools/lint.sh`
- Bazel 8.6.0 → 9.0.0, rules_cc 0.0.17 → 0.2.17
- Docker/Colima: `docker-buildx` CLI plugin path fix via `~/.docker/config.json`

## System preferences

- Turned off macOS auto-punctuation
