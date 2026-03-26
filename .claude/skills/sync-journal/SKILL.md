---
name: sync-journal
description: Use when asked to sync journal, or after updating session files — re-reads today's and yesterday's session files and updates all README.md summary files up the chain
allowed-tools: Read, Write, Edit, Bash, Glob
---

Sync journal summaries for today and yesterday by re-reading all session files and updating README.md files up the chain.

## Steps

1. **Determine target days**: Using today's date and yesterday's date, derive both day directory paths:
   - Format: `~/i/cyborg/journal/{year}/q{quarter}/w{week}/{MM-DD-dow}/`
   - Week number uses ISO 8601 (Monday-start weeks)
   - Day-of-week is lowercase 3-letter abbreviation (mon, tue, wed, thu, fri, sat, sun)
   - Note: today and yesterday may fall in different weeks, quarters, or even years

2. **For each day directory that exists**, read ALL `session-*.md` files in it.

3. **Update day-level README.md** for each day:
   - Title: `# {YYYY-MM-DD} ({DayOfWeek})`
   - Include: key decisions, facts, technical details organized by topic
   - End with a `## Sessions` section listing each session with a one-line description

4. **Propagate up the chain** — update README.md at each ancestor level:
   - **Week** (`w{NN}/`): Title `# {year} W{NN} ({month} {start}–{end})`. Highlights, then detailed per-day summaries.
   - **Quarter** (`q{N}/`): Title `# {year} Q{N}`. List weeks with one-line descriptions.
   - **Year** (`{year}/`): Title `# {year}`. List quarters with one-line descriptions.
   - When updating, read the existing file first, then preserve content from other children and update only the relevant entries.

5. **Report** which days were synced and a brief confirmation.

## Rules

- Follow the conventions in `~/i/cyborg/journal/AGENTS.md`.
- Do NOT modify session files.
- Skip any day directory that doesn't exist (no error).
- When today and yesterday span different weeks/quarters/years, propagate up both chains.
