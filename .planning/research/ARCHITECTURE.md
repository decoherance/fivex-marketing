# Architecture Patterns

**Domain:** Single-page marketing site (Astro + GitHub Pages)
**Project:** FiveX Strong Marketing Site
**Researched:** 2026-03-28
**Confidence:** HIGH — Astro project structure is stable and well-documented; patterns verified against Astro v4/v5 conventions.

---

## Recommended Architecture

A single Astro page (`src/pages/index.astro`) that imports section-level components. No routing. No client-side state. No API calls. Pure static HTML output with Tailwind for styling.

```
src/
  pages/
    index.astro          ← single entry point, assembles all sections
  layouts/
    BaseLayout.astro     ← <html>, <head>, global meta, font loading
  components/
    sections/
      Hero.astro
      Features.astro
      Screenshots.astro
      Privacy.astro
      FinalCTA.astro
      Footer.astro
    ui/
      Button.astro       ← reusable CTA button (Google Play link)
      SectionHeading.astro
      FeatureCard.astro
      ScreenshotSlot.astro
  assets/
    images/              ← screenshots (placeholders or real PNGs)
    icons/               ← Google Play badge, feature icons (SVG)
public/
  favicon.svg
  robots.txt
astro.config.mjs
tailwind.config.mjs
package.json
```

### Why This Shape

- **One page, one route** — `src/pages/index.astro` is the only page. Astro's file-based routing makes this trivially correct.
- **Layout wraps everything** — `BaseLayout.astro` owns `<html>`, `<head>`, viewport meta, font `<link>` tags, and global CSS imports. Section components never touch the document shell.
- **Section components are dumb** — each section receives no props from the page; all content is hardcoded inside each section component. This is appropriate because there is no CMS, no dynamic data, and no reuse across pages.
- **UI components are reusable** — `Button.astro`, `SectionHeading.astro`, `FeatureCard.astro`, and `ScreenshotSlot.astro` accept props so they can be used consistently across multiple sections without duplicating markup or class strings.

---

## Component Boundaries

| Component | Responsibility | Communicates With | Props |
|-----------|---------------|-------------------|-------|
| `BaseLayout.astro` | Document shell: `<html>`, `<head>`, font loading, global styles | Receives page `<slot />` content from `index.astro` | `title`, `description` (SEO) |
| `index.astro` | Section assembly and page-level ordering | Imports all section components; passes into `BaseLayout` | None |
| `Hero.astro` | App name, tagline, primary download CTA | Uses `Button.astro` | None (static) |
| `Features.astro` | 3-feature grid (programmes, logging, history) | Uses `FeatureCard.astro` × 3 | None (static, features hardcoded) |
| `Screenshots.astro` | App screenshot display with placeholder slots | Uses `ScreenshotSlot.astro` × N | None (static) |
| `Privacy.astro` | Local-first / no-account / no-paywall messaging | None | None (static) |
| `FinalCTA.astro` | Closing download push | Uses `Button.astro` | None (static) |
| `Footer.astro` | Links: Google Play, Privacy Policy, GitHub | None | None (static) |
| `Button.astro` | Styled anchor tag for Google Play download | Used by Hero, FinalCTA | `href`, `label`, `variant` (primary/secondary) |
| `SectionHeading.astro` | Consistent `<h2>` + optional subtitle | Used by Features, Privacy, Screenshots, FinalCTA | `heading`, `subheading?` |
| `FeatureCard.astro` | Icon + title + description card | Used by Features | `icon`, `title`, `description` |
| `ScreenshotSlot.astro` | Image wrapper with aspect-ratio placeholder | Used by Screenshots | `src?`, `alt`, `width`, `height` |

---

## Data Flow

This site has no dynamic data. Data flows in one direction at build time only.

```
Build time:
  astro.config.mjs → sets output: 'static', base path for GitHub Pages
  tailwind.config.mjs → design tokens (colors, fonts, spacing)
  index.astro → imports sections → sections import UI components
  All content is static strings inside component templates

No runtime data flow.
No client-side JS state.
No API calls.
No props crossing page boundaries (sections are self-contained).
```

### Props Flow (within components)

```
index.astro
  └─ BaseLayout.astro  (title, description)
       └─ [slot]
            ├─ Hero.astro
            │    └─ Button.astro (href, label)
            ├─ Features.astro
            │    └─ FeatureCard.astro × 3 (icon, title, description)
            ├─ Screenshots.astro
            │    └─ ScreenshotSlot.astro × N (src?, alt)
            ├─ Privacy.astro
            ├─ FinalCTA.astro
            │    └─ Button.astro (href, label)
            └─ Footer.astro
```

Props only flow **downward** (parent to child). No event emission upward. No shared state store.

