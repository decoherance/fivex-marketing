# Project Research Summary

**Project:** FiveX Strong Marketing Site
**Domain:** Single-page app marketing site (free, local-first Android workout tracker)
**Researched:** 2026-03-28
**Confidence:** MEDIUM

## Executive Summary

FiveX Strong is a free, local-first Android workout tracker with no account requirement and no data collection. The marketing site's sole job is to convert visitors into Play Store installs — and the product's genuine differentiators (no account, no cloud, free forever) are unusually compelling in a market crowded with subscription-gated, data-harvesting fitness apps. The recommended approach is to build a lean, zero-JavaScript single-page static site using Astro 5 + Tailwind CSS v4, deployed to GitHub Pages via GitHub Actions. This is a well-solved problem with clear patterns: one page, one CTA, section-based composition, no routing, no dynamic data.

The recommended stack is deliberately minimal. Astro's zero-JS-by-default output model is purpose-built for this use case. Tailwind v4's CSS-first configuration integrates cleanly via the `@tailwindcss/vite` plugin. Self-hosted fonts (Fontsource) eliminate the Google Fonts privacy and performance penalty. The entire site is static HTML generated at build time — no server, no runtime, no framework overhead. This delivers a Lighthouse score of 95+ and a fast LCP critical for mobile users arriving on Android devices.

The key risks are conversion risks, not technical ones. The pitfalls that matter most are: burying the CTA, leading with feature descriptions instead of the user's problem, and shipping with placeholder screenshots. On the technical side, the two deployment risks — missing the GitHub Pages `base` path config and failing WCAG contrast on the neon-green dark theme — are both addressed by following documented Astro patterns and running a Lighthouse audit before launch. These are preventable if caught in the scaffolding phase, and painful rewrites if not.

---

## Key Findings

### Recommended Stack

Astro 5 is the clear choice for this project. Its static output adapter targets GitHub Pages directly, ships zero JavaScript by default, and its component model gives clean section-by-section composition without the overhead of a full SPA framework. Tailwind v4's CSS-first configuration (via `@astrojs/vite` plugin, not the deprecated `@astrojs/tailwind` adapter) maps well to Astro's component authoring style and enables design token consistency through the `@theme` block. Font delivery via Fontsource eliminates cross-origin font dependencies entirely.

Note: All stack recommendations carry a MEDIUM confidence caveat. Research data has a cutoff of August 2025 and this project builds in March 2026. Run `npm outdated` after install to catch version drift, and verify `withastro/action` and `actions/deploy-pages` major versions against current Astro deploy docs before wiring CI.

**Core technologies:**
- **Astro 5** (^5.x): Static site generator — zero JS by default, ideal for GitHub Pages, island architecture if interactive components are ever needed
- **Tailwind CSS v4** (^4.x): Utility-first styling — CSS-first config via `@theme`, no `tailwind.config.js` required
- **`@tailwindcss/vite`** (^4.x): Vite plugin — registered in `astro.config.mjs`; replaces the deprecated `@astrojs/tailwind` adapter (do NOT install the old adapter)
- **Fontsource** (`@fontsource/space-grotesk` + `@fontsource-variable/inter`): Self-hosted fonts — eliminates Google Fonts round-trip and privacy leak
- **`sharp`** (^0.33): Image optimization peer dep — required when using Astro's `<Image />` component for screenshot optimization
- **GitHub Actions + `withastro/action@v3`**: CI/CD — official Astro action handles Node setup, caching, build, and Pages artifact upload in one step

**What NOT to use:**
- `@astrojs/tailwind` — deprecated v3 adapter, incompatible with Tailwind v4
- Google Fonts `<link>` tags — cross-origin, render-blocking, leaks visitor IPs
- React/Vue/Svelte islands for static content — unnecessary JS overhead for a purely static page

### Expected Features

The MVP page structure is a linear scroll with a single primary CTA throughout. Every section should reinforce the core positioning: private, free, no account required.

