# Session 02: Personal website planning

Repo: github.com/qobilidop/cyborg (discussion only, no code changes)

## Context

Bili is considering starting a personal website. Primary goal: **digital longevity** — the site should remain available long after death.

## Key decisions

- **Hosting**: GitHub Pages (free, no payment to lapse, backed by Microsoft infrastructure)
- **No custom domain**: Custom domains require annual renewal; payment lapse after death kills the URL. `username.github.io` is more durable for this use case.
- **Static site**: No database, no server, trivially portable to any host.
- **Repo name**: Must be `username.github.io` for root URL serving.
- **Longevity strategy**: Git repo as source of truth + Internet Archive as passive backup. No single platform is a 100-year bet, but this combination is the best free option.

## Other notes

- Discussed GitHub Pages URL routing: project repos serve at `username.github.io/reponame/` and take priority over user site pages at the same path.
- Public repo required for free GitHub Pages.
- Suggested adding a license (e.g. Creative Commons) to clarify post-death content reuse intent.
- Static site generator choice (Jekyll vs Hugo vs plain HTML) left for next session.
- Next session will be in the new `username.github.io` repo, not `cyborg`.

## Memory saved

- `project_personal-website.md`: Captures the website project context and key decisions.
