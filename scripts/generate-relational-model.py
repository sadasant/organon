#!/usr/bin/env python3
"""Generate and verify Organon's complete finite Alloy registry model."""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
REGISTRY = ROOT / "ontology" / "terms.yaml"
ONTOLOGY = ROOT / "ontology" / "ontology.md"
OUTPUT = ROOT / "ontology" / "relational" / "registry-global.als"
INSTANCE = ROOT / "ontology" / "relational" / "registry-global-instance.json"


def t(name: str) -> str:
    return f"organon:{name}"


# Roles preserve repetition and alternatives. The produced term is the stable
# registry concept classified by the relation witness.
RELATIONS: dict[str, tuple[list[tuple[str, ...]], str]] = {
    "directs": ([(t("Relation"),), (t("State"),), (t("State"),)], t("Direction")),
    "feeds": ([(t("State"),), (t("State"),), (t("Specification"),)], t("Feeds")),
    "persists": ([(t("Configuration"),), (t("Invariant"),), (t("Boundary"),), (t("State"),)], t("Persistence")),
    "senses": ([(t("Entity"),), (t("Difference"),), (t("Boundary"),)], t("Perception")),
    "remembers": ([(t("Entity"),), (t("Record"),), (t("State"),)], t("Memory")),
    "interprets": ([(t("Entity"),), (t("Perception"),), (t("Memory"), t("Model"))], t("Interpretation")),
    "acts": ([(t("Agent"),), (t("State"),), (t("Boundary"),)], t("Action")),
    "uses": ([(t("Agent"),), (t("Tool"),), (t("Action"),)], t("Tool")),
    "claims": ([(t("Agent"),), (t("Representation"),), (t("Scope"),)], t("Claim")),
    "specifies": ([(t("Representation"),), (t("Scope"),), (t("Rule"),)], t("Specification")),
    "observes": ([(t("Witness"),), (t("Environment"),), (t("Specification"),), (t("CausalPath"),)], t("Observation")),
    "controls": ([(t("Agent"),), (t("Constraint"), t("Rule")), (t("Scope"),)], t("Control")),
    "recognizes": ([(t("Order"),), (t("Entity"),), (t("Rule"),), (t("Scope"),)], t("Recognition")),
    "actsFor": ([(t("Order"),), (t("Agent"),), (t("Principal"),), (t("Scope"),)], t("ActsFor")),
    "countsAs": ([(t("Order"),), (t("Rule"),), (t("Presence"), t("Record")), (t("Standing"),), (t("Scope"),)], t("CountsAs")),
    "authorizes": ([(t("Order"),), (t("Agent"),), (t("Principal"),), (t("Scope"),)], t("Authority")),
    "declares": ([(t("Agent"),), (t("Authority"),), (t("Claim"),), (t("Specification"),), (t("Order"),)], t("Declaration")),
    "grants": ([(t("Declaration"),), (t("PermissionClaim"),)], t("Grant")),
    "admits": ([(t("Order"),), (t("Rule"),), (t("Claim"), t("Observation"), t("Record"))], t("Admission")),
    "permits": ([(t("Order"),), (t("PermissionClaim"),), (t("Grant"),)], t("Permission")),
    "revokes": ([(t("Order"),), (t("Declaration"),), (t("Permission"),), (t("State"),)], t("Revocation")),
    "exercises": ([(t("Permission"),), (t("Agent"),), (t("Action"),), (t("State"),)], t("PermissionExercise")),
    "isExercisable": ([(t("Permission"),), (t("Action"),), (t("State"),), (t("Capability"),), (t("Configuration"), t("Constraint"))], t("Exercisability")),
    "enforces": ([(t("Order"),), (t("Rule"),), (t("Constraint"),), (t("Record"), t("Consequence"))], t("Enforcement")),
    "independentFor": ([(t("Witness"),), (t("Agent"),), (t("Claim"),), (t("Observation"),), (t("Order"),)], t("IndependentFor")),
    "attests": ([(t("Witness"),), (t("Claim"),), (t("Specification"),), (t("Order"),)], t("Attestation")),
    "institutes": ([(t("Role"),), (t("Record"),), (t("Interface"),), (t("Flow"),)], t("Institution")),
    "constitutes": ([(t("Polity"),), (t("Agency"),), (t("Order"),)], t("ConstituentExercise")),
    "attributesConsciousness": ([(t("Agent"),), (t("Entity"),), (t("State"),), (t("Representation"),), (t("Specification"),), (t("Language"),), (t("Rule"),), (t("Map"),), (t("Scope"),)], t("ConsciousnessAttribution")),
    "designatesConsciousness": ([(t("Order"),), (t("Rule"),), (t("ConsciousnessAttribution"),), (t("Scope"),)], t("ConsciousnessDesignation")),
    "operationalizes": ([(t("Representation"),), (t("Rule"),), (t("Interface"),), (t("Scope"),), (t("Transformation"),), (t("CausalPath"),)], t("Operationalization")),
    "composesWorld": ([(t("Entity"),), (t("Environment"),), (t("Scope"),), (t("Constraint"),), (t("CausalPath"),), (t("Invariant"),)], t("World")),
    "servesAsSubstrate": ([(t("Configuration"),), (t("Scope"),), (t("State"),), (t("Feeds"),), (t("Constraint"),), (t("Transformation"),)], t("Substrate")),
    "isTrue": ([(t("Claim"),), (t("Representation"),), (t("Rule"),), (t("Specification"),), (t("Presence"),), (t("Reality"),), (t("Scope"),)], t("Truth")),
    "trusts": ([(t("Entity"),), (t("Entity"),), (t("Constraint"),), (t("CausalPath"),), (t("State"), t("Exposure")), (t("Scope"),)], t("Trust")),
    "alignsUnder": ([(t("Configuration"),), (t("Presence"),), (t("Specification"),), (t("Scope"),)], t("Alignment")),
    "actsIntelligently": ([(t("Agent"),), (t("Perception"),), (t("Memory"),), (t("Model"),), (t("Interpretation"),), (t("State"),), (t("Action"),), (t("Consequence"),), (t("Specification"),), (t("Scope"),)], t("Intelligence")),
    "knowsOperatively": ([(t("Record"),), (t("Agent"),), (t("Capability"),), (t("Constraint"),), (t("Rule"),), (t("Model"), t("Interpretation")), (t("CausalPath"),), (t("Action"), t("Transformation")), (t("State"), t("Consequence")), (t("Specification"),), (t("Scope"),)], t("OperativeKnowledge")),
    "transmitsKnowledge": ([(t("OperativeKnowledge"),), (t("State"),), (t("Record"),), (t("CausalPath"),), (t("OperativeKnowledge"),), (t("State"),), (t("Specification"),), (t("Scope"),)], t("KnowledgeTransmission")),
    "knowsFactively": ([(t("OperativeKnowledge"),), (t("Record"),), (t("Claim"),), (t("Truth"),), (t("Rule"),), (t("Specification"),), (t("Presence"),), (t("Scope"),)], t("FactiveOperativeKnowledge")),
    "knowsWarrantedly": ([(t("FactiveOperativeKnowledge"),), (t("Evidence"),), (t("Observation"),), (t("Witness"),), (t("AdmissibilityRule"),), (t("Order"),), (t("Admission"),)], t("WarrantedKnowledge")),
    "attributesMoralStatus": ([(t("Agent"),), (t("Entity"),), (t("State"),), (t("Representation"),), (t("Specification"),), (t("Language"),), (t("Rule"),), (t("Map"),), (t("Scope"),)], t("MoralStatusAttribution")),
    "designatesMoralPersonhood": ([(t("Order"),), (t("Rule"),), (t("MoralStatusAttribution"),), (t("Scope"),)], t("MoralPersonhoodDesignation")),
    "exercisesConstituentSovereignty": ([(t("Polity"),), (t("ConstituentPower"),), (t("ConstituentExercise"),), (t("Order"),), (t("Scope"),)], t("ConstituentSovereignty")),
    "holdsConstitutedSovereignty": ([(t("Order"),), (t("Entity"),), (t("Standing"),), (t("Authority"),), (t("Action"),), (t("Rule"),), (t("Scope"),)], t("ConstitutedSovereignty")),
    "holdsBoundarySovereignty": ([(t("Polity"), t("Entity")), (t("Boundary"),), (t("Constraint"),), (t("Transformation"),), (t("Enforcement"),), (t("Consequence"), t("State")), (t("Scope"),)], t("BoundarySovereignty")),
    "recognizesExternalSovereignty": ([(t("Order"),), (t("Order"),), (t("Entity"), t("Polity")), (t("Principal"),), (t("Action"),), (t("Rule"),), (t("Scope"),)], t("ExternalSovereignty")),
    "prefers": ([(t("Agent"),), (t("State"), t("Consequence")), (t("State"), t("Consequence")), (t("Rule"),), (t("Scope"),)], t("Preference")),
    "measuresUtility": ([(t("State"), t("Consequence")), (t("Map"),), (t("Rule"),), (t("Specification"),), (t("Scope"),)], t("UtilityMeasure")),
    "prices": ([(t("Ledger"),), (t("Record"),), (t("Order"),), (t("Rule"),), (t("Representation"),), (t("Presence"),), (t("State"),), (t("Scope"),)], t("Price")),
}


