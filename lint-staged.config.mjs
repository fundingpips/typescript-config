/**
 * Lint-staged configuration for pre-commit hooks.
 * Runs oxfmt on staged files only for fast commits.
 * @type {import('lint-staged').Configuration}
 */
export default {
  "*.{js,jsx,ts,tsx,mjs,cjs,json,jsonc,md,mdx}": ["oxfmt"],
};
