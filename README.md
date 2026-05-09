# @fundingpips/typescript-config

[![npm version](https://img.shields.io/npm/v/@fundingpips/typescript-config.svg)](https://www.npmjs.com/package/@fundingpips/typescript-config)
[![CI](https://github.com/fundingpips/typescript-config/actions/workflows/ci.yml/badge.svg)](https://github.com/fundingpips/typescript-config/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Shareable TypeScript configurations for FundingPips projects. This package provides strict, self-contained TypeScript configurations optimized for different project types.

## Features

- ✨ **Maximum Type Safety** - Inlines strict compiler options for the highest level of type checking
- 📦 **Multiple Presets** - Configurations for Next.js, React Native, Node.js, Vite, and libraries
- 🎯 **Consistent Standards** - Unified settings across all FundingPips projects
- ⚡ **Performance Optimized** - Incremental builds and smart defaults
- 🚀 **Minimal Config** - Works with project-local overrides only where TypeScript requires them

## Installation

```bash
# npm
npm install --save-dev @fundingpips/typescript-config

# yarn
yarn add -D @fundingpips/typescript-config

# pnpm
pnpm add -D @fundingpips/typescript-config
```

## Usage

### Next.js Projects

```json
{
  "extends": "@fundingpips/typescript-config/next",
  "compilerOptions": {
    "baseUrl": "."
  }
}
```

### React Native Projects

```json
{
  "extends": "@fundingpips/typescript-config/react-native"
}
```

### Node.js Projects (CommonJS)

```json
{
  "extends": "@fundingpips/typescript-config/node"
}
```

### Node.js Projects (ESM)

```json
{
  "extends": "@fundingpips/typescript-config/node-esm"
}
```

### Vite React Projects

```json
{
  "extends": "@fundingpips/typescript-config/vite"
}
```

### Library Projects

```json
{
  "extends": "@fundingpips/typescript-config/library"
}
```

### Base Configuration (Advanced)

For custom configurations, extend the base:

```json
{
  "extends": "@fundingpips/typescript-config/base",
  "compilerOptions": {
    // Your custom options
  }
}
```

## Available Configurations

| Configuration   | Description          | Use Case                           |
| --------------- | -------------------- | ---------------------------------- |
| `/next`         | Next.js applications | SSR/SSG React apps with App Router |
| `/react-native` | React Native apps    | Mobile applications                |
| `/node`         | Node.js CommonJS     | Traditional Node.js services       |
| `/node-esm`     | Node.js ES Modules   | Modern Node.js with ESM            |
| `/vite`         | Vite React apps      | SPA React applications             |
| `/library`      | Libraries            | Publishable packages               |
| `/base`         | Base configuration   | Custom setups                      |

## Features by Configuration

### All Configurations Include

- ✓ Strict type checking (via inlined strict options)
- ✓ Path aliases (`@/*` → `src/*`)
- ✓ JSON module imports
- ✓ ES module interop
- ✓ Incremental compilation
- ✓ Source maps

### Configuration-Specific Features

#### Next.js (`/next`)

- JSX preserve mode for Next.js processing
- DOM library types
- Next.js plugin support
- Optimized for App Router
- Inherits the shared ES2022 target

#### React Native (`/react-native`)

- React Native JSX transform
- Mobile-optimized library selection
- Jest types included
- Support for `.monicon` files

#### Node.js (`/node`, `/node-esm`)

- Node.js type definitions
- Compiled output to `dist/`
- Declaration files generation
- CommonJS or ESM modules

#### Vite (`/vite`)

- Vite client types
- React JSX runtime
- Hot module replacement support
- Build optimization settings

#### Library (`/library`)

- Declaration file generation
- Multiple module format support
- Stripped internal APIs
- Composite project support

## Strictness Settings

All configurations include the strictest TypeScript settings for maximum type safety:

```typescript
// Core strict settings
strict: true;
noImplicitAny: true;
strictNullChecks: true;
strictFunctionTypes: true;
strictBindCallApply: true;
strictPropertyInitialization: true;
noImplicitThis: true;
alwaysStrict: true;

// Additional strictness
allowUnusedLabels: false;
allowUnreachableCode: false;
exactOptionalPropertyTypes: true;
noFallthroughCasesInSwitch: true;
noImplicitOverride: true;
noImplicitReturns: true;
noPropertyAccessFromIndexSignature: true;
noUncheckedIndexedAccess: true;
noUnusedLocals: true;
noUnusedParameters: true;
```

## Path Aliases

All configurations support the `@/*` alias for the consumer project's `src` directory:

```typescript
// Instead of:
import { Button } from "../../../components/Button";

// Use:
import { Button } from "@/components/Button";
```

## Migration Guide

### From Custom tsconfig

1. Install the package:

```bash
pnpm add -D @fundingpips/typescript-config
```

2. Update your `tsconfig.json`:

```json
{
  "extends": "@fundingpips/typescript-config/next",
  "compilerOptions": {
    // Only add overrides if absolutely necessary
  }
}
```

3. Remove redundant options that are now inherited

### Common Overrides

If you need to override settings:

```json
{
  "extends": "@fundingpips/typescript-config/next",
  "compilerOptions": {
    // Allow JavaScript files (not recommended)
    "allowJs": true,

    // Custom paths
    "paths": {
      "@/*": ["${configDir}/src/*"],
      "@components/*": ["${configDir}/src/components/*"]
    }
  }
}
```

## Troubleshooting

### No inputs were found

This package does not ship `include` or `exclude` values. TypeScript resolves those paths relative to the file that declares them, so shared configs cannot define them safely. Add project-local values in your `tsconfig.json`:

```json
{
  "extends": "@fundingpips/typescript-config/next",
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
```

### "Cannot find module" errors

The built-in `@/*` alias points at your project-local `src` directory. If you replace `compilerOptions.paths`, include the alias explicitly:

```json
{
  "extends": "@fundingpips/typescript-config/next",
  "compilerOptions": {
    "paths": {
      "@/*": ["${configDir}/src/*"],
      "@components/*": ["${configDir}/src/components/*"]
    }
  }
}
```

### React Native specific issues

For React Native projects with custom file extensions:

```json
{
  "extends": "@fundingpips/typescript-config/react-native",
  "include": ["src", "index.js", "custom.d.ts"]
}
```

### Node.js module resolution

For Node.js projects, ensure your `package.json` has the correct `type`:

```json
// For ESM
{
  "type": "module"
}

// For CommonJS (default)
{
  "type": "commonjs"
}
```

## Dependencies

This package is self-contained and does not depend on external tsconfig base packages at runtime. The shared presets inline the strict compiler options directly so consumers do not need resolver support for nested `extends`.

Development uses:

- `typescript` - Validates all shipped configurations
- `oxfmt` - Formats JSON, Markdown, and JavaScript/TypeScript config files
- `husky` and `lint-staged` - Run formatting on staged files

## Development

### Testing

```bash
# Validate all configurations
pnpm test

# Validate a specific configuration
pnpm test:config next

# Format code
pnpm format

# Check formatting
pnpm format:check
```

### Project Structure

```
├── bases/              # TypeScript configuration presets
│   ├── base.json      # Base configuration (all others extend this)
│   ├── next.json      # Next.js configuration
│   ├── react-native.json
│   ├── node.json
│   ├── node-esm.json
│   ├── vite.json
│   └── library.json
├── scripts/           # Validation scripts
│   ├── validate-all.sh    # Validates all configs
│   └── validate-config.sh # Validates single config
└── .github/workflows/ # CI/CD pipelines
    ├── ci.yml        # Test on push/PR
    └── publish.yml   # Publish to npm on release
```

## Contributing

Contributions are welcome! Please read our contributing guidelines before submitting PRs.

## License

MIT © FundingPips

## Support

For issues and questions, please [open an issue](https://github.com/fundingpips/typescript-config/issues).

---

Made with ❤️ by the FundingPips team
