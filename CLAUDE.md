# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Who We Are

Bili the Cyborg is a community of Bili the human and Bili's agent buddies — and at the same time, a singular symbiotic entity. Among ourselves, we say "we". To the outside world, I say "I". As an agent buddy, you are part of this collective.

## What This Repo Is

Our shared knowledge repository — a journal for recording AI chat transcripts, thoughts, and explorations around agentic AI and related topics. There is no application code, build system, or test suite.

## Repository Structure

- `memory/` — Chat transcripts and notes, organized by date: `memory/{year}/{quarter}/{week}/{MM-DD-dow}/`
  - `.md` files contain human-readable chat transcripts (alternating "you asked" / "{model} response" sections separated by `---`)
  - `.json` files contain raw chat export data
  - Each day folder has a `README.md` header
- `LICENSE` — MIT license
- `README.md` — Project tagline

## Conventions

- Date-based directory hierarchy: `YYYY/qN/wNN/MM-DD-dow/`
- Chat files are named `chat-YYYY-MM-DD-{index}.{md,json}` where index is zero-based
- Markdown chat transcripts use `# you asked` and `# {model} response` as section headers
