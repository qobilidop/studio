# 2026-03-10 (Tue)

## Sessions

### session-00: Daily log (Gemini)
- Late night coding on z3wire the night before — flow state
- Gemini reviewed z3wire repo, gave feedback: C++20 concepts, ergonomic slicing, benchmarking, Yosys integration
- Recorded **HashMath** (Samuel Schlesinger): content-addressed Calculus of Inductive Constructions, SHA-256 hashed proofs, Lean 4 + Rust P2P sidecar
- Recorded **AutoCLRS** (MSR RiSE): AI agents (Claude Opus 4.6) formalized ~50 CLRS algorithms in F*/Pulse, 100k+ LOC, specification review is the new bottleneck
- Recorded **"Designing AI Chip Hardware and Software"** by Bjarke Hammersholt Roune (ex-TPUv3 software lead): AI CPU thesis, systolic arrays, memory wall strategies, software pipelining
- Discussed **Amaranth** HDL (Python): first-class formal verification, elaboration-time shape checking vs C++ compile-time
- **C++ vs Python tradeoff for hardware verification**: C++ gives compile-time safety but hard to build Python bindings for templated code; Python gives ergonomics but delays error detection to elaboration
- Researched static site generators: MkDocs Material, Hugo, Zola, Astro
- Bay Area commute frustration — left work early but traffic negated time savings
- Discussed combinational logic: ITE is the fundamental routing primitive; multi-way MUX reduces to cascaded ITE

### session-01: Z3Wire docs reorg, bitfield_eq, project polish (Claude)
- **bitfield_eq feature**: `z3w::Bool bitfield_eq(buffer, fields...)`, LSB-first ordering, auto type conversions, static_assert on width sum
- mdformat-mkdocs fix (not mdformat-admon — they conflict)
- Naming convention audit: keep snake_case (matches Z3 C++ API), documented deviations
- LICENSE: changed to "The Z3Wire Authors"
- AGENTS.md refinements: project name, docs, test co-location, lint guidelines
- Plan file cleanup: moved out of docs/, then deleted after completion

## Key facts
- z3wire project: `~/i/z3wire`
- LSB-first is dominant modern convention for bitfield layout (Amaranth, Chisel, FIRRTL)
- mdformat-mkdocs is the correct plugin (not mdformat-admon)
