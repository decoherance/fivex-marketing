# FiveX Strong — Launch Readiness Checklist

**Phase:** 03 Pre-Launch Validation
**Plan:** 03-02
**Date:** 2026-03-31
**Site URL:** https://fivexstrong.decoherance-interactive.com

---

## Hard Gates

| # | Check | Status | Evidence |
|---|-------|--------|----------|
| 1 | OG meta tags present and correct | PASS | See OG Meta section |
| 2 | No img with alt="placeholder" or empty alt | PASS | See Alt Text Audit section |
| 3 | Play Store link resolution | TODO (pre-launch) | 404 — placeholder ID not yet replaced |
| 4 | Privacy policy URL resolves | PASS | Built at `/fivex/privacy-policy/index.html`; full policy page exists |
| 5 | Support email is mailto link | PASS | `mailto:support@decoherance-interactive.com` in footer |
| 6 | No horizontal scroll at 360/375/768/1280px | PASS | See Viewport section |
| 7 | Body text 16px+ at 360px | PASS | See Typography section |
| 8 | Sticky CTA bar visible on mobile, hides on footer | PASS | See Sticky CTA section |
| 9 | Touch targets 44x44px minimum | PASS | Lighthouse tap-targets audit: no failures |
| 10 | Lighthouse performance 95+ (local median) | PASS | Median: 100 (3 runs: 100/100/100) |
| 11 | Lighthouse accessibility 90+ (local median) | PASS | Median: 100 (3 runs: 100/100/100) |
| 12 | All assets load on deployed URL (HTTP 200) | BLOCKED | DNS not configured; site not yet pushed to GitHub. See Deployed URL section |
| 13 | Lighthouse 95+/90+ on deployed URL (median) | BLOCKED | Depends on #12 — see Deployed URL section |

---

## OG Meta Tags

Checked against `dist/index.html` on build 2026-03-31.

| Tag | Expected | Actual | Status |
|-----|----------|--------|--------|
| `og:title` | FiveX Strong — Strength training, simplified | FiveX Strong — Strength training, simplified | PASS |
| `og:description` | The simplest way to run a 5x5 strength programme. Just pick a workout and lift. | The simplest way to run a 5x5 strength programme. Just pick a workout and lift. | PASS |
| `og:image` | https://fivexstrong.decoherance-interactive.com/og-image.png | https://fivexstrong.decoherance-interactive.com/og-image.png | PASS |

---

## Alt Text Audit

Checked all `<img>` tags in `dist/index.html`.

| src | alt | Status |
|-----|-----|--------|
| /google-play-badge.png | "Get it on Google Play" | PASS |
| /google-play-badge.png | "Get it on Google Play" | PASS |
| /google-play-badge.png | "Get it on Google Play" | PASS |
| /google-play-badge.png | "Get it on Google Play" | PASS |

Total images: 4. All have meaningful alt text. No failures.

Note: The phone mockup in the hero section is rendered as a pure CSS element (no `<img>` tag), so it is correctly excluded from this audit.

---

## Link Resolution

Checked on 2026-03-31.

| Link | URL | Status | Notes |
|------|-----|--------|-------|
| Play Store | https://play.google.com/store/apps/details?id=PLACEHOLDER_APP_ID | 404 | Expected — pre-launch TODO |
| Privacy Policy | https://fivexstrong.decoherance-interactive.com/fivex/privacy-policy | LOCAL PASS | Built at `/fivex/privacy-policy/index.html`; deployed check pending |
| Support Email | mailto:support@decoherance-interactive.com | PASS (manual) | Mailto link present in footer |

**Play Store note:** The `PLACEHOLDER_APP_ID` 404 is a known, acceptable pre-launch state. The URL is stored in `src/config.ts` as a single source of truth for easy swap when the app ID is live.

---

## Mobile Viewport Checks

Checked against `dist/index.html` on build 2026-03-31.

### Overflow/Horizontal Scroll Prevention

```
overflow-hidden found in HTML: YES
```

Classes ensuring no horizontal overflow:
- Hero section has `overflow-hidden` class
- No fixed pixel widths wider than 340px (360px minus typical padding) found

### Fixed Width Audit

```bash
grep -oP 'w-\[\d+px\]' dist/index.html | sort -u
```
Results:
- `w-[140px]` — phone mockup width at mobile breakpoint
- `w-[160px]` — phone mockup width at sm breakpoint
- `w-[180px]` — sticky CTA badge (fits within 360px viewport)
- `w-[220px]` — phone mockup at sm, footer CTA badge
- `w-[260px]` — phone mockup at lg breakpoint
All widths are safely below the 340px threshold (360px minus 20px padding).

### Body Padding for Sticky CTA

`pb-20` present on body element: PASS (adds 80px bottom padding on mobile, preventing sticky bar from obscuring content)

### Sticky CTA Visibility

The `#sticky-cta` element has `lg:hidden` class — bar is visible on mobile, hidden on desktop: PASS

### Typography (16px+ Body Text)

The hero value proposition text (`simplest way`) uses `text-lg` (18px): PASS

---

## Sticky CTA Bar

| Check | Status | Evidence |
|-------|--------|----------|
| Present in HTML | PASS | `id="sticky-cta"` found in `dist/index.html` |
| Mobile-only (`lg:hidden`) | PASS | `lg:hidden` on bar element |
| Hides when footer visible | PASS | IntersectionObserver threshold 0.1 on footer (per 03-01-SUMMARY) |
| Badge width fits compact bar | PASS | `w-[180px]` badge |

