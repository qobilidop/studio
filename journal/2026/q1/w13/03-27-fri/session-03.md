# Session 03 — P4Py docs, e2e test infra, Bazel P4 deps attempt

Repo: https://github.com/qobilidop/p4py
Agent: Claude Opus 4.6 (Claude Code)
Commits: 5ef9a50..eef369d (14 commits pushed to main)

## What happened

### 1. Roadmap and architecture docs
- Created `docs/roadmap.md`: two milestones — P4Mini (v0.1.0, concrete) and P4Lite (v1.0.0, placeholder).
- Created `docs/architecture.md`: hub-and-spoke around P4 AST, AST-parsing approach (not tracing), components: AST, decorator API, simulator, P4 emitter, externs.
- Added toctree to `docs/index.md`.
- Key decisions: P4Mini = minimal language + minimal v1model subset. P4Lite = useful subset + full v1model. AST parsing chosen because P4 is static (compile-time control flow). Tracing can't capture full parser state machines.

### 2. E2e test infrastructure
- Brainstormed testing strategy. Chose STF (Simple Test Framework) as unified test format, following 4ward's approach.
- Researched p4c test formats: STF, PTF, Protobuf, Protobuf IR, Metadata. STF is simplest and sufficient for P4Mini.
- Switched devcontainer to Ubuntu 22.04 for p4lang apt packages (p4c, BMv2).
- Wrote `e2e_tests/stf_runner.py`: STF parser, hex matcher, pcap I/O, p4c compilation, BMv2 integration via veth pairs + Thrift CLI.
- Wrote `e2e_tests/basic_forward/`: minimal v1model L2 forwarder (.p4) + STF test (.stf).
- Created `stf_test.bzl` Bazel macro.
- Used subagent-driven development: 7 tasks dispatched to implementer agents with spec + code quality reviews.
- Plan had FIFO-based BMv2 I/O; implementer discovered veth pairs were needed instead. Required NET_ADMIN, iproute2, sudo in devcontainer.

### 3. Bazel-hermetic P4 deps (attempted, reverted)
- Researched 4ward's approach: Bazel-managed p4c (smolkaj/p4c fork) + BMv2 (upstream + patch). C++ BMv2 driver eliminates Thrift/veth/sudo.
- Wrote full implementation plan with C++ bmv2_driver.cpp.
- **Blocked**: Building p4c from source under x86_64 QEMU emulation on ARM Mac is unreliable (C preprocessor segfaults). Reverted to apt-based setup.
- Saved plan/spec in docs/superpowers/ for future reference.

### 4. Cleanup
- Renamed requirements_lock.txt → requirements.txt (standard convention).
- Added uv package manager to devcontainer.
- Added CC=clang to .bazelrc (then removed when reverting to 22.04).
- E2e test has transient QEMU flakiness (p4c preprocessor segfaults occasionally under emulation).

## Key files
- `docs/roadmap.md`, `docs/architecture.md` — project docs
- `e2e_tests/stf_runner.py` — STF test runner (parser + BMv2 driver)
- `e2e_tests/stf_runner_test.py` — 17 unit tests
- `e2e_tests/stf_test.bzl` — Bazel macro
- `e2e_tests/basic_forward/` — first e2e test
- `docs/superpowers/specs/2026-03-27-e2e-test-infra-design.md` — e2e test design spec
- `docs/superpowers/plans/2026-03-28-bazel-p4-deps.md` — Bazel P4 deps plan (for future)

## Decisions and lessons
- STF format chosen over PTF/Protobuf for simplicity; 4ward validates the approach.
- Ubuntu 22.04 required for p4lang apt packages (no 24.04 support).
- QEMU emulation on ARM Mac is unreliable for heavy C++ builds (p4c). Bazel-hermetic P4 deps should wait for native amd64 CI.
- veth pairs needed for BMv2 packet I/O (FIFOs didn't work as planned).
- `--platform=linux/amd64` required in devcontainer.json for p4lang packages.
- `requirements_lock.txt` is a Bazel convention; `requirements.txt` is more standard.

## Next steps
- P4Mini spec (detailed language subset definition)
- Start implementing p4py core: AST node types, decorator API
- Consider p4testgen integration for automated test generation
- Revisit Bazel-hermetic P4 deps when native amd64 CI is available