**Must have (table stakes):**
- Hero section with headline + Google Play CTA — first 5 seconds determine bounce; CTA must be above the fold on all viewports
- Google Play badge/button — official asset, single target, no competing CTAs
- App screenshots (2–3 minimum) — real UI, not polished mockups that don't match the actual app
- Value proposition statement — survives skimming, no jargon
- Feature highlights section — 3–6 benefits focused on outcomes, not feature names
- Mobile-responsive layout — minimum 360px; majority of visitors arrive on Android
- Fast page load — lean assets, zero unnecessary JS
- Privacy/data statement — plain English, local-first explained; this is a selling point, not legal boilerplate
- Support contact path — email or GitHub issues link; no form required
- Branding consistency with Play Store listing — exact app name, icon, color scheme

**Should have (differentiators):**
- "No account needed" prominent callout — visual badge or callout block, not buried in a features list
- "Free, forever" explicit statement — counters paywall skepticism before it forms
- Local-first / offline explanation — "your data stays on your phone," practical benefit for gym use without signal
- Programme showcase — shows depth without requiring a download; reduces "I don't know where to start" barrier
- History/progress tracking visual — single screenshot reassures users the app is persistent and capable
- Dark theme site matching app — the site is a preview of the app experience
- Approachable copy tone — avoid "crush," "beast," "shred"; use "track," "build," "consistent"
- Open source/GitHub link (if repo is public) — builds technical trust with privacy-focused users

**Defer (v2+):**
- Programme deep-dive section — describe in feature highlights for now; detailed showcase adds complexity without blocking launch
- Privacy-respecting analytics — decide on tool (Plausible, Fathom) after launch; don't let the decision block the site
- Open source section — only include if repo is public; verify before adding
- Blog/content section — zero near-term conversion benefit; adds maintenance burden

**Anti-features (explicitly do not build):**
- Newsletter/email signup — friction, contradicts "no account" brand promise
- Fake or placeholder social proof — the app is new; fabricated metrics destroy trust when cross-checked against Play Store
- Multiple competing CTAs — decision paralysis; one primary CTA everywhere
- iOS App Store badge — the app is Android only; a dead iOS link destroys trust
- Cookie consent banners — avoid analytics or third-party scripts that require consent
- Video autoplay — burns mobile data, delays page load

### Architecture Approach

The site is a single Astro page (`src/pages/index.astro`) that assembles section-level components. No routing, no client-side state, no API calls. `BaseLayout.astro` owns the document shell (`<html>`, `<head>`, font loading, global CSS). Section components (`Hero`, `Features`, `Screenshots`, `Privacy`, `FinalCTA`, `Footer`) are static and self-contained — no props from the page, content hardcoded inside each section. Reusable UI leaf components (`Button`, `SectionHeading`, `FeatureCard`, `ScreenshotSlot`) accept props for consistency. A `src/config.ts` module centralizes the Google Play URL and site metadata so it's updated in one place.

**Major components:**
1. `BaseLayout.astro` — document shell, SEO meta, Open Graph tags, font loading
2. `src/config.ts` — Google Play URL, site title, description (single source of truth)
3. Section components (`Hero`, `Features`, `Screenshots`, `Privacy`, `FinalCTA`, `Footer`) — self-contained visual regions, each managing its own spacing
4. UI leaf components (`Button`, `SectionHeading`, `FeatureCard`, `ScreenshotSlot`) — prop-driven, reusable, keep brand consistency without duplicating Tailwind class strings
5. `src/assets/images/` — screenshots processed by Astro's `<Image />` component for WebP optimization and responsive srcsets
6. `.github/workflows/deploy.yml` — GitHub Actions pipeline using `withastro/action@v3`

**Key patterns:**
- All internal asset references use Astro's `<Image />` component or `import` — never hardcoded `/path/to/image` strings, which break under GitHub Pages base path configuration
- Google Play URL defined once in `src/config.ts`, imported by `Hero`, `FinalCTA`, and `Footer`
- Brand color tokens defined in Tailwind's `@theme` block; neon green (`#00E676`) used exclusively for CTAs and large display text, never body copy
- Zero client-side JavaScript unless an interactive element genuinely requires it

### Critical Pitfalls

1. **Weak or buried hero CTA** — The Google Play button must be the dominant visual action above the fold on all viewport sizes. Reserve the neon green brand color exclusively for the CTA — using it decoratively elsewhere dilutes visual hierarchy and reduces install conversions. Apply the 5-second test before sign-off.

