# v0 Prompt Template

> Copyright © Verkís internal documentation.

For generating a front-end *prototype* with v0 (Vercel). The prototype is exploration only — Figma is the
design authority and a human review + the gates own promotion to production (see
[`../../DESIGN_WORKFLOW_STANDARD.md`](../../DESIGN_WORKFLOW_STANDARD.md)). For an HMI deliverable, treat the
v0 output as a reference to translate into an Ignition Perspective view, not as the shipped artifact.

```md
Create a production-quality front-end screen using React, TypeScript, Tailwind CSS, and shadcn/ui.

Screen:        [screen name]
Target user:   [operator / engineer / manager / customer]
Main goal:     [the one decision/action this screen supports]

Requirements:
- Follow the provided design-system tokens (Verkís palette per RULES.md Branding).
- Clear layout hierarchy; one primary action.
- Accessible components (keyboard, labels, contrast); no colour-only meaning.
- Responsive for mobile / tablet / desktop (390 / 768 / 1440 px).
- Realistic placeholder data at real volume; show empty / loading / stale / error states.
- Reusable components; avoid unnecessary animation.

Style direction: [brand / visual tone]
For HMI: alarm colours for alarms only; command vs feedback separate; show data quality + mode.

Output:
- Single screen implementation
- Component structure suggestion
- Notes on responsive behaviour and on the Perspective-translation (for HMI screens)
```
