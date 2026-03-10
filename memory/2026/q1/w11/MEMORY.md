# 2026 W11 (Mar 9–15)

## What happened

- Reflected on agentic coding best practices (Boris Tane's Claude Code blog post)
- Explored personal website hosting: GitHub Pages vs custom domain, digital longevity concerns
- Built `sync-memory` skill — re-reads today+yesterday sessions, updates summaries up the chain
- Simplified `record-session` skill — now only writes session file (single responsibility)

## Key decisions

- Skill separation: record-session = raw memory, sync-memory = summaries
- sync-memory is repo-local (not global) — tied to this repo's memory structure
- Personal website: leaning toward github.io for zero-cost permanence
- macOS: disabled auto-punctuation
