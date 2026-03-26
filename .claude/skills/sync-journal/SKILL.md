---
name: sync-journal
description: Use when asked to sync journal, or after updating session files - re-reads the past 3 days of session files and updates all README.md summary files up the chain
allowed-tools: Read, Write, Edit, Bash, Glob
---

Sync journal summaries for the past 3 days (today, yesterday, day before yesterday) by re-reading all session files and updating README.md files up the chain.

## Steps

1. **Determine target days**: Using today's date, derive day directory paths for today, yesterday, and the day before yesterday:
   - Format: `~/i/cyborg/journal/{year}/q{quarter}/w{week}/{MM-DD-dow}/`
   - Week number uses ISO 8601 (Monday-start weeks)
   - Day-of-week is lowercase 3-letter abbreviation (mon, tue, wed, thu, fri, sat, sun)
   - Note: the 3 days may span different weeks, quarters, or even years

2. **For each day directory that exists**, read ALL `session-*.md` files in it.

3. **Update README.md at each level** (day, week, quarter, year) with the same three-section structure:

   **Overview** (no heading, right after title):
   - 1-3 sentence glanceable summary
   - Title formats: `# {YYYY-MM-DD} ({DayOfWeek})`, `# {year} W{NN} ({month} {start}–{end})`, `# {year} Q{N}`, `# {year}`

   **Children section** (human-readable):
   - One-line description per child with link
   - Section name matches child type: `## Sessions` (day), `## Days` (week), `## Weeks` (quarter), `## Quarters` (year)
   - Day-level format: `- **session-NN**: {description}`
   - Other levels format: `- [{child}]({child}/README.md): {one-line summary}`

   **`## Agent index`** (agent-optimized):
   - Optimized for your own future consumption — help yourself find things fast
   - Include: decisions with rationale, blockers, lessons, cross-references
   - Terse and keyword-heavy — no need to be human-readable
   - At day level, tag entries by source session
   - At higher levels, capture cross-child patterns and open items
   - Only include things that don't fit naturally into the children descriptions

   When updating, read the existing file first, then preserve content from other children and update only the relevant entries.

4. **Report** which days were synced and a brief confirmation.

## Rules

- Follow the conventions in `~/i/cyborg/journal/AGENTS.md`.
- Do NOT modify session files.
- Skip any day directory that doesn't exist (no error).
- When the 3 days span different weeks/quarters/years, propagate up all affected chains.
