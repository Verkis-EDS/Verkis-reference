# Verkís Proxmox Development Lab — Operating Rules

> Copyright © Verkís internal documentation. Canonical source. Edit via merge request; never overwrite on the NAS without committing.

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
| NAS SMB share | `//192.168.x.x/share` |
| Public mirror (sanitized) | `https://github.com/Verkis-EDS/Verkis-reference` |

Legacy aliases (do not propagate): `/mnt/verkis-nas`, `Verkis-Lab`. If they appear in docs, point them at the canonical path; do not maintain parallel trees.

## Fallback when this file is unreachable

If `/mnt/nas/Verkis-Proxmox-Dev/_common/` is not mounted or returns errors, the operating standard is mirrored publicly at **https://github.com/Verkis-EDS/Verkis-reference** (sanitized — operating standard, runbook templates, agent/skill catalog only; no inventories, IPs, secrets, or per-guest audits). Start with `START_HERE.md`, then `RULES.md`, then `PLANNING_MODE.md`. The `~/bin/verkis-common` dispatcher detects NAS-down and prints this URL with quick troubleshooting commands.

## Mandatory session opening

Every non-trivial session starts by:

1. Running `~/bin/verkis-common banner` (or equivalent) — see [PLANNING_MODE.md](PLANNING_MODE.md) and [SETUP_STATUS_CHECK.md](SETUP_STATUS_CHECK.md). If NAS is unreachable, the dispatcher prints the public-mirror fallback URL.
2. Reading **this file**, then [PLANNING_MODE.md](PLANNING_MODE.md), then [CONTEXT_DISCIPLINE.md](CONTEXT_DISCIPLINE.md), then the active project's `PROJECT_MEMORY.md` if any.
3. Stating objective, assumptions, current known infrastructure, missing information, proposed first actions, risk level, approval points, acceptance criteria, verification method, rollback approach — before any write action.

## Mandatory session closing

Every non-trivial session ends by:

1. Saving lessons + memory updates as they happen during the session (not only at the end). Surprising facts, validated approaches, corrections worth not repeating → auto-memory per [MEMORY_POLICY.md](memory/MEMORY_POLICY.md).
2. Invoking `/bye` (Claude slash command) at end of session. It consolidates the summary, finalizes memory updates, and runs `~/bin/verkis-common bye <slug> "<summary>"` which writes a local closeout under `~/.claude/projects/-root/sessions/` (always) and appends to the NAS session log (best-effort). Manual fallback: `verkis-common session-close <slug> "<summary>"`.
3. Stopping any background watchers/tasks you started; not leaking processes between sessions.

## Non-negotiable rules

- **Current-state first.** No design or evaluation until current state is observed. Sequence is fixed: `current-state → gap → plan → execute → verify → document`.
- **Plan first.** Skip planning only for trivial, reversible, low-risk tasks. Otherwise produce a written plan.
- **No destructive actions without explicit approval.** Includes `rm -rf`, VM/LXC/disk delete, firewall changes, public exposure, secret rotation, downgrading packages, key rotation, force-push.
- **No services on the Proxmox host.** Run in a Proxmox LXC, VM, or Docker container inside an approved VM.
- **No plaintext secrets.** Never in Git, Markdown, logs, screenshots, NAS plaintext, or chat. Use `.env.local` (gitignored) or GitLab CI variables only.
- **Trust observed reality over recalled memory.** Memory may be stale — verify before recommending.
- **Reuse over create.** Do not create a new agent, skill, script, or memory entry unless the [Artifact Creation Gate](governance/ARTIFACT_CREATION_GATE.md) passes.
- **Reversible default.** Prefer changes that can be undone with one command. Document the rollback alongside the change.

## Branding

- Site name: **Verkís Lab Manuals**
- Copyright line: `Copyright © Verkís internal documentation`
- Brand palette: red `#E81830`, grey `#485860` (already in `lab-manuals/docs/assets/stylesheets/extra.css`)
- Logos: `assets/logo/verkis-{horizontal,symbol,stacked}.svg` (already deployed)

Inherit the existing theme. Do not introduce alternative branding.

## Where to find things

- **Master runbook (v4.0):** [`RUNBOOK_MASTER_v4.md`](RUNBOOK_MASTER_v4.md) — full canonical source
- **Memory policy:** [`memory/MEMORY_POLICY.md`](memory/MEMORY_POLICY.md)
- **Context discipline:** [`CONTEXT_DISCIPLINE.md`](CONTEXT_DISCIPLINE.md)
- **Gates:** [`governance/ARTIFACT_CREATION_GATE.md`](governance/ARTIFACT_CREATION_GATE.md) · [`governance/MEMORY_CREATION_GATE.md`](governance/MEMORY_CREATION_GATE.md)
- **Audit script:** [`scripts/proxmox_readonly_audit.sh`](scripts/proxmox_readonly_audit.sh)
- **Banner:** [`scripts/context_banner.sh`](scripts/context_banner.sh)
- **Cleanup dry-run:** [`scripts/cleanup_dryrun.sh`](scripts/cleanup_dryrun.sh)

## Cost and model policy

Default to `opusplan` (Opus for planning + Sonnet for execution). Use Haiku only for read-only, low-risk, low-stakes work. Use Opus/`opusplan` for security, infrastructure, destructive actions, and final review. Token/cost reporting is informational only — never let cost pressure drive an unsafe model downgrade for planning, security, infrastructure, or final review.

## Review cadence

- Memory: monthly via `~/bin/verkis-common stale-review`
- This file: quarterly, or whenever a non-negotiable rule changes
