#!/usr/bin/env bash
set -euo pipefail

OUT_DIR="${OUT_DIR:-$HOME/Projects/Verkis-reference/.mirror-work/private-audit}"
TS="$(date -u +"%Y%m%d-%H%M%S")"
OUT="$OUT_DIR/proxmox-readonly-audit-$TS.txt"

mkdir -p "$OUT_DIR"

{
  echo "# Proxmox Read-Only Audit"
  echo "Generated UTC: $(date -u +"%Y-%m-%d %H:%M:%S")"
  echo

  echo "## Host"
  hostname || true
  uname -a || true
  pveversion -v || true
  echo

  echo "## Nodes and resources"
  pvesh get /nodes || true
  pvesh get /cluster/resources || true
  echo

  echo "## VMs"
  qm list || true
  echo

  echo "## LXCs"
  pct list || true
  echo

  echo "## Storage"
  pvesm status || true
  df -h || true
  lsblk || true
  echo

  echo "## Network"
  ip -br addr || true
  ip route || true
  echo

  echo "## Recent errors"
  journalctl -p err -n 80 --no-pager || true

} > "$OUT"

chmod 600 "$OUT"

echo "Wrote private audit: $OUT"
echo "Do not publish raw audit output."
