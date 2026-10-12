#!/usr/bin/env python3
# /// script
# requires-python = ">=3.11"
# dependencies = ["fonttools[woff]==4.60.1", "shapely==2.1.2"]
# ///
"""Build the nonbinding Organon symbol font and Markdown study from one catalog.

Run with: uv run scripts/build-glyph-font.py
No font tools are needed to build the website from the checked-in font.
"""

import argparse
import hashlib
import html
import json
from pathlib import Path
import re
import subprocess
import tempfile

from fontTools.fontBuilder import FontBuilder
from fontTools.pens.basePen import BasePen
from fontTools.pens.ttGlyphPen import TTGlyphPen
from fontTools.svgLib.path import parse_path
from shapely.geometry import LineString
from shapely.geometry.polygon import orient
from shapely.ops import unary_union

ROOT = Path(__file__).resolve().parents[1]
GEOMETRY = json.loads((ROOT / "proposals/glyph-geometry.json").read_text())
SCALE = GEOMETRY["units_per_em"] / GEOMETRY["canvas"]


class StrokePen(BasePen):
    """Flatten the small curved strokes before expanding to filled outlines.

    64 samples per Bezier segment keeps the approximation below a display pixel
    at all of the website's glyph sizes. Fonts contain outlines, not SVG strokes.
    """

    def __init__(self):
        super().__init__(None)
        self.lines = []

    def _moveTo(self, point):
        self.points = [point]

    def _lineTo(self, point):
        self.points.append(point)

    def _curveToOne(self, a, b, c):
        start = self.points[-1]
        for i in range(1, 65):
            t = i / 64
            self.points.append(tuple(
                (1-t)**3 * start[j] + 3*(1-t)**2*t*a[j]
                + 3*(1-t)*t*t*b[j] + t**3*c[j] for j in (0, 1)
            ))

    def _qCurveToOne(self, a, b):
        start = self.points[-1]
        for i in range(1, 65):
            t = i / 64
            self.points.append(tuple(
                (1-t)**2*start[j] + 2*(1-t)*t*a[j] + t*t*b[j]
                for j in (0, 1)
            ))

    def _closePath(self):
        self.points.append(self.points[0])
        self._endPath()

    def _endPath(self):
        if len(self.points) > 1:
            self.lines.append(LineString(self.points))


def outline(path):
    numbers = re.findall(r"[-+]?(?:\d*\.\d+|\d+)(?:[eE][-+]?\d+)?", path)
    assert all(float(n) % GEOMETRY["coordinate_grid"] == 0 for n in numbers), "Off-grid glyph coordinate"
    stroke = StrokePen()
    parse_path(path, stroke)
    shape = unary_union([
        line.buffer(GEOMETRY["stroke_width"] / 2, cap_style=GEOMETRY["linecap"],
                    join_style="mitre", mitre_limit=GEOMETRY["miter_limit"])
        for line in stroke.lines
    ])
    assert GEOMETRY["linejoin"] == "miter", "Font and specimen must share join style"
    low, high = GEOMETRY["ink_inset"], GEOMETRY["canvas"] - GEOMETRY["ink_inset"]
    assert not shape.is_empty and all(low <= b <= high for b in shape.bounds), f"Ink outside geometric envelope: {shape.bounds}"
    pen = TTGlyphPen(None)
    polygons = [shape] if shape.geom_type == "Polygon" else shape.geoms
    for polygon in polygons:
        # Flipping SVG's downward Y makes CCW exterior rings clockwise in TTF.
        polygon = orient(polygon, sign=1)
        for ring in [polygon.exterior, *polygon.interiors]:
            points = [(round(x*SCALE), round((GEOMETRY["canvas"]-y)*SCALE)) for x, y in ring.coords[:-1]]
            pen.moveTo(points[0])
            for point in points[1:]:
                pen.lineTo(point)
            pen.closePath()
    return pen.glyph()


