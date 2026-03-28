# Domain Pitfalls

**Domain:** Single-page app marketing site (free, local-first Android app on Google Play)
**Researched:** 2026-03-28
**Confidence:** MEDIUM — drawn from established landing page conversion patterns, Astro deployment knowledge, and app-store marketing best practices. External web research was unavailable; claims are grounded in well-established industry patterns.

---

## Critical Pitfalls

Mistakes that cause rewrites, tank conversions, or break deployment.

---

### Pitfall 1: Weak or Buried Hero CTA

**What goes wrong:** The "Get it on Google Play" button is not the dominant visual action in the hero section. Visitors land, scan, don't immediately see what to do, and leave within seconds.

**Why it happens:** Designers add too many elements (feature lists, screenshots, taglines) above the fold before establishing the primary action. The CTA gets styled the same weight as secondary copy.

**Consequences:** Bounce rates stay high even when traffic is strong. The app never gets installs from the page.

**Prevention:**
- The hero must contain exactly one primary CTA button: the Google Play badge or a styled "Download Free" button.
- Place it above the fold on all common viewport sizes (375px mobile, 768px tablet, 1280px desktop).
- Use the neon green brand color exclusively on the CTA — nowhere else above the fold — so it draws the eye.
- Audit with a 5-second test: cover the screen, uncover it, and ask "what is the one thing this page wants me to do?" If the answer isn't instant, the hierarchy is broken.

**Detection warning signs:**
- CTA button color is reused decoratively elsewhere on the same screen.
- The Play Store badge is used instead of a custom-styled button (badges are small and easily overlooked).
- There are more than two sentences of copy before the CTA appears.

**Phase to address:** Initial build — hero section implementation.

---

### Pitfall 2: Messaging Leads With Features, Not the User's Problem

**What goes wrong:** The headline says something like "Track your workouts with FiveX Strong" — which describes the app, not why someone needs it. Visitors don't connect emotionally and don't read further.

**Why it happens:** Founders know their product deeply and naturally describe what it does rather than the pain it solves.

**Consequences:** Low time-on-page, high bounce rate. The "free, no account, local-first" differentiators — which are genuinely compelling — never get seen.

**Prevention:**
- Lead the headline with the user's pain or goal: "Your workouts. Your phone. No account needed." or "Train without handing your data to anyone."
- The subheadline (1–2 sentences max) then bridges to the product.
- The "free, no account, local-first" value props must appear within the first scroll — not buried in a features section.
- Write the hero copy last, after all other sections are done, once the core positioning is locked.

**Detection warning signs:**
- Headline contains the app name in the first three words.
- The word "track" appears in the headline without mentioning privacy or cost.
- "Local-first" doesn't appear until below the fold.

**Phase to address:** Copy/content definition before any implementation begins.

---

### Pitfall 3: Dark Theme + Neon Green Fails Contrast Requirements

**What goes wrong:** Neon green (`#00ff88` or similar) on a dark background looks great visually but fails WCAG AA contrast for body text if used at small sizes. Accessibility failures alienate screen reader users and can affect SEO.

**Why it happens:** Designers choose accent colors for brand feel, not contrast ratios.

**Consequences:** Text becomes unreadable for visually impaired users. Google Lighthouse accessibility score tanks. Some users on low-brightness displays can't read the page.

**Prevention:**
- Reserve neon green exclusively for large display text, buttons, and icons — never for body copy.
- All body text must be near-white (`#e5e5e5` or `#f0f0f0`) on the dark background — not gray, which often fails AA.
- Run `npx @astrojs/check` and Lighthouse audit before considering the site done.
- Use the WebAIM Contrast Checker during design: body text needs 4.5:1 ratio, large text needs 3:1.
- In Tailwind/CSS, define a `--color-accent` token and enforce it only appears in the design system's non-body-text contexts.

**Detection warning signs:**
- Neon green is used for paragraph text or small labels.
- Lighthouse accessibility score below 90.
- Gray text (e.g., `text-gray-400`) on a dark background (`bg-gray-900`) — this frequently fails at the AA level.

**Phase to address:** Design system / CSS variables setup at project initialization.