2. **Leading with features instead of the user's problem** — Headlines like "Track your workouts with FiveX Strong" describe the product; they don't engage the visitor's problem. Lead with the user's pain or goal ("Your workouts. Your phone. No account needed."). The "free, no account, local-first" value props must appear within the first scroll, not buried in a features section. Write hero copy last, after all other sections lock the positioning.

3. **Dark theme + neon green fails WCAG contrast** — Neon green on dark backgrounds looks great at large sizes but fails WCAG AA (4.5:1) for body text. Reserve the accent color for buttons, large display text, and icons only. All body text must be near-white (`#e5e5e5`+), not gray. Run Lighthouse accessibility audit before the site is considered done. Address this at design system setup — it's a painful retrofit.

4. **GitHub Pages base path not configured** — If deploying to `username.github.io/repo-name` (project page, not user/org page or custom domain), `base` must be set in `astro.config.mjs` from day one. Assets hardcoded with `/path/to/image` will 404 on the deployed site while working perfectly locally. Use Astro's `<Image />` component and asset imports — they respect the base path automatically. Set this in the first commit; verify with a test deploy before building content.

5. **Placeholder screenshots shipped to production** — Screenshot slots are deferred as "we'll add real ones later" and never get filled before launch. Treat screenshots as a launch blocker, not a deferral. If real screenshots aren't ready, use intentional branded mockups — not gray placeholder divs. Never ship `alt="placeholder"`.

---

## Implications for Roadmap

Based on research, suggested phase structure:

### Phase 1: Project Scaffolding and Deployment Pipeline

**Rationale:** The GitHub Pages base path bug and the missing OG tags are both painful retrofits if left until later. Standing up the deployment pipeline first means every subsequent phase is validated against the real production URL, not just localhost. Establishes the "no JS by default" constraint before any component work begins.

**Delivers:** Working Astro 5 project with Tailwind v4, Fontsource, brand design tokens, `src/config.ts` constants file, `BaseLayout.astro` with OG meta, GitHub Actions CI/CD pipeline deploying to GitHub Pages. Live URL confirmed working before content goes in.

**Addresses (from FEATURES.md):** Fast page load (architectural foundation), branding consistency (design tokens defined)

**Avoids (from PITFALLS.md):**
- Pitfall 4: GitHub Pages base path configured on day one
- Pitfall 12: OG tags in initial layout, not a retrofit
- Pitfall 13: Final URL decided before sharing begins
- Pitfall 10: "No JS by default" established as explicit constraint at scaffolding

**Stack elements:** Astro 5, Tailwind v4 + `@tailwindcss/vite`, Fontsource, `withastro/action@v3`, `actions/deploy-pages@v4`

---

### Phase 2: Design System and Copy

**Rationale:** Content and copy decisions must precede visual implementation. The hero headline in particular should be written last (after all other sections define the positioning), but the copywriting and messaging decisions need to happen before any section is built. The design system (color tokens, type scale, spacing) must be locked before component work starts — retrofitting brand colors after components are built breaks everything.

**Delivers:** Locked copy for all six sections (hero headline, subheadline, feature names and descriptions, privacy statement, footer links). Confirmed design token set in Tailwind `@theme` (brand green, teal, purple, surface colors, font families). WCAG contrast audit passed. Real app screenshots sourced and ready for import.

**Addresses (from FEATURES.md):** Value proposition statement, approachable copy tone, "no account" callout, "free forever" clarity, privacy plain-language statement

**Avoids (from PITFALLS.md):**
- Pitfall 2: Hero copy written with user problem first, not feature description
- Pitfall 3: Neon green assigned exclusively to large text and interactive elements; contrast verified before implementation
- Pitfall 6: No fake social proof; honest new-app positioning locked in copy
- Pitfall 5: Screenshot requirements defined as launch blockers in this phase

---

### Phase 3: UI Component Library

**Rationale:** Leaf UI components (`Button`, `SectionHeading`, `FeatureCard`, `ScreenshotSlot`) have no dependencies and are needed by multiple sections. Building them before the sections ensures visual consistency from the start and avoids duplicating Tailwind class strings across section components. This order mirrors the build order recommended in ARCHITECTURE.md.

