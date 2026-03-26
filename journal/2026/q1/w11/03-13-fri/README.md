# 2026-03-13 (Friday)

Z3Wire wiregen architecture designed in depth: Protobuf txtpb meta-schema, triad output (symbolic + concrete + protobuf), nested structs, Smart Enum pattern. Type system exploration across languages. Evening break with Genshin Impact.

## Sessions

- **session-00**: Daily log (Gemini) -- wiregen architecture design (naming, meta-schema, nested structs, arrays, enums, generator language comparison, hardware register format survey), type system exploration (OCaml GADTs, Rust const generics, Zig comptime, Idris/Agda dependent types), evening Genshin Impact break

## Agent index

- wiregen module: `tools/wiregen/`, single-source-of-truth schema -> generates 3 artifacts: symbolic Z3Wire struct, concrete C++ struct, Protobuf message (session-00)
- wiregen meta-schema: define types in `wiregen_schema.proto`, use `.txtpb` as SoT; Protobuf TextFormat::Parse() provides free schema validation (session-00)
- wiregen supports: nested structs (multi-pass/topological sort), repeated/array fields (std::array for fixed-size), enum fields ("Smart Enum" struct wrapping z3wire::UInt<W> with is_valid()) (session-00)
- separate C++ enum from Protobuf enum: memory layout control, dependency isolation, zero-value rule (session-00)
- wiregen naming exploration: wiregen, harness, loom, prism, bundler -> settled on wiregen (session-00)
- generator language: C++ stronger with txtpb approach (parsing free via Protobuf runtime); Python has Jinja2 advantage (session-00)
- hardware register formats surveyed: SystemRDL, IP-XACT, CMSIS-SVD, OpenTitan reggen (HJSON) -- custom txtpb preferred for minimal agentic workflow (session-00)
- type system spectrum: C++ NTTPs -> Rust const generics -> Zig comptime -> Idris/Agda true dependent types; OCaml GADTs/phantom types simulate but Peano unergonomic; Hardcaml tracks widths dynamically (session-00)
- conclusion: C++ templates + wiregen codegen is practical sweet spot (session-00)
- P4 GSoC repo work still planned for weekend (session-00)
