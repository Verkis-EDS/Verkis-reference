# Template: create an LXC

Owner/date/target: complete before execution. This generic template defers lab allocation to the canonical manuals access table and LXC guide.

## Prerequisites

Authorized free CTID/static address, trusted exact template filename, available storage/bridge, resources and public SSH key. Inspect `pct list`, existing configs and storage. Prefer unprivileged containers; enable nesting only for a reviewed requirement. No DHCP or internal DNS is assumed.

## Steps

Substitute actual approved values; use one exact verified template, not a wildcard:

```bash
pct create "$NEW_CTID" "$EXACT_TEMPLATE" \
  --hostname "$HOSTNAME" --unprivileged 1 \
  --cores "$CORES" --memory "$MEMORY_MIB" --rootfs "$STORAGE:$DISK_GIB" \
  --net0 "name=eth0,bridge=$BRIDGE,ip=$STATIC_CIDR,gw=$GATEWAY" \
  --ssh-public-keys "$PUBLIC_KEY_FILE"
pct start "$NEW_CTID"
```

## Verification

Check status, console, address/route, expected storage mounts and trusted SSH/service health. Separately document excluded data mounts and their backup path. Record actual results and update inventory.

## Rollback and troubleshooting

Stop only the new container while inspecting template/storage/address/permission issues. Preserve data; destruction or overwriting an existing CT is a separate exact-target action. Capture owner/date, expected results and failed/unavailable checks.
