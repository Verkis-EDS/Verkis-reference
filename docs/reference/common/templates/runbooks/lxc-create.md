> Source-of-truth: `verkis-lab/proxmox-manager:/runbooks/lxc-create.md` on host `3HS`. NAS copy synced 2026-05-28.

# Runbook: Create a Container (LXC)

## Preconditions
- Confirm: CTID, hostname, template, storage, bridge, IP mode, resources.
- Use official/trusted templates: `pveam update && pveam available` → `pveam download local <template>`.
- Prefer **unprivileged** containers; avoid nesting unless required.

## Default baseline
| Setting | Default |
|---|---|
| Unprivileged | yes |
| Cores | 1–2 |
| RAM | 1–2 GiB |
| Disk | 8–16 GiB on `local-lvm` |
| NIC | `vmbr0` |
| Features | minimal |
| Firewall | enabled where practical |

## Steps (example)
```bash
CTID=200; STORAGE=local-lvm; BRIDGE=vmbr0
pct create "$CTID" local:vztmpl/<template>.tar.zst \
  --hostname ct-example --unprivileged 1 \
  --cores 2 --memory 2048 --rootfs ${STORAGE}:8 \
  --net0 name=eth0,bridge=${BRIDGE},ip=dhcp \
  --ssh-public-keys /path/to/key.pub
pct start "$CTID"
```

## Verify
- `pct status $CTID` = running; `pct exec $CTID -- ip a` ok; DNS + package manager work.
- Record the container in `inventory/containers.md`.
