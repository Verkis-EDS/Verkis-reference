# Workspace and initial setup

Owner: Lab maintainers. Checked: 2026-10-07. Scope: reusable workstation/project setup; no guest provisioning or blanket tool installation. Templates remain drafts until a project owner fills and verifies them.

## Canonical locations

| Purpose | Location |
|---|---|
| Shared operating source | GitLab `verkis-lab/verkis-proxmox-dev-common-ops`; deployed NAS checkout `/mnt/nas/Verkis-Proxmox-Dev/_common` |
| Shared AI/provider and skills/tools guidance | GitLab AI Practice Hub (`verkis-lab/eythor-ai-operating-system`) |
| Existing reusable templates | `templates/` ([index](templates/README.md)); `agents/templates/`, `skills/templates/` |
| Project authoring workspace | User-local `~/Projects/PROJECT`; existing projects retain their actual checkout |
| Optional NAS project counterpart | `/mnt/nas/Verkis-Proxmox-Dev/projects/PROJECT` |
| Infrastructure management | `/root/proxmox-manager` on 3HS |
| Manuals authoring | `/root/work/lab-manuals`; protected CI publishes `https://192.168.x.x:8443` |

No internal DNS is required. The canonical manuals access table owns static IP allocation; do not copy a lab topology into reusable templates or allocate from remembered free addresses.

## Prerequisites

Use an authorized account and trusted GitLab TLS/SSH. Obtain the public lab CA/host keys through the documented trusted management path; never disable verification to send credentials. Git, Bash, Python 3 and coreutils are needed for these helpers; install only missing approved dependencies through the workstation's normal package policy. Skills, MCP integrations and provider clients are selected by the actual task, not installed as a bundle.

For NAS-backed setup, confirm the share is mounted and the existing projects root is reachable/writable. If NAS is unavailable, stop or explicitly choose local-only creation; the script must not create a fake NAS mount path. Follow the AI hub start here (internal service; use the private workspace guide) for current provider setup and source-linked recommendations.

## Inspect and install the dispatcher

From a trusted clean Common Ops checkout:

```bash
git status --short
git log -1 --oneline
bash scripts/install_claude_common.sh
~/bin/verkis-common help
~/bin/verkis-common where
~/bin/verkis-common banner
```

The installer copies the **existing dispatcher** from `scripts/verkis-common-wrapper.sh` into a regular local executable. It never creates a recursive NAS symlink, writes source files, installs skills or edits Claude/Codex settings. With a noncanonical checkout set `NAS_COMMON` to that inspected checkout; `BINDIR` selects the user-local destination.

Expected: new install succeeds; repeated same-content installation reports unchanged. An existing different executable, symlink or inaccessible source is a conflict and remains intact. Inspect/backup such a file and review the candidate before a manual replacement; do not delete a user configuration just to make the installer succeed. The installed `help` and `where` commands work while NAS is unavailable; NAS-backed commands fail with a specific fallback notice.

The banner reports active-project MkDocs separately from `/root/work/lab-manuals`. An infrastructure checkout lacking `mkdocs.yml` is not evidence that canonical manuals are missing.

## Start or reuse a project

For an existing project, inspect its README, thin instructions, runbook and working tree; copy only relevant template improvements on a feature branch. The bootstrap helper deliberately refuses unrelated existing local/NAS workspaces.

For a new standalone workspace:

```bash
~/bin/verkis-common bootstrap example-project verkis-lab
# Deliberate workstation-only alternative:
~/bin/verkis-common bootstrap example-local-project verkis-lab --local-only
```

Expected: a clean tracked templates/project source is reused (ignored/untracked files are excluded), placeholders receive the slug/group, optional NAS directories are created, and `.common-ops-bootstrap.json` records source provenance. No Git initialization, commit, push, guest creation, service deployment or tools/settings install occurs. Repeating the same completed invocation preserves all files, including subsequent user edits. Invalid names, missing templates/NAS root, symlinked paths and existing unrelated destinations fail before overwrite. A failed incomplete setup remains visible for operator review, never mislabeled successful.

Complete ownership, use-case scope, actual test commands and recovery in the scaffold. Optional MkDocs files do not automatically create a portal route. Keep real credentials outside Git and shared NAS plaintext; the example environment file contains no credentials.

## Integrate into GitLab safely

Use an existing authorized starter kit or create/initialize the GitLab project through its supported UI/API. Clone its real default branch with verified trust; create a focused setup branch and bring only reviewed scaffold files into that clone. Do not force-push unrelated scaffold history or push directly to protected main.

```bash
git status --short
git fetch origin
git switch -c setup/initial-workspace origin/main
# Copy only the selected reviewed files; define project-specific CI/tests.
git diff --check
git add path/to/reviewed/file
git diff --cached --stat
git commit -m "Initialize reviewed project workspace"
git push -u origin setup/initial-workspace
```

Replace the example staged path with actual reviewed files. CI must match the implementation, use appropriate runner tags, pin the required runtime/dependencies and avoid secrets in logs/artifacts. Protected main requires a successful pipeline and resolved discussions; skipped CI is not a validation result. Manuals deploy through their protected immutable-artifact pipeline, not working-tree rsync.

## Verification, rollback and troubleshooting

Run the relevant helper tests, `bash -n`, project tests and the current MR pipeline. Inspect resulting paths and prove existing user files/configurations stayed unchanged. Keep failures and untested behavior explicit.

The installer rollback is to restore the reviewed previous local dispatcher. A new scaffold has no deployed service to roll back: retain it for review or remove only that specifically identified unused new workspace after checking for user edits. Do not recursively delete existing NAS data. Source changes revert through an MR; regenerate derived portal/public references from the resulting merged source pin.

| Problem | Action |
|---|---|
| Installer conflict | Preserve the existing file; compare trusted candidate and choose a reviewed replacement |
| NAS inaccessible | Repair authorized mount access or explicitly choose local-only creation |
| Workspace already exists | Reuse it through a feature branch; bootstrap never overwrites it |
| MkDocs absent in PM | Check canonical standalone manuals path; do not recreate an embedded tree |
| Runner job pending | Check required tags/protection and queue; do not bypass merge gates |
| Setup appears to work but service fails | Scaffold creation is not a runtime deployment or recovery proof |
