# 2026-03-08 (Sunday)

Infrastructure polish and workflow improvements. Three sessions.

## Key decisions

- CI split into focused workflows: Checks, Bazel, CMake, Docs
- Codecov over Coveralls; Renovate over Dependabot (Bazel MODULE.bazel support)
- Sentence-case headings convention (Google/Apple/MkDocs Material)
- README as single source of truth for docs (included via mkdocs plugin)
- "Create when content demands" principle documented
- Global skill deployment: `.global` marker + symlink via `tools/deploy-skills.sh`
- End-of-session recording preferred over mid-session

## Skills

- Built first Claude Code skill: `/record-session`
- Skills are SKILL.md files in `.claude/skills/<name>/`; user-level in `~/.claude/skills/`

## Z3Wire infrastructure

- Added CMake as secondary build system
- Integrated Codecov and Renovate
- Documentation overhaul: deduplicated README/docs, reorganized nav
- Unified `size_t` width parameter, relaxed comparison operators, split build targets, added coverage checklist

## Knowledge directory (session-04)

- Created `knowledge/internal/` (about us) and `knowledge/external/` (about the world)
- Files: `internal/conventions.md`, `external/claude-code.md`
- Identity pronoun system: context-dependent — "I" = human internally, cyborg externally

## Memory redesign (session-04)

- Dual-audience split: `MEMORY.md` (agent) + `README.md` (human) at every level
- Updated `record-session` skill for new convention
- Installed superpowers plugin (`obra/superpowers-marketplace`)

## AGENTS.md simplification (session-04)

- Stripped to essentials: Identity, Roles, Principles, Structure
- Key lines: "help me grow", "learn my preference and adapt", "think from first principles", "prefer simplicity"
