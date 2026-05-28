# Red-Team Review — <task ID / slug>

> Fillable per-task companion to the active 12-question checklist in
> `_common/REDTEAM_REVIEW.md`. Save filled copies for destructive actions under
> `_common/governance/reviews/YYYY-MM-DD-<slug>.md`.

| Field | Value |
|---|---|
| Task ID | `VSYS-0000` |
| Task title | `<one line>` |
| Reviewer model | `opus / sonnet / haiku` |
| Review date (UTC) | `YYYY-MM-DD HH:MM` |
| Change class | `destructive / shared-state / docs-only / new-artifact` |

## Section A — 12-question checklist

(Scoring per `REDTEAM_REVIEW.md`. Answer each with evidence; "unknown" = failure.)

1. **What exactly changes on disk, in Git, or in running services?**
   - Files / repos / branches / containers / VMs / vhosts:
2. **Blast radius if step N hits the wrong target?**
3. **Is the change reversible with one documented command?**
   - Rollback command:
4. **Correct CWD and host?**
   - `pwd && hostname`:
5. **Does any step touch secrets?**
   - Paths checked:
6. **Re-running an already-run command — idempotent?**
7. **Depends on unverified-this-session memory?**
   - Verification done:
8. **Crossing a project boundary?**
9. **Acting on a stale summary?**
10. **What happens if NAS / GitLab / docs portal goes offline mid-step?**
11. **Verification command — does it prove the change worked?**
12. **What does the session log capture for the next session?**

**Score: <n>/10**

## Section B — Failure-mode lens

| Failure mode | Mitigation / "not applicable" |
|---|---|
| NAS offline mid-write | |
| GitLab unavailable | |
| Wrong CWD | |
| Command re-run | |
| Secrets committed | |
| Memory duplicates | |
| Project bleed | |
| Stale summary | |

## Section C — Necessity / bloat (protocol §22)

| Category | Score 0–3 | Note |
|---|---|---|
| Necessity | | |
| Risk | | |
| Complexity | | |
| Maintenance | | |
| Reuse value | | |
| Security exposure | | |

## Section D — Decision

```text
Decision: GO / MITIGATE / NO-GO
Mitigations applied:
- …
Rollback command (one line):
Verification command (one line):
Approver:
```

## Section E — Recorded outcome (post-execution)

| Item | Value |
|---|---|
| Executed? | yes / no / partial |
| Rollback used? | yes / no |
| Verification result | pass / fail |
| Lesson worth saving? | yes / no — destination: |
