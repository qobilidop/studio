#!/usr/bin/env bash
# Symlink global skills to ~/.claude/skills/ for cross-repo availability.
# Only skills with a .global marker file are deployed.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SKILLS_SRC="$REPO_DIR/.claude/skills"
SKILLS_DST="$HOME/.claude/skills"

mkdir -p "$SKILLS_DST"

for skill_dir in "$SKILLS_SRC"/*/; do
    skill_name="$(basename "$skill_dir")"

    if [ ! -f "$skill_dir/.global" ]; then
        continue
    fi

    target="$SKILLS_DST/$skill_name"

    if [ -L "$target" ]; then
        rm "$target"
    elif [ -e "$target" ]; then
        echo "Warning: $target exists and is not a symlink, skipping"
        continue
    fi

    ln -s "$skill_dir" "$target"
    echo "Linked $skill_name"
done
