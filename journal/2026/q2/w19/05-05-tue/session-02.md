# Session 02 — z3wire Bazel CI speedup

**Repo:** github.com/qobilidop/z3wire
**Branch start:** feat/from-tryfrom-redesign (PR #21 in flight)
**Branch end:** main (clean)

## Outcome

Warm-cache Bazel CI on z3wire: ~1h14m → **~2m32s** (~30x faster). Achieved via persistent `.bazel-disk-cache` + committing MODULE.bazel.lock so cache key invalidates correctly.

## PRs / commits landed

- **#21** "Redesign construction API: Literal/From/TryFrom" — user's, merged mid-session.
- **#22** https://github.com/qobilidop/z3wire/pull/22 "ci: persist Bazel disk cache across CI runs"
- **#23** https://github.com/qobilidop/z3wire/pull/23 "test: add fuzz test for same-width cast roundtrip"
- **b9bc2f8** direct push to main: "docs: remove completed fuzz test ideas from roadmap"

## Core mechanism (PR #22)

Added to `.github/workflows/bazel.yml` before the existing config step:

```yaml
- name: Restore Bazel disk cache
  uses: actions/cache@v4
  with:
    path: .bazel-disk-cache
    key: bazel-${{ runner.os }}-${{ hashFiles('.bazelversion', 'MODULE.bazel.lock', '.bazelrc') }}
    restore-keys: |
      bazel-${{ runner.os }}-
```

Removed `MODULE.bazel.lock` line from `.gitignore`. Copied lockfile from existing checkout (hash 2d331e51cd9f15355e321fa203ce153ed99fb0bb02b3c2a6521d311f18adbb63, 1187 lines, byte-portable URL+hash content).

## Key insight: lockfile must be committed

If `MODULE.bazel.lock` is gitignored, `hashFiles('MODULE.bazel.lock')` returns the empty-set hash on every run → cache key never invalidates → cache silently grows stale on dep updates. Bazel 8+ official guidance is to commit Bzlmod lockfiles anyway (churn issues from Bazel 6/7 are gone). Project was on Bazel 8.6.0 at `.bazelversion`.

## Measurements

| Run | Trigger | Disk state | Build | Test | Total |
|-----|---------|------------|-------|------|-------|
| historical baseline (PR #12) | feature branch | none | - | - | 1h14m14s |
| PR #22 first run | feature branch | cold (miss, no restore-key) | 15m33s | 14m11s | 29m54s |
| PR #22 merge to main | push | warm hit, no source change | 1m50s | 36s | 2m38s |
| PR #23 first run | feature branch | warm via partial restore-key | 1m45s | 41s | 2m32s |

PR #22's first run still ate 30 min because BuildBuddy remote cache was warm but disk cache was cold — every action had to be re-fetched over the network (~1000+ remote cache hits in prior runs by inspection of older logs). After disk cache is populated, BuildBuddy round-trips are eliminated.

## actions/cache@v4 mechanics (clarified during session)

- Step is two things: restore at step time + implicit save as post-step (after job's other steps).
- Save only fires if (a) job succeeded AND (b) exact `key` didn't already exist at job start.
- No save on failure → broken first run can't poison cache.
- GitHub repo cache budget: 10 GB with LRU eviction.
- Step name "Restore Bazel disk cache" is misleading (also saves) but matches existing `cmake.yml` "Restore ccache" convention; intentionally left as-is for symmetry.

## Decisions made (and *not* taken)

**Pursued:**
- Disk cache persistence (PR #22).
- Cast-roundtrip fuzz test (PR #23) as small source-change validator.

**Explicitly declined / dropped:**
- **Collapse Build + Test into one devcontainers/ci step** — user pushed back. Separate steps give per-step duration metrics, separate BuildBuddy invocation IDs (one per `bazel` invocation), per-step pass/fail visibility in Actions UI, and symmetry with `docs/dev/commands.md`'s separate documented commands. The 1-3 min container-setup overhead is one-time per run; the visibility benefits are recurring forever.
- **Repository cache persistence** (`--repository_cache=.bazel-repo-cache` + second `actions/cache`) — warm-cache CI is already at GitHub Actions overhead floor. No measurable benefit available.
- **Prebuilt Z3 via `cc_import` behind `--config=local`** — would break BCR distribution roadmap item. Big tradeoff for marginal gain.
- **`--remote_download_minimal`** — obviated by disk cache eliminating BuildBuddy round-trips.
- **Hermetic LLVM toolchain (`toolchains_llvm`)** — different goal (hermeticity), not speed. Deferred for separate session.

**Skipped flat:** RBE via BuildBuddy (overkill), mold linker (marginal), PCH (not feasible for `bazel_dep`'d Z3).

## Project-side gotchas

- **Squash-merge hides reachability.** Project uses GitHub "Squash and merge". Local merged feature branch's commits aren't reachable from new main. `git branch -d` refuses; must use `git branch -D`. Same for `ExitWorktree(action: "remove")` — needs `discard_changes: true`.
- **Branch protection: NONE on main** — direct push to main worked for `b9bc2f8` roadmap commit.
- **Dev container has prebuilt Z3** at `/usr/local/lib/libz3.so` via `.devcontainer/Dockerfile:20-37` (Z3 4.15.2). CMake uses this via `find_library`. Bazel builds Z3 from source via `bazel_dep(name = "z3", version = "4.15.2")` in `MODULE.bazel:14` — keep these versions in sync.
- **C++ toolchain is NOT hermetic.** `cc_configure` autodetects host clang. `ENV CC=clang` in Dockerfile. Build outside dev container uses host compiler.

## Files touched (final state on main)

- `.github/workflows/bazel.yml` — disk cache step added before activate-config
- `.gitignore` — `MODULE.bazel.lock` line removed
- `MODULE.bazel.lock` — now tracked
- `tests/fuzz/sym_bit_vec_cast_test.cc` — new, mirrors `bit_vec_roundtrip_test.cc` pattern
- `tests/fuzz/BUILD.bazel` — added `sym_bit_vec_cast_test` target
- `docs/dev/roadmap.md` — removed completed fuzz bullets, updated lead-in

## Workflow patterns observed/used

- `gh run watch <id> --repo qobilidop/z3wire --exit-status` in background = fire-and-forget completion notification.
- `gh api repos/qobilidop/z3wire/actions/runs/<id>/jobs --jq '.jobs[] | {steps: [.steps[] | {name, duration: ((.completed_at | fromdate) - (.started_at | fromdate))}]}'` for per-step timings.
- Per-PR job ID lookup: `gh api repos/.../actions/runs/<id> --jq '.name, .html_url'` to disambiguate between Bazel/CMake/Devcontainer "build" jobs (all share `jobs.build` key).

## Worktree behavior

- `EnterWorktree` creates at `.claude/worktrees/<name>/`, branches off `main` (not current HEAD as docstring suggests). Auto-prefixes branch name with `worktree-` and substitutes `/` with `+`.
- Renamed via `git branch -m feat/<name>` post-creation each time.
- `ExitWorktree(action: "remove", discard_changes: true)` removed worktree dir but **left the local branch in place** in 2/2 cases. Required follow-up `git branch -D <name>` to delete the leftover branch ref.

## User feedback captured

Saved to `~/.claude/projects/-Users-qobilidop-i-z3wire/memory/feedback_skip_worktree_for_trivial.md`: For trivial single-file docs/config edits with no parallel CI in flight, skip worktree + skip PR, commit directly to main. User pushed back twice in this session on the default-to-worktree-and-PR pattern for trivial work.

## Open items (not blockers, just noted)

- **Node 20 deprecation** annotation on `actions/cache@v4`. Forced to Node 24 on 2026-06-02; removed on 2026-09-16. Will affect both `bazel.yml` and `cmake.yml`. Maintainers will likely ship updated v4 / v5 before then. Track but don't act yet.
- **No "linear history" branch protection toggle enabled** on `main`. Worth enabling since project already uses squash-merge exclusively. Out of scope for today.
- **PR #21's push run on main (id 25416579320)** was triggered before #22 merged — runs old workflow without cache step. Will be slow (~1h+). Not a useful data point; ignore when looking back.

## Roadmap items still open (post-session)

Operations: division/remainder, repeat, reduction ops, SymUInt<1>/SymBool friction.
Release: v0.1.0 tag, BCR publish, vcpkg port.
Ergonomics: solver-interaction usage page, native-int comparison promotion, symbolic struct construction helpers, saturating_cast.
Quality: test coverage (signed under-tested, W=1/W=64 boundaries, mixed concrete+symbolic bitwise).
Fuzz: arithmetic properties (commutativity, negation), shift properties (`shl<N>(shr<N>())`), continuous-fuzzing CI workflow.
