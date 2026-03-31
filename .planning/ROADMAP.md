# Roadmap: FiveX Strong Marketing Site

## Overview

Three phases take the project from a blank repo to a live, validated marketing site. Phase 1 stands up the Astro + GitHub Pages pipeline and locks in design tokens — the foundation everything else builds on. Phase 2 builds every page section from hero to footer, assembling the complete single-page experience. Phase 3 validates the site against real devices and quality gates before the Play Store URL goes live.

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

Decimal phases appear between their surrounding integers in numeric order.

- [ ] **Phase 1: Foundation** - Astro project with Tailwind v4, brand tokens, fonts, and GitHub Pages CI/CD deploying a live URL
- [ ] **Phase 2: Page Sections** - All six page sections built and assembled into the complete single-page experience
- [ ] **Phase 3: Pre-Launch Validation** - Lighthouse, mobile, accessibility, and link verification before the site goes public

## Phase Details

### Phase 1: Foundation
**Goal**: A deployable Astro project is live on GitHub Pages with the brand design system in place and zero-content placeholder confirming the pipeline works
**Depends on**: Nothing (first phase)
**Requirements**: TECH-01, TECH-02, TECH-03, TECH-04, TECH-05
**Success Criteria** (what must be TRUE):
  1. Running `npm run build` produces a static site with no errors
  2. Pushing to main triggers GitHub Actions and the site deploys to the live GitHub Pages URL
  3. The live URL loads without 404s on assets (confirming base path is correctly configured)
  4. Brand colors (#00E676, #00BFA5, #D1C4E9), Space Grotesk, and Inter are available as Tailwind tokens and render correctly in the browser
  5. The page `<head>` includes correct OG title, description, and image meta tags
**Plans:** 2 plans
Plans:
- [ ] 01-01-PLAN.md — Scaffold Astro project with Tailwind v4, design tokens, fonts, and base layout with OG meta
- [ ] 01-02-PLAN.md — Branded placeholder landing page, Play Store badge, GitHub Actions CI/CD, and static assets

### Phase 2: Page Sections
**Goal**: Every page section is built and assembled in index.astro so a visitor can scroll the complete page from hero to footer
**Depends on**: Phase 1
**Requirements**: HERO-01, HERO-02, HERO-03, HERO-04, FEAT-01, FEAT-02, FEAT-03, FEAT-04, DIFF-01, DIFF-02, DIFF-03, SCRN-01, CTA-01, FOOT-01, FOOT-02, FOOT-03
**Success Criteria** (what must be TRUE):
  1. Visitor sees "FiveX Strong" headline and a value proposition sentence in the hero without scrolling on a 375px mobile viewport
  2. Visitor can tap the Google Play badge in the hero and reach the Play Store (or placeholder URL) — the button is the dominant visual CTA above the fold
  3. Visitor sees four feature highlights (pre-defined programmes, custom programmes, history tracking, offline/no-internet) in the features section
  4. "No account needed," "free forever, no paywall," and "data stays on your device" each appear as distinct, prominent callouts — not buried in a features list
  5. Visitor sees a closing CTA section and a footer with a Play Store link, support email, and privacy policy link
**Plans**: TBD

### Phase 3: Pre-Launch Validation
**Goal**: The site passes all quality gates and is safe to share publicly
**Depends on**: Phase 2
**Requirements**: (no new requirements — validates all prior requirements are correctly implemented)
**Success Criteria** (what must be TRUE):
  1. Lighthouse performance score is 95+ and accessibility score is 90+ on the deployed URL
  2. The page is fully usable at 360px viewport width with no horizontal scroll or clipped content
  3. No image has `alt="placeholder"` or an empty alt attribute (every visual element has meaningful alt text or is decorative and marked aria-hidden)
  4. All three footer links resolve correctly: Play Store URL opens the app listing, support email opens a mail client, privacy policy link loads a valid page
  5. OG link preview (tested via opengraph.xyz or equivalent) shows correct title, description, and image
**Plans**: TBD

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 2 → 3

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Foundation | 0/2 | Not started | - |
| 2. Page Sections | 0/TBD | Not started | - |
| 3. Pre-Launch Validation | 0/TBD | Not started | - |
