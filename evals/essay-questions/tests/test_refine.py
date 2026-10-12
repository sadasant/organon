import importlib.util
import json
import sys
from pathlib import Path

import pytest


ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location("organon_essay_refine", ROOT / "refine.py")
assert SPEC and SPEC.loader
MODULE = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = MODULE
SPEC.loader.exec_module(MODULE)


def test_merge_revisions_preserves_passing_answers_and_order():
    original = [
        {"question_id": "AA-1", "answer": "keep"},
        {"question_id": "AA-2", "answer": "replace"},
        {"question_id": "AA-3", "answer": "keep too"},
    ]
    revised = [{"question_id": "AA-2", "answer": "revised"}]
    merged = MODULE.merge_revisions(original, revised, ["AA-2"])
    assert [item["question_id"] for item in merged] == ["AA-1", "AA-2", "AA-3"]
    assert [item["answer"] for item in merged] == ["keep", "revised", "keep too"]


def test_merge_revisions_rejects_unrequested_id():
    with pytest.raises(ValueError, match="Expected revised IDs"):
        MODULE.merge_revisions(
            [{"question_id": "AA-1", "answer": "a"}],
            [{"question_id": "AA-2", "answer": "b"}],
            ["AA-1"],
        )


def test_refinement_rejects_inputs_that_did_not_generate_the_answers(tmp_path, monkeypatch):
    ontology = tmp_path / "ontology.md"
    answer_form = tmp_path / "answer-form.md"
    ontology.write_text("revised ontology")
    answer_form.write_text("form")
    source = tmp_path / "candidate.json"
    source.write_text(json.dumps({"run": {
        "ontology_sha256": MODULE.sha256_text("original ontology"),
        "answer_form_sha256": MODULE.sha256_text("form"),
    }}))
    evaluation = tmp_path / "evaluation.json"
    evaluation.write_text(json.dumps({"run": {"source_result_sha256": MODULE.sha256_path(source)}}))
    monkeypatch.setenv("OPENAI_API_KEY", "test")
    monkeypatch.setattr(sys, "argv", [
        "refine.py", "--source-result", str(source), "--evaluation", str(evaluation),
        "--vault-root", str(tmp_path), "--ontology", str(ontology),
        "--answer-form", str(answer_form), "--run-dir", str(tmp_path / "run"),
    ])
    with pytest.raises(SystemExit, match="ontology digest does not match"):
        MODULE.main()
    assert not (tmp_path / "run").exists()
