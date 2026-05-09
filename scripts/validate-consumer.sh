#!/usr/bin/env bash
set -euo pipefail

echo "🔍 Validating consumer resolution..."

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
TSC="pnpm exec tsc"
TMP_ROOT="$(mktemp -d)"

cleanup() {
  rm -rf "$TMP_ROOT"
}
trap cleanup EXIT

CONSUMER_DIR="$TMP_ROOT/consumer"
mkdir -p "$CONSUMER_DIR/node_modules/@fundingpips" "$CONSUMER_DIR/src"
ln -s "$REPO_ROOT" "$CONSUMER_DIR/node_modules/@fundingpips/typescript-config"

cat >"$CONSUMER_DIR/src/foo.ts" <<'EOF'
export const foo = 1;
EOF

cat >"$CONSUMER_DIR/src/index.ts" <<'EOF'
import { foo } from "@/foo";

export const value = foo;
EOF

for config in base next react-native node node-esm vite library; do
  tsconfig="$CONSUMER_DIR/tsconfig.$config.json"
  show_config="$TMP_ROOT/show-$config.json"

  cat >"$tsconfig" <<EOF
{
  "extends": "@fundingpips/typescript-config/$config",
  "include": ["src/**/*.ts"]
}
EOF

  $TSC --showConfig --project "$tsconfig" >"$show_config"

  node - "$show_config" "$REPO_ROOT" "$CONSUMER_DIR" "$config" <<'NODE'
const fs = require("node:fs");

const [showConfigPath, repoRoot, consumerDir, config] = process.argv.slice(2);
const resolved = JSON.parse(fs.readFileSync(showConfigPath, "utf8"));
const compilerOptions = resolved.compilerOptions ?? {};

function fail(message) {
  console.error(`❌ ${config}: ${message}`);
  process.exit(1);
}

function containsPackagePath(value) {
  if (typeof value === "string") {
    return value.includes(`${repoRoot}/bases`);
  }
  if (Array.isArray(value)) {
    return value.some(containsPackagePath);
  }
  if (value && typeof value === "object") {
    return Object.values(value).some(containsPackagePath);
  }
  return false;
}

if (containsPackagePath(compilerOptions)) {
  fail("resolved compilerOptions still point at this package's bases directory");
}

const aliasTarget = compilerOptions.paths?.["@/*"]?.[0];
if (aliasTarget !== `${consumerDir}/src/*`) {
  fail(`@/* resolved to ${aliasTarget ?? "<missing>"} instead of the consumer src directory`);
}

if (["node", "node-esm", "library"].includes(config)) {
  if (compilerOptions.rootDir !== "./src") {
    fail(`rootDir resolved to ${compilerOptions.rootDir ?? "<missing>"} instead of ./src`);
  }
  if (compilerOptions.outDir !== "./dist") {
    fail(`outDir resolved to ${compilerOptions.outDir ?? "<missing>"} instead of ./dist`);
  }
}

if (config === "library" && compilerOptions.declarationDir !== "./dist/types") {
  fail(
    `declarationDir resolved to ${
      compilerOptions.declarationDir ?? "<missing>"
    } instead of ./dist/types`,
  );
}

if (
  config === "vite" &&
  compilerOptions.tsBuildInfoFile !== "./node_modules/.tmp/tsconfig.app.tsbuildinfo"
) {
  fail(
    `tsBuildInfoFile resolved to ${
      compilerOptions.tsBuildInfoFile ?? "<missing>"
    } instead of ./node_modules/.tmp/tsconfig.app.tsbuildinfo`,
  );
}

if (config !== "vite" && compilerOptions.tsBuildInfoFile !== "./.tsbuildinfo") {
  fail(
    `tsBuildInfoFile resolved to ${
      compilerOptions.tsBuildInfoFile ?? "<missing>"
    } instead of ./.tsbuildinfo`,
  );
}
NODE

  echo "✅ $config resolves from a consumer project"
done

$TSC --project "$CONSUMER_DIR/tsconfig.base.json" --pretty false
echo "✅ base path alias resolves in a consumer project"
