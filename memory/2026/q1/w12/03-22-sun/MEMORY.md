# 2026-03-22 (Sunday)

## Repo organization design

Bili clarified the purpose and boundaries of their multi-repo setup through a design conversation (no code).

### Meta-layer (5 stable repos)

| Repo | Visibility | Purpose | Decision test |
|------|-----------|---------|---------------|
| Cyborg | Public | Agentic workspace | Am I working *with* agents? |
| Artisan | Public | Human-first workspace | Am I the sole creative driver? |
| Hermit | Private | Legacy — journal, reflections | Would I keep this after I die? |
| Clert | Private | Logistics — life management | Do I just need this done? |
| Website | Public | Personal website | Is this for the world to see *now*? |

### Project layer

Standalone projects get their own repos. The meta-layer is the stable coordinate system; projects are dynamic.

### Key decisions

- **Cyborg vs. Artisan**: separate to prevent agent infrastructure from polluting creative space. "Human-first" = creative direction is Bili's alone, not zero tooling.
- **Hermit vs. Clert**: has Bili's voice → Hermit. Structured data → Clert.
- **Dotfiles** → Cyborg (agent-maintained).
- **Personal website roadmap**: identity page → blog → portfolio → digital garden. Content in website repo to start; pipeline from other repos later.
