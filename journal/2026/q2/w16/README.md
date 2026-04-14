# 2026 W16 (Apr 13–19)

Hardware formal specification deep dive — Lean for HW, C++-to-RTL equivalence checking, ac_types ecosystem, open-source HLS tooling, and mathematical curiosity (Webb's Theorem on functional completeness).

## Days

- [04-13-mon](04-13-mon/README.md): HW formal spec survey (Sail, FormalRTL, Jasper/HECTOR), C++-to-RTL equivalence (algorithmic subset C++, bit-blasting, SAT/SMT), ac_types ecosystem (MatchLib, Intel oneAPI, CERN da4ml), open-source HLS (Bambu, Dynamatic), Lean for HW (eDSLs, time-warping simulation), Webb's Theorem

## Agent index

- HW-FORMAL-SPEC: correct-by-construction via eDSLs, deep SMT during construction, verified codegen. Sail = ISA gold standard (RISC-V/Arm). FormalRTL uses C/C++ reference models + hw-cbmc. Commercial: Jasper/HECTOR for C++-to-RTL equivalence (Mon)
- C-TO-RTL-EQUIVALENCE: algorithmic subset C++ (no malloc, ac_int types, bounded loops) → bit-blast → SAT/SMT. Dual-rail for X-states. HLS sign-off standard. Open-source: HW-CBMC, CIRCT circt-lec (Mon)
- AC_TYPES-Z3WIRE: user considering ac_int for Z3Wire. ac_int enforces natural growth arithmetic at compile time (ac_int<4> + ac_int<5> → ac_int<6>), then Z3 handles logic constraints. Strong architectural fit (Mon)
- LEAN-HW: Lean FRO mandate includes HW verification. Dependent types for bit-width, SMT tactics, time-warping simulation (>100M cycles/sec). Community HDL "Sparkle" (Mon)
- WEBBS-THEOREM: functional completeness — single binary operator generates all operations. Webb (N-valued), Sheffer (Boolean NAND/NOR), Sierpinski (infinite sets), Odrzywołek (continuous eml operator) (Mon)
