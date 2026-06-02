# Front-End & HMI Design Workflow

How we design and build operator interfaces and front-ends — **industrial HMI/SCADA first**, generic web as
the rapid-prototyping layer. This standard governs *design* work and reuses the existing gates, intake, and
scoring rather than restating them.

## Core principle

```text
Figma        = design authority (tokens, components, flows)
AI agent     = orchestrator + engineer + QA lead
v0           = rapid UI generator (prototype only, never source of truth)
HMI platform = the production target (e.g. Ignition Perspective)
Human review = final approval (mandatory for control + brand + production)
```

Generated UI never becomes the standard by accident — an approved pattern is reviewed, documented, and
promoted into the design system.

## The pipeline

```text
Brief → Figma → v0 prototype → AI refactor + token-align + QA
      → web (Next.js/Storybook) ─┐
      → production HMI view      ─┴→ Playwright/axe/Lighthouse → human review → release
```

The web prototype is exploration; for an HMI deliverable the canonical output is the HMI project itself
(authored per the platform's project-development guide).

## Workflow modes

| Mode | When |
|---|---|
| Fast concept | exploring — discard or promote |
| Production (web) | real software — Figma → impl → tests → review |
| **HMI build** | operator interface — signal list → prototype → HMI view → operator review → gated import |
| Redesign | modernise an old UI |
| Design-system | tokens → components → variants → docs → approved library |

## Quality + human-review gates (reuse, don't reinvent)

Design work passes the existing artifact-creation, red-team, and verification gates, plus design-specific
checks: screen goal + primary action clear; matches the design system; responsive variants defined;
empty/loading/stale/fault/error states present; no critical accessibility violation; for HMI, command vs
feedback separated and abnormal states most visible. A human approves control, brand, customer-facing, and
production work; production-gateway import is gated.

## SCADA / HMI rules (priority)

Alarm colours = alarm states only · command vs feedback separate · show mode (auto/manual/local/remote) +
data quality (live/delayed/stale/offline) · never hide a critical alarm behind a tab · confirm dangerous
actions · abnormal more visible than normal · operator clarity over visual novelty.

## Anti-patterns

Letting a generated draft become the source of truth · pretty-but-unusable screens · generated-code bloat ·
alarm-coloured decoration · controls without confirmation · hidden stale/offline state · a parallel design
registry or intake tree · installing every tool before there are approved examples.

See also: [Dashboard & HMI Data Pack](dashboard-hmi-data-pack.md).
