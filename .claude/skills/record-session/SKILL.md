---
name: record-session
description: Record a summary of the current session to memory
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Bash, Glob
---

Record a summary of the current Claude Code session to our collective memory at `~/i/cyborg/memory/`.

## Steps

1. **Derive the session file path** from today's date:
   - Format: `~/i/cyborg/memory/{year}/q{quarter}/w{week}/{MM-DD-dow}/session-{NN}.md`
   - Week number uses ISO 8601 (Monday-start weeks)
   - Day-of-week is lowercase 3-letter abbreviation (mon, tue, wed, thu, fri, sat, sun)
   - `NN` is the next available zero-padded two-digit index in that day's directory
   - Create the directory if it doesn't exist

2. **Write the session summary** to the derived path:
   - Optimize for your own future reference as an agent, not for human readability
   - Capture key decisions, facts, file paths, commands, and lessons — whatever helps you pick up context later
   - Be concise but don't omit details that would be hard to recover

3. **Update MEMORY.md files** up the chain (agent-optimized):
   - Focus on key decisions, structured facts, and lessons
   - Use whatever format works best for future agent consumption
   - When updating an existing MEMORY.md, preserve existing content and add/update entries as needed

4. **Update README.md files** up the chain (human-optimized):
   - Focus on highlights, lessons learned, and per-child summaries
   - **Day README** (`{day}/README.md`): Title is `# {YYYY-MM-DD} ({DayOfWeek})`. Brief highlights, then list sessions.
   - **Week README** (`w{NN}/README.md`): Title is `# {year} W{NN} ({month} {start}–{end})`. Highlights, lessons, day summaries.
   - **Quarter README** (`q{N}/README.md`): Title is `# {year} Q{N}`. List weeks with one-line descriptions.
   - **Year README** (`{year}/README.md`): Title is `# {year}`. List quarters with one-line descriptions.
   - When updating an existing README, preserve existing content and add/update entries as needed.
   - When creating a new README, follow the patterns from existing READMEs.

5. **Report** the session file path and a brief confirmation.

## Rules

- Follow the conventions in `~/i/cyborg/memory/AGENTS.md`.
- Do NOT modify existing session files.
- Do NOT ask the user for the session content — summarize from the current conversation context.
