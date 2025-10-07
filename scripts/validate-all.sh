#!/bin/bash

echo "🔍 Validating TypeScript configurations..."
echo ""

# Validate all base configs
for config in bases/*.json; do
  name=$(basename "$config" .json)
  echo "Validating $name..."

  # Check that config can be parsed and resolved (ignore missing input files)
  set +e
  output=$(npx tsc --showConfig --project "$config" 2>&1)
  exit_code=$?
  set -e

  # Allow "No inputs were found" error since we're just validating config structure
  if [ $exit_code -ne 0 ] && ! echo "$output" | grep -q "No inputs were found"; then
    echo "❌ Failed to validate $config"
    echo "$output"
    exit 1
  fi

  echo "✅ $name is valid"
done

echo ""
echo "✅ All configurations validated successfully!"