**Delivers:** `Button.astro` (primary/ghost variants, tap-target compliant 48px+ height), `SectionHeading.astro`, `FeatureCard.astro`, `ScreenshotSlot.astro` (with aspect-ratio placeholder and Astro `<Image />` integration). All components mobile-first (375px base, scaling up). Unit-testable in isolation.

**Addresses (from FEATURES.md):** Mobile-responsive layout foundation, dark theme brand expression

**Avoids (from PITFALLS.md):**
- Pitfall 7: Mobile-first Tailwind classes from the first component; tap targets verified
- Pitfall 3: Brand color token used via Tailwind class names only, never inline styles
- Pitfall 8: `ScreenshotSlot` uses `<Image />` component with `loading` attribute from the start

---

### Phase 4: Section Implementation

**Rationale:** With copy locked, design tokens defined, and UI leaf components built, section assembly is straightforward. Build in the order the visitor reads them: hero first (sets visual tone and CTA pattern), then downward. Each section is self-contained and can be reviewed independently.

**Delivers:** All six sections complete and assembled in `index.astro`: `Hero`, `Features`, `Screenshots`, `Privacy`, `FinalCTA`, `Footer`. Single-page scroll experience functional end-to-end.

**Addresses (from FEATURES.md):** All table-stakes and differentiator features — hero CTA, Play Store badge, screenshots, feature highlights, "no account" callout, privacy statement, support path

**Avoids (from PITFALLS.md):**
- Pitfall 1: Hero CTA is the sole dominant visual action above the fold; neon green used nowhere else in the same viewport
- Pitfall 11: Official Google Play badge asset used without modification
- Pitfall 9: `scroll-behavior: smooth` on `<html>`; `scroll-margin-top` on anchored sections if sticky nav is added

---

### Phase 5: Pre-Launch Validation

**Rationale:** A structured pre-launch checklist prevents the most common launch failures. Mobile testing, Lighthouse audit, and screenshot verification must all pass before the URL is shared publicly. This is also the phase where the Play Store URL in `src/config.ts` is swapped from a placeholder to the live listing URL.

**Delivers:** Lighthouse scores verified (target: 95+ performance, 90+ accessibility), tested at 360px/390px/414px mobile viewports on Chrome DevTools and ideally a real Android device, all `alt` attributes reviewed (no "placeholder"), live Play Store URL confirmed in `src/config.ts`, OG preview tested via opengraph.xyz or similar, final deployed URL confirmed stable.

**Addresses (from FEATURES.md):** Fast page load (verified), mobile-responsive layout (verified), branding consistency (Play Store URL live)

**Avoids (from PITFALLS.md):**
- Pitfall 5: Placeholder screenshots caught before shipping
- Pitfall 7: Mobile experience validated on actual Android viewport sizes
- Pitfall 3: Lighthouse accessibility score confirmed 90+
- Pitfall 12: OG tags verified with link preview tool

---

### Phase Ordering Rationale

- Scaffolding and CI/CD first forces the base-path problem to be solved before any content is built on top of a broken foundation.
- Copy and design before components prevents the most expensive rework — retrofitting messaging changes after sections are built, or retrofitting contrast failures after the entire color system is in components.
- Leaf components before sections follows natural dependency order: sections import leaf components; building them first avoids circular work.
- Pre-launch validation as a named phase (not just "check stuff before pushing") ensures it happens. The most common failure mode is treating launch as the end of the section-implementation phase rather than a separate gate.

### Research Flags

**Phases with standard patterns (skip research-phase):**
- **Phase 1 (Scaffolding):** Astro + GitHub Pages deployment is thoroughly documented with official patterns. `withastro/action` workflow is copy-paste from Astro docs.
- **Phase 3 (UI Components):** Standard Astro component patterns, well-established. No external APIs or integrations.
- **Phase 4 (Sections):** Static HTML composition with Tailwind. No novel patterns.

