# 2026-03-27 (Friday)

P4Py eDSL architecture deep dive with Gemini - explored Lean, Rust, and Python as host languages, converged on Python AST VM approach. Also discussed P4 pain points, P4Mini/P4Lite subset strategy, and v1model compatibility for testing.

## Sessions

- **session-00**: Daily log - late night fun with "能工智人" joke, marked arxiv paper to read, extensive P4Py architecture brainstorm (Lean eDSL, Rust eDSL, Python AST VM vs tracing, extern registry, project naming, namespace, P4Mini/P4Lite subsets, v1model-lite for testing), "boundary architect" concept extension, Goedel-Code-Prover discovery

## Agent index

- P4PY-ARCHITECTURE: converged on Python eDSL using AST Virtual Machine (Path 2) over tracing (Path 1). Inspired by Triton, Taichi, MyHDL (session-00)
- P4PY-SCOPE: useful subset of P4, not full spec. Two tiers: P4Mini (minimal toy) and P4Lite (useful subset). Validation via capability profiles (session-00)
- P4PY-TESTING: subset v1model architecture (not custom MiniArch) to leverage p4testgen + BMv2 diff testing for free (session-00)
- P4PY-EXTERNS: ExternRegistry pattern - Python implements P4 externs, VM crosses boundary to call them, emitter generates extern declarations only (session-00)
- P4PY-NAMING: package=p4py, brand=P4Py, avoid "p4" namespace (Perforce collision). `import p4py as p4` convention (session-00)
- P4PY-ERGONOMICS: builder pattern + decorators (@p4.parser, @p4.control, @p4.table, @p4.action, @p4.extern). Python classes for headers/structs. IDE support for free (session-00)
- P4PY-BACKENDS: hub-and-spoke - single AST, multiple backends: Python simulator, P4 emitter, future C/eBPF emitter (session-00)
- P4PY-PAIN-POINTS: poor interop, C-preprocessor kills IDE, black-box externs, heavy BMv2 simulation loop. Python eDSL solves all four (session-00)
- P4PY-DECISION: keep P4 language intact, evolve tooling only. Emit strict P4 subset, let p4c handle deep validation (session-00)
- CONCEPT: "boundary architect" key skill = identify most constraining parts of boundary to specify intended system behavior (session-00)
- LEAN-EDSL: deep embedding for both formal semantics + code generation. C FFI via @[extern]/@[export]. Projects: zkLean, SciLean, LeanLTL (session-00)
- RUST-EDSL: enum ADTs + typestate pattern for correct-by-construction ASTs. proc_macro for native P4 syntax. Builder pattern for IDE support (session-00)
- REFERENCE: Goedel-Code-Prover (goedelcodeprover.github.io) - 8B Lean 4 theorem prover, hierarchical proof search (session-00)
- REFERENCE: scheme-rs (github.com/maplant/scheme-rs) - inspiration for p4-rs approach (session-00)
- REFERENCE: arxiv 2602.06923 "From Kepler to Newton" - marked to read (session-00)
