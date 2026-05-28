#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="${REPO_DIR:-$HOME/Projects/Verkis-reference}"
NAS_COMMON="${NAS_COMMON:-/mnt/nas/Verkis-Proxmox-Dev/_common}"
WORK_DIR="${WORK_DIR:-$REPO_DIR/.mirror-work}"
STAGING_DIR="$WORK_DIR/staging"
PUBLIC_BUILD_DIR="$WORK_DIR/public-build"
PUSH="${PUSH:-0}"

echo "=== Verkís Public Mirror Sync ==="
echo "Repo:       $REPO_DIR"
echo "NAS_COMMON: $NAS_COMMON"
echo "PUSH:       $PUSH"

cd "$REPO_DIR"

mkdir -p "$STAGING_DIR" "$PUBLIC_BUILD_DIR"
rm -rf "$STAGING_DIR" "$PUBLIC_BUILD_DIR"
mkdir -p "$STAGING_DIR" "$PUBLIC_BUILD_DIR"

echo "=== Current status ==="
git status --short
git remote -v

echo "=== Gather allowlisted reusable material ==="
if [ -d "$NAS_COMMON" ]; then
  mkdir -p "$STAGING_DIR/common"

  for f in \
    RULES.md \
    PLANNING_MODE.md \
    AGENT_OPERATING_STANDARD.md \
    MODEL_ROUTING_POLICY.md \
    REDTEAM_REVIEW.md \
    TEST_VERIFY_STANDARD.md \
    SESSION_CLOSEOUT.md \
    CONTEXT_DISCIPLINE.md \
    SETUP_STATUS_CHECK.md \
    RUNBOOK_MASTER_v4.md \
    memory/MEMORY_POLICY.md \
    governance/ARTIFACT_CREATION_GATE.md \
    governance/MEMORY_CREATION_GATE.md \
    governance/CONTEXT_CREATION_GATE.md \
    agents/AGENT_REGISTRY.md \
    skills/SKILL_REGISTRY.md
  do
    if [ -f "$NAS_COMMON/$f" ]; then
      mkdir -p "$STAGING_DIR/common/$(dirname "$f")"
      cp "$NAS_COMMON/$f" "$STAGING_DIR/common/$f"
      echo "Copied: $f"
    else
      echo "Missing: $f"
    fi
  done

  for d in templates agents/templates skills/templates; do
    if [ -d "$NAS_COMMON/$d" ]; then
      mkdir -p "$STAGING_DIR/common/$d"
      rsync -a \
        --exclude='.git/' \
        --exclude='*.env' \
        --exclude='*.key' \
        --exclude='*.pem' \
        --exclude='*secret*' \
        --exclude='*token*' \
        "$NAS_COMMON/$d/" "$STAGING_DIR/common/$d/" || true
    fi
  done
else
  echo "WARN: NAS common path not found. Syncing only existing public repo files."
fi

echo "=== Sanitize ==="
python3 scripts/sanitize_public_mirror.py --source "$STAGING_DIR" --dest "$PUBLIC_BUILD_DIR" --strict

echo "=== Install sanitized reference output ==="
mkdir -p docs/reference/common
if [ -d "$PUBLIC_BUILD_DIR/common" ]; then
  rsync -a "$PUBLIC_BUILD_DIR/common/" docs/reference/common/
fi

bash scripts/sync_personality.sh

cat > PUBLIC_MIRROR_MANIFEST.md <<EOF
# Public Mirror Manifest

Generated: $(date -u +"%Y-%m-%d %H:%M UTC")

## Purpose

Sanitized public reference mirror for external AI coding tools.

## Source policy

Internal GitLab/NAS/MkDocs remain the source of truth.
Public GitHub contains reusable non-secret reference information only.

## Sync input

- NAS_COMMON: placeholder-configured local path
- Raw private data: not published
EOF

echo "=== Verify ==="
bash scripts/verify_public_repo.sh

echo "=== Git diff ==="
git status --short
git diff --stat || true

if [ "$PUSH" = "1" ]; then
  git add .
  if git diff --cached --quiet; then
    echo "No changes to commit."
  else
    git commit -m "docs: update public reference mirror"
    git push
  fi
else
  echo "Dry run complete. Review then run:"
  echo "PUSH=1 bash scripts/public_mirror_sync.sh"
fi
