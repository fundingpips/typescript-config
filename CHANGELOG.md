# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
- ES2017 target for broader compatibility

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

[1.0.0]: https://github.com/fundingpips/typescript-config/releases/tag/v1.0.0
