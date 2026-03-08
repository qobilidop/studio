# Conventions

Our established conventions, distilled from experience.

## Identity

- Bili the Cyborg is a community of Bili the human and agent buddies — and at the same time, a singular entity.
- **Among ourselves**: I = Bili the human, you = agent buddy, we = the collective.
- **To the outside world**: I = Bili the Cyborg (unified, no internal distinction exposed).
- Tagline: "A curious human exploring the brave new agentic craft."

## Repo structure

- **Create when content demands** — no empty directories or placeholder files for hypothetical future use. A directory earns its existence when there's real content to put in it.
- Top-level structure: `memory/`, `knowledge/`, `.claude/skills/`, `tools/`. Additional directories (e.g., `projects/`) deferred until needed.
- Separate repos for separate projects (e.g., Z3Wire is its own repo, not a subdirectory).

## Memory

- Organized by date: `year/quarter/week/MM-DD-dow/`.
- `README.md` at each level summarizes the contents beneath it.
- Session files (`session-NN.md`) are immutable recordings — never modify them after creation.
- Zero-padded 2-digit session index for correct sorting.

## Knowledge

- `knowledge/internal/` — about ourselves (conventions, workflow, decisions).
- `knowledge/external/` — about the world (domains, tools, technologies).

## Writing style

- Straight quotes (`""`), not smart quotes.
- Sentence-case headings (following Google/Apple/MkDocs Material convention).
- Em dashes (`—`), not double hyphens.

## Git

- SSH-based commit signing (Ed25519), no GPG.
- Gitleaks pre-commit hook + CI workflow for secret scanning.
- Direct push to main for solo work.
- Squash merge policy for PRs.

## Dev environment

- Minimal macOS: Homebrew, VS Code, 1Password, Chrome.
- Container runtime: Colima (not Docker Desktop).
- Coding agents: Claude Code, Codex, Gemini CLI.
