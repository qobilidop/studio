# Session 01: Library directory design and inbox setup

Repo: github.com/qobilidop/i-cyborg (local ~/i/cyborg)

## Decisions

- **library/ directory**: Designed as a curated personal database of consumed external sources (books, papers, blog posts, videos, etc.).
  - Structure: `library/{year}/{publication-date}__{source-id}__{slug}`
  - Date granularity: `yyyy` (books, courses) or `yyyy-mm-dd` (everything else). No `yyyy-mm`.
  - Source ID: most natural unique identifier — arxiv ID, ISBN, youtube video ID, author/site name, etc.
  - Slug: human-readable, lowercase, hyphen-separated.
  - Entry format: single `.md` file for simple entries, directory with `README.md` when more material accumulates.
  - Key insight: the triplet `{date}__{source-id}__{slug}` is a general-purpose pattern that fits any source type without needing type-specific rules.
  - Chose flat year directory (no month subdirectories) for simplicity. Can revisit if volume warrants it.

- **inbox.md**: Created at repo root as a general-purpose scratchpad for anything needing processing. Preferred over putting an Inbox section in README.md to keep concerns separate.

- **No formal design doc**: User clarified that the brainstorming conversation itself was sufficient for simple designs.

## Actions

- Populated `inbox.md` "Sources to consume" section by searching all journal session files for mentioned sources. Found 10 items (papers, videos, blog posts, LinkedIn posts, books). User trimmed list down to 4 items.

## Files touched

- `inbox.md` — created and populated with sources to consume
