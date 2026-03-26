# 2026-03-09 (Monday)

Late night exploration of agentic coding workflows, then a productive evening building the sync-memory skill and making major Z3Wire progress (compile-fail tests, scope clarification, README rewrite, full tooling overhaul).

## Sessions

- **session-00**: Daily log (Gemini) -- late night reading Boris Tane's Claude Code blog post, commute with Lex Fridman Podcast (Peter Steinberger), work day, evening kickoff
- **session-01**: Built `sync-memory` skill for summary propagation, simplified `record-session` to single responsibility
- **session-02**: Z3Wire -- 24 compile-fail tests with custom Starlark rule, tagline update, AGENTS.md structural rules (flat structure, 72-char commit subjects)
- **session-03**: Z3Wire -- scope narrowed to combinational logic primitives, README rewrite with hardware verification framing, tooling overhaul (buildifier, mdformat, shfmt, shellcheck), Bazel 9 upgrade

## Agent index

- sync-memory skill created `.claude/skills/sync-memory/SKILL.md` -- repo-local, re-reads today+yesterday sessions, updates summaries up chain; "today+yesterday" sidesteps timezone ambiguity; idempotent; handles cross-week boundaries (session-01)
- record-session simplified to only write session file -- separation of concerns: raw memory vs summaries (session-01)
- Z3Wire compile-fail test patterns: `template class Foo<>` for class-level static_assert, `checked<>(int64_t{42})` with explicit template args for SFINAE (session-02)
- renamed overflow/underflow -> above_max/below_min -- "underflow" is a float concept (session-02)
- Z3Wire scope: combinational logic primitives only; removed mult/div/mod from roadmap (YAGNI); `.raw()` escape hatch for users (session-03)
- "combinational logic primitives" = bitwise, arithmetic (add/sub/negate), shifting, comparison, multiplexing (ite), bit manipulation (extract/concat), reduction (session-03)
- Z3Wire tagline: "Type-safe Z3 bit-vectors for hardware verification. C++20 and above." (session-03)
- tooling unified: `tools/format.sh`, `tools/lint.sh`; user prefers tooling over good habits for consistency (session-03)
- Bazel 8.6.0 -> 9.0.0, rules_cc 0.0.17 -> 0.2.17; `find -L` needed for symlinks in Bazel 9 external repos (session-03)
- Docker/Colima: `brew install docker-buildx` needs `cliPluginsExtraDirs` in `~/.docker/config.json` (session-03)
- Boris Tane blog post: plan-first, document-driven workflow; superpowers plugin automates the same pattern (session-00)
- macOS auto-punctuation disabled (session-00)
