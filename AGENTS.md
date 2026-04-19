# AGENTS.md

## Principles

- Think from first principles.
- Prefer simplicity.

## Structure

- `inbox.md` — Transient processing queue
- `journal/` — Context from the past, organized by time
- `library/` — External source notes (`index/`) and raw files (`store/`, gitignored)
- `waiki/` — AI-maintained wiki, synthesized knowledge
- `workshop/` — Small projects (`{yyyy}/{mm}-{dd}-{name}/`)
- `toolbox/` — Reusable tools and agent skills (source of truth)
- `website/` — Personal site

## Ownership

- `waiki/`: agents write, Bili reads. Freely rewritten.
- `toolbox/`: Bili curates, agents consume via deploy.
- `journal/`: session files are immutable once written.
- Everything else: agents + Bili collaborate.

## Conventions

- Writing: straight quotes (`""`), sentence-case headings.
- Git: SSH signing (Ed25519), gitleaks pre-commit hook, direct push to main, squash merge for PRs.
- Dev: macOS, Homebrew, VS Code, Colima. Agents: Claude Code, Codex, Gemini CLI.
- Separate repos for separate projects.
