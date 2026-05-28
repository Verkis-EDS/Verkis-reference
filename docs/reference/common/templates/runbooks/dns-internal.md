> Source-of-truth: `verkis-lab/proxmox-manager:/runbooks/dns-internal.md` on host `3HS`. NAS copy synced 2026-05-28.

# Runbook: Internal DNS (`dns01`)

Lightweight LAN DNS for `verkis.internal` so clients don't need `/etc/hosts` entries.

- **Host:** `dns01` LXC (CT 206), `192.168.x.x`, on internal `local-lvm` (NVMe) for resilience.
- **Software:** dnsmasq. Authoritative for `verkis.internal`; forwards everything else to `192.168.x.x`.
- **Config:** `/etc/dnsmasq.d/verkis.conf` (source of truth: `dns/verkis.conf` in this repo).

## Add / change a record
1. Edit `dns/verkis.conf` here (and on dns01 at `/etc/dnsmasq.d/verkis.conf`).
2. Add `host-record=<name>.verkis.internal,<ip>` — front-door services point to proxy01 (`.181`).
3. On dns01: `dnsmasq --test && systemctl restart dnsmasq`.
4. Verify: `dig +short @192.168.x.x <name>.verkis.internal`.

## Make the LAN use it (required, done on the router — not this host)
Point clients at `dns01` as **primary** DNS with the existing resolver as **secondary**:
- **Best:** set the router/DHCP to hand out DNS = `192.168.x.x`, then `192.168.x.x`. All clients
  pick it up on next DHCP lease renewal. Zero per-client config.
- **Per-client fallback:** set DNS manually to `192.168.x.x` (primary), `192.168.x.x` (secondary).

The `.112` secondary matters: if `dns01` is ever down, clients still resolve the internet (they only
lose `*.verkis.internal` names). After switching to DNS, remove any temporary `gitlab.verkis.internal`
line from client `/etc/hosts` to avoid stale entries.

## Re-create dns01 from scratch
`pct create 206 local:vztmpl/debian-13-standard_*.tar.zst --hostname dns01 --unprivileged 1 --cores 1
--memory 256 --rootfs local-lvm:4 --net0 name=eth0,bridge=vmbr0,ip=192.168.x.x/24,gw=192.168.x.x
--nameserver 192.168.x.x --features nesting=1 --onboot 1` → `apt-get install dnsmasq` →
deploy `dns/verkis.conf` → restart.
