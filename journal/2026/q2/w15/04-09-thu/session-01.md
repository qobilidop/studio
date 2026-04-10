# Z3Wire branding & config migration

**Repo:** github.com/qobilidop/z3wire

## What happened

Designed and integrated a project logo, updated the tagline, and migrated docs config from mkdocs.yml to zensical.toml.

## Logo design

- User designed a `<W>` logo encoding three readings: Z (left zigzag), 3 (right zigzag), W (center), plus `<W>` (embedded `<>` brackets)
- Grid: 16x16 viewBox, all endpoints on integer grid points, symmetric
- Left Z: `(1,2)→(3,6)→(1,10)→(3,14)` — strokes 2&3 form a `<` centered at y=10
- Right 3: `(13,2)→(15,4)→(13,6)→(15,10)→(13,14)` — strokes 3&4 form a `>` centered at y=10
- The `<` and `>` are exact mirrors (same center, arm length, depth) — this constrains the 3's proportions
- W: `(5,4)→(6,14)→(8,8)→(10,14)→(11,4)`
- Three SVG variants in `docs/assets/`: `z3wire_logo.svg` (adaptive via CSS `prefers-color-scheme` media query), `z3wire_logo_black.svg`, `z3wire_logo_white.svg`
- Adaptive SVG works with Zensical's light/dark toggle (unexpectedly — the site toggle apparently syncs with the media query)

## Integration

- README: `<picture>` element with dark/light `<source>` for GitHub theme switching, centered layout (Vite-style: logo + badges centered, title left-aligned)
- Docs: `zensical.toml` sets both `favicon` and `logo` to the adaptive SVG
- Commits: `4e8d83a`, `815fcc5`, `5a2e6bb`

## Tagline

- Old: "Type-safe Z3 bit-vectors for hardware verification. C++20 and above."
- New: "Compile-time safe bit-vectors for Z3."
- Reasoning: "type-safe" undersells compile-time enforcement; dropped C++ mention (language obvious from code); dropped name-origin line for brevity
- Updated in both README and docs config

## Config migration

- Migrated `mkdocs.yml` → `zensical.toml` (Zensical's native config format)
- Key mapping: top-level keys go under `[project]`, `theme.name: material` dropped, palette uses `[[project.theme.palette]]`, markdown extensions each get a `[project.markdown_extensions.X]` section
- `zensical.toml` excluded from dprint because the TOML formatter (taplo-based, even at v0.7.0) inlines arrays of inline tables — a TOML v1.0 spec limitation where inline tables must stay on one line
- Bumped dprint TOML plugin from 0.6.4 to 0.7.0
- Explored uniform table nav entries (all `{ "Title" = "path" }`) vs mixed (bare string + tables) — uniform works with `navigation.indexes` but dprint still inlines them, so no formatting benefit; kept the original mixed pattern

## Key learnings

- SVG `prefers-color-scheme` media query works inside `<img>` tags and favicons in modern browsers
- GitHub README supports `<picture>` with `<source media="(prefers-color-scheme: ...)">` for theme-aware images
- `forwardPorts` in devcontainer.json only works with VS Code, not `devcontainer exec` CLI
- dprint TOML plugin config uses camelCase (`lineWidth`), not taplo's snake_case (`column_width`)
- TOML v1.0 can't mix strings and tables in arrays; inline tables can't span multiple lines — both limitations addressed in TOML v1.1 draft
