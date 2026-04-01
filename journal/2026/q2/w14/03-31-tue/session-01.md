# Session 01 — Sail XISA: Full project bootstrap + Parser ISA implementation

**Repo:** github.com:qobilidop/sail-xisa.git
**Duration:** Long session (multi-hour)
**Model:** Claude Opus 4.6

## What happened

Built the Sail XISA project from scratch — a formal specification of Xsight Labs' X-Switch ISA in the Sail language. Went from empty repo to 20 implemented Parser instructions with an executable fetch-decode-execute loop.

## Key decisions

- **Sail language** for formal ISA spec, inspired by sail-riscv but not mirroring its structure
- **Dev container** (Ubuntu 24.04 + opam + OCaml 5.1.0 + Sail 0.20.1 + z3) with `dev.sh` wrapper
- **CMake** over Makefile for out-of-source builds and CTest integration
- **No binary instruction encoding** — instruction memory stores `pinstr` union values directly. Binary decode deferred until XISA publishes encodings. Execute function unchanged when encoding added later.
- **256-slot instruction memory** — Sail requires literal default for vector registers of union types; 1024 was impractical
- **Subtraction uses `sub_bits(a, b)`** not `a - b` in Sail (operator not defined for bitvectors)
- **EXT source offsets are big-endian** (MSB-first): offset 0 = most significant bit of packet data
- **Parser register naming**: `PR0-PR3, PRN` prefix avoids future MAP ISA collision
- **Condition flags** `pflag_z`, `pflag_n` set by arithmetic/compare/sub instructions

## Implemented (20 Parser instructions)

NOP, HALT, HALTDROP, MOV, MOVI, EXT, ADD/ADDI, SUB/SUBI/SUBII, AND/ANDI, OR/ORI, CMP/CMPIBY/CMPIBI, CNCTBY/CNCTBI, BR (7 condition codes), BRBTST (CLR/SET)

## Infrastructure built

- `.devcontainer/` with Dockerfile + devcontainer.json
- `dev.sh` — devcontainer exec wrapper
- `CMakeLists.txt` — type-check target + CTest via `add_sail_test` function
- `tools/format.sh` — `sail --fmt` wrapper with `--check` mode (container-compatible, no git dependency)
- `.github/workflows/build-devcontainer.yml` — builds + pushes dev container image to GHCR
- `.github/workflows/ci.yml` — format check + type-check + tests using cached devcontainer
- 15 test suites: per-instruction + integration + EXT edge cases + program-level
- `model/parser/exec.sail` — fetch-decode-execute loop (`parser_step`, `parser_run`, `parser_load_program`)

## Remaining Parser ISA (priority order)

1. STCI/STC — cursor manipulation
2. HDR model + STH + STCH/STHC — header metadata
3. ST/STI — struct storage
4. EXTMAP/MOVMAP — MAP register bridge
5. MOVL/MOVR (6 variants) — dynamic offset moves
6. NXTP/PSEEK + deferred BRs — transition table (hardest)

## Sail lessons learned

- `$include <prelude.sail>` and `$include <string.sail>` needed in prelude
- `sail_zeros(n)` not `zeros()` for explicit-width zero bitvectors
- `sail_shiftleft`/`sail_shiftright` functions, not `<<`/`>>` operators
- `sub_bits(a, b)` for bitvector subtraction
- `scattered union` + `scattered function` for extensible instruction definitions
- Enum equality needs manual `eq_` function + `overload operator ==`
- Vector registers of union types need literal default values (no `undefined`)
- `assert()` in loops doesn't always propagate constraints to Sail's type checker; use helper functions with assert instead
- `get_slice_int(width, value, offset)` to convert int to bits for shift/mask operations

## File structure

```
model/prelude.sail, main.sail
model/parser/{types,state,decode,insts,exec}.sail
test/parser/test_{nop,halt,mov,ext,add,sub,and,or,cmp,cnct,br,brbtst,integration,ext_edge,program}.sail
tools/format.sh
.devcontainer/{Dockerfile,devcontainer.json}
.github/workflows/{ci,build-devcontainer}.yml
docs/{dev-commands,coverage,todo}.md
docs/specs/2026-03-31-{sail-xisa,ci-and-formatter,parser-arith-logic,branch-instructions,fetch-decode-execute}-design.md
docs/plans/2026-03-31-{parser-vertical-slice,ci-and-formatter,parser-arith-logic}.md
```

## User preferences noted

- Lowercase filenames with hyphens (uppercase only for root conventional files)
- Dev container workflow with `dev.sh` convenience script
- Readable tests as correctness evidence
- Docs: dev commands reference, spec coverage tracker, tech debt log
- Inline execution for small mechanical tasks; brainstorm+plan for larger ones
- Enforcing formatter in CI
