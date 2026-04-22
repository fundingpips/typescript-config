#!/usr/bin/env bash
set -euo pipefail

echo "🔍 Validating TypeScript configurations..."
echo ""

# `pnpm exec` uses the locally-installed TypeScript from devDependencies.
# Reproducible across machines, unlike `npx` which can resolve to a different
# package version depending on global state.
TSC="pnpm exec tsc"

for config in bases/*.json; do
  name=$(basename "$config" .json)
  echo "Validating $name..."

  # `--showConfig` resolves the extends chain without running a build. We
  # tolerate "No inputs were found" because many bases don't have a src/
  # directory inside this repo — we're only validating the config shape.
  if ! output=$($TSC --showConfig --project "$config" 2>&1); then
    if ! echo "$output" | grep -q "No inputs were found"; then
      echo "❌ Failed to validate $config"
      echo "$output"
      exit 1
    fi
  fi

  echo "✅ $name is valid"
done

echo ""
echo "✅ All configurations validated successfully!"
