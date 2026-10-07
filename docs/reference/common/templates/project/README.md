# <project-slug>

## Purpose and scope

Describe this project's tool/use case, expected behavior and excluded systems. Shared AI guidance belongs in the AI Practice Hub (internal service; use the private workspace guide); operating policy and reusable templates belong in Common Ops. Do not copy shared policy into this repository.

## Owner and status

- Owner and backup owner: to be assigned.
- Status: draft scaffold; no deployment, organization approval or successful tests implied.
- Source templates: Common Ops `templates/project/` and `.common-ops-bootstrap.json` when scaffolded by its helper.

## Initial setup

1. Inspect the existing repository, instructions and working tree before making changes.
2. Complete this README and `RUNBOOK.md`; choose only the tools required by this use case.
3. Inspect `.env.example`. Create local secret configuration only if the application requires it; it is never committed or copied to NAS/shared docs.
4. Define actual build/test commands and a matching protected CI pipeline. Use an existing authorized starter kit when appropriate; do not install the entire shared catalog.
5. Create a focused branch/MR. Clone an initialized GitLab default branch before integrating a standalone scaffold; do not push unrelated scaffold history directly onto protected main.

## Build and test

Document version-pinned requirements and the actual commands/results for this project. Placeholder files and a successful syntax check do not prove application behavior.

## Deployment and recovery

Document target, trust/access requirements, backup, acceptance tests, rollback and owner. Shared lab address allocation is in the canonical manuals access table, not this generic template. New project docs do not acquire a portal route automatically.

## Known issues and next actions

Maintain `OPEN_POINTS.md`, `DECISIONS.md` and the project-specific runbook. Keep dated evidence without inventing review or approval dates.
