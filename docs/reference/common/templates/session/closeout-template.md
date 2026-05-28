# Task Closeout Summary (v4.0 §25)

> Copyright © Verkís internal documentation. Append this block to the session log before closing
> the terminal. Every field must be answered — write `none` rather than leave blank.

## Header

| Field | Value |
|---|---|
| Date (UTC) | `<YYYY-MM-DD HH:MM>` |
| Operator | `<name>` |
| Agent | `Claude Code <model-id>` |
| Project | `<slug>` |
| Session ID | `<uuid>` |
| Duration | `<HH:MM>` |
| Tokens (in/out) | `<n / m>` or `unknown` |
| USD cost | `$<x.xx>` or `unknown` |

## Objective & outcome

| Field | Value |
|---|---|
| Objective | `<one line>` |
| Outcome | `done` / `partial` / `blocked` |
| Reason (if not done) | `<brief>` |

## Changes

| Path | Change | Notes |
|---|---|---|
| `<file>` | add / edit / delete | `<why>` |

## Commands of record

| # | Command | Result |
|---|---|---|
| 1 | `<cmd>` | `<exit / observed>` |

## Decisions (mirror to DECISIONS.md)

| Date | Decision | Options | Reason | Owner |
|---|---|---|---|---|

## Lessons learned (mirror to LESSONS_LEARNED.md)

| Date | Lesson | Context | Action taken | Tag |
|---|---|---|---|---|

## Improvements (mirror to IMPROVEMENTS.md)

| ID | Date | Area | Improvement | Value | Effort | Priority | Status | Next step |
|---|---|---|---|---|---|---|---|---|

## Open points (mirror to OPEN_POINTS.md)

| ID | Topic | Owner | Priority | Status | Next step |
|---|---|---|---|---|---|

## Verification

| Check | Evidence |
|---|---|
| Service responds | `<curl / log>` |
| Config valid | `<tool -t>` |
| Logs clean | `<journalctl summary>` |
| Second-source | `<API / probe>` |

## Risks & follow-ups

- `<risk>` — mitigation: `<action>` — owner: `<name>`

## Hand-off

| Field | Value |
|---|---|
| Next session should start with | `<pointer to runbook section / file>` |
| Blocked on | `<person / dependency>` or `none` |
| Approval needed for | `<destructive op>` or `none` |
