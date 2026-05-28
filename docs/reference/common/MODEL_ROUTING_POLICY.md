# Model Routing Policy

> Copyright © Verkís internal documentation.

Which model handles which work. Default route: **`opusplan`** (Opus for planning, Sonnet for execution). Cost is informational only — never a justification to downgrade for planning, security, infrastructure, or final review.

## Default route

`opusplan` — Opus owns the plan and the review; Sonnet does the routine execution under that plan. This matches [PLANNING_MODE.md](PLANNING_MODE.md) and [RULES.md](RULES.md) "Cost and model policy".

## Routing table

| Task class | Model | Rationale |
|---|---|---|
| Planning Mode session | `opusplan` or Opus | Plan quality dominates outcome; one bad plan costs more than every cheap reply combined |
| Security review | Opus | Threat modelling, secret handling, attack-surface reasoning |
| Infrastructure change (VM/LXC/network/storage) | Opus | Irreversibility risk; needs the strongest reasoning |
| Destructive action (delete, rotate, force-push) | Opus | See [REDTEAM_REVIEW.md](REDTEAM_REVIEW.md) — Opus must produce the go/no-go |
| Final review of a session | Opus | Last line of defence before closeout |
| Routine coding / refactor under an approved plan | Sonnet | Execution under a frozen plan; quality bar met by Sonnet |
| Markdown editing, doc cross-linking, format passes | Sonnet | Throughput task; deterministic |
| Read-only audit script run / log inspection | Haiku | Cheap and fast; no mutation possible |
| Quick syntax check / spelling pass | Haiku | Low risk, low stakes |

Haiku is **never** used for: anything in Planning Mode, security, infrastructure, destructive actions, final review, gate decisions, or writing to memory.

## When to override

Override the default upward (cheaper → more capable) when **any** of:

- The task crossed a gate boundary mid-session (e.g. read-only became mutating).
- Verification turned up unexpected complexity.
- The user explicitly asked for Opus on this step.

Override downward (more capable → cheaper) only when **all** of:

- The remaining work is purely mechanical execution under an already-approved plan.
- No gate decision remains.
- No destructive step is reachable from here.

Cost pressure alone is never sufficient.

## Sub-agents

A sub-agent inherits the parent's risk class. A planning parent on Opus may dispatch Sonnet sub-agents for parallel read-only research, but the parent retains the decision and the final review. See [AGENT_OPERATING_STANDARD.md](AGENT_OPERATING_STANDARD.md) "Sub-agent and orchestration rules".

## Token and cost reporting

- Report tokens-in, tokens-out, and cost when the runtime exposes them.
- If any field is missing, render the literal string `unknown`. **Never** estimate, interpolate, or invent.
- Cost reporting is diagnostic. It informs the next session's routing choice; it does not override the routing table above.
- Same rule lives in [CONTEXT_DISCIPLINE.md](CONTEXT_DISCIPLINE.md) "Token/cost reporting" — those two files must stay aligned.

## Reporting format

```text
Model: <opus|sonnet|haiku>  Route: <opusplan|direct>
Tokens in: <int|unknown>   Tokens out: <int|unknown>
Cost (USD): <float|unknown>
```

## Anti-patterns

- "Downgrading to Haiku to save tokens on this destructive step." — refuse.
- "Estimating tokens at ~3k because the runtime didn't say." — render `unknown`.
- "Opus is overkill for this rename." — fine, if the rename is mechanical, under an approved plan, and reversible. Otherwise, stay on Opus.

See also: [`RUNBOOK_MASTER_v4.md`](RUNBOOK_MASTER_v4.md) cost section.
