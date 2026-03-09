# Claude Code

Practical knowledge about Claude Code, accumulated from our experience.

## Agent instructions

- `CLAUDE.md` and `AGENTS.md` are loaded into the agent's context automatically.
- `CLAUDE.md` can reference `AGENTS.md` via `@AGENTS.md` to keep one source of truth.
- Best practices: keep under 200 lines, be specific, use hierarchy, avoid duplicating what agents can infer from code.
- Subdirectories can have their own `CLAUDE.md`/`AGENTS.md` for scoped instructions.

## Skills

- Skills are prompt-based extensions that become slash commands.
- Defined by a `SKILL.md` file inside `.claude/skills/<skill-name>/`.
- Repo-level skills live in `.claude/skills/`; user-level skills in `~/.claude/skills/`.
- Global deployment: add a `.global` marker file to a repo skill, then symlink it to `~/.claude/skills/` (we use `tools/deploy-skills.sh` for this).

## Subagents

- The Explore subagent is useful for broad codebase research but can hang on network-heavy operations (e.g., fetching GitHub pages). When stuck, cancel with Escape and work with local files instead.
- Subagents are good for parallelizing independent queries but add overhead — don't use them for simple directed searches.

## Plugins

- Plugins are always-on extensions — once installed, they load automatically in every session.
- Managed via `/plugin` (interactive UI with Discover/Installed/Marketplaces/Errors tabs).
- Can be disabled (`/plugin disable`) and re-enabled (`/plugin enable`), but no per-session toggle.
- Marketplaces are plugin registries. We use: `claude-plugins-official` (Anthropic) and `superpowers-marketplace` (Jesse Vincent / obra).
- **Superpowers** (`superpowers@superpowers-marketplace`): highly recommended. Provides disciplined engineering skills — TDD, systematic debugging, code review, plan-driven development, brainstorming, git worktrees. Impressed us in Z3Wire development.

## Practical tips

- Prefer direct push to main for solo work; PRs add overhead without collaborators.
- Squash merge when using PRs for clean commit history.
- The agent respects `.gitignore` and won't commit secrets if gitleaks is set up as a pre-commit hook.
