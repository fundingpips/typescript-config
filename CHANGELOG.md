# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2026-04-23

### Breaking

- **`base.json`** — removed `experimentalDecorators`, `emitDecoratorMetadata`, `checkJs`, and `allowSyntheticDefaultImports`. No-op for any consumer not using legacy decorator syntax (`@Foo class Bar {}`) — which is all current consumers, verified by grep across the fundingpips/tradin/finticks repos. Stage-3 decorators (TS 5.0+) continue to work without any flag.
- **`library.json`** — now extends `./base.json` instead of being fully inlined. Picks up all strictness flags from base; overrides only emit/declaration settings. If you relied on library.json having settings that base doesn't (none today), re-declare them in your own tsconfig.
- **`engines.node`** — bumped from `>=22.19.0` to `>=24.15.0` (current Node LTS, Krypton).

### Changed

- **All bases extend `base.json`** — `vite.json` previously did not. Every shared setting now lives in exactly one place.
- **Redundancy removed from every base** — `next.json`, `node.json`, `node-esm.json`, `react-native.json` no longer re-declare settings that base already sets (`strict`, `esModuleInterop`, `skipLibCheck`, etc.). 9 redundant lines gone from `next.json` alone.
- **`node-esm.json`** — dropped the `ts-node` config block. Node 24+ runs TypeScript natively via `--experimental-strip-types` (stable since 23.6).
- **`node.json` / `node-esm.json`** — `lib` collapsed from a granular list (`es2020.bigint`, `es2020.date`, …) to `["ES2024"]`. Node 24 supports ES2024 natively.
- **`react-native.json`** — `lib` collapsed from granular ES2019–2022 pieces to `["ES2022"]`. RN 0.82+ with Hermes supports ES2022.
- **`library.json`** — `target` bumped `ES2020` → inherits base (ES2022); `jsx` bumped `react` → `react-jsx` (React 17+ transform).
- **Migrated formatter Prettier → oxfmt.** Matches the rest of the FundingPips stack. `sortPackageJson` is built-in to oxfmt, so `prettier-plugin-packagejson` is no longer needed.
- **Dependencies updated**: `typescript` 5.9.3 → 6.0.3, `lint-staged` 16.2.7 → 16.4.0.
- **`packageManager`** pinned to `pnpm@10.33.1` with sha512 integrity hash for Corepack verification.
- **CI / publish workflows** — Node 22 → 24.15.0, pnpm 10.18.1 → 10.33.1. Added `concurrency` group to CI so push + PR runs cancel each other.

### Removed

- **`.npmignore`** — redundant with `files: ["bases"]` in `package.json`. The `files` field is an allowlist (always safer than a blocklist).
- **`prettier.config.mjs`, `.prettierignore`** — replaced by `oxfmt.config.ts`.
- **`prettier`, `prettier-plugin-packagejson`** from devDependencies.

### Fixed

- **`base.json`** — `checkJs: true` was a dead setting (silently ignored without `allowJs: true`); removed.
- **`base.json`** — `allowSyntheticDefaultImports: true` was implicit with `esModuleInterop: true`; removed the noise.

## [1.2.0] - 2025-12-30

### Changed

- **Base Config** - Removed `baseUrl` option for tsgo compatibility
  - tsgo (Go-based TypeScript compiler) has removed support for `baseUrl`
  - Path aliases continue to work with relative paths (`./src/*`)

## [1.1.0] - 2025-01-08

### Changed

- **BREAKING**: Inlined all external tsconfig dependencies for full control and ESLint compatibility
  - Eliminates ESLint import resolver issues with nested extends
  - No longer depends on `@tsconfig/strictest`, `@tsconfig/next`, `@tsconfig/node-lts`, `@tsconfig/vite-react`, or `@react-native/typescript-config`
  - All configurations now fully self-contained with inline strictness settings
- **All Configs** - Added explicit `strict: true` declaration for better ESLint compatibility
- **Library Config** - Now fully standalone without extending base config

### Fixed

- ESLint TypeScript parser errors: "This rule requires the `strictNullChecks` compiler option"
- ESLint import resolver errors: "Tsconfig not found" for extended configurations
- Module resolution issues in projects using `eslint-import-resolver-typescript`

