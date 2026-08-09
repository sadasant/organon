#!/usr/bin/env python3
"""Check Organon's stable terms, typed claims, and dependency order."""

from __future__ import annotations

import json
import re
import subprocess
import sys
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
PROVENANCE = ROOT / "provenance" / "terms.json"
FORMAL = ROOT / "ontology" / "formal"
GOVERNED = [
    path
    for path in (
        ROOT / "editorial" / "long-form.md",
        ROOT / "editorial" / "short-form.md",
        ROOT / "Long-Form-Editorial-Grammar.md",
        ROOT / "Samples" / "Short-Form.md",
    )
    if path.exists()
]
TERM_MARKER = re.compile(r"<!-- organon:term (organon:[A-Za-z0-9]+) claim=([A-Za-z0-9]+) -->")
CLAIM_MARKER = re.compile(r"<!-- organon:claim ([A-Za-z0-9]+) -->")
USE_MARKER = re.compile(
    r"<!-- organon:(?:uses|projection) [A-Za-z0-9]+ term=(organon:[A-Za-z0-9]+) claim=([A-Za-z0-9]+) -->"
)
DEFINITION = re.compile(r"^\*\*([^*]+)\*\* is", re.MULTILINE)
PERSONA_FIELD = re.compile(r"\*\*([^*]+):\*\*")
CORE_FORBIDDEN_DECLARATION = re.compile(
    r"\b(?:abbrev|def|theorem|structure|inductive)\s+"
    r"(Absent|Present|Mark|absenceElim|emptyEquiv|"
    r"absencePresenceExclusive|absencePresenceExhaustive|presenceObtains)\b"
)


