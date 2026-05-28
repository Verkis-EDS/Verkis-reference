# Verkís Proxmox Development Lab — Master Runbook (v4.0)
> Copyright © Verkís internal documentation. Distilled from canonical user-pasted v4.0 source 2026-05-28.

This is the operating manual for the Verkís Proxmox Development Lab on host `3HS`. It binds together
the NAS common layer (`/mnt/nas/Verkis-Proxmox-Dev/_common`), the GitLab source-of-truth, the MkDocs
documentation portal, and the Claude Code executor. Every operator and every agent session starts
here. The structure follows the canonical v4.0 section numbering (§0 – §30) so that any earlier
runbook or session log can be cross-referenced section-by-section.

---

## §0 — Core operating rule

**Always work in this order:** current-state → gap → plan → execute → verify → document.

Before any change, establish the *current* state of the relevant component from first-hand evidence
(read the file, run the read-only command, query the API). Compare that to the *desired* state and
articulate the gap. Then write a short plan, execute the smallest reversible step, verify the result
with a second command, and document what happened. No step may be skipped; if a step is impossible,
say so explicitly and stop.

| Phase | Output |
|---|---|
| Current state | Concrete facts (paths, versions, IPs, exit codes) |
| Gap | One-sentence statement of what differs from desired |
| Plan | Numbered list of reversible steps + rollback note |
| Execute | Run the steps; capture stdout/stderr |
| Verify | Second-source check (different command, API, or log) |
| Document | Session log + relevant artifact updates |

---

## §1 — Identity and scope

### §1.1 Opening statement (paste at every session start, verbatim)

> I am operating the Verkís Proxmox Development Lab as a cautious infrastructure agent on host `3HS`.
> The NAS common layer at `/mnt/nas/Verkis-Proxmox-Dev/_common` is shared state; GitLab at
> `https://192.168.x.x` is the source of truth; the docs portal at `https://192.168.x.x:8443`
> is the read interface; Proxmox at `https://192.168.x.x:8006` is the runtime. I will follow the
> current-state → gap → plan → execute → verify → document sequence for every change, gate
> destructive actions on explicit approval, and close out every session with a written summary.

---

## §2 — Session banner

Render at the top of every session log via `~/bin/verkis-common banner`. Fields left `unknown`
when an upstream value is unavailable — never fabricate.

| Field | Value |
|---|---|
| Date (UTC) | `<YYYY-MM-DD HH:MM>` |
| Host | `3HS` |
| Operator | `<name>` |
| Agent | `Claude Code <model-id>` |
| Project | `<slug>` |
| Branch | `<git-branch>` |
| GitLab | `https://192.168.x.x` |
| Docs | `https://192.168.x.x:8443` |
| Proxmox | `https://192.168.x.x:8006` |
| NAS SMB | `//192.168.x.x/share` |
| NAS common | `/mnt/nas/Verkis-Proxmox-Dev/_common` |
| Tokens (in/out) | `<n / m>` or `unknown` |
| USD cost | `$<x.xx>` or `unknown` |
| Session ID | `<uuid>` |

### §2.1 Token / USD rule

If the harness does not expose token counts or per-session USD cost, render the field literally as
`unknown`. Do not estimate, do not back-fill, do not drop the row. The presence of `unknown` is a
signal that an instrumentation gap exists; it gets logged into `IMPROVEMENTS.md`.

---

## §3 — Canonical names and aliases

Use the **canonical name** in commits, runbooks, and dashboards. Aliases are accepted in
free-form chat but must be normalised on write.

| Canonical | Accepted aliases |
|---|---|
| `3HS` | `host`, `pve`, `proxmox-host`, `the host` |
| `gitlab01` | `gitlab`, `git`, `gl01` |
| `gitlab-runner01` | `runner`, `runner01`, `ci-runner` |
| `openproject01` | `op`, `openproject`, `op01` |
| `ignition-dev01` | `ignition`, `ign01`, `gateway` |
| `wg01` | `wireguard`, `vpn`, `wg-easy` |
| `proxy01` | `proxy`, `nginx`, `reverse-proxy` |
| `nettools01` | `nettools`, `netdiag` |
| `nas01` | `samba`, `share` |
| `dns01` | `dns`, `dnsmasq` |
| `verkis.internal` | `internal`, `lan domain` |

