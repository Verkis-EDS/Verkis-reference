# Workspace Gatekeeper

> Copyright © Verkís internal documentation.

Entry point to the workspace governance process. This page is **navigation +
glue**, not a parallel rulebook. Every rule referenced here lives in another
file in `_common/` — follow the link. Net-new content (registries, AI-assistant
prompt, hygiene template, setup checklist) lives in the sibling folders.

## Purpose

Prevent unnecessary complexity entering the Verkís lab workspace. Every
proposed add-on — agent, skill, script, tool, MCP, service, template,
workflow, memory file, doc structure — must clear a Gatekeeper review before
it becomes shared infrastructure.

Default position:

> Do not add it unless the value is clear, the implementation is simple, and
> the result is verifiable.

Prefer:

| Prefer | Instead of |
|---|---|
| Checklist | New agent |
| Template | New tool |
| Script | New service |
| Sandbox | Shared production setup |
| Documentation | Hidden automation |
| GitLab issue | Memory file |
| Verification test | Assumption |
| Existing tool | Duplicate tool |
| Simple workflow | Complex orchestration |

## Where the rules already live

Most of the original Gatekeeper proposal is already implemented elsewhere in
`_common/`. Read the canonical file rather than re-stating the rule here.

| Topic | Canonical file |
|---|---|
| Default position, core principles, preferences | [`../RULES.md`](../RULES.md) |
| Planning Mode preamble | [`../PLANNING_MODE.md`](../PLANNING_MODE.md) |
| 12-question redteam checklist | [`../REDTEAM_REVIEW.md`](../REDTEAM_REVIEW.md) |
| Approval scoring + decision threshold for new artifacts | [`ARTIFACT_CREATION_GATE.md`](ARTIFACT_CREATION_GATE.md) |
| Memory file creation rules | [`MEMORY_CREATION_GATE.md`](MEMORY_CREATION_GATE.md) |
| Context / project-isolation rules | [`CONTEXT_CREATION_GATE.md`](CONTEXT_CREATION_GATE.md), [`../CONTEXT_DISCIPLINE.md`](../CONTEXT_DISCIPLINE.md) |
| Master runbook + session model | [`../RUNBOOK_MASTER_v4.md`](../RUNBOOK_MASTER_v4.md), [`../SESSION_CLOSEOUT.md`](../SESSION_CLOSEOUT.md) |
| Verification standard | [`../TEST_VERIFY_STANDARD.md`](../TEST_VERIFY_STANDARD.md) |
| Model routing for review | [`../MODEL_ROUTING_POLICY.md`](../MODEL_ROUTING_POLICY.md) |
| Front-end & HMI design workflow (Ignition-first) | [`../DESIGN_WORKFLOW_STANDARD.md`](../DESIGN_WORKFLOW_STANDARD.md) |
| Dashboard/HMI catalogs + quality scorecard | [`../DASHBOARD_HMI_DATA_PACK.md`](../DASHBOARD_HMI_DATA_PACK.md) |

If you came here from the original 29-section "Workspace Gatekeeper" prompt,
the section→file mapping is:

| Original section | Lives at |
|---|---|
| §Role, §Core Principles, §Default Position, §Final Instruction | `RULES.md` |
| §Planning Mode | `PLANNING_MODE.md` |
| §Redteam Review | `REDTEAM_REVIEW.md` |
| §Approval Rules, §Scoring Model, §Decision Threshold, §Required Output Format | `governance/ARTIFACT_CREATION_GATE.md` |
| §Memory Management Rules | `governance/MEMORY_CREATION_GATE.md` |
| §Agent Creation Rules, §Tool Addition Rules | `governance/ARTIFACT_CREATION_GATE.md` (same rubric, type filter) |
| §Workflow Cleanliness Rules | `RUNBOOK_MASTER_v4.md` §workflows |
| §Add-on / Agent / Skill Registry | `governance/registries/` (this folder, net-new) |
| §Gatekeeper Agent Prompt | `governance/prompts/workspace-gatekeeper-agent.md` (net-new) |
| §Periodic Review, §Hygiene Review | `governance/hygiene/hygiene-review-template.md` (net-new) + `verkis-common stale-review` |
| §Setup Instructions, §Folder Structure, §MkDocs Navigation | `governance/SETUP_CHECKLIST.md` (net-new, reality-matched) |
| §GitLab Issue Template | deferred — file as a follow-up if needed |
| §Verification Scripts | `verkis-common verify`, `memory-lint`, `stale-review` (already wired) |