POSITIVE_ENTAILMENTS = {
    t("PermissionExercise"): [t("Permission")],
    t("FullyExercisablePermission"): [t("Permission"), t("Exercisability")],
    t("ConsciousnessDesignation"): [t("CountsAs"), t("Admission")],
    t("MoralPersonhoodDesignation"): [t("CountsAs"), t("Admission")],
    t("FactiveOperativeKnowledge"): [t("OperativeKnowledge"), t("Truth")],
    t("WarrantedKnowledge"): [t("FactiveOperativeKnowledge"), t("Evidence"), t("Admission")],
}


# Each tuple requires one finite counterexample to the stated implication.
ANTI_ENTAILMENTS: list[tuple[str, tuple[str, ...], str]] = [
    ("C6", (t("Claim"),), t("Evidence")),
    ("C7", (t("Capability"),), t("Standing")),
    ("C7", (t("Standing"),), t("Capability")),
    ("C7", (t("Authority"),), t("Capability")),
    ("C10", (t("ConsciousnessDesignation"),), t("Standing")),
    ("C10", (t("ConsciousnessDesignation"),), t("Person")),
    ("C10", (t("ConsciousnessDesignation"),), t("Permission")),
    ("C10", (t("ConsciousnessDesignation"),), t("Interface")),
    ("C10", (t("ConsciousnessDesignation"),), t("Consequence")),
    ("C11", (t("Operationalization"),), t("Map")),
    ("C11", (t("Operationalization"),), t("Evidence")),
    ("C14", (t("Truth"),), t("Evidence")),
    ("C14", (t("Evidence"),), t("Truth")),
    ("C14", (t("Truth"),), t("Admission")),
    ("C14", (t("Admission"),), t("Truth")),
    ("C14", (t("Claim"), t("Representation"), t("Rule"), t("Presence"), t("Specification")), t("Truth")),
    ("C15", (t("Trust"),), t("Control")),
    ("C15", (t("Trust"),), t("Evidence")),
    ("C15", (t("Permission"),), t("Trust")),
    ("C15", (t("Authority"),), t("Trust")),
    ("C16", (t("Alignment"),), t("Truth")),
    ("C16", (t("Alignment"),), t("Trust")),
    ("C16", (t("Alignment"),), t("Permission")),
    ("C16", (t("Alignment"),), t("Authority")),
    ("C16", (t("Alignment"),), t("Agency")),
    ("C16", (t("Alignment"),), t("Persistence")),
    ("C17", (t("Model"),), t("Intelligence")),
    ("C17", (t("Capability"),), t("Intelligence")),
    ("C17", (t("Intelligence"),), t("Truth")),
    ("C17", (t("Intelligence"),), t("Authority")),
    ("C18", (t("Record"),), t("OperativeKnowledge")),
    ("C18", (t("Truth"),), t("OperativeKnowledge")),
    ("C18", (t("OperativeKnowledge"),), t("Truth")),
    ("C18", (t("OperativeKnowledge"),), t("Evidence")),
    ("C19", (t("Record"),), t("KnowledgeTransmission")),
    ("C19", (t("KnowledgeTransmission"),), t("Intelligence")),
    ("C20", (t("OperativeKnowledge"),), t("FactiveOperativeKnowledge")),
    ("C20", (t("Truth"),), t("FactiveOperativeKnowledge")),
    ("C20", (t("FactiveOperativeKnowledge"),), t("WarrantedKnowledge")),
    ("C20", (t("Evidence"),), t("WarrantedKnowledge")),
    ("C21", (t("MoralPersonhoodDesignation"),), t("Person")),
    ("C21", (t("MoralPersonhoodDesignation"),), t("Standing")),
    ("C21", (t("MoralPersonhoodDesignation"),), t("Permission")),
    ("C21", (t("MoralPersonhoodDesignation"),), t("Consequence")),
    ("C23", (t("Action"),), t("Preference")),
    ("C23", (t("Preference"),), t("UtilityMeasure")),
    ("C23", (t("UtilityMeasure"),), t("Preference")),
    ("C23", (t("Price"),), t("Preference")),
    ("C23", (t("Price"),), t("UtilityMeasure")),
    ("C23", (t("Price"),), t("Truth")),
]