---

## §4 — Endpoint reference

### §4.1 Front doors

| Service | Endpoint | Notes |
|---|---|---|
| GitLab | `https://192.168.x.x` | self-signed; via proxy01 |
| Docs portal | `https://192.168.x.x:8443` | MkDocs Material; source `verkis-lab/lab-manuals` |
| Proxmox UI | `https://192.168.x.x:8006` | host `3HS` |
| wg-easy UI | `http://192.168.x.x:51821` | VPN admin |
| NAS SMB | `//192.168.x.x/share` | guest mount, CIFS |

### §4.2 Lab guests

| ID | Name | IP | Type | Role |
|----|------|----|------|------|
| 101 | gitlab01 | .171 | VM | GitLab CE |
| 102 | gitlab-runner01 | .172 | VM | CI runner |
| 103 | openproject01 | .173 | VM | OpenProject |
| 104 | ignition-dev01 | .174 | VM | Ignition Gateway |
| 105 | wg01 | .175 | VM | WireGuard |
| 201 | proxy01 | .181 | LXC | nginx + TLS |
| 202 | nettools01 | .182 | LXC | net diag |
| 205 | nas01 | .200 | LXC | Samba |
| 206 | dns01 | .185 | LXC | dnsmasq |

---

## §5 — Current setup check (read-only command pack)

Run these verbatim at session start to capture current state. None of these mutate.

```bash
# Host facts
hostnamectl
pveversion -v
uptime
df -hT
lvs -o lv_name,vg_name,data_percent,metadata_percent

# Guests
qm list
pct list
qm status 101 102 103 104 105 2>/dev/null
pct status 201 202 205 206 2>/dev/null

# Network
ip -br addr
ip -br route
brctl show 2>/dev/null || bridge link

# DNS reachability
dig +short @192.168.x.x gitlab.verkis.internal
dig +short @192.168.x.x docs.verkis.internal

# NAS
mount | grep -E 'nas|cifs'
ls /mnt/nas/Verkis-Proxmox-Dev/_common | head -20

# GitLab + docs front door (no auth, accept self-signed)
curl -ksI https://192.168.x.x | head -5
curl -ksI https://192.168.x.x:8443 | head -5
```

---

## §6 — Proxmox read-only audit

The detailed read-only audit lives at `scripts/proxmox_readonly_audit.sh`. It captures versions,
storage, guests, networking, firewall, replication, jobs, and certificate expiry into a
timestamped folder under `audits/`. Run it before any change window and diff against the
previous snapshot.

```
/mnt/nas/Verkis-Proxmox-Dev/_common/scripts/proxmox_readonly_audit.sh
```

---

## §7 — Gap scoring

After current-state capture, score each observed gap so prioritisation is explicit.

| Score | Meaning | Action window |
|---|---|---|
| 5 | Production outage / data-loss risk | immediate |
| 4 | Imminent risk; degraded service | < 24 h |
| 3 | Standard improvement; planned | < 7 d |
| 2 | Hygiene / consistency | next milestone |
| 1 | Cosmetic / nice-to-have | backlog |

Each gap row: `id | area | observed | desired | score | owner | next step`.

---

## §8 — Execution plan template

```
Plan: <one-line objective>
Preconditions: <what must already be true>
Approval: <who signed off; for destructive ops only>
Steps:
  1. <reversible action> — rollback: <how>
  2. <reversible action> — rollback: <how>
  3. <verification command>
Risks: <enumerated>
Done when: <observable criterion>
```

---

## §9 — Canonical NAS structure

