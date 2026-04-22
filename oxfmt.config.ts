import { defineConfig } from "oxfmt";

export default defineConfig({
  // This package ships only JSON tsconfigs and a couple of .mjs files —
  // no source files with imports to sort.
  sortImports: false,
  // sortPackageJson is enabled by default in oxfmt; keeping package.json
  // keys in canonical order matters more here than most repos because
  // the root package.json is itself an example of our house style.
});
