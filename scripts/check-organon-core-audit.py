#!/usr/bin/env python3
"""Generate or verify the complete OrganonCore reduct term audit."""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
REGISTRY = ROOT / "ontology" / "terms.yaml"
REPORT = ROOT / "ontology" / "formal" / "organon-core-term-audit.md"

PROVED_TRANSLATIONS = {
    "organon:Presence": "CorePresence is definitionally Nonempty, exactly the current Present shadow.",
    "organon:Missingness": "An expected value supplies Presence; nonmembership remains the load-bearing relation.",
    "organon:Persistence": "The classifier carries an ordered history and identity Invariant and is extension-invariant.",
    "organon:Entity": "Every Entity now carries a classified Persistence witness for its identity.",
}

PENDING_DECISIONS: dict[str, str] = {
    "organon:Reality": "Choose an ambient metatheoretic or universe-indexed projection; no local carrier is Reality as a whole.",
}

CHALLENGE_SUPPORT = {
    "organon:Invariant",
    "organon:Boundary",
}

# A named Lean shadow exists. This is deliberately not a claim of prose parity.
FORMAL_SHADOWS = {
    "organon:Missingness", "organon:State", "organon:Direction",
    "organon:Transformation", "organon:Feeds", "organon:CausalPath",
    "organon:Invariant", "organon:Persistence", "organon:Constraint",
    "organon:Entity", "organon:Boundary", "organon:Scope",
    "organon:Specification", "organon:Capability",
    "organon:PermissionClaim", "organon:Authority", "organon:Grant",
    "organon:Permission", "organon:PermissionExercise",
    "organon:IndependentFor", "organon:ConsciousnessAttribution",
    "organon:ConsciousnessDesignation", "organon:Operationalization",
    "organon:World", "organon:Substrate", "organon:Truth",
    "organon:Trust", "organon:Alignment", "organon:Intelligence",
    "organon:OperativeKnowledge", "organon:KnowledgeTransmission",
    "organon:FactiveOperativeKnowledge", "organon:WarrantedKnowledge",
    "organon:MoralStatusAttribution", "organon:MoralPersonhoodDesignation",
    "organon:ConstituentSovereignty", "organon:ConstitutedSovereignty",
    "organon:BoundarySovereignty", "organon:ExternalSovereignty",
    "organon:Preference", "organon:UtilityMeasure", "organon:Price",
}


def render() -> str:
    registry = json.loads(REGISTRY.read_text(encoding="utf-8"))
    terms = registry["terms"]
    known = {term["id"] for term in terms}
    unknown_shadows = sorted(FORMAL_SHADOWS - known)
    if unknown_shadows:
        raise ValueError(f"unknown formal-shadow IDs: {', '.join(unknown_shadows)}")

    rows: list[str] = []
    counts: dict[str, int] = {}
    for term in terms:
        term_id = term["id"]
        if term_id == "organon:Absence":
            disposition = "extension-only"
            result = "excluded"
            reason = "The reduct intentionally has no classifier named Absence."
        elif term_id in PROVED_TRANSLATIONS:
            disposition = "translated"
            result = "proved"
            reason = PROVED_TRANSLATIONS[term_id]
        elif term_id in PENDING_DECISIONS:
            disposition = "challenge seam"
            result = "pending"
            reason = PENDING_DECISIONS[term_id]
        elif term_id in CHALLENGE_SUPPORT:
            disposition = "challenge support"
            result = "unknown"
            reason = "Used by the adversarial history classifier; binding parity remains unproved."
        elif term_id in FORMAL_SHADOWS:
            disposition = "compiled shadow"
            result = "unknown"
            reason = "The Lean shadow is extension-invariant; exact prose parity is not established."
        elif "organon:Presence" in term["depends_on"]:
            disposition = "direct translation gate"
            result = "unknown"
            reason = "The prose definition names Presence directly and lacks an exact paired classifier."
        else:
            disposition = "downstream translation gate"
            result = "unknown"
            reason = "No exact paired classifier yet; dependency closure alone cannot prove preservation."
        counts[result] = counts.get(result, 0) + 1
        rows.append(
            f"| {term['claim_id']} | `{term_id}` | {disposition} | {result} | {reason} |"
        )

    if len(rows) != 104:
        raise ValueError(f"expected 104 registered terms, found {len(rows)}")

    return "\n".join([
        "---",
        "type: formal-experiment-audit",
        "status: draft",
        "canonicality: noncanonical",
        "created: 2026-08-03",
        f'ontology_version: "{registry["ontology_version"]}"',
        "generated_by: scripts/check-organon-core-audit.py",
        "---",
        "# OrganonCore term audit",
        "",
        "This table accounts for every registered term. `proved` means only that the declared challenge classifier is preserved in Lean. It is not automatically a complete encoding of the binding prose. `compiled shadow` means a named Lean shadow builds without the Absence extension; it does not mean that the shadow is extensionally identical to the binding prose definition.",
        "",
        f"Result totals: **{counts.get('proved', 0)} proved translations**, **{counts.get('pending', 0)} pending representation decision**, **{counts.get('excluded', 0)} intentionally excluded**, and **{counts.get('unknown', 0)} unknown**.",
        "",
        "| Claim | Term | Reduct disposition | Experiment result | Reason |",
        "|---|---|---|---|---|",
        *rows,
        "",
    ])


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    expected = render()
    if args.write:
        REPORT.write_text(expected, encoding="utf-8")
        print(f"Wrote {REPORT.relative_to(ROOT)}")
        return 0
    if not REPORT.exists() or REPORT.read_text(encoding="utf-8") != expected:
        print("OrganonCore term audit is stale; run with --write.", file=sys.stderr)
        return 1
    print("OrganonCore term audit passed: 104 registered terms accounted for.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
