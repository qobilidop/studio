# Session 01: Website migration and repo rename

Date: 2026-04-08 (Tue)
Repo: qobilidop/cyborg → qobilidop/studio

## Website migration to monorepo

**Goal:** Move personal website source from `qobilidop/qobilidop.github.io` into the monorepo, with CI deploying back to GitHub Pages.

**What the website is:** Minimal Astro site — single landing page (name + links to GitHub/LinkedIn/X), light/dark theme toggle. Only dependency is Astro 5.7.10.

**What we did:**

1. Copied website source into `website/` (src/, astro.config.mjs, package.json, package-lock.json, .prettierrc, .prettierignore, .gitignore).
2. Created `.github/workflows/deploy-website.yml`:
   - Triggers on push to `main` when `website/**` changes.
   - Uses `actions/setup-node@v4` with Node 22.
   - Builds with `npm ci && npm run build` in `website/` directory.
   - Deploys using `peaceiris/actions-gh-pages@v4` to `gh-pages` branch of `qobilidop/qobilidop.github.io`.
   - `force_orphan: true` keeps target repo clean (single commit, no history bloat).
3. Generated Ed25519 deploy key pair. Added public key to `qobilidop.github.io` (write access), private key as `WEBSITE_DEPLOY_KEY` secret on this repo.
4. Changed `qobilidop.github.io` GitHub Pages source from "GitHub Actions" to "Deploy from branch" (`gh-pages`). The API only accepts `gh-pages` as a custom branch (not `main`), which is why we deploy to `gh-pages` instead of `main`.
5. Disabled (not deleted — requires `workflow` scope) the old deploy workflow in `qobilidop.github.io`.
6. Committed, pushed, verified the workflow ran successfully (14s).

**Commit:** `f3777eb` "Move personal website source into monorepo"

## Repo rename: cyborg → studio

**Context:** Discussion about the right name for a personal public monorepo.

**Reasoning chain:**

1. The 5-repo system (Cyborg, Artisan, Hermit, Clert, Website) designed in W12 (Mar 22) felt too fragmented.
2. The Artisan repo was never used since creation. The distinction between agentic and manual work can be captured at the commit level (co-author metadata) rather than repo level.
3. Fundamentally only 2 repos are needed: one public workspace, one private workspace. The split maps to a real constraint (visibility), everything else is organizational overhead.
4. Wanted a broader name (not "cyborg" which implies only agentic work) and a paired name for public/private.

**Naming exploration:**

- Considered pairs: open/closed, stage/backstage, agora/vault, commons/keep, etc.
- User recalled previously using "studio" for public workspace.
- For the private pair, explored: studio/vault, studio/attic, studio/den, studio/study, studio/workshop.
- Landed on **studio / study**:
  - Same Latin root: *studium* ("eagerness, zeal") → *studēre* ("to apply oneself").
  - "Study" came through Old French *estudie* — kept the private/intellectual meaning.
  - "Studio" came through Italian *studio* — shifted to "place where an artist works" (Renaissance artists).
  - Same word, diverged through two languages. Study = private room for reading/writing/thinking. Studio = creative workspace open to the world.

**What we did:**

1. Deleted the pre-existing empty `qobilidop/studio` repo (created Jan 1, 2026, contained `1_now`, `2_later`, README.md — a previous workspace attempt). User deleted manually (needed `delete_repo` scope).
2. Renamed `qobilidop/cyborg` → `qobilidop/studio` via `gh repo rename`.
3. Updated git remote to `git@github.com:qobilidop/studio.git`.
4. Could not rename local directory (`~/i/cyborg` → `~/i/studio`) from within the session — sandbox was rooted in the old path.

**Still TODO (deferred to next session):**

- Rename local directory: `mv ~/i/cyborg ~/i/studio`
- Rethink identity in AGENTS.md (currently "Bili the Cyborg" — may want to update now that repo is "studio")
- The private "study" repo hasn't been created yet
