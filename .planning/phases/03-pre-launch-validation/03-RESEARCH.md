# Phase 3: Pre-Launch Validation - Research

**Researched:** 2026-03-31
**Domain:** Web quality auditing — Lighthouse CLI, mobile viewport testing, accessibility, link verification, OG meta
**Confidence:** HIGH (standard tooling, well-documented, codebase fully read)

---

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

**Failure handling**
- Report-only approach: generate a report of all failures, then fix issues inline within this phase
- All five success criteria are hard gates — every one must pass before the site is launch-ready
- Small fixes (alt text, meta tags, minor CSS) are done within this phase, not sent back to Phase 2
- Produce a markdown checklist document with each criterion, status, and evidence

**Mobile testing scope**
- Test four viewport widths: 360px, 375px, 768px, 1280px
- Test both portrait and landscape orientations on mobile viewports
- Full mobile UX validation: no horizontal scroll, no clipped content, touch targets min 44x44px, body text min 16px
- Verify sticky Play Store CTA remains visible while scrolling on all tested viewports

**Link & asset verification**
- Play Store placeholder URL is acceptable for now — flag as pre-launch TODO that must be swapped before going public
- Privacy policy page exists externally — verify the link resolves to the existing URL
- OG preview validated by checking meta tags in HTML (og:title, og:description, og:image) — no external preview service needed
- Verify all images/assets load correctly on the deployed GitHub Pages URL (not just local build)

**Lighthouse thresholds**
- Performance 95+ and accessibility 90+ only (no thresholds for Best Practices or SEO)
- Run Lighthouse locally first (npm run preview) for fast feedback, then confirm on deployed URL
- No visual trade-offs to hit performance targets — if 95 isn't reachable, report why rather than degrading design
- Run Lighthouse 3 times per target, take median score to account for variance

### Claude's Discretion
- Lighthouse CLI vs programmatic API choice
- Order of validation checks
- Checklist document format and level of detail
- How to structure fix commits (batched vs per-issue)

### Deferred Ideas (OUT OF SCOPE)
None — discussion stayed within phase scope
</user_constraints>

---

## Summary

Phase 3 is a pure validation-and-fix phase with five hard gates: Lighthouse scores, mobile viewport integrity, alt text coverage, link resolution, and OG meta correctness. The stack is already built (Astro 6 + Tailwind v4, deployed to GitHub Pages). No new features are added here — only auditing and inline fixes.

The primary tooling recommendation is the **Lighthouse CLI** (npm package `lighthouse`, v13.0.3 as of Feb 2026) run against `npm run preview` locally, then confirmed on the deployed URL. Mobile testing is done through direct browser DevTools viewport emulation or a lightweight Node script using Playwright — but given the low complexity of the site (single static page, no JS interactions required), manual browser DevTools testing at the four specified widths is sufficient and faster than a full Playwright setup.

A critical pre-existing gap surfaces during validation: **the sticky Play Store CTA does not exist yet**. The memory file (`feedback_sticky_cta.md`) records this as deferred user feedback from Phase 2. The CONTEXT.md requires verifying it. This means Phase 3 must both implement the sticky CTA and then verify it — this is an inline fix that belongs in this phase per the failure-handling decision.

**Primary recommendation:** Run Lighthouse CLI with `--only-categories=performance,accessibility` 3x, take median. Fix issues in a single batched commit. Produce `03-LAUNCH-CHECKLIST.md` as the artifact.

---

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| lighthouse | 13.0.3 | Automated performance + accessibility audit | Google-maintained, industry standard, CLI + programmatic API |
| Node.js fetch / curl | built-in | HTTP status check for links | No extra dependency needed |

### Supporting
| Tool | Version | Purpose | When to Use |
|------|---------|---------|-------------|
| astro preview | via `npm run preview` | Serve production build locally on port 4321 | Fast local Lighthouse runs before deployed check |
| Browser DevTools | n/a | Viewport simulation at 360/375/768/1280px | Manual mobile responsiveness check |
| npm run build | via astro | Rebuild before every audit round | Ensure audit targets current code state |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Lighthouse CLI | @lhci/cli (Lighthouse CI) | lhci adds assertion config files and server; overkill for one-off validation. CLI is simpler. |
| Lighthouse CLI | Programmatic Node API | Programmatic requires managing Chrome launch manually. CLI handles it. Prefer CLI. |
| Manual DevTools viewport | Playwright automated | Playwright adds ~2min setup, npm install, and test file. Manual DevTools is faster for a single static page. |
| `fetch()` for link check | npm package (check-http-status) | Built-in Node fetch is sufficient for checking 3 links. No extra dependency. |

