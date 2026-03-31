# Phase 3: Pre-Launch Validation - Context

**Gathered:** 2026-03-31
**Status:** Ready for planning

<domain>
## Phase Boundary

Validate the completed marketing site against all quality gates before going public. Run Lighthouse, mobile responsiveness, accessibility, link verification, and OG meta checks. Fix any issues found inline. No new features — only validation and fixes to meet success criteria.

</domain>

<decisions>
## Implementation Decisions

### Failure handling
- Report-only approach: generate a report of all failures, then fix issues inline within this phase
- All five success criteria are hard gates — every one must pass before the site is launch-ready
- Small fixes (alt text, meta tags, minor CSS) are done within this phase, not sent back to Phase 2
- Produce a markdown checklist document with each criterion, status, and evidence

### Mobile testing scope
- Test four viewport widths: 360px, 375px, 768px, 1280px
- Test both portrait and landscape orientations on mobile viewports
- Full mobile UX validation: no horizontal scroll, no clipped content, touch targets min 44x44px, body text min 16px
- Verify sticky Play Store CTA remains visible while scrolling on all tested viewports

### Link & asset verification
- Play Store placeholder URL is acceptable for now — flag as pre-launch TODO that must be swapped before going public
- Privacy policy page exists externally — verify the link resolves to the existing URL
- OG preview validated by checking meta tags in HTML (og:title, og:description, og:image) — no external preview service needed
- Verify all images/assets load correctly on the deployed GitHub Pages URL (not just local build)

### Lighthouse thresholds
- Performance 95+ and accessibility 90+ only (no thresholds for Best Practices or SEO)
- Run Lighthouse locally first (npm run preview) for fast feedback, then confirm on deployed URL
- No visual trade-offs to hit performance targets — if 95 isn't reachable, report why rather than degrading design
- Run Lighthouse 3 times per target, take median score to account for variance

### Claude's Discretion
- Lighthouse CLI vs programmatic API choice
- Order of validation checks
- Checklist document format and level of detail
- How to structure fix commits (batched vs per-issue)

</decisions>

<specifics>
## Specific Ideas

- Checklist document should serve as a "launch readiness" artifact the user can reference
- Sticky CTA verification is important — this was a specific user request from Phase 2 feedback
- Play Store URL swap is a known product dependency — validation should clearly flag this as the remaining pre-launch blocker

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 03-pre-launch-validation*
*Context gathered: 2026-03-31*
