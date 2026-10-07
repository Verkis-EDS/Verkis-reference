# Verkís Proxmox Development Lab — Operating Rules

> Copyright © Verkís internal documentation. Canonical policy. GitLab Common Ops is the versioned source; this NAS checkout is its deployed working copy. Changes go through a reviewed commit and merge request.

This file is the single load-bearing operating standard for the lab. Every session reads it first.

## Canonical names

| Item | Canonical value |
|---|---|
| NAS mount on `3HS` | `/mnt/nas` |
| NAS root | `/mnt/nas/Verkis-Proxmox-Dev` |
| Common folder | `/mnt/nas/Verkis-Proxmox-Dev/_common` |
| Projects folder | `/mnt/nas/Verkis-Proxmox-Dev/projects` |
| GitLab | `https://192.168.x.x` |
| Docs portal | `https://192.168.x.x:8443` |
| Proxmox GUI | `https://192.168.x.x:8006` |
| NAS SMB share | `\\192.168.x.x\share` |
| Public mirror (sanitized) | `https://github.com/Verkis-EDS/Verkis-reference` |

Legacy aliases (do not propagate): `/mnt/verkis-nas`, `Verkis-Lab`. If they appear in docs, point them at the canonical path; do not maintain parallel trees.

## Fallback when this file is unreachable

If `/mnt/nas/Verkis-Proxmox-Dev/_common/` is not mounted or returns errors, the operating standard is mirrored publicly at **https://github.com/Verkis-EDS/Verkis-reference** (sanitized — operating standard, runbook templates, agent/skill catalog only; no inventories, IPs, secrets, or per-guest audits). Start with `START_HERE.md`, then `RULES.md`, then `PLANNING_MODE.md`. The `~/bin/verkis-common` dispatcher detects NAS-down and prints this URL with quick troubleshooting commands.

## Mandatory session opening

Every non-trivial session starts by:

1. Running `~/bin/verkis-common banner` (or equivalent) — see [PLANNING_MODE.md](PLANNING_MODE.md) and [SETUP_STATUS_CHECK.md](SETUP_STATUS_CHECK.md). If NAS is unreachable, the dispatcher prints the public-mirror fallback URL.
2. Reading **this file**, then [PLANNING_MODE.md](PLANNING_MODE.md), then [CONTEXT_DISCIPLINE.md](CONTEXT_DISCIPLINE.md), then the active project's `PROJECT_MEMORY.md` if any.
3. **Checking and mapping the current workspace and relevant data** — CWD, the active project repo and its `CLAUDE.md`, current auto-memory, the latest `audits/` and `inventory/`, and live infrastructure state (`qm list` / `pct list`, storage, network) — observed, never recalled. This is the "current-state" leg of the loop; see [SETUP_STATUS_CHECK.md](SETUP_STATUS_CHECK.md) and "Current-state first" below.
4. Stating objective, assumptions, current known infrastructure, missing information, proposed first actions, risk level, approval points, acceptance criteria, verification method, rollback approach — before any write action.

## Mandatory session closing

Every non-trivial session ends by:

1. Saving validated lessons in the appropriate project record. Update provider-owned memory only when the user explicitly requests it and the provider permits the update. Surprising facts, validated approaches, corrections worth not repeating → auto-memory per [MEMORY_POLICY.md](memory/MEMORY_POLICY.md).
2. Invoking `/bye` (Claude slash command) at end of session. It consolidates the summary, finalizes memory updates, and runs `~/bin/verkis-common bye <slug> "<summary>"` which writes a local closeout under `~/.claude/projects/-root/sessions/` (always) and appends to the NAS session log (best-effort). Manual fallback: `verkis-common session-close <slug> "<summary>"`.
3. Stopping any background watchers/tasks you started; not leaking processes between sessions.

## Authority and authorization

