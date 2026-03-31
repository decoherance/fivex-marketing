# Phase 2: Page Sections - Research

**Researched:** 2026-03-31
**Domain:** Astro component architecture, Tailwind CSS v4, scroll animations, section-by-section marketing page
**Confidence:** HIGH

---

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

**Hero layout & CTA**
- Two-column layout on desktop: headline + subtext + Play Store badge on left, phone mockup on right
- On mobile (375px+): all three elements (headline, badge, phone mockup) should be visible above the fold — keep compact
- Phone mockup uses a branded placeholder frame (branded colors + app name inside) until real screenshots are available
- Video background with fallback to dark-to-brand gradient — video file will be provided later, build gradient first with a video slot ready
- Play Store badge is the dominant visual CTA above the fold

**Feature highlights**
- 2x2 icon card grid on desktop, single column stack on mobile
- Each card: line icon (Lucide/Heroicons style) + title + 1-2 sentence description
- Four features: pre-defined programmes, custom programmes, history tracking, offline/no-internet
- Section has a heading + subtitle above the cards (e.g. "What you get")

**Differentiators presentation**
- Banner-style callout cards in a row (3 cards), stacking vertically on mobile
- Each card: bold statement + one-liner supporting sentence (e.g. "No account needed" + "Open the app and start training")
- Brand accent treatment — green/teal accent borders or backgrounds, cohesive with page palette
- Section has its own heading above the cards (e.g. "Why FiveX Strong" or similar)
- Must be visually distinct from the features grid — these are trust/value signals, not feature descriptions

**Visual style & tone**
- Dark theme throughout — `#0e0e0e` base background
- Bold & energetic vibe — high contrast, strong typography, dynamic feel (Nike Training / Freeletics territory)
- Section transitions use spacing only — no dividers, no background color shifts between sections
- Subtle entrance animations (fade-in, slide-up) as sections enter viewport via Intersection Observer
- Style reference: Titan Kinetic "Obsidian Performance Lab" design system and FiveX Strong mobile site mockup (files in ~/Downloads/stitch_home_dashboard) — use as inspiration for visual language, NOT to copy

### Claude's Discretion
- Exact copy/headlines for each section (placeholder copy is fine, will be refined)
- Screenshot section layout and treatment
- CTA section design and closing copy
- Footer layout and link arrangement
- Specific animation timing and easing
- Phone mockup placeholder design details
- Icon selection for each feature card

### Deferred Ideas (OUT OF SCOPE)
None — discussion stayed within phase scope
</user_constraints>

---

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| HERO-01 | User sees app name "FiveX Strong" with brand-consistent headline | Space Grotesk heading + existing `font-heading` token; existing index.astro headline as starting point |
| HERO-02 | User sees a 1-2 sentence value proposition | Simple `<p>` with `text-text-secondary` token; existing copy in index.astro can be reused |
| HERO-03 | User can tap a prominent Google Play download button | `/google-play-badge.png` already in `/public`; `playStoreUrl` exported from `config.ts`; `<a>` wrapping `<img>` |
| HERO-04 | User sees a placeholder phone mockup | Pure CSS/Tailwind phone frame pattern (no external lib); branded placeholder content inside |
| FEAT-01–04 | Four feature highlight cards | `@lucide/astro` package; 2×2 grid via Tailwind `grid-cols-2`; one component per card |
| DIFF-01–03 | Three prominent differentiator callouts | Distinct banner-card component with brand-green left border or background tint; `border-l-4 border-brand-green` pattern from reference |
| SCRN-01 | Placeholder screenshot slots | Aspect-ratio boxes with placeholder styling; 2–4 in a row; ready to swap real images |
| CTA-01 | Closing section with Play Store button | Re-use badge + link pattern from hero; CTA section component |
| FOOT-01 | Footer Play Store link | `playStoreUrl` from `config.ts` |
| FOOT-02 | Footer support email | Hardcoded `mailto:` link; email address needs supplying by user |
| FOOT-03 | Footer privacy policy link | Placeholder `href` until privacy page is built |
</phase_requirements>

---

## Summary

This phase builds on a working Astro 6 + Tailwind v4 foundation (Phase 1). All design tokens, fonts (Space Grotesk + Inter), and base layout are already established in `src/styles/global.css` and `astro.config.mjs`. The task is purely additive: create one `.astro` component file per section, import them into `index.astro`, and wire up scroll animations.

