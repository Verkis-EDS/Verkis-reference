# PROJECT_MEMORY — `<project-slug>`

> Copyright © Verkís internal documentation. Long-lived project context that an agent loads at
> session start.

## Current Objective
<What this project is trying to achieve in the current milestone.>

## Current State
<Where the project is right now: deployed components, branch under work, last verified-good
commit, last successful pipeline.>

## Infrastructure
- Proxmox host: `3HS` (`https://192.168.x.x:8006`)
- Guests in use: `<list IDs + names>`
- Storage: `<local-lvm | usb-lvm | NAS>`
- Network: `<bridges, IPs, ports>`

## GitLab
- Project URL: `https://192.168.x.x/<group>/<project-slug>`
- Default branch: `main`
- Runner: `gitlab-runner01` (tags `docker,python`)
- Protected branches / tags: `<list>`

## NAS Location
- Project tree: `/mnt/nas/Verkis-Proxmox-Dev/projects/<project-slug>`
- Shared artifacts: `<sub-paths used>`

## MkDocs
- Local serve: `mkdocs serve -a 0.0.0.0:8000`
- Portal entry: `https://192.168.x.x:8443/<project-slug>/`

## Key Decisions
<Pointers to DECISIONS.md rows; do not duplicate the table here.>

## Known Issues
<Pointers to OPEN_POINTS.md rows.>

## Next Actions
<Top 3 next moves with owner.>
