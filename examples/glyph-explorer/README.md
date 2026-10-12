# Organon glyph explorer — local preview

A nonbinding website prototype on `preview/glyph-observatory`, branched from the Unicode study. No ontology changes, official glyph assignments, GitHub Pages deployment, or domain changes are made here.

## Run

From this directory, with Node 22+ and Python 3.10+:

```sh
npm ci
npm run build
npm test
npm run preview
```

`npm run dev` regenerates the data before starting Vite. Rerun it after editing ontology sources. `build-data.py` reuses the repository's primary-definition extractor, preserves all 115 entries in registry order, and includes their full Markdown entries. Generated data, dependencies and build output are ignored.

## Content boundaries

- The wall uses **Organon Symbols**, our provisional symbol typeface for all 115 terms. The [shared catalog](../../proposals/glyph-catalog.mjs) generates both the font and the study's SVG specimen. Rebuild them with `uv run scripts/build-glyph-font.py` from the repository root. The website build uses the checked-in WOFF2; it does not need font-building dependencies. Private-use slots are local to this font, not portable Unicode meanings. Organon IDs and accessible labels remain authoritative.
- The [semantic review](../../proposals/glyph-atlas.md) records 49 revised and 66 retained trials. The revisions cover the original 43 flagged marks and six related family members. Notes display the same per-term judgments; revised does not mean approved. Historical Unicode alternatives remain in the study, not as a competing alphabet in the UI.
- The [geometric rules](../../proposals/glyph-geometry.json) enforce an integer grid, shared strokes and ink bounds in the font build. Golden-section guides are advisory. Neither geometric consistency nor distinct outlines certify semantic fidelity or small-size readability.
- The nine existing algebra experiment cards render as candidate inference forms with shared variables and witness premises. They are not canonical equivalences. Remaining terms display explicitly labelled lexical signatures or foundational status; registry dependencies are never represented as sufficient conditions.
- Graph edges point from prerequisite to dependent, expressing `depends_on`, not causal contribution. Immediate prerequisites and immediate dependents are both included. Narrow screens arrange this graph vertically.
- Definitions unfold to their natural height without framed cells or reserved blank space. Full entries and notation qualifications remain available in compact disclosures. Term navigation opens only one definition and waits for fonts before aligning it below the fixed header; the app owns history scroll restoration.
- The star field uses a single Three.js point draw with a small shader, capped at 20 rendered frames per second and 1.5 device-pixel ratio. Reduced motion, hidden tabs and manual pause stop animation. If WebGL is unavailable, a static CSS star field remains. Graph nodes are SVG links, so navigation still works without WebGL.
- The byline links to Daniel's existing GitHub profile. The confirmed intended site address is `organon.sadasant.ai`; confirm the byline destination before publication.

## GitHub Pages preparation, not deployment

Vite builds entirely static output under `dist/`, with locally bundled fonts and relative asset paths. React Router uses `#/term/agency` routes: direct links, refresh, Back and Forward work on Pages without a catch-all server. View modes live in the same fragment URL. This works at either a repository subpath or a custom-domain root.

After semantic review and merge approval, a separate Pages PR can add a workflow that builds this directory and uploads `dist/`. At that point, configure `organon.sadasant.ai` in GitHub Pages, add its DNS CNAME pointing to `sadasant.github.io`, and enable HTTPS. **That is the point to set up the confirmed subdomain.** No workflow, CNAME or DNS record has been created by this preview.