def main() -> int:
    registry = json.loads(REGISTRY.read_text(encoding="utf-8"))
    provenance = json.loads(PROVENANCE.read_text(encoding="utf-8"))
    ontology = ONTOLOGY.read_text(encoding="utf-8")
    terms = registry["terms"]
    commitments = registry["commitments"]
    claim_types = set(registry["claim_types"])
    errors: list[str] = []

    term_ids = [term["id"] for term in terms]
    labels = [term["label"] for term in terms]
    claim_ids = [term["claim_id"] for term in terms] + [item["id"] for item in commitments]
    known_claims = set(claim_ids)
    known_terms = set(term_ids)

    if provenance.get("ontology_version") != registry.get("ontology_version"):
        errors.append("term provenance version does not match term registry")
    provenance_sources = set(provenance.get("sources", {}))
    provenance_terms: list[str] = []
    for group in provenance.get("groups", []):
        if group.get("basis") not in {
            "corpus-extraction",
            "adopted-commitment",
            "formalization-finding",
            "review-repair",
        }:
            errors.append(f"unknown provenance basis: {group.get('basis')}")
        for source in group.get("sources", []):
            if source not in provenance_sources:
                errors.append(f"unknown provenance source: {source}")
        provenance_terms.extend(group.get("terms", []))
    for term_id in sorted(known_terms - set(provenance_terms)):
        errors.append(f"missing term provenance: {term_id}")
    for term_id in sorted(set(provenance_terms) - known_terms):
        errors.append(f"unknown term in provenance: {term_id}")
    for term_id in sorted({term for term in provenance_terms if provenance_terms.count(term) > 1}):
        errors.append(f"duplicate term provenance: {term_id}")

    for field, values in (("term ID", term_ids), ("term label", labels)):
        duplicates = sorted({value for value in values if values.count(value) > 1})
        for duplicate in duplicates:
            errors.append(f"duplicate {field}: {duplicate}")

    term_claims = [term["claim_id"] for term in terms]
    duplicate_claims = sorted(
        claim for claim in set(term_claims)
        if term_claims.count(claim) > 1 and claim not in {"A3", "A5"}
    )
    for duplicate in duplicate_claims:
        errors.append(f"duplicate term claim ID: {duplicate}")

    seen_terms: set[str] = set()
    for term in terms:
        if term["claim_type"] not in claim_types:
            errors.append(f"{term['id']}: unknown claim type {term['claim_type']}")
        for dependency in term["depends_on"]:
            if dependency not in known_terms:
                errors.append(f"{term['id']}: unknown term dependency {dependency}")
            elif dependency not in seen_terms:
                errors.append(f"{term['id']}: forward term dependency {dependency}")
        seen_terms.add(term["id"])

        marker = f'<!-- organon:term {term["id"]} claim={term["claim_id"]} -->'
        if ontology.count(marker) != 1:
            errors.append(f"{term['id']}: expected one source marker, found {ontology.count(marker)}")
        anchor = f'<a id="{term["anchor"]}"></a>'
        if ontology.count(anchor) != 1:
            errors.append(f"{term['id']}: expected one stable anchor, found {ontology.count(anchor)}")

    registered_labels = set(labels)
    for label in DEFINITION.findall(ontology):
        if label not in registered_labels:
            errors.append(f"unregistered binding definition: {label}")

    seen_claims: set[str] = set(term_claims)
    for commitment in commitments:
        if commitment["claim_type"] not in claim_types:
            errors.append(f"{commitment['id']}: unknown claim type {commitment['claim_type']}")
        for dependency in commitment["depends_on"]:
            if dependency not in known_terms and dependency not in seen_claims:
                errors.append(f"{commitment['id']}: unknown or forward dependency {dependency}")
        seen_claims.add(commitment["id"])
        marker = f'<!-- organon:claim {commitment["id"]} -->'
        all_text = ontology + "\n" + "\n".join(path.read_text(encoding="utf-8") for path in GOVERNED)
        if all_text.count(marker) != 1:
            errors.append(f"{commitment['id']}: expected one claim marker, found {all_text.count(marker)}")

    for path in GOVERNED:
        text = path.read_text(encoding="utf-8")
        for term_id, claim_id in USE_MARKER.findall(text):
            if term_id not in known_terms:
                errors.append(f"{path.relative_to(ROOT)}: unknown governed term {term_id}")
            if claim_id not in known_claims:
                errors.append(f"{path.relative_to(ROOT)}: unknown governed claim {claim_id}")
        for field in PERSONA_FIELD.findall(text):
            if field in registered_labels:
                errors.append(
                    f"{path.relative_to(ROOT)}: persona field collides with ontology term {field}"
                )

    core_path = FORMAL / "OrganonCore.lean"
    extension_path = FORMAL / "DanielOntology.lean"
    if not core_path.is_file():
        errors.append("formal reduct missing: ontology/formal/OrganonCore.lean")
    else:
        core_text = core_path.read_text(encoding="utf-8")
        forbidden = sorted(set(CORE_FORBIDDEN_DECLARATION.findall(core_text)))
        if forbidden:
            errors.append(
                "OrganonCore declares Absence-extension identifiers: "
                + ", ".join(forbidden)
            )
    if not extension_path.is_file():
        errors.append("formal extension missing: ontology/formal/DanielOntology.lean")
    elif not extension_path.read_text(encoding="utf-8").startswith("import OrganonCore\n"):
        errors.append("DanielOntology.lean must conservatively extend OrganonCore")
    for formal_path in sorted(FORMAL.glob("*.lean")):
        if formal_path == extension_path:
            continue
        first_imports = [
            line for line in formal_path.read_text(encoding="utf-8").splitlines()
            if line.startswith("import ")
        ]
        if "import DanielOntology" in first_imports:
            errors.append(
                f"{formal_path.relative_to(ROOT)}: formal classifier bypasses OrganonCore reduct"
            )

    audit_check = subprocess.run(
        [sys.executable, str(ROOT / "scripts" / "check-organon-core-audit.py")],
        cwd=ROOT,
        capture_output=True,
        text=True,
    )
    if audit_check.returncode != 0:
        errors.append(audit_check.stderr.strip() or audit_check.stdout.strip())

    bridge_check = subprocess.run(
        [sys.executable, str(ROOT / "scripts" / "check-bridges.py")],
        cwd=ROOT,
        capture_output=True,
        text=True,
    )
    if bridge_check.returncode != 0:
        errors.append(bridge_check.stderr.strip() or bridge_check.stdout.strip())

    prompt_check = subprocess.run(
        [sys.executable, str(ROOT / "scripts" / "build-ontology-prompt.py"), "--check"],
        cwd=ROOT,
        capture_output=True,
        text=True,
    )
    if prompt_check.returncode != 0:
        errors.append(prompt_check.stderr.strip() or prompt_check.stdout.strip())

    algebra_check = subprocess.run(
        [sys.executable, str(ROOT / "scripts" / "build-algebra.py"), "--check"],
        cwd=ROOT,
        capture_output=True,
        text=True,
    )
    if algebra_check.returncode != 0:
        errors.append(algebra_check.stderr.strip() or algebra_check.stdout.strip())

    if errors:
        print("Semantic check failed:")
        for error in errors:
            print(f"- {error}")
        return 1

    print(
        f"Semantic check passed: {len(terms)} terms, "
        f"{len(commitments)} typed commitments."
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
