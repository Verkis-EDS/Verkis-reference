# Dashboard / HMI Quality Scorecard — &lt;asset name&gt;

> Copyright © Verkís internal documentation.

Template for scoring a dashboard or HMI. Canonical rubric: [`../../DASHBOARD_HMI_DATA_PACK.md`](../../DASHBOARD_HMI_DATA_PACK.md).
Score each 1–5. Model any scoring engine on `scripts/session_quality.py` — do not build a parallel one.

- **Asset:** &lt;id / name&gt;  · **Platform:** &lt;ignition-perspective / nextjs / …&gt;  · **Reviewer:** &lt;name&gt; · **Date:** &lt;YYYY-MM-DD&gt;

| Category | Score 1–5 | Note |
|---|---:|---|
| Clarity — status understood in 5 s | | |
| Visual hierarchy — important items prioritised | | |
| Alarm visibility — abnormal states obvious | | |
| Data trust — stale/offline/bad visible | | |
| Control safety — commands protected + clear | | |
| Responsiveness — works on target devices | | |
| Performance — loads/updates efficiently | | |
| Consistency — follows the design system | | |
| Maintainability — extensible cleanly | | |
| Reuse value — can become a template | | |

- **criticality:** low / medium / high / safety-critical
- **problem_score** (1–5, severity of issues): &lt;n&gt;
- **reuse_potential:** low / medium / high
- **modernisation_priority = criticality × problem_score × reuse_potential** = &lt;n&gt;
- **Human review required:** yes (mandatory for any control / alarm-priority / production screen)
- **Verdict:** approved / needs-rework / rejected — &lt;notes&gt;
