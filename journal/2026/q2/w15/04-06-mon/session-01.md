# Session 01 — Migrate docs tooling: MkDocs Material → Zensical + pip → uv

Repo: https://github.com/qobilidop/z3wire

## What happened

Two migrations in one session, both touching `.devcontainer/Dockerfile` and docs infrastructure.

### 1. MkDocs Material → Zensical (commit `bf7be53`)

MkDocs Material is entering maintenance mode (squidfunk). Zensical is the successor, reads `mkdocs.yml` natively.

**Key changes:**
- `mkdocs-material` + `mkdocs-include-markdown-plugin` replaced by `zensical` in Dockerfile
- `include-markdown` plugin replaced by `pymdownx.snippets` extension — only one usage in `docs/index.md` (includes a slice of `README.md`)
- Added `--8<-- [start/end:intro]` snippet markers to `README.md`
- `tools/docs.sh`: `mkdocs` → `zensical`, dropped `--strict` (not yet supported in Zensical v0.0.31)
- `.github/workflows/docs.yml`: same command swap
- `mkdocs.yml` kept as-is — `zensical.toml` not yet supported (planned)

**Files modified:** `README.md`, `docs/index.md`, `mkdocs.yml`, `.devcontainer/Dockerfile`, `.devcontainer/devcontainer.json`, `.github/workflows/docs.yml`, `.gitignore`, `docs/dev/architecture.md`, `tools/docs.sh`

### 2. pip → uv (commit `41e7710`)

**Key changes:**
- Replaced `python3-pip` with `python3-venv` in apt packages (uv needs venv for system Python)
- Installed uv v0.7.8 as standalone binary via `curl | sh`
- `pip3 install --break-system-packages --ignore-installed` → `uv pip install --system --break-system-packages`
- Eliminated the `--ignore-installed` workaround that was needed for PyYAML conflict with pip

## Decisions & rationale

- **Snippets over include-markdown**: only one usage site, snippets is natively supported by Zensical, include-markdown is not on their supported plugin list
- **Dropped --strict**: Zensical ignores it — accepted trade-off since it's pre-1.0
- **--break-system-packages still needed with uv**: Ubuntu 24.04's managed Python blocks system-wide installs regardless of installer

## Blockers / notes

- CI will need the devcontainer image rebuilt (`.devcontainer/` changes trigger it) before docs workflow succeeds
- `zensical.toml` config format not yet available — staying on `mkdocs.yml`
- `mdformat-mkdocs` (markdown formatter) is independent of MkDocs — kept as-is
