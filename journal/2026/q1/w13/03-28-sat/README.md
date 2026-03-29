# 2026-03-28 (Saturday)

Intense P4Py feature day: diff testing + p4testgen, DSL refinement (6 commits), LPM/metadata/switch features, complete basic_routing-bmv2 pipeline, BMv2→p4testgen migration, absltest migration, faithful basic_routing, eBPF architecture vertical slice. Also explored p4py logo design and discussed a Boris Cherny podcast.

## Sessions

- **session-00**: Daily log — Gemini chat: Python→WASM feasibility, P4Py browser playground concept (Pyodide/PyScript), latent space/embeddings Q&A, extensive p4py logo design exploration (tangram concept, 4y ligature, Python snake + P4 geometry, color mapping, logo system design principles)
- **session-01**: P4Py diff testing + p4testgen integration — hand-written STF diff test (basic_forward.py DSL program, stf_to_sim_inputs adapter), p4testgen diff test (5 generated STFs, all paths), $ end-of-packet fix
- **session-02**: P4Py DSL refinement — 6 commits: header/metadata type inference from parser annotations, import style cleanup (module-qualified externs), deparser sub-byte field packing fix, V1SwitchMini→V1Switch rename, lang/ module reorganization (_types.py + _blocks.py), hex literal formatting fix. 67/67 tests passing
- **session-03**: P4Py project org + new language features — CI badges, roadmap→spec-coverage docs, uv migration, test directory restructuring (e2e/examples split), LPM match kind, metadata struct with bit<W> fields, switch on action_run, empty actions, basic_routing-bmv2 aspirational target, test count 67→101
- **session-04**: P4Py complete basic_routing-bmv2 — 6 commits: std_meta table keys, egress pipeline, extract-length validation (p4testgen caught real bug), STF LPM prefix parsing, checksum externs (RFC 1071 csum16), 127+ tests + 837 p4testgen paths passing
- **session-05**: BMv2→p4testgen migration — removed BMv2 entirely, Bazel-built p4testgen from p4c BCR, Ubuntu 22→24.04 + native arm64, STF runner 529→166 lines, 3 Bazel test macros, discovered pytest tests silently passing under Bazel py_test
- **session-06**: absltest migration + faithful basic_routing — 18 test files to absltest.TestCase, then made basic_routing-bmv2 a 1:1 faithful translation: nested struct support, BoolLiteral, optional default_action, table size, width-annotated literals, dynamic struct names. Zero TODOs remaining, 681 p4testgen paths passing
- **session-07**: Boris Cherny podcast (Lenny's Podcast) — Claude Code team principles (have Claude do it, underfund, go faster), Anthropic's autonomy thesis (coding→tool use→computer use, safety at each step), howborisusesclaudecode.com, bitter lesson discussion
- **session-08**: P4Py eBPF architecture vertical slice — second arch (after v1model), full DSL→compile→emit→simulate→p4testgen pipeline, init_ebpf.p4 as north star, lightweight dispatch (no ABC), p4.bool/p4.NoAction/p4.hex/const_entries/implementation, Bazel patch for p4c ebpf testgen (p4lang/p4c#5573), 21 local + 4 p4testgen tests passing

## Agent index

- P4PY-DIFF-TESTING: STF as single source of truth, stf_to_sim_inputs adapter strips control-block prefixes, p4testgen from p4lang-p4c apt package (session-01)
- P4PY-DSL-INFERENCE: parser annotations are sole type source — V1Switch infers headers/metadata from parser's _p4_annotations (session-02)
- P4PY-MODULE-REORG: lang/ consolidated to _types.py + _blocks.py, underscore prefix = private submodule convention (session-02)
- P4PY-DEPARSER-FIX: sub-byte field packing bug — _append_bits used byte-aligned offset, replaced with running bit_offset counter (session-02)
- P4PY-LPM: lpm sentinel + _entry_matches() with match-kind-aware logic + _resolve_field_width() (session-03)
- P4PY-NESTED-STRUCT: struct members can reference other structs, simulator flattens with dotted keys (session-06)
- P4PY-SWITCH-ACTION-RUN: match table.apply(): case "action_name" → SwitchAction/SwitchActionCase IR nodes (session-03)
- P4PY-SPEC-COVERAGE: replaced roadmap with p4-spec-coverage.md + v1model-coverage.md tables (session-03)
- P4PY-UV: devcontainer migrated pip/virtualenv→uv, dependency-groups for test (session-03)
- P4PY-TEST-REORG: e2e_tests/→examples/ (curated) + tests/{unit,e2e,infra}/ (session-03)
- P4PY-BASIC-ROUTING-COMPLETE: faithful 1:1 translation of p4c basic_routing-bmv2.p4, zero TODOs, golden + STF + p4testgen (681 paths) all passing (session-06)
- P4PY-EXTRACT-BUG: p4testgen caught real simulator correctness issue — silent zero-padding on short packets (session-04)
- P4PY-CHECKSUM: ChecksumVerify/ChecksumUpdate as specialized IR nodes (not generic extern registry), RFC 1071 csum16 (session-04)
- P4PY-BMV2-REMOVED: BMv2 dependency fully removed, replaced by Bazel-built p4testgen from p4c BCR package (session-05)
- P4PY-ARM64-NATIVE: Ubuntu 24.04 + native arm64 devcontainer, no more QEMU emulation (session-05)
- P4PY-BAZEL-TEST-BUG: bare class TestFoo (no base) silently passes under Bazel py_test — migrated to absltest (session-05, session-06)
- P4PY-EBPF: second architecture, lightweight dispatch on pipeline type, no ABC (YAGNI with 2 arches), init_ebpf.p4 as north star (session-08)
- P4PY-EBPF-FEATURES: p4.bool, p4.NoAction, p4.hex(), const_entries, implementation kwarg on p4.table() (session-08)
- P4PY-EBPF-PATCH: p4c BCR module hardcodes TESTGEN_TARGETS=["bmv2"], local Bazel patch adds "ebpf", upstream issue p4lang/p4c#5573 (session-08)
- P4PY-ARCH-FUTURE: arch semantics should eventually live in p4py.arch.* as single source of truth, need 3+ arches first (session-08)
- FEEDBACK: p4c corpus test programs must be faithful 1:1 translations, not improvements (session-04)
- FEEDBACK: testgen scope — verifying BMv2 correctness isn't our job, compare simulator against p4testgen predictions only (session-04)
- LOGO: tangram/origami concept with 4-color mapping (P=purple, 4=green, p=blue, y=yellow), logo system (logomark→lockup), deferred to proper design tool (session-00)
- PODCAST: Boris Cherny (Claude Code) — "have Claude do it, underfund, go faster", Anthropic thesis coding→tool use→computer use with safety validation at each step (session-07)
- BITTER-LESSON: Rich Sutton concept recurring in multiple podcasts (session-07)
