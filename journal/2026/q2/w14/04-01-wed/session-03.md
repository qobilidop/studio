# Session 03 — Personal Website Build

Repo: `github.com:qobilidop/qobilidop.github.io`

## What happened

Built a personal landing page from scratch in a single session: brainstorm → design spec → implementation plan → subagent-driven execution → dev experience polish.

## Key decisions & rationale

- **Astro** as SSG — ships zero JS by default, scales from landing page to blog/portfolio naturally
- **Selenized White/Black** color theme — chosen for scientific rigor (CIELAB perceptual model), high contrast variant over standard Selenized light/dark
- **Dev container on plain `ubuntu:24.04`** (not devcontainer base image) — user wants explicit control over installed packages
- **Node 22** via devcontainer feature (not Dockerfile)
- **System font stack** (`system-ui, sans-serif`) — revisit when more content exists
- **Name display**: "Bili Dong" only (no handle) — handle is already in URL and all profile links
- **Centered layout** with theme toggle (localStorage persistence, system preference as default)
- **Prettier** (with astro plugin) for formatting; no ESLint yet

## Implementation details

- 5-task plan executed via subagent-driven development
- Dockerfile required fixes for Ubuntu 24.04: pre-existing `ubuntu` user at UID 1000, `dash` as default `/bin/sh` breaking Node feature install
- `forwardPorts` in devcontainer.json doesn't work with CLI — needed `appPort` for `docker run -p` mapping
- `--host 0.0.0.0` needed on astro dev/preview for container port forwarding
- `dev.sh` wrapper: runs `devcontainer up` then `devcontainer exec "$@"`
- CI: GitHub Actions with `devcontainers/ci@v0.3`, deploys to Pages via `actions/deploy-pages@v4`

## Files created/modified

- `.devcontainer/Dockerfile`, `.devcontainer/devcontainer.json`
- `src/layouts/Base.astro`, `src/pages/index.astro`, `src/styles/global.css`
- `astro.config.mjs`, `package.json`
- `.github/workflows/deploy.yml`
- `dev.sh`, `.gitignore`, `.prettierrc`, `.prettierignore`, `README.md`

## Lessons / gotchas

- Ubuntu 24.04 ships with `ubuntu` user at UID 1000 — must remove before creating custom user
- `devcontainer up` CLI ignores `forwardPorts`; use `appPort` instead
- Astro dev/preview binds to localhost by default — won't work through container port forwarding without `--host 0.0.0.0`
- User uses Colima as Docker runtime on macOS; stale state can require `colima stop && colima start`

## Memory saved

- `feedback_devcontainer.md` — all npm/build commands must run in dev container
- `user_profile.md` — user profile and preferences