---

### Pitfall 4: GitHub Pages Deployment Surprises Break the Site

**What goes wrong:** The Astro site works perfectly on `localhost` but breaks on GitHub Pages because:
- Base path is not configured (`/fivex-marketing-site/` prefix is missing from asset URLs).
- Client-side routing (if any) returns 404 on direct URL access because GitHub Pages has no server-side routing fallback.
- Custom domain isn't set up before sharing the link, so the ugly `username.github.io/repo` URL gets indexed.

**Why it happens:** Developers test locally, push, assume it works. Base URL configuration is easy to miss in Astro.

**Consequences:** Images don't load. Navigation breaks. The site is unusable for real users while looking fine in development.

**Prevention:**
- Set `base` in `astro.config.mjs` immediately if deploying to a project page (not a user/org page or custom domain): `base: '/fivex-marketing-site'`.
- Use Astro's built-in `<Image />` component and `import` for all local assets — they respect the base path automatically. Never hardcode `/images/...` paths.
- Since this is a single-page site with no routing, the 404 routing issue doesn't apply — but verify this assumption if any anchor-based scrolling or hash routing is added.
- Add `CNAME` file for custom domain from day one if one is planned, so the URL is stable before sharing.
- Add a GitHub Actions workflow that deploys on push to `main` and fails loudly if the build breaks.

**Detection warning signs:**
- Assets return 404 in deployed site but load locally.
- `<img src="/images/screenshot.png" />` hardcoded anywhere in templates.
- No `base` config set in `astro.config.mjs` and repo name is not the `username.github.io` repo.

**Phase to address:** Project scaffolding / first deployment — before any content goes in.

---

### Pitfall 5: Placeholder Screenshots Shipped to Production

**What goes wrong:** The site launches with "placeholder image slots" still showing — gray boxes, lorem ipsum alt text, or dev-only screenshots. Real users see an unfinished product and don't trust the app.

**Why it happens:** Screenshots are deferred ("we'll add real ones later") but "later" never comes before launch.

**Consequences:** The page looks unfinished. Users assume the app is also unfinished. Install rate suffers.

**Prevention:**
- Treat placeholder slots as blockers, not deferrals. Define what screenshots are needed as a launch requirement.
- If real screenshots genuinely aren't ready, use illustrated mockups or a device frame with a solid brand-color fill — anything that looks intentional rather than missing.
- Add Astro content collection or a simple config object for screenshot slots so swapping them in is a one-file change when ready.
- Never ship with `alt="placeholder"` or `alt="screenshot 1"` — these are dead giveaways.

**Detection warning signs:**
- `src/assets/` contains files named `placeholder.png`, `screenshot-temp.jpg`, or similar.
- Any `alt` attribute containing the word "placeholder."
- Gray `bg-gray-700` div used as an image stand-in in the committed codebase.

**Phase to address:** Content freeze / pre-launch checklist.

---

### Pitfall 6: No Social Proof Handled Poorly — Either Ignored or Faked

**What goes wrong:** Two failure modes exist:
1. The absence of social proof (reviews, ratings, user count) is treated as a problem to paper over with vague superlatives ("the best workout tracker").
2. The builder adds fake or inflated metrics ("Loved by thousands of athletes!") that erode trust when users check the Play Store and see a new app with zero reviews.

**Why it happens:** Social proof is a known conversion lever, so the instinct is to add something — anything — in its place.

**Consequences:** Superlatives sound like marketing copy, which users filter out. Inflated claims destroy credibility when cross-checked. Both outcomes reduce trust and installs.

**Prevention:**
- Embrace the new-app reality. Lean into the positioning: "Built for lifters who want zero accounts and zero cloud dependency. Download it and decide."
- Replace social proof sections with a strong "Why Free? Why No Account?" explainer — this is the genuine differentiator for privacy-conscious users.
- If the builder wants a trust signal, use the Google Play badge itself (official, recognized) rather than invented metrics.
- Reserve space for a testimonial/rating section but leave it empty or hidden until real reviews exist. Use a feature flag or conditional render in Astro.