DISJOINT_CLASSES = [
    ("C5", t("Map"), t("Reality")),
    ("C5", t("Model"), t("Reality")),
    ("C5", t("Ledger"), t("Reality")),
    ("C12", t("World"), t("Reality")),
    ("C12", t("World"), t("Environment")),
    ("C12", t("World"), t("Map")),
    ("C12", t("World"), t("Reference")),
    ("C13", t("Substrate"), t("Representation")),
    ("C13", t("Substrate"), t("Invariant")),
    ("C13", t("Substrate"), t("Entity")),
]


def atom(prefix: str, identifier: str) -> str:
    return prefix + re.sub(r"[^A-Za-z0-9_]", "_", identifier.split(":")[-1])


def union(names: list[str] | tuple[str, ...], prefix: str = "T_") -> str:
    if not names:
        return "none"
    return " + ".join(atom(prefix, name) for name in names)


def relation_names_from_ontology() -> set[str]:
    text = ONTOLOGY.read_text(encoding="utf-8")
    return set(re.findall(r"^\| `([^`]+)` \|", text, re.MULTILINE))


def positive_closure(term: str) -> set[str]:
    result = {term}
    frontier = [term]
    while frontier:
        current = frontier.pop()
        for required in POSITIVE_ENTAILMENTS.get(current, []):
            if required not in result:
                result.add(required)
                frontier.append(required)
    return result