The key technical decision already made is to use `@lucide/astro` for icons — this is the official Lucide package for Astro, ships zero runtime JS, and is tree-shaken per import. Each icon is an Astro component rendering an inline SVG. The phone mockup will be built with pure CSS/Tailwind (no image, no external library), matching the brand palette. Video background support is deferred until a video file is available, but the `<video>` tag slot must be present, hidden behind the gradient fallback via a CSS conditional.

Intersection Observer animations are implemented as a single vanilla `<script>` in a shared utility component or `BaseLayout`. The pattern is: elements start with `opacity-0 translate-y-4` (Tailwind utility classes), the observer adds an `is-visible` class that transitions them to `opacity-100 translate-y-0`. No animation library is needed.

**Primary recommendation:** One component file per section in `src/components/sections/`, imported and assembled in `index.astro`. All config values (Play Store URL, support email, privacy URL) flow through `src/config.ts`.

---

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| Astro | ^6.1.2 (installed) | Static site framework, component model | Already installed; `.astro` components compile to zero-JS HTML by default |
| Tailwind CSS v4 | ^4.2.2 (installed) | Utility CSS; design tokens via `@theme` | Already installed; all brand tokens defined in `global.css` |
| `@tailwindcss/vite` | ^4.2.2 (installed) | Vite plugin for Tailwind v4 | Required adapter for Tailwind v4 with Vite/Astro |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| `@lucide/astro` | ^1.7.0 (latest as of research) | Line icons as Astro SVG components | Feature card icons; zero runtime JS; tree-shakeable |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| `@lucide/astro` | Heroicons (SVG files in `/public`) | Manual SVG copy-paste; no type safety; more maintenance |
| `@lucide/astro` | Material Symbols font | External font dependency; heavier; reference files use it, but project spec says no external font dependency |
| Pure CSS phone mockup | External mockup image / device-frames npm | Image = binary asset to maintain; npm package = more dep; CSS is zero-dep and themeable |
| Intersection Observer (vanilla) | AOS, GSAP, Motion One | AOS needs CDN/npm; GSAP is heavyweight; vanilla IO is built into all modern browsers |

**Installation:**
```bash
npm install @lucide/astro
```

---

## Architecture Patterns

### Recommended Project Structure
```
src/
├── components/
│   └── sections/
│       ├── HeroSection.astro
│       ├── FeaturesSection.astro
│       ├── DifferentiatorsSection.astro
│       ├── ScreenshotsSection.astro
│       ├── CtaSection.astro
│       └── FooterSection.astro
├── layouts/
│   └── BaseLayout.astro       # already exists — add scroll-animate script here
├── pages/
│   └── index.astro            # import and assemble all sections
├── styles/
│   └── global.css             # already exists — add animation utility classes here
└── config.ts                  # already exists — add supportEmail, privacyPolicyUrl
```

### Pattern 1: Astro Section Component
**What:** Each section is a self-contained `.astro` file. No props needed (content is hardcoded placeholder copy at this stage). Exports zero JavaScript.
**When to use:** All six page sections.

```astro
---
// src/components/sections/FeaturesSection.astro
import { Dumbbell, ListChecks, History, WifiOff } from '@lucide/astro';
---

<section id="features" class="py-24 px-6 max-w-7xl mx-auto animate-on-scroll">
  <h2 class="font-heading text-4xl font-bold tracking-tight text-text-primary">
    What you get
  </h2>
  <p class="text-text-secondary mt-3 text-lg">...</p>
  <div class="mt-12 grid grid-cols-1 sm:grid-cols-2 gap-6">
    <!-- Feature cards -->
  </div>
</section>
```

### Pattern 2: Lucide Icon Usage
**What:** Import named icon from `@lucide/astro` in frontmatter; use as component in template.
**When to use:** Feature card icons.

```astro
---
import { Dumbbell } from '@lucide/astro';
---
<Dumbbell size={28} class="text-brand-green" />
```

Supported props: `size` (number, default 24), `color` (string, default currentColor), `strokeWidth` (number, default 2), plus any standard SVG attribute (`class`, `aria-label`, etc.).

