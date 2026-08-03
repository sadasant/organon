#!/usr/bin/env python3
"""Independently validate Organon's concrete finite relational inhabitant."""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
REGISTRY = ROOT / "ontology" / "terms.yaml"
ONTOLOGY = ROOT / "ontology" / "ontology.md"
INSTANCE = ROOT / "ontology" / "relational" / "registry-global-instance.json"


def fail(errors: list[str]) -> int:
    print("Relational inhabitant check failed:")
    for error in errors:
        print(f"- {error}")
    return 1


def main() -> int:
    registry = json.loads(REGISTRY.read_text(encoding="utf-8"))
    instance = json.loads(INSTANCE.read_text(encoding="utf-8"))
    errors: list[str] = []

    if instance.get("ontology_version") != registry.get("ontology_version"):
        errors.append("ontology version mismatch")
    if instance.get("terms") != registry.get("terms"):
        errors.append("term registry projection is not exact")
    if instance.get("commitments") != registry.get("commitments"):
        errors.append("commitment registry projection is not exact")

    term_ids = {item["id"] for item in registry["terms"]}
    commitment_ids = {item["id"] for item in registry["commitments"]}

    dependencies = {
        item["id"]: set(item.get("depends_on", [])) for item in registry["terms"]
    }
    visiting: set[str] = set()
    visited: set[str] = set()

    def visit(term_id: str) -> None:
        if term_id in visiting:
            errors.append(f"term dependency cycle reaches {term_id}")
            return
        if term_id in visited:
            return
        visiting.add(term_id)
        for dependency in dependencies[term_id]:
            if dependency not in dependencies:
                errors.append(f"{term_id}: unknown dependency {dependency}")
            else:
                visit(dependency)
        visiting.remove(term_id)
        visited.add(term_id)

    for term_id in dependencies:
        visit(term_id)
    coverage = instance.get("commitment_coverage", {})
    if set(coverage) != commitment_ids:
        errors.append("commitment coverage is incomplete")
    allowed_coverage = {"executable-constraint", "exact-metadata-only"}
    if set(coverage.values()) - allowed_coverage:
        errors.append("unknown commitment coverage classification")

    nodes = instance.get("nodes", [])
    node_ids = [node.get("id") for node in nodes]
    if len(node_ids) != len(set(node_ids)):
        errors.append("duplicate node identifier")
    classifications = {node["id"]: set(node.get("classifies", [])) for node in nodes}
    for node_id, classes in classifications.items():
        unknown = classes - term_ids
        if unknown:
            errors.append(f"{node_id}: unknown classifications {sorted(unknown)}")
        if not classes:
            errors.append(f"{node_id}: degenerate unclassified node")

    absence = "organon:Absence"
    if any(absence in classes for classes in classifications.values()):
        errors.append("absolute Absence has an inhabitant")
    witnessed = set().union(*classifications.values()) if classifications else set()
    missing_terms = (term_ids - {absence}) - witnessed
    if missing_terms:
        errors.append(f"unwitnessed registered terms: {sorted(missing_terms)}")
    if len(nodes) < 24:
        errors.append("fewer than 24 distinct nodes")
    if not any(len(classes) >= 2 for classes in classifications.values()):
        errors.append("no joined multi-classification node")
    if "JoinedCausal" not in classifications or "JoinedInstitutional" not in classifications:
        errors.append("missing named joined scenarios")

    for source, required in instance.get("positive_entailments", {}).items():
        for node_id, classes in classifications.items():
            if source in classes and not set(required) <= classes:
                errors.append(f"{node_id}: {source} lacks positive join {required}")

    for obligation in instance.get("anti_entailments", []):
        required = set(obligation["required"])
        denied = obligation["denied"]
        if not any(required <= classes and denied not in classes for classes in classifications.values()):
            errors.append(
                f"{obligation['claim']}: no counterexample for {sorted(required)} -> {denied}"
            )

    for obligation in instance.get("disjoint_classes", []):
        left, right = obligation["left"], obligation["right"]
        if any({left, right} <= classes for classes in classifications.values()):
            errors.append(f"{obligation['claim']}: {left} collapses with {right}")

    declared_relations = set(
        re.findall(r"^\| `([^`]+)` \|", ONTOLOGY.read_text(encoding="utf-8"), re.MULTILINE)
    )
    witnesses = instance.get("relation_witnesses", [])
    witness_kinds = [witness.get("kind") for witness in witnesses]
    if set(witness_kinds) != declared_relations or len(witness_kinds) != len(declared_relations):
        errors.append("relation-signature witness coverage is not exact")
    participating_nodes: list[str] = []
    for witness in witnesses:
        kind = witness["kind"]
        output = witness["output"]
        if output not in classifications:
            errors.append(f"{kind}: unknown output node {output}")
            continue
        if witness["produces"] not in classifications[output]:
            errors.append(f"{kind}: output lacks {witness['produces']}")
        slots = [argument["slot"] for argument in witness.get("arguments", [])]
        if slots != list(range(len(slots))):
            errors.append(f"{kind}: role slots are not contiguous")
        for argument in witness.get("arguments", []):
            node_id = argument["node"]
            if node_id not in classifications:
                errors.append(f"{kind}: unknown argument node {node_id}")
                continue
            participating_nodes.append(node_id)
            expected = set(argument["expects_any"])
            if not expected & classifications[node_id]:
                errors.append(f"{kind}: slot {argument['slot']} is ill-typed")

    if len(participating_nodes) == len(set(participating_nodes)):
        errors.append("relation witnesses share no participants")

    if errors:
        return fail(errors)
    print(
        "Relational inhabitant passed: "
        f"{len(term_ids)} terms, {len(commitment_ids)} commitments, "
        f"{len(nodes)} nodes, {len(witnesses)} typed relations."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
