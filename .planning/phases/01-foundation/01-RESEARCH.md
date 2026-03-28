# Phase 1: Foundation - Research

**Researched:** 2026-03-28
**Domain:** Astro 6, Tailwind CSS v4, GitHub Pages CI/CD, Design Tokens
**Confidence:** HIGH

---

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

**Placeholder page**
- Branded landing page, not a minimal test page — should look intentional if discovered early
- Includes app name "FiveX Strong", tagline "Strength training, simplified", and brand colors
- Google Play badge present and links to placeholder URL (swap to real URL later)
- Tagline "Strength training, simplified" is the real value proposition — use in hero and elsewhere in Phase 2

**Design tokens — color**
- Dark theme site: deep black backgrounds (#0a0a0a), not light marketing style
- Green (#00E676) is the primary CTA/action color
- Teal (#00BFA5) for secondary accents
- Purple (#D1C4E9) for subtle highlights
- Derive surface/card colors, text colors, and borders from the dark theme base

**Design tokens — typography**
- Bold and punchy heading style — large sizes, heavy weights (fitness/gym energy)
- Space Grotesk for headings, Inter for body (already decided in PROJECT.md)
- Type scale should make a statement, not be understated

**Hosting & URL**
- Custom subdomain: fivexstrong.decoherance-interactive.com
- Base path is `/` (root) — subdomain means no path prefix needed
- CNAME record pointing to GitHub Pages
- CNAME file in repo for GitHub Pages custom domain support

**OG / meta content**
- OG title: "FiveX Strong — Strength training, simplified"
- OG description: benefit-focused, e.g., "The simplest way to run a 5x5 strength programme. Just pick a workout and lift."
- OG image: placeholder branded graphic for now (app icon to be swapped in later)
- Claude to draft the final OG description copy during implementation

### Claude's Discretion
- Loading skeleton design
- Exact spacing and component sizing
- Placeholder OG image design (branded, swap later)
- Error state handling
- Typography scale exact values
- Surface/border color derivation from dark theme

### Deferred Ideas (OUT OF SCOPE)
None — discussion stayed within phase scope
</user_constraints>

---

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| TECH-01 | Site is built with Astro generating static HTML | Astro 6 defaults to `output: 'static'`; no explicit config needed; `npm run build` → `dist/` |
| TECH-02 | Site is responsive and usable at 360px+ viewport | Tailwind v4 mobile-first by default; `sm:` breakpoint is 40rem (640px); 360px is below all breakpoints, so base styles must target 360px |
| TECH-03 | Site uses dark theme with #00E676 green, Space Grotesk + Inter fonts | Tailwind v4 `@theme` block defines custom colors; Astro 6 Fonts API (stable) handles Space Grotesk + Inter with auto-optimization |
| TECH-04 | Site deploys to GitHub Pages via GitHub Actions | `withastro/action@v6` + `actions/deploy-pages@v5`; `withastro/action` v6 uses Node 24 by default; requires `pages: write` + `id-token: write` permissions |
| TECH-05 | Site includes proper OG/meta tags for social sharing | Standard `<meta>` tags in Astro layout `<head>`; OG image in `public/` at 1200×630px; no special library needed |
</phase_requirements>

---

## Summary

This phase sets up an Astro 6 project from scratch with Tailwind CSS v4, deploys it to GitHub Pages via a custom subdomain, and ships a branded placeholder page with design tokens and OG meta tags. All four key technologies (Astro, Tailwind, GitHub Actions, custom DNS) have well-established patterns in 2026 and the research surfaces no unusual risks.

The biggest "gotcha" area is the interaction between Astro's `site` config, the `base` config, and the custom subdomain: because the site uses a CNAME subdomain (not a repo path like `/fivex-marketing-site/`), the `base` property must be omitted or set to `/`. The `withastro/action` starter workflow injects `--base` at build time from the Pages environment, which would break asset paths on a custom domain — so the `actions/starter-workflows` YAML template should be used cautiously and the base injection step removed when a CNAME is in play.

Tailwind CSS v4 is a CSS-first configuration system — there is no `tailwind.config.js`. Design tokens live in a `@theme {}` block in the global CSS file. The Astro 6 Fonts API is stable (promoted from experimental in Astro 6) and handles Space Grotesk + Inter with automatic download, caching, and `<link rel="preload">` generation.

**Primary recommendation:** Scaffold with `npm create astro@latest`, add Tailwind via `@tailwindcss/vite` plugin, configure fonts via the Astro 6 Fonts API with `fontProviders.google()`, deploy with the official GitHub Actions starter workflow (modified to remove the `--base` injection for CNAME setup).

---

## Standard Stack

### Core

| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| astro | 6.1.x (latest) | Static site framework | Project requirement; v6 stable as of late 2025, Node 22 required |
| @tailwindcss/vite | 4.x | Tailwind CSS v4 Vite plugin | Official approach for Tailwind v4 with Astro; replaces deprecated `@astrojs/tailwind` |
| tailwindcss | 4.x | Utility-first CSS | Project requirement for design tokens |

### Supporting

| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| withastro/action | v6 | GitHub Actions builder for Astro | Always for Pages CI/CD; auto-detects package manager, Node 24 default |
| actions/deploy-pages | v5 | GitHub Pages deployment step | Paired with withastro/action; handles artifact upload + deploy |
| actions/configure-pages | v5 | Injects Pages origin + base_path | Used in starter workflow; must be bypassed/not used for base injection when CNAME is set |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Astro Fonts API (stable) | Google Fonts CDN `<link>` | CDN approach works but requires manual preload and sends user data to Google; Fonts API self-hosts and auto-optimizes |
| Astro Fonts API | `astro-font` npm package | `astro-font` is a third-party package that predates the built-in API; built-in is now preferred |
| Tailwind `@theme` for tokens | `:root` CSS variables | `:root` vars don't generate Tailwind utility classes; `@theme` is required |

**Installation:**
```bash
npm create astro@latest . -- --template minimal
npm install tailwindcss @tailwindcss/vite
```

---

## Architecture Patterns

### Recommended Project Structure

```
src/
├── components/       # Reusable .astro components (Head, GooglePlayBadge, etc.)
├── layouts/          # BaseLayout.astro wrapping all pages
├── pages/            # index.astro (single page)
└── styles/
    └── global.css    # @import "tailwindcss" + @theme tokens + @custom-variant dark

public/
├── CNAME             # fivexstrong.decoherance-interactive.com
├── og-image.png      # Placeholder OG image 1200×630
└── favicon.svg       # Brand favicon

.github/
└── workflows/
    └── deploy.yml    # GitHub Actions CI/CD

astro.config.mjs      # site, fonts[], vite.plugins
```

### Pattern 1: Tailwind v4 Design Tokens (CSS-First)

**What:** All brand tokens defined in `@theme {}` block inside `global.css`. No `tailwind.config.js` exists.

**When to use:** Always — this is the only supported approach in Tailwind v4.

**Example:**
```css
/* src/styles/global.css */
/* Source: https://tailwindcss.com/docs/theme */
@import "tailwindcss";

/* Force dark mode always-on (dark-only site) */
@custom-variant dark (&:where(.dark, .dark *));

@theme {
  /* Brand colors */
  --color-brand-green:   #00E676;
  --color-brand-teal:    #00BFA5;
  --color-brand-purple:  #D1C4E9;

  /* Dark theme surfaces derived from #0a0a0a base */
  --color-surface-base:  #0a0a0a;
  --color-surface-card:  #141414;
  --color-surface-raised:#1a1a1a;
  --color-border:        #2a2a2a;
  --color-text-primary:  #f5f5f5;
  --color-text-muted:    #9e9e9e;

  /* Typography */
  --font-heading: "Space Grotesk", sans-serif;
  --font-body:    "Inter", sans-serif;

  /* Type scale — bold and punchy */
  --text-display: clamp(3rem, 8vw, 6rem);
  --text-hero:    clamp(2rem, 5vw, 3.5rem);
  --text-xl:      1.5rem;
  --text-lg:      1.25rem;
  --text-base:    1rem;
  --text-sm:      0.875rem;
}
```

Generated utility classes from `@theme`:
- `bg-brand-green`, `text-brand-green`, `border-brand-green`
- `bg-surface-base`, `bg-surface-card`
- `text-text-primary`, `text-text-muted`
- `font-heading`, `font-body`

### Pattern 2: Astro 6 Fonts API (Stable)

**What:** Fonts defined in `astro.config.mjs`, served from your site (not Google CDN), with automatic preload and fallback generation.

**When to use:** Always — preferred over manual `<link>` to Google Fonts.

**Example:**
```javascript
// astro.config.mjs
// Source: https://docs.astro.build/en/guides/fonts/
import { defineConfig, fontProviders } from "astro/config";
import tailwindcss from "@tailwindcss/vite";

export default defineConfig({
  site: "https://fivexstrong.decoherance-interactive.com",
  fonts: [
    {
      name: "Space Grotesk",
      cssVariable: "--font-space-grotesk",
      provider: fontProviders.google(),
    },
    {
      name: "Inter",
      cssVariable: "--font-inter",
      provider: fontProviders.google(),
    },
  ],
  vite: {
    plugins: [tailwindcss()],
  },
});
```

Then in the layout head:
```astro
---
// src/layouts/BaseLayout.astro
import { Font } from "astro:assets";
---
<html lang="en" class="dark">
  <head>
    <Font cssVariable="--font-space-grotesk" />
    <Font cssVariable="--font-inter" />
    <!-- OG meta tags here -->
  </head>
```

Wire up in Tailwind `@theme inline` so CSS variables resolve:
```css
@theme inline {
  --font-heading: var(--font-space-grotesk);
  --font-body:    var(--font-inter);
}
```

### Pattern 3: GitHub Actions Deploy (CNAME / Custom Domain)

**What:** GitHub Actions workflow using `withastro/action@v6` + `actions/deploy-pages@v5`. Because a CNAME custom subdomain is used, `base` is `/` and must NOT be injected from the Pages environment (which would set it to the repo name path).

**When to use:** Any CNAME-based deployment to GitHub Pages.

**Example:**
```yaml
# .github/workflows/deploy.yml
# Source: https://github.com/actions/starter-workflows (modified for CNAME)
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
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    name: Build
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: "22"
          cache: "npm"
          cache-dependency-path: package-lock.json

      - name: Install dependencies
        run: npm ci

      - name: Build with Astro
        run: npm run build
        # NOTE: No --base flag injection — custom subdomain means base is always "/"

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: dist

  deploy:
    name: Deploy
    needs: build
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v5
```

### Pattern 4: OG Meta Tags in Astro Layout

**What:** Static `<meta>` tags in `BaseLayout.astro` head. OG image is a static file in `public/`.

**Example:**
```astro
<!-- src/layouts/BaseLayout.astro -->
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>FiveX Strong — Strength training, simplified</title>
  <meta name="description" content="The simplest way to run a 5×5 strength programme. Just pick a workout and lift." />

  <!-- Open Graph -->
  <meta property="og:title" content="FiveX Strong — Strength training, simplified" />
  <meta property="og:description" content="The simplest way to run a 5×5 strength programme. Just pick a workout and lift." />
  <meta property="og:image" content="https://fivexstrong.decoherance-interactive.com/og-image.png" />
  <meta property="og:image:width" content="1200" />
  <meta property="og:image:height" content="630" />
  <meta property="og:type" content="website" />
  <meta property="og:url" content="https://fivexstrong.decoherance-interactive.com" />

  <!-- Twitter Card -->
  <meta name="twitter:card" content="summary_large_image" />
  <meta name="twitter:title" content="FiveX Strong — Strength training, simplified" />
  <meta name="twitter:description" content="The simplest way to run a 5×5 strength programme. Just pick a workout and lift." />
  <meta name="twitter:image" content="https://fivexstrong.decoherance-interactive.com/og-image.png" />

  <link rel="canonical" href="https://fivexstrong.decoherance-interactive.com" />
</head>
```

### Anti-Patterns to Avoid

- **Using `@astrojs/tailwind` integration:** Deprecated for Tailwind v4. Use `@tailwindcss/vite` plugin in `vite.plugins[]` instead.
- **Creating `tailwind.config.js`:** Not used in Tailwind v4. All config lives in the CSS file via `@theme`.
- **Setting `base: '/repo-name'` in astro.config.mjs:** Only needed for path-based GitHub Pages URLs. CNAME subdomain = root path, no `base` needed.
- **Injecting `--base` in the build command:** The `actions/configure-pages` step injects `--base` based on repo name; remove this step when using CNAME to avoid broken asset paths.
- **Using Google Fonts `<link>` tags directly:** Works but loses the performance benefits of the Astro Fonts API (self-hosting, preload, fallback generation).
- **Using `@tailwindcss/typography` for a placeholder page:** Unnecessary complexity for Phase 1.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Font loading + preload | Manual `<link>` tags with preload attributes | Astro 6 Fonts API | Handles download, caching, fallback generation, and preload automatically |
| GitHub Actions build | Custom Node + build steps | `withastro/action@v6` | Handles package manager detection, caching, Astro-specific build optimizations |
| CSS custom properties for design | Manual `:root {}` vars | Tailwind `@theme {}` | `:root` vars don't generate utility classes; `@theme` vars do both |
| Dark mode toggle logic | JS class-switching logic | Not needed — site is dark-only | Add `class="dark"` to `<html>` and define `@custom-variant dark (&:where(.dark, .dark *))` |

**Key insight:** The Astro Fonts API eliminates an entire class of font loading complexity (FOUT, preload hints, fallback stacks) that teams routinely get wrong by hand.

---

## Common Pitfalls

### Pitfall 1: Base Path Breaks Asset Loading on Custom Domain

**What goes wrong:** Assets load correctly in development but return 404s on the live URL. All CSS, JS, and images have paths prefixed with `/repo-name/`.

**Why it happens:** The `actions/configure-pages` step in the starter workflow injects `--base /repo-name` into the Astro build command. This is correct for path-based GitHub Pages but wrong for CNAME subdomains.

**How to avoid:** Remove `actions/configure-pages@v5` and the `--base "${{ steps.pages.outputs.base_path }}"` flag from the build command. Set `site:` in `astro.config.mjs` to the custom subdomain URL. Leave `base` unset (defaults to `/`).

**Warning signs:** Live site has 404s on CSS/JS; browser DevTools shows paths like `/fivex-marketing-site/assets/index.css`.

### Pitfall 2: Tailwind v4 Config File Confusion

**What goes wrong:** A `tailwind.config.js` is created (from tutorials or AI assistance trained on v3 docs), `@tailwind base; @tailwind components; @tailwind utilities;` is used in CSS, or `@astrojs/tailwind` is installed.

**Why it happens:** The vast majority of Tailwind tutorials and Stack Overflow answers are for v3. v4 is a complete paradigm shift.

**How to avoid:** No `tailwind.config.js`. CSS file starts with `@import "tailwindcss"`. Plugin is `@tailwindcss/vite` (not `@astrojs/tailwind`). All customization goes in `@theme {}`.

**Warning signs:** Build warns about missing config file; colors defined in `tailwind.config.js` have no effect.

### Pitfall 3: CNAME File Not in `public/`

**What goes wrong:** GitHub Pages loses the custom domain setting after every deploy, reverting to the `username.github.io` URL and triggering HTTPS cert re-issue.

**Why it happens:** The CNAME file must be committed at `public/CNAME` so Astro copies it to `dist/CNAME` during build. If only set in GitHub Pages settings (without the file), it gets overwritten on each deploy via GitHub Actions.

**How to avoid:** Create `public/CNAME` with a single line: `fivexstrong.decoherance-interactive.com`. No trailing newline concerns — file just needs the domain name.

**Warning signs:** Site works right after deploy but breaks hours later; GitHub Pages settings show domain field blank.

### Pitfall 4: Font CSS Variable Not Connected to Tailwind

**What goes wrong:** Astro Fonts API generates `--font-space-grotesk` CSS variable but `font-heading` Tailwind utility applies the wrong font or falls back to system sans-serif.

**Why it happens:** The Fonts API sets up the CSS variable (`--font-space-grotesk`) but Tailwind's `@theme` must also define a mapping from the font utility name to that variable. Missing the `@theme inline` block.

**How to avoid:**
```css
@theme inline {
  --font-heading: var(--font-space-grotesk);
  --font-body:    var(--font-inter);
}
```
The `inline` keyword tells Tailwind to resolve the variable at utility generation time rather than creating a variable reference chain.

**Warning signs:** `font-heading` class applies but browser shows system font; inspecting element shows `font-family: var(--font-space-grotesk)` but variable is undefined in computed styles.

### Pitfall 5: OG Image Absolute URL Requirement

**What goes wrong:** OG image doesn't render in social previews (Twitter/X, LinkedIn, Slack) even though the `<meta>` tag is present.

**Why it happens:** `og:image` must be an absolute URL, not a relative path. Many scrapers don't resolve relative paths.

**How to avoid:** Always use the full URL including protocol: `https://fivexstrong.decoherance-interactive.com/og-image.png`. Hardcode it in the layout since it's a single-page site with one OG image.

**Warning signs:** Social preview shows no image; Opengraph.xyz debugger reports image missing.

### Pitfall 6: Node.js Version Mismatch

**What goes wrong:** GitHub Actions build fails with a Node version error.

**Why it happens:** Astro 6 requires Node 22+. The starter workflow may default to Node 20 (`node-version: "20"`).

**How to avoid:** Set `node-version: "22"` in the workflow. Alternatively, add a `.nvmrc` or `engines` field in `package.json` to make the requirement explicit.

**Warning signs:** Build fails immediately with `Unsupported Node.js version` or similar error.

---

## Code Examples

Verified patterns from official sources:

### Complete `astro.config.mjs` for This Project

```javascript
// Source: https://docs.astro.build/en/guides/fonts/
//         https://tailwindcss.com/docs/installation/framework-guides/astro
import { defineConfig, fontProviders } from "astro/config";
import tailwindcss from "@tailwindcss/vite";

export default defineConfig({
  site: "https://fivexstrong.decoherance-interactive.com",
  // No 'base' — CNAME means root path
  fonts: [
    {
      name: "Space Grotesk",
      cssVariable: "--font-space-grotesk",
      provider: fontProviders.google(),
    },
    {
      name: "Inter",
      cssVariable: "--font-inter",
      provider: fontProviders.google(),
    },
  ],
  vite: {
    plugins: [tailwindcss()],
  },
});
```

### Complete `src/styles/global.css`

```css
/* Source: https://tailwindcss.com/docs/theme */
@import "tailwindcss";

/* Dark-only site: make all dark: utilities always apply */
@custom-variant dark (&:where(.dark, .dark *));

@theme {
  /* Brand palette */
  --color-brand-green:    #00E676;
  --color-brand-teal:     #00BFA5;
  --color-brand-purple:   #D1C4E9;

  /* Dark surfaces (derived from #0a0a0a) */
  --color-surface-base:   #0a0a0a;
  --color-surface-card:   #141414;
  --color-surface-raised: #1a1a1a;
  --color-border-subtle:  #222222;
  --color-border:         #2e2e2e;

  /* Text */
  --color-text-primary:   #f5f5f5;
  --color-text-secondary: #b0b0b0;
  --color-text-muted:     #717171;

  /* Font families (resolved from Fonts API CSS vars) */
  --font-sans: var(--font-inter);

  /* Named font utilities */
}

/* Wire Fonts API variables to Tailwind font utilities */
@theme inline {
  --font-heading: var(--font-space-grotesk);
  --font-body:    var(--font-inter);
}

/* Base layer: dark theme applied to html.dark */
@layer base {
  html {
    background-color: var(--color-surface-base);
    color: var(--color-text-primary);
    font-family: var(--font-body);
  }
}
```

### Google Play Badge

The official Google Play badge is available at:
```
https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png
```
This is a Google-hosted PNG. For production, download and commit to `public/` to avoid third-party dependency and ensure availability. Link to placeholder URL:
```astro
<a href="https://play.google.com/store/apps/details?id=PLACEHOLDER_APP_ID"
   target="_blank"
   rel="noopener noreferrer"
   aria-label="Get FiveX Strong on Google Play">
  <img src="/google-play-badge.png"
       alt="Get it on Google Play"
       width="200"
       height="59" />
</a>
```

### `public/CNAME` File

```
fivexstrong.decoherance-interactive.com
```
Single line, no trailing slash.

---

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| `@astrojs/tailwind` integration | `@tailwindcss/vite` Vite plugin | Tailwind v4 release (late 2024) | Old package deprecated; must use new plugin |
| `tailwind.config.js` | `@theme {}` block in CSS | Tailwind v4 | No JS config file needed or expected |
| `@tailwind base/components/utilities` | `@import "tailwindcss"` | Tailwind v4 | Single import replaces three directives |
| `fontProviders` in `experimental.fonts` | `fontProviders` in stable `fonts` | Astro 6 (late 2025) | No `experimental: { fonts: [...] }` wrapper needed |
| Node 18/20 support | Node 22+ required | Astro 6 | GitHub Actions must use `node-version: "22"` |
| `withastro/action@v5` | `withastro/action@v6` | March 2026 | Defaults to Node 24, new action version |

**Deprecated/outdated:**
- `@astrojs/tailwind`: Deprecated — use `@tailwindcss/vite` instead
- `tailwind.config.js`: Not applicable for Tailwind v4
- `darkMode: 'class'` in tailwind config: Replaced by `@custom-variant dark` in CSS

---

## Open Questions

1. **Astro 6 Fonts API: experimental flag still needed?**
   - What we know: The Astro 6 blog post says it's stable; the docs URL is under `/reference/experimental-flags/fonts/` (path may be stale/redirect)
   - What's unclear: Whether `experimental: { fonts: true }` still needs to be set in `astro.config.mjs` for Astro 6.1.x
   - Recommendation: Try without `experimental` flag first. If fonts don't resolve, add `experimental: { fonts: true }`. The docs fetched during research did NOT show an experimental wrapper in the config example, which is a good sign.

2. **Google Play badge self-hosting vs. hotlinking**
   - What we know: Official badge PNG is at `https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png`; Google's badge guidelines require download via their Partner Marketing Hub (login required) for strict compliance
   - What's unclear: Whether hotlinking the Google-hosted PNG is acceptable for a hobby/indie project
   - Recommendation: Download the badge PNG during implementation and commit to `public/google-play-badge.png`. Avoids third-party dependency and any future URL changes.

3. **OG placeholder image: SVG vs. PNG**
   - What we know: OG image scrapers universally support PNG/JPG; SVG support is inconsistent across platforms
   - What's unclear: Whether Claude should generate a simple branded PNG or use a tool like sharp/canvas
   - Recommendation: Create a simple SVG in `public/og-image.svg` for source control friendliness, but convert to PNG during implementation. Alternatively, a flat-color PNG with text overlay created via any image tool is sufficient for Phase 1.

---

## Sources

### Primary (HIGH confidence)
- https://docs.astro.build/en/guides/deploy/github/ — GitHub Pages deployment, CNAME setup, `site`/`base` configuration
- https://docs.astro.build/en/guides/fonts/ — Astro Fonts API syntax, Google provider configuration
- https://tailwindcss.com/docs/theme — `@theme` directive, custom color/font tokens, namespace conventions
- https://tailwindcss.com/docs/installation/framework-guides/astro — `@tailwindcss/vite` setup, `@import "tailwindcss"` syntax
- https://tailwindcss.com/docs/dark-mode — `@custom-variant dark` for class-based dark mode in v4
- https://astro.build/blog/astro-6/ — Astro 6 breaking changes (Node 22+, stable Fonts API)
- https://github.com/actions/starter-workflows/blob/main/pages/astro.yml — Official GitHub Actions starter workflow YAML with concurrency settings

### Secondary (MEDIUM confidence)
- https://github.com/withastro/action — `withastro/action@v6` confirmed as latest (Mar 19, 2026 release); Node 24 default
- `play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png` — Official Google Play badge PNG URL (sourced from multiple community references; direct URL pattern verified from search)

### Tertiary (LOW confidence)
- Search results re: Astro 6 Fonts API stable status — confirmed by blog post but experimental docs URL path is ambiguous

---

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — Verified against official Astro 6 and Tailwind v4 documentation
- Architecture: HIGH — Patterns derived directly from official docs examples
- GitHub Actions workflow: HIGH — Starter workflow YAML fetched from official GitHub Actions repo
- Pitfalls: HIGH — Each pitfall is grounded in a specific documented behaviour (base path injection, v4 config change, CNAME persistence)
- Font loading: MEDIUM — Astro Fonts API config verified; experimental vs stable flag for Astro 6.1.x has minor ambiguity

**Research date:** 2026-03-28
**Valid until:** 2026-04-28 (30 days — Astro and Tailwind are stable, but GitHub Actions action versions may update)