**Detection warning signs:**
- Any copy claiming user counts, ratings, or "loved by X" without a verifiable source.
- A testimonial section with fabricated quotes.
- Star ratings displayed without linking to actual Play Store reviews.

**Phase to address:** Content definition — before writing any marketing copy.

---

### Pitfall 7: Mobile Experience Treated as an Afterthought

**What goes wrong:** The marketing site for a mobile app is designed desktop-first and broken on the devices where its core audience will most likely encounter it. Android users clicking a shared link will hit the page on mobile.

**Why it happens:** Developers work on desktop machines and check mobile last (or not at all before deployment).

**Consequences:** The CTA is tiny or off-screen on mobile. Screenshots overflow their containers. Text is unreadably small or requires horizontal scroll.

**Prevention:**
- Design mobile-first in all Tailwind/CSS work. Start with the 375px viewport and scale up.
- The Google Play CTA button must be tap-target compliant: minimum 48x48px touch area (44px by Apple HIG, 48dp by Google Material).
- Test on actual Android devices (or Chrome DevTools device emulation) at 360px, 390px, and 414px widths — these cover the majority of Android screen sizes.
- Use Astro's `<Image />` with `width` and `height` to prevent layout shift on image load.
- Screenshots must be constrained with `max-width` so they don't overflow on small screens.

