# Artifact Creation Gate

> Copyright © Verkís internal documentation.

Use this before creating any new **agent, skill, script, repeated workflow, or template**. Default stance: *do not create unless the gate passes.*

## Why

Every new artifact carries a maintenance cost. Most one-off needs are better served by a session note. The gate exists to make the cost visible before commit.

## Scoring

| Criterion | Score |
|---|---:|
| Reused at least monthly | +3 |
| Reduces real operational/security/quality risk | +3 |
| Used across 2+ projects | +3 |
| Has a clear owner and maintenance path | +2 |
| Has a test/verification method | +2 |
| Existing tool/template already solves it | -4 |
| One-off task | -3 |
| Adds hidden complexity | -3 |
| Contains secrets or sensitive data | **REJECT** |

## Decision

| Score | Result |
|---:|---|
| 10+ | **Create**, add to the appropriate registry |
| 6–9 | **Pilot or template only** — temporary, with an explicit revisit date |
| 1–5 | **Do not create**, use a session note |
| < 1 or REJECT flag | **Do not create** |

## How to run it

```bash
python3 /mnt/nas/Verkis-Proxmox-Dev/_common/scripts/artifact_gate.py \
  --type {skill|agent|script|memory|template} \
  --name <slug> \
  --purpose "<one sentence>" \
  --frequency {daily|weekly|monthly|rarely} \
  --risk {low|medium|high} \
  --reuse {low|medium|high} \
  --existing {none|partial|yes}
```

Output: numeric score + decision. Save the gate transcript under `governance/decisions/YYYY-MM-DD-<name>.md`.

## Registries

When a "Create" decision is reached, add a row to the appropriate registry **before** writing the artifact:

- Skills → [`../skills/SKILL_REGISTRY.md`](../skills/SKILL_REGISTRY.md)
- Agents → [`../agents/AGENT_REGISTRY.md`](../agents/AGENT_REGISTRY.md)
- Scripts → describe in [`../RULES.md`](../RULES.md) "Where to find things" or the relevant runbook

## Examples

| Proposed | Score | Decision |
|---|---:|---|
| Reusable `/redteam` slash-command used weekly across 3 projects, no secrets | 11 | Create |
| One-off rename script for a single project migration | -3 | Session note only |
| Memory entry "user prefers tabs over spaces" — no source, no review date | REJECT (insufficient evidence) | Do not create |
| Backup script that needs the SMB password | REJECT (secret) | Use credentials file outside Git |
| Template for `mkdocs.yml` reused on every new docs site | 9 | Pilot — promote to standard after second use |
