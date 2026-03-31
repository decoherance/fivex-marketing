# Phase 2: Page Sections - Context

**Gathered:** 2026-03-31
**Status:** Ready for planning

<domain>
## Phase Boundary

Build all six page sections (hero, features, differentiators, screenshots, CTA, footer) and assemble them into index.astro as the complete single-page scroll experience. Users scroll from hero to footer seeing the full marketing story. Content creation (copy, real screenshots) and quality validation are separate phases.

</domain>

<decisions>
## Implementation Decisions

### Hero layout & CTA
- Two-column layout on desktop: headline + subtext + Play Store badge on left, phone mockup on right
- On mobile (375px+): all three elements (headline, badge, phone mockup) should be visible above the fold — keep compact
- Phone mockup uses a branded placeholder frame (branded colors + app name inside) until real screenshots are available
- Video background with fallback to dark-to-brand gradient — video file will be provided later, build gradient first with a video slot ready
- Play Store badge is the dominant visual CTA above the fold

### Feature highlights
- 2x2 icon card grid on desktop, single column stack on mobile
- Each card: line icon (Lucide/Heroicons style) + title + 1-2 sentence description
- Four features: pre-defined programmes, custom programmes, history tracking, offline/no-internet
- Section has a heading + subtitle above the cards (e.g. "What you get")

### Differentiators presentation
- Banner-style callout cards in a row (3 cards), stacking vertically on mobile
- Each card: bold statement + one-liner supporting sentence (e.g. "No account needed" + "Open the app and start training")
- Brand accent treatment — green/teal accent borders or backgrounds, cohesive with page palette
- Section has its own heading above the cards (e.g. "Why FiveX Strong" or similar)
- Must be visually distinct from the features grid — these are trust/value signals, not feature descriptions

### Visual style & tone
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

</decisions>

<specifics>
## Specific Ideas

- Reference files provided as style guide (NOT to copy from):
  - `titan_kinetic_component_gallery_v3/` — component library showing surface layering, kinetic accent bars, glow shadows, Material Symbols
  - `titan_kinetic/DESIGN.md` — color tokens, typography, shape/spacing specs
  - `fivex_strong_mobile_site_v2/` — marketing page mockup showing hero treatment, feature cards with image headers, stats section, closing CTA
- Key visual patterns from references: layered dark surfaces, primary green (`#3fff8b`) glow accents, backdrop blur on nav, uppercase tracking-widest labels, gradient CTA buttons with shadow glow
- The references use Material Symbols Outlined — but the Astro project should use Lucide or similar (line icons, no external font dependency)
- Video background is a user priority — build the gradient fallback first, make the video slot a simple swap

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 02-page-sections*
*Context gathered: 2026-03-31*
