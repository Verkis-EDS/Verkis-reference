# Template: select or replace a GitLab runner

Owner/date/version/target: complete before execution. Reuse an existing correctly scoped runner whenever possible. The current lab runner/deployment facts are maintained in the manuals GitLab/CI guide, not copied into this generic setup template.

## Prerequisites

Authorized GitLab maintainer/admin access with verified TLS, selected supported executor and signed/version-reviewed installation source, capacity, required tags, secret storage and rollback configuration. Never register by sending credentials through `curl -k` or by printing a token.

## Steps

1. Inspect the existing runner's status, tags, project scope, protection and executor. A queued job may simply be waiting for a matching slot.
2. If replacement is necessary, install the reviewed package through its supported repository/version procedure; do not blindly execute a downloaded shell installer.
3. Obtain the public GitLab certificate through a trusted management path and configure runner TLS trust before registration. Keep authentication material outside Git, docs and logs.
4. Create/register the selected runner using the installed version's supported GitLab UI/instructions. Ordinary jobs use appropriate explicit tags. Deployment uses a project-locked protected runner and production-scoped credentials.
5. Use unprivileged ephemeral containers, pull current pinned images, and do not expose the host Docker socket to jobs. Set source/project access deliberately.

## Verification

Check runner online status and a real project pipeline with matching tags/protection. Verify protected secrets are unavailable to unprotected branches and deployment is gated by successful validation. A runner listing alone does not prove execution.

## Rollback and troubleshooting

Keep the previous runner/configuration until the replacement pipeline succeeds. Disable/revoke only the newly introduced runner if it fails; never export the old config/token into a shared artifact. Check queue, tags, protection, TLS and executor reachability before restart or resource changes.

Official version-matched references: [runner registration](https://docs.gitlab.com/runner/register/), [self-signed certificate trust](https://docs.gitlab.com/runner/configuration/tls-self-signed/), [Docker executor](https://docs.gitlab.com/runner/executors/docker/).