**Detection warning signs:**
- Tailwind classes written as `flex-row` without a `flex-col` mobile equivalent first.
- CTA button with `px-4 py-2` only — likely under 44px height on mobile.
- No viewport meta tag (Astro includes this by default, but verify it's present).

**Phase to address:** Every implementation phase — enforce mobile-first from the first component.

---

## Moderate Pitfalls

---

### Pitfall 8: Astro Image Optimization Not Used — Slow LCP

**What goes wrong:** App screenshots are added as raw `<img>` tags pointing to large PNG files. The page loads slowly, especially on mobile connections. Google's Core Web Vitals (LCP) suffers, which can affect search ranking.

**Prevention:**
- Use Astro's built-in `<Image />` component for all screenshots. It generates WebP, applies lazy loading, and sets explicit dimensions to prevent CLS.
- Keep source screenshot files under 2MB. Astro will optimize them, but starting with compressed sources speeds build times.
- Set `loading="eager"` only on the hero image (above-the-fold screenshot) and `loading="lazy"` on all others.

**Phase to address:** Screenshot/media implementation phase.

---

### Pitfall 9: Anchor Link Scroll Behavior Broken or Janky

**What goes wrong:** A single-page site with section anchors (hero, features, download) uses default browser scroll behavior, which snaps instantly. Or worse, anchor links are used for navigation but the offset doesn't account for a sticky header, causing sections to appear cut off at the top.

**Prevention:**
- Add `scroll-behavior: smooth` via CSS or Tailwind's `scroll-smooth` class on `<html>`.
- If a sticky header is used, add a `scroll-margin-top` value to each anchored section matching the header height.
- Test anchor scroll on mobile — iOS Safari historically has quirks with `scroll-behavior: smooth`.

**Phase to address:** Navigation/layout implementation.

---

### Pitfall 10: Over-Engineering for a Static Marketing Page

**What goes wrong:** React islands, state management, client-side routing, and component libraries get added to a page that is fundamentally static HTML with a few scroll animations. Astro's architecture is fought rather than embraced.

**Why it happens:** Developers default to tools they know from SPA work.

**Consequences:** Unnecessary JavaScript, slower page loads, more complexity than the page warrants.

**Prevention:**
- Default to zero JavaScript. Every interactive element (scroll animations, mobile menu) should be a `<script>` island only if truly needed.
- Astro's partial hydration (`client:visible`) is the right model if any island is added — but question whether it's needed at all first.
- A marketing page this size should score 95+ on Lighthouse performance with zero JS frameworks.

**Phase to address:** Project scaffolding — establish "no JS by default" as an explicit constraint.

---

## Minor Pitfalls

---

### Pitfall 11: Google Play Badge Used Without Brand Guidelines Compliance

**What goes wrong:** A custom-styled or outdated version of the Google Play badge is used. Google's brand guidelines require specific badge assets and prohibit distortion, recoloring, or modification.

**Prevention:**
- Download the official badge from the [Google Play Badge Generator](https://play.google.com/intl/en_us/badges/).
- Do not recolor, stretch, or place the badge over a busy background without adequate clearspace.
- Use the localized badge (English "Get it on Google Play") for a primarily English-language site.

**Phase to address:** CTA implementation.

---

### Pitfall 12: Missing Open Graph / Social Meta Tags

**What goes wrong:** When a user shares the site link on Discord, Reddit, or WhatsApp, no preview image or description appears. The link looks like a dead URL.

**Prevention:**
- Add `<meta property="og:title">`, `<meta property="og:description">`, `<meta property="og:image">`, and `<meta name="twitter:card">` to the Astro layout's `<head>`.
- The OG image should be 1200x630px. Create a simple branded image (dark background, neon green app name, tagline) early in the project.
- Astro makes this straightforward via layout props — it's a 15-minute task if done during initial setup and a painful retrofit otherwise.

**Phase to address:** Project scaffolding / initial HTML layout.

---

### Pitfall 13: Deploy URL Changes After Launch Breaks Shared Links

**What goes wrong:** The site launches at `username.github.io/fivex-marketing-site`, gets shared, then the repo is renamed or a custom domain is added. All previously shared links 404.

**Prevention:**
- Decide on the final URL before any public sharing: either `username.github.io` (requires repo named exactly `username.github.io`) or a custom domain configured from day one.
- If using a custom domain, add the `CNAME` file to the repo root and configure the GitHub Pages setting in the first deployment.
- GitHub Pages does not automatically redirect from old URLs to new ones — there is no server-side redirect.

**Phase to address:** Deployment setup — first commit.

---

## Phase-Specific Warnings

| Phase Topic | Likely Pitfall | Mitigation |
|---|---|---|
| Project scaffolding / Astro setup | Missing `base` config for GitHub Pages project page deployment | Set `base` in `astro.config.mjs` on day one; verify with a test deploy immediately |
| Copy / messaging | Leading with features instead of user problem; fake social proof | Write hero headline last; ban superlatives without evidence; acknowledge new-app status honestly |
| Design system / CSS | Neon green fails WCAG contrast on body text | Use accent color only for large text and interactive elements; run Lighthouse accessibility before proceeding |
| Hero section implementation | Weak or buried CTA; CTA color diluted by decorative reuse | One primary CTA; neon green used nowhere else on the same viewport |
| Screenshot slots | Placeholder images shipped to production | Define screenshot requirements as a launch blocker; use intentional mockups if real screenshots aren't ready |
| Navigation / scroll | Janky anchor scroll; sticky header clips section tops | `scroll-smooth` on `<html>`; `scroll-margin-top` per anchored section |
| Media / images | Raw PNG screenshots causing slow LCP | Use Astro `<Image />` component for all screenshots; `loading="eager"` on hero image only |
| Pre-launch | Missing OG tags; unvalidated mobile experience | OG tags in initial layout; test on 360px, 390px, 414px viewports before shipping |

---

## Sources

**Confidence note:** External web research tools were unavailable during this session. The pitfalls documented here are drawn from:

- Well-established landing page conversion research (CXL, Nielsen Norman Group, Unbounce documented patterns — training data, MEDIUM confidence)
- Astro documentation patterns for GitHub Pages deployment (training data current to August 2025, MEDIUM confidence — verify `base` config behavior against current Astro docs before implementation)
- Google Play badge brand guidelines (stable, rarely changes — MEDIUM confidence)
- WCAG 2.1 AA contrast requirements (stable standard — HIGH confidence)
- Google Core Web Vitals LCP/CLS requirements (stable since 2021, HIGH confidence on mechanism, MEDIUM on current scoring thresholds)

**Recommend verifying:**
- Current Astro GitHub Pages deployment docs: https://docs.astro.build/en/guides/deploy/github/
- Current Google Play badge assets: https://play.google.com/intl/en_us/badges/
- WCAG contrast checker: https://webaim.org/resources/contrastchecker/
