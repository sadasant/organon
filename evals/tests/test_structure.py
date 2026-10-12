from __future__ import annotations

import importlib.util
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


STRUCTURE = load_script("organon_check_structure", ROOT / "scripts" / "check-structure.py")


def test_repository_structure_contract_passes() -> None:
    assert STRUCTURE.check_repository() == []


def test_numbered_sync_sibling_is_rejected() -> None:
    errors = STRUCTURE.check_portable_paths(["ontology/ontology 2.md"])
    assert errors == ["ontology/ontology 2.md: sync-style numbered sibling"]


def test_reserved_filename_is_rejected() -> None:
    errors = STRUCTURE.check_portable_paths(["notes/CON.md"])
    assert errors == ["notes/CON.md: Windows reserved device name"]


def test_only_a_passed_evaluation_must_cover_the_current_ontology(tmp_path, monkeypatch) -> None:
    import json

    manifest = tmp_path / "prompt-manifest.json"
    manifest.write_text(json.dumps({
        "ontology_version": "0.20.0",
        "sources_sha256": {"ontology/ontology.md": "current"},
    }))
    suite = tmp_path / "evals" / "example"
    for run in ("results/now", "results/before"):
        (suite / run).mkdir(parents=True)
        (suite / run / "report.md").write_text("report")
        (suite / run / "run.json").write_text(
            json.dumps({"run": {"complete": True, "passed": True, "ontology_sha256": "older"}})
        )
    pointer = {
        "schema_version": 1,
        "suite": "example",
        "current_run": "results/now",
        "predecessor": "results/before",
        "run_record": "run.json",
        "primary_artifact": "report.md",
        "evaluation_status": "passed",
        "promotion_status": "hold",
        "ontology_version": "0.20.0",
        "ontology_sha256": "older",
    }
    (suite / "current.json").write_text(json.dumps(pointer))
    monkeypatch.setattr(STRUCTURE, "ROOT", tmp_path)
    monkeypatch.setattr(STRUCTURE, "PROMPT_MANIFEST", manifest)
    monkeypatch.setattr(STRUCTURE, "EVAL_SUITES", ("example",))
    assert any("must cover the current ontology" in error
               for error in STRUCTURE.check_current_evaluations())

    pointer["evaluation_status"] = "incomplete"
    (suite / "current.json").write_text(json.dumps(pointer))
    (suite / "results/now/run.json").write_text(
        json.dumps({"run": {"complete": True, "passed": False, "ontology_sha256": "older"}})
    )
    assert STRUCTURE.check_current_evaluations() == []
