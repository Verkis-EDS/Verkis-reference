# Context Creation Gate

> Copyright © Verkís internal documentation.

Use this before escalating the session's **context level** above the default L1/L2. Implements the escalation discipline introduced in [`../CONTEXT_DISCIPLINE.md`](../CONTEXT_DISCIPLINE.md) "Context loading levels".

## Why a gate

Every additional file loaded into context is a chance to drift, mis-apply project-specific rules to the wrong project, or act on a stale summary. Default low; escalate deliberately.

## Levels (recap)

| Level | Load | When |
|---|---|---|
| 0 | No memory | Trivial one-off |
| 1 | Global rules only ([../RULES.md](../RULES.md)) | General lab operation |
| 2 | Global + project memory | Project-specific work |
| 3 | Global + project + selected resources | Technical implementation, cross-references |
| 4 | Full audit context | Cleanup, migration, architecture review |

Default starting point: **L1 or L2**.

## When escalation is justified

Escalate to **L3** only when **all** of:

- The task explicitly requires cross-referencing third-party docs, vendor manuals, or executive summaries.
- The specific resources are named ahead of time (not "all of `resources/`").
- A red-team review (see [`../REDTEAM_REVIEW.md`](../REDTEAM_REVIEW.md)) has confirmed no project-bleed risk.

Escalate to **L4** only when **all** of:

- The task is an audit, migration, cleanup, or architecture review (the four named L4 use cases).
- A written plan exists (see [`../PLANNING_MODE.md`](../PLANNING_MODE.md)).
- The session is on Opus or `opusplan` per [`../MODEL_ROUTING_POLICY.md`](../MODEL_ROUTING_POLICY.md).
- The user has approved the escalation, or the runbook step being executed explicitly calls for L4.

## Pre-flight checklist

```text
[ ] Current level is L1 or L2.
[ ] The task genuinely needs the extra context (named files, not "everything").
[ ] No project-bleed risk — the additional files belong to the active project or are global.
[ ] Model route is appropriate for the higher level (Opus/opusplan for L3+).
[ ] The escalation is recorded in the session log with reason.
[ ] A downgrade plan exists — when this sub-task ends, drop back to L1/L2.
```

If any answer is **no**, do not escalate. Solve the task at the current level or split it.

## How to record the decision

Append to the session log at the point of escalation:

```text
Context escalation — <ISO datetime>
From level: <1|2>
To level: <3|4>
Reason: <one sentence>
Files loaded: <explicit list>
Project scope: <active project name or "_common">
Downgrade plan: <when/how we return to baseline>
Approver: <user or "autonomous — safe-default conditions met">
```

For L4, also save under `governance/decisions/YYYY-MM-DD-context-L4-<slug>.md`.

## Downgrade

When the L3/L4 sub-task ends, **drop back to L1/L2 explicitly**. State the downgrade in the session log. Lingering at L4 is the same failure mode as never gating in the first place.

## Anti-patterns

- "Loading everything in `_common/` to be safe." — that is the bug, not the fix. Load named files.
- "We were at L4 earlier, let's stay there." — every sub-task re-evaluates the level.
- Escalating to avoid the inconvenience of looking something up. Look it up.

See also: [`../CONTEXT_DISCIPLINE.md`](../CONTEXT_DISCIPLINE.md), [`../memory/CONTEXT_DRIFT_CONTROL.md`](../memory/CONTEXT_DRIFT_CONTROL.md), [`ARTIFACT_CREATION_GATE.md`](ARTIFACT_CREATION_GATE.md), [`MEMORY_CREATION_GATE.md`](MEMORY_CREATION_GATE.md).
