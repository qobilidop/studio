# 2026-04-25 (Saturday)

The "Fabricked" attack on AMD SEV-SNP confidential computing — software-only Infinity Fabric routing manipulation that bypasses memory encryption and forges attestation, deterministic on Zen 5 EPYC.

## Sessions

- **session-00**: Daily log (Gemini). User shared https://fabricked-attack.github.io/. Attack disclosed by ETH Zurich researchers against AMD SEV-SNP (Secure Encrypted Virtualization-Secure Nested Paging). Mechanism: malicious hypervisor modifies UEFI to skip Infinity Fabric lockdown API calls during boot → fabric memory routing remains configurable post-SEV-SNP-init → attacker misroutes memory transactions between DRAM and PSP secure co-processor → tricks PSP into believing SEV-SNP initialized correctly when it wasn't. Impact: arbitrary read/write to victim CVM memory, forged attestation reports, 100% deterministic, software-only, no physical access or victim VM code execution required. Confirmed on AMD Zen 5 EPYC. AMD released patches. Architectural lesson: complex interconnect routing (Infinity Fabric) is a massive undermined attack surface for hardware-based confidential computing

## Agent index

- FABRICKED-ATTACK: ETH Zurich, AMD SEV-SNP bypass via Infinity Fabric routing manipulation. UEFI skips lockdown → fabric routes mutable post-init → misroute DRAM↔PSP traffic → forge attestation. Deterministic, software-only, Zen 5 EPYC confirmed, AMD patched. Architectural lesson: interconnect routing is undermined attack surface for confidential computing (s00)