def build_instance(registry: dict) -> dict:
    terms = registry["terms"]
    commitments = registry["commitments"]
    nonabsence_terms = [item["id"] for item in terms if item["id"] != t("Absence")]
    alternate_terms: set[str] = set()
    for roles, _ in RELATIONS.values():
        chosen = [role[0] for role in roles]
        alternate_terms.update(term for term in chosen if chosen.count(term) > 1)

    nodes = [
        {"id": atom("N_", term), "classifies": sorted(positive_closure(term))}
        for term in nonabsence_terms
    ]
    nodes.extend(
        {"id": atom("N_Alt_", term), "classifies": [term]}
        for term in sorted(alternate_terms)
    )
    causal_join = [
        t("Presence"), t("Relation"), t("Configuration"), t("State"),
        t("Direction"), t("Transformation"), t("Change"), t("Feeds"),
        t("CausalPath"), t("Invariant"), t("Persistence"), t("Constraint"),
        t("Entity"), t("Boundary"), t("Environment"), t("Representation"),
        t("Scope"), t("Specification"), t("Rule"), t("Perception"),
        t("Record"), t("Memory"), t("Model"), t("Action"),
        t("Consequence"), t("Interpretation"), t("Agent"), t("Capability"),
        t("OperativeKnowledge"), t("Truth"), t("FactiveOperativeKnowledge"),
    ]
    institutional_join = [
        t("Presence"), t("Relation"), t("Configuration"), t("Record"),
        t("Agent"), t("Action"), t("Representation"), t("Scope"),
        t("Specification"), t("Rule"), t("Claim"), t("Order"),
        t("Standing"), t("Recognition"), t("Principal"), t("CountsAs"),
        t("Authority"), t("PermissionClaim"), t("Declaration"), t("Grant"),
        t("Admission"), t("Permission"), t("PermissionExercise"),
        t("Exercisability"), t("FullyExercisablePermission"), t("Evidence"),
        t("OperativeKnowledge"), t("Truth"), t("FactiveOperativeKnowledge"),
        t("WarrantedKnowledge"),
    ]
    nodes.extend([
        {"id": "JoinedCausal", "classifies": sorted(causal_join)},
        {"id": "JoinedInstitutional", "classifies": sorted(institutional_join)},
    ])
    nodes.extend(
        {"id": f"Counterexample_{claim}_{index}", "classifies": sorted(required)}
        for index, (claim, required, _) in enumerate(ANTI_ENTAILMENTS)
        if len(required) > 1
    )

    relation_witnesses = []
    for name, (roles, produced) in RELATIONS.items():
        seen: dict[str, int] = {}
        arguments = []
        for index, expected in enumerate(roles):
            chosen = expected[0]
            occurrence = seen.get(chosen, 0)
            seen[chosen] = occurrence + 1
            node_prefix = "N_Alt_" if occurrence else "N_"
            arguments.append({
                "slot": index,
                "expects_any": list(expected),
                "node": atom(node_prefix, chosen),
            })
        relation_witnesses.append({
            "kind": name,
            "produces": produced,
            "arguments": arguments,
            "output": atom("N_", produced),
        })

    constraint_claims = {
        claim_id for claim_id, _, _ in ANTI_ENTAILMENTS
    } | {claim_id for claim_id, _, _ in DISJOINT_CLASSES} | {"C1", "C4", "C20", "C21", "C22"}
    commitment_coverage = {
        item["id"]: (
            "executable-constraint" if item["id"] in constraint_claims
            else "exact-metadata-only"
        )
        for item in commitments
    }

    sovereignty = [t("ConstituentSovereignty"), t("ConstitutedSovereignty"), t("BoundarySovereignty"), t("ExternalSovereignty")]
    anti_entailments = [
        {"claim": claim, "required": list(required), "denied": denied}
        for claim, required, denied in ANTI_ENTAILMENTS
    ]
    anti_entailments.extend(
        {"claim": "C22", "required": [left], "denied": right}
        for left in sovereignty for right in sovereignty if left != right
    )

    return {
        "schema_version": 1,
        "ontology_version": registry["ontology_version"],
        "claim": "one constructive nondegenerate structural inhabitant",
        "semantic_boundary": "Registry topology and encoded obligations only; not full prose-semantic parity.",
        "terms": terms,
        "commitments": commitments,
        "commitment_coverage": commitment_coverage,
        "positive_entailments": POSITIVE_ENTAILMENTS,
        "anti_entailments": anti_entailments,
        "disjoint_classes": [
            {"claim": claim, "left": left, "right": right}
            for claim, left, right in DISJOINT_CLASSES
        ],
        "nodes": nodes,
        "relation_witnesses": relation_witnesses,
    }


