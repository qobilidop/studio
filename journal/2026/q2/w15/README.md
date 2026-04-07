# 2026 W15 (Apr 6-12)

Week begins with Zensical exploration and tooling migrations, sail-xisa docs restructuring and MAP ISA completion (44 opcodes, all self-contained instructions done), plus deep Gemini research into Rust+MLIR, BPF ecosystem, and P4 backends.

## Days

- [04-06-mon](04-06-mon/README.md): Zensical deep dive + Z3Wire tooling migration (MkDocs Material to Zensical, pip to uv), sail-xisa docs restructuring (Starlight reverted, spec/plan cleanup), MAP ISA expansion (opcodes 26-43, all self-contained done), Rust+MLIR/BPF/P4 backend exploration

## Agent index

- ZENSICAL: comprehensive comparison vs MkDocs/Docusaurus/Hugo/Sphinx. Migration: MkDocs Material → Zensical (reads mkdocs.yml natively), pip → uv. Zensical best for docs-as-code (Rust core, Python extensibility, standard Markdown) (Mon)
- SAIL-XISA-MAP-COMPLETE: opcodes 0-43 all self-contained instructions implemented. Remaining (JTL, HASH, LKP, SYNC, CPR, CHKSUM, SENDOUT/DROP) need external subsystems. MLDS/MSTS added PMEM state model. insert_bits → set_slice_bits refactor. Doc audit caught MAP register range + .CD modifier gaps (Mon)
- SAIL-XISA-DOCS: adopted z3wire docs/dev pattern, tried and reverted Starlight, deleted 43 spec/plan files (-18740 lines), extracted reference content to docs/, flattened docs/dev → docs/ (Mon)
- RUST-MLIR: melior (most mature, TableGen+FFI), pliron (native Rust), circt-rs. Projects: Burn/CubeCL, LLZK, CIRCT integrations (Mon)
- BPF-MLIR: no upstream BPF dialect in MLIR, P4MLIR proposal on Discourse, p4c backends (p4c-ebpf, p4c-dpdk, p4c-ubpf) (Mon)
