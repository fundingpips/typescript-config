#!/usr/bin/env bash
set -euo pipefail

if [ "${CI:-}" = "true" ] || [ "${HUSKY:-}" = "0" ]; then
  echo "Skipping Husky install."
  exit 0
fi

if ! command -v git >/dev/null 2>&1; then
  echo "Skipping Husky install: git is unavailable."
  exit 0
fi

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Skipping Husky install: not inside a git worktree."
  exit 0
fi

git_dir="$(git rev-parse --git-common-dir)"
case "$git_dir" in
  /*) ;;
  *) git_dir="$(pwd -P)/$git_dir" ;;
esac

if [ ! -w "$git_dir" ]; then
  echo "Skipping Husky install: git directory is not writable."
  exit 0
fi

if ! command -v husky >/dev/null 2>&1; then
  echo "Skipping Husky install: husky is unavailable."
  exit 0
fi

husky