```
/mnt/nas/Verkis-Proxmox-Dev/
├── _common/
│   ├── RUNBOOK_MASTER_v4.md
│   ├── AGENT_OPERATING_STANDARD.md
│   ├── CONTEXT_DISCIPLINE.md
│   ├── MODEL_ROUTING_POLICY.md
│   ├── PLANNING_MODE.md
│   ├── RULES.md
│   ├── SETUP_STATUS_CHECK.md
│   ├── agents/
│   ├── audit/
│   ├── config/
│   ├── governance/
│   │   └── ARTIFACT_CREATION_GATE.md
│   ├── memory/
│   ├── mkdocs/
│   ├── resources/
│   ├── scripts/
│   │   ├── proxmox_readonly_audit.sh
│   │   └── workspace_audit.sh
│   ├── skills/
│   └── templates/
│       ├── runbooks/
│       ├── session/
│       ├── project/
│       └── prompts/
└── projects/
    └── <project-slug>/
```

---

## §10 — NAS install (one-time)

NAS is exported as SMB from `nas01` at `//192.168.x.x/share`. On host `3HS` and every lab VM
the share is mounted at `/mnt/nas` via `/etc/fstab`. Required packages on Debian/Ubuntu guests:
`cifs-utils`, `keyutils`, `linux-modules-extra-$(uname -r)`. The Verkís tree lives under
`/mnt/nas/Verkis-Proxmox-Dev/`; the `_common/` directory is read-mostly and only updated through
GitLab CI from `verkis-lab/proxmox-common-ops`. Never edit `_common/` files manually in production
— stage edits in the GitLab repo, let CI publish.

---

## §11 — GitLab common-ops repo

Repo: `verkis-lab/proxmox-common-ops` on `https://192.168.x.x`.

- `main` is protected; merge via MR.
- CI pipeline lints markdown, renders MkDocs, and `rsync`s `_common/` to `nas01:/srv/share/Verkis-Proxmox-Dev/_common/` on tag `v*`.
- Tags follow `vMAJOR.MINOR` (e.g. `v4.0`); each tag corresponds to a master runbook revision.
- Issues are tracked against the `lab/common-ops` board.

---

## §12 — Claude Code startup

Single command to begin a session on host `3HS`:

```bash
cd /root/proxmox-manager && claude
```

Claude is launched with project `CLAUDE.md` plus the NAS `_common/` policies auto-loaded via the
project hook. The opening statement (§1.1) is pasted as the first message.

---

## §13 — Master startup prompt (paste verbatim)

> You are joining a Verkís Proxmox Development Lab session on host `3HS`. The NAS common layer is
> at `/mnt/nas/Verkis-Proxmox-Dev/_common`. Source of truth is GitLab at `https://192.168.x.x`;
> docs portal is `https://192.168.x.x:8443`; Proxmox UI is `https://192.168.x.x:8006`.
>
> Before anything else: (1) render the session banner from §2 of `RUNBOOK_MASTER_v4.md` with all
> fields populated or marked `unknown`; (2) run the §5 read-only setup check and paste the output
> into the session log; (3) state today's objective in one sentence; (4) produce a §8 execution
> plan with rollback notes and wait for approval before any mutating step.
>
> Follow the §0 sequence at every step. Never overwrite secrets, never run destructive disk or
> network operations without explicit approval, never commit `.env` or token files. Close out the
> session with the §25 closeout summary written to the session log.

---

## §14 — Context discipline

Detailed in `_common/CONTEXT_DISCIPLINE.md`. Key rules: load only the policies relevant to the
current task, prefer reading a specific file over a full directory dump, summarise long files into
the session log before referencing them later, and discard stale context at section boundaries.

---

## §15 — Artifact creation gate

Detailed in `_common/governance/ARTIFACT_CREATION_GATE.md`. New files require: a named owner, a
clear purpose, a home in the canonical NAS structure (§9), and a removal trigger. Drive-by files
are rejected at review.

---

## §16 — Standard project structure

```
projects/<slug>/
├── README.md
├── PROJECT_MEMORY.md
├── DECISIONS.md
├── OPEN_POINTS.md
├── LESSONS_LEARNED.md
├── IMPROVEMENTS.md
├── TOOL_REGISTRY.md
├── RUNBOOK.md
├── CHANGELOG.md
├── .gitignore
├── .env.example
├── mkdocs.yml
├── docs/
├── src/
└── tests/
```

