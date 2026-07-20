#!/usr/bin/env bash
set -euo pipefail
branch="${1:-}"
if [[ ! "$branch" =~ ^(feature|fix|docs|chore)/[a-z0-9._-]+$ ]]; then
  echo "Branch must match type/description, such as feature/login-flow" >&2
  exit 1
fi
echo "Branch name is valid: $branch"
