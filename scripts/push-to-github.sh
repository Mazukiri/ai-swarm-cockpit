#!/usr/bin/env bash
set -euo pipefail

REPO_NAME="${1:-ai-swarm-cockpit}"
VISIBILITY="${2:-public}"

if ! command -v git >/dev/null 2>&1; then
  echo "git is required" >&2
  exit 1
fi

if [[ ! -d .git ]]; then
  git init
fi

git add .
if git diff --cached --quiet; then
  echo "No changes to commit."
else
  git commit -m "Initial AI Swarm Cockpit template"
fi

if command -v gh >/dev/null 2>&1; then
  gh repo create "$REPO_NAME" "--$VISIBILITY" --source=. --remote=origin --push
else
  echo "GitHub CLI 'gh' is not installed."
  echo "Create an empty GitHub repo named '$REPO_NAME', then run:"
  echo "  git remote add origin git@github.com:<your-user>/$REPO_NAME.git"
  echo "  git branch -M main"
  echo "  git push -u origin main"
fi
