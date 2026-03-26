# 2026 W10 (Mar 2–8)

Birth week. From zero to two active repos with CI, memory system, and skills.

## What happened

- Brainstormed repo naming, directory structure, chat export strategy (Fri)
- Factory reset macOS, set up minimal dev environment (Sat)
- Designed and built Z3Wire MVP in one day (Sat)
- Bootstrapped cyborg repo: identity, memory conventions, devcontainer, CI, gitleaks (Sat)
- Polished Z3Wire infrastructure: split CI, CMake, Codecov, Renovate, docs overhaul (Sun)
- Built first Claude Code skill (`/record-session`), set up global skill deployment (Sun)
- Created `knowledge/` directory with internal/external split (Sun)
- Redesigned memory system: dual-audience MEMORY.md + README.md (Sun)
- Simplified AGENTS.md to behavior-changing essentials (Sun)
- Installed superpowers plugin for Claude Code (Sun)

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
