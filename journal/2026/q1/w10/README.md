# 2026 W10 (Mar 2–8)

The week Bili the Cyborg was born.

## Highlights

- Named the dual repos: **Cyborg** (brave new agentic craft) and **Artisan** (good old manual craft)
- Factory reset macOS and rebuilt a minimal dev environment from scratch
- Designed and built the **Z3Wire** MVP — type-safe C++20 wrapper for Z3 bit-vectors
- Bootstrapped the cyborg repo with identity, memory system, devcontainer, and CI
- Built our first Claude Code skill (`/record-session`)
- Created the `knowledge/` directory and redesigned the memory system

## Days

### [03-06-fri](03-06-fri/README.md)

Day zero. Five brainstorming sessions with Gemini and ChatGPT before any repo existed.

- Dual-format chat export: JSON + Markdown side by side (later simplified to Markdown only)
- Time-based directory hierarchy: `year/quarter/week/day/` aligned with life rhythm (weeks, quarters)
- ISO weeks starting Monday; quarter determined by week start date
- Named the two repos: **Cyborg** (brave new agentic craft) and **Artisan** (good old manual craft)
- Open source under MIT; use gitleaks for secret scanning

### [03-07-sat](03-07-sat/README.md)

The build day. Five sessions spanning environment setup, design, and implementation.

- Dev environment: minimal macOS with Homebrew, VS Code, 1Password, Colima (not Docker Desktop), SSH signing (Ed25519, no GPG)
- Coding agents installed: Claude Code, Codex, Gemini CLI
- Repo structure evolved: `ability/` → `skills/`, `activity/` → `projects/`; Z3Wire as separate repo
- Designed and built Z3Wire complete MVP in one day (header-only C++20, `BitVec<Width, IsSigned>`, `Bool`, three-tier casting)
- Memory conventions: `chat-` → `session-`, 2-digit index, dropped JSON exports, consolidated CLAUDE.md → AGENTS.md
- Squash merge policy for PRs

### [03-08-sun](03-08-sun/README.md)

Infrastructure polish and workflow improvements. Three sessions.

- CI split into focused workflows: Checks, Bazel, CMake, Docs
- Codecov over Coveralls; Renovate over Dependabot (Bazel MODULE.bazel support)
- Built first Claude Code skill (`/record-session`); global skill deployment via `.global` marker + symlink
- Created `knowledge/internal/` (about us) and `knowledge/external/` (about the world)
- Redesigned memory system: dual-audience `MEMORY.md` (agent) + `README.md` (human)
- Simplified AGENTS.md to essentials: identity, roles, principles, structure

## Key decisions

- Identity: "Bili the Cyborg" — community internally, unity externally; "I" is context-dependent
- Time-based memory: `year/quarter/week/day/`
- "Create when content demands" — no premature structure
- Separate repos for separate projects (Z3Wire independent)
- Tooling: Colima, SSH signing, gitleaks, squash merge
- Knowledge split: `internal/` (about us) vs `external/` (about the world)
- Memory dual-audience: MEMORY.md (agent-optimized) + README.md (human-optimized)
- AGENTS.md principles: "think from first principles", "prefer simplicity", "learn my preference and adapt"

## Lessons

- CLAUDE.md: keep short, specific, non-obvious
- Subagents can hang on network ops; cancel and use local files
- Sentence-case headings as standard convention
