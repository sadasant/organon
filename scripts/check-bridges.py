#!/usr/bin/env python3
"""Check that every audited hidden bridge has one stable resolution."""

from __future__ import annotations

import json
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
REGISTRY = ROOT / "ontology" / "terms.yaml"
BRIDGES = ROOT / "ontology" / "bridges.json"

EXPECTED = {
    "identity-criterion": "declared-metalanguage-with-object-witness",
    "denotation-and-use": "typed-relation-and-generic-use-elimination",
    "causal-contribution": "typed-relation",
    "modal-capability": "declared-constraint-relative-satisfiability-with-object-witness",
    "evidential-support": "typed-relation",
    "institutional-eligibility": "derived-alias",
}
PROMOTED = {
    "denotation-and-use": "organon:Denotation",
    "causal-contribution": "organon:CausalContribution",
    "evidential-support": "organon:EvidentialBearing",
    "institutional-eligibility": "organon:Standing",
}
FORBIDDEN_TERMS = {"organon:Use", "organon:Eligibility", "organon:Possibility"}


def main() -> int:
    registry = json.loads(REGISTRY.read_text(encoding="utf-8"))
    document = json.loads(BRIDGES.read_text(encoding="utf-8"))
    known_terms = {term["id"] for term in registry["terms"]}
    errors: list[str] = []

    if document.get("ontology_version") != registry.get("ontology_version"):
        errors.append("bridge registry version does not match term registry")

    entries = document.get("bridges", [])
    by_id = {entry.get("id"): entry for entry in entries}
    if len(by_id) != len(entries):
        errors.append("bridge registry contains duplicate IDs")

    missing = sorted(set(EXPECTED) - set(by_id))
    extra = sorted(set(by_id) - set(EXPECTED))
    for bridge_id in missing:
        errors.append(f"missing bridge resolution: {bridge_id}")
    for bridge_id in extra:
        errors.append(f"unexpected bridge resolution: {bridge_id}")

    for bridge_id, expected_resolution in EXPECTED.items():
        entry = by_id.get(bridge_id)
        if not entry:
            continue
        if entry.get("resolution") != expected_resolution:
            errors.append(f"{bridge_id}: wrong resolution")
        if entry.get("term") != PROMOTED.get(bridge_id):
            errors.append(f"{bridge_id}: wrong promoted or derived term")
        for term_id in entry.get("required_terms", []):
            if term_id not in known_terms:
                errors.append(f"{bridge_id}: unknown required term {term_id}")

    for term_id in sorted(FORBIDDEN_TERMS & known_terms):
        errors.append(f"hidden bridge was reintroduced as duplicate term: {term_id}")

    if errors:
        print("Hidden-bridge check failed:")
        for error in errors:
            print(f"- {error}")
        return 1

    print("Hidden-bridge check passed: 6 bridge resolutions remain explicit.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
