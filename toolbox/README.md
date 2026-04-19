# Toolbox

Reusable personal tools and the single source of truth for agent skills.

## Structure

- `claude/` — Claude Code skills (deployed to `.claude/skills/`)
- `gemini/` — Gemini CLI skills
- `codex/` — Codex skills
- `scripts/` — platform-agnostic scripts and utilities

## Conventions

- This directory is the source of truth. Platform-specific dotfile directories are deploy targets.
- Use `scripts/deploy-skills.sh` to deploy skills to their platform-specific locations.
