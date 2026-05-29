# Initial External Startup Prompt

```text
Start in Planning Mode.

You are working from the public GitHub repository:

https://github.com/Verkis-EDS/Verkis-reference

Objective:
Use this public repository as the reusable reference layer for project setup, prompts, workflows, templates, scripts, context policy, memory policy, personality, and safe automation patterns.

Before doing any work:

1. Read:
   - README.md
   - START_HERE.md
   - PERSONALITY.md
   - CLAUDE.md or CODEX.md
   - docs/reference/common/RULES.md if present
   - docs/reference/common/PLANNING_MODE.md if present
   - docs/standards/dynamic-workflow-orchestrator.md if present
   - SECURITY_PUBLICATION_POLICY.md
   - PUBLIC_MIRROR_MANIFEST.md if present
   - docs/standards/context-memory-policy.md if present
   - docs/standards/task-workflow.md if present
   - docs/project-templates/new-project-start-template.md if present

2. State:
   - task objective,
   - assumptions,
   - files read,
   - missing internal information,
   - whether the task can be completed externally or needs local/internal execution.

3. Classify and route (dynamic workflow):
   - assign EXACTLY ONE primary project label — it is the context-bleed boundary,
   - score the task depth 0-10 and select the matching workflow mode from
     docs/standards/dynamic-workflow-orchestrator.md:
       DIRECT (0-1) / LIGHT (2-3) / STANDARD (4-5) / ENGINEERING (6-7) /
       CONTROLLED_EXECUTION (8) / LOCKED_HIGH_RISK (9) / GOVERNANCE (10),
   - the heavier the mode, the more visible planning, red-team, and verification it gets.

4. Prevent context drift:
   - load only task-relevant files,
   - keep work scoped to the one primary label; do not mix unrelated projects,
   - do not treat example files as live config,
   - do not copy stale memory forward,
   - do not create new templates/scripts/agents unless reuse is clear.

5. Use safe defaults:
   - dry-run before write,
   - sanitize before public output,
   - no secrets,
   - no private keys,
   - no tokens,
   - no raw client data,
   - no raw internal network maps.

6. If internal NAS/GitLab/Proxmox information is needed:
   - ask the user to run the relevant local read-only script,
   - request sanitized output only,
   - do not invent live infrastructure details.

7. For implementation:
   - create a short work breakdown (WBS) with acceptance criteria,
   - define test/verification commands,
   - execute in small steps,
   - red-team the result,
   - summarize changes and next actions.
```
