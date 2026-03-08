---
name: record-session
description: Record a summary of the current session to memory
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Bash, Glob
---

Record a summary of the current Claude Code session to our memory.

## Steps

1. **Derive the session file path** from today's date:
   - Format: `memory/{year}/q{quarter}/w{week}/{MM-DD-dow}/session-{NN}.md`
   - Week number uses ISO 8601 (Monday-start weeks)
   - Day-of-week is lowercase 3-letter abbreviation (mon, tue, wed, thu, fri, sat, sun)
   - `NN` is the next available zero-padded two-digit index in that day's directory
   - Create the directory if it doesn't exist

2. **Write the session summary** to the derived path:
   - Summarize what was discussed and accomplished in the current session
   - Be concise but capture key decisions, topics, and outcomes
   - Write in past tense, third person plural ("we")

3. **Update README.md files** up the chain:
   - **Day README** (`{day}/README.md`): Title is `# {YYYY-MM-DD} ({DayOfWeek})`. List all sessions with a brief one-line description each.
   - **Week README** (`w{NN}/README.md`): Title is `# {year} W{NN} ({month} {start}--{end})`. Summarize key events, list days with one-line descriptions.
   - **Quarter README** (`q{N}/README.md`): Title is `# {year} Q{N}`. List weeks with one-line descriptions.
   - **Year README** (`{year}/README.md`): Title is `# {year}`. List quarters with one-line descriptions.
   - When updating an existing README, preserve existing content and add/update entries as needed.
   - When creating a new README, follow the patterns from existing READMEs.

4. **Report** the session file path and a brief confirmation.

## Rules

- Follow the conventions in `memory/AGENTS.md`.
- Do NOT modify existing session files.
- Do NOT ask the user for the session content — summarize from the current conversation context.
