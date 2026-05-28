# Context and Memory Policy

Prevent context drift, memory bloat, and bleeding between sessions or projects.

## Rules

1. Use session-scoped context first.
2. Load only files relevant to the active task.
3. Do not mix examples with live configuration.
4. Do not import unrelated project memory.
5. Do not carry stale assumptions forward.
6. Ask for clarification when missing information affects correctness or safety.
7. Run automatically when the task is clearly defined, low-risk, and reversible.
8. Stop and ask when the task requires secrets, destructive action, client data, or unclear infrastructure changes.

## Memory creation gate

Create reusable memory only if all are true:

- useful for future sessions,
- valid for more than 30 days,
- non-secret,
- concise,
- sourced,
- not duplicated,
- has clear use and limits.
