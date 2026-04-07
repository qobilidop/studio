# 2026-04-06 (Monday)

Zensical deep dive (Gemini Q&A comparing doc systems, Astro integration patterns), Z3Wire docs tooling migration (MkDocs Material to Zensical + pip to uv), sail-xisa docs restructuring (Starlight experiment reverted, docs cleanup, port forwarding fix), sail-xisa MAP ISA expansion (16 new instructions: scratchpad/RAM/global data/modulo/subroutines/packet header + MLDS/MSTS + insert_bits refactor + doc audit), plus Gemini exploration of category theory, Rust+MLIR, BPF/eBPF, and P4 backends.

## Sessions

- **session-00**: Daily log — Gemini Q&A: Zensical vs MkDocs/Docusaurus/Hugo/Sphinx, Zensical for PEP-like design docs, mixing Zensical with Astro (monorepo/build-time merge/reverse proxy), category theory for engineers (Milewski, Fong & Spivak), Rust+MLIR (melior, pliron, circt-rs, CubeCL, LLZK), BPF VM/runtime projects (bpftime, uBPF, rbpf), eBPF bytecodes vs BPF ISA, BPF/P4MLIR dialect proposals, P4 backend C/C++ codegen (p4c-ebpf, p4c-dpdk, p4c-ubpf)
- **session-01**: Z3Wire — docs tooling migration: MkDocs Material to Zensical (bf7be53), pip to uv (41e7710). Snippets over include-markdown, dropped --strict (Zensical pre-1.0), --break-system-packages still needed with uv on Ubuntu 24.04
- **session-02**: sail-xisa — docs restructuring: adopted z3wire docs/dev pattern, Starlight integration tried and reverted (net negative for playground/spec pages), port forwarding fix (forwardPorts + appPort), deleted 43 spec/plan files (-18740 lines), extracted opcode tables + MAP reference + tech rationale into proper docs, flattened docs/dev to docs/
- **session-03**: sail-xisa — MAP ISA expansion: 16 new instructions (opcodes 26-41) with 43 tests. Scratchpad (LDSP/LDSPI/STSP/STSPI), RAM (MLD/MST), Global Data (MLDD/MLDDI/MSTD/MSTDI), Modulo (MMOD/MMODI), Subroutines (MCALL/MRET), Packet Header (MLDH/MSTH). New state: scratchpad, device_ram, gdmr. Include order change for cross-module access.
- **session-04**: sail-xisa — MLDS/MSTS implementation (PMEM structure load/store, opcodes 42-43), insert_bits refactor (replaced with Sail stdlib set_slice_bits), documentation audit (2 fixes: MAP R0-R15, .CD modifier missing SHLI/SHRI), surveyed remaining MAP ISA (all remaining need external subsystems), read HASH spec

## Agent index

- ZENSICAL-DEEP-DIVE: Gemini comparison of Zensical vs MkDocs/Docusaurus/Hugo/Sphinx. Zensical wins on: Rust core (differential builds), Python extensibility, mkdocs.yml migration path, AI/agent compatibility (standard Markdown, no MDX). Limitations: no interactive React components, not a general-purpose SSG. Best Markdown-based doc solution for docs-as-code (s00)
- ZENSICAL-ASTRO: mixing Zensical with Astro via monorepo (separate builds, shared deploy), build-time merging, or reverse proxy. No native integration (s00)
- Z3WIRE-TOOLING: MkDocs Material → Zensical (zensical reads mkdocs.yml natively, include-markdown → pymdownx.snippets). pip → uv (standalone binary, --break-system-packages still needed on Ubuntu 24.04). CI needs devcontainer image rebuild (s01)
- SAIL-XISA-DOCS: adopted z3wire docs/dev pattern, tried Starlight (reverted — StarlightPage has no head slot, squeezed content, extra heading injected). Port forwarding: forwardPorts + appPort + --host 0.0.0.0. Deleted 43 spec/plan files, extracted reference content to docs/ (encoding.md, map-reference.md, architecture.md). Flattened docs/dev → docs/ (s02)
- SAIL-XISA-MAP-ISA: 16 new instructions (opcodes 26-41) in session 03, 2 more (opcodes 42-43 MLDS/MSTS) in session 04. Total 44 opcodes implemented (0-43), all self-contained ones done. Remaining (JTL, HASH, LKP, SYNC, CPR, CHKSUM, SENDOUT/DROP) all need external subsystems (s03, s04)
- SAIL-GOTCHAS: hex literals are bitvectors not ints, no / or % operators (use bitvector masking + tmod_int), foreach satisfies type checker for bounds (while doesn't), range() type annotation + assert for bounds (s03)
- PMEM-MODELING: str_present (bits(14)), str_offset (14x8-bit), pmem (1024 bytes). STR.OFFSET spec ambiguity: section 4.4 says "4B granularity" but 4.13.13/14 says "Units: Bytes" — modeled as byte offsets (s04)
- INSERT-BITS-REFACTOR: insert_bits → set_slice_bits (cleaner). extract_bits → slice() rejected (128 >= 's constraint unprovable by callers) (s04)
- RUST-MLIR: melior (TableGen+FFI, most mature), pliron (native Rust, no TableGen), circt-rs. Notable: Burn/CubeCL, LLZK, CIRCT integrations (Moore compiler, Calyx, SMT/Verif dialects) (s00)
- BPF-LANDSCAPE: bpftime (userspace eBPF), uBPF (minimal C), rbpf (Rust, Solana). No BPF dialect upstream in MLIR — needed for compiler-level optimizations. P4MLIR proposal exists on Discourse (s00)
- CATEGORY-THEORY: recommended resources — Milewski (programmer-friendly), Fong & Spivak (applied), Pierce (types), Yanofsky (physics/CS) (s00)
