#!/usr/bin/env python3
"""Verify typed, nonbinding statements in Organon proposal dossiers."""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
PROPOSALS = ROOT / "proposals"
TERM_REGISTRY = ROOT / "ontology" / "terms.yaml"
ALLOWED_TYPES = {
    "proposed_definition",
    "hypothesis",
    "anti_collapse_constraint",
    "open_formalization_gate",
    "open_evidence_gate",
}
MARKER = re.compile(
    r"<!-- organon:proposal-statement ([A-Z]{2}-[A-Z][0-9]+) "
    r"type=([a-z_]+) -->"
)


def check_manifest(path: Path, known_terms: set[str]) -> list[str]:
    errors: list[str] = []
    data = json.loads(path.read_text(encoding="utf-8"))
    base = path.parent
    markdown = base / data.get("markdown", "")
    formal = base / data.get("formal_shadow", "")
    formal_evidence = [base / item for item in data.get("formal_evidence", [])]

    if data.get("schema_version") != 1:
        errors.append(f"{path.name}: unsupported schema_version")
    if data.get("binding") is not False:
        errors.append(f"{path.name}: proposal manifest must remain nonbinding")
    if data.get("status") != "ready-for-review":
        errors.append(f"{path.name}: status must be ready-for-review")
    if not markdown.is_file():
        errors.append(f"{path.name}: missing Markdown file {markdown}")
        return errors
    if not formal.is_file():
        errors.append(f"{path.name}: missing formal shadow {formal}")
        return errors
    for evidence in formal_evidence:
        if not evidence.is_file():
            errors.append(f"{path.name}: missing formal evidence {evidence}")
    if errors:
        return errors

    markdown_text = markdown.read_text(encoding="utf-8")
    formal_text = "\n".join(
        item.read_text(encoding="utf-8")
        for item in [formal, *formal_evidence]
    )
    if "binding: false" not in markdown_text:
        errors.append(f"{markdown.name}: frontmatter must declare binding: false")
    if "status: ready-for-review" not in markdown_text:
        errors.append(f"{markdown.name}: frontmatter status does not match manifest")

    statements = data.get("statements", [])
    statement_ids = [item.get("id") for item in statements]
    duplicates = sorted({
        statement_id for statement_id in statement_ids
        if statement_ids.count(statement_id) > 1
    })
    for duplicate in duplicates:
        errors.append(f"{path.name}: duplicate statement ID {duplicate}")

    local_symbols = set(data.get("local_symbols", []))
    seen: set[str] = set()
    manifest_pairs: set[tuple[str, str]] = set()

    for item in statements:
        statement_id = item.get("id")
        statement_type = item.get("type")
        if not isinstance(statement_id, str):
            errors.append(f"{path.name}: statement missing string ID")
            continue
        if statement_type not in ALLOWED_TYPES:
            errors.append(f"{statement_id}: unknown statement type {statement_type}")
        manifest_pairs.add((statement_id, statement_type))

        for dependency in item.get("depends_on", []):
            if dependency in known_terms or dependency in local_symbols:
                continue
            if dependency in seen:
                continue
            errors.append(f"{statement_id}: unknown or forward dependency {dependency}")

        marker = (
            f"<!-- organon:proposal-statement {statement_id} "
            f"type={statement_type} -->"
        )
        if markdown_text.count(marker) != 1:
            errors.append(
                f"{statement_id}: expected one exact Markdown marker, "
                f"found {markdown_text.count(marker)}"
            )
        if markdown_text.count(f"| {statement_id} |") != 1:
            errors.append(f"{statement_id}: expected one statement-registry row")

        formal_symbol = item.get("formal_symbol")
        if formal_symbol and not re.search(
            rf"\b(?:structure|def|theorem|inductive)\s+{re.escape(formal_symbol)}\b",
            formal_text,
        ):
            errors.append(
                f"{statement_id}: formal symbol {formal_symbol} not declared"
            )
        seen.add(statement_id)

    markdown_pairs = set(MARKER.findall(markdown_text))
    for extra in sorted(markdown_pairs - manifest_pairs):
        errors.append(f"{markdown.name}: unregistered proposal marker {extra}")
    for missing in sorted(manifest_pairs - markdown_pairs):
        errors.append(f"{markdown.name}: missing proposal marker {missing}")

    return errors


def main() -> int:
    registry = json.loads(TERM_REGISTRY.read_text(encoding="utf-8"))
    known_terms = {item["id"] for item in registry["terms"]}
    manifests = sorted(PROPOSALS.glob("*-claims.json"))
    if not manifests:
        print("Proposal check failed: no statement manifests found")
        return 1

    errors: list[str] = []
    for manifest in manifests:
        errors.extend(check_manifest(manifest, known_terms))

    if errors:
        print("Proposal check failed:")
        for error in errors:
            print(f"- {error}")
        return 1

    statement_count = sum(
        len(json.loads(path.read_text(encoding="utf-8"))["statements"])
        for path in manifests
    )
    print(
        f"Proposal check passed: {len(manifests)} manifest(s), "
        f"{statement_count} typed statements."
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
