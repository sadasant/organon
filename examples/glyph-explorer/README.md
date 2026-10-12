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

- The wall uses a **provisional, hand-composed SVG alphabet** for all 115 terms. Related concepts share visual motifs; the paths are not hashes or encodings of IDs. These are navigational marks, not canonical notation or a claim of semantic equivalence. The separate Unicode study remains unchanged; its trial candidates appear in Notes using bundled Noto Sans Symbols 2 and text-presentation selectors. SVG runes cannot turn into platform emoji.
- The nine existing algebra experiment cards render as candidate inference forms with shared variables and witness premises. They are not canonical equivalences. Remaining terms display explicitly labelled lexical signatures or foundational status; registry dependencies are never represented as sufficient conditions.
- Graph edges point from prerequisite to dependent, expressing `depends_on`, not causal contribution. Immediate prerequisites and immediate dependents are both included. Narrow screens arrange this graph vertically.
- Definitions unfold to their natural height without framed cells or reserved blank space. Full entries and notation qualifications remain available in compact disclosures. Term navigation opens only one definition and waits for fonts before aligning it below the fixed header; the app owns history scroll restoration.
- The star field uses a single Three.js point draw with a small shader, capped at 20 rendered frames per second and 1.5 device-pixel ratio. Reduced motion, hidden tabs and manual pause stop animation. If WebGL is unavailable, a static CSS star field remains. Graph nodes are SVG links, so navigation still works without WebGL.
- The byline links to Daniel's existing GitHub profile. Confirm the desired domain spelling and profile destination before publication.

## GitHub Pages preparation, not deployment

Vite builds entirely static output under `dist/`, with locally bundled fonts and relative asset paths. React Router uses `#/term/agency` routes: direct links, refresh, Back and Forward work on Pages without a catch-all server. View modes live in the same fragment URL. This works at either a repository subpath or a custom-domain root.

After visual approval, a separate Pages PR can add a workflow that builds this directory and uploads `dist/`. At that point, confirm the exact custom domain, configure it in GitHub Pages, add the required DNS record and enable HTTPS. **That is the point to set up the proposed `organon.satasant.ai` subdomain.** No workflow, CNAME or DNS record has been created by this preview.
