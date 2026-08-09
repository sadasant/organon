import importlib.util
import sys
from argparse import Namespace
from pathlib import Path

import pytest


ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location("organon_essay_compare", ROOT / "compare.py")
assert SPEC and SPEC.loader
MODULE = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = MODULE
SPEC.loader.exec_module(MODULE)


def test_sentence_count_handles_bounded_answer():
    assert MODULE.sentence_count("One sentence. Another sentence.") == 2


def test_indexes_answers_by_question_id():
    result = {
        "essays": [{
            "title": "Essay",
            "answers": [{"question_id": "AA-1", "answer": "Answer."}],
        }]
    }
    assert MODULE.index_answers(result)["AA-1"][1]["answer"] == "Answer."


def test_evaluation_must_bind_exact_candidate_name_and_bytes(tmp_path):
    candidate = tmp_path / "candidate.json"
    candidate.write_text('{"essays": []}\n')
    evaluation = {
        "run": {
            "source_result": candidate.name,
            "source_result_sha256": MODULE.sha256_path(candidate),
        }
    }
    MODULE.validate_evaluation_candidate(evaluation, candidate)

    evaluation["run"]["source_result"] = "other.json"
    with pytest.raises(ValueError, match="name"):
        MODULE.validate_evaluation_candidate(evaluation, candidate)
    evaluation["run"]["source_result"] = candidate.name
    evaluation["run"]["source_result_sha256"] = "0" * 64
    with pytest.raises(ValueError, match="digest"):
        MODULE.validate_evaluation_candidate(evaluation, candidate)


def test_comparison_records_cross_version_scope(tmp_path):
    baseline_path = tmp_path / "baseline.json"
    candidate_path = tmp_path / "candidate.json"
    evaluation_path = tmp_path / "evaluation.json"
    answer = {
        "question_id": "AA-1",
        "question": "Question?",
        "answer": "Answer.",
        "interlocutor": {
            "confidence": "low",
            "probable_background": "Reader.",
            "likely_purpose": "Test.",
            "question_evidence": ["Question"],
            "stopping_condition": "Answer.",
        },
    }
    baseline = {
        "run": {"ontology_sha256": "a" * 64},
        "essays": [{"title": "Essay", "essay_file": "essay.md", "answers": [answer]}],
    }
    candidate = {
        "run": {"ontology_sha256": "b" * 64},
        "essays": [{"title": "Essay", "essay_file": "essay.md", "answers": [answer]}],
    }
    baseline_path.write_text("{}\n")
    candidate_path.write_text("{}\n")
    evaluation = {
        "run": {
            "source_result": candidate_path.name,
            "source_result_sha256": MODULE.sha256_path(candidate_path),
        },
        "essays": [{
            "judgments": [{
                "question_id": "AA-1",
                "passed": True,
                "ontology": {"term_fidelity": 4, "critical_violations": [], "evidence": "", "revision": ""},
                "editorial": {"responsiveness": 4, "critical_violations": [], "evidence": "", "revision": ""},
            }],
        }],
    }
    evaluation_path.write_text("{}\n")
    result = MODULE.build_comparison(
        baseline,
        candidate,
        evaluation,
        Namespace(
            baseline=baseline_path,
            candidate=candidate_path,
            evaluation=evaluation_path,
        ),
    )
    assert result["run"]["same_ontology"] is False
    assert "cross-version historical contrast" in MODULE.render(result)
