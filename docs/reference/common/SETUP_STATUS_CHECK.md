# Setup Status Check

> Copyright © Verkís internal documentation.

Mandatory current-state check that opens every non-trivial session. Implements `RUNBOOK_MASTER_v4.md` §1 (session opening) and §5 (verification gate). Observed state only — never recalled state. See [RULES.md](RULES.md) "Current-state first".

## Mandatory opening statement

Paste this verbatim at the top of the first agent reply of the session, filled in:

```text
Session opening — Verkís Proxmox Development Lab
Host: 3HS
Active project: <name or "none — _common only">
Context level: <0–4, default 1–2; see CONTEXT_DISCIPLINE.md>
Memory loaded: <list of files actually read>
Model route: <opusplan|opus|sonnet|haiku>  Reason: <one phrase>
Risk class: <low|medium|high|destructive>
Planning Mode: <on|off — see PLANNING_MODE.md for when it is mandatory>
```

If any field is unknown, write `unknown` — never invent. See [CONTEXT_DISCIPLINE.md](CONTEXT_DISCIPLINE.md) "Token/cost reporting" for the same rule applied to token data.

## Automated runner

```bash
~/bin/verkis-common banner
```

The banner script prints host, NAS mount status, active Git branch (if CWD is a repo), MkDocs build state, and the memory files it would load. Treat its output as the canonical answer; do not paraphrase from recall.

## Local status block

Run from `3HS`:

```bash
# Host + NAS
hostnamectl | sed -n '1,3p'
mountpoint -q /mnt/nas && echo "NAS: mounted" || echo "NAS: NOT MOUNTED"
ls -d /mnt/nas/Verkis-Proxmox-Dev/_common >/dev/null && echo "_common: reachable"

# Working directory + Git
pwd
git -C "$(pwd)" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "not a git repo"
git -C "$(pwd)" status --short 2>/dev/null | head -20
```

## Git status block

Run from the active repository (commonly `/root/proxmox-manager`):

```bash
git status --short
git log --oneline -5
git remote -v | head -2
```

GitLab endpoint: `https://192.168.x.x`. If the remote does not resolve, stop and surface the failure — do not retry blindly.

## MkDocs status block

Run from `lab-manuals/`:

```bash
test -f mkdocs.yml && echo "mkdocs.yml: present" || echo "mkdocs.yml: MISSING"
.venv/bin/mkdocs --version 2>/dev/null || echo "mkdocs venv: not initialised"
ls -1 site/ 2>/dev/null | head -3 || echo "site/ not built yet"
```

Published portal: `https://192.168.x.x:8443`. Do not assume the live portal reflects local `site/` — verify with `curl -kIs https://192.168.x.x:8443/ | head -1`.

## Proxmox status block (read-only)

```bash
ssh -o BatchMode=yes 3HS pveversion -v 2>/dev/null | head -1 \
  || echo "pveversion: unreachable from this CWD/user"
```

Proxmox GUI: `https://192.168.x.x:8006`. Never run mutating `pve*` commands from the opening check — observation only.

## Failure handling

If any block reports a failure (NAS not mounted, Git remote unreachable, MkDocs venv missing) the session enters Planning Mode regardless of the requested task. See [PLANNING_MODE.md](PLANNING_MODE.md) and [REDTEAM_REVIEW.md](REDTEAM_REVIEW.md) failure-mode lens.

## Where this links

- Master runbook: [`RUNBOOK_MASTER_v4.md`](RUNBOOK_MASTER_v4.md) §1, §5
- Closeout counterpart: [`SESSION_CLOSEOUT.md`](SESSION_CLOSEOUT.md)
- Drift controls: [`memory/CONTEXT_DRIFT_CONTROL.md`](memory/CONTEXT_DRIFT_CONTROL.md) rules 1–3
