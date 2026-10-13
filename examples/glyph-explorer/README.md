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

`npm run dev` regenerates the data before starting Vite. Rerun it after editing ontology sources. `build-data.py` reuses the repository's primary-definition extractor, preserves every registry entry in registry order, and includes their full Markdown entries. Generated data, dependencies and build output are ignored.

## Content boundaries

- Prose links and glyph substitution match capitalized registered names. Lowercase metalanguage such as a mathematical "relation" or "set" stays literal. A current label outranks a retained identifier alias: Order resolves to mathematical Order, while Coordination Order retains the legacy ID and route.
- The wall uses **Organon Symbols**, our provisional symbol typeface. The [shared catalog](../../proposals/glyph-catalog.mjs) generates both the font and the study's SVG specimen. Registry order governs the wall and study; catalog order fixes append-only font slots, so inserting Identity after Presence does not reassign existing characters. Rebuild with `uv run scripts/build-glyph-font.py` from the repository root. The website build uses the checked-in WOFF2; it does not need font-building dependencies. Private-use slots are local to this font, not portable Unicode meanings. Organon IDs and accessible labels remain authoritative.
- The English/Glyphs toggle controls both prose and mathematics. Mathematics reuses that catalog and font for whole registered type names and unambiguous, explicitly catalogued Lean aliases. Variables, fields, operators and unmapped names remain unchanged; a glyph does not assert that a partial encoding equals the full prose definition. Screen readers receive the English MathML, and source disclosures always retain verbatim Lean.
- The [semantic review](../../proposals/glyph-atlas.md) records 50 revised and 68 other trials, including Identity, Set and mathematical Order. State now shares Configuration's connected dots with a detached index; the legacy Order slot retains its drawing under Coordination Order. Notes display the same per-term judgments; revised does not mean approved. The [geometric vocabulary](../../proposals/glyph-design-vocabulary.md) separates family cues from unsupported reuse. Historical Unicode alternatives remain in the study, not as a competing alphabet in the UI.
- The [geometric rules](../../proposals/glyph-geometry.json) enforce an integer grid, shared strokes and ink bounds in the font build. Golden-section guides are advisory. Neither geometric consistency nor distinct outlines certify semantic fidelity or small-size readability.
- The [Lean mapping catalog](lean-math.json) covers all 118 terms. Identity and Difference are equality and its negation on one supplied carrier; they do not individuate empirical things. State, Entity and Boundary expose structured Configuration projections; Model retains its fuller existing perspective construction with StructuredModel as qualified supporting evidence. It selects the current Attention, Care and Respect revision predicates rather than similarly named historical records. Each mathematical panel is extracted from the mapped Lean source at build time, retaining fields, conditions, binders, shared variables and application order. Supporting declarations and the exact source are available in disclosures. This is a conservative TeX transcription, not a Lean pretty-printer or a proof of equivalence to the prose. A supplied carrier or field excerpt is labelled as such; no definition is invented for missing encodings.
- Graph edges point from prerequisite to dependent, expressing `depends_on`, not causal contribution. Local view is an induced subgraph: the selected term, its immediate neighbours, and **every** source edge between them. Whole DAG shows every term within Presence. Both views use the same deterministic full-graph layout, with pan, zoom, keyboard controls and linked nodes. Positions and distances are layout choices, not ontological quantities. Absence is shown separately: A3's contrast belongs to the metalanguage, so its registry reference remains intact but is not rendered as an edge within Presence.
- Graph navigation uses a telescope-like camera: drag displacement is scaled to 5.5%, eases toward a bounded target, and stops after settling rather than flinging. Decorative node depths differ by only ±1%; edges follow the same projection. Zoom uses smaller, eased steps. Reduced-motion mode removes easing and differential panning, but keeps the slow navigation gain. Depth and apparent size encode no ontological rank.
- Definitions unfold to their natural height without framed cells or reserved blank space. Full entries and notation qualifications remain available in compact disclosures. Term navigation opens only one definition and waits for fonts before aligning it below the fixed header; the app owns history scroll restoration.
- Star density follows the selected term's position in the full canonical order, not search results or graph extent: round(2200 × zero-based position / last position). Absence has no sky, luminous node marker or pause control; Presence starts with 19 background points and the final term reaches 2200. The seeded positions stay fixed as more points appear. This is an editorial navigation cue, not a claim that later terms contain more Presence. The sky stays anchored rather than following the cursor, with gentle brightness cycles lasting approximately 9–20 seconds. It uses a single Three.js point draw, capped at 20 rendered frames per second and 1.5 device-pixel ratio. Reduced motion, hidden tabs and manual pause stop animation. Without WebGL, a static CSS field approximates the same density progression by increasing spacing for earlier terms. Graph nodes remain SVG links.
- The byline links to Daniel's existing GitHub profile; the repository link opens the canonical source.

## Checking the mathematics

`npm test` checks source extraction, renders every catalog expression and signature in both notations with KaTeX, and checks term links and graph structure. With the repository's Lean toolchain installed, run `python3 lean_math.py --check-lean` here to build the referenced modules and resolve every mapped symbol (100 distinct declarations). Pages builds do not install Lean; extraction fails on unsupported syntax instead of guessing. Changes to source declarations or the registry must be reviewed against the catalog, especially partial encodings. English notation keeps Lean names; glyph notation never merges distinct variable names. Long formulas scroll horizontally on narrow screens.

## GitHub Pages deployment

Vite builds entirely static output under `dist/`, with locally bundled fonts and relative asset paths. React Router uses `#/term/agency` routes: direct links, refresh, Back and Forward work on Pages without a catch-all server. View modes live in the same fragment URL. This works at either a repository subpath or a custom-domain root.

The [Glyph explorer workflow](../../.github/workflows/pages.yml) builds and tests pull requests without deploying them. Pushes to `main` build, test, upload only `dist/`, and deploy through the `github-pages` environment. Deployment permissions are confined to that job. A manual run on `main` can retry a deployment; runs on other branches cannot deploy. The separate [glyph-study workflow](../../.github/workflows/glyphs.yml) verifies source coverage and reproducible font assets.

Initial hosting setup requires repository administration and DNS access:

1. In this repository's **Settings → Pages**, select **GitHub Actions** as the source.
2. Set the custom domain to `organon.sadasant.ai` before pointing DNS at GitHub.
3. In the `sadasant.ai` DNS zone, add a DNS-only CNAME named `organon` pointing to `sadasant.github.io`. This does not change the personal Pages repository or the apex domain.
4. After GitHub provisions the certificate, enable **Enforce HTTPS**. Verify the root page, a direct fragment URL, refresh, Back/Forward, glyph loading and graph navigation over HTTPS.

The custom domain is repository Pages configuration, not a `CNAME` file: the Actions deployment uses that configuration. Check **Actions → Glyph explorer** for the deployed commit and environment URL. To roll back, revert the website change on `main`; the next successful workflow publishes that revision.
