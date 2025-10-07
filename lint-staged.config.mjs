/**
 * Lint-staged configuration for pre-commit hooks
 * Runs formatters and linters on staged files only for faster commits
 * @type {import('lint-staged').Configuration}
 */
export default {
  // JavaScript/TypeScript - format first, then lint (more efficient)
  "*.{js,jsx,ts,tsx,mjs,cjs}": ["prettier --write"],

  // Configuration and documentation files
  "*.{json,jsonc}": ["prettier --write"],
  "*.{md,mdx}": ["prettier --write"],
  "*.{yml,yaml}": ["prettier --write"],

  // Package.json gets special treatment to maintain consistent ordering
  "package.json": ["prettier --write"],
};
