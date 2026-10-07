# Runbook — <project-slug>

## Owner and applicability

State the project, version, target and operator. Mark this draft until actual execution evidence exists.

## Prerequisites

Identify access/trust, scope, exact source/target, required tools and preserved backup. Consult authoritative shared references instead of copying lab topology.

## Start, stop and deployment

Add only verified project-specific commands, their expected results and interruption limits. Do not run placeholders against a live service.

## Verification

Record actual build/tests and runtime health separately. Include failed/unavailable checks and a dated evidence location.

## Backup and recovery

Distinguish archive integrity, freshness, retained copies and service restoration. Test an isolated restore before claiming recovery; keep secrets/private backups outside Git and shared NAS plaintext.

## Rollback

State the tested previous version/configuration, exact bounded action and post-rollback checks. Keep the current access session until replacement access works.

## Troubleshooting

| Symptom | Read-only diagnosis | Bounded corrective action | Owner |
|---|---|---|---|
| To be completed | To be verified | Requires applicable authorization | To be assigned |
