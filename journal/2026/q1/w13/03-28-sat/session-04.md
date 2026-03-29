# Session 04 — P4Py: Complete basic_routing-bmv2 pipeline

**Repo:** github.com:qobilidop/p4py.git
**Branch:** main
**Commits:** facdc46..96be014 (6 commits)

## What happened

Extended P4Py to fully support the p4c `basic_routing-bmv2.p4` test program. Six features implemented in sequence, each with TDD:

1. **std_meta table keys** (`facdc46`) — Added `std_meta` branch to `_resolve_field_width()` in simulator. Enabled `port_mapping` (exact on `std_meta.ingress_port`) and `bd` tables.

2. **Egress pipeline** (`6365150`) — Threaded optional `egress: ControlDecl | None` through IR → compiler → simulator → emitter. Added `rewrite_mac` egress table to test program.

3. **Extract-length validation** (`dcaa95a`) — Fixed simulator bug: `_exec_extract()` now checks packet has enough bits before extracting. Previously silently padded with zeros and marked header valid. Found via p4testgen (54/837 tests failed before fix). Also made `_get_field()` return 0 for unextracted header fields instead of KeyError.

4. **STF LPM prefix parsing** (`407ad7c`) — Parse `field:value/prefix_len` notation in `_parse_stf_add_to_sim()`. Added diff test (simulator vs BMv2) and testgen test (simulator vs p4testgen, 837 paths). Updated `.stf` file with all current tables.

5. **Checksum externs** (`13b5976`) — Added `ChecksumVerify`/`ChecksumUpdate` IR nodes. Compiler handles `v1model.verify_checksum()`/`v1model.update_checksum()` with keyword args + list literals. Emitter produces P4-16 checksum calls. Simulator implements RFC 1071 csum16. Also fixed `IsValid` evaluation in `_eval_expression()`.

6. **Complete basic_routing-bmv2** (`96be014`) — Wired checksum controls into test program. Updated golden P4, STF expected checksums, sim tests. Fixed STF runner to handle wildcard bits (`*`) in p4testgen key values.

## Key files modified

- `src/p4py/ir/nodes.py` — Added egress, verify_checksum, compute_checksum to Program; ChecksumVerify/ChecksumUpdate nodes
- `src/p4py/compiler/compiler.py` — Compile egress + checksum controls; `_compile_checksum_control()` with keyword args + list literals
- `src/p4py/sim/simulator.py` — Egress execution, extract-length check, csum16, checksum update, IsValid in expressions, std_meta field width
- `src/p4py/backend/p4.py` — Emit egress/checksum controls or empty placeholders; dynamic V1Switch names
- `src/p4py/arch/v1model.py` — HashAlgorithm, verify_checksum, update_checksum externs
- `tests/infra/stf_runner.py` — LPM prefix parsing, wildcard bits in keys
- `tests/e2e/p4_16_samples/basic_routing_bmv2/` — Full test suite: golden, sim (10 tests), diff, testgen (837+ paths)

## Remaining gaps (for next session)

Compared our P4Py version against the original p4c source. Three faithfulness gaps:

1. **Multi-key tables** — Original `ipv4_fib`/`ipv4_fib_lpm` have two keys (vrf + dstAddr). Ours has one.
2. **Nested metadata struct** — Original uses `meta.ingress_metadata.vrf`. Ours flattens to `meta.vrf`.
3. **Apply block scope** — Original has `port_mapping`/`bd` inside `if (hdr.ipv4.isValid())`. Ours has them outside.

## Key decisions & lessons

- **Feedback recorded:** p4c corpus test programs must be faithful 1:1 translations, not improvements. The goal is systematic correctness checking against the known-good reference.
- **Extract-length bug:** p4testgen caught a real simulator correctness issue — underscores the value of the testgen approach.
- **Checksum externs:** Implemented as specialized IR nodes (`ChecksumVerify`/`ChecksumUpdate`), not a generic extern registry. YAGNI — only two checksum externs exist.
- **Testgen scope:** Dropped BMv2 verification from testgen test per user guidance — verifying BMv2 correctness isn't our job. p4testgen predicts output directly; we compare our simulator against those predictions.
- **STF wildcard bits:** p4testgen generates binary key values with `*` for don't-care bits (e.g., `0b1111****`). Fixed by replacing `*` with `0` before int parsing.

## Test count

- 127+ pytest tests (unit + e2e + golden + diff + testgen)
- 22 bazel tests
- 837+ p4testgen-generated paths for basic_routing-bmv2, all passing
