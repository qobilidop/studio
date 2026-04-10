# 2026-04-08 (Wednesday)

Lean/Rocq/F* theorem prover survey, "machine building assistant / human learning practitioner" philosophy, open hardware NICs (Corundum, OpenNIC), personal website migration to monorepo, and repo rename cyborg to studio.

## Sessions

- **session-00**: Daily log (Gemini) — nap + recovery, Lean 4 and Rocq learning interest (dependent types, interactive theorem provers), survey of verification languages (Lean 4, Rocq, Isabelle/HOL, Dafny, F*), deep Lean 4 Q&A (forward declarations via opaque/mutual/typeclasses, stateful objects via structures + StateM + FBIP), "machine building assistant / human learning practitioner" identity framing, return to X/Twitter for agentic AI discourse, open hardware NICs (Corundum FPGA NIC, AMD OpenNIC)
- **session-01**: Website migration and repo rename — moved personal website source (Astro) from qobilidop.github.io into studio/website/ with CI deploy workflow (peaceiris/actions-gh-pages, Ed25519 deploy key), renamed repo cyborg to studio (etymology: studio/study from Latin studium), deferred local dir rename and AGENTS.md identity update

## Agent index

- THEOREM-PROVERS: Lean 4 (eDSL playground, extensible parser, FBIP for perf), Rocq (battle-tested, CompCert/seL4), Isabelle/HOL (Sledgehammer automation), Dafny (SMT-backed, preconditions/postconditions), F* (refinement types + SMT, Project Everest). User interested in learning Lean + Rocq (s00)
- LEAN4-DETAILS: no forward declarations (kernel needs full definition); workarounds: `opaque` for FFI, `mutual` for mutual recursion, typeclasses for interfaces. State via structures + dot notation + StateM monad + FBIP (ref-count-based in-place mutation when rc=1) (s00)
- IDENTITY: "machine building assistant, human learning practitioner" — user builds sandboxes and orchestrates agents, frees cognitive load for learning (s00)
- OPEN-NICS: Corundum (Verilog, 10/25/100G, thousands of queues, PTP timestamping), AMD OpenNIC (AXI4-Stream user logic boxes, DPDK+kernel drivers). Both FPGA-based, potential compilation targets for packet processing eDSLs (s00)
- REPO-RENAME: cyborg→studio. studio/study pair from Latin studium — studio (Italian, public creative workspace) / study (French, private intellectual room). Deleted pre-existing empty studio repo. Website CI via deploy key to gh-pages branch of qobilidop.github.io (s01)
