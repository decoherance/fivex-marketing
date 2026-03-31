---
status: complete
phase: 02-page-sections
source: [02-01-SUMMARY.md, 02-02-SUMMARY.md, 02-03-SUMMARY.md]
started: 2026-03-31T16:10:00Z
updated: 2026-03-31T16:45:00Z
---

## Current Test

[testing complete]

## Tests

### 1. Hero Headline and Value Proposition
expected: "FiveX Strong" headline is visible at the top of the page in Space Grotesk font. Below it, a 1-2 sentence value proposition explains what the app does. Both are immediately visible without scrolling.
result: issue
reported: "at mobile size the image of the phone has resized to a square. It looks more like an apple watch than a phone"
severity: major

### 2. Hero Play Store Badge
expected: A Google Play badge is prominently visible in the hero section. Tapping/clicking it navigates to a Play Store URL (or placeholder). The badge is the dominant CTA above the fold.
result: issue
reported: "I would like the Play badge to be larger"
severity: cosmetic

### 3. Hero Phone Mockup and Gradient
expected: A branded phone mockup (CSS-rendered with "5X" branding in green) appears in the hero, alongside the headline. The background has a dark-to-green gradient. On desktop it's a two-column layout (text left, phone right); on mobile they stack.
result: issue
reported: "on mobile the text is left aligned and the phone is centre-aligned which makes it look untidy. I would like the text to be centre-aligned on mobile, the image of the phone to be slightly larger. I would also like the phone image to on top in mobile view so the CTA button is nearer to the users thumb"
severity: major

### 4. Above the Fold at 375px Mobile
expected: Using browser dev tools at 375px width, the headline, value proposition, phone mockup, and Play Store badge are all visible without scrolling.
result: issue
reported: "No, CTA is not visible. There is a lot of margin padding around the top of the page and text"
severity: major

### 5. Scroll Animations
expected: As you scroll down the page, each section (features, differentiators, screenshots, CTA) fades/slides into view when it enters the viewport. Hero and footer do NOT animate — they are immediately visible.
result: issue
reported: "in mobile there is a lot of empty space between sections"
severity: cosmetic

### 6. Features Section - Four Icon Cards
expected: Below the hero, a "Features" section shows four cards in a 2x2 grid (single column on mobile). Each card has a Lucide line icon, a title, and a short description. The four features are: pre-defined programmes, custom programmes, history tracking, and offline/no-internet.
result: pass

### 7. Differentiators Section - Three Callout Cards
expected: Below features, three distinct banner-style callout cards with green left-border accents (visually different from feature cards). They prominently state: "No account needed," "Free forever, no paywall," and "Data stays on your device."
result: pass

### 8. Screenshots Section - Branded Placeholders
expected: A screenshots section shows 2-4 phone-shaped placeholder slots with branded styling (dashed borders, "5X" branding, screen labels like "Home", "Workout", etc.). Not gray boxes — intentionally styled.
result: pass

### 9. CTA Section
expected: A closing CTA section with a bold headline (e.g., "Start training today"), supporting copy, and a Google Play badge (slightly larger than the hero badge). Clear final conversion push.
result: pass

### 10. Footer Links
expected: Footer shows the app name and copyright year. Three links are present: Google Play (opens store), Support email (opens mail client via mailto:), and Privacy Policy (opens a valid URL). All sourced from config.ts.
result: issue
reported: "privacy policy should be located at /fivex/privacy-policy. File should already exist here"
severity: major

## Summary

total: 10
passed: 4
issues: 6
pending: 0
skipped: 0

## Gaps

[none — all issues were fixed inline during UAT session]
