# Session 04 — Knowledge directory and memory system redesign

## Knowledge directory

- Created `knowledge/` with `internal/` and `external/` split
  - `internal/`: about ourselves — conventions, workflow, decisions. Distilled from our own memory.
  - `external/`: about the world — domains, tools, technologies. Includes curated external sources.
- First knowledge files:
  - `knowledge/internal/conventions.md`: identity (pronoun system, context-dependent "I"), repo structure, memory, writing style, git, dev environment
  - `knowledge/external/claude-code.md`: agent instructions, skills, subagents, plugins
- Added plugins section to claude-code.md after installing superpowers plugin from `obra/superpowers-marketplace`

## AGENTS.md redesign

- Simplified root `AGENTS.md` significantly — removed inferrable content, kept only what changes agent behavior
- Final structure: Identity (we/I/you), Roles, Principles, Structure
- Key additions: "You help me grow to be a better human", "You actively learn my preference and adapt to that"
- Principles: "Think from first principles", "Prefer simplicity"
- Knowledge line intentionally left vague: "Haven't quite decided its purpose and scope"
- Evaluated each line against "does this change agent behavior?" — removed lines that don't

## Identity clarification

- Pronoun system is context-dependent:
  - Among ourselves: I = Bili the human, you = agent buddy, we = the collective
  - To outside world: I = Bili the Cyborg (unified entity)

## README.md update

- Changed "Who am I?" to "Who we are?" — reflects internal perspective
- Simplified identity description

## Memory system redesign

- Split summaries into dual-audience files:
  - `MEMORY.md`: agent-optimized — key decisions, structured facts, lessons, paths, commands
  - `README.md`: human-optimized — highlights, lessons learned, per-child summaries
- Added MEMORY.md retroactively at all levels (root, year, quarter, week, day)
- Updated all existing READMEs to follow new human-focused style
- Updated `memory/AGENTS.md` to document the dual-file convention

## record-session skill update

- `.claude/skills/record-session/SKILL.md` updated:
  - Session files now explicitly agent-optimized (not human-readable)
  - Added step 3 for MEMORY.md updates
  - Updated step 4 README guidance for human-optimized style
- Confirmed skills are read from disk on invocation, not cached at session start

## Claude Code knowledge gained

- Plugins are always-on (no per-session toggle), managed via `/plugin` UI
- `/plugin disable` / `/plugin enable` for persistent toggling
- Marketplaces: `claude-plugins-official` (Anthropic), `superpowers-marketplace` (obra/Jesse Vincent)
- Superpowers plugin: TDD, debugging, code review, plan-driven dev — impressed us in Z3Wire
- Read full best practices guide from code.claude.com — key takeaway: CLAUDE.md should contain only non-obvious rules that prevent mistakes

## Commits

- `6e5dbe3`: knowledge/ directory structure
- `4d46871`: first knowledge files (conventions + claude-code)
- `dfd7e8d`: plugins section in claude-code knowledge
- User committed AGENTS.md and README.md updates separately
- `ce343b9`: MEMORY.md files and README updates for dual-audience memory
- `17548e9`: record-session skill update
