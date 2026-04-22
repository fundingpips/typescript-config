#!/usr/bin/env bash
set -euo pipefail

if [ -z "${1:-}" ]; then
  echo "Usage: $0 <config-name>"
  echo "Available configs: next, react-native, node, node-esm, vite, library, base"
  exit 1
fi

CONFIG="$1"
CONFIG_FILE="bases/${CONFIG}.json"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "❌ Config not found: $CONFIG_FILE"
  exit 1
fi

echo "🔍 Validating $CONFIG configuration..."

TSC="pnpm exec tsc"

if ! output=$($TSC --showConfig --project "$CONFIG_FILE" 2>&1); then
  if ! echo "$output" | grep -q "No inputs were found"; then
    echo "❌ Failed to validate $CONFIG_FILE"
    echo "$output"
    exit 1
  fi
fi

echo "✅ $CONFIG configuration is valid"
