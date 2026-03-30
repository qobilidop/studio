# 2026 W13 (Mar 23-29)

Z3Wire cleanup early week, cyborg repo reorg mid-week, then P4Py dominated Fri-Sun: from architecture brainstorm through P4Mini, DSL refinement, basic_routing-bmv2 completion, BMv2→p4testgen migration, eBPF architecture vertical slice, arch-agnostic refactoring, and production-grade sai_p4 translations (wbb.p4 + tor.p4). Personal website planned. Logo design explored.

## Days

- [03-23-mon](03-23-mon/README.md): Z3Wire cleanup - Weave removal, API review, symbolic-offset bugfix, dual markdown formatting setup
- [03-24-tue](03-24-tue/README.md): Employer work focus day, no project activity
- [03-25-wed](03-25-wed/README.md): Cyborg repo reorganization - memory/ to journal/, unified README format, knowledge/ removal
- [03-26-thu](03-26-thu/README.md): Designed library/ directory structure (triplet pattern), created inbox.md, day job symbolic execution focus
- [03-27-fri](03-27-fri/README.md): Massive P4Py day — architecture brainstorm, project init (Bazel+Sphinx), e2e test infra, full P4Mini spec→implementation; personal website planning
- [03-28-sat](03-28-sat/README.md): P4Py feature sprint — diff testing, DSL refinement, LPM/metadata/switch, basic_routing-bmv2 complete, BMv2→p4testgen migration, absltest, eBPF arch vertical slice; logo design exploration; Boris Cherny podcast
- [03-29-sun](03-29-sun/README.md): P4Py architecture overhaul — arch-agnostic refactoring (unified IR, Architecture ABC, SimEngine), module cleanup, table-entries corpus tests, wbb.p4 + tor.p4 production translations, Gemini Q&A on WASM/WASI

## Agent index

- theme-shift: Mon = Z3Wire cleanup, Wed = cyborg repo meta-work, Thu = library/inbox design, Fri-Sat = P4Py all-out; Tue-Thu = heavy employer work
- Z3Wire scope narrowing: Weave removed, library refocused on core type-safe wrapper (Mon)
- cyborg repo overhaul: memory/ -> journal/, MEMORY.md eliminated, three-section README pattern, knowledge/ removed, sync-journal expanded (Wed)
- NEW: library/ directory designed — `{year}/{date}__{source-id}__{slug}` triplet, curated consumed sources only (Thu)
- NEW: inbox.md — general-purpose processing queue, separate from README; populated with sources from journal (Thu)
- decision: journal/ for chronological records, .claude/projects/.../memory/ for agent memory - clear separation (Wed)
- decision: unified README structure (overview + children + agent index) at all journal levels (Wed)
- blocker-ongoing: Z3Wire Getting Started docs blocked on packaging (BCR or vcpkg) (Mon)
- tooling: mdformat-mkdocs + dprint dual formatting for docs/ vs GitHub markdown (Mon)
- new-office: first day in new office building (Mon)
- day-job: symbolic execution engine — absorbing most time this week (Thu)
- NEW-PROJECT: P4Py — Python eDSL for P4 subset. AST VM architecture (Triton/Taichi-inspired), P4Mini/P4Lite tiers, v1model-lite for testing compatibility, ExternRegistry for bridging Python/P4 (Fri)
- P4Py converged: Lean (formal but heavy), Rust (fast but no runtime reflection), Python (AST VM wins — ergonomic, executable specs, free IDE support) (Fri)
- P4Py-INIT: src-layout, Bazel 9, Sphinx+MyST+Furo (MkDocs ecosystem dead), devcontainer, CI, full toolchain (Fri)
- P4Mini-COMPLETE: full milestone done in one day — spec, plan, subagent-driven impl in worktree, 7 commits, 12 tests, merged to main (Fri)
- P4Py-E2E: STF test runner + BMv2 veth pairs working; Bazel-hermetic P4 deps blocked by ARM QEMU, plan saved for future (Fri)
- WEBSITE-PLANNED: GitHub Pages at username.github.io, no custom domain (digital longevity), static site, next step = choose generator (Fri)
- CONCEPT: "boundary architect" = identify most constraining boundary parts to specify system behavior efficiently (Fri)
- P4Py-DSL-MATURED: type inference from parser annotations, module-qualified externs, deparser bit-packing fix, V1Switch rename, lang/ module reorg (Sat)
- P4Py-FEATURES-EXPANDED: LPM match, metadata struct with bit<W>, switch on action_run, nested structs, BoolLiteral, width-annotated literals, checksum externs (Sat)
- P4Py-BASIC-ROUTING-FAITHFUL: 1:1 translation of p4c basic_routing-bmv2.p4, golden + STF + 681 p4testgen paths (Sat)
- P4Py-INFRA-OVERHAUL: BMv2 removed, p4testgen from p4c BCR, Ubuntu 24.04 arm64 native, Bazel test macros, absltest migration (Sat)
- P4Py-EBPF: second arch vertical slice — DSL→compile→emit→simulate→p4testgen, lightweight dispatch, p4c patch for ebpf testgen (Sat)
- P4Py-ARCH-DIRECTION: arch semantics should centralize in p4py.arch.*, wait for 3+ arches before abstracting (Sat)
- P4Py-ARCH-AGNOSTIC-DONE: unified IR (Package), Architecture ABC, SimEngine + extern registry, compiler/emitter zero arch imports, modules flattened (Sun)
- P4Py-TABLE-ENTRIES: 4 corpus tests (exact, lpm, ternary, exact-ternary), ir.Masked/ir.Wildcard, param name collision fix (Sun)
- P4Py-WBB: sonic-net/sonic-pins wbb.p4 translation — typedef/newtype/enum/const, sub-controls with directions, clone sim, direct counters/meters, 48 tests (Sun)
- P4Py-TOR: tor.p4 slices 1-4 of 6 — 15-state parser, cast, setValid/setInvalid, comparison/logical ops, bitwise AND, BitSlice, 14 controls, 53 tests (Sun)
- P4Py-TOR-REMAINING: slice 5 (routing — .apply().hit, action_selector) + slice 6 (egress — clone_preserving_field_list, mirror) (Sun)
- CONCEPT: "build at smallest agentic loop scale" — unix philosophy for AI era (Sun)
- WASM-INTEREST: explored WASM tiers + WASI — potential P4Py browser playground via Pyodide (Sun)
- LOGO: tangram concept with 4-color character mapping (P=purple, 4=green, p=blue, y=yellow), logo system principles, deferred to design tool (Sat)
- PODCAST: Boris Cherny — Claude Code team principles, Anthropic autonomy thesis (coding→tool use→computer use) (Sat)
