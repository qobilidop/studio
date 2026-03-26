# Session 01 - Cyborg repo reorganization

Repo: github.com/qobilidop/cyborg

## What happened

Major reorganization of the cyborg repo's journal and knowledge systems.

### memory/ renamed to journal/
- `git mv memory journal` - directory rename
- Rationale: content is chronologically organized session records (a journal), not retrieval-oriented memory. Also reduces naming confusion with Claude Code's built-in `.claude/projects/.../memory/` system.
- Updated all references: AGENTS.md, record-session skill, sync-memory skill, knowledge/ READMEs, journal/AGENTS.md, journal/README.md
- Commit: e05f315

### MEMORY.md merged into README.md
- Eliminated dual-summary convention (MEMORY.md agent-optimized + README.md human-optimized)
- Decision: the distinction wasn't materializing in practice - good concise writing serves both audiences
- Merged 26 MEMORY.md files into corresponding README.md files, deleted MEMORY.md files
- Used 4 parallel agents (one per week) for bulk merge
- Commit: 9e6dc04

### sync-memory skill renamed to sync-journal
- `.claude/skills/sync-memory/` -> `.claude/skills/sync-journal/`
- Skill name: sync-memory -> sync-journal

### Unified README.md structure across all journal levels
- Same three-section pattern at every level (day, week, quarter, year):
  1. **Overview** (no heading, after title): 1-3 sentence glanceable summary
  2. **Children section**: one-liners with links (Sessions/Days/Weeks/Quarters)
  3. **Agent index**: agent-optimized lookup - decisions, blockers, lessons, cross-references
- Day-level agent index tags entries by source session
- Higher-level agent index captures cross-child patterns
- Updated sync-journal skill and journal/AGENTS.md
- Commit: 6ae1e23

### Bulk-updated all journal READMEs to new format
- 4 parallel agents rewrote all day+week level READMEs
- Manually updated quarter, year, and top-level journal READMEs
- 25 README.md files changed, net -675 lines
- Commit: e689dc9

### knowledge/ directory removed
- Deemed premature - only had conventions.md and claude-code.md
- Useful conventions merged into AGENTS.md (identity details, writing style, git, dev environment)
- Em dash convention dropped per user preference - use simple `-` instead
- Commit: 437d5e6

### sync-journal expanded from 2 to 3 days
- Now covers today, yesterday, and day before yesterday
- Rationale: late-night sessions might be missed with 2-day window
- Commit: 34ad22d

## Decisions

- journal/ over memory/ for chronological records
- Single README.md over dual README.md + MEMORY.md
- Unified three-section README pattern at all levels
- Agent index as explicit section for agent-optimized content
- No em dashes - use simple `-`
- No knowledge/ directory - conventions belong in AGENTS.md
- 3-day sync window over 2-day

## Files changed (key ones)

- AGENTS.md - expanded with conventions from knowledge/
- journal/AGENTS.md - new README structure documented
- .claude/skills/sync-journal/SKILL.md - renamed from sync-memory, new format, 3-day scope
- .claude/skills/record-session/SKILL.md - updated refs
- All journal/\*\*/README.md files - new three-section format
- knowledge/ - deleted entirely
