# Agent Operating Standard

> Copyright © Verkís internal documentation.

Applies to every AI agent operating inside the Verkís Proxmox Development Lab — Claude Code, Codex, any future model, and any orchestrated sub-agent. This file defines posture, escalation, and the non-bypassable gates.

## Posture

1. **Planning Mode is the default.** See [PLANNING_MODE.md](PLANNING_MODE.md). Exit only when its conditions are met.
2. **Current-state first.** Open every session with [SETUP_STATUS_CHECK.md](SETUP_STATUS_CHECK.md). Never reason from recall when observation is one command away.
3. **Reuse over create.** The [Artifact Creation Gate](governance/ARTIFACT_CREATION_GATE.md) and [Memory Creation Gate](governance/MEMORY_CREATION_GATE.md) are mandatory and non-bypassable.
4. **Reversible default.** Pick the option that can be undone with one command. Document the rollback alongside the change. See [RULES.md](RULES.md) non-negotiables.

## When to ask, when to act

Ask for clarification when **any** of:

- The objective is ambiguous and a wrong guess could cause destructive, irreversible, or expensive action.
- The active project is unclear (project bleed risk — see [CONTEXT_DISCIPLINE.md](CONTEXT_DISCIPLINE.md) rule 3).
- Required input is missing and inventing it would violate the "no fabricated data" rule.
- The proposed action touches the Proxmox host, shared GitLab/NAS state, secrets, or the firewall.
- The user has explicitly indicated they want to approve before execution.

Act automatically when **all** of:

- The task is clearly scoped and matches a documented runbook step.
- Risk class is low (read-only, scratch space, sandboxed container).
- Defaults are safe and reversible with one command.
- No gate (artifact, memory, context) needs an exception.

When in doubt: ask. Cost of one extra round-trip is far below the cost of a wrong destructive action on a lab without off-drive backup (see GLOBAL_MEMORY.md "evaluation-only" entry).

## Gates — never bypass

| Gate | When triggered | File |
|---|---|---|
| Artifact creation | Any new agent, skill, script, template, workflow | [governance/ARTIFACT_CREATION_GATE.md](governance/ARTIFACT_CREATION_GATE.md) |
| Memory creation | Any new entry in global/project memory or lessons learned | [governance/MEMORY_CREATION_GATE.md](governance/MEMORY_CREATION_GATE.md) |
| Context level escalation | Moving from L1/L2 to L3/L4 | [governance/CONTEXT_CREATION_GATE.md](governance/CONTEXT_CREATION_GATE.md) |
| Red-team review | Before any destructive or shared-state change | [REDTEAM_REVIEW.md](REDTEAM_REVIEW.md) |

A failed gate is a stop, not a hint. Do not "lightly modify" the artifact to make the score pass.

## Model routing

Default `opusplan`. Full table and rules in [MODEL_ROUTING_POLICY.md](MODEL_ROUTING_POLICY.md). Cost is informational, never a reason to downgrade for planning, security, infrastructure, or final review.

## Verification and closeout

Every session ends with [TEST_VERIFY_STANDARD.md](TEST_VERIFY_STANDARD.md) checks appropriate to the task class, then [SESSION_CLOSEOUT.md](SESSION_CLOSEOUT.md). No closeout = no exit.

## Sub-agent and orchestration rules

- A sub-agent inherits the parent session's gates. It cannot grant itself a context level its parent does not hold.
- Sub-agents must not write directly to global memory or registries — return findings to the parent, who runs the gates.
- Output of a sub-agent is treated as memory `Status: review` until the parent verifies it.

## Anti-patterns

- "Trust me, this is safe" — show the rollback or it is not safe.
- "Skipping the banner because we just ran one earlier" — re-run; cheap, prevents drift.
- "I'll create a one-off helper script for this" — that is what the [Artifact Creation Gate](governance/ARTIFACT_CREATION_GATE.md) exists to refuse.
- "I'll remember this for next time" — write it via the [Memory Creation Gate](governance/MEMORY_CREATION_GATE.md) or it does not exist.

See also: [`RUNBOOK_MASTER_v4.md`](RUNBOOK_MASTER_v4.md).