**Installation:**
```bash
npm install -g lighthouse
# Lighthouse 13 requires Node 22+ — project already requires Node >=22.12.0 (compatible)
```

---

## Architecture Patterns

### Recommended Validation Order

Run checks from cheapest/fastest to most expensive:

```
1. OG meta check         — static HTML parse, instant
2. Alt text audit        — static HTML parse, instant
3. Link resolution       — 3 HTTP HEAD requests, ~5s
4. Asset load check      — 3 HTTP HEAD requests for images, ~5s
5. Mobile viewport       — browser DevTools, ~10min manual
6. Lighthouse local      — 3 runs × ~60s = ~3min
7. Lighthouse deployed   — 3 runs × ~60s = ~3min (confirm after local passes)
```

Rationale: static checks first means you fix cheap issues before spending time on Lighthouse runs.

### Pattern 1: Lighthouse CLI Run (Local)

**What:** Run `astro preview`, then invoke Lighthouse against localhost.
**When to use:** Initial fast feedback loop before deployed check.

```bash
# Terminal 1: serve production build
cd /path/to/project && npm run build && npm run preview
# Default port: 4321

# Terminal 2: run Lighthouse 3 times, capture JSON
npx lighthouse http://localhost:4321 \
  --only-categories=performance,accessibility \
  --output=json \
  --output-path=./lighthouse-run-1.json \
  --chrome-flags="--headless" \
  --preset=desktop

# Extract scores from JSON:
node -e "
  const r = JSON.parse(require('fs').readFileSync('./lighthouse-run-1.json'));
  console.log('Performance:', Math.round(r.lhr.categories.performance.score * 100));
  console.log('Accessibility:', Math.round(r.lhr.categories.accessibility.score * 100));
"
```

Run 3 times, take median of each category score.

### Pattern 2: Lighthouse CLI Run (Deployed URL)

```bash
npx lighthouse https://fivexstrong.decoherance-interactive.com \
  --only-categories=performance,accessibility \
  --output=json \
  --output-path=./lighthouse-deployed-1.json \
  --chrome-flags="--headless"
```

Note: Deployed URL may score differently from local due to network latency simulation. Lighthouse applies throttling by default (slow 4G, 4x CPU slowdown). Both must pass 95/90.

### Pattern 3: OG Meta Check (Static HTML Parse)

```bash
# After npm run build, parse dist/index.html directly
node -e "
  const html = require('fs').readFileSync('./dist/index.html', 'utf8');
  const tags = ['og:title', 'og:description', 'og:image'];
  tags.forEach(tag => {
    const match = html.match(new RegExp('property=\"' + tag + '\" content=\"([^\"]+)\"'));
    console.log(tag + ':', match ? match[1] : 'MISSING');
  });
"
```

### Pattern 4: Alt Text Audit (Static HTML Parse)

```bash
node -e "
  const html = require('fs').readFileSync('./dist/index.html', 'utf8');
  const imgs = [...html.matchAll(/<img[^>]*>/g)].map(m => m[0]);
  imgs.forEach(img => {
    const alt = img.match(/alt=\"([^\"]*)\"/);
    const src = img.match(/src=\"([^\"]+)\"/);
    const altVal = alt ? alt[1] : 'MISSING';
    const isEmpty = altVal === '' || altVal === 'MISSING';
    const isPlaceholder = altVal.toLowerCase() === 'placeholder';
    const flag = (isEmpty || isPlaceholder) ? ' ← FAIL' : '';
    console.log('src:', src?.[1], '| alt:', JSON.stringify(altVal) + flag);
  });
"
```

Note: Empty alt (`alt=""`) is acceptable ONLY for decorative images that also have `aria-hidden="true"` on a parent. The audit must verify this context.

### Pattern 5: Link Resolution Check (Node fetch)

```bash
node -e "
const links = [
  { name: 'Play Store', url: 'https://play.google.com/store/apps/details?id=PLACEHOLDER_APP_ID' },
  { name: 'Support Email', url: 'mailto:support@decoherance-interactive.com' },
  { name: 'Privacy Policy', url: 'https://fivexstrong.decoherance-interactive.com/fivex/privacy-policy' }
];
(async () => {
  for (const link of links) {
    if (link.url.startsWith('mailto:')) {
      console.log(link.name + ': MAILTO — manual verification required');
      continue;
    }
    try {
      const res = await fetch(link.url, { method: 'HEAD', redirect: 'follow' });
      console.log(link.name + ':', res.status, res.ok ? 'OK' : 'FAIL');
    } catch(e) {
      console.log(link.name + ': ERROR —', e.message);
    }
  }
})();
" --input-type=module
```

