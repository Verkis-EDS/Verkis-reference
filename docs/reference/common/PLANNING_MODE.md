# Planning Mode

> Copyright © Verkís internal documentation.

Planning Mode is the default opening state for every non-trivial session. The session does not exit Planning Mode until the plan is written, the risks are listed, and approval points are explicit.

## When Planning Mode is mandatory

- Any infrastructure change (VM/LXC/Docker/network/storage)
- Any GitLab/NAS change touching shared state
- Any new agent, skill, script, or memory entry
- Any non-trivial code change crossing more than one file
- Any cleanup, deletion, or archive action
- Anything tagged "P1" in a gap evaluation

You may skip Planning Mode only when **all** of:
- the action is trivial,
- fully reversible with one command,
- non-destructive,
- has no shared-state impact,
- has a single obvious implementation.

## Plan template (every plan ships these sections)

1. **Objective** — single sentence outcome
2. **Assumptions** — what we believe to be true, listed separately from facts
3. **Current known infrastructure** — observed state, not recalled state
4. **Missing information** — what we need to ask or look up before executing
5. **Proposed first actions** — small, ordered, verifiable
6. **Risks and approval points** — listed before, not after
7. **Acceptance criteria** — how we know it's done
8. **Verification method** — concrete commands or test names
9. **Rollback or recovery approach** — explicit, executable

## Order of operations

Strict, enforced:

```text
current-state → gap → plan → execute → verify → document
```

No step skipped. No reordering.

## Outputs

A Planning Mode session produces, in order:

1. Session banner (`~/bin/verkis-common banner`)
2. Current setup status (per [SETUP_STATUS_CHECK.md](SETUP_STATUS_CHECK.md))
3. Gap and risk evaluation
4. Recommended fixes
5. Execution plan with work-package table
6. Approval points
7. Verification checklist
8. Closeout (per [SESSION_CLOSEOUT.md](SESSION_CLOSEOUT.md))

## When to exit Planning Mode

When the user has explicitly approved the plan (or, in autonomous flow, when the safe-default conditions in [RULES.md](RULES.md) are satisfied). Exit by saving the plan to `~/.claude/plans/<name>.md` (or equivalent for non-Claude agents) and proceeding to the execute step.

## Anti-patterns

- "I'll just quickly..." — almost never quick, almost always non-trivial. Plan it.
- "The plan is to do X." (one sentence) — not a plan. Use the 9-section template.
- "Plan after I write the code." — order is fixed. Plan first.
- "Verify after the next change." — verify after every major step, not at the end.
