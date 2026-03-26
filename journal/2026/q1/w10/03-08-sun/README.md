# 2026-03-08 (Sunday)

Infrastructure polish day. Split Z3Wire CI into focused workflows, added CMake/Codecov/Renovate, built the first Claude Code skill (`/record-session`), created the `knowledge/` directory, and redesigned the memory system with dual-audience files.

## Sessions

- **session-00**: Day log -- continued agentic coding with Claude Code, explored superpowers/humanize plugins, discussed personal website options (GitHub Pages vs custom domain), turned off Mac auto-punctuation
- **session-01**: Z3Wire infrastructure -- split CI into Checks/Bazel/CMake/Docs workflows, added CMake build system, Codecov, Renovate, documentation overhaul with sentence-case headings
- **session-02**: Cyborg workflow -- built `/record-session` Claude Code skill, global skill deployment via `.global` marker + symlink, fixed day-of-week errors in memory dirs, documented "create when content demands" principle
- **session-03**: Z3Wire cleanup -- unified `size_t` width parameter, relaxed comparison operators (cross-width/signedness), split build targets (int/bool/bitvec), added coverage checklist
- **session-04**: Knowledge directory (`internal/` + `external/`), memory redesign (dual-audience MEMORY.md + README.md), AGENTS.md simplification, installed superpowers plugin

## Agent index

- decision: CI split into Checks, Bazel, CMake, Docs workflows (session-01)
- decision: Codecov over Coveralls -- more popular, better PR integration (session-01)
- decision: Renovate over Dependabot -- supports Bazel MODULE.bazel (session-01)
- decision: sentence-case headings convention following Google/Apple/MkDocs Material (session-01)
- decision: README as single source of truth for docs, included via mkdocs plugin (session-01)
- decision: clang-only compiler support, GCC deferred (session-01)
- decision: `/record-session` skill in `.claude/skills/record-session/SKILL.md` (session-02)
- decision: global skill deployment -- `.global` marker + `tools/deploy-skills.sh` symlinks to `~/.claude/skills/` (session-02)
- decision: end-of-session recording preferred over mid-session (session-02)
- decision: `knowledge/internal/` (about us) vs `knowledge/external/` (about the world) (session-04)
- decision: dual-audience memory -- MEMORY.md (agent-optimized) + README.md (human-optimized) at every level (session-04)
- decision: AGENTS.md stripped to essentials -- Identity, Roles, Principles, Structure; "help me grow", "learn my preference and adapt", "think from first principles", "prefer simplicity" (session-04)
- decision: identity pronoun system context-dependent -- "I" = human internally, cyborg externally (session-04)
- z3wire: unified `size_t` width param eliminated `std::enable_if_t` workaround (session-03)
- z3wire: relaxed comparisons allow different widths/signedness via common type extension (session-03)
- z3wire: split single target into int (no Z3 dep), bool, bitvec (session-03)
- ref: superpowers plugin `obra/superpowers-marketplace` -- TDD, debugging, code review, plan-driven dev (session-00, session-04)
- ref: personal website -- GitHub Pages free `github.io` domain preferred for longevity over custom `.dev` domain (session-00)
- lesson: CLAUDE.md should contain only non-obvious rules that prevent mistakes (session-04)
