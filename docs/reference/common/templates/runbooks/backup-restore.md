# Template: backup and isolated restore

Owner/date/target: complete before execution. This generic template is not the current lab retention configuration. The lab's canonical implementation/runbook is proxmox-manager `runbooks/verified-backup-retention.md`; the manuals backup overview records current evidence.

## Prerequisites and plan

Identify guests, application/configuration layers, excluded mounts, selected archive/destination, freshness and failure domains. Preserve at least the workflow's required verified holders and headroom. Independent storage is a separate hardware decision; copying on one host does not become off-host protection.

## Steps

1. Inspect the installed backup job/catalog without changing it.
2. Validate the intended archive's complete decompression and VMA/tar structure, recording results separately from restoration.
3. Select a confirmed free disposable restore ID and enough target capacity. Keep networking disconnected **before first boot** to avoid IP/service collisions.
4. Follow the platform/version-matched restore procedure for the exact archive and target, then verify boot and service health inside the isolated environment. Restore excluded NAS mounts/application exports separately.
5. Record actual checks, limitations and cleanup. Do not prune by filename age or use native retention that can remove unknown/unverified holders.

## Verification

Report integrity, freshness, retained-copy count, guest boot, application behavior, excluded-data recovery and failure-domain coverage independently. A valid archive is not a proved application recovery. Preserve secrets/private archives outside Git/shared plaintext.

## Rollback and troubleshooting

Leave production unchanged; stop the disposable clone if checks fail. Retain backup holders and resolve target capacity, format/version, mounts and application consistency before retry. Destroy only an identified disposable guest after the current evidence is captured and the scope authorizes it.
