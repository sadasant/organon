from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]


def load_script(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


PROPOSALS = load_script(
    "organon_check_proposals", ROOT / "scripts" / "check-proposals.py"
)
REVIEWS = load_script(
    "organon_check_promotion_review",
    ROOT / "scripts" / "check-promotion-review.py",
)


def test_schema_v2_contracts_bind_statements_to_marked_theorems() -> None:
    manifest = ROOT / "proposals" / "embodied-consciousness-claims.json"
    registry = json.loads((ROOT / "ontology" / "terms.yaml").read_text())
    terms = {item["id"]: item for item in registry["terms"]}
    labels = {item["label"]: item["id"] for item in registry["terms"]}
    assert PROPOSALS.check_manifest(manifest, terms, labels) == []


def test_semantic_field_scanner_detects_multiline_prop_relations() -> None:
    source = """structure Example where
  ordinary : Nat
  hiddenBridge :
    Nat →
      Bool → Prop
"""
    assert PROPOSALS.direct_prop_fields(source) == {"Example.hiddenBridge"}


def test_proved_contract_rejects_an_unaccounted_dependency() -> None:
    errors = PROPOSALS.check_dependency_dispositions(
        "EX-D1",
        ["organon:Model", "organon:Memory"],
        {
            "subject_symbols": ["Example"],
            "dependency_dispositions": {
                "organon:Model": {
                    "status": "formalized",
                    "symbols": ["model"],
                }
            },
        },
        "theorem Example (model : Nat) : True := by trivial",
        "proved",
    )
    assert any("missing ['organon:Memory']" in error for error in errors)


def test_proved_contract_derives_symbols_from_dependency_dispositions() -> None:
    errors = PROPOSALS.check_dependency_dispositions(
        "EX-D2",
        ["organon:Perception"],
        {
            "subject_symbols": ["Example"],
            "dependency_dispositions": {
                "organon:Perception": {
                    "status": "represented_by",
                    "symbols": ["perception"],
                    "reason": "The local projection names the exact joined object.",
                }
            },
        },
        "theorem Example : True := by trivial",
        "proved",
    )
    assert errors == [
        "EX-D2: contract block lacks disposition-derived symbol perception"
    ]


def test_unformalized_dependency_forces_boundary_qualified_status() -> None:
    contract = {
        "subject_symbols": ["Example"],
        "dependency_dispositions": {
            "organon:Action": {
                "status": "outside_formal_boundary",
                "reason": "The reduct has no canonical Action negation for this claim.",
            }
        },
    }
    block = "theorem Example : True := by trivial"
    errors = PROPOSALS.check_dependency_dispositions(
        "EX-D3", ["organon:Action"], contract, block, "proved"
    )
    assert any("use proved_with_boundaries" in error for error in errors)
    assert PROPOSALS.check_dependency_dispositions(
        "EX-D3", ["organon:Action"], contract, block,
        "proved_with_boundaries",
    ) == []


def test_promoted_schema_v2_manifest_has_exact_source_review() -> None:
    manifest = ROOT / "proposals" / "embodied-consciousness-claims.json"
    assert REVIEWS.check_review(manifest) == []
