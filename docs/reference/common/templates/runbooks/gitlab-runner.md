> Source-of-truth: `verkis-lab/proxmox-manager:/runbooks/gitlab-runner.md` on host `3HS`. NAS copy synced 2026-05-28.

# Runbook: GitLab Runner (`gitlab-runner01`)

CI runner registered against `https://gitlab.verkis.internal`. Docker executor, default image
`python:3.12-slim`, tags `docker,python`, `run_untagged=true`. Lives on VM **102** (`192.168.x.x`).

## Re-create / replace

```bash
# 1) Install Docker + gitlab-runner on the VM (Ubuntu 24.04)
sudo apt-get update && sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc >/dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable" | sudo tee /etc/apt/sources.list.d/docker.list
curl -fsSL https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin gitlab-runner

# 2) Trust the self-signed cert proxy01 uses for gitlab.verkis.internal
sudo mkdir -p /etc/gitlab-runner/certs
sudo scp root@192.168.x.x:/etc/nginx/ssl/gitlab.verkis.internal.crt \
  /etc/gitlab-runner/certs/gitlab.verkis.internal.crt
sudo chmod 644 /etc/gitlab-runner/certs/gitlab.verkis.internal.crt

# 3) Create the runner in GitLab (admin) and get the auth token
#    GUI: Admin Area → CI/CD → Runners → New instance runner
#    Or API (admin PAT, scope=api):
#    curl -sk --resolve gitlab.verkis.internal:443:192.168.x.x \
#         -H "PRIVATE-TOKEN=<REDACTED>" \
#         -X POST https://gitlab.verkis.internal/api/v4/user/runners \
#         --data runner_type=instance_type \
#         --data-urlencode description=gitlab-runner01 \
#         --data-urlencode tag_list=docker,python \
#         --data run_untagged=true --data locked=false
#    → returns token starting with glrt-...

# 4) Register
sudo gitlab-runner register --non-interactive \
  --url https://gitlab.verkis.internal --token glrt-... \
  --executor docker --docker-image python:3.12-slim --docker-pull-policy if-not-present \
  --description gitlab-runner01

# 5) Verify
sudo gitlab-runner list
sudo gitlab-runner verify
```

In GitLab: **Admin Area → CI/CD → Runners** — the runner appears as online.
Config (with token) is at `/etc/gitlab-runner/config.toml`; back this up if mirroring elsewhere.

## Test pipeline
Add to any project's `.gitlab-ci.yml`:
```yaml
hello:
  image: python:3.12-slim
  script:
    - python -c "print('runner ok')"
```
Push → pipeline picks up on `gitlab-runner01`.
