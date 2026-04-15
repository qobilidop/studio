# Session 01 — Journal sync + instruction fuzzing deep dive

## What happened

1. Ran `/sync-journal` for Apr 12-14. Created 04-14-tue/README.md (new), updated W16, Q2, 2026 READMEs. Committed as `a136fd1`.

2. User asked about a fuzzing library mentioned during sail-xisa work. Searched journal — found **proptest** (property-based testing for Rust, used in sail-xisa differential testing, found 7 bugs). But user remembered a different tool with ~3-character name.

3. Identified **TestRIG** (REMS group, Cambridge) as the tool user was recalling. Not recorded in journal — came from a prior conversation. TestRIG uses RVFI-DII (RISC-V Formal Interface - Direct Instruction Injection) for differential testing of RISC-V implementations against Sail golden models.

4. Researched TestRIG's instruction generation methodology:
   - Grammar-aware biased random generation via Haskell QuickCheck (QuickCheckVEngine)
   - Template DSL with weighted distribution, domain-expert-written generators for memory ops, atomics, control flow, CSRs, page table translation
   - `surroundWithMemAccess` for data hazard scenarios, `lui` with specific values for address patterns
   - QuickCheck shrinking for minimal counterexamples
   - Architecture-conditional generation via `ArchDesc`
   - NOT coverage-guided or SMT-based — relies on human-designed templates

5. Surveyed state of art in instruction fuzzing (2024-2026):
   - **Hybrid formal+fuzz**: HyPFuzz (USENIX Security 2024) — formal finds hard-to-reach states, fuzz for scalability. ARM ISA-Formal similar philosophy
   - **LLM-assisted generation**: ChatFuzz, LLM4Fuzz (2024) — emerging, unproven
   - **Microarchitectural state abstraction**: hashing pipeline/cache/TLB state as coverage metric (beyond Verilog line coverage)
   - **Morphing-based mutation**: MorFuzz (2024) — constraint-preserving transformations
   - **Security-focused**: Revizor (Microsoft, real silicon, HPCs for leakage detection), SIGFuzz (taint tracking across speculation), SpecDoctor (microarchitectural contracts)
   - **Industry**: Intel (Revizor-style), ARM (ISA-Formal), Google OpenTitan (Verilator + coverage-guided), RISC-V ecosystem (Sail/Spike differential)
   - **Trend**: hybrid formal+fuzz with microarchitectural coverage metrics and security-oriented oracles

## Key tools referenced

- proptest: Rust property-based testing, used in sail-xisa diff testing
- TestRIG: REMS group, QuickCheck-based RISC-V differential testing via RVFI-DII
- HyPFuzz: hybrid formal+fuzz (USENIX Security 2024)
- Revizor: Microsoft, black-box CPU fuzzing with HPCs
- Cascade: ETH Zurich, intricate program generation, found CVEs
- DifuzzRTL: register-coverage metric
- RFuzz: UC Berkeley, Chisel/FIRRTL + Verilator + Rust
