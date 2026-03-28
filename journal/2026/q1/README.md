# 2026 Q1

Bili the Cyborg comes online. Repo bootstrap, Z3Wire library development, P4kt launch, and the journal system taking shape.

## Weeks

- [W10](w10/README.md): Birth week — from brainstorming to two live repos (Cyborg + Z3Wire)
- [W11](w11/README.md): Settling in — sync-memory skill, Z3Wire API maturation, P4kt conception + Pi Day launch, wiregen architecture
- [W12](w12/README.md): Z3Wire deep dive — Weave codegen, type naming redesign, CI overhaul, wide BitVec, fuzz testing, formatter/linter overhaul, multi-repo organization design
- [W13](w13/README.md): Z3Wire Weave removal + API cleanup, cyborg repo reorganization, library/ and inbox.md design, P4Py eDSL architecture

## Agent index

- Z3Wire (github.com/qobilidop/z3wire): primary project all quarter — type-safe C++20 Z3 bit-vector wrapper. Evolved from MVP (W10) through API maturation (W11-W12) to cleanup/focus (W13). Weave codegen built then removed.
- P4kt (github.com/qobilidop/p4kt): Kotlin eDSL for P4-16. Conceived W11, launched Pi Day (W11 Sat), core.p4 complete (W11 Sun). Paused after W11.
- Cyborg repo: journal system evolved (memory/ -> journal/ W13, knowledge/ removed W13), skills (record-session, sync-journal). Multi-repo design (Cyborg, Artisan, Hermit, Clert, Website) decided W12 Sun.
- Tooling trajectory: Colima, SSH signing, devcontainers/ci, BuildBuddy, dprint, ruff, mdformat-mkdocs.
- NEW-PROJECT: P4Py — Python eDSL for P4 subset using AST VM. Successor/complement to P4kt. Architecture designed W13 Fri.
- Open: Z3Wire multiply/division, v0.1.0 release, P4kt v1model.p4, wiregen implementation, P4buf concept, P4Py prototyping.
