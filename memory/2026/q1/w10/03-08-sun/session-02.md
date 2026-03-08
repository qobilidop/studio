We learned about Claude Code skills — prompt-based extensions that become slash commands via `SKILL.md` files. We built our first skill, `/record-session`, which auto-derives a session file path from today's date and writes a session summary to our collective memory, then updates the README chain.

Key decisions and work:
- Created `/record-session` skill in `.claude/skills/record-session/SKILL.md`
- Moved status info into `README.md` (created then removed `STATUS.md`)
- Updated `AGENTS.md`: streamlined structure (dropped planned `skills/` and `projects/` directories), documented the "create when content demands" principle, added `.claude/skills/` and `tools/` to structure
- Updated `memory/AGENTS.md`: renamed "raw session files" to "session files" covering both transcripts and summaries
- Designed global skill deployment: `.global` marker file convention + `tools/deploy-skills.sh` symlinks marked skills to `~/.claude/skills/` for cross-repo availability
- Fixed day-of-week errors in memory directories: 03-06 was Friday (not Saturday), 03-07 was Saturday (not Sunday)
- Discussed but deferred mid-session recording — concluded end-of-session recording is simpler and better
