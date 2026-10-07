# Retired template: internal lab DNS

The lab has no internal DNS service. This compatibility filename is retained so older references do not recreate the retired DNS guest or use obsolete endpoints.

Use the canonical manuals access table and static IPs. VM/LXC setup templates require reviewed static addressing; do not add DHCP/DNS assumptions or a new name-service dependency. A future DNS design would need its own explicit requirements, target capacity, trust, backup, migration and rollback plan.

Historical DNS instructions remain in Git history; this file is not a provisioning procedure.
