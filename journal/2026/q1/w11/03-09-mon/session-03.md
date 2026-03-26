# Z3Wire: Scope Clarification, README Rewrite, Tooling Overhaul

Project: Z3Wire (https://github.com/qobilidop/z3wire)

## Key Decisions

- **Removed mult/div/mod from roadmap.** Rationale: Z3Wire covers combinational logic primitives; mult is borderline, div/mod are rarely synthesizable. Users can use `.raw()` escape hatch. YAGNI.
- **Adopted "combinational logic primitives" as the scope framing.** The complete set: bitwise (AND/OR/XOR/NOT), arithmetic (add/sub/negate), shifting, comparison, multiplexing (ite), bit manipulation (extract/concat), reduction. Two gaps remain: unary negate, reduction operators.
- **"What's in the name?" section added to README** — connects "wire" to hardware (single bit or bundle of bits), scopes the library to combinational logic.

## README Rewrite (commits 911add4 → 451a131)

- Tagline: "Type-safe Z3 bit-vectors for hardware verification. C++20 and above."
- "Why Z3Wire?" rewritten with hardware verification framing; acknowledged Z3's overflow predicates exist but are opt-in
- Removed "Who is this for?" (redundant with tagline)
- Deduplicated Features bullets (type safety + bit-growth already in Why section)
- Quick example: carry flag verification (meaningful proof, not just API demo)
  - Variable names: `sum`, `carry`, `truncated`, `overflowed`
  - Used `(carry != overflowed).raw()` over `carry.raw() != overflowed.raw()`
- Building → Getting Started: just Docker + one command
- Linked to docs site example page (not raw .cc) for mkdocs compatibility
- Used "compile-time error" not "compiler error" (latter sounds like compiler bug)

## Tooling Added

| Language | Formatter | Linter |
|----------|-----------|--------|
| C++ | clang-format (existing) | clang-tidy (existing) |
| Bazel | buildifier (new) | buildifier -lint (new) |
| Markdown | mdformat (new) | — |
| Shell | shfmt (new) | shellcheck (new) |

- All formatters unified in `tools/format.sh`, linters in `tools/lint.sh`
- `.editorconfig` added for shfmt (2-space indent for .sh files)
- AGENTS.md rule added: "Run `./dev.sh ./tools/format.sh` before every commit"
- User prefers tooling over good habits for consistency

## Build Updates

- Bazel 8.6.0 → 9.0.0
- rules_cc 0.0.17 → 0.2.17
- Migrated to explicit `load()` for rules_cc (was using deprecated native rules)
- `lint.sh`: added `find -L` to follow symlinks (Bazel 9 uses symlinks for external repos)
- `dev.sh`: switched `docker build` → `docker buildx build`

## Docker/Colima Lesson

- User runs Colima locally. `brew install docker-buildx` installs binary but Docker CLI can't find it.
- Fix: add `"cliPluginsExtraDirs": ["/opt/homebrew/lib/docker/cli-plugins"]` to `~/.docker/config.json` (per brew caveats)

## Roadmap State (docs/dev/roadmap.md)

Next features:
- Complete combinational logic primitives (unary negate, reduction ops)
- Single-bit extraction shorthand (`z3w::bit<N>`) + Bool/Ubv<1> friction
- Document combinational logic framing in design docs

## Example Sync

- All three example docs pages (safe-adder, alu, bit-manipulation) verified to match source files exactly (minus file-level comments)
- Include ordering fixed in alu.md and bit-manipulation.md to match clang-format output

## Commits (chronological)

1. 911add4 — Rewrite README intro around hardware verification scope
2. 0d3ba03 — Add mdformat for Markdown formatting
3. 448340e — Add buildifier for Bazel file formatting
4. d418899 — Add shfmt and shellcheck for shell scripts
5. 5034fca — Add buildifier linting for Bazel files
6. aa237a7 — Migrate to explicit rules_cc loads
7. d53d46e — Update Bazel to 9.0.0 and rules_cc to 0.2.17
8. 79b7122 — Use docker buildx build in dev.sh
9. b7fea0a — Rewrite README example to verify carry flag correctness
10. 451a131 — Simplify README building section and sync all examples
