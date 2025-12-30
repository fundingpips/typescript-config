# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
