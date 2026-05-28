#!/usr/bin/env bash
set -euo pipefail

PERSONALITY_FILE="${PERSONALITY_FILE:-PERSONALITY.md}"

if [ ! -f "$PERSONALITY_FILE" ]; then
  echo "ERROR: $PERSONALITY_FILE missing."
  exit 1
fi

mkdir -p docs/reference docs/standards

cp "$PERSONALITY_FILE" docs/reference/personality.md

if ! grep -q "PERSONALITY.md" CLAUDE.md 2>/dev/null; then
  cat >> CLAUDE.md <<'EOF'

## Personality

Read `PERSONALITY.md` before starting work.
EOF
fi

if ! grep -q "PERSONALITY.md" CODEX.md 2>/dev/null; then
  cat >> CODEX.md <<'EOF'

## Personality

Read `PERSONALITY.md` before starting work.
EOF
fi

echo "Personality synced:"
echo "- $PERSONALITY_FILE"
echo "- docs/reference/personality.md"
echo "- CLAUDE.md checked"
echo "- CODEX.md checked"
