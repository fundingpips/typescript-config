#!/bin/bash

if [ -z "$1" ]; then
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

# Validate config can be resolved (ignore missing input files)
set +e
output=$(npx tsc --showConfig --project "$CONFIG_FILE" 2>&1)
exit_code=$?
set -e

# Allow "No inputs were found" error since we're just validating config structure
if [ $exit_code -ne 0 ] && ! echo "$output" | grep -q "No inputs were found"; then
  echo "❌ Failed to validate $CONFIG_FILE"
  echo "$output"
  exit 1
fi

echo "✅ $CONFIG configuration is valid"
