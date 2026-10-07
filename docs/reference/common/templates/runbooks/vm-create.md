# Template: create a VM

Owner/date/target: complete before execution. This generic template is not a VM allocation or proof of success. Use the canonical manuals VM guide and access table for the actual lab plan.

## Prerequisites

Authorized target/VMID, current capacity, reviewed source image/template, selected storage/bridge, static IP/gateway and trusted SSH key. Inspect `qm list`, the proposed VMID, storage and guest network configuration. A suggested next ID does not prove an IP is free. No internal DNS or DHCP is assumed.

## Steps

Prepare exact approved values, then adapt the target platform's version-matched VM creation procedure. Cloud-init example after the new VM exists:

```bash
# Set these to observed and approved values; never use a live template VMID.
qm set "$NEW_VMID" --ciuser "$SSH_USER" --sshkeys "$PUBLIC_KEY_FILE"
qm set "$NEW_VMID" --ipconfig0 "ip=$STATIC_CIDR,gw=$GATEWAY"
qm set "$NEW_VMID" --agent enabled=1
qm start "$NEW_VMID"
```

## Verification

Confirm boot, expected resources, static network and trusted SSH. Guest-agent checks succeed only if that agent is installed/running. Record actual results and update the canonical inventory; do not declare an unperformed restore or application test successful.

## Rollback and troubleshooting

Stop only the newly created VM if validation fails. Preserve source image/backups; review any deletion separately. Diagnose source compatibility, storage headroom, console, bridge/address conflict and key trust before retrying. Keep command evidence and owner/date with the completed runbook.