Note: The Play Store URL uses `PLACEHOLDER_APP_ID` which will return a 404 or redirect to the store root. This is expected and acceptable per the locked decision — flag it as a pre-launch TODO, not a blocking failure.

### Pattern 6: Asset Load Check (Deployed URL)

```bash
node -e "
const assets = [
  'https://fivexstrong.decoherance-interactive.com/google-play-badge.png',
  'https://fivexstrong.decoherance-interactive.com/og-image.png',
  'https://fivexstrong.decoherance-interactive.com/favicon.svg'
];
(async () => {
  for (const url of assets) {
    const res = await fetch(url, { method: 'HEAD' });
    console.log(url.split('/').pop() + ':', res.status, res.ok ? 'OK' : 'FAIL');
  }
})();
" --input-type=module
```

### Pattern 7: Horizontal Scroll Check (DevTools Console)

Run this in DevTools console at each viewport width:

```javascript
// Paste into browser DevTools console at each viewport
const body = document.body;
const html = document.documentElement;
const bodyScroll = body.scrollWidth > body.clientWidth;
const htmlScroll = html.scrollWidth > html.clientWidth;
console.log('body overflow:', bodyScroll ? 'HORIZONTAL SCROLL DETECTED' : 'OK');
console.log('html overflow:', htmlScroll ? 'HORIZONTAL SCROLL DETECTED' : 'OK');
```

Note: Use `document.body` and `document.documentElement` together — `documentElement` alone is unreliable in Chrome/Safari.

### Pattern 8: Sticky CTA Implementation

The sticky Play Store CTA does **not currently exist** in the codebase. The existing CTA in HeroSection is only shown/hidden with `hidden lg:inline-block` and `lg:hidden` classes. A separate sticky bar must be added.

Recommended implementation: a `StickyCtaBar.astro` component with `position: fixed; bottom: 0` visible on mobile viewports, hidden on desktop (where the hero badge is already visible). It should not obstruct footer links — use a `pb-[height]` pad on the body or add auto-hiding when footer is in view.

```astro
---
// src/components/StickyCtaBar.astro
import { playStoreUrl } from '../config';
---
<!-- Sticky bottom bar: mobile only, hidden on lg+ -->
<div
  id="sticky-cta"
  class="fixed bottom-0 left-0 right-0 z-50 lg:hidden bg-surface-base/95 backdrop-blur border-t border-border-subtle py-3 px-4 flex justify-center"
>
  <a
    href={playStoreUrl}
    target="_blank"
    rel="noopener noreferrer"
    aria-label="Get FiveX Strong on Google Play"
    class="inline-block"
  >
    <img
      src="/google-play-badge.png"
      alt="Get it on Google Play"
      width="200"
      height="59"
    />
  </a>
</div>
```

Add to `BaseLayout.astro` before `</body>`. Add `pb-[80px] lg:pb-0` to `<body>` to prevent content being obscured on mobile.

### Anti-Patterns to Avoid

- **Running Lighthouse against `npm run dev`:** The dev server does not minify or optimize assets. Always run against `npm run preview` (the production build).
- **Taking a single Lighthouse score as definitive:** Variance of ±3-5 points is common. Always take the median of 3 runs.
- **Treating empty `alt=""` as a failure on all images:** Empty alt is correct for decorative images. Only fail when a meaningful image lacks alt, or when alt is literally "placeholder".
- **Assuming the privacy policy URL is relative:** It's stored in `config.ts` as `/fivex/privacy-policy` — this is a relative path that will resolve to `https://fivexstrong.decoherance-interactive.com/fivex/privacy-policy`. Verify the deployed URL returns 200.
- **Fixing issues in multiple scattered commits:** Batch all fixes into a single commit to keep the git history clean. One commit: "fix: pre-launch validation issues".

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Performance audit | Custom timing scripts | Lighthouse CLI | Lighthouse includes throttling, scoring, accessibility tree; not replicable manually |
| Accessibility audit | Manual DOM scan | Lighthouse accessibility category | Lighthouse runs axe-core under the hood; catches 30+ audit types |
| Score median calculation | Complex test harness | 3 CLI runs + manual median | Simple, transparent, no setup overhead |

