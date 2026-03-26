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
  - `README.md`: Directory-level summary.

### `README.md` structure (all levels)

1. **Overview** (no heading, after title): 1-3 sentence glanceable summary.
2. **Children**: one-line description per child with link. Section name matches child type — Sessions (day), Days (week), Weeks (quarter), Quarters (year).
3. **Agent index**: agent-optimized lookup at that scope — decisions with rationale, blockers, lessons, cross-references. Terse and keyword-heavy. At day level, tag entries by source session.

## Rules

- NEVER update **session files**!
- DO update `README.md` files when relevant session files are updated.
