# Memory Creation Gate

> Copyright © Verkís internal documentation.

Use this before adding any entry to `GLOBAL_MEMORY.md`, a project's `PROJECT_MEMORY.md`, or `LESSONS_LEARNED.md`.

## Pre-flight checklist

```text
[ ] Will this help future sessions?
[ ] Is it likely valid for more than 30 days?
[ ] Is it non-secret? (no passwords, tokens, keys)
[ ] Is there a named source/evidence?
[ ] Is the body concise (≤ 5 bullets)?
[ ] Is it not already captured somewhere else?
[ ] Does it have a named owner?
[ ] Does it have a review date?
[ ] Does it belong in this scope (global/project/lesson)?
```

If any answer is **no**, keep the content in the session log instead — do not promote it to memory.

## Scope rule (prevents project bleed)

- A fact that names a specific project, repo, file path, IP, or service config → goes to that **project's** memory.
- A fact that applies across two or more current projects and is stable → goes to **global** memory.
- A reusable pattern that emerged from a project → goes to **lessons learned** (consolidated, not raw).

## Format

See [`../memory/MEMORY_POLICY.md`](../memory/MEMORY_POLICY.md) § Entry format.

## Common rejections

| Proposed entry | Why rejected |
|---|---|
| "User likes verbose comments" | Project preference, not durable lab fact |
| "The 2026-05-28 incident took 4 hours" | Session chatter; lives in session log |
| "Token for docs-bot is `glpat-...`" | **REJECT** — secret |
| "We decided X today" without source | No evidence; not durable |
| "GitLab is at 192.168.x.x" duplicated from `RULES.md` | Already captured |
| "Maybe we should restructure NAS later" | Speculation, not a fact |

## When you're not sure

Default to **not creating**. Future sessions will surface the need again if it's real; if it's noise, it disappears.
