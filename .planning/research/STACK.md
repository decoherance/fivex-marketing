# Technology Stack

**Project:** FiveX Strong Marketing Site
**Researched:** 2026-03-28
**Confidence note:** Training data cutoff August 2025. Version numbers verified against known stable releases as of that date. Pin versions at install time with `npm install` and commit `package-lock.json`. Run `npm outdated` before first build to catch any drift.

---

## Recommended Stack

### Core Framework

| Technology | Version | Purpose | Why |
|------------|---------|---------|-----|
| Astro | ^5.x (5.6+ at time of writing) | Static site generator | Zero-JS-by-default output model is ideal for a marketing page. Built-in static adapter targets GitHub Pages perfectly. Island architecture means you can add one interactive component (e.g., a mobile nav) without shipping a full framework bundle. Content Collections and View Transitions are gravy you won't need here, but the DX is the best in class for component-authored static pages. |
| Node.js | 20 LTS | Build runtime | Astro 5 requires Node >= 18.17.1; 20 LTS is the recommended stable target and what GitHub Actions runners default to. |

**Confidence:** MEDIUM — Astro 5 released December 2024 and was the stable major as of August 2025. Version patch number may have advanced; verify with `npm view astro version`.

---

### Styling

| Technology | Version | Purpose | Why |
|------------|---------|---------|-----|
| Tailwind CSS | ^4.x | Utility-first styling | Tailwind v4 ships with a new CSS-first configuration model (no `tailwind.config.js` required — configure via `@theme` in CSS). The `@astrojs/tailwind` integration was deprecated for v4; instead use the official `@tailwindcss/vite` Vite plugin, which Astro 5 supports natively via its `vite` config block. Eliminates a dependency layer. |
| `@tailwindcss/vite` | ^4.x | Vite plugin for Tailwind v4 | Direct Vite integration; no wrapper adapter needed. Register in `astro.config.mjs` under `vite.plugins`. |

**Confidence:** MEDIUM — Tailwind v4 was released in early 2025. The CSS-first config and Vite plugin approach is the documented path. The `@astrojs/tailwind` v3 adapter should NOT be used with Tailwind v4 — they are incompatible.

**What NOT to use:**
- `@astrojs/tailwind` — This is the old v3 integration. Using it with Tailwind v4 causes build failures.
- Tailwind v3 — No blocking reason to use the older major when v4 is stable. v3 config patterns (JIT, purge arrays) are replaced by v4's new model.

---

### Fonts

| Technology | Version | Purpose | Why |
|------------|---------|---------|-----|
| Fontsource (self-hosted) | ^5.x | Space Grotesk + Inter delivery | Self-hosting fonts via Fontsource eliminates Google Fonts round-trip, improving privacy (no third-party domain requests) and Core Web Vitals (eliminates render-blocking cross-origin font load). Astro's static output means no server-side font subsetting is needed — just import the CSS in your layout. |
| `@fontsource/space-grotesk` | ^5.x | Space Grotesk | Bold/Black weights needed for headlines; import only `400`, `700`, `900` to minimize payload. |
| `@fontsource/inter` | ^5.x | Inter | Body text; import variable font variant (`@fontsource-variable/inter`) for a single file covering all weights. |

**Confidence:** MEDIUM — Fontsource v5 is a known stable release. The `@fontsource-variable/*` packages for variable fonts are well-established. Verify package names with `npm view @fontsource/space-grotesk`.

**What NOT to use:**
- Google Fonts `<link>` tags — Cross-origin, adds DNS lookup + TLS handshake to critical path, leaks visitor IP to Google. No reason to use this when Fontsource is a one-line npm install.

---

### Deployment

| Technology | Version | Purpose | Why |
|------------|---------|---------|-----|
| GitHub Actions | N/A | CI/CD pipeline | Native to GitHub Pages; zero additional infrastructure. Official Astro docs provide a ready-made workflow. |
| `withastro/action` | ^3 | Official Astro GitHub Action | Handles Node setup, caching, build, and artifact upload in one step. Maintained by the Astro team. Use with `actions/deploy-pages` v4 for the actual Pages publish step. |

**Astro config for static output:**

```js
// astro.config.mjs
import { defineConfig } from 'astro/config';
import tailwindcss from '@tailwindcss/vite';

export default defineConfig({
  site: 'https://<username>.github.io',
  base: '/<repo-name>',  // omit if deploying to username.github.io root
  output: 'static',      // default in Astro 5; explicit for clarity
  vite: {
    plugins: [tailwindcss()],
  },
});
```

