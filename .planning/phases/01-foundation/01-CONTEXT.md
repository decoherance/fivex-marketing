# Phase 1: Foundation - Context

**Gathered:** 2026-03-28
**Status:** Ready for planning

<domain>
## Phase Boundary

A deployable Astro project is live on GitHub Pages with the brand design system in place and zero-content placeholder confirming the pipeline works. Includes branded placeholder page, design tokens, CI/CD, and OG meta tags.

</domain>

<decisions>
## Implementation Decisions

### Placeholder page
- Branded landing page, not a minimal test page — should look intentional if discovered early
- Includes app name "FiveX Strong", tagline "Strength training, simplified", and brand colors
- Google Play badge present and links to placeholder URL (swap to real URL later)
- Tagline "Strength training, simplified" is the real value proposition — use in hero and elsewhere in Phase 2

### Design tokens — color
- Dark theme site: deep black backgrounds (#0a0a0a), not light marketing style
- Green (#00E676) is the primary CTA/action color
- Teal (#00BFA5) for secondary accents
- Purple (#D1C4E9) for subtle highlights
- Derive surface/card colors, text colors, and borders from the dark theme base

### Design tokens — typography
- Bold and punchy heading style — large sizes, heavy weights (fitness/gym energy)
- Space Grotesk for headings, Inter for body (already decided in PROJECT.md)
- Type scale should make a statement, not be understated

### Hosting & URL
- Custom subdomain: fivexstrong.decoherance-interactive.com
- Base path is `/` (root) — subdomain means no path prefix needed
- CNAME record pointing to GitHub Pages
- CNAME file in repo for GitHub Pages custom domain support

### OG / meta content
- OG title: "FiveX Strong — Strength training, simplified"
- OG description: benefit-focused, e.g., "The simplest way to run a 5x5 strength programme. Just pick a workout and lift."
- OG image: placeholder branded graphic for now (app icon to be swapped in later)
- Claude to draft the final OG description copy during implementation

### Claude's Discretion
- Loading skeleton design
- Exact spacing and component sizing
- Placeholder OG image design (branded, swap later)
- Error state handling
- Typography scale exact values
- Surface/border color derivation from dark theme

</decisions>

<specifics>
## Specific Ideas

- Dark theme should feel like Linear or Vercel — premium, high contrast on deep black
- Placeholder page should be a real branded landing, not a "coming soon" afterthought
- Play Store badge should be functional from day one (even with placeholder URL)
- Tagline "Strength training, simplified" confirmed as the app's value proposition

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 01-foundation*
*Context gathered: 2026-03-28*