---

## Patterns to Follow

### Pattern 1: Layout as Document Shell

`BaseLayout.astro` owns everything above the `<body>` content. Section components never include `<html>` or `<head>` tags. The layout also loads Google Fonts via `<link>` preconnect + stylesheet in `<head>`.

```astro
---
// BaseLayout.astro
interface Props {
  title: string;
  description: string;
}
const { title, description } = Astro.props;
---
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width" />
    <title>{title}</title>
    <meta name="description" content={description} />
    <!-- Space Grotesk + Inter via Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@700;900&family=Inter:wght@400;500&display=swap" />
  </head>
  <body class="bg-[#0E0E0E] text-white">
    <slot />
  </body>
</html>
```

### Pattern 2: Section as Self-Contained Island

Each section component is a full visual region (`<section>` tag with padding, max-width container, full-width background). No section leaks styles into adjacent sections.

```astro
---
// Features.astro — no props, no imports of external data
import FeatureCard from '../ui/FeatureCard.astro';
---
<section class="py-20 px-4">
  <div class="max-w-5xl mx-auto">
    <!-- content -->
  </div>
</section>
```

### Pattern 3: Reusable UI Components with Props

Small UI components accept typed props via the Astro `Props` interface. This keeps section components free of repeated Tailwind class strings and ensures visual consistency.

```astro
---
// Button.astro
interface Props {
  href: string;
  label: string;
  variant?: 'primary' | 'ghost';
}
const { href, label, variant = 'primary' } = Astro.props;
---
<a href={href} class:list={[
  'inline-flex items-center gap-2 px-6 py-3 rounded-full font-bold transition',
  variant === 'primary' && 'bg-[#00E676] text-black hover:bg-[#00BFA5]',
  variant === 'ghost' && 'border border-[#00E676] text-[#00E676] hover:bg-[#00E676]/10'
]}>
  {label}
</a>
```

### Pattern 4: Static Assets in `src/assets/` vs `public/`

- **`src/assets/images/`** — app screenshots and any raster images processed by Astro's image optimization pipeline (`<Image />` component). Astro will optimize, resize, and convert to WebP at build time.
- **`public/`** — favicon, `robots.txt`, Google Play badge SVG (referenced directly by URL, no processing needed).

### Pattern 5: GitHub Pages Base Path

When deploying to `username.github.io/repo-name`, set `base` in `astro.config.mjs`. All internal asset references then use `import.meta.env.BASE_URL` automatically via Astro's built-in handling.

```javascript
// astro.config.mjs
import { defineConfig } from 'astro/config';
import tailwind from '@astrojs/tailwind';

export default defineConfig({
  output: 'static',
  site: 'https://username.github.io',
  base: '/fivex-marketing-site',  // if deploying to a project page
  integrations: [tailwind()],
});
```

If deploying to a custom domain or `username.github.io` root, omit `base`.

---

## Anti-Patterns to Avoid

### Anti-Pattern 1: Client-Side Framework for Static Content

**What:** Adding React/Vue/Svelte islands for section content that is purely static.
**Why bad:** Increases bundle size, adds hydration complexity, slows Time to Interactive — all with zero benefit for content that never changes.
**Instead:** Write everything as `.astro` components. Zero JS shipped by default.

### Anti-Pattern 2: Global CSS Class Overrides Between Sections

**What:** Writing CSS in one section component that targets elements in another section (e.g., `section + section { margin-top: ... }`).
**Why bad:** Creates implicit coupling. Reordering sections breaks spacing.
**Instead:** Each section manages its own top/bottom padding. Vertical rhythm is uniform via consistent `py-20` classes on each `<section>`.

### Anti-Pattern 3: Hardcoding Google Play URL in Multiple Places

**What:** Pasting the Google Play store link directly into `Hero.astro`, `FinalCTA.astro`, and `Footer.astro` as raw strings.
**Why bad:** When the URL changes (e.g., app goes live, package name changes), every component needs updating.
**Instead:** Define the URL once in a constants file or as a prop passed from `index.astro`, or centralise in a `src/config.ts` module that all components import.

```typescript
// src/config.ts
export const GOOGLE_PLAY_URL = 'https://play.google.com/store/apps/details?id=com.example.fivexstrong';
export const SITE_TITLE = 'FiveX Strong — Free Workout Tracker';
export const SITE_DESCRIPTION = '...';
```

### Anti-Pattern 4: Images in `public/` Without Optimization

**What:** Placing large PNG screenshots directly in `public/` and referencing via `<img src="/screenshot.png" />`.
**Why bad:** No automatic WebP conversion, no responsive srcsets, no lazy loading attributes. Large images on a marketing site kill Lighthouse scores.
**Instead:** Put screenshots in `src/assets/images/` and use Astro's `<Image />` component, which optimizes at build time.

