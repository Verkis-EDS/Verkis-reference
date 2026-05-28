# Context Discipline

> Copyright © Verkís internal documentation.

Goal: prevent context drift, memory bloat, session bleed, and stale-memory misuse. A session that loads the wrong context produces the wrong answer.

## What we prevent

| Failure mode | Symptom | Cause |
|---|---|---|
| Context drift | Agent starts solving the wrong problem | Loaded an unrelated memory or assumed without checking |
| Memory bloat | Files exceed soft limits, signal lost in noise | Appending instead of compressing; saving session chatter as durable memory |
| Session bleed | One session's open file shapes the next | No closeout, memory not gated |
| Project bleed | Project A's rules applied to Project B | Project-specific data put in `GLOBAL_MEMORY.md` |
| Stale-memory misuse | Recommendation cites a function that no longer exists | Trusting memory over current code |

## Context loading levels (escalation, not default)

| Level | Load | When |
|---|---|---|
| 0 | No memory | Trivial one-off |
| 1 | Global rules only ([RULES.md](RULES.md)) | General lab operation |
| 2 | Global + project memory | Project-specific work |
| 3 | Global + project + selected resources | Technical implementation, cross-references |
| 4 | Full audit context | Cleanup, migration, architecture review |

Default starting point: **Level 1 or 2**. Escalate only when the work actually needs the extra context.

## Boundaries by file type

| Type | Location | Use | Do not use for |
|---|---|---|---|
| Global memory | `_common/memory/GLOBAL_MEMORY.md` | Stable lab-wide rules | Project details |
| Project memory | `projects/<name>/memory/PROJECT_MEMORY.md` | Durable project facts | Session chatter |
| Session log | `projects/<name>/sessions/` | Today's work | Long-term truth |
| Lessons learned | `_common/memory/LESSONS_LEARNED.md` | Reusable patterns | Raw transcripts |
| Resource summaries | `_common/resources/executive_summaries/` | Verified third-party doc summaries | Full document dumps |
| Archive | `<area>/archive/` | Historical reference | Active instructions |

## The 10 drift controls

1. Start each session with [SETUP_STATUS_CHECK.md](SETUP_STATUS_CHECK.md).
2. State which memory files were loaded (the banner does this).
3. State which project is active. If unclear, ask.
4. State assumptions separately from observed facts.
5. Do not reuse project-specific facts unless the active project matches.
6. Do not update global memory from one-off project details.
7. Compress old memory before adding new memory — see [memory/MEMORY_POLICY.md](memory/MEMORY_POLICY.md).
8. Mark uncertain memory as `Status: review`, not `Status: active`.
9. Archive stale memory with a reason and date.
10. When identity, project, environment, or objective is unclear — ask.

## Trust order

```text
1. Current observed reality (live commands, fresh file reads)
2. The active project's PROJECT_MEMORY.md
3. Recently-modified runbooks / documentation
4. GLOBAL_MEMORY.md
5. Auto-memory entries
6. Older archived notes
```

When a recall conflicts with observation, **trust observation** and update the memory.

## Token/cost reporting

Tokens and cost are diagnostic, not optimisation pressure. Render `unknown` if the runtime doesn't expose them — do **not** estimate. See [MODEL_ROUTING_POLICY.md](MODEL_ROUTING_POLICY.md).
