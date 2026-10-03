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
ALLOWED_STATUSES = {
    "draft",
    "ready-for-review",
    "partially-promoted",
    "promoted",
    "rejected",
    "superseded",
}
MARKER = re.compile(
    r"<!-- organon:proposal-statement ([A-Z]{2}-[A-Z][0-9]+) "
    r"type=([a-z_]+) -->"
)
PROMOTION_CONTRACT_MARKER = re.compile(
    r"/-- organon:promotion-contract ([A-Z]{2}-[A-Z][0-9]+) -/"
)
FORMAL_CONTRACT_STATUSES = {
    "proved",
    "proved_with_boundaries",
    "outside_formal_boundary",
    "open_gate",
}
DEPENDENCY_DISPOSITION_STATUSES = {
    "formalized",
    "represented_by",
    "prose_only",
    "outside_formal_boundary",
}


def promotion_contract_block(text: str, statement_id: str) -> str | None:
    marker = f"/-- organon:promotion-contract {statement_id} -/"
    if text.count(marker) != 1:
        return None
    tail = text.split(marker, 1)[1]
    next_marker = PROMOTION_CONTRACT_MARKER.search(tail)
    return tail[: next_marker.start()] if next_marker else tail


def direct_prop_fields(text: str) -> set[str]:
    """Return structure fields whose declared value is directly a relation to Prop."""
    fields: set[str] = set()
    structure: str | None = None
    lines = text.splitlines()
    index = 0
    while index < len(lines):
        line = lines[index]
        structure_match = re.match(r"^structure\s+([A-Za-z][A-Za-z0-9_]*)\b", line)
        if structure_match:
            structure = structure_match.group(1)
            index += 1
            continue
        if structure and re.match(
            r"^(?:structure|def|theorem|inductive|abbrev|namespace|end)\b", line
        ):
            structure = None
            continue
        field_match = re.match(r"^  ([A-Za-z][A-Za-z0-9_]*)\s*:\s*(.*)$", line)
        if structure and field_match:
            field_name, declaration = field_match.groups()
            continuation = index + 1
            while continuation < len(lines):
                following = lines[continuation]
                if re.match(r"^  [A-Za-z][A-Za-z0-9_]*\s*:", following):
                    break
                if following and not following.startswith(" "):
                    break
                declaration += " " + following.strip()
                continuation += 1
            if re.search(r"(?:→|->)\s*Prop\b", declaration):
                fields.add(f"{structure}.{field_name}")
            index = continuation
            continue
        index += 1
    return fields


def check_dependency_dispositions(
    statement_id: str,
    dependencies: list[str],
    contract: dict,
    block: str,
    contract_status: str,
) -> list[str]:
    """Require an explicit, checked disposition for every declared dependency."""
    errors: list[str] = []
    if "required_symbols" in contract:
        errors.append(
            f"{statement_id}: required_symbols is forbidden; checked symbols "
            "must come from subject_symbols and dependency_dispositions"
        )

    subject_symbols = contract.get("subject_symbols")
    if not isinstance(subject_symbols, list) or not subject_symbols or not all(
        isinstance(symbol, str) and symbol for symbol in subject_symbols
    ):
        errors.append(f"{statement_id}: proved contract requires subject_symbols")
        subject_symbols = []

    dispositions = contract.get("dependency_dispositions")
    if not isinstance(dispositions, dict):
        errors.append(
            f"{statement_id}: proved contract requires dependency_dispositions"
        )
        dispositions = {}

    expected = set(dependencies)
    actual = set(dispositions)
    if actual != expected:
        errors.append(
            f"{statement_id}: dependency disposition drift; "
            f"missing {sorted(expected - actual)}, extra {sorted(actual - expected)}"
        )

    checked_symbols = list(subject_symbols)
    boundary_dependencies = 0
    for dependency in dependencies:
        disposition = dispositions.get(dependency)
        if not isinstance(disposition, dict):
            continue
        status = disposition.get("status")
        if status not in DEPENDENCY_DISPOSITION_STATUSES:
            errors.append(
                f"{statement_id}: {dependency} has invalid dependency status {status}"
            )
            continue
        symbols = disposition.get("symbols", [])
        reason = str(disposition.get("reason", "")).strip()
        if status in {"formalized", "represented_by"}:
            if not isinstance(symbols, list) or not symbols or not all(
                isinstance(symbol, str) and symbol for symbol in symbols
            ):
                errors.append(
                    f"{statement_id}: {dependency} status {status} requires symbols"
                )
                symbols = []
            checked_symbols.extend(symbols)
            if status == "represented_by" and len(reason) < 20:
                errors.append(
                    f"{statement_id}: represented dependency {dependency} "
                    "requires a substantive representation reason"
                )
        else:
            boundary_dependencies += 1
            if symbols:
                errors.append(
                    f"{statement_id}: {dependency} status {status} cannot claim symbols"
                )
            if len(reason) < 20:
                errors.append(
                    f"{statement_id}: {dependency} status {status} "
                    "requires a substantive boundary reason"
                )

    if contract_status == "proved" and boundary_dependencies:
        errors.append(
            f"{statement_id}: proved contract has {boundary_dependencies} "
            "prose-only or outside-boundary dependencies; use "
            "proved_with_boundaries"
        )
    if contract_status == "proved_with_boundaries" and not boundary_dependencies:
        errors.append(
            f"{statement_id}: proved_with_boundaries requires at least one "
            "prose-only or outside-boundary dependency"
        )
    for symbol in dict.fromkeys(checked_symbols):
        if not re.search(rf"\b{re.escape(symbol)}\b", block):
            errors.append(
                f"{statement_id}: contract block lacks disposition-derived "
                f"symbol {symbol}"
            )
    return errors


