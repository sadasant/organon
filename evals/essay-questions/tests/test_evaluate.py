import importlib.util
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location(
    "organon_essay_judges", ROOT / "evaluate.py"
)
assert SPEC and SPEC.loader
MODULE = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = MODULE
SPEC.loader.exec_module(MODULE)


def sample_answer() -> dict:
    return {
        "question_id": "AA-1",
        "disposition": "partly_answered",
        "interlocutor": {
            "probable_background": "A reader testing whether one example generalizes.",
            "likely_purpose": "Determine the supported scope.",
            "shared_vocabulary": ["mechanism", "generalize"],
            "possible_mistaken_premise": "One example may be treated as a general proof.",
            "confidence": "high",
            "question_evidence": ["Does the mechanism generalize?"],
            "stopping_condition": "State the example's scope and what further case is needed.",
        },
        "answer": (
            "The essay names the mechanism and the actor responsible for it, "
            "but stops before proving that the mechanism is general. The answer "
            "therefore remains bounded by the supplied example and does not turn "
            "the ontology into factual evidence. A stronger answer would require "
            "another case observed under the same declared scope and rule."
        ),
        "essay_anchors": ["The mechanism"],
        "limitation": "No external case is supplied.",
        "question": "Does the mechanism generalize?",
        "pressure_point": "One example may be insufficient.",
    }


def test_deterministic_checks_accept_complete_bounded_answer():
    result = MODULE.deterministic_checks(sample_answer())
    assert result["passed"]
    assert result["checks"]["has_locatable_anchor"]


def test_judge_gate_requires_every_score_and_no_critical_violation():
    passing = {
        "question_id": "AA-1",
        "term_fidelity": 3,
        "anti_collapse_discipline": 4,
        "epistemic_discipline": 3,
        "source_grounding": 3,
        "critical_violations": [],
        "evidence": "Exact.",
        "revision": "",
    }
    assert MODULE.judgment_passed(passing)
    passing["source_grounding"] = 2
    assert not MODULE.judgment_passed(passing)


def test_markdown_reports_gate_without_private_paths():
    result = {
        "run": {
            "judge_model": "gpt-5.6-luna",
            "generated_at": "2026-08-04T00:00:00+00:00",
            "complete": True,
            "passed": True,
            "question_count": 1,
            "passed_count": 1,
            "revision_count": 0,
            "source_result": "result.json",
            "source_result_sha256": "r",
            "judge_reasoning_effort": "high",
            "ontology_sha256": "o",
            "answer_form_sha256": "a",
        },
        "essays": [{
            "title": "Essay",
            "essay_file": "Essay.md",
            "judgments": [{
                "question_id": "AA-1",
                "passed": True,
                "deterministic": {"passed": True},
                "ontology": {
                    "question_id": "AA-1",
                    "term_fidelity": 3,
                    "anti_collapse_discipline": 3,
                    "epistemic_discipline": 3,
                    "source_grounding": 3,
                    "critical_violations": [],
                    "evidence": "Bounded.",
                    "revision": "",
                },
                "editorial": {
                    "question_id": "AA-1",
                    "responsiveness": 3,
                    "interlocutor_fit": 3,
                    "proportionality": 3,
                    "necessary_bridge": 3,
                    "epistemic_boundary": 3,
                    "stopping_discipline": 3,
                    "critical_violations": [],
                    "evidence": "Clear.",
                    "revision": "",
                },
            }],
        }],
    }
    markdown = MODULE.render_markdown(result)
    assert "1 pass / 0 revise" in markdown
    assert "/Users/" not in markdown


def test_reuse_requires_same_answer_and_same_essay_snapshot():
    answer = sample_answer()
    digest = MODULE.canonical_digest(answer)
    assert MODULE.can_reuse_judgment(answer, "essay-a", digest, "essay-a")
    assert not MODULE.can_reuse_judgment(answer, "essay-b", digest, "essay-a")
    changed = dict(answer, answer=answer["answer"] + " Changed.")
    assert not MODULE.can_reuse_judgment(changed, "essay-a", digest, "essay-a")
