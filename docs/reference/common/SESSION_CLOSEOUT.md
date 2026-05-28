# Session Closeout

> Copyright © Verkís internal documentation.

Every non-trivial session ends with a written closeout. No closeout = the session is still open and the next session starts in the wrong context. Implements `RUNBOOK_MASTER_v4.md` closeout section.

## Automated runner

```bash
~/bin/verkis-common session-close
```

Generates the closeout template populated from the session banner, Git state, NAS sync state, and any memory deltas. Edit, do not skip.

## Required sections

A closeout is incomplete unless every section below is present and filled in. `none` is a valid value; missing is not.

### 1. Objective

One sentence — the same objective stated in the opening plan (see [PLANNING_MODE.md](PLANNING_MODE.md)). If it changed mid-session, record both and the reason.

### 2. Work completed

Bulleted, factual, past tense. Each bullet names the file, container, or service touched. No prose.

### 3. Files changed

```text
M  path/to/file
A  path/to/new
D  path/to/deleted
```

Generate from `git status --short` and any non-Git writes (NAS-only paths). Non-Git writes must be flagged explicitly.

### 4. Tests / verification

Per [TEST_VERIFY_STANDARD.md](TEST_VERIFY_STANDARD.md):

```text
Verification — <task class>
Commands run: <list>
Expected: <one line>
Observed: <one line>
Result: pass | fail | partial
```

If `partial` or `fail`, the closeout pauses — return to Planning Mode, then re-open.

### 5. Red-team findings

Per [REDTEAM_REVIEW.md](REDTEAM_REVIEW.md):

```text
Score: <n>/10
Failure-mode lens hits: <list or "none">
Decision: <go|mitigate|no-go>
Rollback command: <one line>
```

### 6. Memory updates

For each entry added or modified, name the file and confirm the [Memory Creation Gate](governance/MEMORY_CREATION_GATE.md) passed. If no memory changed, state `none`.

```text
GLOBAL_MEMORY.md       : <added|updated|none>
<project>/PROJECT_MEMORY.md : <added|updated|none>
LESSONS_LEARNED.md     : <added|updated|none>
```

### 7. NAS sync

```text
mountpoint -q /mnt/nas && echo OK || echo NOT MOUNTED
```

Confirm any file intended to land on the NAS is present:

```text
ls -la /mnt/nas/Verkis-Proxmox-Dev/<paths>
```

For rsync operations: `--dry-run` after, must show zero changes.

### 8. Git

```text
git status --short        # expect clean
git log --oneline -3      # show new commits
git push                  # if applicable, against https://192.168.x.x
```

Record the commit SHAs that landed.

### 9. Next actions

A short ordered list. Each item is the smallest reasonable next step, with the owner. If none, write `none — closed`.

## Closeout template

```markdown
# Session closeout — <ISO datetime>

Host: 3HS
Project: <name or "_common">
Model route: <opusplan|opus|sonnet|haiku>

## Objective
…

## Work completed
- …

## Files changed
…

## Verification
…

## Red-team
…

## Memory updates
…

## NAS sync
…

## Git
…

## Next actions
- …
```

Save under `projects/<name>/sessions/YYYY-MM-DD-<slug>.md` (or `_common/audit/` for `_common`-only sessions).

## Anti-patterns

- "Closeout: done." — not a closeout.
- Closing out before verification passes. Verification gates the closeout, not the other way round.
- Promoting session chatter into `GLOBAL_MEMORY.md` during closeout. Gate it through [`governance/MEMORY_CREATION_GATE.md`](governance/MEMORY_CREATION_GATE.md).

See also: [`RUNBOOK_MASTER_v4.md`](RUNBOOK_MASTER_v4.md), [`SETUP_STATUS_CHECK.md`](SETUP_STATUS_CHECK.md) (the opening counterpart).
