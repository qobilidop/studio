# Monorepo structure reorganization plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reorganize Bili Studio from its current flat structure into the target directory layout defined in the design spec.

**Architecture:** File moves and renames via `git mv`, new directories with README.md files, updated AGENTS.md and root .gitignore. No code logic changes — this is purely structural.

**Tech Stack:** Git, Bash, Markdown

**Spec:** `docs/superpowers/specs/2026-04-18-monorepo-structure-design.md`

---

### Task 1: Create new empty directories with READMEs

Create `waiki/` and `workshop/` with README.md files that describe purpose and conventions.

**Files:**
- Create: `waiki/README.md`
- Create: `workshop/README.md`

- [ ] **Step 1: Create waiki/README.md**

```markdown
# Waiki

AI-maintained wiki. Agents synthesize knowledge from journal entries, library sources, and other inputs into topic-centric pages. Freely rewritten — form is fluid, value is in synthesis.

Inspired by Andrej Karpathy's LLM wiki concept.

## Rules

- Agents own this space entirely.
- Pages are organized by topic, not by time or source.
- Any page can be rewritten at any time — no expectation of stability.
```

- [ ] **Step 2: Create workshop/README.md**

```markdown
# Workshop

Small projects that don't warrant their own repo. Experiments, scripts, one-off analyses.

## Conventions

- Directory naming: `{yyyy}/{mm}-{dd}-{name}/`
- Start date is always the full date, never renamed after creation.
- Larger projects get their own separate repos.
```

- [ ] **Step 3: Commit**

```bash
git add waiki/README.md workshop/README.md
git commit -m "Add waiki/ and workshop/ with READMEs"
```

---

### Task 2: Restructure library/

Move the existing library file into `library/index/`, create `library/store/` with a .gitkeep, and add .gitignore for store contents.

**Files:**
- Move: `library/2026/2026-02-19__youtube-We7BZVKbCVw__lenny-with-boris-cherny.md` → `library/index/2026/2026-02-19__youtube-We7BZVKbCVw__lenny-with-boris-cherny.md`
- Create: `library/store/.gitkeep`
- Create: `library/.gitignore`
- Modify: `library/README.md` (if exists, or create)

- [ ] **Step 1: Create library/index/ and move existing file**

```bash
mkdir -p library/index/2026
git mv library/2026/2026-02-19__youtube-We7BZVKbCVw__lenny-with-boris-cherny.md library/index/2026/
rmdir library/2026
```

- [ ] **Step 2: Create library/store/ with .gitkeep and .gitignore**

Create `library/.gitignore`:
```
# Raw source files are stored locally and synced to cloud storage.
# Only the store/ directory is ignored — index/ is tracked.
store/*
!store/.gitkeep
```

Create `library/store/.gitkeep` (empty file).

- [ ] **Step 3: Update library README**

Replace the existing library README (or create one) with:

```markdown
# Library

External source notes and raw files.

## Structure

- `index/` — per-source markdown notes (tracked in git)
- `store/` — raw source files: PDFs, images, videos (gitignored, synced to cloud storage)

## Conventions

- Each index file documents a single external source (paper, book, video, podcast).
- Include: metadata, key takeaways, quotes, personal commentary.
- Library is source-indexed ("what does this source contain?"), not time-indexed.
- Cross-reference journal entries for session context.
```

- [ ] **Step 4: Commit**

```bash
git add library/
git commit -m "Restructure library/ into index/ and store/"
```

---

### Task 3: Rename tools/ to toolbox/ and reorganize

Move the existing deploy script, create platform sub-folders, and move Claude Code skills from `.claude/skills/` to `toolbox/claude/`.

**Files:**
- Move: `tools/deploy-skills.sh` → `toolbox/scripts/deploy-skills.sh`
- Move: `.claude/skills/sync-journal/SKILL.md` → `toolbox/claude/sync-journal/SKILL.md`
- Move: `.claude/skills/record-session/SKILL.md` → `toolbox/claude/record-session/SKILL.md`
- Move: `.claude/skills/record-session/.global` → `toolbox/claude/record-session/.global`
- Create: `toolbox/README.md`
- Create: `toolbox/gemini/.gitkeep`
- Create: `toolbox/codex/.gitkeep`

- [ ] **Step 1: Create toolbox directory structure**

```bash
mkdir -p toolbox/claude toolbox/gemini toolbox/codex toolbox/scripts
```

- [ ] **Step 2: Move deploy script**

```bash
git mv tools/deploy-skills.sh toolbox/scripts/deploy-skills.sh
rmdir tools
```

