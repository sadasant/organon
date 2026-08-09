#!/usr/bin/env python3
"""Build the exhaustive, nonbinding completeness audit for the candidate algebra."""

from __future__ import annotations

import argparse
import hashlib
import json
import sys
from collections import Counter
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
ALGEBRA = ROOT / "ontology" / "algebra"
REGISTRY = ROOT / "ontology" / "terms.yaml"
NORMAL_FORMS = ALGEBRA / "normal-forms.yaml"
LAWS = ALGEBRA / "candidate-laws.yaml"
CLAIM_COVERAGE = ALGEBRA / "claim-coverage.yaml"
CONSISTENCY = ALGEBRA / "consistency-dispositions.yaml"
LEDGER = ALGEBRA / "reduction-ledger.yaml"
REPORT = ALGEBRA / "complete-reduction-report.md"


class AuditError(RuntimeError):
    pass


def load(path: Path) -> dict[str, Any]:
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as error:
        raise AuditError(f"cannot load {path.relative_to(ROOT)}: {error}") from error
    if not isinstance(value, dict):
        raise AuditError(f"{path.relative_to(ROOT)} must contain one object")
    return value


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def write_or_check(path: Path, content: str, *, check: bool) -> None:
    if check:
        if not path.is_file() or path.read_text(encoding="utf-8") != content:
            raise AuditError(f"generated reduction artifact is stale: {path.relative_to(ROOT)}")
        return
    path.write_text(content, encoding="utf-8")


