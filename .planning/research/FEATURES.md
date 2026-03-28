# Feature Landscape

**Domain:** Single-page app marketing site — mobile fitness/workout tracker (Google Play, free, local-first)
**Project:** FiveX Strong
**Researched:** 2026-03-28
**Confidence note:** External search tools unavailable this session. Analysis based on training knowledge (established patterns through mid-2025) cross-referenced with project context. App marketing landing page conventions are stable and well-documented — HIGH confidence on structural patterns, MEDIUM on specific CRO details.

---

## Table Stakes

Features users expect. Missing any of these and visitors bounce or distrust the product.

| Feature | Why Expected | Complexity | Notes |
|---------|--------------|------------|-------|
| Hero section with headline + CTA | First 5 seconds decide bounce. Visitors need to know immediately what the app does and for whom. | Low | Headline must answer "what is this and why should I care?" CTA goes straight to Play Store. |
| Google Play download badge/button | Users arriving from search or shared links need a clear, recognized path to install. Unofficial-looking buttons erode trust. | Low | Use the official Google Play badge asset. Single CTA target — no distractions. |
| App screenshot(s) | Users want to see what they're getting before installing. Abstract claims without visuals fail to convert. | Low | 2–3 screens minimum. Show actual UI, not a fake polished mockup that doesn't match the real app. |
| Value proposition statement | One or two sentences that make the product's purpose and core benefit unmistakably clear. | Low | Must survive skimming. No jargon. |
| Feature highlights / benefits section | Visitors need to understand what the app does differently or well. Bullet list or icon grid is standard expectation. | Low | 3–6 highlights. Focus on benefits, not feature names. |
| Mobile-responsive layout | The majority of marketing site visitors arrive on mobile. A broken mobile layout instantly disqualifies the app. | Low | Must be usable at 360px+. |
| Fast page load | Users on mobile data will abandon slow pages. Google Play ranking factors also consider linked site quality. | Medium | Keep assets lean. No heavy JS frameworks unless justified. |
| Privacy/data section (brief) | Privacy-conscious users — especially those searching for "no account workout app" — will look for this. For a local-first app it's a selling point, not a legal afterthought. | Low | A short, plain-English statement. Does not need to be a full policy page inline — can link out. |
| Contact or support path | Visitors who have a question before installing need somewhere to go, or they abandon. | Low | Email address or link to GitHub issues is sufficient. No need for a contact form. |
| App name + branding consistency | The site must match what users will find in the Play Store. Mismatch in name, icon, or screenshots erodes trust. | Low | Use the exact app name, icon, and color scheme from the Play Store listing. |

---

## Differentiators

Features that go beyond expectations and actively convert skeptical visitors or reinforce the brand promise.

| Feature | Value Proposition | Complexity | Notes |
|---------|-------------------|------------|-------|
| "No account needed" callout (prominent) | This is a genuine differentiator in a market dominated by apps that require signup and harvest data. Surface it early — in the hero or immediately below it. | Low | Don't bury it in a features list. Make it a visual badge or callout, not just a list item. |
| "Free, forever" clarity | Many "free" apps hide paywalls. Explicitly stating no subscriptions, no premium tier, no hidden cost builds immediate trust with budget-conscious users. | Low | If there are ever in-app purchases, this needs to be accurate. Assuming truly free based on context. |
| Local-first / offline capability explanation | "Your data stays on your phone" resonates with privacy-aware users. It's also a practical benefit — works in the gym with no signal. | Low | Explain it in plain language. Avoid jargon like "local-first" without a plain-English translation. |
| Programme showcase (pre-defined + custom) | Shows the app has structure and depth without requiring a download to discover this. Pre-defined programmes reduce the "I don't know where to start" barrier for beginners. | Medium | Screenshots of programme selection UI + brief description of what pre-defined programmes exist. |
| History/progress tracking visual | Progress tracking is a core motivator. Showing what historical data looks like reassures users the app is capable and persistent. | Medium | A single screenshot of the history or progress view is enough — doesn't need explanation. |
| Dark theme + neon green brand expression | Visual identity that communicates the app's aesthetic before downloading. Users who prefer dark-mode apps self-select positively. | Low | The site should itself use the dark theme. Seeing the brand in action on the site = preview of the app experience. |
| Approachable, non-intimidating copy tone | Most fitness apps target elite athletes or project aggressive aspiration. Copy that says "this is for regular people building a habit" differentiates from Whoop, MyFitnessPal, etc. | Low | Specific: avoid words like "crush," "beast," "shred." Use words like "track," "build," "consistent." |
| Open source / GitHub link (if applicable) | Builds technical trust, especially with privacy-focused users. A visible repo signals transparency about what the app actually does with data. | Low | Only include if the repo is public. If not, omit entirely. |

---

## Anti-Features

