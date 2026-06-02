# Dashboard & HMI Interface Data Pack

Reference catalogs and decision aids for dashboards and operator interfaces — Node-RED, custom web,
**industrial SCADA/HMI (e.g. Ignition Perspective)**, and Grafana. Companion to the
[Front-End & HMI Design Workflow](design-workflow.md).

## Platform decision matrix

| Requirement | Platform |
|---|---|
| Fastest dashboard from Node-RED | FlowFuse Dashboard 2.0 |
| Custom branded Node-RED UI | UIBUILDER |
| Product-grade customer dashboard | Next.js / React |
| **True industrial SCADA/HMI** | **Ignition Perspective** |
| Historian / trends / diagnostics | Grafana |
| Admin / configuration tools | Appsmith / ToolJet / Retool |

Node-RED owns integration/routing/transform/protocol-bridge/alarm-event generation; the HMI layer owns
layout/interaction/branding/accessibility/role workflows. Don't push complex UI logic into Node-RED flows
when the dashboard is meant to become a reusable product.

## Component catalog

KPI card · status/equipment card · alarm banner · alarm table · trend chart · gauge · tank/level widget ·
pump/valve/motor widget (command **vs** feedback distinct) · data table · map/site view · timeline ·
control button (review-gated) · setpoint input · health indicator.

## Data-source / protocol catalog

MQTT · REST · WebSocket · InfluxDB · PostgreSQL · Prometheus · OPC UA · Modbus TCP · native HMI tags.

## Metadata + scorecard

- **Metadata tagging schema** for a design reference database (asset/platform/interface/components/criticality/
  data-quality/status …), filed through the existing resource intake — not a parallel store.
- **Dashboard quality scorecard** — score 1–5 across clarity, visual hierarchy, alarm visibility, data trust,
  control safety, responsiveness, performance, consistency, maintainability, reuse value.
  `modernisation_priority = criticality × problem_score × reuse_potential`.

## Best practices

Start from the user **decision**, not the chart type · one purpose per screen · progressive disclosure · real
expected data ranges · always show units · trends for behaviour, tables for exact lookup, KPIs for high-level
decisions only · target devices early; test 390/768/1024/1440 px.

## Industrial / HMI rules

Alarm colours = alarms only · command vs feedback separate · show mode + data quality · never hide critical
alarms behind tabs · confirm dangerous actions · abnormal > normal in visibility · production-gateway import
requires explicit human approval.

See also: [Front-End & HMI Design Workflow](design-workflow.md).
