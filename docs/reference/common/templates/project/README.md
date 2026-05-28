# `<project-slug>`

> Copyright © Verkís internal documentation.

## Purpose
<What this project exists to do, in one paragraph.>

## Owner
<Name and contact. Backup owner.>

## Environment
- Host: `3HS` (Proxmox `https://192.168.x.x:8006`)
- GitLab: `https://192.168.x.x/<group>/<project-slug>`
- Docs portal: `https://192.168.x.x:8443/<project-slug>/`
- NAS path: `/mnt/nas/Verkis-Proxmox-Dev/projects/<project-slug>`
- NAS SMB: `//192.168.x.x/share`

## Status
<dev | staging | production | retired>

## Setup
```bash
git clone https://192.168.x.x/<group>/<project-slug>.git
cd <project-slug>
cp .env.example .env  # then fill in real values
```

## Run
```bash
# project-specific run command
```

## Test
```bash
# project-specific test command
```

## Deployment
<Where it deploys, how it is rolled out, who can approve.>

## Known issues
<Bullet list with links to OPEN_POINTS.md rows.>

## Next actions
<Bullet list with owner and target date.>
