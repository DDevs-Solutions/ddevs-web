// @ts-check
import { defineConfig } from 'astro/config';

export default defineConfig({
  site: 'https://ddevs.cl',
  // Emit every script and stylesheet as an external file so the
  // Content-Security-Policy can forbid inline code entirely.
  build: { inlineStylesheets: 'never' },
  vite: { build: { assetsInlineLimit: 0 } },
  devToolbar: { enabled: false },
});
