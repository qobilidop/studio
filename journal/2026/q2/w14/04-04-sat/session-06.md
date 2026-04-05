# Session 06: Z3Wire Dev Docs Refactor

**Repo:** https://github.com/qobilidop/z3wire
**Agent:** Claude Opus 4.6 (Claude Code)
**Commits:** 5ef18f0, 3efa8a6, 710021e, defce6b → bbf012f, c2b3ae8

## What happened

Major refactor of docs/dev/ and README, driven by collaborative discussion.

### docs/dev/ restructure

Split monolithic `guide.md` into 8 focused files:
- `index.md` — hub with links
- `north_star.md` — project scope, non-goals, design principles
- `architecture.md` — codebase map, type hierarchy, build targets
- `setup.md` — prerequisites, dev container, first build (human-facing, NOT in AGENTS.md)
- `commands.md` — dev command reference
- `style.md` — C++, Bazel, doc conventions
- `workflow.md` — TDD, quality checks, commit style
- `roadmap.md` — current state + what's next (updated, not new)

### docs/design/ removed

- `philosophy.md` — redundant with north_star.md, deleted
- `compile-fail-tests.md` — merged into `tests/compile_fail/README.md` (next to the code)

### AGENTS.md updated

Now `@`-links all docs/dev/ files except setup.md. Uses `<!-- dprint-ignore -->` to prevent dprint from joining the `@` directives onto single lines.

### north_star.md refined extensively

Iterated many rounds with user. Final version is 19 lines with 3 sections:
- "What Z3Wire is" — 2 sentences
- "What Z3Wire is not" — 3 bullets (not solver, not general SMT, not sequential)
- "Design principles" — 2 bullets (minimal overhead, no lossy implicit conversions)

Key test applied: "if something could change without changing what Z3Wire *is*, it doesn't belong in the north star." Removed all feature checklists, operation lists, distribution plans → those belong in roadmap.

### README rewritten

- New tagline: "Type-safe Z3 for combinational logic verification."
- Added: "Booleans and bit-vectors - the wires of digital circuits." (explains the name)
- Replaced midpoint overflow example with Z3 vs Z3Wire side-by-side comparison (mixed-sign 8-bit multiplication)
- Removed getting started commands, kept just docs link
- Fixed em dashes → plain hyphens per style guide

### mkdocs.yml

- Updated site_description to match new tagline (no trailing period)
- Removed Design nav section
- Added all new dev docs to Development nav

## Key decisions

- `setup.md` omitted from AGENTS.md — agents don't need setup instructions
- north_star.md is boundary-defining only, not a feature checklist
- "combinational logic verification" chosen over "hardware verification" — more accurate scope, justifies operation set
- Design principles reduced to 2: minimal overhead + no lossy implicit conversions (others were redundant with scope or implementation details)
- README example: mixed-sign multiplication chosen because it demonstrates all 3 safety guarantees (width, signedness, overflow) in one comparison
- docs/design/ eliminated entirely — philosophy was redundant, compile-fail-tests moved to code

## Lessons / feedback captured

- User iterates very carefully on doc wording — apply "accurate, most constraining, minimal" test
- Trivial fixups should amend previous commit, not create new one
- When a principle is already stated elsewhere (scope, another section), don't repeat it as a "design principle"
- `dprint` with `textWrap: "always"` joins consecutive lines — use `<!-- dprint-ignore -->` for `@` directives in AGENTS.md
- `mdformat` runs on `docs/`, `dprint` runs on everything else (including root .md files)