def render() -> str:
    registry = json.loads(REGISTRY.read_text(encoding="utf-8"))
    terms = registry["terms"]
    commitments = registry["commitments"]
    known_terms = {item["id"] for item in terms}
    known_commitments = {item["id"] for item in commitments}

    declared_relations = relation_names_from_ontology()
    if declared_relations != set(RELATIONS):
        missing = sorted(declared_relations - set(RELATIONS))
        extra = sorted(set(RELATIONS) - declared_relations)
        raise ValueError(f"relation map mismatch; missing={missing}, extra={extra}")

    referenced_terms = {
        term
        for roles, produced in RELATIONS.values()
        for role in roles
        for term in role
    } | {produced for _, produced in RELATIONS.values()}
    referenced_terms |= {
        term for values in POSITIVE_ENTAILMENTS.values() for term in values
    } | set(POSITIVE_ENTAILMENTS)
    referenced_terms |= {
        term for _, required, denied in ANTI_ENTAILMENTS for term in (*required, denied)
    }
    referenced_terms |= {term for _, left, right in DISJOINT_CLASSES for term in (left, right)}
    unknown = sorted(referenced_terms - known_terms)
    if unknown:
        raise ValueError(f"unknown terms in relational model: {unknown}")

    for claim_id, _, _ in [*ANTI_ENTAILMENTS, *DISJOINT_CLASSES]:
        if claim_id not in known_commitments:
            raise ValueError(f"unknown commitment in relational model: {claim_id}")

    lines = [
        "module registry_global",
        "",
        "// Generated by scripts/generate-relational-model.py. Do not edit by hand.",
        "// Structural satisfiability does not establish full prose-semantic parity.",
        "",
        "abstract sig Term { dependsOn: set Term }",
    ]
    lines.extend(f"one sig {atom('T_', item['id'])} extends Term {{}}" for item in terms)
    lines.extend(["", "abstract sig Commitment { dependsOnTerm: set Term, dependsOnCommitment: set Commitment }"])
    lines.extend(f"one sig {atom('K_', item['id'])} extends Commitment {{}}" for item in commitments)
    max_roles = max(len(roles) for roles, _ in RELATIONS.values())
    lines.extend(["", "abstract sig Slot {}"])
    lines.append("one sig " + ", ".join(f"Slot{index}" for index in range(max_roles)) + " extends Slot {}")
    lines.append("abstract sig RelationDef { roles: set Slot, expects: Slot -> set Term, produces: one Term }")
    for name, (roles, _) in RELATIONS.items():
        lines.append(f"one sig {atom('R_', name)} extends RelationDef {{}}")

    nonabsence_terms = [item["id"] for item in terms if item["id"] != t("Absence")]
    alternate_terms: set[str] = set()
    for roles, _ in RELATIONS.values():
        chosen = [role[0] for role in roles]
        alternate_terms.update(term for term in chosen if chosen.count(term) > 1)

    lines.extend([
        "",
        "abstract sig Node { classifies: some Term }",
    ])
    lines.extend(f"one sig {atom('N_', term)} extends Node {{}}" for term in nonabsence_terms)
    lines.extend(f"one sig {atom('N_Alt_', term)} extends Node {{}}" for term in sorted(alternate_terms))
    lines.extend([
        "one sig JoinedCausal, JoinedInstitutional extends Node {}",
    ])
    for index, (claim, required, _) in enumerate(ANTI_ENTAILMENTS):
        if len(required) > 1:
            lines.append(f"one sig Counterexample_{claim}_{index} extends Node {{}}")
    lines.extend([
        "",
        "abstract sig RelationWitness {",
        "  kind: one RelationDef,",
        "  arguments: Slot -> lone Node,",
        "  output: one Node",
        "}",
    ])
    lines.extend(f"one sig {atom('W_', name)} extends RelationWitness {{}}" for name in RELATIONS)
    lines.extend([
        "",
        "fact ExactRegistryMetadata {",
    ])
    for item in terms:
        lines.append(f"  {atom('T_', item['id'])}.dependsOn = {union(item['depends_on'])}")
    for item in commitments:
        term_deps = [dep for dep in item["depends_on"] if dep in known_terms]
        commitment_deps = [dep for dep in item["depends_on"] if dep in known_commitments]
        lines.append(f"  {atom('K_', item['id'])}.dependsOnTerm = {union(term_deps)}")
        lines.append(f"  {atom('K_', item['id'])}.dependsOnCommitment = {union(commitment_deps, 'K_')}")
    lines.extend(["}", "", "fact ExactRelationMetadata {"])
    for name, (roles, produced) in RELATIONS.items():
        relation_atom = atom("R_", name)
        slot_atoms = [f"Slot{index}" for index in range(len(roles))]
        lines.append(f"  {relation_atom}.roles = {' + '.join(slot_atoms)}")
        lines.append(f"  {relation_atom}.produces = {atom('T_', produced)}")
        products = []
        for slot, expected in zip(slot_atoms, roles):
            products.extend(f"{slot}->{atom('T_', term)}" for term in expected)
        lines.append(f"  {relation_atom}.expects = {' + '.join(products)}")
    lines.extend(["}", "", "fact ExactNodeClassifications {"])

    for term in nonabsence_terms:
        lines.append(f"  {atom('N_', term)}.classifies = {union(sorted(positive_closure(term)))}")
    for term in sorted(alternate_terms):
        lines.append(f"  {atom('N_Alt_', term)}.classifies = {atom('T_', term)}")
    causal_join = [
        t("Presence"), t("Relation"), t("Configuration"), t("State"),
        t("Direction"), t("Transformation"), t("Change"), t("Feeds"),
        t("CausalPath"), t("Invariant"), t("Persistence"), t("Constraint"),
        t("Entity"), t("Boundary"), t("Environment"), t("Representation"),
        t("Scope"), t("Specification"), t("Rule"), t("Perception"),
        t("Record"), t("Memory"), t("Model"), t("Action"),
        t("Consequence"), t("Interpretation"), t("Agent"), t("Capability"),
        t("OperativeKnowledge"), t("Truth"), t("FactiveOperativeKnowledge"),
    ]
    institutional_join = [
        t("Presence"), t("Relation"), t("Configuration"), t("Record"),
        t("Agent"), t("Action"), t("Representation"), t("Scope"),
        t("Specification"), t("Rule"), t("Claim"), t("Order"),
        t("Standing"), t("Recognition"), t("Principal"), t("CountsAs"),
        t("Authority"), t("PermissionClaim"), t("Declaration"), t("Grant"),
        t("Admission"), t("Permission"), t("PermissionExercise"),
        t("Exercisability"), t("FullyExercisablePermission"), t("Evidence"),
        t("OperativeKnowledge"), t("Truth"), t("FactiveOperativeKnowledge"),
        t("WarrantedKnowledge"),
    ]
    lines.append(f"  JoinedCausal.classifies = {union(causal_join)}")
    lines.append(f"  JoinedInstitutional.classifies = {union(institutional_join)}")
    for index, (claim, required, _) in enumerate(ANTI_ENTAILMENTS):
        if len(required) > 1:
            lines.append(f"  Counterexample_{claim}_{index}.classifies = {union(required)}")
    lines.extend(["}", "", "fact ExactRelationWitnesses {"])
    for name, (roles, produced) in RELATIONS.items():
        witness = atom("W_", name)
        lines.append(f"  {witness}.kind = {atom('R_', name)}")
        seen: dict[str, int] = {}
        argument_products = []
        for index, role in enumerate(roles):
            chosen = role[0]
            occurrence = seen.get(chosen, 0)
            seen[chosen] = occurrence + 1
            node_prefix = "N_Alt_" if occurrence else "N_"
            argument_products.append(f"Slot{index}->{atom(node_prefix, chosen)}")
        lines.append(f"  {witness}.arguments = {' + '.join(argument_products)}")
        lines.append(f"  {witness}.output = {atom('N_', produced)}")
    lines.extend([
        "}",
        "",
        "// Dependency edges are exact above. Acyclicity is checked directly from",
        "// the registry by scripts/check-relational-instance.py; asking the SAT",
        "// solver for a transitive closure over 104 fixed terms adds no inhabitant",
        "// evidence and dominates the otherwise finite search.",
        "",
        "fact EveryRegisteredConceptIsWitnessedExceptAbsoluteAbsence {",
        f"  no node: Node | {atom('T_', t('Absence'))} in node.classifies",
        f"  all term: Term - {atom('T_', t('Absence'))} | some node: Node | term in node.classifies",
        "}",
        "",
        "fact EveryDeclaredRelationHasOneTypedWitness {",
        "  all definition: RelationDef | one witness: RelationWitness | witness.kind = definition",
        "  all witness: RelationWitness | {",
        "    witness.arguments.Node = witness.kind.roles",
        "    all slot: witness.kind.roles | some expected: witness.kind.expects[slot] | expected in witness.arguments[slot].classifies",
        "    all slot: Slot - witness.kind.roles | no witness.arguments[slot]",
        "    witness.kind.produces in witness.output.classifies",
        "  }",
        "}",
        "",
        "fact PositiveProfileJoins {",
    ])
    for source, required in POSITIVE_ENTAILMENTS.items():
        lines.append(f"  all node: Node | {atom('T_', source)} in node.classifies implies {union(required)} in node.classifies")
    lines.extend([
        "}",
        "",
        "pred implicationCounterexample[required: set Term, denied: Term] {",
        "  some node: Node | required in node.classifies and denied not in node.classifies",
        "}",
        "",
        "pred disjointClasses[left, right: Term] {",
        "  no node: Node | left + right in node.classifies",
        "}",
        "",
        "fact EncodedNoCollapseObligations {",
    ])
    for claim_id, required, denied in ANTI_ENTAILMENTS:
        lines.append(f"  implicationCounterexample[{union(required)}, {atom('T_', denied)}] // {claim_id}")
    for claim_id, left, right in DISJOINT_CLASSES:
        lines.append(f"  disjointClasses[{atom('T_', left)}, {atom('T_', right)}] // {claim_id}")
    sovereignty = [t("ConstituentSovereignty"), t("ConstitutedSovereignty"), t("BoundarySovereignty"), t("ExternalSovereignty")]
    for left in sovereignty:
        for right in sovereignty:
            if left != right:
                lines.append(f"  implicationCounterexample[{atom('T_', left)}, {atom('T_', right)}] // C22")
    lines.extend([
        "}",
        "",
        "pred NondegenerateGlobalInhabitant {",
        f"  disj[{atom('N_', t('Presence'))}, {atom('N_', t('State'))}, {atom('N_', t('Entity'))}, {atom('N_', t('Order'))}]",
        f"  {atom('T_', t('Entity'))} + {atom('T_', t('Agent'))} + {atom('T_', t('Action'))} in JoinedCausal.classifies",
        f"  {atom('T_', t('Order'))} + {atom('T_', t('Permission'))} + {atom('T_', t('Evidence'))} in JoinedInstitutional.classifies",
        "  some disj first, second: RelationWitness |",
        "    some first.arguments[Slot] & second.arguments[Slot]",
        "}",
        "",
        "run NondegenerateGlobalInhabitant for 0 Int",
        "",
    ])
    return "\n".join(lines)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    expected = render()
    registry = json.loads(REGISTRY.read_text(encoding="utf-8"))
    expected_instance = json.dumps(build_instance(registry), indent=2, sort_keys=True) + "\n"
    if args.write:
        OUTPUT.parent.mkdir(parents=True, exist_ok=True)
        OUTPUT.write_text(expected, encoding="utf-8")
        INSTANCE.write_text(expected_instance, encoding="utf-8")
        print(f"Wrote {OUTPUT.relative_to(ROOT)} and {INSTANCE.relative_to(ROOT)}")
        return 0
    if (
        not OUTPUT.exists()
        or OUTPUT.read_text(encoding="utf-8") != expected
        or not INSTANCE.exists()
        or INSTANCE.read_text(encoding="utf-8") != expected_instance
    ):
        print("Relational model or instance is stale; run with --write.", file=sys.stderr)
        return 1
    print("Relational model check passed: 104 terms, 34 commitments, "
          f"{len(RELATIONS)} relation signatures.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
