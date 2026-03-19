# Session 01 — Z3Wire API gap analysis and Weave roadmap

Repo: github.com:qobilidop/z3wire.git (branch: main)

## What happened

1. **API gap analysis**: Compared z3wire's bit-vector API surface against Z3 C++, Rust z3, Bitwuzla, cvc5, and STP. Identified missing operations.

2. **Roadmap update — Arithmetic section added** (commit c07607d):
   - Multiply (`*`) — highest priority gap, every other library has it
   - Division/remainder (`/`, `%`) — udiv, sdiv, urem, srem
   - Rotate left/right — useful for crypto/hardware, but composable from shifts+bitwise; user confirmed it's not essential but wants it noted
   - Repeat — replicate bit pattern N times
   - Decided nand/nor/xnor and overflow detection are low priority (trivial compositions; bit-growth already handles add/sub overflow)

3. **Weave register array representation research**:
   - Researched how SystemRDL tools (PeakRDL-*, UVM RAL, Chisel, CIRCT) handle large register arrays in generated code
   - Researched how symbolic tools (Z3 array theory, KLEE, angr, Rosette, Bitwuzla) handle arrays of symbolic values
   - Key finding: static artifact generators handle arrays compactly; runtime object graph generators (PeakRDL-python, UVM RAL) all have scalability problems with eager instantiation
   - For **concrete structs**: arrays are the right choice — register arrays are dense, fixed-size, and the data is small (just packed bits)
   - For **symbolic structs**: default-zero arrays are fine for now; Z3 array theory would help for symbolic indexing but YAGNI
   - For **proto serialization**: `map<uint32, RegType>` preferred over `repeated` for register arrays, since most entries are zero. C++ side stays as `std::array`.

4. **Roadmap update — Weave proto map optimization** (commit 078e413):
   - Added item to use `map` instead of `repeated` for register arrays in generated proto messages

## Key decisions
- Rotation stays on roadmap despite being composable (user wants awareness, not urgency)
- Concrete struct arrays: use `std::array`, no map needed
- Symbolic struct arrays: use arrays with default-zero, defer Z3 array theory until needed
- Proto serialization of register arrays: switch to `map<uint32, RegType>` for sparsity