### Pattern 3: Intersection Observer Scroll Animation
**What:** A single `<script>` tag added once to `BaseLayout.astro` (or a dedicated `ScrollAnimations.astro` component included in the layout). Observes all `.animate-on-scroll` elements.
**When to use:** Applied to every section root element.

```html
<!-- In BaseLayout.astro, before </body> -->
<script>
  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add('is-visible');
          observer.unobserve(entry.target); // fire once
        }
      });
    },
    { threshold: 0.1 }
  );
  document.querySelectorAll('.animate-on-scroll').forEach((el) => {
    observer.observe(el);
  });
</script>
```

CSS utilities to add to `global.css`:
```css
@layer utilities {
  .animate-on-scroll {
    opacity: 0;
    transform: translateY(1rem);
    transition: opacity 0.5s ease, transform 0.5s ease;
  }
  .animate-on-scroll.is-visible {
    opacity: 1;
    transform: translateY(0);
  }
}
```

**Note:** Astro bundles `<script>` tags by default (makes them `type="module"`) and deduplicates them — putting it once in `BaseLayout.astro` is enough. Use `is:inline` only if you need to avoid module bundling (not needed here).

### Pattern 4: Video Hero with Gradient Fallback
**What:** CSS background gradient as the base; `<video>` tag on top with `hidden` class until a real video file is provided. Swap is a one-line class change.
**When to use:** Hero section only.

```astro
<section class="relative min-h-screen overflow-hidden">
  <!-- Gradient fallback (always visible) -->
  <div
    class="absolute inset-0 bg-gradient-to-br from-surface-base via-surface-card to-[#001a0d]"
    aria-hidden="true"
  ></div>

  <!-- Video slot (add src and remove `hidden` when video is ready) -->
  <video
    class="absolute inset-0 w-full h-full object-cover hidden"
    autoplay
    muted
    loop
    playsinline
    aria-hidden="true"
  >
    <!-- <source src="/hero-video.mp4" type="video/mp4"> -->
  </video>

  <!-- Content layer -->
  <div class="relative z-10 ...">...</div>
</section>
```

### Pattern 5: Pure CSS Phone Mockup Placeholder
**What:** A Tailwind-styled `<div>` that looks like a rounded phone frame. Branded colors and app name inside. No images, no external assets.
**When to use:** Hero section right column (desktop), stacked below content (mobile).

```astro
<!-- Outer frame -->
<div class="relative mx-auto w-[200px] h-[400px] rounded-[2.5rem] border-4 border-border bg-surface-card shadow-[0_0_40px_rgba(0,230,118,0.15)] flex flex-col overflow-hidden">
  <!-- Status bar mockup -->
  <div class="h-8 bg-surface-raised flex items-center justify-center">
    <div class="w-16 h-4 rounded-full bg-surface-base"></div>
  </div>
  <!-- Screen content -->
  <div class="flex-1 flex flex-col items-center justify-center gap-3 px-4">
    <div class="text-brand-green text-4xl font-heading font-bold">5X</div>
    <div class="text-text-secondary text-xs text-center uppercase tracking-widest">FiveX Strong</div>
    <div class="w-8 h-1 rounded bg-brand-green opacity-60"></div>
  </div>
  <!-- Home bar mockup -->
  <div class="h-8 flex items-center justify-center">
    <div class="w-20 h-1 rounded-full bg-border"></div>
  </div>
</div>
```

### Pattern 6: Differentiator Card with Brand Accent
**What:** Card using a left border accent (`border-l-4 border-brand-green`) and `bg-surface-card` — visually different from the feature grid which uses icon headers.
**When to use:** Differentiators section (3 cards: no account, free forever, data on device).

```astro
<div class="border-l-4 border-brand-green bg-surface-card rounded-lg p-6">
  <p class="font-heading font-bold text-xl text-text-primary">No account needed</p>
  <p class="text-text-secondary text-sm mt-2">Open the app and start training — no sign-up, no email.</p>
</div>
```

### Pattern 7: Screenshot Placeholder Slots
**What:** Aspect-ratio boxes with dashed border, placeholder label inside. Sized for portrait mobile screen proportions (9:19 approximately).
**When to use:** Screenshots section (2–4 slots).

