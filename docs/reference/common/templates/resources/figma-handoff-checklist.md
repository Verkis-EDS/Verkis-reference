# Figma → Implementation Handoff Checklist

> Copyright © Verkís internal documentation.

Before a Figma frame is implemented (web or Perspective). See
[`../../DESIGN_WORKFLOW_STANDARD.md`](../../DESIGN_WORKFLOW_STANDARD.md).

- [ ] Tokens/variables used for colour, spacing, typography (no ad-hoc values).
- [ ] Components built before pages; variants cover default / hover / disabled / loading / error.
- [ ] Auto Layout used consistently; layers named clearly.
- [ ] Mobile / tablet / desktop variants present (or N/A stated).
- [ ] Intended behaviour documented, not just visuals (interactions, data binding, states).
- [ ] Empty / loading / stale / fault / offline states designed.
- [ ] For HMI: alarm colours = alarms only; command vs feedback distinct; mode + data-quality shown;
      abnormal states more visible than normal; controls flagged for human safety review.
- [ ] Brand fits `RULES.md` Branding; no alternative palette introduced.
- [ ] Acceptance criteria written (primary action, breakpoints, a11y, no secrets/customer data).
- [ ] Signal/tag list approved (HMI) and data sources confirmed.
- [ ] Git branch created; gateway backup/snapshot decision made (HMI).
