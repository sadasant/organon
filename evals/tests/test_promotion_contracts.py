from __future__ import annotations

import importlib.util
import json
import subprocess
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
    manifests = [
        ROOT / "proposals" / "embodied-consciousness-claims.json",
        ROOT / "proposals" / "attention-love-care-claims.json",
    ]
    for manifest in manifests:
        assert REVIEWS.check_review(manifest) == []


def test_review_requires_and_checks_every_formal_evidence_pin(tmp_path, monkeypatch) -> None:
    monkeypatch.setattr(REVIEWS, "ROOT", tmp_path)
    manifest = {
        "schema_version": 2,
        "proposal_id": "example",
        "status": "partially-promoted",
        "markdown": "example.md",
        "formal_shadow": "Shadow.lean",
        "formal_evidence": ["First.lean", "Second.lean"],
        "promotion_contracts": "Contracts.lean",
        "promotion_review": "review.json",
        "statements": [],
    }
    sources = [
        "claims.json", "example.md", "Shadow.lean", "Contracts.lean",
        "First.lean", "Second.lean", "scripts/check-proposals.py",
        "scripts/check-promotion-review.py",
    ]
    for relative in sources:
        path = tmp_path / relative
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(json.dumps(manifest) if relative == "claims.json" else relative)

    def git(*args):
        return subprocess.check_output(
            ["git", *args], cwd=tmp_path, text=True, stderr=subprocess.DEVNULL
        ).strip()

    git("init")
    git("add", ".")
    git("-c", "user.name=Test", "-c", "user.email=test@example.org",
        "-c", "commit.gpgsign=false", "commit", "-m", "Reviewed sources")
    pins = {relative: REVIEWS.digest(tmp_path / relative) for relative in sources}
    review = {
        "schema_version": 1,
        "proposal_id": "example",
        "status": "promotion-ready",
        "reviewed_commit": git("rev-parse", "HEAD"),
        "reviewed_tree": git("rev-parse", "HEAD^{tree}"),
        "source_sha256": pins.copy(),
        "verified_contracts": [],
        "findings": [{"id": "R1", "disposition": "resolved",
                      "resolution": "All declared evidence sources were reviewed."}],
    }
    review_path = tmp_path / "review.json"
    manifest_path = tmp_path / "claims.json"
    review_path.write_text(json.dumps(review))
    assert REVIEWS.check_review(manifest_path) == []

    del review["source_sha256"]["Second.lean"]
    review_path.write_text(json.dumps(review))
    assert any("missing required source pins ['Second.lean']" in error
               for error in REVIEWS.check_review(manifest_path))

    review["source_sha256"] = pins
    review_path.write_text(json.dumps(review))
    (tmp_path / "Second.lean").write_text("Changed proof")
    assert any("reviewed source drift for Second.lean" in error
               for error in REVIEWS.check_review(manifest_path))
