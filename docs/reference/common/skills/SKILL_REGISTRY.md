# Skill Registry

> Copyright © Verkís internal documentation.

Authoritative list of skills (slash-commands, reusable prompt templates, automation hooks) approved for operation inside the Verkís Proxmox Development Lab. No skill runs without a row in this table.

Adding a row requires a passing [Artifact Creation Gate](../governance/ARTIFACT_CREATION_GATE.md) decision. See also [`../AGENT_OPERATING_STANDARD.md`](../AGENT_OPERATING_STANDARD.md) for how skills are invoked.

## Columns

- **Name** — slug used in invocations (the `/<name>` form, or the harness's equivalent).
- **Purpose** — one sentence: what this skill does.
- **Scope** — which projects / hosts / data this skill may touch (`_common`, named project, read-only, etc.).
- **Owner** — named person or team accountable.
- **Last gate decision** — ISO date and result of the most recent Artifact Creation Gate run for this skill. Link to `governance/decisions/<file>.md`.
- **Status** — `active` · `pilot` · `archived`.

## Registry

| Name | Purpose | Scope | Owner | Last gate decision | Status |
|---|---|---|---|---|---|
| _no skills registered yet_ |  |  |  |  |  |

## Adding a skill

1. Run the [Artifact Creation Gate](../governance/ARTIFACT_CREATION_GATE.md). Save the transcript under `governance/decisions/YYYY-MM-DD-skill-<slug>.md`.
2. If the score is `Create` (10+), append a row to this table **before** writing the skill.
3. If the score is `Pilot` (6–9), add the row with `Status: pilot` and an explicit revisit date.
4. If the score is below 6, do not add the skill. Use a session note instead.

## Removing or archiving a skill

- Move `Status` to `archived` and update `Last gate decision` to the date of the archival decision.
- Keep the row — the registry is the audit trail. Do not delete.
- Add a `Superseded by:` link in the archive decision file if a replacement exists.

## Anti-patterns

- Invoking a skill that is not in this table. The table is the allow-list, not a hint.
- Promoting a pilot to active without re-running the gate.
- Skills that grow scope quietly. Scope changes require a new gate run.

See also: [`../AGENT_OPERATING_STANDARD.md`](../AGENT_OPERATING_STANDARD.md), [`../MODEL_ROUTING_POLICY.md`](../MODEL_ROUTING_POLICY.md), [`../agents/AGENT_REGISTRY.md`](../agents/AGENT_REGISTRY.md).
