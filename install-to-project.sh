#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-.}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$ROOT_DIR/template"

if [[ ! -d "$TARGET" ]]; then
  echo "Target directory does not exist: $TARGET" >&2
  exit 1
fi

cd "$TARGET"

mkdir -p .swarm

if [[ -e AI_COLLAB.md ]]; then
  cp AI_COLLAB.md "AI_COLLAB.md.bak.$(date +%Y%m%d%H%M%S)"
fi

cp -R "$TEMPLATE_DIR/.swarm/." .swarm/
cp "$TEMPLATE_DIR/AI_COLLAB.md" AI_COLLAB.md
if [[ ! -e justfile ]]; then
  cp "$TEMPLATE_DIR/justfile" justfile
fi

chmod +x .swarm/bin/*

touch .swarm/chat.log .swarm/messages.jsonl

echo "Installed AI Swarm Cockpit into: $(pwd)"
echo "Next steps:"
echo "  1. Edit .swarm/agents.env"
echo "  2. Run: .swarm/bin/swarm-start"
