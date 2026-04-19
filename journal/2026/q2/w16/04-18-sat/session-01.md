# Session: Monorepo structure redesign and migration

**Repo:** https://github.com/qobilidop/studio

## What happened

Brainstormed and implemented a full monorepo reorganization for Bili Studio. Went from design discussion through spec, plan, and execution in one session.

## Key decisions

- **Directory structure finalized:**
  - `journal/` — chronological raw memories (unchanged)
  - `library/index/` + `library/store/` (gitignored) — external source notes and raw files
  - `waiki/` — AI-maintained wiki (Karpathy LLM wiki concept), agents own entirely
  - `workshop/{yyyy}/{mm}-{dd}-{name}/` — small projects, never renamed after creation
  - `toolbox/{claude,gemini,codex,scripts}/` — single source of truth for agent skills
  - `website/` — personal site, also publishes from other folders
  - `inbox.md` — root-level transient processing queue, evolving toward general-purpose GTD
- **Dropped `notebook/`** — temporal thoughts go in journal, project notes go in workshop, blog posts go in website. No orphaned content needing a separate space.
- **Kept `waiki/` name** over `wiki/` — the coined word signals "this isn't a normal wiki" (AI-owned, freely rewritten).
- **`workshop/` over `projects/`** — fits the studio metaphor, singular like other folder names.
- **Toolbox is source of truth** for skills. `.claude/skills/` etc. are deploy targets via symlinks. `toolbox/scripts/deploy-skills.sh` handles deployment to both project and global locations.
- **Library store** gitignored, synced to cloud storage externally. User considering Google Drive or iCloud (decided to keep this outside the spec).
- **About page on website** serves double duty as agent-readable user profile (linked from AGENTS.md).
- **Devcontainer** switched from `devcontainers/base:ubuntu` to plain `ubuntu:24.04` Dockerfile.

## Ownership rules

- `waiki/`: agents write, Bili reads
- `toolbox/`: Bili curates, agents consume
- `journal/`: session files immutable
- Everything else: collaborative

## Files created/modified

- `docs/superpowers/specs/2026-04-18-monorepo-structure-design.md` — design spec
- `docs/superpowers/plans/2026-04-18-monorepo-structure.md` — implementation plan
- `waiki/README.md`, `workshop/README.md`, `library/README.md`, `toolbox/README.md` — new READMEs
- `library/.gitignore`, `.claude/.gitignore` — gitignore for store and deploy targets
- `toolbox/scripts/deploy-skills.sh` — updated deploy script (reads from toolbox/claude/, deploys to .claude/skills/ and ~/.claude/skills/)
- `AGENTS.md` — updated structure and ownership sections
- `README.md` — added structure listing
- `.devcontainer/Dockerfile` — new, plain ubuntu:24.04
- `.devcontainer/devcontainer.json` — updated to use Dockerfile

## Lessons

- Skill symlinks created mid-session aren't discoverable by Claude Code's `/skill` system until session restart. Workaround: read the SKILL.md directly and follow instructions manually.
- User added convention to AGENTS.md: write all temporary files to `.agent_scratch/` (gitignored), never to `docs/` or other tracked directories.