- [ ] **Step 3: Move Claude Code skills to toolbox/claude/**

```bash
git mv .claude/skills/sync-journal toolbox/claude/sync-journal
git mv .claude/skills/record-session toolbox/claude/record-session
```

- [ ] **Step 4: Create .gitkeep files for empty platform dirs**

```bash
touch toolbox/gemini/.gitkeep
touch toolbox/codex/.gitkeep
```

- [ ] **Step 5: Create toolbox/README.md**

```markdown
# Toolbox

Reusable personal tools and the single source of truth for agent skills.

## Structure

- `claude/` — Claude Code skills (deployed to `.claude/skills/`)
- `gemini/` — Gemini CLI skills
- `codex/` — Codex skills
- `scripts/` — platform-agnostic scripts and utilities

## Conventions

- This directory is the source of truth. Platform-specific dotfile directories are deploy targets.
- Use `scripts/deploy-skills.sh` to deploy skills to their platform-specific locations.
```

- [ ] **Step 6: Commit**

```bash
git add toolbox/
git commit -m "Rename tools/ to toolbox/ and move skills from .claude/skills/"
```

---

### Task 4: Update deploy script for new paths

Update `deploy-skills.sh` to read from `toolbox/claude/` instead of `.claude/skills/`.

**Files:**
- Modify: `toolbox/scripts/deploy-skills.sh`

- [ ] **Step 1: Update the script**

Replace the script content with:

```bash
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
```

- [ ] **Step 2: Verify the script is executable**

```bash
chmod +x toolbox/scripts/deploy-skills.sh
```

- [ ] **Step 3: Run deploy and verify symlinks are created**

```bash
toolbox/scripts/deploy-skills.sh
ls -la .claude/skills/
```

Expected: symlinks from `.claude/skills/sync-journal` and `.claude/skills/record-session` pointing to `toolbox/claude/` paths. `record-session` should also appear in `~/.claude/skills/`.

- [ ] **Step 4: Commit**

```bash
git add toolbox/scripts/deploy-skills.sh
git commit -m "Update deploy script for new toolbox paths"
```

---

### Task 5: Add .gitignore for deploy targets

Since `.claude/skills/` now contains symlinks (deploy targets), we should gitignore them so the symlinks aren't tracked.

**Files:**
- Create or modify: `.claude/.gitignore`

- [ ] **Step 1: Create .claude/.gitignore**

```
# Skills are deployed from toolbox/ via symlinks.
# The source of truth is toolbox/claude/.
skills/
```

- [ ] **Step 2: Remove .claude/skills/ from git tracking**

```bash
git rm -r --cached .claude/skills/
```

- [ ] **Step 3: Commit**

```bash
git add .claude/.gitignore
git commit -m "Gitignore .claude/skills/ (now deployed from toolbox/)"
```

---

### Task 6: Update AGENTS.md

Update the structure section to reflect the new layout, and add a link to the about page (once it exists).

**Files:**
- Modify: `AGENTS.md`

- [ ] **Step 1: Update AGENTS.md**

Replace the `## Structure` section with:

```markdown
## Structure

- `inbox.md` — Transient processing queue
- `journal/` — Context from the past, organized by time
- `library/` — External source notes (`index/`) and raw files (`store/`, gitignored)
- `waiki/` — AI-maintained wiki, synthesized knowledge
- `workshop/` — Small projects (`{yyyy}/{mm}-{dd}-{name}/`)
- `toolbox/` — Reusable tools and agent skills (source of truth)
- `website/` — Personal site

## Ownership

- `waiki/`: agents write, Bili reads. Freely rewritten.
- `toolbox/`: Bili curates, agents consume via deploy.
- `journal/`: session files are immutable once written.
- Everything else: agents + Bili collaborate.
```

- [ ] **Step 2: Commit**

```bash
git add AGENTS.md
git commit -m "Update AGENTS.md for new directory structure"
```

---

### Task 7: Update skill paths in record-session and sync-journal

The skills reference `~/i/studio/journal/` with hardcoded paths. These still work since journal didn't move, but verify and update any references to `.claude/skills/` or `tools/` if present.

**Files:**
- Verify: `toolbox/claude/sync-journal/SKILL.md`
- Verify: `toolbox/claude/record-session/SKILL.md`

- [ ] **Step 1: Check for stale paths in skill files**

```bash
grep -r "\.claude/skills\|/tools/" toolbox/claude/
```

If any matches, update them to use `toolbox/` paths. Based on current file contents, neither skill references `.claude/skills/` or `tools/` directly — they reference `~/i/studio/journal/` which hasn't changed. If grep returns no matches, no changes needed.

- [ ] **Step 2: Verify sync-journal skill references**

The sync-journal SKILL.md references `~/i/studio/journal/AGENTS.md`. This path is still valid. No change needed.

- [ ] **Step 3: Commit (only if changes were made)**

```bash
# Only if step 1 found stale paths:
git add toolbox/claude/
git commit -m "Update skill file paths for new structure"
```

---

### Task 8: Update README.md and clean up

Update the root README and remove any leftover empty directories.

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Update root README.md**

```markdown
# Bili Studio

Bili's public personal workspace.

## Structure

- `journal/` — Context from the past, organized by time
- `library/` — External source notes and files
- `waiki/` — AI-maintained wiki
- `workshop/` — Small projects
- `toolbox/` — Reusable tools and agent skills
- `website/` — Personal site
```

- [ ] **Step 2: Verify no leftover empty directories**

```bash
ls -la tools/ 2>/dev/null && echo "tools/ still exists — remove it" || echo "clean"
ls -la library/2026/ 2>/dev/null && echo "library/2026/ still exists — remove it" || echo "clean"
```

- [ ] **Step 3: Commit**

```bash
git add README.md
git commit -m "Update README for new directory structure"
```

---

### Task 9: Final verification

Run a full check to confirm the structure matches the spec.

- [ ] **Step 1: Verify directory structure**

```bash
find . -maxdepth 3 -not -path './.git/*' -not -path './website/node_modules/*' | sort
```

Expected top-level directories: `journal/`, `library/` (with `index/`, `store/`), `waiki/`, `workshop/`, `toolbox/` (with `claude/`, `gemini/`, `codex/`, `scripts/`), `website/`.

- [ ] **Step 2: Verify gitignore works**

```bash
echo "test" > library/store/test.txt
git status library/store/
rm library/store/test.txt
```

Expected: `test.txt` should not appear in git status.

- [ ] **Step 3: Verify deploy script works**

```bash
rm -f .claude/skills/sync-journal .claude/skills/record-session
toolbox/scripts/deploy-skills.sh
ls -la .claude/skills/
```

Expected: symlinks recreated correctly.

- [ ] **Step 4: Run git status for clean state**

```bash
git status
```

Expected: clean working tree.
