# Monorepo structure design for Bili Studio

## Purpose

Bili Studio is a public personal digital workspace that serves as both a knowledge management system and an agent harness. It is primarily for Bili and AI agents, intentionally made public so others can browse it. Some parts (like the website) are explicitly outward-facing.

## Directory structure

```
inbox.md              — transient processing queue (GTD-style inbox)
journal/              — chronological raw memories (sessions, daily logs)
library/
  index/              — per-source markdown notes (tracked)
  store/              — raw source files: PDFs, videos, etc. (gitignored)
waiki/                — AI-maintained wiki, synthesized knowledge across sources
workshop/             — small projects that don't need their own repo
  {yyyy}/
    {mm}-{dd}-{name}/
toolbox/              — reusable tools and agent skills (single source of truth)
  claude/             — Claude Code skills
  gemini/             — Gemini CLI skills
  codex/              — Codex skills
  scripts/            — platform-agnostic tools
  deploy.sh           — deploys skills to platform-specific locations
website/              — personal site, also publishes content from other folders
```

## Root-level files

- `AGENTS.md` — agent instructions, includes link to about page for user profile
- `CLAUDE.md` — Claude Code entry point
- `inbox.md` — general-purpose processing queue, evolves over time
- `README.md` — public-facing repo description

## Folder descriptions

### `journal/`

Context from the past, organized by time. Contains immutable session files (transcripts or summaries) as raw memory, with README summaries at all levels for lookup. Directory pattern: `{year}/{quarter}/{week}/{day}/`. Session files are never modified after creation.

### `library/`

External source notes and files. Two sub-folders:

- `index/` — per-source markdown notes. Each file documents a single external source (paper, book, video, podcast) with metadata, key takeaways, quotes, and personal commentary. These are tracked in git.
- `store/` — the actual raw files (PDFs, images, videos). Gitignored. Synced to cloud storage externally for portability across machines.

The boundary between library and journal: library is source-indexed (what does *this source* contain?), journal is time-indexed (what did I do/think *today*?). They cross-reference each other.

### `waiki/`

An AI-maintained wiki, inspired by Andrej Karpathy's LLM wiki concept. Agents synthesize knowledge from journal entries, library sources, and other inputs into topic-centric pages. The waiki is freely rewritten — its form is fluid and disposable, its value is in synthesis. Agents own this space entirely.

### `workshop/`

Small projects that don't warrant their own repo (experiments, scripts, one-off analyses). Larger projects get their own separate repos per existing convention.

Naming: `{yyyy}/{mm}-{dd}-{name}/`. The start date is always the full date, never renamed after creation. If the project list grows too long, an `archive/` sub-folder can be introduced later.

### `toolbox/`

Reusable personal tools and the single source of truth for agent skills.

- `claude/` — Claude Code skills (deployed to `.claude/skills/`)
- `gemini/` — Gemini CLI skills (deployed to `.gemini/`)
- `codex/` — Codex skills (deployed to corresponding location)
- `scripts/` — platform-agnostic scripts and utilities
- `deploy.sh` — deploys skills from toolbox to platform-specific locations

Platform-specific dotfile directories (`.claude/skills/`, `.gemini/`, etc.) are deploy targets, not sources of truth. Whether these deploy targets should be gitignored or tracked is an implementation detail to decide during migration.

### `website/`

Personal website built with Astro. Both self-contained (blog posts, about page) and a publisher of content from other folders (e.g., surfacing waiki content). The about page serves double duty as user profile for agents (linked from AGENTS.md).

### `inbox.md`

A root-level flat file serving as a transient processing queue. Items arrive (sources to consume, ideas to sort, tasks to triage), get processed into the appropriate folder (library, journal, workshop, etc.), and are removed. Starts as a reading list, evolves into a general-purpose GTD-style inbox.

## Ownership rules

| Folder | Who writes | Who reads |
|--------|-----------|-----------|
| journal/ | Agents + Bili | Agents + Bili |
| library/index/ | Agents + Bili | Agents + Bili |
| library/store/ | Bili | Agents + Bili |
| waiki/ | Agents only | Agents + Bili |
| workshop/ | Agents + Bili | Agents + Bili |
| toolbox/ | Bili (curated) | Agents (deployed) |
| website/ | Agents + Bili | Public |

## Agent harness

The repo is designed so that any AI agent, starting with no prior context, can bootstrap itself by reading files in this order:

1. `AGENTS.md` — how to work here + link to about page for user profile
2. `inbox.md` — what's active now
3. `journal/` summaries — recent context and decisions
4. `waiki/` — accumulated synthesized knowledge
5. `library/index/` — what external sources are available
6. `toolbox/` — what skills and tools are available

## Conventions

- **Journal sessions are immutable** once written.
- **Waiki is freely rewritten** by agents with no expectation of stability.
- **Toolbox is the single source of truth** for agent skills; dotfile directories are deploy targets.
- **Library store is gitignored** and synced to cloud storage externally.
- **Workshop projects use `{yyyy}/{mm}-{dd}-{name}/`** naming, never renamed after creation.
- **Separate repos for separate projects** — workshop is only for small things.
- **Public safety**: gitleaks pre-commit hook for secrets. Bili is intentional about what session content is committed.

## Migration from current state

Current structure to be reorganized:

- `journal/` — stays as-is
- `library/` — currently has one file at `library/2026/...`. Restructure into `library/index/` and `library/store/`.
- `tools/` — rename to `toolbox/`, reorganize with platform sub-folders
- `website/` — stays as-is
- `waiki/` — new, create empty with README
- `workshop/` — new, create empty with README
- `.claude/skills/` — becomes a deploy target; sources move to `toolbox/claude/`
- `inbox.md` — stays as-is
- `AGENTS.md` — update structure section to reflect new layout
