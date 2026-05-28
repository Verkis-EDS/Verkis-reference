# Red-Team Review

> Copyright © Verkís internal documentation.

See also: [`governance/WORKSPACE_GATEKEEPER.md`](governance/WORKSPACE_GATEKEEPER.md) — entry point and end-to-end flow.

Mandatory before any destructive action, shared-state change, or session closeout that touched infrastructure. Implements `RUNBOOK_MASTER_v4.md` §23. The goal is to surface the failure mode *before* it lands.

## When to run

- Before any destructive action (see [RULES.md](RULES.md) non-negotiables).
- Before any change to shared state on `3HS`, GitLab `https://192.168.x.x`, the docs portal `https://192.168.x.x:8443`, the Proxmox GUI `https://192.168.x.x:8006`, or the NAS `/mnt/nas/Verkis-Proxmox-Dev/`.
- Before merging a plan that introduces a new agent, skill, or runbook.
- Always in final review (see [MODEL_ROUTING_POLICY.md](MODEL_ROUTING_POLICY.md)).

## The 12-question checklist

Answer every question. "Unknown" counts as a failure for that question — go observe.

1. **What exactly changes on disk, in Git, or in running services?** Name every file, repo, branch, container, VM, vhost.
2. **What is the blast radius if step N executes with the wrong target?** Single file? Single project? Whole NAS tree? Whole host?
3. **Is the change reversible with one documented command?** If no, what is the multi-step rollback and has it been tested?
4. **Are we on the correct CWD and the correct host?** `pwd && hostname` — written into the plan, not assumed.
5. **Does any step touch secrets?** Any `.env`, token, key, certificate, password. If yes, is the path `.gitignore`d and outside the NAS plaintext zone?
6. **Are we re-running a command that already ran?** Idempotent? Or will it duplicate, double-charge, or double-delete?
7. **Does the plan depend on memory that has not been verified this session?** If yes, verify now.
8. **Are we crossing a project boundary?** Project A's facts must not bleed into Project B — see [CONTEXT_DISCIPLINE.md](CONTEXT_DISCIPLINE.md) rule 5.
9. **Is the summary we are acting on stale?** If the summary is older than the last commit on the file it describes, re-read the file.
10. **What happens if the NAS goes offline mid-step?** What happens if GitLab is unavailable? What happens if the docs portal is down?
11. **What is the verification command, and does it actually prove the change worked** (not just "no error")?
12. **What does the session log capture for the next session?** Without this, the next session repeats the work or undoes it.

## Failure-mode lens

Run the checklist against each of these, explicitly:

- NAS offline (`/mnt/nas` unmounted mid-write)
- GitLab unavailable (push/pull failures)
- Wrong CWD (running in `~` instead of the repo, or vice versa)
- Command re-run (second invocation silently appends/deletes)
- Secrets committed (any path under Git or NAS plaintext)
- Memory duplicates (same fact written twice)
- Project bleed (Project A rules applied to Project B)
- Stale summary (acting on a summary older than the source file)

## Scoring

Score 0–10. One point per checklist question answered cleanly with evidence; subtract for unresolved failure-mode lens hits.

| Score | Decision |
|---:|---|
| 0–5 | **No-go.** Stop. Return to Planning Mode. Document the gap. |
| 6–7 | **Mitigation required.** Identify the specific weakness, mitigate, re-score before proceeding. |
| 8–10 | **Go.** Proceed with the documented rollback ready. |

A "Go" score does not waive the rollback or verification step. It only authorises execution.

## Recording the result

Append to the session log:

```text
Red-team review — <ISO datetime>
Reviewer model: <opus|sonnet>
Score: <n>/10
Failure-mode lens hits: <list or "none">
Decision: <go|mitigate|no-go>
Mitigations applied: <list>
Rollback command: <one line>
Verification command: <one line>
```

For destructive actions, also save under `governance/reviews/YYYY-MM-DD-<slug>.md`.

## Anti-patterns

- "Score 8 because the change looks small." — small changes that delete the wrong directory are still destructive.
- "We'll verify after the next change." — verify after this one.
- "Rollback is to restore from backup." — there is no off-drive backup on this lab (see GLOBAL_MEMORY.md). Plan a different rollback.

See also: [`SESSION_CLOSEOUT.md`](SESSION_CLOSEOUT.md), [`TEST_VERIFY_STANDARD.md`](TEST_VERIFY_STANDARD.md), [`RUNBOOK_MASTER_v4.md`](RUNBOOK_MASTER_v4.md) §23.
