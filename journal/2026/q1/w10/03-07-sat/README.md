# 2026-03-07 (Saturday)

The build day. Factory-reset macOS, set up a minimal dev environment, designed and built the Z3Wire MVP (type-safe C++20 Z3 wrapper) in a single day, bootstrapped the cyborg repo with identity and memory system, and cleaned up memory conventions.

## Sessions

- **session-00**: Day log -- planned factory reset, set up minimal macOS (Homebrew, VS Code, 1Password, Colima), installed coding agents (Claude Code, Codex, Gemini CLI)
- **session-01**: Z3Wire design -- `BitVec<Width, IsSigned>`, `Bool`, precision-preserving arithmetic inspired by CIRCT HWArith, three-tier casting API
- **session-02**: Cyborg repo bootstrap -- defined "Bili the Cyborg" identity, four-tier repo vision (`memory/`, `knowledge/`, `skills/`, `projects/`), devcontainer, CI, gitleaks, memory conventions
- **session-03**: Z3Wire MVP build -- Bool, BitVec with full operations, three runnable examples, clang-format, dev.sh Docker wrapper, AGENTS.md
- **session-04**: Memory conventions cleanup -- renamed `chat-` to `session-`, 2-digit index, dropped JSON exports, consolidated CLAUDE.md into AGENTS.md

## Agent index

- decision: minimal macOS host -- Homebrew, VS Code, 1Password, Colima (not Docker Desktop), SSH signing Ed25519 no GPG (session-00)
- decision: coding agents installed -- Claude Code, Codex, Gemini CLI (session-00)
- decision: repo structure `ability/` -> `skills/`, `activity/` -> `projects/`; Z3Wire separate repo not submodule (session-02)
- decision: Z3 static over dynamic -- dynamic has Bazel sandbox runfiles issues (session-03)
- decision: subtraction always signed -- even Ubv-Ubv returns Sbv (session-03)
- decision: persistent Bazel cache volume to avoid Z3 rebuild (~9 min) (session-03)
- decision: `chat-` -> `session-`, 2-digit zero-padded index, dropped JSON exports (~4000 lines removed) (session-04)
- decision: consolidated CLAUDE.md -> AGENTS.md as single source of truth (session-04)
- decision: squash merge policy for PRs (session-02)
- lesson: stuck Explore subagent can hang on network-heavy ops; cancel with Escape, use local files (session-04)
- lesson: CLAUDE.md best practices -- keep under 200 lines, be specific, avoid duplicating inferrable info (session-04)
- z3wire: header-only C++20, `BitVec<W,S>`, `Bool`, Ubv/Sbv aliases, cast/safe_cast/checked_cast, bit-growth arithmetic (session-01, session-03)
- z3wire: design doc first then implement; test before commit; incremental commits (session-03)
