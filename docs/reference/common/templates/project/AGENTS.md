# Project instructions

Read README.md for this project's tool/use-case scope and RUNBOOK.md for verified commands. Read the canonical Common Ops policy and the AI Practice Hub references as needed; explicit user authorization and runtime boundaries remain authoritative.

At session start, after each meaningful slice and at handoff, follow Common Ops Git discovery and updates. Confirm the actual repositories/remotes and reuse canonical source; preserve unrelated work in existing checkouts and use a dedicated task worktree. Maintain `spec/repository-map.csv`, cross-repository release pins and `handoff/STATUS.md`. Stage explicit paths, run actual project checks and content secret scanning, and push/open MRs only within existing authorization. A passing scaffold check is not a deployment or recovery proof. Git isolation does not replace the shared Gateway write lock.

Keep this entrypoint thin. Reuse shared templates/skills/tools rather than copying global policy or installing every catalog item. Save only authorized, relevant evidence; provider-owned memory is updated only when explicitly requested.
