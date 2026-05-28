# Memory Policy

> Copyright © Verkís internal documentation.

Memory exists to make future sessions faster and safer. Memory that is wrong, stale, project-leaked, or noisy makes future sessions worse.

## When to add memory

Add only if **all** of:

- Useful for future sessions
- Likely valid for more than 30 days
- Non-secret
- Source/evidence is named
- Concise (under the soft limit for its file)
- Not already captured elsewhere
- Has an owner
- Has a review date

If any answer is no, keep it in the session log instead.

## When to never add memory

- Passwords, tokens, API keys, private keys
- Raw logs unless critical and sanitised
- Temporary task chatter
- Duplicate of an existing entry
- Project-specific facts on the way into `GLOBAL_MEMORY.md`
- Large pasted documents when an executive summary suffices

## Soft limits

| File | Lines | Action if exceeded |
|---|---:|---|
| `GLOBAL_MEMORY.md` | 200 | Compress old entries, move oldest to `memory/archive/` |
| `PROJECT_MEMORY.md` | 200 | Same per-project |
| `LESSONS_LEARNED.md` | 300 | Consolidate themes; archive raw |
| Resource summary | 150 | Split or summarise |
| Session log | none | Close session and summarise into appropriate file |

Run `~/bin/verkis-common memory-lint` monthly (and before any new entry that pushes a file over its limit).

## Entry format

```markdown
## YYYY-MM-DD — Short title

Status: active | review | deprecated
Owner: <name/team>
Source: <file/link/session>
Review date: YYYY-MM-DD
Confidence: high | medium | low

Summary:
- Up to 5 bullets.

Use when:
- When this helps future work.

Do not use when:
- Edge cases or limits.
```

## Compression patterns

- **Multiple similar incidents** → one "Pattern: …" entry, link to incidents in archive
- **Sequence of decisions on one topic** → one rolling entry with dated section headers, oldest moved to archive
- **Long narrative** → bullet list with one-line anchor + archive link

## Review cadence

- Monthly: `~/bin/verkis-common stale-review` — surfaces entries past review date or marked `Status: review`
- Quarterly: full read-through of `GLOBAL_MEMORY.md` and `LESSONS_LEARNED.md`

## Trust order

See [../CONTEXT_DISCIPLINE.md](../CONTEXT_DISCIPLINE.md). When memory conflicts with current observation, **trust observation** and update the entry.
