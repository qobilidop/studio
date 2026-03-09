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
