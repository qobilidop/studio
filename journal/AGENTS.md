# Journal

Context from the past.

## Principles

- Keep immutable **session files** (transcripts or summaries) as our raw memory.
- Maintain summaries at all levels to facilitate lookup.

## Structure

- Directory pattern: `{year}/{quarter}/{week}/{day}/`
  - `{year}` as `YYYY` like `2026`.
  - `{quarter}` as `qN` like `q1`.
  - `{week}` as `wNN` like `w10`.
  - `{day}` as `MM-DD-dow` like `03-06-fri`.
- File types:
  - `session-NN.md`: Raw **session files**. Leaf node only.
     - `session-00.md` is always my daily log, a background chat I keep throughout the day.
     - Other session files are more focused work sessions.
  - `README.md`: Directory-level summary. Key decisions, technical details, and per-child summaries.

### What to cover in `README.md`?

- Key decisions, facts, technical details organized by topic.
- Per-child summaries.
- At day level: end with a Sessions section listing each session.

## Rules

- NEVER update **session files**!
- DO update `README.md` files when relevant session files are updated.
