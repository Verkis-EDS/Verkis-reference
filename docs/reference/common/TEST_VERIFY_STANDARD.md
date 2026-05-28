# Test and Verify Standard

> Copyright © Verkís internal documentation.

What "verified" means in this lab. Verification is a separate step from execution — see [PLANNING_MODE.md](PLANNING_MODE.md) order of operations. No closeout without verification appropriate to the task class.

## Automated runner

```bash
~/bin/verkis-common verify <task-class>
```

Runs the standard checks for the given class. If the runner is unavailable, use the manual commands below.

## Verification approach by task class

### Markdown / docs

Minimum:
- `mkdocs build --strict` from `lab-manuals/` — must exit 0.
- `markdownlint <file>` on changed files (or the project's configured linter).
- Visual check: render the page and confirm headings, code fences, links work.
- For published pages: `curl -kIs https://192.168.x.x:8443/<path> | head -1` returns `200`.

### Bash / shell scripts

Minimum:
- `bash -n <script>` (syntax check).
- `shellcheck <script>` — must pass with no warnings, or each waived warning documented inline.
- Dry-run mode if the script supports it; otherwise run in a scratch directory.
- Trap handlers verified by triggering the error path.

### Python

Minimum:
- `python3 -m py_compile <file>` (syntax).
- `ruff check <file>` (or project linter).
- Unit tests under `pytest -q` — exit 0.
- For scripts touching the lab: read-only dry-run before mutating run.

### Docker

Minimum:
- `docker compose config` — schema valid.
- `docker compose build` for any changed image.
- `docker compose up -d` then `docker compose ps` shows `healthy` (or `running` if no healthcheck).
- Verify logs `docker compose logs --tail=50` — no error spam.
- Confirm container is **inside an approved VM**, never on the Proxmox host (see [RULES.md](RULES.md)).

### Git

Minimum:
- `git status` clean after commit.
- `git log --oneline -1` shows the expected message.
- `git push` succeeds against `https://192.168.x.x`.
- For force-pushes: red-team review required (see [REDTEAM_REVIEW.md](REDTEAM_REVIEW.md)).

### NAS operations

Minimum:
- `mountpoint -q /mnt/nas` before and after.
- For writes: `stat <new-path>` confirms expected size/owner/mtime.
- For rsyncs: re-run with `--dry-run` after — must show zero changes.
- For deletes: red-team review required.

### Proxmox

Minimum (read-only baseline always available):
- `pvesh get /version` on the host — confirms API reachable.
- For VM/LXC changes: `qm config <id>` or `pct config <id>` before and after, diffed.
- For storage changes: `pvesm status` before and after.
- For network changes: `ip -br addr` and `ip -br link` before and after.
- See [`scripts/proxmox_readonly_audit.sh`](scripts/proxmox_readonly_audit.sh).

### Security-sensitive changes

Minimum:
- Inventory of secrets touched (paths, types) — see [RULES.md](RULES.md) non-negotiables.
- `git diff` reviewed line-by-line for accidental secret inclusion.
- `gitleaks detect` (or equivalent) on the repo before push.
- Rotation log entry if a credential changed.

## What "verified" is not

- "It didn't error" — not verification. Show that the intended outcome is observable.
- "I ran the same command twice and got the same output" — only valid for idempotent reads.
- "I checked the file existed" — check size, content, owner, mtime as appropriate.
- "The pipeline was green last time" — re-run for this change.

## Recording verification

Every closeout (see [SESSION_CLOSEOUT.md](SESSION_CLOSEOUT.md)) includes:

```text
Verification — <task class>
Commands run: <list>
Expected: <one line>
Observed: <one line>
Result: pass | fail | partial
```

If `partial` or `fail`, the session does not close — return to Planning Mode.

## Anti-patterns

- Verifying with the same memory-only knowledge that wrote the change. Re-read the file from disk.
- Verifying on the wrong host or CWD. `pwd && hostname` first.
- Treating MkDocs `build --strict` as sufficient for behavioural changes — it only proves the build. Behaviour needs `curl` or a browser.

See also: [`RUNBOOK_MASTER_v4.md`](RUNBOOK_MASTER_v4.md).