GitLab Common Ops owns shared policy; the manuals repository owns operational guides and its canonical `docs/proxmox-lab/access-table.md` owns IP allocation. The NAS and portal are deployed views, not competing authoring sources. Project instructions provide short entrypoints and local verification commands.

An explicit user authorization persists for the agreed scope; do not ask repeatedly for the same action. Record concrete recovery and access prerequisites, then proceed when they pass. If scope changes materially, clarify the new action. Higher-priority runtime constraints still apply. No instruction file can grant unavailable tools or override sandbox boundaries.

## Git discovery and updates

At session start, after each meaningful slice and at handoff, inspect every affected approved repository: actual root/worktrees, sanitized remote, branch/base commit, status/diffs, recent history, tracked paths, README/agent rules, CI, relevant issues/MRs and current handoff. Start from lab/NAS standards and the task; do not scan unrelated networks or clone every accessible project. Never print credential-bearing remote URLs.

Reuse canonical shared source and record ownership, allowed paths and reuse decisions in the task's `spec/repository-map.csv`. Record cross-repository revisions and linked MRs in its release manifest. The manuals own the detailed Git discovery and updates guide (internal service; use the private workspace guide); existing task records stay in their owning repository.

Preserve unrelated dirty work. After confirming the authorized remote/base, fetch explicitly and create or reuse the task's dedicated worktree. Do not automatically reset, clean, stash, rebase or switch another writer's branch. Synchronize affected implementation, contracts/inputs, tests, reusable assets, MkDocs and `handoff/STATUS.md` after each meaningful slice. Change the canonical shared library and record consumer versions rather than silently forking it.

Run relevant project checks and the actual manuals strict build with its locked dependencies when affected. Use the approved content secret scanner and inspect exports/nested archives; ignore rules do not protect tracked secrets. Stage explicit paths/hunks including intended deletions, then review cached whitespace, stat and full diff. Never use `git add -A` in a shared workspace. Commit coherent changes; push/open an MR within existing authorization. Protected-default pushes, force pushes, merges and deployment require their applicable authority; do not infer deployment from code review.

At handoff record repository, branch, exact commit, pushed status, MR, changed paths, tests, remaining blockers and next owner. Failed remote access leaves reviewed local commits intact and explicitly unsynchronized. Do not claim a repository update or deployment without evidence.

Git worktrees isolate files; they are not Gateway write locks. All Designer, CLI and API writers must use the established shared Gateway lock/controller. A GitLab `resource_group` serializes jobs within its project, not every independent repository or workstation. Discover the actual locking mechanism before writing; do not invent a lock or treat `git worktree lock` as one.

## Non-negotiable rules

- **Current-state first.** No design or evaluation until current state is observed. Sequence is fixed: `current-state → gap → plan → execute → verify → document`.
- **Plan first.** Skip planning only for trivial, reversible, low-risk tasks. Otherwise produce a written plan.
- **Planning Mode first.** Every session opens in [Planning Mode](PLANNING_MODE.md) and stays there until the current-state check is done; leave it only for trivial, reversible, low-risk actions.
- **Task breakdown + tag.** Before non-trivial work, assign exactly one primary project label — the context-bleed boundary, see [CONTEXT_DISCIPLINE.md](CONTEXT_DISCIPLINE.md) — and decompose into a WBS, selecting process weight via the Workflow Depth Ladder (TASK_INGESTION_PROTOCOL.md (internal reference; omitted from this mirror) §0.5.21).
- **No destructive actions without explicit approval.** Includes `rm -rf`, VM/LXC/disk delete, firewall changes, public exposure, secret rotation, downgrading packages, key rotation, force-push.
- **No services on the Proxmox host.** Run in a Proxmox LXC, VM, or Docker container inside an approved VM.
- **No plaintext secrets in shared artifacts.** Never in Git, Markdown, logs, screenshots, NAS plaintext, or chat. Use `.env.local` (gitignored) or GitLab CI variables only.
- **Trust observed reality over recalled memory.** Memory may be stale — verify before recommending.
- **Reuse over create.** Do not create a new agent, skill, script, or memory entry unless the [Artifact Creation Gate](governance/ARTIFACT_CREATION_GATE.md) passes.
- **Build reusable tooling deliberately.** When a check, fix, or audit is performed more than twice — or any time a recurring reliability or performance gap is identified — convert it into a script or `verkis-common` subcommand rather than repeating ad-hoc commands. New tooling must pass the [Artifact Creation Gate](governance/ARTIFACT_CREATION_GATE.md) and extend the existing dispatcher (`~/bin/verkis-common`) or the project-local `scripts/` directory; do not create parallel CLIs, wrappers, or shadow copies. Host-touching scripts live under `/root/proxmox-manager/scripts/` and stay read-only by default; cross-project standards and dispatcher subcommands live under `/mnt/nas/Verkis-Proxmox-Dev/_common/scripts/`. Every new script must carry a header documenting (a) the recurring need it serves, (b) why an existing tool could not be extended, and (c) whether it is read-only or requires approval gates. Retire or fold scripts back into the dispatcher when their need disappears — proliferation is the failure mode this rule prevents.
- **Reversible default.** Prefer changes that can be undone with one command. Document the rollback alongside the change.

