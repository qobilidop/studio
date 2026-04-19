#!/usr/bin/env bash
# Deploy skills from toolbox to platform-specific locations.
# Claude Code skills: toolbox/claude/ → .claude/skills/ (project) and ~/.claude/skills/ (global, if .global marker present)
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
SKILLS_SRC="$REPO_DIR/toolbox/claude"
PROJECT_DST="$REPO_DIR/.claude/skills"
GLOBAL_DST="$HOME/.claude/skills"

# Deploy to project .claude/skills/
mkdir -p "$PROJECT_DST"
for skill_dir in "$SKILLS_SRC"/*/; do
    [ -d "$skill_dir" ] || continue
    skill_name="$(basename "$skill_dir")"
    target="$PROJECT_DST/$skill_name"

    if [ -L "$target" ]; then
        rm "$target"
    elif [ -e "$target" ]; then
        echo "Warning: $target exists and is not a symlink, skipping"
        continue
    fi

    ln -s "$skill_dir" "$target"
    echo "Linked $skill_name → $target"
done

# Deploy global skills to ~/.claude/skills/
mkdir -p "$GLOBAL_DST"
for skill_dir in "$SKILLS_SRC"/*/; do
    [ -d "$skill_dir" ] || continue
    skill_name="$(basename "$skill_dir")"

    if [ ! -f "$skill_dir/.global" ]; then
        continue
    fi

    target="$GLOBAL_DST/$skill_name"

    if [ -L "$target" ]; then
        rm "$target"
    elif [ -e "$target" ]; then
        echo "Warning: $target exists and is not a symlink, skipping"
        continue
    fi

    ln -s "$skill_dir" "$target"
    echo "Linked $skill_name → $target (global)"
done