### Anti-Pattern 5: Inline Styles for Brand Colors

**What:** Writing `style="color: #00E676"` directly on elements instead of using Tailwind.
**Why bad:** Bypasses Tailwind's purge/tree-shaking, creates inconsistency, harder to theme.
**Instead:** Extend Tailwind config with brand tokens:

```javascript
// tailwind.config.mjs
theme: {
  extend: {
    colors: {
      brand: {
        green: '#00E676',
        teal: '#00BFA5',
        purple: '#D1C4E9',
      },
      surface: {
        base: '#0E0E0E',
        elevated: '#121212',
      }
    },
    fontFamily: {
      display: ['Space Grotesk', 'sans-serif'],
      body: ['Inter', 'sans-serif'],
    }
  }
}
```

---

## Suggested Build Order

Dependencies drive this order. Build what a later component depends on before building that component.

| Step | What to Build | Why This Order |
|------|--------------|----------------|
| 1 | `tailwind.config.mjs` + brand tokens | Everything else uses these classes; define once, use everywhere |
| 2 | `src/config.ts` | Google Play URL and site metadata consumed by Layout and CTAs |
| 3 | `BaseLayout.astro` | Every page uses this; must exist before `index.astro` can render |
| 4 | `Button.astro`, `SectionHeading.astro` | Leaf UI components with no dependencies; Hero and others need them |
| 5 | `FeatureCard.astro`, `ScreenshotSlot.astro` | Leaf UI components needed by Features and Screenshots sections |
| 6 | `Hero.astro` | First visible section; establishes visual tone for everything below |
| 7 | `Features.astro` | Uses FeatureCard; second section in visual order |
| 8 | `Screenshots.astro` | Uses ScreenshotSlot with placeholder images |
| 9 | `Privacy.astro` | Standalone static section, no dependencies |
| 10 | `FinalCTA.astro` | Mirrors Hero's CTA; can reuse Button pattern already proven |
| 11 | `Footer.astro` | Last section; references config URLs |
| 12 | `index.astro` | Assembles all sections; can only be completed once all sections exist |
| 13 | GitHub Pages deployment config | `.github/workflows/deploy.yml`; validated after full page renders correctly |

---

## Scalability Considerations

This is intentionally a non-scalable concern — a single-page marketing site should resist scope creep.

| Concern | Now (v1) | If Scope Grows |
|---------|----------|----------------|
| Multiple pages (blog, changelog) | Not needed; single `index.astro` | Add `src/pages/` routes; layout already supports this |
| Content management | Hardcoded strings in components | Extract to `src/content/` collections (Astro Content Collections) |
| i18n | Out of scope | Astro has built-in i18n routing; restructure pages to `src/pages/[lang]/index.astro` |
| App screenshots become video | Placeholder slots ready | Replace `ScreenshotSlot` with a `VideoEmbed` component |
| Analytics | Not in v1 | Add Partytown integration to run analytics in a web worker; zero main thread cost |

---

## Confidence Assessment

| Claim | Confidence | Basis |
|-------|------------|-------|
| Astro project directory structure | HIGH | Stable convention since Astro v2; unchanged in v4/v5 |
| `output: 'static'` for GitHub Pages | HIGH | Standard Astro static adapter pattern |
| `base` config for GitHub Pages project pages | HIGH | Documented Astro deploy pattern |
| Tailwind config extension for brand tokens | HIGH | Standard Tailwind v3/v4 pattern |
| `<Image />` component for optimization | HIGH | Astro built-in since v3 |
| Props interface pattern in `.astro` components | HIGH | Core Astro component API, unchanged |
| `src/config.ts` for shared constants | MEDIUM | Common community pattern, not official requirement |
| Build order recommendations | MEDIUM | Logical dependency analysis; no single authoritative source |

---

## Sources

- Astro project structure docs: https://docs.astro.build/en/basics/project-structure/ (HIGH confidence — official)
- Astro components docs: https://docs.astro.build/en/basics/astro-components/ (HIGH confidence — official)
- Astro GitHub Pages deployment guide: https://docs.astro.build/en/guides/deploy/github/ (HIGH confidence — official)
- Astro image optimization: https://docs.astro.build/en/guides/images/ (HIGH confidence — official)
- Tailwind CSS configuration: https://tailwindcss.com/docs/configuration (HIGH confidence — official)
- Note: WebFetch and WebSearch tools were unavailable during this research session. Architecture recommendations are based on training knowledge (cutoff August 2025) of Astro v4/v5 stable conventions, which are well-established and unlikely to have changed materially.