```astro
<div class="aspect-[9/19] w-full max-w-[140px] rounded-2xl border-2 border-dashed border-border bg-surface-card flex items-center justify-center">
  <span class="text-text-muted text-xs uppercase tracking-widest">Screenshot</span>
</div>
```

### Anti-Patterns to Avoid
- **Putting all sections in `index.astro` inline:** Kills maintainability; each section becomes its own file.
- **Using `document.querySelector` in an Astro component `<script>` without scoping:** Works fine when component appears once, but use `is:inline` or custom elements pattern if any component repeats.
- **Putting animation CSS in `<style>` tags inside each section component:** Leads to duplication; put in `global.css` as utilities once.
- **Using `client:visible` on non-interactive Astro components:** Not needed; scroll animations via IO don't require framework hydration.
- **Hard-coding Play Store URL:** Always import from `config.ts`.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Line icons | Custom SVG files in `/public` | `@lucide/astro` | Tree-shaken, typed, maintained; SVG files require manual updates |
| Scroll animations | Custom scroll event listener | Intersection Observer API (native) | `scroll` events fire constantly and require `requestAnimationFrame` throttling; IO is async and performant by default |
| CSS resets / normalisation | Own reset stylesheet | Tailwind v4's built-in Preflight | Already active via `@import "tailwindcss"` |
| Design tokens | Inline hex values in markup | `@theme` variables in `global.css` | Already done in Phase 1; use the existing tokens (`text-brand-green`, `bg-surface-card`, etc.) |

**Key insight:** The design token system is already built. Phase 2 should never use raw hex values in markup — every color reference goes through an existing Tailwind token.

---

## Common Pitfalls

### Pitfall 1: Mobile "above the fold" hero complexity
**What goes wrong:** On 375px viewport, a two-column hero hero with headline + badge + phone mockup easily overflows the fold if elements are full-size. Visitor sees only partial content without scrolling.
**Why it happens:** Desktop phone mockup placeholder can be 400px+ tall; headline + badge alone can be 200px; navbar adds ~60px. Total exceeds 667px (375×667 common dimensions).
**How to avoid:** On mobile (`sm:` breakpoint and below): stack elements, reduce phone mockup to ≈180px tall, use compact spacing. Test at exactly 375×667 in browser devtools.
**Warning signs:** Phone mockup specified at a fixed large height without responsive sizing.

### Pitfall 2: Tailwind v4 `@theme inline` vs `@theme`
**What goes wrong:** Using `@theme` (not `inline`) for font CSS variables that reference other CSS variables causes the utility class to carry `var(--font-inter)` literally rather than the resolved font stack. Fonts may not apply in some browsers.
**Why it happens:** Without `inline`, resolution happens where the variable is defined (in `@theme`), not where it's used.
**How to avoid:** Already handled in Phase 1 — `global.css` uses `@theme inline` correctly for font aliases. Do not change this pattern.
**Warning signs:** Fonts not rendering even though tokens look correct.

### Pitfall 3: Astro script deduplication breaks if `is:inline` is used
**What goes wrong:** If the scroll-animation `<script>` is written with `is:inline`, Astro won't deduplicate it. If `BaseLayout.astro` is included multiple times (unlikely but possible with nested layouts), the observer initialises twice.
**Why it happens:** `is:inline` opts out of Astro's bundling and deduplication.
**How to avoid:** Don't use `is:inline` for the animation script — use a plain `<script>` tag and Astro handles deduplication automatically.
**Warning signs:** Console warning about duplicate custom element definitions, or double fade-in firing.

### Pitfall 4: Video element causes CLS without explicit dimensions
**What goes wrong:** The `<video>` tag (even if `hidden`) can cause layout shift during hydration on some browsers if it doesn't have explicit dimensions.
**Why it happens:** Browser reserves space for the video before it determines it is hidden.
**How to avoid:** Wrap the video in the same `absolute inset-0` container as the gradient; it never contributes to flow layout.
**Warning signs:** Lighthouse CLS score spikes on hero section.

### Pitfall 5: Scroll animation elements invisible with JS disabled (or slow JS parse)
**What goes wrong:** If elements start with `opacity: 0` and the IO script hasn't run yet (slow network, no JS), the page appears blank.
**Why it happens:** CSS sets initial opacity to 0 regardless of JS.
**How to avoid:** Use the `.animate-on-scroll` class as the trigger — add it via JS (`document.querySelectorAll`), not in the HTML. Elements without the class are visible by default. This is a progressive-enhancement approach.

