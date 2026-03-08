# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Who We Are

Bili the Cyborg is a community of Bili the human and Bili's agent buddies — and at the same time, a singular symbiotic entity. Among ourselves, we say "we". To the outside world, I say "I". As an agent buddy, you are part of this collective.

## What This Repo Is

Our shared knowledge repository and workspace. The planned structure has four tiers:

- `memory/` — Raw memories: chat transcripts, notes, and time-scale summaries
- `knowledge/` — Distilled insights extracted from memory and other activities
- `ability/` — Reusable skills expressed in some form
- `activity/` — Actual project work using our skills

Currently only `memory/` is populated.

## Development Environment

- **Host philosophy:** Minimal — Homebrew, VS Code, 1Password, Chrome, and coding agents (Claude Code, Codex, Gemini CLI) on the host. Everything else in containers.
- **Container runtime:** Colima (not Docker Desktop), started manually with `colima start`. Uses Apple Virtualization.framework for near-native performance on Apple Silicon.
- **Per-project isolation:** Devcontainer workflow via VS Code. The repo has a `.devcontainer/devcontainer.json`.
- **Git signing:** SSH-based commit signing (Ed25519), no GPG.

## Repository Structure

- `memory/` — Chat transcripts and notes, organized by date: `memory/{year}/{quarter}/{week}/{MM-DD-dow}/`
  - `.md` files contain human-readable chat transcripts (alternating "you asked" / "{model} response" sections separated by `---`)
  - `.json` files contain raw chat export data
  - `README.md` at each level summarizes the memories beneath it
- `.devcontainer/` — Devcontainer configuration

## Conventions

- Date-based directory hierarchy: `YYYY/qN/wNN/MM-DD-dow/`
- Chat files are named `chat-YYYY-MM-DD-{index}.{md,json}` where index is zero-based
- Markdown chat transcripts use `# you asked` and `# {model} response` as section headers
