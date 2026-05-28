> Source-of-truth: `verkis-lab/proxmox-manager:/runbooks/backup-restore.md` on host `3HS`. NAS copy synced 2026-05-28.

# Runbook: Backup & Restore

> A backup is not valid until a **restore has been tested**.

## Plan
- What: which VMs/LXCs. Where: storage/PBS/offsite. Frequency, retention, encryption, monitoring.
- Single-disk host → an **offsite/PBS target is essential** (local backups die with the disk).

## Configure a scheduled backup (vzdump)
- GUI: Datacenter → Backup → Add. Or `/etc/pve/jobs.cfg`.
- Example one-off:
  ```bash
  vzdump <VMID> --storage local --mode snapshot --compress zstd
  ```
- Prefer Proxmox Backup Server (PBS) for incremental + encrypted + dedup; add it as storage, then target it in the job.

## Restore
```bash
# list
ls /var/lib/vz/dump/                 # or: proxmox-backup-client snapshot list
# VM restore (new VMID to avoid clobber)
qmrestore /var/lib/vz/dump/<file>.vma.zst <NEW_VMID> --storage local-lvm
# LXC restore
pct restore <NEW_CTID> /var/lib/vz/dump/<file>.tar.zst --storage local-lvm
```

## Verify
- Restored guest boots, networks, and serves; then document the restore test date.
- **Never print backup encryption keys / repo passwords.** Store them in a secrets manager.
