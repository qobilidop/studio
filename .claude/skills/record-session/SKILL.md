---
name: record-session
description: Record a summary of the current session to the journal
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Bash, Glob
---

Record a summary of the current Claude Code session to a session file in `~/i/cyborg/journal/`.

## Steps

1. **Derive the session file path** from today's date:
   - Format: `~/i/cyborg/journal/{year}/q{quarter}/w{week}/{MM-DD-dow}/session-{NN}.md`
   - Week number uses ISO 8601 (Monday-start weeks)
   - Day-of-week is lowercase 3-letter abbreviation (mon, tue, wed, thu, fri, sat, sun)
   - `NN` is the next available zero-padded two-digit index in that day's directory
   - Create the directory if it doesn't exist

2. **Write the session summary** to the derived path:
   - Optimize for your own future reference as an agent, not for human readability
   - Capture key decisions, facts, file paths, commands, and lessons — whatever helps you pick up context later
   - Be concise but don't omit details that would be hard to recover

3. **Report** the session file path and a brief confirmation.

## Rules

- Follow the conventions in `~/i/cyborg/journal/AGENTS.md`.
- Do NOT modify existing session files.
- Do NOT ask the user for the session content — summarize from the current conversation context.
- When the session involves work in a git repo, identify it by its remote GitHub URL, not the local path.
- This skill only writes the session file. Use `/sync-journal` separately to update summary files.