**Phases that may benefit from a research spike before implementation:**
- **Phase 2 (Copy):** If the builder wants validated landing page copy formulas or wants to study current fitness app marketing site examples, a short research spike (lapa.ninja, land-book.com, actual Play Store app landing pages) would sharpen the messaging before any content is locked. Not a technical research need — a positioning/copy review.
- **Phase 5 (Pre-launch):** If privacy-respecting analytics are added, a brief spike on Plausible vs. Fathom configuration with Astro would be worthwhile. Low priority if analytics are deferred post-launch (recommended).

---

## Confidence Assessment

| Area | Confidence | Notes |
|------|------------|-------|
| Stack | MEDIUM | Astro 5 + Tailwind v4 are the right choices with high certainty; version numbers may have drifted since August 2025 cutoff — verify with `npm outdated` after install |
| Features | HIGH | App landing page structural patterns are stable and well-studied; differentiators derived directly from stated product facts (local-first, free, no account) |
| Architecture | HIGH | Astro project structure and static output patterns are stable since v2, well-documented officially; `src/config.ts` pattern is community convention not official requirement |
| Pitfalls | MEDIUM | Landing page conversion pitfalls are well-established (CXL, NNG); Astro-specific deployment pitfalls are documented; WCAG contrast requirements are stable standard |

**Overall confidence:** MEDIUM-HIGH

The domain (single-page static marketing site) is one of the most well-documented problem spaces in web development. The technology choices (Astro, Tailwind, GitHub Pages) are mature and well-documented. The main uncertainty is version drift between the August 2025 research cutoff and the March 2026 build date — this is a known, addressable gap (run `npm outdated`, check Astro deploy docs).

### Gaps to Address

- **Version verification at install time:** Run `npm view astro version`, `npm view tailwindcss version`, and check `withastro/action` and `actions/deploy-pages` current major versions against the Astro deploy docs before committing a lockfile. Do not assume pinned versions from research are still current patch versions.

- **Play Store URL:** The Google Play listing URL must be live before Phase 5 can complete. If the app isn't published yet, `src/config.ts` ships with a placeholder and the site cannot go live until the URL is replaced. This is a product dependency, not a technical one — surface it early.

- **Screenshots availability:** Real app screenshots are needed before Phase 4 can be completed. If they're not ready, the decision about intentional mockups vs. placeholder slots needs to be made in Phase 2 (copy/design), not discovered in Phase 4.

- **Custom domain decision:** The final URL (GitHub Pages project URL vs. custom domain) must be decided in Phase 1. GitHub Pages does not redirect from old URLs to new ones; changing the URL after sharing breaks all previously shared links.

- **Open source repo status:** The optional GitHub link in the footer requires the repo to be public. This is an on/off decision that should be confirmed in Phase 2 copy review.

---

## Sources

### Primary (HIGH confidence)
- Astro project structure docs — https://docs.astro.build/en/basics/project-structure/
- Astro components docs — https://docs.astro.build/en/basics/astro-components/
- Astro GitHub Pages deployment guide — https://docs.astro.build/en/guides/deploy/github/
- Astro image optimization — https://docs.astro.build/en/guides/images/
- WCAG 2.1 AA contrast requirements — https://webaim.org/resources/contrastchecker/

### Secondary (MEDIUM confidence)
- Tailwind CSS v4 documentation — https://tailwindcss.com/docs
- Tailwind v4 + Vite integration — https://tailwindcss.com/docs/installation/using-vite
- Fontsource — https://fontsource.org
- `withastro/action` GitHub repository — https://github.com/withastro/action
- App landing page conversion patterns — training knowledge, well-established patterns through mid-2025 (CXL, Nielsen Norman Group, Unbounce documented research)
- Google Play badge brand guidelines — https://play.google.com/intl/en_us/badges/

### Tertiary (LOW confidence — verify before use)
- Specific CRO copy formulas and button color recommendations — training data, not verified against 2026 studies
- Fitness-app-specific conversion rate benchmarks — general app patterns applied; fitness-specific nuances not verified with current sources

**Recommended reference sites for copy/positioning validation:**
- lapa.ninja — landing page gallery
- land-book.com — landing page examples
- Actual Play Store app landing pages for comparable indie fitness apps

---

*Research completed: 2026-03-28*
*Ready for roadmap: yes*
