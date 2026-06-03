# Ignition Perspective HMI Screen Template

> Copyright © Verkís internal documentation.

A starting structure for a Verkís Perspective operator screen (the lab's primary HMI target). Build mechanics
(headless `view.json`, `onStartup` tag bootstrap, `onClick` control, symbols, auto-scale) are in
`lab-manuals/docs/ignition/{project-development,perspective-ui-design-guide,mvp-demo-project}.md`. Design
rules: [`../../DESIGN_WORKFLOW_STANDARD.md`](../../DESIGN_WORKFLOW_STANDARD.md) §SCADA.

## Screen contract
- **Area / route:** `views/<area>/<name>` → page `/＜route＞`  · **User:** operator / engineer
- **Primary purpose:** ＜the one decision this screen supports＞
- **Signal/tag list:** `[default]<provider>/<system>/*` (demo only in dev; no prod/PLC/client tags)

## Required regions
| Region | Content |
|---|---|
| Header | system name · live clock · **state badge** (tag-bound colour) |
| Nav | page buttons (`onClick` → `system.perspective.navigate`) |
| Process / mimic | symbols (tank fill / pump / valve) bound to tag state |
| KPIs | value tiles (units, format) bound to tags |
| Alarm strip | highest-priority alarm; impossible to miss; `alarm_high` bound |
| Controls | start/stop/open/close (`onClick` scope `G` → `system.tag.writeBlocking`) — **human-review gated** |
| Footer / health | last update · data-quality / stale indicator |

## Mandatory states & rules
- [ ] Empty / loading / stale / offline / fault states present.
- [ ] Alarm colours = alarm states only; abnormal more visible than normal.
- [ ] Command vs feedback separated; mode (auto/manual/local/remote) shown.
- [ ] Auto-scale (root coord container `mode: fixed`).
- [ ] Dangerous actions confirmed; tag mapping human-verified.
- [ ] Each `views/<x>/` folder has `resource.json` `{"scope":"G","version":1,"restricted":false,"overridable":true,"files":["view.json"],"attributes":{}}` (or the loader silently skips it).
- [ ] Production-gateway import is gated (`TASK_INGESTION_PROTOCOL.md` §17.5).