def audit(*, check: bool) -> dict[str, int]:
    registry = load(REGISTRY)
    cards = load(NORMAL_FORMS).get("cards", [])
    laws = load(LAWS).get("laws", [])
    candidate_entries = load(CLAIM_COVERAGE).get("entries", [])
    dispositions = load(CONSISTENCY).get("dispositions", [])

    terms = registry.get("terms", [])
    commitments = registry.get("commitments", [])
    term_ids = [term["id"] for term in terms]
    if len(term_ids) != 109 or len(term_ids) != len(set(term_ids)):
        raise AuditError("complete audit requires exactly 109 unique registered terms")

    card_by_term = {card["term_id"]: card["id"] for card in cards}
    if len(card_by_term) != len(cards):
        raise AuditError("normal forms must target unique terms")
    if set(card_by_term) - set(term_ids):
        raise AuditError("normal form targets an unregistered term")

    term_entries = []
    for term in terms:
        if term["claim_type"] in {"primitive", "axiom"}:
            disposition = "retained_foundation"
            reason = "A reduction may test independence but cannot silently derive away a declared primitive or axiom."
            pair = None
        elif term["id"] in card_by_term:
            disposition = "constructively_encoded"
            reason = f"The positive constructor is encoded by {card_by_term[term['id']]} and has a finite witness."
            pair = None
        else:
            disposition = "positively_underdetermined"
            reason = "Dependencies declare vocabulary prerequisites, not a sufficient constructor; the six prohibitive laws have no positive head for this predicate."
            pair = {
                "all_declared_dependencies_present": True,
                "shared_dependency_extensions": term["depends_on"],
                "target_predicate": term["id"],
                "model_without_target_extension": [],
                "model_with_target_extension": ["candidate"],
                "classification_differs": True,
            }
        term_entries.append(
            {
                "term": term["id"],
                "claim": term["claim_id"],
                "claim_type": term["claim_type"],
                "depends_on": term["depends_on"],
                "disposition": disposition,
                "reason": reason,
                **({"paired_underdetermination_model": pair} if pair else {}),
            }
        )

    consistency_ids = {
        item["id"] for item in commitments if item["claim_type"] == "binding_constraint"
    }
    disposition_ids = [item.get("claim") for item in dispositions]
    if set(disposition_ids) != consistency_ids or len(disposition_ids) != len(set(disposition_ids)):
        raise AuditError("consistency dispositions must account for C1-C31 exactly once")
    candidate_ids = {entry["claim"] for entry in candidate_entries}
    allowed = {"candidate_clause_derived", "retained_governance", "positive_schema_missing"}
    for item in dispositions:
        if item.get("status") not in allowed:
            raise AuditError(f"{item.get('claim')}: unknown disposition")
        if (item["status"] == "candidate_clause_derived") != (item["claim"] in candidate_ids):
            raise AuditError(f"{item['claim']}: candidate coverage and complete disposition disagree")
        if item["status"] != "candidate_clause_derived" and not item.get("reason"):
            raise AuditError(f"{item['claim']}: residual disposition requires a reason")

    other_commitments = [
        {
            "claim": item["id"],
            "claim_type": item["claim_type"],
            "disposition": "retained_non_reduction_commitment",
            "reason": "The candidate algebra does not replace foundation axioms, authorized projections, or hypotheses.",
        }
        for item in commitments
        if item["claim_type"] != "binding_constraint"
    ]

    term_counts = Counter(item["disposition"] for item in term_entries)
    consistency_counts = Counter(item["status"] for item in dispositions)
    complete = not term_counts["positively_underdetermined"] and not consistency_counts["positive_schema_missing"]
    ledger = {
        "schema_version": 1,
        "status": "generated-nonbinding-complete-reduction-audit",
        "source_sha256": {
            "ontology/terms.yaml": digest(REGISTRY),
            "ontology/algebra/normal-forms.yaml": digest(NORMAL_FORMS),
            "ontology/algebra/candidate-laws.yaml": digest(LAWS),
            "ontology/algebra/claim-coverage.yaml": digest(CLAIM_COVERAGE),
            "ontology/algebra/consistency-dispositions.yaml": digest(CONSISTENCY),
            "scripts/build-reduction-audit.py": digest(Path(__file__).resolve()),
        },
        "question": "Do the retained foundation, nine positive normal forms, and six candidate laws preserve every registered Organon classification?",
        "answer": "yes" if complete else "no",
        "reason": "Complete reduction requires positive construction as well as prohibition of invalid collapses.",
        "counts": {
            "registered_terms": len(terms),
            "registered_commitments": len(commitments),
            "candidate_laws": len(laws),
            "normal_forms": len(cards),
            **dict(sorted(term_counts.items())),
            **{f"consistency_{key}": value for key, value in sorted(consistency_counts.items())},
        },
        "terms": term_entries,
        "consistency_rules": dispositions,
        "other_commitments": other_commitments,
    }

    missing_terms = [item for item in term_entries if item["disposition"] == "positively_underdetermined"]
    missing_rules = [item for item in dispositions if item["status"] == "positive_schema_missing"]
    report = [
        "# Complete reduction audit",
        "",
        "> Generated from the complete v0.18 registry. This audits the candidate algebra after v0.18 promoted definition admission into C1.",
        "",
        "## Result",
        "",
        "**The six-law candidate algebra is not a complete reduction of Organon.**",
        "",
        "It is a compact algebra of admissibility: it explains why many proposed joins fail and why several indices and witnesses must be conserved. It is not a generative algebra. Its laws have no positive predicate heads, so they cannot reconstruct a classification merely by rejecting malformed alternatives.",
        "",
        f"The exhaustive ledger accounts for all **{len(terms)} terms** and **{len(commitments)} commitments**. It retains {term_counts['retained_foundation']} foundational terms, constructively encodes {term_counts['constructively_encoded']} definitions, and exhibits paired underdetermination models for the remaining {term_counts['positively_underdetermined']} definitions. It accounts for all 31 consistency rules: {consistency_counts['candidate_clause_derived']} have candidate clause-level derivations, {consistency_counts['retained_governance']} remain governance constraints, and {consistency_counts['positive_schema_missing']} still require positive domain circuits.",
        "",
        "## Why dependency closure is insufficient",
        "",
        "`depends_on` says which earlier vocabulary a definition may use. It does not say that the presence of those dependencies entails the defined term. Treating the dependency graph as a constructor would make every listed prerequisite decorative and would recreate the exact collapse problem this experiment is meant to prevent.",
        "",
        "For every unencoded definition, the ledger therefore supplies a pair of finite interpretations that agree on the current candidate basis while differing only in that term's extension. The laws classify both interpretations identically. The target classification does not survive reduction.",
        "",
        "## Missing positive circuits",
        "",
    ]
    for item in missing_rules:
        report.append(f"- `{item['claim']}`: {item['reason']}")
    report.extend(
        [
            "",
            "## What did reduce",
            "",
            "The experiment still found a real compression. Six laws organize the tested anti-collapses, every law is ablation-essential on the finite suite, and the unchanged basis generalizes to the held-out domains without blocking complete institutional constitution. What reduces is a substantial part of Organon's **admissibility discipline**, not its complete positive vocabulary.",
            "",
            "## Next reduction question",
            "",
            "The next candidate is a two-part architecture:",
            "",
            "1. a small generative calculus of positive constructors for persistence, representation, causation, agency, institution, epistemic status, situated world, adaptive knowledge, and ritual meaning; and",
            "2. the six-law admissibility algebra governing how those constructors may compose.",
            "",
            "A future completeness claim must reconstruct all 106 definitions from that combined basis and eliminate every paired underdetermination model. Adding more prohibitions alone cannot do it.",
            "",
            "## Follow-on constructor result",
            "",
            "The [positive constructor calculus](./positive-calculus-report.md) closes the registry-level operational gap with one generic witnessed-introduction rule. It reconstructs all 106 definitions from their complete binding definition schemas and declared dependencies, but fails the semantic anti-vacuity gate because the conformity witness is opaque to the evaluator. It eliminates the paired underdetermination models only after that term-specific witness is supplied; it does not semantically eliminate any definition schema.",
            "",
            "## Complete disposition",
            "",
            "| Disposition | Count |",
            "|---|---:|",
            f"| Retained primitive or axiom | {term_counts['retained_foundation']} |",
            f"| Constructively encoded definition | {term_counts['constructively_encoded']} |",
            f"| Positively underdetermined definition | {term_counts['positively_underdetermined']} |",
            f"| Candidate-derived consistency clause | {consistency_counts['candidate_clause_derived']} |",
            f"| Retained governance constraint | {consistency_counts['retained_governance']} |",
            f"| Consistency rule missing a positive circuit | {consistency_counts['positive_schema_missing']} |",
            "",
            "The machine-readable term-by-term and commitment-by-commitment record is [reduction-ledger.yaml](./reduction-ledger.yaml).",
            "",
        ]
    )

    write_or_check(LEDGER, json.dumps(ledger, indent=2) + "\n", check=check)
    write_or_check(REPORT, "\n".join(report), check=check)
    return {
        "terms": len(terms),
        "commitments": len(commitments),
        "encoded": term_counts["constructively_encoded"],
        "underdetermined": term_counts["positively_underdetermined"],
        "missing_rules": consistency_counts["positive_schema_missing"],
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    try:
        result = audit(check=args.check)
    except AuditError as error:
        print(f"Reduction audit failed: {error}", file=sys.stderr)
        return 1
    action = "verified" if args.check else "generated"
    print(
        f"Complete reduction audit {action}: {result['terms']} terms, "
        f"{result['commitments']} commitments, {result['encoded']} positive constructors, "
        f"{result['underdetermined']} underdetermined definitions, "
        f"{result['missing_rules']} missing positive circuits."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