Alternative (simpler): Keep `opacity-0` in HTML but add a CSS rule `.no-js .animate-on-scroll { opacity: 1; transform: none; }` and set a `<noscript>` fallback, or set `.animate-on-scroll { opacity: 1; }` and override with JS `classList.add('will-animate')` before observing. **Recommended:** Add `animate-on-scroll` class in HTML markup (simpler to plan), but accept the JS-off edge case as acceptable for a mobile app marketing page.
**Warning signs:** FOUC (flash of unstyled/invisible content) on slow connections.

### Pitfall 6: Google Play badge already exists as PNG — don't recreate
**What goes wrong:** Implementing a CSS-styled "Download on Google Play" button instead of using the official badge.
**Why it happens:** Designer reflex to customise.
**How to avoid:** `/public/google-play-badge.png` is already present. `playStoreUrl` is already in `config.ts`. Just use `<a href={playStoreUrl}><img src="/google-play-badge.png" /></a>`. Swapping to SVG is an optional improvement, not a requirement.
**Warning signs:** Any task that says "create a Play Store button".

---

## Code Examples

Verified patterns from official sources and project analysis:

### Importing and assembling sections in index.astro
```astro
---
// src/pages/index.astro
import BaseLayout from '../layouts/BaseLayout.astro';
import HeroSection from '../components/sections/HeroSection.astro';
import FeaturesSection from '../components/sections/FeaturesSection.astro';
import DifferentiatorsSection from '../components/sections/DifferentiatorsSection.astro';
import ScreenshotsSection from '../components/sections/ScreenshotsSection.astro';
import CtaSection from '../components/sections/CtaSection.astro';
import FooterSection from '../components/sections/FooterSection.astro';
---

<BaseLayout>
  <HeroSection />
  <FeaturesSection />
  <DifferentiatorsSection />
  <ScreenshotsSection />
  <CtaSection />
  <FooterSection />
</BaseLayout>
```

### Existing design tokens (already in global.css — use these, not raw hex)
```
text-brand-green     → #00E676
text-brand-teal      → #00BFA5
bg-surface-base      → #0a0a0a
bg-surface-card      → #141414
bg-surface-raised    → #1a1a1a
border-border-subtle → #222222
border-border        → #2e2e2e
text-text-primary    → #f5f5f5
text-text-secondary  → #b0b0b0
text-text-muted      → #717171
font-heading         → Space Grotesk (via CSS var)
font-body            → Inter (via CSS var)
```

**Note:** The reference mockup at `~/Downloads/stitch_home_dashboard/code.html` uses `#3fff8b` as its primary green. The project's `global.css` uses `#00E676`. These are close but different — follow `global.css`, not the reference.

### config.ts additions needed
```typescript
// Add to src/config.ts
export const supportEmail = 'support@PLACEHOLDER.com'; // user must supply
export const privacyPolicyUrl = '/privacy';             // placeholder until privacy page built
```

### Feature card Lucide icon + title + description pattern
```astro
---
import { WifiOff } from '@lucide/astro';
---
<div class="bg-surface-card rounded-xl p-6 border border-border-subtle">
  <WifiOff size={28} class="text-brand-green mb-4" />
  <h3 class="font-heading font-bold text-lg text-text-primary">Works offline</h3>
  <p class="text-text-secondary text-sm mt-2 leading-relaxed">
    No Wi-Fi? No problem. All your workouts and history are stored on your device.
  </p>
</div>
```

### Suggested Lucide icon mapping for features
| Feature | Lucide Icon |
|---------|-------------|
| Pre-defined programmes | `Layers` or `BookOpen` |
| Custom programmes | `PenLine` or `Settings2` |
| History tracking | `BarChart2` or `TrendingUp` |
| Offline / no internet | `WifiOff` |

---

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| `tailwind.config.js` JS config | CSS-first `@theme {}` in `.css` file | Tailwind v4 (2025) | No JS config file needed; tokens live in CSS |
| `@apply` heavy usage | Utility classes directly in HTML | Tailwind v4 guidance | `@apply` still works but not recommended for component styles |
| `lucide-react` for icons in Astro | `@lucide/astro` official package | 2024+ | Astro-native package; no React dependency needed |
| `document.addEventListener('scroll', ...)` | `IntersectionObserver` | 2019+, widely supported now | IO is async, no layout thrashing, all modern browsers |

