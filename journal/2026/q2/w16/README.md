# 2026 W16 (Apr 13–19)

Hardware formal specification deep dive and broad technical exploration — HW formal spec survey (Sail, C++-to-RTL equivalence, ac_types, open-source HLS), Webb's Theorem, then C preprocessor alternatives, symbolic execution naming, comptime survey, type theory (division by zero), and ISA instruction fuzzer methodology.

## Days

- [04-13-mon](04-13-mon/README.md): HW formal spec survey (Sail, FormalRTL, Jasper/HECTOR), C++-to-RTL equivalence (algorithmic subset C++, bit-blasting, SAT/SMT), ac_types ecosystem (MatchLib, Intel oneAPI, CERN da4ml), open-source HLS (Bambu, Dynamatic), Lean for HW (eDSLs, time-warping simulation), Webb's Theorem
- [04-14-tue](04-14-tue/README.md): C preprocessor alternatives (modules, generics, comptime, hygienic macros), symbolic execution naming (PathGroup/PathSet), protobuf set patterns, comptime survey (D/C++/Jai/Rust/Circle), division by zero in type theory (Buzzard FAQ), ISA instruction fuzzer methodology (coverage-guided, differential testing)

## Agent index

- HW-FORMAL-SPEC: correct-by-construction via eDSLs, deep SMT during construction, verified codegen. Sail = ISA gold standard (RISC-V/Arm). FormalRTL uses C/C++ reference models + hw-cbmc. Commercial: Jasper/HECTOR for C++-to-RTL equivalence (Mon)
- C-TO-RTL-EQUIVALENCE: algorithmic subset C++ (no malloc, ac_int types, bounded loops) → bit-blast → SAT/SMT. Dual-rail for X-states. HLS sign-off standard. Open-source: HW-CBMC, CIRCT circt-lec (Mon)
- AC_TYPES-Z3WIRE: user considering ac_int for Z3Wire. ac_int enforces natural growth arithmetic at compile time (ac_int<4> + ac_int<5> → ac_int<6>), then Z3 handles logic constraints. Strong architectural fit (Mon)
- LEAN-HW: Lean FRO mandate includes HW verification. Dependent types for bit-width, SMT tactics, time-warping simulation (>100M cycles/sec). Community HDL "Sparkle" (Mon)
- WEBBS-THEOREM: functional completeness — single binary operator generates all operations. Webb (N-valued), Sheffer (Boolean NAND/NOR), Sierpinski (infinite sets), Odrzywołek (continuous eml operator) (Mon)
- COMPTIME-LANDSCAPE: D pioneered CTFE (2007), C++ constexpr→consteval, Zig flagship, Jai #run, Rust const fn (restricted), Circle @meta. Implementation requires compiler-as-VM, cross-compilation awareness, memory management. Approaches dependent type theory (Tue)
- ISA-FUZZERS: grammar-aware generation + coverage-guided feedback (toggle/FSM/CSR metrics) + differential testing (golden model vs DUT). Tools: DifuzzRTL, Cascade (ETH Zurich, CVEs), RFuzz, ProcessorFuzz, PreSiFuzz (Intel). Applicable to XISA simulator (Tue)
- SYMBOLIC-EXECUTION: PathGroup (active management), PathSet (formal output), ExecutionFrontier (search edges). angr SimulationManager, KLEE Executor/Searcher. Individual paths: ExecutionState/SimState/SymbolicState (Tue)
- TYPE-THEORY-TOTALITY: division by zero in Lean/Rocq — total functions require 1/0=0. Burden shifts from syntax to theorem application. CS pragmatism vs mathematical purity tension (Tue)
