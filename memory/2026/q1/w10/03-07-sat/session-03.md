# z3wire — first implementation session

## claude-opus-4-6 summary

### What we accomplished

Built z3wire from scaffolding to a complete MVP in a single session:

1. **Z3 as Bazel dependency** — Wired up Z3 (static build) and GoogleTest via bzlmod. Discovered Z3's CMake needs python3, and the dynamic library has runfiles issues — static works cleanly.

2. **Bool wrapper** — `z3w::Bool` with symbolic variables, literals (`True`/`False`), logical ops (`&&`, `||`, `!`), equality.

3. **BitVec<W,S> with Ubv/Sbv aliases** — Full MVP:
   - Construction: symbolic variables, `Literal<Value>` (compile-time range-checked)
   - Bitwise: `&`, `|`, `^`, `~` (strict width/signedness matching)
   - Equality/comparison: `==`, `!=`, `<`, `<=`, `>`, `>=` (signedness-aware)
   - Arithmetic: `+`, `-` with bit-growth (`max(W1,W2)+1`)
   - Shifts: `<<`, `>>` (hardware), `checked_shl`/`checked_shr`, `lossless_shl`
   - Casting: `cast`, `safe_cast`, `checked_cast`
   - Bit manipulation: `extract` (static + symbolic-offset), `concat` (variadic)
   - Bool/Ubv<1> conversion: `to_bool`, `to_ubv1`
   - Conditional selection: `ite`

4. **Examples** — Three runnable examples: safe_adder, alu, bit_manipulation.

5. **Code quality tooling** — clang-format (Google style), `tools/format.sh`, `tools/lint.sh`, CI format check.

6. **dev.sh** — Docker wrapper script that auto-builds the devcontainer image and runs commands inside it. CI uses it too, so the script is always tested.

7. **Code organization** — Restructured from `include/` + `tests/` to Google-style flat layout (`z3wire/bool.h` + `z3wire/bool_test.cc` side by side).

8. **AGENTS.md** — Comprehensive agent guide modeled after smolkaj/4ward, enabling gradual transition to auto-pilot mode.

### Key technical decisions

- **Z3 static over dynamic**: Dynamic has shared library runfiles issues in Bazel sandboxed tests. Static just works.
- **Subtraction is always signed**: Even `Ubv - Ubv` returns `Sbv` because the result can be negative.
- **`internal::extend`**: Shared helper for bit-growth arithmetic — extends based on source signedness.
- **Persistent Bazel cache volume**: `docker run -v bazel-cache:/root/.cache/bazel` avoids rebuilding Z3 (~9 min) on every run.
- **`dev.sh` always rebuilds image**: Uses `docker build -q` (layer cache makes it instant when unchanged) instead of checking if image exists (which misses Dockerfile changes).

### Workflow patterns that worked well

- **Test before commit**: Always run `bazel test //...` before committing.
- **Incremental commits**: Small, focused commits with clear messages rather than one big commit.
- **`/simplify` for review**: Used the simplify skill to catch stale docs, duplicated docker boilerplate, and a missing lint step in README.
- **Design doc first**: Having `docs/design.md` made implementation straightforward — just follow the spec.

### What's next (post-MVP)

- Multiplication, division, modulo (listed as deferred in design doc)
- Unary minus for signed values
- API review with fresh eyes
