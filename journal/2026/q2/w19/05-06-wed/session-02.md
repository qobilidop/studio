# session-02: z3wire — naming rule restated; symbolic execution example #1

Repo: github.com/qobilidop/z3wire. Worktree workflow used for the example; trivial direct-to-main for the style edit.

## Outcomes

- **Commit `0bc471e` direct to main:** restated `docs/dev/style.md` naming rule positively in 3 buckets (free fns snake_case, class methods Google-style, type traits std-style snake_case+_v). Dropped overstated "other SMT/HW libraries in the ecosystem" claim — replaced with honest "matches Z3 (wrapped API) + std::". No code changes.
- **PR #25 merged → squash commit `87ccdc9` on main**, three branch commits squashed:
    1. `cbac441` chore: refresh `MODULE.bazel.lock` for `rules_shell` 0.8.0 (entries missing from #16; bazel auto-added on first fresh build)
    2. `dd47eed` library: add `constexpr` to `BitVec::operator==` at `z3wire/bit_vec.h:296`. Body already constexpr-clean for W≤64 (uses `value()`); W>64 branch (`ToLeBytes()`) not constexpr but C++20 allows non-constexpr code in unreachable branches during constant evaluation. Test: new `BitVecTest.EqualityIsConstexpr` in `bit_vec_test.cc:261`.
    3. `5830fa1` examples: add `examples/symbolic_execution/exact_match_table.cc` + `BUILD.bazel`, CMake entry in `examples/CMakeLists.txt`, README row.

## Naming-rule audit (key facts to remember)

- Z3 free fns (in z3++.h): `ashr`, `lshr`, `shl`, `concat`, `ite`, `zext`, `sext`, `bvadd_no_overflow`, `mk_and`, `min`, `max`, `forall`, `exists`, … all snake_case.
- std:: free fns: snake_case universally.
- **camelCase counterexamples (don't overclaim ecosystem):** Verilator (`assertOn`, `gotFinish`), MLIR/CIRCT (`emitError`, `emitWarning`; `mlir::verify` is the rare snake_case from STL-mimic utilities), CVC5 (`mkBitVector` — methods, not free fns).
- snake_case anchors: Z3, std::, SystemC (`sc_start`/`sc_stop`), Bitwuzla (`mk_bv_value`).
- Justification used in commit msg: "calls like `z3::shl` and `z3w::shl` read consistently."

## Exact-match-table example: design facts

- `examples/symbolic_execution/` is a new subdirectory. Helper `extract_key` stays inline in the example file; **factor to shared header only when 2nd example (e.g., `ternary_match_table.cc`) needs it (YAGNI)**.
- Future planned examples in same dir: ternary match, range match, LPM, multi-stage match-action pipelines. All would share path-enumeration style.
- Dimensions: input W=48 bits (6 bytes), N=3 byte offsets `{0, 2, 4}` (MSB-first), K=4 entries, V=8 bits, `kMissValue=0xff`. Entry keys: `0xaabbcc, 0xddeeff, 0x112233, 0x445566`. Values 0x01..0x04.
- Path semantics: option (a) **static enumeration** — K+1 separate `z3::solver` instances, each with one path-condition assertion. NOT solver-driven path discovery (option b was rejected for first example as less transparent).
- Each `s.check()` is always sat under unique-key invariant + miss-room invariant. No runtime fallback handling — that'd indicate a logic bug.
- Compile-time uniqueness: `consteval all_keys_unique(const Table&)` + `static_assert`. **Required `BitVec::operator==` to be `constexpr`** — that's what the precursor commit was for.
- Output format: per path, label + path condition + witness input (12 hex digits) + output value. ASCII-only ("not in {…}", not `∉`).

## API facts confirmed during design (still true at `87ccdc9`)

- `SymBitVec::From(z3::expr)` at `sym_bit_vec.h:49` — documented public factory; equivalent to the `explicit` constructor at `:40`. Both run width/sort `Z3W_CHECK`. **Use `From` in user-facing example code; library internals use the constructor.**
- `z3w::concat` is variadic at `sym_bit_vec.h:664-669` — `concat(a, b, rest...)` works.
- Static `extract<H, L>(val)` at `sym_bit_vec.h:534` requires compile-time H, L.
- **Symbolic-offset `extract<TargetWidth>(val, start_idx)` at `sym_bit_vec.h:543` exists** — takes a `SymUInt<IdxW>` start_idx (LSB of slice). I missed this initially during the design; user pointed it out. We considered it then rejected it because the implementation became more complex (`std::bit_width(W)`, `to_symbolic(UInt::From(...), ctx)`, intermediate `std::array<SymUInt<8>, N>`, `std::apply` over variadic concat). Final version drops to raw `z3::expr` per byte, builds `z3::expr_vector`, calls `z3::concat(bytes)`, re-wraps via `SymUInt<N*8>::From(...)`.
- Mixed sym/concrete `==`/`!=` at `sym_bit_vec.h:358, 365` (uses `mixed_operands` concept + `internal::promote`).

## Style/lint gotchas in this codebase

- **clang-tidy enforces `readability-braces-around-statements`** — `if (cond) return false;` fails as "warning treated as error". Always brace single-statement bodies.
- `clang-tidy: all checks passed`, `include-cleaner: all checks passed`, `buildifier: all checks passed`, `shellcheck: all checks passed` — full lint pipeline at `./tools/lint.sh`.
- `./tools/format.sh` in a worktree prints `fatal: not a git repository: .git/worktrees/<name>` from some script's git probe (linked-worktree `.git` is a file, not a dir) but completes successfully. **Pre-existing, harmless, ignore.**

## CMake / Bazel target naming

- **Bazel:** `//examples/symbolic_execution:exact_match_table` — new `BUILD.bazel` per subdir.
- **CMake:** target name follows `<subdir>_<basename>` per `usage_*` precedent → `symbolic_execution_exact_match_table`. Added directly to `examples/CMakeLists.txt` (no per-subdir CMakeLists, matching `usage/` precedent).
- examples deps: `//z3wire:sym_bit_vec` only (transitively pulls bit_vec). Other examples include `bit_vec.h` directly without listing the dep — fine.

## User preferences exercised this session

- Skip worktree + PR for trivial docs/config edits → used for the style.md update (commit direct to main).
- Worktree + PR for non-trivial work → used for the example (PR #25). User's saved feedback explicitly distinguishes the two cases.
- Confirmed naming preference: full words, no abbreviations (`symbolic_execution/`, not `symex/`).
- During brainstorming, prefers iterating on naming/wording carefully — surfaced via "Maybe it looks better with the previous 'escape to Z3' version?" feedback that swapped the implementation cleanly.

## Process lessons

- **Verify API existence before recommending alternatives** — I claimed `extract` was template-only when proposing the raw-Z3 escape; user knew the symbolic-offset overload existed. Now habituated: grep before asserting.
- **Self-corrected an audit overclaim** mid-stream rather than doubling down — user requested verification, web-searched CVC5/Bitwuzla/SystemC/Verilator/MLIR, found the camelCase counterexamples, narrowed the claim to "Z3 + std::" only. Worth doing every time the persuasion case rests on "everyone does it."
- **Squash-merge cleanup:** `ExitWorktree --action remove` refuses if commits aren't on base branch. After GitHub squash, branch commits look unmerged from git's ancestry, so use `discard_changes: true`. User confirmed merge before I proceeded.
- **Lockfile churn is benign:** if a dependency-bump PR didn't include the new lockfile entries (e.g., #16 for rules_shell 0.8.0), they'll appear on the next fresh build. Commit them as a chore alongside whatever you're working on, or separately.

## Files touched on main (post-merge state)

- `docs/dev/style.md` — 3-bullet naming rule
- `z3wire/bit_vec.h:296` — `constexpr operator==`
- `z3wire/bit_vec_test.cc:261` — `EqualityIsConstexpr` test
- `examples/symbolic_execution/{exact_match_table.cc, BUILD.bazel}` — new
- `examples/CMakeLists.txt` — new target between `midpoint_overflow` and usage examples
- `examples/README.md` — new row
- `MODULE.bazel.lock` — rules_shell 0.8.0 entries

## Spec/plan artifacts (gitignored)

- `.agent_scratch/2026-05-06-exact-match-table-design.md`
- `.agent_scratch/2026-05-06-exact-match-table-plan.md`
