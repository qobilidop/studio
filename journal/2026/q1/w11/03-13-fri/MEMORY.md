# 2026-03-13 (Fri)

## Sessions

### session-00: Daily log (Gemini)
- Z3Wire codegen architecture brainstorming — **"wiregen"** module
  - Single-source-of-truth schema → generates 3 artifacts: symbolic Z3Wire struct, concrete C++ struct, Protobuf message
  - Meta-schema approach: define types in `wiregen_schema.proto`, use `.txtpb` as SoT files
  - Protobuf `TextFormat::Parse()` provides free schema validation and strongly-typed parsing
  - Supports: nested structs (requires multi-pass resolution / topological sort), repeated/array fields (`std::array` for fixed-size), enum fields ("Smart Enum" struct pattern backed by `z3wire::UInt<W>`)
  - Enum `is_valid()` method auto-generates Z3 domain constraint from enum values
  - Separate C++ `enum class` from Protobuf enum (memory layout control, dependency isolation, zero-value rule)
  - Naming: explored wiregen, harness, loom, prism, bundler → settled on **wiregen** (`tools/wiregen/`)
  - Generator language: C++ vs Python vs Go comparison; C++ became stronger contender with txtpb approach (parsing is free via Protobuf runtime); Python still has Jinja2 advantage
  - Surveyed existing hardware register formats: SystemRDL, IP-XACT, CMSIS-SVD, OpenTitan's reggen (HJSON) — custom txtpb approach preferred for minimal agentic workflow
- Type system exploration (pure research, no OCaml rewrite planned)
  - OCaml: no true dependent types; GADTs/phantom types can simulate but Peano encoding is unergonomic; Hardcaml tracks widths dynamically at runtime
  - Spectrum: C++ NTTPs → Rust const generics → Zig comptime → Idris/Agda true dependent types
  - Conclusion: C++ templates + wiregen codegen is a practical sweet spot
- Decided to take evening break — Genshin Impact (Teyvat); resume coding tomorrow
- P4 GSoC repo work planned for weekend

## Key decisions
- wiregen module name and location: `tools/wiregen/`
- Protobuf txtpb meta-schema approach for SoT (over YAML/JSON)
- Triad output: symbolic + concrete + protobuf, all from single schema
- Separate C++ enum from Protobuf enum for hardware accuracy
- "Smart Enum" pattern: struct wrapping `z3wire::UInt<W>` with static constants and `is_valid()`

## Open items
- P4 GSoC repo work this weekend
- P4kt Pi Day (3/14) kickoff
- wiregen implementation (schema design locked, generator not yet built)
