# Organon glyph explorer

A static reader for Organon's definitions, provisional glyphs, candidate algebra and local dependency graphs. It projects the repository's sources without changing the binding ontology. The release target is [organon.sadasant.ai](https://organon.sadasant.ai).

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
- The byline links to Daniel's existing GitHub profile; the repository link opens the canonical source.

## GitHub Pages deployment

Vite builds entirely static output under `dist/`, with locally bundled fonts and relative asset paths. React Router uses `#/term/agency` routes: direct links, refresh, Back and Forward work on Pages without a catch-all server. View modes live in the same fragment URL. This works at either a repository subpath or a custom-domain root.

The [Glyph explorer workflow](../../.github/workflows/pages.yml) builds and tests pull requests without deploying them. Pushes to `main` build, test, upload only `dist/`, and deploy through the `github-pages` environment. Deployment permissions are confined to that job. A manual run on `main` can retry a deployment; runs on other branches cannot deploy. The separate [glyph-study workflow](../../.github/workflows/glyphs.yml) verifies source coverage and reproducible font assets.

Initial hosting setup requires repository administration and DNS access:

1. In this repository's **Settings → Pages**, select **GitHub Actions** as the source.
2. Set the custom domain to `organon.sadasant.ai` before pointing DNS at GitHub.
3. In the `sadasant.ai` DNS zone, add a DNS-only CNAME named `organon` pointing to `sadasant.github.io`. This does not change the personal Pages repository or the apex domain.
4. After GitHub provisions the certificate, enable **Enforce HTTPS**. Verify the root page, a direct fragment URL, refresh, Back/Forward, glyph loading and graph navigation over HTTPS.

The custom domain is repository Pages configuration, not a `CNAME` file: the Actions deployment uses that configuration. Check **Actions → Glyph explorer** for the deployed commit and environment URL. To roll back, revert the website change on `main`; the next successful workflow publishes that revision.