**GitHub Actions workflow (`.github/workflows/deploy.yml`):**

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [main]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: pages
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: withastro/action@v3
        # No additional config needed for static output

  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

**GitHub Pages settings required:**
- Repository Settings > Pages > Source: set to "GitHub Actions" (not the legacy "Deploy from a branch" option).

**Confidence:** MEDIUM — `withastro/action` v3 and `actions/deploy-pages` v4 reflect the documented patterns as of mid-2025. Action major versions are stable but verify the current major with the Astro deploy docs before wiring up CI.

---

### Supporting Libraries

| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| `sharp` | ^0.33 | Image optimization at build time | Astro's `<Image>` component uses Sharp for build-time optimization. Add it if you add any `<Image>` or `<Picture>` components to the screenshots section. Sharp is a peer dependency — Astro will warn if it's missing when you use its image components. |

**Confidence:** HIGH — Sharp as Astro's image optimization peer dep is well-established and documented.

---

## Alternatives Considered

| Category | Recommended | Alternative | Why Not |
|----------|-------------|-------------|---------|
| SSG Framework | Astro | Next.js (static export) | Next.js static export carries React overhead, requires more config to strip JS, and has worse DX for pure-content pages. Astro ships zero JS by default. |
| SSG Framework | Astro | Eleventy (11ty) | 11ty is excellent but template-language-based rather than component-based. Worse DX for a UI-designed branded page with reusable section components. |
| SSG Framework | Astro | Hugo | Go-based, fast, but no component model and poor ecosystem for JS/CSS tooling integration. |
| CSS | Tailwind v4 | Plain CSS | Plain CSS is fine for a single-page site, but Tailwind's utility classes match well with Astro's component authoring pattern and give consistent spacing/color tokens. |
| CSS | Tailwind v4 | CSS Modules | Overkill for a single-page static site with no dynamic component reuse. |
| Fonts | Fontsource | Google Fonts `<link>` | Privacy leakage, render-blocking, third-party dependency. No upside over self-hosting. |
| Deployment | GitHub Pages | Netlify / Vercel | Free tiers exist, but the constraint is GitHub Pages. Both would work if constraints changed. |
| Deployment | GitHub Actions | Manual `gh-pages` branch push | Brittle, easy to forget, no CI verification. Actions is the modern approach. |

---

## Installation

```bash
# Create project with Astro CLI (interactive setup)
npm create astro@latest fivex-marketing-site

# Or scaffold manually
npm install astro

# Tailwind v4 (Vite plugin, not the old @astrojs/tailwind)
npm install tailwindcss @tailwindcss/vite

# Fonts (self-hosted via Fontsource)
npm install @fontsource/space-grotesk @fontsource-variable/inter

# Image optimization peer dep (add when screenshot images are added)
npm install sharp
```

**Do NOT install:** `@astrojs/tailwind` — this is the deprecated v3 adapter and is incompatible with Tailwind v4.

---

## Tailwind v4 CSS Setup

With Tailwind v4, configuration moves into CSS rather than `tailwind.config.js`. Add this to your global stylesheet:

```css
/* src/styles/global.css */
@import "tailwindcss";

@theme {
  --color-brand: #00E676;
  --color-teal: #00BFA5;
  --color-purple: #D1C4E9;
  --color-bg: #0E0E0E;
  --color-bg-card: #121212;

  --font-heading: "Space Grotesk", sans-serif;
  --font-body: "Inter Variable", Inter, sans-serif;
}
```

Import fonts at the top of this file or in your Astro layout:

```js
// src/layouts/Layout.astro frontmatter
import '@fontsource/space-grotesk/400.css';
import '@fontsource/space-grotesk/700.css';
import '@fontsource/space-grotesk/900.css';
import '@fontsource-variable/inter';
```

---

## Sources

- Astro documentation (training data, cutoff August 2025) — verify at https://docs.astro.build
- Astro GitHub Pages deployment guide — https://docs.astro.build/en/guides/deploy/github/
- Tailwind CSS v4 documentation — https://tailwindcss.com/docs
- Tailwind v4 + Vite integration — https://tailwindcss.com/docs/installation/using-vite
- Fontsource — https://fontsource.org
- `withastro/action` — https://github.com/withastro/action
- Confidence: MEDIUM across all recommendations. Training data is from August 2025 but the project will build in March 2026 — run `npm outdated` after install to catch version drift before first commit.
