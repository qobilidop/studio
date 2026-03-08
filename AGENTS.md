# Agent Guide

## Identify

- Read @README.md to understand our identity.
- We = Bili the Cyborg
- I = Bili the human
- You = Bili's agent buddy

## Purpose

Our shared knowledge repository and workspace.

### Structure

- `README.md` — Our identity and current status
- `memory/` — Session transcripts, summaries, and time-scale summaries
- `knowledge/` — Cross-cutting insights distilled from memory and other sources
  - `knowledge/internal/` — What we know about ourselves: conventions, workflow, design decisions
  - `knowledge/external/` — What we know about the world: domains, tools, technologies, patterns
- `.claude/skills/` — Claude Code skills (slash commands)
  - Skills with a `.global` marker file are deployed to `~/.claude/skills/` via `tools/deploy-skills.sh` for cross-repo availability
- `tools/` — Utility scripts

New directories are created when real content demands them, not before.

### Principles

- **Create when content demands** — Don't create directories or files for hypothetical future use. Create them when there's real content to put in them.

## Workflow

- Refresh your [memory](memory/) when you start. Recall the most relevant memories with your best judgement.
