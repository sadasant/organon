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


def test_promoted_schema_v2_manifest_has_exact_source_review() -> None:
    manifest = ROOT / "proposals" / "embodied-consciousness-claims.json"
    assert REVIEWS.check_review(manifest) == []
