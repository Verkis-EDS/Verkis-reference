#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="${REPO_DIR:-$HOME/Projects/Verkis-reference}"
NAS_COMMON="${NAS_COMMON:-/mnt/nas/Verkis-Proxmox-Dev/_common}"
# Reusable allowlisted export. Only the derived docs subtree is replaced.
# Publication remains a reviewed Git operation; this command never commits/pushes.
umask 077
if [ "${PUSH:-0}" != 0 ]; then
  echo 'PUSH is no longer supported. Generate, review, verify and submit a focused commit.' >&2
  exit 2
fi
WORK_DIR="$(mktemp -d -t verkis-public-mirror-XXXXXXXX)"
trap 'rm -rf -- "$WORK_DIR"' EXIT
STAGING_DIR="$WORK_DIR/staging"
PUBLIC_BUILD_DIR="$WORK_DIR/public-build"

echo "=== Verkís Public Mirror Sync ==="
echo "Repo:       $REPO_DIR"
echo "NAS_COMMON: $NAS_COMMON"


cd "$REPO_DIR"

mkdir -p "$STAGING_DIR"
[ "$(git rev-parse --show-toplevel)" = "$(pwd -P)" ] || exit 2
[ -d "$NAS_COMMON" ] || { echo "Common Ops source unavailable" >&2; exit 2; }
SOURCE_REV="$(git -C "$NAS_COMMON" rev-parse HEAD)"
[ -z "$(git -C "$NAS_COMMON" status --porcelain)" ] || { echo "Source has uncommitted changes" >&2; exit 2; }

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
    governance/WORKSPACE_GATEKEEPER.md \
    governance/ARTIFACT_CREATION_GATE.md \
    governance/MEMORY_CREATION_GATE.md \
    governance/CONTEXT_CREATION_GATE.md \
    governance/registries/agents.md \
    governance/registries/skills.md \
    agents/AGENT_REGISTRY.md \
    skills/SKILL_REGISTRY.md
  do
    if [ -f "$NAS_COMMON/$f" ]; then
      [ ! -L "$NAS_COMMON/$f" ] || { echo "Source symlink rejected: $f" >&2; exit 2; }
      case "$(realpath "$NAS_COMMON/$f")" in "$(realpath "$NAS_COMMON")"/*) ;; *) exit 2;; esac
      mkdir -p "$STAGING_DIR/common/$(dirname "$f")"
      cp "$NAS_COMMON/$f" "$STAGING_DIR/common/$f"
      echo "Copied: $f"
    else
      echo "Required allowlisted source missing: $f" >&2
      exit 2
    fi
  done

  for d in templates agents/templates skills/templates; do
    if [ -d "$NAS_COMMON/$d" ]; then
      [ ! -L "$NAS_COMMON/$d" ] || exit 2
      case "$(realpath "$NAS_COMMON/$d")" in "$(realpath "$NAS_COMMON")"/*) ;; *) exit 2;; esac
      mkdir -p "$STAGING_DIR/common/$d"
      rsync -a \
        --exclude='.git/' \
        --exclude='*.env' \
        --exclude='.env*' \
        --exclude='.gitignore' \
        --exclude='*.key' \
        --exclude='*.pem' \
        --exclude='*secret*' \
        --exclude='*token*' \
        "$NAS_COMMON/$d/" "$STAGING_DIR/common/$d/"
    fi
  done
else
  echo "WARN: NAS common path not found. Syncing only existing public repo files."
fi

echo "=== Sanitize ==="
python3 scripts/sanitize_public_mirror.py --source "$STAGING_DIR" --dest "$PUBLIC_BUILD_DIR" --strict

echo "=== Install sanitized reference output ==="
[ ! -L docs ] && [ ! -L docs/reference ] && [ ! -L docs/reference/common ] || exit 2
mkdir -p docs/reference/common
if [ -d "$PUBLIC_BUILD_DIR/common" ]; then
  rsync -a --delete "$PUBLIC_BUILD_DIR/common/" docs/reference/common/
fi

bash scripts/sync_personality.sh

[ ! -L PUBLIC_MIRROR_MANIFEST.md ] || { echo 'Refusing manifest symlink' >&2; exit 2; }
cat > PUBLIC_MIRROR_MANIFEST.md <<EOF
# Public Mirror Manifest

Source revision: $SOURCE_REV

Export procedure reviewed: 2026-10-07

## Purpose

Sanitized public reference mirror for external AI coding tools.

## Source policy

Internal GitLab/NAS/MkDocs remain the source of truth.
Public GitHub contains reusable non-secret reference information only.

## Sync input

- NAS_COMMON: placeholder-configured local path
- Raw private data: not published
- References to omitted internal files: rendered as prose, never broken public links
EOF

echo "=== Verify ==="
bash scripts/verify_public_repo.sh

echo "=== Git diff ==="
git status --short
git diff --stat || true

echo "Local derived files updated. Review their diff and run scripts/verify_public_repo.sh."
echo "Stage only the intended paths and submit a reviewed branch; no commit or push was performed."
