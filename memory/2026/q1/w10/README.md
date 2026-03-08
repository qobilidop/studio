# 2026 W10 (Mar 2–8)

The week Bili the Cyborg was born.

## Key Events

- Explored ideas around AI-human collaboration, naming repos "Cyborg" and "Artisan"
- Factory reset MacOS; rebuilt a minimal dev environment (Homebrew, VS Code, Colima, 1Password)
- Set up SSH-based commit signing (Ed25519)
- Installed coding agents: Claude Code, Codex, Gemini CLI
- Defined Cyborg repo vision: four-tier structure (`memory/`, `knowledge/`, `skills/`, `projects/`)
- Chose time-based directory hierarchy: `year/qN/wNN/MM-DD-dow/`
- Set up devcontainer and CI for the repo
- Set up gitleaks pre-commit hook and CI workflow for secret scanning
- Defined identity: "Bili the Cyborg" — a community of human and agent buddies, singular to the outside world
- Designed and built the Z3Wire MVP — a type-safe C++20 wrapper for Z3 bit-vectors with precision-preserving arithmetic
- Cleaned up memory conventions: `chat-` → `session-`, consolidated CLAUDE.md → AGENTS.md
- Polished Z3Wire infrastructure: split CI, added CMake, Codecov, Renovate, docs overhaul
- Built first Claude Code skill (`/record-session`), established global skill deployment convention

## Days

- [03-06-fri](03-06-fri/README.md): Brainstorming sessions — repo naming, chat export strategy, directory structure, AI contributor bot design
- [03-07-sat](03-07-sat/README.md): Environment setup, repo initialization, Z3Wire design + full MVP implementation, memory conventions cleanup
- [03-08-sun](03-08-sun/README.md): Z3Wire infrastructure polish, Claude Code skills exploration, cyborg workflow improvements
