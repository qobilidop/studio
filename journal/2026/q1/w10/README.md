# 2026 W10 (Mar 2–8)

The week Bili the Cyborg was born. From brainstorming repo names to building a Z3Wire MVP, bootstrapping the cyborg repo, and establishing the memory/knowledge/skill systems.

## Days

- [03-06-fri](03-06-fri/README.md): Day zero -- five brainstorming sessions on export formats, directory structure, repo naming, and AI-agent collaboration workflows
- [03-07-sat](03-07-sat/README.md): The build day -- factory-reset macOS, designed and built Z3Wire MVP, bootstrapped cyborg repo, cleaned up memory conventions
- [03-08-sun](03-08-sun/README.md): Infrastructure polish -- split Z3Wire CI, built `/record-session` skill, created knowledge directory, redesigned memory system

## Agent index

- identity: "Bili the Cyborg" born this week -- community internally (I=human, you=agent), unity externally (I=cyborg)
- repos: named "Cyborg" (agentic craft) + "Artisan" (manual craft); Z3Wire as independent repo
- z3wire: full MVP in one day -- header-only C++20, `BitVec<W,S>`, `Bool`, three-tier casting, bit-growth arithmetic; then CI split, CMake, Codecov, Renovate, relaxed comparisons, split build targets
- memory-system: evolved from JSON+MD dual export -> MD-only; `chat-` -> `session-`; then dual-audience MEMORY.md (agent) + README.md (human)
- knowledge: `internal/` (about us) vs `external/` (about the world); created conventions.md, claude-code.md
- skills: first Claude Code skill `/record-session`; global deployment via `.global` marker + symlink
- tooling: Colima (not Docker Desktop), SSH signing (Ed25519, no GPG), gitleaks, squash merge, Renovate over Dependabot, Codecov over Coveralls
- principles-established: "think from first principles", "prefer simplicity", "create when content demands", sentence-case headings
- open-items: Z3Wire multiplication/division/modulo, v0.1.0 release, Bazel Central Registry publish
- lesson: CLAUDE.md keep short/specific/non-obvious; subagents can hang on network ops
