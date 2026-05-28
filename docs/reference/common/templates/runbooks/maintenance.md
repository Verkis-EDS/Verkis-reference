> Source-of-truth: `verkis-lab/proxmox-manager:/runbooks/maintenance.md` on host `3HS`. NAS copy synced 2026-05-28.

# Runbook: Maintenance & Updates

## APT repositories (current state on `3HS`)
- Enterprise repos **disabled** (no subscription → 401). Using `pve-no-subscription`.
- Files: `/etc/apt/sources.list.d/{pve-enterprise,ceph}.sources` carry `Enabled: false`;
  `pve-no-subscription.sources` is active.
- Re-enable enterprise (if a subscription is purchased): set `Enabled: true` and remove the no-subscription file.

## Update procedure
```bash
apt-get update
apt-get -s dist-upgrade        # review what changes (simulation)
# confirm backups first, then in a maintenance window:
apt-get dist-upgrade
```
- Check whether a reboot is needed (new kernel/microcode): `[ -f /var/run/reboot-required ] && echo reboot needed`.
- Reboot only with approval and a console/rollback path.

## Verify after updates
```bash
pveversion -v
systemctl --failed
journalctl -p err -n 100 --no-pager
```

## Routine health check
Run `scripts/readonly-audit.sh` and compare against the latest `audits/` snapshot.
Never run blind major version upgrades — read the official upgrade guide first.