## Branding

- Site name: **Verkís Lab Manuals**
- Copyright line: `Copyright © Verkís internal documentation`
- Brand palette: red `#E81830`, grey `#485860` (manuals repository: `docs/assets/stylesheets/extra.css`)
- Logos: `assets/logo/verkis-{horizontal,symbol,stacked}.svg` (deployed from the manuals repository)

Inherit the existing theme. Do not introduce alternative branding.

## Where to find things

- **Master runbook (v4.0):** [`RUNBOOK_MASTER_v4.md`](RUNBOOK_MASTER_v4.md) — full canonical source
- **Task ingestion protocol:** `TASK_INGESTION_PROTOCOL.md` (internal reference; omitted from this mirror) — read before any non-trivial task intake
- **Memory policy:** [`memory/MEMORY_POLICY.md`](memory/MEMORY_POLICY.md)
- **Context discipline:** [`CONTEXT_DISCIPLINE.md`](CONTEXT_DISCIPLINE.md)
- **Gates:** [`governance/ARTIFACT_CREATION_GATE.md`](governance/ARTIFACT_CREATION_GATE.md) · [`governance/MEMORY_CREATION_GATE.md`](governance/MEMORY_CREATION_GATE.md)
- **Design standards:** `DESIGN_WORKFLOW_STANDARD.md` (internal reference; omitted from this mirror) (front-end & HMI design workflow, Ignition-first) · `DASHBOARD_HMI_DATA_PACK.md` (internal reference; omitted from this mirror) (platform/component/data catalogs + scorecard)
- **Audit script:** `scripts/proxmox_readonly_audit.sh` (internal reference; omitted from this mirror)
- **Banner:** `scripts/context_banner.sh` (internal reference; omitted from this mirror)
- **Cleanup dry-run:** `scripts/cleanup_dryrun.sh` (internal reference; omitted from this mirror)

## Cost and model policy

Use the task and risk routes in [MODEL_ROUTING_POLICY.md](MODEL_ROUTING_POLICY.md). Select models actually available in the active runtime, use bounded context, and reserve the strongest review for security, infrastructure, destructive actions and final acceptance. Report unavailable token/cost measurements as `unknown`.

## Review cadence

- Memory: monthly via `~/bin/verkis-common stale-review`
- This file: quarterly, or whenever a non-negotiable rule changes

## Automation boundaries

Daily health and weekly cleanup review write private local reports only. They do not commit, push, deploy, notify people, delete backups or archive memory. Apply cache cleanup explicitly. Backup retention is performed only by the verified host-local workflow; the Common Ops backup-health command reads its catalog. Documentation is published from the protected manuals CI artifact with a recorded source revision and rollback release.