Each top-level markdown file has a Verkís template in `_common/templates/project/`.

---

## §17 — Default `.gitignore` (verbatim)

```
# Verkís Proxmox Development Lab — default ignore (v4.0)
.env
.env.*
!.env.example
*.key
*.pem
*.crt
secrets/
.secrets/
__pycache__/
*.pyc
.venv/
venv/
node_modules/
dist/
build/
.cache/
.pytest_cache/
.coverage
htmlcov/
site/
.DS_Store
Thumbs.db
*.log
*.swp
*.swo
.idea/
.vscode/
```

---

## §18 — MkDocs setup

Each project ships an `mkdocs.yml` with the Verkís Material theme and a fixed top-level nav.
The portal at `https://192.168.x.x:8443` serves the merged set built from
`verkis-lab/lab-manuals`. Project-local builds use:

```bash
python -m venv .venv && . .venv/bin/activate
pip install mkdocs mkdocs-material
mkdocs serve -a 0.0.0.0:8000
```

Required nav sections: Home, Setup, Architecture, Operations, Troubleshooting, Decisions, Changelog.

---

## §19 — GitLab project register

The canonical list of projects, owners, repo URLs, and status lives in `_common/resources/`
as `gitlab-project-register.md` and is mirrored to the docs portal. New projects are added by MR
to the register before any code is pushed.

---

## §20 — Workspace audit

`_common/scripts/workspace_audit.sh` walks `/mnt/nas/Verkis-Proxmox-Dev/projects/`, checks each
project for the §16 file set, validates `.env.example` presence, lints `mkdocs.yml`, and prints a
report. Run weekly; archive output under `_common/audit/<date>-workspace.md`.

---

## §21 — Cleanup procedure

Before declaring a session closed:

1. Delete scratch files under `/tmp/` and `~/scratch/`.
2. `git status` clean or every untracked file justified in the session log.
3. No new files outside §9 canonical layout.
4. Secrets scan: `git grep -nE '(BEGIN .* PRIVATE KEY|glpat-|glrt-|sk-[A-Za-z0-9]{20,})'`.
5. NAS `_common/` unchanged unless a GitLab MR was merged.

---

## §22 — Standard workflow

```
1. Pull latest _common from NAS (read-only sync).
2. Render session banner (§2) into session log.
3. Run §5 setup check; paste output.
4. State objective.
5. Capture current state of the touched component.
6. Score gaps (§7).
7. Write execution plan (§8); request approval if destructive.
8. Execute step-by-step; verify each step.
9. Update project DECISIONS / OPEN_POINTS / IMPROVEMENTS.
10. Run §21 cleanup.
11. Write §25 closeout.
```

---

## §23 — Red-team checklist

Detailed in `_common/REDTEAM_REVIEW.md`. Pre-merge questions: what breaks if this fails halfway,
what credentials are exposed, what is the blast radius, who else holds a lock, is rollback
tested, is the monitoring updated.

---

## §24 — Verification checklist

| Check | Command / Evidence |
|---|---|
| Service responds | `curl -ksI <endpoint>` |
| Config syntax valid | `<tool> -t` or equivalent |
| Logs clean | `journalctl -u <unit> -p err -n 50` |
| Resource OK | `lvs`, `df -h`, `free -h` |
| Second-source agrees | API call / second host / external probe |
| Documented | session log + project file updated |

---

## §25 — Session closeout

Detailed in `_common/SESSION_CLOSEOUT.md`. The closeout block is appended to every session log.

```
## Task Closeout Summary
- Objective: <one line>
- Outcome: <done | partial | blocked>
- Changes (files): <list>
- Commands run: <count, link to log>
- Decisions: <link to DECISIONS.md rows>
- Lessons: <link to LESSONS_LEARNED.md rows>
- Improvements: <link to IMPROVEMENTS.md rows>
- Open points: <link to OPEN_POINTS.md rows>
- Verification: <evidence>
- Risks / followups: <list>
- Next session start with: <pointer>
```

