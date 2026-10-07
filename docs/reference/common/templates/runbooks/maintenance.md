# Template: bounded maintenance

Owner/date/target/version: complete before execution. This generic format does not declare a live host's repositories, upgrades or reboot state.

## Prerequisites

Observed installed version, official upgrade guidance, trusted package sources, verified backup/recovery, console access, interruption window and a specific rollback plan. Do not start a major upgrade from a copied old command sequence.

## Steps

Inspect repositories and available updates; simulate the reviewed upgrade where supported. Apply only the authorized selected change after its recovery prerequisites pass. A reboot requires the agreed window/access; package installation alone does not prove the new kernel is running.

## Verification

Check actual version, failed services, critical application health, connectivity and backup scheduling. Record package/kernel difference and pending reboot honestly.

## Rollback and troubleshooting

Use the preserved prior package/configuration or tested recovery route. Do not blindly downgrade packages, rotate keys or remove repositories to hide an error. Capture the actual symptom and read-only diagnosis before corrective writes.
