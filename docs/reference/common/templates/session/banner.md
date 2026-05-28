# Session banner template (v4.0 §2)

> Render via `~/bin/verkis-common banner`. Any unavailable field is printed literally as
> `unknown` — never fabricated, never omitted.

| Field | Value |
|---|---|
| Date (UTC) | `<YYYY-MM-DD HH:MM>` |
| Host | `3HS` |
| Operator | `<name>` |
| Agent | `Claude Code <model-id>` |
| Project | `<slug>` |
| Branch | `<git-branch>` |
| GitLab | `https://192.168.x.x` |
| Docs | `https://192.168.x.x:8443` |
| Proxmox | `https://192.168.x.x:8006` |
| NAS SMB | `//192.168.x.x/share` |
| NAS common | `/mnt/nas/Verkis-Proxmox-Dev/_common` |
| Tokens (in/out) | `<n / m>` or `unknown` |
| USD cost | `$<x.xx>` or `unknown` |
| Session ID | `<uuid>` |

Copyright © Verkís internal documentation.