**Key insight:** Lighthouse already covers both performance and accessibility (via axe-core) in one tool. No separate accessibility scanner needed.

---

## Common Pitfalls

### Pitfall 1: Lighthouse Variance Kills a Valid Site
**What goes wrong:** One run scores 94, another 97. If only one run is taken, you may make unnecessary changes or incorrectly pass.
**Why it happens:** Lighthouse applies CPU throttling that interacts with machine load. Cloud VMs especially show variance.
**How to avoid:** Run 3 times, take median. Document all three scores in the checklist.
**Warning signs:** Score differs by more than 4 points between runs.

### Pitfall 2: Local vs Deployed Scores Diverge
**What goes wrong:** Local preview scores 97, deployed scores 88. Differences come from font loading, GitHub Pages CDN latency, or missing HTTPS/HTTP2 optimizations.
**Why it happens:** `npm run preview` serves over HTTP/1.1 localhost — no CDN, no real-world network latency. Lighthouse applies throttled network emulation either way, but response time baselines differ.
**How to avoid:** Always confirm on the deployed URL after local passes. Fix on deployed URL is what matters for the gate.
**Warning signs:** Scores drop more than ~5 points between local and deployed.

### Pitfall 3: Sticky CTA Obscures Touch Targets in Footer
**What goes wrong:** A fixed-bottom sticky bar sits over footer links, making them untappable on small screens.
**Why it happens:** Footer is at the bottom of the page, sticky bar covers it.
**How to avoid:** Add `padding-bottom` to the page body equal to the sticky bar height (`pb-20` or similar). Alternatively, auto-hide when the footer enters the viewport using an IntersectionObserver.
**Warning signs:** Footer links fail the 44x44px touch target check, or are visually clipped.

### Pitfall 4: Lucide Icons Fail Alt Text Audit Incorrectly
**What goes wrong:** An auditor or script flags icon SVGs as missing alt text.
**Why it happens:** Lucide icons in `@lucide/astro` render with `aria-hidden="true"` by default — verified from the built `dist/index.html`. They are decorative and do not need alt text.
**How to avoid:** Confirm `aria-hidden="true"` is present on all icon SVGs in the built HTML before marking as pass. This is already the case in the current build.
**Warning signs:** Lighthouse accessibility flags icon SVGs — unlikely given `aria-hidden` is present.

### Pitfall 5: Privacy Policy URL Returns 404 on Deployed Site
**What goes wrong:** The privacy policy link (`/fivex/privacy-policy`) is a path on the same domain — but no page exists at that path in the Astro project (there is no `src/pages/fivex/privacy-policy.astro`).
**Why it happens:** `privacyPolicyUrl` in config.ts is a relative path pointing to an external page that should exist on the same domain, but may not be served by this Astro site.
**How to avoid:** Verify the deployed URL `https://fivexstrong.decoherance-interactive.com/fivex/privacy-policy` returns a 200 response. If it is a separate deployment, confirm it is live. If it 404s, this is a hard gate failure.
**Warning signs:** `fetch` returns non-200 for the privacy policy URL.

### Pitfall 6: Body Text Size Below 16px at 360px
**What goes wrong:** Tailwind's `text-sm` (`14px`) is used on several elements (footer links, feature card descriptions, screenshot labels). At 360px, these elements may be below the 16px body text requirement.
**Why it happens:** The decision specifies "body text min 16px" — but this may conflict with intentionally smaller utility text.
**How to avoid:** Clarify: the 16px minimum applies to the primary body/paragraph text (`text-base`, `text-text-secondary` paragraph copy), not small utility labels. Check `<p>` elements with body copy at 360px in DevTools. Inspect computed font-size.
**Warning signs:** DevTools computed styles show main paragraph text below 16px at 360px.

### Pitfall 7: Horizontal Scroll from Absolute-Positioned Hero Background
**What goes wrong:** The hero section uses `absolute inset-0` divs for background layers. If any absolutely positioned element extends beyond the viewport, it can cause horizontal scroll even when the main content fits.
**Why it happens:** `overflow-hidden` on the `<section>` prevents child overflow from escaping, but `overflow: hidden` on a parent with `min-h-screen` is already applied to the hero section — this should contain it.
**How to avoid:** Test at 360px portrait in DevTools. Run the horizontal scroll console check. The hero section has `overflow-hidden` — verify this is present in the built output.
**Warning signs:** `html.scrollWidth > html.clientWidth` returns true at any tested viewport.

---

## Code Examples

Verified patterns from official sources and codebase:

