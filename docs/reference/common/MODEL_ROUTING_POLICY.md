# Model routing policy

> Copyright © Verkís internal documentation. Reviewed 2026-10-07.

Choose capability for the consequence of a mistake, then minimize context and unnecessary work. Model availability comes from the active runtime. A model name in a document does not make that model callable.

## Task routing

| Work | Codex route verified for this workspace | Reasoning effort |
|---|---|---|
| Recovery, storage, security, destructive changes, independent final review | GPT-6 Astra | High |
| Complex GitLab, CI and maintenance implementation under an agreed plan | GPT-6.1 Sol | High |
| Documentation, routine coding and scoped repository updates | GPT-6.1 Sol | Medium |
| Bounded mechanical read-only checks after planning | GPT-6 Luna | High |

These assignments implement the approved October 2026 lab refresh. They are defaults for this workspace, not permanent provider guarantees. Recheck current model availability and official guidance before changing clients or models. Escalate unresolved ambiguity, failed verification and actions crossing a risk boundary. Do not use a lower tier to make storage, security, deletion or recovery decisions.

For Claude Code, use the same task classes with the strongest available model for consequential decisions and a capable execution model for bounded implementation. Resolve the actual model and effort from the installed client's supported configuration and current official documentation. Historical Opus/Sonnet/Haiku and `opusplan` names in dated records describe those sessions; they are not cross-provider configuration values.

## Delegation and context

- The coordinator owns scope, integration and the final result. Give workers disjoint files or services and clear acceptance criteria.
- During this refresh, use at most three workers alongside the coordinator. Parallelize independent inspection and editing; serialize storage changes, credential transitions and publication.
- Send the goal, relevant paths, observed facts, constraints and expected output. Avoid copying the complete conversation into every worker.
- Use deterministic tools for counts, comparisons, syntax and link checks. Do not ask a model to re-read material whose verified summary is sufficient.
- Routine session delegation is not creation of a durable agent artifact. Persistent agents, skills and scripts still follow the artifact gate and canonical registries.
- Preserve decisions, changed files, verification evidence, pending work and authorization in handoffs. Do not treat compacted history as a reason to restart completed work.

## Token and cost reporting

Report measured input/output tokens and cost only when exposed by the runtime. Otherwise use the literal `unknown`. Never estimate or invent accounting. Saving tokens must not weaken recovery or review requirements.

## Sources and maintenance

- [OpenAI model selection](https://learn.chatgpt.com/docs/model-selection)
- [OpenAI best practices](https://learn.chatgpt.com/guides/best-practices)
- [Claude Code best practices](https://code.claude.com/docs/en/best-practices)
- [Claude model configuration](https://code.claude.com/docs/en/model-config)

Checked 2026-10-07. Review quarterly and after a material client/model change. Owner: Lab maintainers. See [context discipline](CONTEXT_DISCIPLINE.md) and [agent operating standard](AGENT_OPERATING_STANDARD.md).