**Deprecated/outdated:**
- `tailwind.config.js` with `theme.extend`: Still works in v4 for backward compat, but the v4-native way is `@theme` in CSS. The project already uses v4-native — don't revert.
- `astro-icon` package: Older community icon integration; `@lucide/astro` is now the official first-party Lucide package for Astro.

---

## Open Questions

1. **Support email address**
   - What we know: FOOT-02 requires a support contact email in the footer.
   - What's unclear: The actual email address is unknown — `src/config.ts` would be the right place to put it.
   - Recommendation: Add `supportEmail = 'support@PLACEHOLDER.com'` to `config.ts` now; planner should note the user must supply the real address.

2. **Privacy policy URL**
   - What we know: FOOT-03 requires a privacy policy link; no privacy page is being built in this phase.
   - What's unclear: Whether this should link to an external URL (e.g., Google Play privacy policy field) or a `/privacy` path.
   - Recommendation: Use `href="/privacy"` placeholder; add a comment so it's obvious it needs updating.

3. **`<nav>` component in Phase 1 or Phase 2**
   - What we know: The reference mockup includes a fixed top nav bar with backdrop blur. Phase boundary says "build sections" but the current `BaseLayout.astro` has no nav.
   - What's unclear: Whether a nav bar is in scope for this phase (it's not listed as a requirement ID).
   - Recommendation: A minimal sticky nav (logo + Download button) is not required by any requirement ID, but is conventional for a marketing page. Planner can treat it as discretionary — include it as part of `HeroSection.astro` or create a `NavBar.astro` component.

4. **Phone mockup size on mobile to stay above the fold**
   - What we know: Hero must show all three elements (headline, badge, phone mockup) above the fold at 375px.
   - What's unclear: Exact pixel budget after heading, value prop text, badge, and phone mockup stacked.
   - Recommendation: Phone mockup should be no taller than `160–180px` on mobile. Use `h-40` (160px) as the mobile constraint. Test with browser devtools at 375×667.

---

## Sources

### Primary (HIGH confidence)
- Astro 6 official docs (docs.astro.build) — component structure, script tags, layout patterns
- Tailwind CSS v4 official docs (tailwindcss.com/docs/theme) — `@theme`, `@theme inline`, namespace reference
- `src/styles/global.css` (project file, read directly) — existing tokens, font setup
- `astro.config.mjs` (project file, read directly) — Astro version, font providers
- `package.json` (project file, read directly) — installed dependency versions
- `src/pages/index.astro` (project file, read directly) — current index structure
- `~/Downloads/stitch_home_dashboard/code.html` (reference mockup, read directly) — visual patterns
- `~/Downloads/stitch_home_dashboard/DESIGN.md` (reference design doc, read directly) — color/type system

### Secondary (MEDIUM confidence)
- lucide.dev/guide/packages/lucide-astro — install and props (WebFetch of official docs)
- WebSearch: `@lucide/astro` version 1.7.0, npm package confirmed published and active

### Tertiary (LOW confidence)
- WebSearch: phone mockup CSS patterns — multiple sources agree on pure CSS div approach using `border-radius` + `border`, but specific implementation is hand-rolled for this project
- WebSearch: Intersection Observer animation patterns — multiple sources agree on the `opacity: 0 → 1 + translateY` approach; specific timing (0.5s ease) is a discretion choice

---

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — all core dependencies read directly from `package.json`; Lucide confirmed via official docs
- Architecture: HIGH — Astro component model confirmed via official docs; file structure follows Astro conventions
- Tailwind v4 patterns: HIGH — confirmed via official docs fetch; project already uses correct v4 patterns
- Animation approach: HIGH — Intersection Observer is native browser API, widely documented
- Pitfalls: MEDIUM — several based on direct code analysis (existing `global.css`/component) and verified patterns; edge cases around mobile fold sizing are estimation

**Research date:** 2026-03-31
**Valid until:** 2026-06-30 (Astro 6 and Tailwind v4 are stable; Lucide icons stable)
