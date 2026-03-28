# P4Py Project Initialization

Repo: https://github.com/qobilidop/p4py

## What happened

Initialized the P4Py Python project from scratch (repo had only LICENSE + README). Followed patterns from https://github.com/qobilidop/z3wire adapted for Python.

## Key decisions

- **Package layout**: src-layout (`src/p4py/`) per Google/PyPA best practice
- **Build**: Bazel 9 with rules_python 1.7.0 + pyproject.toml for standard Python tooling
- **Docs**: Started with MkDocs Material, then switched to **Sphinx + MyST-Parser + Furo** after research showed MkDocs ecosystem fragmenting (core unmaintained, Material in maintenance mode Nov 2025, ecosystem splitting into 3 forks). Reference projects: pip, black, attrs.
- **Formatting**: ruff (Python), buildifier (Bazel), shfmt (shell), dprint (Markdown/JSON/YAML/TOML but NOT docs/ - dprint mangles MyST syntax)
- **Linting**: ruff (Python), buildifier (Bazel), shellcheck (shell), sphinx-build -W (docs)
- **No doc formatter**: Researched thoroughly - no good MyST or rST formatter exists. Major projects (CPython, Django, pip) don't use one either. `sphinx-build -W` is the quality gate.
- **Devcontainer**: Ubuntu 24.04 with Bazelisk, ruff, pytest, Sphinx stack, buildifier, shfmt, dprint, shellcheck
- **CI**: GitHub Actions with devcontainers/ci - bazel.yml, lint.yml, docs.yml, devcontainer.yml

## Commits

1. `7be0ff3` - Set up Python project with Bazel, devcontainer, and tooling (30 files, 680 insertions)
2. `88073d3` - Switch documentation from MkDocs Material to Sphinx + MyST + Furo
3. `5ef9a50` - Exclude docs/ from dprint to avoid mangling MyST syntax

## Files created

- `src/p4py/__init__.py` - package with version
- `tests/test_version.py` - smoke test
- `pyproject.toml` - metadata, ruff/pytest config
- `MODULE.bazel`, `BUILD.bazel`, `src/p4py/BUILD.bazel`, `tests/BUILD.bazel` - Bazel build
- `.bazelrc`, `.bazelversion`, `requirements_lock.txt` - Bazel config
- `.devcontainer/Dockerfile`, `.devcontainer/devcontainer.json`, `dev.sh` - devcontainer
- `tools/format.sh`, `tools/lint.sh`, `tools/docs.sh` - tooling scripts
- `docs/conf.py`, `docs/index.md`, `docs/dev/guide.md` - Sphinx docs
- `.github/workflows/{bazel,lint,docs,devcontainer}.yml` - CI
- `CLAUDE.md`, `AGENTS.md` - AI assistant guidelines
- `.gitignore`, `.editorconfig`, `dprint.json` - editor/tool config

## Research conducted

- Sphinx vs MkDocs Material comparison (adoption, stars, downloads, ecosystem health)
- MkDocs ecosystem fragmentation (Zensical, ProperDocs, MaterialX forks)
- Sphinx + MyST + Furo example projects (pip, black, attrs, datasette)
- MyST markdown formatter/linter landscape (mdformat-myst breaks colon fences, no good option)
- rST formatter/linter landscape (even worse than MyST - docstrfmt 41 stars only active formatter)

## Next session

Ready for actual P4Py implementation work. The brainstorm session (session-00.md) has the full eDSL architecture: AST representation, decorator API, interpreter/simulator, P4 emitter, extern registry.
