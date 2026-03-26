# 2026-03-10 (Tuesday)

Deep Z3Wire development day: implemented `bitfield_eq`, fixed mdformat, audited naming conventions, and polished the project. Wide-ranging daily log covering hardware design reading, Amaranth HDL, and static site generator research.

## Sessions

- **session-00**: Daily log (Gemini) -- Z3Wire feedback from Gemini, recorded HashMath/AutoCLRS/AI chip design talks, Amaranth HDL discussion, C++ vs Python for hardware verification, combinational logic deep dive (ITE as fundamental routing primitive), static site generator research, Bay Area commute frustration
- **session-01**: Z3Wire -- `bitfield_eq` feature (LSB-first, auto type conversions, static_assert on width sum), mdformat-mkdocs fix, naming convention audit (keep snake_case), LICENSE update, AGENTS.md refinements, plan file cleanup (16 commits)

## Agent index

- bitfield_eq API: `z3w::Bool bitfield_eq(buffer, fields...)`, LSB-first ordering (Amaranth, Chisel, FIRRTL convention), auto Bool->to_ubv1/Sbv->cast<Ubv> conversions, static_assert on width sum (session-01)
- mdformat-mkdocs is the correct plugin for mkdocs admonitions, NOT mdformat-admon -- they conflict; must not install both (session-01)
- naming audit: keep snake_case (matches Z3 C++ API users call alongside Z3Wire); type traits keep STL convention (`is_symbolic`); deviations documented in AGENTS.md (session-01)
- LICENSE: "Copyright (c) 2026 The Z3Wire Authors" -- follows Go pattern, no annual year updates needed (session-01)
- no SMT solver provides struct/bitfield abstraction -- novel for Z3Wire (session-01)
- don't place non-doc files in `docs/` -- mkdocs strict mode fails; plan files moved out then deleted (session-01)
- Docker cache: `docker buildx build --no-cache` when Dockerfile changes cause snapshot errors (session-01)
- HashMath: content-addressed Calculus of Inductive Constructions, SHA-256 hashed proofs, Lean 4 + Rust P2P (session-00)
- AutoCLRS: Claude Opus 4.6 agents formalized ~50 CLRS algorithms in F*/Pulse, 100k+ LOC (session-00)
- C++ vs Python tradeoff: C++ gives compile-time safety but hard Python bindings for templates; Python gives ergonomics but delays errors to elaboration (session-00)
- ITE is the fundamental routing primitive; multi-way MUX reduces to cascaded ITE (session-00)
- static site generators evaluated: MkDocs Material, Hugo, Zola, Astro (session-00)
