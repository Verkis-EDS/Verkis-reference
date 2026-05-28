> Source-of-truth: `verkis-lab/proxmox-manager:/runbooks/vm-create.md` on host `3HS`. NAS copy synced 2026-05-28.

# Runbook: Create a VM (QEMU/KVM)

## Preconditions
- Confirm: VMID (free), name, OS/ISO or cloud-init image, cores, RAM, disk size, storage, bridge, VLAN, IP mode, SSH user + keys.
- Check for conflicts: `qm list`, `pvesh get /cluster/nextid`.
- Prefer a cloud-init template for Linux.

## Default baseline (override as needed)
| Setting | Default |
|---|---|
| Cores | 2 |
| RAM | 4 GiB |
| Disk | 32 GiB on `local-lvm` |
| NIC | virtio on `vmbr0` |
| Guest agent | enabled |
| Cloud-init | enabled (Linux) |
| Auth | SSH key only; password auth disabled |
| Firewall | default-deny inbound except required |

## Steps (example, cloud-init)
```bash
VMID=9000; STORAGE=local-lvm; BRIDGE=vmbr0
# (template creation / import image steps depend on chosen image)
qm set "$VMID" --ciuser USER --sshkeys /path/to/key.pub
qm set "$VMID" --ipconfig0 ip=dhcp        # or ip=CIDR,gw=GW
qm set "$VMID" --agent enabled=1
qm start "$VMID"
```

## Verify
- `qm status $VMID` = running; console boots; `qm agent $VMID ping` ok.
- Network reachable; `ssh USER@IP` works; firewall state known.
- Record the VM in `inventory/vms.md`.
