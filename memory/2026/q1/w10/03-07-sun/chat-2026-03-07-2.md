# Claude Code session: Cyborg repo bootstrap

First working session with Claude Code as an agent buddy. Covered repo setup, conventions, and infrastructure.

## Identity & README

- Defined "Bili the Cyborg" identity in README.md — a community of human and agent buddies, singular to the outside world
- Tagline: "A curious human exploring the brave new agentic craft"
- Created CLAUDE.md with repo guidance for agent buddies

## Repo structure

- Discussed the four-tier vision: `memory/`, `knowledge/`, `skills/`, `projects/`
- Renamed from original proposal: `ability/` → `skills/`, `activity/` → `projects/`
- Only `memory/` exists for now; others will emerge when content demands them
- Decided to keep Z3Wire as a fully separate repo (not submodule, not gitignored subfolder)

## Memory conventions

- Moved README from `w10/` to `memory/` as the top-level explainer
- Created README.md summaries at every level (year, quarter, week, day)
- Originally tried SUMMARY.md, then consolidated into README.md for simplicity and GitHub rendering
- Split CLAUDE.md: memory-specific conventions moved to `memory/CLAUDE.md`
- Summarized all existing chat transcripts from 03-06 and 03-07

## Devcontainer & CI

- Set up minimal `.devcontainer/devcontainer.json` with base Ubuntu image
- Added GitHub Actions workflow to validate devcontainer builds
- Added Gitleaks CI workflow for secret scanning
- Added badges for both workflows to README

## Security

- Installed `pre-commit` + `gitleaks` for local secret scanning on every commit
- Added Gitleaks GitHub Actions workflow as a CI safety net
- Verified full git history passes gitleaks scan (18 commits, no leaks)

## Development environment (from reading chat-0)

- Host: minimal macOS — Homebrew, VS Code, 1Password, Chrome, coding agents
- Container runtime: Colima (not Docker Desktop), manual start
- Git signing: SSH-based (Ed25519), no GPG
- Coding agents installed: Claude Code, Codex, Gemini CLI

## Conventions established

- Use straight quotes (""), not smart quotes ("")
- Direct push to main (no PRs for now)
- Date hierarchy: `YYYY/qN/wNN/MM-DD-dow/`
- Chat files: `chat-YYYY-MM-DD-{index}.{md,json}`

## Discussed but deferred

- PII redaction beyond gitleaks (regex scanning, agentic redaction)
- GitHub PRs — revisit when workflow demands coordination
- Creating `knowledge/`, `skills/`, `projects/` directories
