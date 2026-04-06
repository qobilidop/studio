# Session 01 — Z3Wire docs/dev reorganization

Repo: github.com/qobilidop/z3wire

## What happened

Reorganized `docs/dev/` documentation structure and `AGENTS.md`.

### Engineering principles moved to docs/dev/workflow.md
- Principles (TDD, YAGNI, DAMP over DRY, local reasoning) were in AGENTS.md but apply to all contributors, not just agents.
- Merged standalone TDD section into principles list — each principle now has an actionable description instead of just acronym expansion.
- Decided acronym expansions are unnecessary — the descriptions convey intent, and contributors to a C++20 template library will know the terms.
- Discussed adding "also do DRY" principle — decided against it; "DAMP over DRY" already implies DRY is default when no conflict.

### AGENTS.md cleanup
- Removed engineering principles section (now in workflow.md).
- Renamed scratch space from `docs/superpowers/` to `.agent_workspace/`.
- Removed `setup.md` from agent doc references.
- Reordered doc references to match index.md.

### docs/dev/index.md → section index page
- Discussed naming: "Index" in nav reads awkwardly as "Development/Index".
- Considered: overview.md, getting_started.md, or keeping index.md as section index.
- Decision: keep `dev/index.md`, use MkDocs Material `navigation.indexes` feature so clicking "Development" lands on it directly with no sub-entry.

### index.md descriptions updated
- North Star: removed "definition of done" (doesn't exist in the file) → "project scope and design principles"
- Workflow: updated to "engineering principles, quality checks, and commit style"

### Roadmap cleanup
- Removed "Current state" paragraph — derivable from code and architecture doc, will drift.
- Fixed heading levels: Operations was `##` while siblings were `###`; all now `##`.

### Commit history cleanup
- Squashed 4 today's commits into 2: one for README/tagline, one for docs reorg.
- Used interactive rebase: fixup tagline into README commit, drop stale force-push leftover.

## Key files changed
- `AGENTS.md`
- `docs/dev/workflow.md`
- `docs/dev/index.md`
- `docs/dev/roadmap.md`
- `mkdocs.yml` (added `navigation.indexes`, section index for dev/)
- `.gitignore` (`.agent_workspace/`)

## Decisions & rationale
- docs/dev/ structure is solid as-is: each file answers one question (north_star=scope, architecture=code map, roadmap=what's next, setup=environment, commands=build/test, style=conventions, workflow=how to work)
- Roadmap should be purely forward-looking — no "current state" section
- Section heading "Principles" not "Engineering principles" in workflow.md — user changed back to "Engineering principles"
