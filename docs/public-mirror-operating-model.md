# Public Mirror Operating Model

This repository gives external AI tools enough context to work effectively without direct access to private systems.

| Layer | Internal | Public mirror |
|---|---|---|
| Source control | GitLab | GitHub sanitized mirror |
| Runtime files | NAS | Templates and summaries |
| Infrastructure | Proxmox | Generic setup guidance |
| Documentation | MkDocs internal | Public-safe docs |
| Secrets | Secret manager only | Never |
| Memory | NAS common memory | Public context policy and sanitized examples |
