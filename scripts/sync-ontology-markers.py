#!/usr/bin/env python3
"""Insert missing stable term markers into the binding ontology."""

from __future__ import annotations

import json
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
ONTOLOGY = next(
    path
    for path in (ROOT / "ontology" / "ontology.md", ROOT / "Daniels-Ontology.md")
    if path.exists()
)
REGISTRY = next(
    path
    for path in (ROOT / "ontology" / "terms.yaml", ROOT / "Ontology" / "terms.yaml")
    if path.exists()
)


def main() -> None:
    registry = json.loads(REGISTRY.read_text(encoding="utf-8"))
    text = ONTOLOGY.read_text(encoding="utf-8")

    for term in registry["terms"]:
        marker = f'<!-- organon:term {term["id"]} claim={term["claim_id"]} -->'
        if marker in text:
            continue
        needle = f'**{term["label"]}** is'
        if text.count(needle) != 1:
            raise SystemExit(f"expected one definition for {term['id']}; found {text.count(needle)}")
        text = text.replace(needle, f'<a id="{term["anchor"]}"></a>\n{marker}\n\n{needle}', 1)

    ONTOLOGY.write_text(text, encoding="utf-8")
    print(f"Synchronized term markers in {ONTOLOGY.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