## How to run a review

Three steps. Use the existing wrapper — do not invent a parallel flow.

1. **File the proposal**
   ```bash
   verkis-common intake "<title>" "<source>" "<owner>" "<confidence>" <summary-file>
   ```
   The intake lands under `governance/requests/` (one file per proposal).

2. **Run the right gate**
   - New agent / skill / script / template → `governance/ARTIFACT_CREATION_GATE.md`,
     scored via:
     ```bash
     verkis-common gate -- --type {skill|agent|script|memory|template} --name <slug> --purpose "<one sentence>"
     ```
   - New memory file → `governance/MEMORY_CREATION_GATE.md`.
   - New shared context / cross-project material → `governance/CONTEXT_CREATION_GATE.md`.
   - Destructive or shared-state change → `REDTEAM_REVIEW.md` 12-question
     checklist is **mandatory** in addition to the gate above.

3. **Record the decision**
   Write a short review under `governance/reviews/YYYY-MM-DD-<slug>.md` with:
   decision (Approve / Approve lightweight / Defer / Reject / Replace),
   reason, minimum viable implementation, verification test, rollback plan,
   documentation location. Add the resulting artifact to the appropriate
   registry under `governance/registries/`.

## Registries

Tracking tables for everything that survives a Gatekeeper review. One file
per type. See [`registries/README.md`](registries/README.md) for the column
schema and rules.

- [`registries/workspace.md`](registries/workspace.md) — top-level rollup
- [`registries/agents.md`](registries/agents.md)
- [`registries/tools.md`](registries/tools.md)
- [`registries/skills.md`](registries/skills.md)
- [`registries/scripts.md`](registries/scripts.md)
- [`registries/workflows.md`](registries/workflows.md)
- [`registries/memory.md`](registries/memory.md)

## AI-assistant Gatekeeper prompt

When you want an LLM session to act as the Gatekeeper reviewer:
[`prompts/workspace-gatekeeper-agent.md`](prompts/workspace-gatekeeper-agent.md).

The prompt is intentionally short: it loads context by reading `RULES.md`,
`REDTEAM_REVIEW.md`, and the relevant `*_CREATION_GATE.md` rather than
re-stating the rules. That way the prompt and the canonical files cannot
drift apart.

## Hygiene review

Run monthly, or after large changes. Template + log live under
[`hygiene/`](hygiene/). The existing `verkis-common stale-review` does the
mechanical part (entries past their review date); the template captures the
keep / simplify / merge / archive / delete judgement.

## Setup

The folder layout, NAS paths, MkDocs nav, and Git remotes the original
proposal describes are **already in place**. See
[`SETUP_CHECKLIST.md`](SETUP_CHECKLIST.md) for the reality-matched checklist
and any remaining gaps.

## Out of scope (deferred)

These were in the original proposal but are not part of this rollout:

- A GitLab issue template for proposals — useful, but belongs in GitLab admin.
  File as a follow-up if the intake CLI proves insufficient.
- A migration of the existing `ARTIFACT_CREATION_GATE.md` rubric to the
  proposal's 1–5 scoring model. Different rubrics. Needs its own decision.
- Dashboards, databases, or automation agents for the registry. The
  proposal itself (§27, §29) says Markdown first — defer everything else
  until the manual version has been used on three real proposals.