### Score Extraction from Lighthouse JSON
```javascript
// Source: https://github.com/GoogleChrome/lighthouse/blob/main/docs/readme.md
const result = JSON.parse(fs.readFileSync('./lighthouse-run.json', 'utf8'));
const perf = Math.round(result.lhr.categories.performance.score * 100);
const a11y = Math.round(result.lhr.categories.accessibility.score * 100);
```

### Lighthouse CLI with headless Chrome
```bash
# Source: official Lighthouse docs / npm package README
npx lighthouse <URL> \
  --only-categories=performance,accessibility \
  --output=json \
  --output-path=./lh-run.json \
  --chrome-flags="--headless"
```

### Horizontal Scroll Detection (MDN verified)
```javascript
// Source: MDN scrollWidth (https://developer.mozilla.org/en-US/docs/Web/API/Element/scrollWidth)
// Use both body and documentElement — documentElement alone unreliable in Chrome
const hasHorizontalScroll =
  document.body.scrollWidth > document.body.clientWidth ||
  document.documentElement.scrollWidth > document.documentElement.clientWidth;
```

### OG Meta Presence Check
```javascript
// Inline pattern — parse static HTML string
const html = fs.readFileSync('./dist/index.html', 'utf8');
const ogImage = html.match(/property="og:image" content="([^"]+)"/)?.[1];
// Verify: should be https://fivexstrong.decoherance-interactive.com/og-image.png
```

---

## Current State of the Codebase (Phase 3 Starting Point)

The planner needs to know what already exists and what is a known gap:

### Already implemented and needs verification only
- OG meta tags: `og:title`, `og:description`, `og:image`, `og:image:width`, `og:image:height`, `og:type`, `og:url` — all present in `BaseLayout.astro`, confirmed in `dist/index.html`
- Twitter Card meta: `twitter:card`, `twitter:title`, `twitter:description`, `twitter:image` — present
- Favicon: both `favicon.svg` and `favicon.ico` present in `/public`
- Alt text on images: `google-play-badge.png` has `alt="Get it on Google Play"` in all three locations. No images have `alt="placeholder"` or empty `alt`.
- Lucide icons: all rendered with `aria-hidden="true"` in built output — decorative, no alt needed
- Play Store URL: set in `src/config.ts` as `playStoreUrl` — contains `PLACEHOLDER_APP_ID`, used in 3 places in built HTML
- Privacy policy URL: set in `src/config.ts` as `/fivex/privacy-policy` (relative path — needs deployed verification)
- Support email: `mailto:support@decoherance-interactive.com` in footer
- GitHub Pages deploy: `.github/workflows/deploy.yml` configured and working
- OG image: `public/og-image.png` present, dimensions configured as 1200x630 in meta tags

### Known gap — must be implemented and then verified
- **Sticky Play Store CTA**: Does NOT exist in the current codebase. The `src/components/` directory has no sticky or fixed-position CTA component. The hero section has a mobile CTA inside the page flow (not sticky). A `StickyCtaBar.astro` component must be created and added to `BaseLayout.astro`. This is an inline fix per the failure-handling decision.

### Needs deployed verification (not verifiable from source alone)
- Privacy policy URL resolves on deployed domain
- All assets load correctly from the GitHub Pages URL
- Lighthouse scores on deployed URL (not just local)

---

## Checklist Document Format

The LAUNCH-CHECKLIST.md artifact should follow this structure:

```markdown
# FiveX Strong — Launch Readiness Checklist

**Validated:** [date]
**Build:** [git commit hash]
**Deployed URL:** https://fivexstrong.decoherance-interactive.com

## Hard Gates

| # | Criterion | Status | Evidence |
|---|-----------|--------|---------|
| 1 | Lighthouse Performance 95+ | PASS/FAIL | Local: 97/97/96 (median 97). Deployed: 96/95/97 (median 96) |
| 2 | Lighthouse Accessibility 90+ | PASS/FAIL | Local: 100/100/100 (median 100). Deployed: 100/100/100 (median 100) |
| 3 | Mobile usable at 360px | PASS/FAIL | No horizontal scroll, no clipped content, touch targets ≥44px, body text ≥16px |
| 4 | No placeholder/empty alt text | PASS/FAIL | 2 images found, all have meaningful alt. 0 empty alt. |
| 5 | All footer links resolve | PASS/FAIL | Play Store: placeholder (pre-launch TODO). Email: mailto OK. Privacy: 200. |
| 6 | OG meta correct | PASS/FAIL | og:title, og:description, og:image all present and correct |
| 7 | Sticky CTA visible on scroll | PASS/FAIL | Verified at 360px, 375px, 768px portrait+landscape |

## Pre-Launch TODOs (Non-blocking)

- [ ] Swap `PLACEHOLDER_APP_ID` in `src/config.ts` with real Play Store app ID before going public

## Evidence Log

[Per-check evidence with screenshots or console output]
```

