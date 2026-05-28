# Lab Status

_Last reviewed: 2026-05-28._

A high-level, **sanitized** snapshot of the Verkís Proxmox development lab.
Internal infrastructure detail — addresses, host inventory, and security
configuration — is kept private per the
[Public Safety Rules](standards/public-safety-rules.md). This page carries
only public-safe posture.

## Snapshot

| Area | State |
|---|---|
| Platform | Single bare-metal Proxmox VE node (no cluster, no hardware redundancy) |
| Workloads | Internal Git hosting, CI runner, project tracker, docs portal, reverse proxy, utility containers |
| Documentation | MkDocs manuals plus a common operating / governance layer, actively maintained |
| Source control | Internal Git is the source of truth; this public mirror is sanitized and read-only |
| Health scorecard | **Amber** — compute and storage healthy; one standing risk (see below) |

## Operating posture

- **Plan → inspect → back up → change minimally → verify → document.** No prompt-to-execution.
- **Current-state first:** observed reality outranks memory or documentation.
- Standards live in the [Common Operating Layer](reference/common/RULES.md); this
  mirror exposes the reusable, non-secret subset for external AI-assisted work.

## Focus areas

1. **Backup resilience (top priority).** Standing up an off-host backup target and
   a tested restore drill. Tracked internally as an architecture decision pending a
   hardware choice. Until a restore is verified end-to-end, restored workloads are
   treated as evaluation-only.
2. **Source-control consolidation.** Bringing remaining local management history
   under internal Git hosting.
3. **Resilience hygiene.** A lightweight snapshot policy, scheduled maintenance
   windows, and clearing minor configuration drift.

## Intentionally not published here

Per the [publication policy](standards/public-safety-rules.md), this mirror excludes
raw infrastructure inventory, network maps, credentials, and security configuration.
Internal status lives on the private Git host and NAS common layer.
