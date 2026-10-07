# Reusable templates and initial workspace setup

Existing locations serve reusable setup needs; there is no competing setup tree. These are editable scaffolds, not auto-approved deployments or a tool-install bundle.

| Location | Use |
|---|---|
| `templates/project/` | Project README, shared agent entrypoint, ignored environment example, runbook, repository-map and handoff stubs, memory/log stubs and optional MkDocs scaffold |
| `templates/governance/` | Task intake, ADR and red-team review |
| `templates/runbooks/` | Generic bounded operational procedures; lab-specific guides remain in manuals/proxmox-manager |
| `templates/prompts/` | Session-opening patterns respecting the active task and existing authorization |
| `templates/session/` | Session closeout evidence |
| `agents/templates/`, `skills/templates/` | Existing reusable agent/skill formats; creation still requires applicable governance |

See [workspace setup](../WORKSPACE_SETUP.md) for prerequisites, commands, expected results, conflicts, rollback and verification. Discover reusable skills/tools and official provider guidance through the AI Practice Hub (internal service; use the private workspace guide).

## Reuse workflow

1. Inspect the current project and choose the closest existing template or approved starter kit.
2. Copy only the relevant files into a new workspace or dedicated task worktree. Replace placeholders and assign an owner; never overwrite an existing configuration to match a template.
3. Define actual tests and a scoped CI pipeline. Shared main branches use MRs and require successful pipelines; skipped CI is not successful validation.
4. Review changes, verify behavior, then merge. Update the reusable source only when the improvement is useful across projects; do not propagate personal/client content into shared templates.
5. Refresh source references when canonical behavior changes; preserve source provenance and dated execution evidence.
