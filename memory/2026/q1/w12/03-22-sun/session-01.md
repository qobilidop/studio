# Session 01 — Repo Organization Discussion

## Context

Bili wanted to discuss and clarify the purpose/boundaries of their multi-repo setup. No code written — purely a design conversation.

## Repos discussed

Bili has 4 repos now, plans a 5th (personal website). Organized into a **meta-layer** (stable, 5 repos) and a **project layer** (dynamic, standalone repos as needed).

### Meta-layer

| Repo | Visibility | Purpose | Decision test |
|------|-----------|---------|---------------|
| **Cyborg** | Public | Agentic workspace | Am I working *with* agents? |
| **Artisan** | Public | Human-first workspace | Am I the sole creative driver? |
| **Hermit** | Private | Legacy — journal, reflections | Would I keep this after I die? |
| **Clert** | Private | Logistics — life management | Do I just need this done? |
| **Website** | Public | Personal website | Is this for the world to see *now*? |

### Project layer

Standalone projects get their own repos when they have enough substance.

## Key decisions & reasoning

- **Cyborg vs. Artisan kept separate**: Repo environment shapes workflow. Agent infrastructure (AGENTS.md, memory/, devcontainer) would be noise in human-first work. Separation also protects creative space from agent contamination. "Human-first" means creative direction is Bili's alone, not that there's zero tooling.
- **Hermit vs. Clert boundary**: If it has Bili's *voice* → Hermit. If it's structured data (habits, budgets, checklists) → Clert.
- **Dotfiles** → Cyborg (maintained with agent help).
- **Personal website roadmap**: Start simple, grow incrementally:
  1. Identity page + minimal site setup
  2. Blog (markdown posts)
  3. Portfolio (curated project highlights)
  4. Digital garden (interconnected notes)
- Content lives in the website repo to start. Can add a pipeline from other repos later.
- The 5 meta-repos form a complete coordinate system: public/private, agentic/human, legacy/ephemeral, workspace/product.