def build(output_root):
    catalog = json.loads(subprocess.check_output([
        "node", "--input-type=module", "-e",
        "import {glyphs} from './proposals/glyph-catalog.mjs'; "
        "process.stdout.write(JSON.stringify(glyphs))",
    ], cwd=ROOT))
    registry = json.loads((ROOT / "ontology/terms.yaml").read_text())
    reviews = json.loads((ROOT / "proposals/glyph-semantic-review.json").read_text())
    terms = registry["terms"]
    assert [g["id"] for g in catalog] == [t["id"] for t in terms]
    assert [g["term"] for g in catalog] == [r["term"] for r in reviews["entries"]]
    assert len({g["path"] for g in catalog}) == len(catalog)
    assert len({g["codepoint"] for g in catalog}) == len(catalog)
    assert all(0xE000 <= g["codepoint"] <= 0xF8FF for g in catalog)
    for source, expected in reviews["source"]["sha256"].items():
        # The original SVG module is preserved by the review's historical commit.
        if source.startswith("ontology/") or source in {"proposals/glyph-catalog.mjs", "proposals/glyph-geometry.json"}:
            assert hashlib.sha256((ROOT / source).read_bytes()).hexdigest() == expected

    out = output_root / "proposals/glyph-assets"
    out.mkdir(parents=True, exist_ok=True)
    em = GEOMETRY["units_per_em"]
    font = FontBuilder(em, isTTF=True)
    names = [g["term"] for g in catalog]
    font.setupGlyphOrder([".notdef", "space", *names])
    font.setupCharacterMap({32: "space", **{g["codepoint"]: g["term"] for g in catalog}})
    font.setupGlyf({
        ".notdef": outline("M5 5H27V27H5Z M5 5 27 27 M27 5 5 27"),
        "space": TTGlyphPen(None).glyph(),
        **{g["term"]: outline(g["path"]) for g in catalog},
    })
    assert len({font.font["glyf"][name].compile(font.font["glyf"]) for name in names}) == len(names), "Duplicate font outlines"
    font.setupHorizontalMetrics({name: (em, 0) for name in font.font.getGlyphOrder()})
    # Match outline left sidebearings to avoid renderer-dependent shifts.
    for name in names + [".notdef"]:
        font.font["hmtx"].metrics[name] = (em, font.font["glyf"][name].xMin)
    font.setupHorizontalHeader(ascent=em, descent=0)
    font.setupNameTable({
        "familyName": "Organon Symbols",
        "styleName": "Regular",
        "uniqueFontIdentifier": "OrganonSymbols-0.2",
        "fullName": "Organon Symbols Regular",
        "psName": "OrganonSymbols-Regular",
        "version": "Version 0.2",
        "description": "Nonbinding experimental symbols. Use with the Organon catalog and labels.",
    })
    font.setupOS2(sTypoAscender=em, sTypoDescender=0, sTypoLineGap=0,
                  usWinAscent=em, usWinDescent=0)
    font.setupPost()
    # Fixed timestamps make repeated builds byte reproducible.
    font.font["head"].created = font.font["head"].modified = 3864153600
    font.font.recalcTimestamp = False
    font.save(out / "OrganonSymbols.ttf")
    font.font.flavor = "woff2"
    font.save(out / "OrganonSymbols.woff2")

    # GitHub Markdown cannot load custom webfonts. Render the same source paths
    # as a labelled SVG specimen instead of silently falling back to Unicode.
    sheet = ['<svg xmlns="http://www.w3.org/2000/svg" width="1200" height="1680" viewBox="0 0 1200 1680">',
             '<rect width="1200" height="1680" fill="#080808"/>']
    for i, (glyph, term) in enumerate(zip(catalog, terms)):
        x, y = 75 + (i % 8)*150, 42 + (i // 8)*110
        sheet.append(f'<g transform="translate({x-20},{y}) scale(1.25)"><path d="{glyph["path"]}" fill="none" stroke="#e8e7e3" stroke-width="{GEOMETRY["stroke_width"]}" stroke-linecap="{GEOMETRY["linecap"]}" stroke-linejoin="{GEOMETRY["linejoin"]}" stroke-miterlimit="{GEOMETRY["miter_limit"]}"/></g>')
        # Stable IDs make very long labels unambiguous in the accompanying table.
        label = term.get("label", glyph["term"])
        words, lines = label.split(), [""]
        for word in words:
            if len(lines[-1]) + len(word) > 23:
                lines.append("")
            lines[-1] += (" " if lines[-1] else "") + word
        for row, line in enumerate(lines):
            sheet.append(f'<text x="{x}" y="{y+58+row*12}" text-anchor="middle" fill="#bbb" font-family="sans-serif" font-size="10">{html.escape(line)}</text>')
    sheet.append("</svg>")
    (out / "specimen.svg").write_text("\n".join(sheet) + "\n")
    rows = ["# Organon symbol review", "",
            "Generated by `uv run scripts/build-glyph-font.py` from the shared catalog and semantic review. **Nonbinding; all marks remain provisional.**", "",
            f"Coverage: {len(catalog)} marks; {sum(r['verdict'] == 'trial' for r in reviews['entries'])} retained trials, {sum(r['verdict'] == 'revised' for r in reviews['entries'])} revised trials, {sum(r['verdict'] == 'revise' for r in reviews['entries'])} awaiting redesign. Revised means changed, not approved. These are editorial judgments, not semantic proofs or reader-test results.", "",
            "![All shared glyphs, in registry order](./glyph-assets/specimen.svg)", "",
            "[Installable TTF](./glyph-assets/OrganonSymbols.ttf) · [Webfont](./glyph-assets/OrganonSymbols.woff2) · [Source catalog](./glyph-catalog.mjs) · [Method](./unicode-vocabulary.md)", "",
            "[Geometric rules](./glyph-geometry.json): 32-unit grid, uniform 1.1-unit stroke, 1-unit ink margins, square caps and bounded miter joins. Golden-section guides at 12/20 are advisory, not a claim of semantic or aesthetic correctness.", "",
            "Private-use characters work only with this font. Labels and Organon IDs remain authoritative; component shapes do not imply compositional meaning. Earlier Unicode candidates are historical alternatives, not a second active alphabet.", "",
            "| Term | Font slot | Verdict | Cue | Risk | Recommendation |",
            "| --- | --- | --- | --- | --- | --- |"]
    for glyph, term, review in zip(catalog, terms, reviews["entries"]):
        fields = [f'[{term.get("label", glyph["term"])}](../ontology/ontology.md#{term["anchor"]})',
                  f'U+{glyph["codepoint"]:04X}', *[review[k] for k in ("verdict", "cue", "risk", "recommendation")]]
        rows.append("| " + " | ".join(f.replace("|", "\\|") for f in fields) + " |")
    (output_root / "proposals/glyph-atlas.md").write_text("\n".join(rows) + "\n")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="Fail if generated artifacts are stale; write nothing to the repository")
    args = parser.parse_args()
    if args.check:
        with tempfile.TemporaryDirectory() as directory:
            temporary = Path(directory)
            build(temporary)
            for path in temporary.rglob("*"):
                if path.is_file():
                    target = ROOT / path.relative_to(temporary)
                    assert target.exists() and target.read_bytes() == path.read_bytes(), f"Stale glyph artifact: {target}"
        print("PASS: shared catalog, reviewed sources, fonts and study artifacts agree.")
    else:
        build(ROOT)
        print("Built shared glyphs: TTF, WOFF2, specimen and semantic atlas.")


if __name__ == "__main__":
    main()
