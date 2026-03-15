# Session: P4kt Project Setup

**Repo:** github.com/qobilidop/p4kt

## What happened

Set up a greenfield Kotlin + Bazel project for P4kt (a P4 eDSL in Kotlin). Went through brainstorming, planning, implementation, and several rounds of refinement.

## Key decisions

- **Bazel with Bzlmod** (not WORKSPACE): rules_kotlin 2.3.10, rules_jvm_external 6.10, Bazel 8.6.0
- **JUnit 4 runner** (not JUnit 5): kt_jvm_test uses Bazel's JUnit 4 test runner. kotlin-test-junit, not kotlin-test-junit5. This was a gotcha discovered during verification.
- **Flat Google-style layout**: package-per-feature, tests co-located with source
- **Devcontainer as primary dev env**: benchmarked native (~5s) vs devcontainer (~8s cold cache). Overhead acceptable. Ubuntu 24.04 + JDK 21 + Bazelisk + build-essential.
- **No lock files checked in**: solo project, YAGNI. Re-add when collaborators join.
- **`./dev` wrapper script**: thin shell script forwarding commands to `devcontainer exec`. Pattern inspired by gradlew, Rails bin/dev, etc.
- **Docker runtime is Colima**, not Docker Desktop. Ubuntu 24.04 base image already has `ubuntu` user at UID 1000 (not `vscode`).

## Gotchas encountered

- `maven_install.json` lock file bootstrapping: can't reference a lock_file that doesn't exist yet. Solution: removed lock_file param entirely.
- `groupadd -g 1000 vscode` fails on Ubuntu 24.04 because UID/GID 1000 is already taken by `ubuntu` user. Solution: use `ubuntu` user directly.
- `build-essential` needed in container for Bazel's CC toolchain auto-configuration.

## User preferences learned

- Prefers fewer, logical commits over many tiny ones
- Plain hyphens (-) over em dashes
- Asks thorough clarifying questions before deciding - values understanding trade-offs
- Uses VS Code
- Follows Google/Bazel conventions

## Final file structure

```
.bazelversion
.devcontainer/Dockerfile
.devcontainer/devcontainer.json
.gitignore
AGENTS.md
BUILD.bazel
CLAUDE.md
LICENSE
MODULE.bazel
README.md
dev (executable)
docs/dev.md
p4kt/BUILD.bazel
p4kt/P4kt.kt
p4kt/P4ktTest.kt
```

## What's next

Building actual P4 abstractions (headers, tables, actions, etc.).
