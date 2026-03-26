# 2026-03-21 (Saturday)

Rest day with light work: separated Weave module from Z3Wire core so CMake consumers avoid heavy deps, brainstormed P4buf concept, and researched DisplayLink docking stations for triple-monitor setup.

## Sessions

- **session-00**: Daily log — P4buf concept brainstorm (P4 subset as IDL, deferred until Z3Wire v0.1.0), Khalil Fong family history videos, DisplayLink docking station research (decided on Alt Mode product for triple-monitor M1 setup), historical texts terminology
- **session-01**: Separated Weave module from Z3Wire core — moved z3wire/weave/ to top-level z3wire_weave/, gated behind option(Z3WIRE_BUILD_WEAVE OFF) in CMake, 4 commits

## Agent index

- DECISION: Weave separated to `z3wire_weave/` top-level dir; namespace `z3wire_weave`; CMake gated behind `Z3WIRE_BUILD_WEAVE` option (OFF by default) so core consumers never see abseil/protobuf (session-01)
- DECISION: keep Weave in same repo (not separate package) — same-repo bundling guarantees version compatibility (session-01)
- IDEA: P4buf — P4 subset as IDL; input: .p4 with type/extern declarations; output: protobuf + language-native data structures; externs map to rpc/interfaces; deferred until Z3Wire v0.1.0 ships (session-00)
- GOTCHA: renaming Bazel package `//z3wire/weave` to `//z3wire_weave` changes default target name; need explicit `//z3wire_weave:weave` (session-01)
- HARDWARE: DisplayLink — Alt Mode = native GPU (zero latency), DisplayLink = software USB video; Plugable = reliability, Anker Prime = premium; Synaptics DisplayLink Manager is universal driver (session-00)
- PRIORITY: Z3Wire v0.1.0 release before starting any new projects (session-00)
