# Agent Registry

> Copyright © Verkís internal documentation.

Authoritative list of AI agents (subagents, orchestrators, automated workflows) approved for operation inside the Verkís Proxmox Development Lab. No agent runs without a row in this table.

Adding a row requires a passing [Artifact Creation Gate](../governance/ARTIFACT_CREATION_GATE.md) decision. See also [`../AGENT_OPERATING_STANDARD.md`](../AGENT_OPERATING_STANDARD.md) for how every agent must behave once registered.

## Columns

- **Name** — slug used in invocations and logs.
- **Purpose** — one sentence: what this agent does.
- **Scope** — which projects / hosts / data this agent may touch (`_common`, named project, read-only, etc.).
- **Owner** — named person or team accountable.
- **Last gate decision** — ISO date and result of the most recent Artifact Creation Gate run for this agent. Link to `governance/decisions/<file>.md`.
- **Status** — `active` · `pilot` · `archived`.

## Registry

| Name | Purpose | Scope | Owner | Last gate decision | Status |
|---|---|---|---|---|---|
| _no agents registered yet_ |  |  |  |  |  |

## Adding an agent

1. Run the [Artifact Creation Gate](../governance/ARTIFACT_CREATION_GATE.md). Save the transcript under `governance/decisions/YYYY-MM-DD-agent-<slug>.md`.
2. If the score is `Create` (10+), append a row to this table **before** writing any agent code or prompts.
3. If the score is `Pilot` (6–9), add the row with `Status: pilot` and an explicit revisit date.
4. If the score is below 6, do not add the agent. Use a session note instead.

## Removing or archiving an agent

- Move `Status` to `archived` and update `Last gate decision` to the date of the archival decision.
- Keep the row — the registry is the audit trail. Do not delete.
- Add a `Superseded by:` link in the archive decision file if a replacement exists.

## Anti-patterns

- Running an agent that is not in this table. The table is the allow-list, not a hint.
- Promoting a pilot to active without re-running the gate.
- Project-specific agents quietly broadening their scope. Scope changes require a new gate run.

See also: [`../AGENT_OPERATING_STANDARD.md`](../AGENT_OPERATING_STANDARD.md), [`../MODEL_ROUTING_POLICY.md`](../MODEL_ROUTING_POLICY.md), [`../skills/SKILL_REGISTRY.md`](../skills/SKILL_REGISTRY.md).