## [1.0.2] - 2025-10-07

### Fixed

- **Next.js Config** - Removed ES2017 target override to inherit ES2022 from base config
  - Restores modern language features: top-level await, private class fields, nullish coalescing assignment, Error causes, Array `.at()`
  - Next.js 15+ assumes modern runtimes; ES2017 was an unnecessary 5-year regression
- **Next.js Config** - Explicitly disable `checkJs` to resolve conflict with `@tsconfig/strictest`
  - TypeScript requires `allowJs: true` when `checkJs: true`, but Next.js projects should be TypeScript-only
- **Base Config** - Add `noUncheckedSideEffectImports: true` for stricter import validation
  - Catches non-existent side-effect imports (e.g., `import "./missing.css"`) at compile time

## [1.0.1] - 2025-10-07

### Fixed

- **Next.js Config** - Resolve `checkJs`/`allowJs` conflict with `@tsconfig/strictest` preset

## [1.0.0] - 2025-10-07

### Added

- **Base Configuration** - Foundational TypeScript config extending `@tsconfig/strictest`
  - ES2022 target with ESNext modules
  - Bundler module resolution with verbatim module syntax
  - Path aliases (`@/*` → `src/*`)
  - Incremental compilation support
  - Source maps with inline sources
  - JSON module imports
  - Experimental decorators support

- **Framework-Specific Configurations**
  - **Next.js** - Optimized for Next.js 14+ with App Router
  - **React Native** - Mobile-optimized with React Native JSX transform
  - **Node.js (CommonJS)** - Traditional Node.js services with declaration generation
  - **Node.js (ESM)** - Modern ES modules support for Node.js
  - **Vite** - SPA React applications with HMR support
  - **Library** - Publishable packages with composite project support

- **Strict Type Safety** - All configurations extend `@tsconfig/strictest` with:
  - `strict: true` and all strict mode flags
  - `noUncheckedIndexedAccess: true`
  - `exactOptionalPropertyTypes: true`
  - `noImplicitReturns: true`
  - `noUnusedLocals: true`
  - `noUnusedParameters: true`
  - Additional strictness flags for maximum type safety

- **Development Tools**
  - Validation scripts to test config resolution
  - Prettier formatting with consistent standards
  - Husky pre-commit hooks with lint-staged
  - GitHub Actions CI/CD workflows

- **Documentation**
  - Comprehensive README with usage examples
  - Configuration comparison table
  - Migration guide from custom configs
  - Troubleshooting section
  - Development guidelines

### Configuration Details

#### `/base`

- Foundation for all other configs
- Maximum strictness via `@tsconfig/strictest`
- Modern ES2022 features
- Bundler-optimized module resolution

#### `/next`

- Extends base + `@tsconfig/next`
- JSX preserve mode for Next.js processing
- DOM library types included
- Inherits ES2022 target from base

#### `/react-native`

- Extends base + `@react-native/typescript-config`
- React Native JSX transform
- Mobile-optimized library selection
- Jest types included
- `.monicon` file support

#### `/node` & `/node-esm`

- Extends base + `@tsconfig/node-lts`
- Declaration file generation
- Output to `dist/`
- Test file exclusion
- CommonJS or ES modules

#### `/vite`

- Extends base + `@tsconfig/vite-react`
- Vite client types
- React JSX runtime
- HMR support

#### `/library`

- Extends base
- Declaration and source map generation
- Composite project support
- Storybook file exclusion
- Optimized for npm publishing

### Infrastructure

- **Package Configuration**
  - ESM package with proper exports
  - npm provenance for supply chain security
  - TypeScript 5.9+ peer dependency
  - Node.js 22.20+ engine requirement

- **CI/CD**
  - Automated testing on push/PR
  - Publish workflow with provenance
  - Format checking
  - Config validation

- **Quality Assurance**
  - Pre-commit formatting enforcement
  - Automated validation scripts
  - Comprehensive test coverage

[1.0.2]: https://github.com/fundingpips/typescript-config/compare/v1.0.1...v1.0.2
[1.0.1]: https://github.com/fundingpips/typescript-config/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/fundingpips/typescript-config/releases/tag/v1.0.0