Features to explicitly NOT build for this site. These are common traps that waste development time, add friction, or contradict the brand.

| Anti-Feature | Why Avoid | What to Do Instead |
|--------------|-----------|-------------------|
| Social proof with fake or missing stats | The app is new — no real download counts, no verified reviews. Fabricated numbers destroy trust when discovered. Placeholder stats look amateurish. | Omit social proof entirely until real numbers exist. Let the product speak through screenshots and honest copy. |
| Newsletter / email signup | Creates friction and implies ongoing commitment the user hasn't agreed to. Contradicts "no account needed" brand promise. | Single CTA: download the app. No detours. |
| Blog or content section | Adds maintenance burden with zero near-term conversion benefit. Users arriving on a marketing page want to install, not read articles. | Launch without content. Add only if SEO strategy demands it later. |
| Multiple competing CTAs | "Download" + "Learn more" + "Contact us" = decision paralysis. Every additional CTA reduces conversion on the primary one. | One primary CTA (Play Store download) everywhere. Secondary actions (support email) should be visually subordinate. |
| Video autoplay | Autoplaying video on mobile burns data, startles users, and delays page load. Especially bad for a privacy-focused brand. | Use static screenshots. An optional play-button video embed is acceptable if there's a compelling demo. |
| iOS App Store badge | The app is Google Play only. Showing an iOS badge that goes nowhere destroys trust. | Google Play badge only. If iOS ever launches, update then. |
| Pop-ups or exit-intent modals | Users on a single-page app marketing site have one job: evaluate and download. Interrupting that flow to capture email is counterproductive. | No modals. No overlays. |
| Cookie consent banners (if avoidable) | Adds visual clutter and implies data collection that contradicts local-first messaging. | Avoid analytics or third-party scripts that require consent. Use privacy-respecting analytics (Plausible, Fathom) or none at all. |
| Pricing page / comparison table | There's nothing to compare — the app is free. A pricing section makes users wonder if there's a catch. | State "free" once clearly and move on. |
| "Coming soon" iOS section | Speculative roadmap promises on a marketing site reduce credibility if timelines slip. | Don't promise what isn't shipped. Omit entirely. |

---

## Feature Dependencies

```
App screenshots → Hero section (screenshots needed before hero can be finalized)
App screenshots → Programme showcase (same asset source)
App screenshots → History/progress visual

"No account" callout → Privacy/data section (they reinforce each other; should be thematically consistent)
"Free, forever" clarity → Anti-pricing-page (explicitly not having a pricing section is the implementation of this claim)

Google Play badge → App store link (needs live Play Store URL before launch)

Dark theme site → Brand expression differentiator (the site must implement dark theme to demonstrate it)
Approachable copy → All text sections (tone must be consistent across hero, features, privacy, footer)
```

---

## MVP Recommendation

For a greenfield marketing site with the goal of driving Play Store downloads, the minimum viable page is lean and focused.

**Prioritize (in order of page scroll):**

1. Hero — app name, one-line value prop, Play Store CTA, 1–2 hero screenshots
2. "No account. No subscription. No data collection." — prominent callout block (this is the core differentiator)
3. Feature highlights — 4–6 icons/benefits: pre-defined programmes, custom programmes, history tracking, offline, free, dark theme
4. Screenshots section — 3–4 actual UI screenshots showing key flows
5. Privacy plain-language statement — 2–3 sentences, local-first explained
6. Footer — support contact, Play Store link, optional GitHub link

**Defer:**

- Programme deep-dive: Describe programmes in highlights for now; a detailed showcase adds complexity without blocking launch
- Open source section: Only relevant if repo is public; verify before including
- Any analytics: Decide on privacy-respecting tool after launch; don't let the decision block the site

---

## Confidence Assessment

| Area | Confidence | Basis |
|------|------------|-------|
| Table stakes (structural) | HIGH | App landing page structure is stable, well-studied, consistent across industry 2020-2025 |
| Differentiators for this product | HIGH | Derived directly from stated product facts (local-first, free, no account) + competitive landscape knowledge |
| Anti-features | HIGH | Well-documented conversion research; modal/multi-CTA harms are thoroughly established |
| CRO specifics (exact copy formulas, button colors) | MEDIUM | Training data, not verified against 2026 studies |
| Fitness-app-specific conversion patterns | MEDIUM | General app patterns applied; fitness-specific nuances not verified with current sources |

---

## Sources

- Training knowledge: App store optimization (ASO) and app marketing landing page conventions through mid-2025
- Project context provided: FiveX Strong product description, brand, target audience
- Note: External verification (Unbounce, AppsFlyer, Lapa Ninja, fitness app case studies) was unavailable this session due to tool restrictions. Findings should be validated against current landing page examples before roadmap is finalized. Recommended reference sites: lapa.ninja (landing page gallery), land-book.com, saaslandingpage.com (filter by "app").