---

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| axe-core standalone for a11y | Lighthouse includes axe-core | Lighthouse 5+ | No separate a11y tool needed |
| Lighthouse 12 (Node 18+) | Lighthouse 13 (Node 22+) | Feb 2026 | Project already uses Node >=22.12.0 — compatible |
| Separate `first-meaningful-paint` audit | Removed in Lighthouse 13 | Feb 2026 | Don't reference FMP in reports |
| Running Lighthouse against dev server | Always run against preview build | Best practice | Dev server skips minification, gives false scores |

---

## Open Questions

1. **Privacy policy URL validity on deployed domain**
   - What we know: `privacyPolicyUrl = '/fivex/privacy-policy'` in config.ts. No page at this path exists in the Astro project.
   - What's unclear: Is this path served by a separate deployment on the same domain? Does it currently return 200?
   - Recommendation: The link check task must verify this against the deployed URL. If it 404s, the fix is either: (a) create a minimal privacy policy page in `src/pages/fivex/privacy-policy.astro`, or (b) update `privacyPolicyUrl` to an absolute URL of the external policy page. Flag this as a likely fix candidate.

2. **Lighthouse score headroom for 95+ performance**
   - What we know: The site is a single-page static Astro build with minimal JS (one IntersectionObserver script), CSS-only animations, Google Fonts loaded with preload, optimized woff2 fonts. This profile typically scores 95-100.
   - What's unclear: Actual score on deployed GitHub Pages URL — not yet measured.
   - Recommendation: Run locally first. If local scores 95+, deployed is very likely to also pass given the lightweight stack. If not, investigate LCP (Largest Contentful Paint — likely the hero headline or Google Play badge image) and font display issues.

3. **Body text 16px rule at 360px**
   - What we know: Primary paragraph text uses `text-base` (16px) and `text-text-secondary`. Secondary labels use `text-sm` (14px) in feature cards and footer.
   - What's unclear: Whether the 16px rule applies to ALL text or only primary body copy. The phase criterion says "body text min 16px."
   - Recommendation: Apply the rule to `<p>` elements containing primary value prop copy. `text-sm` on feature card descriptions and footer utility text is conventional and not "body text" in the accessibility sense. Verify computed font-size on the hero value prop paragraph at 360px.

---

## Sources

### Primary (HIGH confidence)
- https://github.com/GoogleChrome/lighthouse — CLI installation, Node.js requirement (v22+), score structure
- https://developer.chrome.com/blog/lighthouse-13-0 — Lighthouse 13 changes confirmed (Node 22 requirement, removed audits)
- https://github.com/GoogleChrome/lighthouse/blob/main/docs/readme.md — `lhr.categories.performance.score` JSON path confirmed
- Codebase read directly — `src/config.ts`, `src/layouts/BaseLayout.astro`, all section components, `dist/index.html`
- https://lucide.dev/guide/advanced/accessibility — Lucide icons render with `aria-hidden="true"` by default

### Secondary (MEDIUM confidence)
- https://developer.mozilla.org/en-US/docs/Web/API/Element/scrollWidth — scrollWidth vs clientWidth comparison for horizontal scroll detection
- WebSearch results confirming Lighthouse 13.0.3 published Feb 11, 2026

### Tertiary (LOW confidence)
- Body text 16px rule scoping (body vs utility text) — interpreted from WCAG guidance, not directly cited from a decision

---

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — Lighthouse 13 is the established tool, version confirmed, Node compatibility confirmed
- Architecture (validation order): HIGH — ordering by cost is a well-established pattern; codebase read confirms starting state
- Known code gap (sticky CTA): HIGH — directly confirmed by reading every source file and memory file
- Pitfalls: HIGH for items confirmed against codebase; MEDIUM for performance score predictions (score not yet measured)
- OG meta status: HIGH — confirmed present in both source and built `dist/index.html`
- Privacy policy URL gap: HIGH — confirmed no page exists in Astro project at that path

**Research date:** 2026-03-31
**Valid until:** 2026-04-30 (Lighthouse releases monthly; thresholds and flags stable)