---

## §26 — Recommended first implementation order

| Step | Item | Why first |
|---|---|---|
| 1 | Off-host backup target (PBS or rsync to NAS) | unblocks "evaluation-only" gate |
| 2 | NAS `_common/` GitLab sync pipeline | makes policies authoritative |
| 3 | MkDocs portal CI build | makes docs visible LAN-wide |
| 4 | Read-only audit cron | drift detection baseline |
| 5 | Project register + template enforcement | structural consistency |
| 6 | Firewall baseline (default-deny) | hardening before any external exposure |
| 7 | Per-user SSH + central key registry | replace shared `root` keys |
| 8 | Monitoring (Prometheus + node_exporter) | observability before scale-up |

---

## §27 — Recommended fixes (carried from v3 review)

| Area | Fix | Priority |
|---|---|---|
| Backups | Stand up PBS on external host | 5 |
| DNS | Add monitoring + secondary nameserver | 4 |
| SSH | Move from shared root keys to per-user | 4 |
| Firewall | Enable Proxmox firewall, default-deny | 4 |
| GitLab | Rotate self-signed cert; document fingerprint | 3 |
| Storage | Monitor `data_percent` on usb-lvm | 3 |
| Docs | Move stray runbooks into NAS templates | 2 |
| Inventory | Auto-render from `qm/pct list` daily | 2 |

---

## §28 — Final operating decision

- **GitLab** at `https://192.168.x.x` is the **source of truth**. All policy and code changes
  land there via MR.
- **NAS** at `/mnt/nas/Verkis-Proxmox-Dev/` is the **runtime distribution surface**. It is
  read-mostly; updates flow from GitLab CI.
- **MkDocs portal** at `https://192.168.x.x:8443` is the **read interface**. Operators and
  agents browse it; they do not write to it.
- **Proxmox** at `https://192.168.x.x:8006` is the **runtime**. State changes happen here under
  the §0 sequence.
- **Claude Code** is the **executor**. It plans and acts under approval gates; it does not own any
  of the four surfaces above.

---

## §29 — One-command session start (paste verbatim)

> Start a Verkís Proxmox Dev Lab session on `3HS`. (1) Render banner from §2 with `unknown` for any
> missing field. (2) Run §5 setup checks; paste output. (3) State today's objective. (4) Produce a
> §8 plan with rollback. (5) Wait for approval on destructive steps. (6) Execute under §0
> discipline. (7) Update project artifacts. (8) Run §21 cleanup. (9) Write §25 closeout.
> Source-of-truth: GitLab `https://192.168.x.x`. Read interface: `https://192.168.x.x:8443`.
> NAS common: `/mnt/nas/Verkis-Proxmox-Dev/_common`. Proxmox: `https://192.168.x.x:8006`.

---

## §30 — Quick command pack

```bash
# Open the master runbook
less /mnt/nas/Verkis-Proxmox-Dev/_common/RUNBOOK_MASTER_v4.md

# Render session banner
~/bin/verkis-common banner

# Read-only Proxmox audit
/mnt/nas/Verkis-Proxmox-Dev/_common/scripts/proxmox_readonly_audit.sh

# Workspace audit
/mnt/nas/Verkis-Proxmox-Dev/_common/scripts/workspace_audit.sh

# DNS sanity
dig +short @192.168.x.x gitlab.verkis.internal
dig +short @192.168.x.x docs.verkis.internal

# GitLab + docs front door
curl -ksI https://192.168.x.x | head -5
curl -ksI https://192.168.x.x:8443 | head -5

# Proxmox guest inventory
qm list ; pct list

# NAS common visibility
ls /mnt/nas/Verkis-Proxmox-Dev/_common
ls /mnt/nas/Verkis-Proxmox-Dev/_common/templates

# Storage capacity
lvs -o lv_name,vg_name,data_percent,metadata_percent

# Secrets scan in working tree
git grep -nE '(BEGIN .* PRIVATE KEY|glpat-|glrt-|sk-[A-Za-z0-9]{20,})' || echo "clean"
```
