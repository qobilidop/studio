# Session 03 - Switch dev.sh to devcontainer CLI

**Repo:** github.com:qobilidop/z3wire.git
**Branch:** main
**Commit:** b5a3a0c (pushed)

## What happened

1. **User asked about Claude Code hooks** for running formatter/linter before commit/push. Researched hooks API (PreToolUse on Bash, exit code 2 blocks). Built a working hook in `.claude/hooks/pre-commit-push.sh` + `.claude/settings.json`.

2. **Decided hooks were wrong tool** - AGENTS.md already instructs Claude to run format/lint/test, and standard git pre-commit hooks would cover non-Claude usage too. Reverted the hook files.

3. **Verified all dev commands** from `docs/dev/commands.md`. Found CMake `cmake --build build` fails without prior `cmake -B build` configure step. Added configure step to docs.

4. **Switched `dev.sh` from raw Docker to devcontainer CLI:**
   - `devcontainer up` + `devcontainer exec` replaces `docker buildx build` + `docker run`
   - Moved bazel cache volume mount and port 8000 forwarding into `devcontainer.json`
   - Simplified `dev.sh` from 32 lines to 8

5. **Fixed issues uncovered by the switch:**
   - CMake `build/` dir inside workspace caused format/lint to scan googletest sources, and Bazel `//...` to parse googletest BUILD files
   - Added `.bazelignore` with `build` and `site`
   - Excluded `build/` and `site/` from `find` commands in `tools/format.sh` and `tools/lint.sh`
   - Fixed `/home/dev/.cache` ownership in Dockerfile (volume mount created it as root)
   - Added `git config --system safe.directory /workspace` in Dockerfile

## Files changed

- `.devcontainer/devcontainer.json` - added mounts, forwardPorts
- `.devcontainer/Dockerfile` - .cache ownership, git safe.directory
- `dev.sh` - devcontainer CLI instead of raw docker
- `docs/dev/commands.md` - added CMake configure step
- `tools/format.sh` - exclude build/, site/
- `tools/lint.sh` - exclude build/, site/
- `.bazelignore` - new, ignores build/ and site/

## Decisions

- User prefers devcontainer as the single dev environment, used consistently
- Usage comments in dev.sh removed as redundant with docs/dev/commands.md
- `set -euo pipefail` kept in dev.sh for defensive consistency