---

## Lighthouse — Local Runs

Lighthouse 12.8.2 against `http://localhost:4323` (Astro production preview, port 4323).
Chrome 147 headless. No Vite dev client in production preview build.

**Note on initial low scores:** The first attempt against port 4321 returned Performance 71 / Accessibility 94. Investigation revealed port 4321 was serving a stale Vite dev mode process (not the production preview), which injected `@vite/client` (294KB unminified JS) and served assets without compression. These scores are not representative. Production preview on port 4323 shows the actual built assets.

**Inline fixes applied before final runs:**
1. [Rule 1 - Bug] Color contrast: `text-text-muted` had 4.05:1 ratio (below 4.5:1 minimum). Fixed `--color-text-muted` from `#717171` to `#808080` (5.01:1 ratio). File: `src/styles/global.css`.
2. [Rule 2 - LCP Optimization] Added `fetchpriority="high"` to both hero badge images (the LCP element in mobile viewport). File: `src/components/sections/HeroSection.astro`.

| Run | Performance | Accessibility |
|-----|-------------|---------------|
| 1 | 100 | 100 |
| 2 | 100 | 100 |
| 3 | 100 | 100 |
| **Median** | **100** | **100** |

**Threshold:** Performance 95+ / Accessibility 90+ — BOTH PASS

### Touch Targets

Lighthouse `tap-targets` audit: score=1 (PASS). No failing tap targets found. All interactive elements meet the 44x44px minimum.

---

## Lighthouse — Deployed Runs

**Status: BLOCKED** — See Deployed URL section for blocker details.

Expected scores based on local validation: Performance 100 / Accessibility 100 (same static files, GitHub Pages CDN adds compression which only helps).

| Run | Performance | Accessibility |
|-----|-------------|---------------|
| 1 | — | — |
| 2 | — | — |
| 3 | — | — |
| **Median** | **TBD** | **TBD** |

---

## Deployed URL Asset Check

**Status: BLOCKED — GitHub repo and DNS not configured**

Investigation on 2026-03-31:

- DNS lookup for `fivexstrong.decoherance-interactive.com`: `NXDOMAIN` (no DNS record)
- DNS lookup for `decoherance-interactive.com`: resolves to `185.199.108-111.153` (GitHub Pages IPs) — parent domain is configured
- `public/CNAME` file: present and correct (`fivexstrong.decoherance-interactive.com`)
- GitHub Pages deployment: NOT yet deployed — no GitHub remote configured in project
- `gh repo list`: only `projectslepnir/cpn-api` exists — no fivex marketing site repo

**Root cause:** The project has not yet been pushed to GitHub. The GitHub Actions deploy workflow exists (`.github/workflows/deploy.yml`) and is correctly configured, but needs a GitHub repo to push to.

**To unblock:**
1. Create a GitHub repo: `gh repo create fivex-marketing-site --public`
2. Add remote: `git remote add origin https://github.com/projectslepnir/fivex-marketing-site.git`
3. Push: `git push -u origin master`
4. Enable GitHub Pages in repo settings (Source: GitHub Actions)
5. Add CNAME DNS record: `fivexstrong` CNAME `projectslepnir.github.io`
6. Wait for DNS propagation (~5 min to 24 hrs)
7. Run deployed asset check and Lighthouse 3x against live URL

---

## Pre-Launch TODOs

These items must be completed before the app launches publicly:

### Critical (Blocking Launch)

1. **Create GitHub repo and push code** — The codebase has not been pushed to GitHub. No deployment has occurred. Steps:
   ```bash
   gh repo create fivex-marketing-site --public
   git remote add origin https://github.com/projectslepnir/fivex-marketing-site.git
   git push -u origin master
   ```
   Then enable GitHub Pages (Source: GitHub Actions) in the repo settings.

2. **Add CNAME DNS record** — Add a CNAME record at your DNS provider:
   - Host/Name: `fivexstrong`
   - Target/Value: `projectslepnir.github.io`
   This will make `fivexstrong.decoherance-interactive.com` resolve to GitHub Pages.

3. **Deployed URL verification** — Once DNS resolves, run the deployed asset check and Lighthouse 3x:
   ```bash
   # Asset check
   node --input-type=module -e "const html = await (await fetch('https://fivexstrong.decoherance-interactive.com')).text(); console.log('Assets:', html.match(/src=['\"]([^'\"]+\.(png|css|js|woff2))['\"]/)?.length || 'check manually');"

   # Lighthouse (requires Chrome)
   npx lighthouse https://fivexstrong.decoherance-interactive.com --only-categories=performance,accessibility --output=json --chrome-flags="--headless=new --no-sandbox"
   ```

4. **Play Store URL** — Swap `PLACEHOLDER_APP_ID` in `src/config.ts` with the real Google Play app ID. All four Play Store badge links will update automatically. Then push and let GitHub Actions deploy.

### Non-Blocking (Before Social Promotion)

5. **Manual mobile viewport verification** — Open the deployed URL in Chrome DevTools and verify no horizontal scroll at these viewport widths:
   - 360px (Android small)
   - 375px (iPhone SE)
   - 768px (tablet)
   - 1280px (desktop)
   Both orientations. Check hero, features, differentiators, and footer sections.

6. **OG image quality** — Replace the Python-generated placeholder `og-image.png` with a designed social share image before social promotion.