def check_manifest(
    path: Path,
    registry_terms: dict[str, dict],
    registry_labels: dict[str, str],
) -> list[str]:
    errors: list[str] = []
    known_terms = set(registry_terms)
    data = json.loads(path.read_text(encoding="utf-8"))
    base = path.parent
    markdown = base / data.get("markdown", "")
    formal = base / data.get("formal_shadow", "")
    formal_evidence = [base / item for item in data.get("formal_evidence", [])]

    schema_version = data.get("schema_version")
    if schema_version not in {1, 2}:
        errors.append(f"{path.name}: unsupported schema_version")
    if data.get("binding") is not False:
        errors.append(f"{path.name}: proposal manifest must remain nonbinding")
    status = data.get("status")
    if status not in ALLOWED_STATUSES:
        errors.append(f"{path.name}: unsupported lifecycle status {status}")
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
    contract_text = ""
    if schema_version == 2:
        contract_path = base / data.get("promotion_contracts", "")
        if not contract_path.is_file():
            errors.append(
                f"{path.name}: schema v2 requires an existing promotion_contracts file"
            )
        else:
            contract_text = contract_path.read_text(encoding="utf-8")

        declared_fields = {
            item.get("symbol")
            for item in data.get("semantic_fields", [])
            if isinstance(item, dict)
        }
        actual_fields = direct_prop_fields(formal.read_text(encoding="utf-8"))
        if declared_fields != actual_fields:
            errors.append(
                f"{path.name}: semantic field ledger drift; "
                f"missing {sorted(actual_fields - declared_fields)}, "
                f"extra {sorted(declared_fields - actual_fields)}"
            )
        for field in data.get("semantic_fields", []):
            if field.get("status") not in {"canonical", "derived", "local-gated"}:
                errors.append(
                    f"{path.name}: semantic field {field.get('symbol')} has invalid status"
                )
            if field.get("status") == "local-gated" and not field.get("gate"):
                errors.append(
                    f"{path.name}: local-gated semantic field "
                    f"{field.get('symbol')} requires a gate"
                )
    if "binding: false" not in markdown_text:
        errors.append(f"{markdown.name}: frontmatter must declare binding: false")
    if f"status: {status}" not in markdown_text:
        errors.append(f"{markdown.name}: frontmatter status does not match manifest")

    statements = data.get("statements", [])
    introduced_terms = set(data.get("introduced_terms", []))
    promoted_statement_terms = {
        item.get("id"): registry_labels[item.get("subject")]
        for item in statements
        if item.get("type") == "proposed_definition"
        and item.get("subject") in registry_labels
        and registry_labels[item.get("subject")] in introduced_terms
    }
    statement_ids = [item.get("id") for item in statements]
    duplicates = sorted({
        statement_id for statement_id in statement_ids
        if statement_ids.count(statement_id) > 1
    })
    for duplicate in duplicates:
        errors.append(f"{path.name}: duplicate statement ID {duplicate}")

    local_symbols = set(data.get("local_symbols", []))
    if not all(
        isinstance(term, str) and term.startswith("organon:")
        for term in introduced_terms
    ):
        errors.append(f"{path.name}: introduced_terms must contain organon identifiers")
    if status in {"partially-promoted", "promoted"}:
        missing_promotions = sorted(introduced_terms - known_terms)
        for term in missing_promotions:
            errors.append(
                f"{path.name}: lifecycle is {status} but registry lacks {term}"
            )
    baseline_terms = known_terms - introduced_terms
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
            if dependency in baseline_terms or dependency in local_symbols:
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

        if schema_version == 1:
            formal_symbol = item.get("formal_symbol")
            if formal_symbol and not re.search(
                rf"\b(?:structure|def|theorem|inductive)\s+{re.escape(formal_symbol)}\b",
                formal_text,
            ):
                errors.append(
                    f"{statement_id}: formal symbol {formal_symbol} not declared"
                )
        else:
            if "formal_symbol" in item:
                errors.append(
                    f"{statement_id}: schema v2 forbids declaration-only formal_symbol"
                )
            contract = item.get("formal_contract")
            if not isinstance(contract, dict):
                errors.append(f"{statement_id}: schema v2 requires formal_contract")
                seen.add(statement_id)
                continue
            contract_status = contract.get("status")
            if contract_status not in FORMAL_CONTRACT_STATUSES:
                errors.append(
                    f"{statement_id}: unsupported formal contract status "
                    f"{contract_status}"
                )
            allowed_statuses = {
                "proposed_definition": {"proved", "proved_with_boundaries"},
                "anti_collapse_constraint": {
                    "proved", "proved_with_boundaries", "outside_formal_boundary"
                },
                "open_formalization_gate": {"open_gate"},
                "open_evidence_gate": {"open_gate"},
            }.get(statement_type, set())
            if contract_status not in allowed_statuses:
                errors.append(
                    f"{statement_id}: {statement_type} cannot use "
                    f"formal status {contract_status}"
                )
            if contract_status in {"proved", "proved_with_boundaries"}:
                theorem = contract.get("theorem")
                block = promotion_contract_block(contract_text, statement_id)
                if block is None:
                    errors.append(
                        f"{statement_id}: expected one promotion-contract marker"
                    )
                elif not isinstance(theorem, str) or not re.search(
                    rf"\btheorem\s+{re.escape(theorem)}\b", block
                ):
                    errors.append(
                        f"{statement_id}: contract theorem {theorem} is absent "
                        f"from its marked block"
                    )
                else:
                    dependencies = item.get("depends_on", [])
                    errors.extend(check_dependency_dispositions(
                        statement_id, dependencies, contract, block,
                        contract_status,
                    ))
                    for shared_index in contract.get("shared_indices", []):
                        occurrences = len(re.findall(
                            rf"\b{re.escape(shared_index)}\b", block
                        ))
                        if occurrences < 2:
                            errors.append(
                                f"{statement_id}: shared index {shared_index} "
                                f"appears only {occurrences} time(s)"
                            )
            elif len(str(contract.get("reason", "")).strip()) < 20:
                errors.append(
                    f"{statement_id}: {contract_status} requires a substantive reason"
                )
        seen.add(statement_id)

    if status in {"partially-promoted", "promoted"}:
        for item in statements:
            statement_id = item.get("id")
            term_id = promoted_statement_terms.get(statement_id)
            if term_id is None:
                continue
            proposal_dependencies = {
                promoted_statement_terms.get(dependency, dependency)
                for dependency in item.get("depends_on", [])
                if promoted_statement_terms.get(dependency, dependency).startswith(
                    "organon:"
                )
            }
            binding_dependencies = set(registry_terms[term_id]["depends_on"])
            if proposal_dependencies != binding_dependencies:
                missing = sorted(binding_dependencies - proposal_dependencies)
                extra = sorted(proposal_dependencies - binding_dependencies)
                errors.append(
                    f"{statement_id}: promoted dependency drift for {term_id}; "
                    f"missing {missing}, extra {extra}"
                )

    markdown_pairs = set(MARKER.findall(markdown_text))
    for extra in sorted(markdown_pairs - manifest_pairs):
        errors.append(f"{markdown.name}: unregistered proposal marker {extra}")
    for missing in sorted(manifest_pairs - markdown_pairs):
        errors.append(f"{markdown.name}: missing proposal marker {missing}")

    return errors


def main() -> int:
    registry = json.loads(TERM_REGISTRY.read_text(encoding="utf-8"))
    registry_terms = {item["id"]: item for item in registry["terms"]}
    registry_labels = {item["label"]: item["id"] for item in registry["terms"]}
    manifests = sorted(PROPOSALS.glob("*-claims.json"))
    if not manifests:
        print("Proposal check failed: no statement manifests found")
        return 1

    errors: list[str] = []
    for manifest in manifests:
        errors.extend(
            check_manifest(manifest, registry_terms, registry_labels)
        )

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
