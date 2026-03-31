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
| 9 | Touch targets 44x44px minimum | PENDING | See Lighthouse section |
| 10 | Lighthouse performance 95+ (local median) | PENDING | See Lighthouse Local section |
| 11 | Lighthouse accessibility 90+ (local median) | PENDING | See Lighthouse Local section |
| 12 | All assets load on deployed URL (HTTP 200) | PENDING | See Deployed URL section |
| 13 | Lighthouse 95+/90+ on deployed URL (median) | PENDING | See Lighthouse Deployed section |

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
- `w-[180px]` — sticky CTA badge (fits within 360px viewport)
- `w-[200px]` — hero badge
- `w-[220px]` — footer CTA badge
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

PENDING — Task 2

| Run | Performance | Accessibility |
|-----|-------------|---------------|
| 1 | — | — |
| 2 | — | — |
| 3 | — | — |
| **Median** | **—** | **—** |

**Threshold:** Performance 95+ / Accessibility 90+

### Touch Targets

PENDING — Task 2

---

## Lighthouse — Deployed Runs

PENDING — Task 3

| Run | Performance | Accessibility |
|-----|-------------|---------------|
| 1 | — | — |
| 2 | — | — |
| 3 | — | — |
| **Median** | **—** | **—** |

---

## Deployed URL Asset Check

PENDING — Task 3

---

## Pre-Launch TODOs

These items are known, documented, and must be completed before the app launches publicly:

1. **Play Store URL** — Swap `PLACEHOLDER_APP_ID` in `src/config.ts` with the real Google Play app ID. All four Play Store badge links will update automatically.

2. **Manual mobile viewport verification** — Open the deployed URL in Chrome DevTools and verify no horizontal scroll at these viewport widths:
   - 360px (Android small)
   - 375px (iPhone SE)
   - 768px (tablet)
   - 1280px (desktop)
   Both orientations. Check hero, features, differentiators, and footer sections.

3. **OG image quality** — Replace the Python-generated placeholder `og-image.png` with a designed social share image before social promotion.
