# Workspace Gatekeeper

Entry point for every proposed addition to shared infrastructure — agents,
skills, scripts, tools, MCPs, services, templates, workflows, memory files,
documentation structures.

## Default position

> Do not add it unless the value is clear, the implementation is simple, and
> the result is verifiable.

Prefer the smallest solution that works. Prefer reuse over create. Prefer
documentation over hidden automation. Prefer a sandbox over shared
production.

## How a review runs

1. **File the proposal.** A short summary: what problem it solves, who owns
   it, where it would live, how it will be verified, how it will be removed.
2. **Run the right gate.** The relevant `*_CREATION_GATE.md` carries the
   scoring rubric and decision threshold.
3. **Apply the redteam.** The 12-question checklist is mandatory for any
   destructive or shared-state change.
4. **Record the decision.** Approve / Approve lightweight / Defer / Reject /
   Replace existing. Add the resulting artifact to the matching registry.

## What every approved artifact must have

- A named owner — not "the team".
- A one-sentence purpose.
- A verification command or steps that prove it works.
- A documented rollback path.
- A registry row pointing back to the review file.
- A review date to drive the next hygiene sweep.

## Why a Gatekeeper

Every new artifact carries a maintenance cost. Most one-off needs are better
served by a session note. The Gatekeeper makes the cost visible *before*
commit so the workspace does not silently become bloated, fragile, or
expensive to maintain.

## Related

- [Planning Mode](planning-mode.md)
- [Red-Team Review](redteam-review.md)
- [Context and Memory Policy](context-memory-policy.md)
- [Task Workflow](task-workflow.md)
- [Public Safety Rules](public-safety-rules.md)
