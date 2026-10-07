#!/usr/bin/env bash
set -euo pipefail

PERSONALITY_FILE="PERSONALITY.md"
git ls-files --error-unmatch "$PERSONALITY_FILE" >/dev/null
for path in PERSONALITY.md docs docs/reference docs/reference/personality.md CLAUDE.md CODEX.md; do
  [ ! -L "$path" ] || { echo "Refusing symlink: $path" >&2; exit 2; }
done

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
