#!/usr/bin/env bash
set -euo pipefail

echo "=== Verify public repository safety ==="

FAIL=0

echo
echo "1) Git status"
git status --short || FAIL=1

echo
echo "2) Blocked filenames"
BLOCKED_FILES="$(find . \
  \( -iname "*.env" -o -iname "*.pem" -o -iname "*.key" -o -iname "*.p12" -o -iname "*.pfx" \
     -o -iname "id_rsa*" -o -iname "id_ed25519*" -o -iname "*secret*" -o -iname "*token*" -o -iname "*credential*" \) \
  -not -path "./.git/*" \
  -not -path "./examples/env.example" \
  -not -path "./examples/public-mirror-config.example.env" \
  -print || true)"

if [ -n "$BLOCKED_FILES" ]; then
  echo "ERROR: blocked filenames found:"
  echo "$BLOCKED_FILES"
  FAIL=1
else
  echo "OK"
fi

echo "3) Likely secret content"
# Match actual secret-bearing patterns, not policy text that mentions the words.
# - PEM private-key markers (the actual file format)
# - `password=value` / `token=value` etc. with an inline non-empty value (not policy prose)
# - GitLab/GitHub token prefixes
SECRET_HITS="$(grep -RniE \
  "-----BEGIN [A-Z ]*PRIVATE KEY-----|(\\bpassword|\\bpasswd|\\bapi[_-]?key|(^|[^-_a-z])token|(^|[^-_a-z])secret)[[:space:]]*[:=][[:space:]]*['\"]?[A-Za-z0-9/+=._\\-]{8,}|\\bglpat-[A-Za-z0-9_\\-]{16,}|\\bgh[pousr]_[A-Za-z0-9_]{20,}" \
  . \
  --exclude-dir=.git \
  --exclude-dir=.mirror-work \
  --exclude-dir=site \
  --exclude="verify_public_repo.sh" \
  --exclude="sanitize_public_mirror.py" \
  --exclude="*.example" || true)"

if [ -n "$SECRET_HITS" ]; then
  echo "ERROR: possible secret content found:"
  echo "$SECRET_HITS"
  FAIL=1
else
  echo "OK"
fi

echo
echo "4) Private IPv4 references outside examples"
IP_HITS="$(grep -RniE \
  "\b(10|192\.168|172\.(1[6-9]|2[0-9]|3[0-1]))\.[0-9]{1,3}\.[0-9]{1,3}" \
  . \
  --exclude-dir=.git \
  --exclude-dir=.mirror-work \
  --exclude="*.example" || true)"

if [ -n "$IP_HITS" ]; then
  echo "ERROR/WARN: private IP references found:"
  echo "$IP_HITS"
  FAIL=1
else
  echo "OK"
fi

echo
echo "5) gitleaks if available"
if command -v gitleaks >/dev/null 2>&1; then
  gitleaks detect --source . --no-git --redact || FAIL=1
else
  echo "WARN: gitleaks not installed"
fi

echo
echo "6) shellcheck if available"
if command -v shellcheck >/dev/null 2>&1; then
  shellcheck scripts/*.sh || FAIL=1
else
  echo "WARN: shellcheck not installed"
fi

echo
echo "7) MkDocs build if available"
if [ -f mkdocs.yml ] && command -v mkdocs >/dev/null 2>&1; then
  mkdocs build --strict || FAIL=1
else
  echo "WARN: mkdocs not installed or mkdocs.yml missing"
fi

if [ "$FAIL" -ne 0 ]; then
  echo "RESULT: FAIL / REVIEW REQUIRED"
  exit 1
fi

echo "RESULT: PASS"
