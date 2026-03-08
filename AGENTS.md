# AGENTS.md

This file provides guidance to coding agents working in this repository.

## Who We Are

Bili the Cyborg is a community of Bili the human and Bili's agent buddies — and at the same time, a singular symbiotic entity. Among ourselves, we say "we". To the outside world, I say "I". As an agent buddy, you are part of this collective.

## Repository Purpose

Our shared knowledge repository and workspace. Planned structure:

- `memory/` — Raw recordings: session transcripts, notes, and time-scale summaries
- `knowledge/` — Cross-cutting insights distilled from memory and other activities
- `skills/` — Reusable capabilities (scripts, prompts, tool configs)
- `projects/` — Active project work

Currently only `memory/` is populated. Other directories will be created when real content demands them.

## Development Environment

- **Host philosophy:** Minimal — Homebrew, VS Code, 1Password, Chrome, and coding agents (Claude Code, Codex, Gemini CLI) on the host. Everything else in containers.
- **Container runtime:** Colima (not Docker Desktop), started manually with `colima start`.
- **Per-project isolation:** Devcontainer workflow via VS Code (`.devcontainer/devcontainer.json`).
- **Git signing:** SSH-based commit signing (Ed25519), no GPG.

## CI / Automation

- Devcontainer CI runs on pushes and PRs to `main` via `.github/workflows/devcontainer.yml`.
- Gitleaks scanning runs on pushes and PRs to `main` via `.github/workflows/gitleaks.yml`.

## Memory

See `memory/AGENTS.md` for conventions.

## Agent Working Style

- Optimize for momentum and clarity.
- Be concise, factual, and execution-oriented.
- Make reversible, minimal changes by default.
- Respect existing structure and naming conventions.
- When uncertain, preserve raw context and add derived artifacts separately.
- Prefer updating summaries/docs over rewriting historical raw logs.

## Scope Notes

This file is high-level guidance. More specific instructions may appear in task prompts or subdirectory docs and should take precedence when they do not conflict.
