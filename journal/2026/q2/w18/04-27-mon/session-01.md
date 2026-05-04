# Session 01 — P4PER-4 Draft + zensical nav

Repo: https://github.com/p4lang/p4per (branch: `p4per-4`)
Outcome: PR https://github.com/p4lang/p4per/pull/7 submitted (Draft of P4PER-4 "P4PER Purpose and Guidelines").

## Environment / Setup

- Devcontainer-based dev: `./dev.sh <cmd>` runs inside container via `devcontainer exec`.
- `dev.sh` line 7 redirects `devcontainer up` stderr to `/dev/null` — hides failures. **If `./dev.sh` silently produces no output, run `devcontainer up --workspace-folder .` directly to see the error.**
- Container path inside VM: `/workspaces/p4lang__p4per` (note double underscore — NOT `p4per`).
- Tool stack: devcontainer (Ubuntu 24.04) → installs `zensical` via `uv tool install zensical --python-preference only-managed` (Dockerfile: `.devcontainer/Dockerfile`).
- Container name during session: `admiring_khorana`.
- Host port: `127.0.0.1:8000` is forwarded to container via Colima SSH multiplexer (`ssh: /Users/qobilidop/.colima/_lima/colima/ssh.sock [mux]`).

## Recurring gotchas

1. **Port 8000 in use** — multiple causes seen this session:
   - User had a separate SSH port-forward holding 8000 (kill the `ssh` PID, but check it's not the colima mux first).
   - Colima's SSH mux holds 8000 because the devcontainer maps it; this is fine, leave it.
   - Stale zensical serve inside container — `docker exec admiring_khorana sh -c 'pkill -f "zensical serve"'`.
2. **Colima docker socket gets stale** — `docker ps` from host fails with "Cannot connect to docker daemon" even though `colima status` says running. Fix: `colima restart` (kills all containers — confirm first).
3. **`zensical serve` watches `docs/` but NOT `zensical.toml`** — config changes require manual restart.
4. **Container processes don't auto-start after colima restart** — must rerun `./dev.sh zensical serve --dev-addr 0.0.0.0:8000`.

## Zensical findings (project-relevant)

- Default nav order is lexicographic string sort. `p4per-1234.md` sorts before `p4per-4.md`.
- Explicit nav syntax in `zensical.toml` (under `[project]`):
  ```toml
  nav = [
    "index.md",
    {"Title" = "path.md"},
  ]
  ```
  Bare strings use page title; dict form `{title = path}` overrides.
- Zensical (v0.0.36 at session time) **claims** MkDocs plugin compat (https://zensical.org/compatibility/plugins/) as a roadmap (Tier 1: `autorefs, awesome-nav, exclude, glightbox, literate-nav, macros, meta, mike, minify, mkdocstrings, offline, redirects, search, tags`) — but **only a hardcoded subset is actually implemented**. Verified by reading `python/zensical/config.py:_convert_plugins`: only `search, offline, mike, mkdocstrings, autorefs, glightbox` get special handling. **`awesome-nav` is NOT implemented as of 0.0.36** — installing the pip plugin and dropping a `.nav.yml` does nothing. Empirically confirmed.
- For natural-number nav order today: explicit `nav` is the only working option. Alternative: zero-pad filenames (`p4per-0004.md`) so lexicographic = numeric (rejected — URL churn).
- Existing `mkdocs-awesome-nav` plugin (PyPI: `mkdocs-awesome-nav`, successor of `mkdocs-awesome-pages-plugin`) supports `sort: type: natural` in `.nav.yml`. File a Zensical feature request if want to track.

## P4PER-4 Draft document (`docs/p4per-4.md`)

Composed via iterative back-and-forth. Structure:

- Frontmatter (title, author list with footnote-style GH links, issue link, created date, type: Process, status: Draft)
- §"What is a P4PER?" — definition + opt-in clause ("use it when it helps with presentation, discussion, coordination, or record-keeping")
- §"P4PER number" — reserve via GH issue, use issue # as P4PER #
- §"P4PER types" — Technical / Informational / Process. Technical: "Once accepted, implementations of the described feature are expected to conform to it." Informational: free to ignore. Process: not free to ignore.
- §"P4PER workflow"
  - TST administrators
  - Roles: Author, Champion, Editor, Approver. Editor doesn't pass judgment; Approver must differ from authors. Eligibility: TST members, P4 WG chairs, anyone TST/WG-chair-appointed.
  - Status: mermaid diagram + 6 bullets (Draft, Accepted, Final, Rejected, Withdrawn, Active)
  - **Lifecycle (5 numbered steps + withdrawal sentence):**
    1. Reserve a number (open GH issue)
    2. Submit a draft (PR; editor reviews+merges as Draft)
    3. Refine the draft (iterate via PRs while in Draft; editor reviews+merges; doesn't change status; many iterations OK)
    4. Get a decision (champion opens PR updating status; **approver** reviews+decides Accepted/Active/Rejected)
    5. Mark complete (Accepted → Final on impl complete; **approver** reviews+merges)
    + Withdrawal: only from Draft (intentional simplification matching PEP/EIP precedent — supersede rather than retract); **editor** reviews+merges.
- §"History" — derived from PEP 1 + EIP-1.

**Role-split convention (worth remembering):**
- Editor merges content/admin PRs: initial Draft, refinement, Withdrawn.
- Approver merges decision PRs: Accepted/Active/Rejected, Final.

## Known gaps in current Draft (deferred, not blocking)

- **Active → Final** transition exists in mermaid (dotted) and in Active bullet text, but not in any lifecycle step. Reviewers may ask.
- Status bullet order (Draft, Accepted, Final, Rejected, Withdrawn, Active) does not match diagram flow. User explicitly declined reorder.
- Lifecycle step 2's `P4PER-N` is a bare placeholder, not a code-formatted file path. User chose to keep it minimal.
- `eligible editors and approvers` list says "appointed by P4 TST members or P4 WG chairs" (singular agent can appoint) — slightly loose, intentional.

## User preferences observed (apply in future sessions on this repo)

- Wants **minimal Draft** — push back on additions that aren't load-bearing.
- Prefers **terse responses**; doesn't need restating of context.
- **Trust-but-verify**: corrected my incorrect claim about Zensical not supporting MkDocs plugins. Always re-check claims about external tools before stating them confidently.
- Prefers **concrete diff suggestions** over abstract feedback (give the rewritten sentence, not just "this is unclear").
- For repeated /loop-style reminder messages about TaskCreate: ignore — user is fine without task tracking.

## Files modified this session

- `docs/p4per-4.md` (heavily edited — see above)
- `zensical.toml` (added explicit nav)
- `docs/index.md` (was already modified at session start)
- `docs/p4per-1234.md` (was already modified at session start)
- `.devcontainer/Dockerfile` — temporarily added `--with mkdocs-awesome-nav`, **reverted** when verified plugin doesn't work
- `docs/.nav.yml` — created and **deleted** in same session (plugin doesn't work)

## Useful commands captured

```bash
# Find what's on host port 8000
lsof -i :8000

# Identify if it's colima's mux (don't kill that)
ps -o pid,command -p <PID>

# Kill zensical serve inside container
docker exec admiring_khorana sh -c 'pkill -f "zensical serve"'

# Start zensical serve in background inside container
docker exec -d admiring_khorana sh -c 'cd /workspaces/p4lang__p4per && zensical serve --dev-addr 0.0.0.0:8000 > /tmp/zensical.log 2>&1'

# Verify nav order on live site
curl -sS -m 5 -o /tmp/p.html http://0.0.0.0:8000/p4per/ && grep -oE 'p4per-[0-9]+' /tmp/p.html

# Check what's on port 8000 inside the container (no lsof available)
docker exec admiring_khorana sh -c 'awk "NR>1 && \$2 ~ /:1F40\$/ {print \$2,\$3,\$4}" /proc/net/tcp'
# state 0A=LISTEN, 06=TIME_WAIT, 01=ESTABLISHED
```
