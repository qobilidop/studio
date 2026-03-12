# Z3Wire: Docs Reorg, bitfield_eq, Project Polish

Project: Z3Wire (https://github.com/qobilidop/z3wire)

## Work Done

### 1. mdformat-mkdocs Fix
- Plain `mdformat` strips 4-space indentation from mkdocs admonitions (`!!! note` blocks)
- Tried `mdformat-admon` and `mdformat-mkdocs` plugins — only `mdformat-mkdocs` works
- **Key**: must NOT install both `mdformat-admon` and `mdformat-mkdocs` — they conflict
- Solution: replace `mdformat` with `mdformat-mkdocs` in `.devcontainer/Dockerfile`
- Re-included `docs/` in `tools/format.sh` (was previously excluded as workaround)
- Plugin normalizes list continuation indent to 4 spaces (CommonMark standard)
- Commit: `4eba69d`

### 2. bitfield_eq Feature (Design + Implementation)
- **Design doc**: `docs/design/bitfield-eq.md`
- **API**: `z3w::Bool bitfield_eq(const Ubv<W>& buffer, const Fields&... fields)`
- **Key decisions**:
  - Returns `z3w::Bool` constraint, doesn't take solver (consistency with rest of API)
  - LSB-first field ordering (matches Amaranth, Chisel; opposite of `concat` which is MSB-first)
  - Name `bitfield_eq` chosen over `bind_bitfield` because it returns a value, not a side effect
  - Automatic type conversions: Bool→to_ubv1, Sbv→cast<Ubv>, Ubv as-is
  - static_assert on width sum
  - No nesting (use concat for grouping, chain bitfield_eq for multi-level)
  - No MSB-first variant (YAGNI)
  - Symbolic types only
- **Alternatives rejected**: macro-generated struct, template struct with index access, plain C++ struct (needs C++26 reflection), Boost.PFR dependency
- **Workaround for plain struct**: users can use C++ structured bindings `auto& [x,y,z] = my_struct;` then pass to bitfield_eq
- **Implementation**: `z3wire/bitfield.h` (62 LOC), 7 tests in `bitfield_test.cc`, 1 compile-fail test
- **Docs**: operations.md "Bit field" section, cheatsheet entry
- Commits: `e9f84ad` through `4383e4d` (8 commits)

### 3. Naming Convention Audit
- Audited all naming against Google C++ Style Guide
- **Major finding**: all functions use `snake_case`, Google says `CamelCase`
- **Decision**: keep `snake_case` — matches Z3 C++ API users call alongside Z3Wire
- **Type traits**: keep STL convention (`is_symbolic`, not `IsSymbolic`)
- Documented deviations in AGENTS.md
- Commit: `ffdd7fa`

### 4. Project Name Convention
- "Z3Wire" in prose, `z3wire` in code/paths/URLs
- Checked consistency — all correct throughout codebase

### 5. LICENSE Update
- Changed `Copyright (c) 2026 Bili Dong` → `Copyright (c) 2026 The Z3Wire Authors`
- Follows Go pattern; year doesn't need annual updating
- Commit: `8fbb50c`

### 6. AGENTS.md Refinements
- Added project name spelling rule
- Added Documentation section (docs build, design docs, cheatsheet, no non-doc files in docs/)
- Added test co-location convention
- Added lint guideline (soft rule — run before push, not every commit)
- Moved docs build check to Rules section
- Commits: `1c3b49b`, `7196a60`

### 7. Plan File Cleanup
- Moved plan from `docs/superpowers/plans/` to `plans/` (mkdocs strict mode rejects broken links)
- Later deleted `plans/` entirely since implementation was done and design doc captures everything
- Commit: `151148f`

## Key Learnings
- `mdformat-mkdocs` is the correct plugin for mkdocs admonition support (not `mdformat-admon`)
- LSB-first is the dominant modern convention for bitfield layout (Amaranth, Chisel, FIRRTL)
- MSB-first is legacy (SystemVerilog) and what datasheets/RFCs use
- No SMT solver provides struct/bitfield abstraction — novel for Z3Wire
- Don't place non-doc files in `docs/` — mkdocs strict mode will fail
- Docker cache issues: use `docker buildx build --no-cache` when Dockerfile changes cause snapshot errors

## Commits (chronological)
```
4eba69d Switch to mdformat-mkdocs for mkdocs admonition support
b02b3ca Add bitfield_eq design doc
e9f84ad Scaffold bitfield_eq header and test
42fab2c Implement bitfield_eq for Ubv fields
637f18f Support Bool fields in bitfield_eq
1aefa52 Add Sbv field test for bitfield_eq
ee20af0 Add mixed-type bitfield_eq test (Bool + Ubv + Sbv)
0014b8a Add compile-fail test for bitfield_eq width mismatch
126c409 Document bitfield_eq in operations guide
4383e4d Add bitfield_eq to cheatsheet
ced47b4 Add bitfield_eq implementation plan
151148f Remove completed implementation plan
8fbb50c Update copyright to The Z3Wire Authors
ffdd7fa Document naming convention deviations from Google style
1c3b49b Add project name and documentation guidelines to AGENTS.md
7196a60 Add test co-location, docs build, and lint guidelines
```
