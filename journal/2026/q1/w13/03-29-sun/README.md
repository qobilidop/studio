# 2026-03-29 (Sunday)

P4Py architecture overhaul day: arch-agnostic refactoring (unified IR, Architecture ABC, SimEngine), module cleanup, 4 new table-entries corpus tests (ternary/masked/wildcard), wbb.p4 production-grade translation (typedefs, enums, sub-controls, clone sim), tor.p4 slices 1-4 (30 commits). Also Gemini Q&A on Python packaging, simulator concepts, WASM/WASI, and agentic loop design philosophy.

## Sessions

- **session-00**: Daily log — Gemini chat: Python package release (pip install from GitHub, PyPI via twine), pip vs uv compatibility, simulator/interpreter/executor/emulator distinctions, "build at smallest agentic loop scale" design philosophy, WASM language support tiers, WASI system interface
- **session-01**: P4Py arch-agnostic refactoring — unified IR (Package replaces Program/EbpfProgram), Architecture ABC in arch/base.py, SimEngine with extern registry, compiler/emitter zero arch imports, module flattening (ir/nodes.py→ir.py, lang/→lang.py, compiler/→compiler.py, backend/→emitter/), scrubbed P4Mini references. 29/29 tests
- **session-02**: P4Py table-entries corpus tests — 4 new p4c tests (exact, lpm, ternary, exact-ternary), ir.Masked/ir.Wildcard, p4.ternary + p4.mask(), fixed param name collision (hdr type vs hdr param), deparser pkt hardcoding, boilerplate shadowing, simulator hardcoded param names. 34/34 tests
- **session-03**: P4Py sai_p4 wbb.p4 translation — production-grade P4 program from sonic-net/sonic-pins. New: typedef, newtype, enum, const, optional match, direct_counter/direct_meter, clone sim, sub-controls with parameter directions, else-if chains, isValid() table keys. 48 tests
- **session-04**: P4Py tor.p4 slices 1-4 — second sai_p4 instantiation (TOR switch). 15-state parser, p4.cast(), ConstRef, setValid/setInvalid, UnaryOp/CompareOp/LogicalOp, bitwise AND, BitSlice, named-type action params, expression table keys. 30 commits, 53 tests, 1069-line golden file

## Agent index

- ARCH-AGNOSTIC: Package replaces Program/EbpfProgram, Architecture ABC (include, pipeline, block_signature, main_instantiation, emit_boilerplate, process_packet), SimEngine + extern registry, compiler/emitter zero arch imports (session-01)
- MODULE-FLATTEN: ir/nodes.py→ir.py, lang/{__init__,_blocks,_types}→lang.py, compiler/compiler.py→compiler.py, backend/p4.py→emitter/p4.py, sim/simulator.py→sim/__init__.py (session-01)
- EXTERN-CONVENTION: handler receives (engine, stmt) where stmt is raw FunctionCall IR node, calls engine.eval_expression() (session-01)
- PARAM-NAME-BUG: header type `hdr` shadowed by emitted param name `hdr` → p4testgen crash. Fix: store param_names in IR decls, emit DSL names in signatures (session-02)
- TERNARY: p4.ternary match kind + p4.mask(value, mask) + ir.Masked/ir.Wildcard + &&& in STF runner (session-02)
- WBB-NORTH-STAR: sonic-net/sonic-pins sai_p4/instantiations/google/wbb.p4 as production-grade target (session-03)
- DSL-DECLARATIONS: typedef, newtype, enum, const — explicit registration via V1Switch(declarations=(...)), automatic discovery deferred (session-03)
- SUB-CONTROLS: explicit sub_controls on V1Switch, separate compilation/emission from pipeline blocks, direction wrappers (p4.in_, p4.out_, p4.inout_) (session-03)
- CLONE-SIM: deferred execution model — record intent during ingress, produce clone output after. SimResult.clone_outputs, clone_session_map (session-03)
- DECISION: p4.newtype over p4.type to avoid shadowing Python builtin (session-03)
- DECISION: counters/meters on v1model (externs, not core P4) (session-03)
- DECISION: annotations deferred (@id, @sai_action, @entry_restriction etc.) (session-03, session-04)
- DECISION: conditional compilation → hardcode TOR choices in Python (session-04)
- TOR-PROGRESS: slices 1-4 of 6 done — parser+deparser+checksum, packet_io+VLAN (5 sub-controls), L3 admit, ACL pre-ingress+ingress. 14 controls wired (session-04)
- TOR-REMAINING: slice 5 (routing — .apply().hit, action_selector, inout action params) + slice 6 (egress — clone_preserving_field_list, mirror, rewrites) (session-04)
- CAST: p4.cast() + ir.Cast for type casting, Python match/case constraint — bare names are capture patterns, use dotted _c.CONSTANT (session-04)
- AGENTIC-DESIGN: "build at smallest agentic loop scale, beyond that create new project" — unix philosophy for AI era (session-00)
- WASM-INTEREST: explored WASM language tiers and WASI system interface — potential relevance to P4Py browser playground concept (session-00)
