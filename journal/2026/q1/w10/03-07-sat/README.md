# 2026-03-07 (Saturday)

The build day. Five sessions spanning environment setup, design, and implementation.

## Key decisions

- Dev environment: minimal macOS with Homebrew, VS Code, 1Password, Colima (not Docker Desktop), SSH signing (Ed25519, no GPG)
- Coding agents installed: Claude Code, Codex, Gemini CLI
- Repo structure evolved: `ability/` → `skills/`, `activity/` → `projects/`; Z3Wire as separate repo
- Memory conventions: `chat-` → `session-`, 2-digit index, dropped JSON exports, consolidated CLAUDE.md → AGENTS.md
- Squash merge policy for PRs

## Z3Wire

- Designed and built complete MVP in one day
- Header-only C++20 type-safe wrapper for Z3 bit-vectors
- Core: `BitVec<Width, IsSigned>`, `Bool`, precision-preserving arithmetic inspired by CIRCT HWArith
- Three-tier casting: `cast<T>`, `checked_cast<T>`, `safe_cast<T>`

## Lessons

- Stuck Explore subagent: can hang on network-heavy operations; cancel with Escape, use local files
- CLAUDE.md best practices: keep under 200 lines, be specific, avoid duplicating what agents can infer

## Sessions

- **session-00**: Day log — environment setup, repo architecture brainstorming, coding agent installation
- **session-01**: Z3Wire design — type system, casting API, precision-preserving arithmetic
- **session-02**: Cyborg repo bootstrap — identity, memory, devcontainer, CI, gitleaks
- **session-03**: Z3Wire MVP build — Bool, BitVec, all operations, examples, tooling
- **session-04**: Memory conventions cleanup — renamed files, consolidated agent instructions
