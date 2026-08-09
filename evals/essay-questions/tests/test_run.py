import importlib.util
import sys
from pathlib import Path

import pytest
from types import SimpleNamespace


ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location("organon_essay_eval", ROOT / "run.py")
assert SPEC and SPEC.loader
MODULE = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = MODULE
SPEC.loader.exec_module(MODULE)


def interlocutor():
    return MODULE.InterlocutorHypothesis(
        probable_background="A reader familiar with the example.",
        likely_purpose="Test whether the claim generalizes.",
        shared_vocabulary=["example"],
        possible_mistaken_premise="none identified",
        confidence="medium",
        question_evidence=["Does it generalize?"],
        stopping_condition="State the supported scope and its limitation.",
    )


def test_question_snapshot_is_exactly_ten_by_four():
    essays = MODULE.parse_questions((ROOT / "inputs" / "questions.md").read_text())
    assert len(essays) == 10
    assert sum(len(essay.questions) for essay in essays) == 40
    assert len({q.id for essay in essays for q in essay.questions}) == 40


def test_calibration_selects_one_question_per_essay():
    essays = MODULE.parse_questions((ROOT / "inputs" / "questions.md").read_text())
    selected, digest = MODULE.select_questions(
        essays, ROOT / "inputs" / "calibration.json"
    )
    assert len(selected) == 10
    assert sum(len(essay.questions) for essay in selected) == 10
    assert digest


def test_essay_path_is_confined_beneath_works_root(tmp_path):
    works = tmp_path / "Contexts" / "Essays" / "Works"
    works.mkdir(parents=True)
    safe = works / "Essay.md"
    safe.write_text("essay\n")
    outside = tmp_path / "outside.md"
    outside.write_text("outside\n")
    (works / "Escape.md").symlink_to(outside)

    assert MODULE.resolve_essay_path(tmp_path, "Essay.md") == safe
    with pytest.raises(ValueError, match="must be relative"):
        MODULE.resolve_essay_path(tmp_path, str(outside))
    with pytest.raises(ValueError, match="escapes"):
        MODULE.resolve_essay_path(tmp_path, "../outside.md")
    with pytest.raises(ValueError, match="escapes"):
        MODULE.resolve_essay_path(tmp_path, "Escape.md")


def test_answer_validation_restores_question_order():
    essay = MODULE.EssayQuestions(
        title="Test",
        essay_file="test.md",
        questions=[
            MODULE.Question(id="AA-1", lens="Argument", question="One?", pressure_point="P1"),
            MODULE.Question(id="AA-2", lens="Evidence", question="Two?", pressure_point="P2"),
            MODULE.Question(id="AA-3", lens="Boundary", question="Three?", pressure_point="P3"),
            MODULE.Question(id="AA-4", lens="Definition", question="Four?", pressure_point="P4"),
        ],
    )
    answers = [
        MODULE.AnswerDraft(question_id=f"AA-{number}", disposition="open", interlocutor=interlocutor(), answer="A", essay_anchors=[], limitation="L")
        for number in (4, 3, 2, 1)
    ]
    ordered = MODULE.validate_answers(essay, answers)
    assert [answer.question_id for answer in ordered] == ["AA-1", "AA-2", "AA-3", "AA-4"]


def test_answer_validation_rejects_missing_ids():
    essay = MODULE.EssayQuestions(
        title="Test",
        essay_file="test.md",
        questions=[
            MODULE.Question(id=f"AA-{number}", lens="Argument", question="Q", pressure_point="P")
            for number in range(1, 5)
        ],
    )
    answers = [
        MODULE.AnswerDraft(question_id=f"AA-{number}", disposition="open", interlocutor=interlocutor(), answer="A", essay_anchors=[], limitation="L")
        for number in range(1, 4)
    ]
    with pytest.raises(ValueError, match="expected IDs"):
        MODULE.validate_answers(essay, answers)


def test_generation_retries_incomplete_structured_response():
    essay = MODULE.EssayQuestions(
        title="Test",
        essay_file="test.md",
        questions=[
            MODULE.Question(id="AA-1", lens="Argument", question="One?", pressure_point="P")
        ],
    )
    calls = []

    def program(**kwargs):
        calls.append(kwargs["retry_instruction"])
        if len(calls) == 1:
            raise ValueError("incomplete")
        return SimpleNamespace(answers=[
            MODULE.AnswerDraft(
                question_id="AA-1", disposition="open", interlocutor=interlocutor(),
                answer="The essay leaves this question open. Another case is required.",
                essay_anchors=["Example"], limitation="No second case.",
            )
        ])

    answers = MODULE.generate_with_retry(program, essay_set=essay, ontology="o")
    assert answers[0].question_id == "AA-1"
    assert calls == ["", calls[1]]
    assert "prior response" in calls[1]


def test_markdown_projection_escapes_cells():
    result = {
        "run": {
            "model": "gpt-5.6-luna",
            "reasoning_effort": "medium",
            "dspy_version": "3.3.0",
            "litellm_version": "1.91.4",
            "python_version": "3.12.9",
            "generated_at": "2026-08-04T00:00:00+00:00",
            "complete": True,
            "essay_count": 1,
            "question_count": 1,
            "organon_commit": "abc",
            "ontology_sha256": "o",
            "answer_form_sha256": "a",
            "questions_sha256": "q",
            "selection_sha256": None,
        },
        "essays": [
            {
                "title": "Essay",
                "essay_file": "Essay.md",
                "answers": [
                    {
                        "question_id": "AA-1",
                        "lens": "Evidence",
                        "disposition": "open",
                        "question": "A | B?",
                        "interlocutor": {
                            "probable_background": "A reader.",
                            "likely_purpose": "Test the claim.",
                            "confidence": "low",
                        },
                        "answer": "First line.\nSecond line.",
                        "essay_anchors": ["Part | One"],
                        "limitation": "Unknown.",
                    }
                ],
            }
        ],
    }
    markdown = MODULE.render_markdown(result)
    assert "A \\| B?" in markdown
    assert "First line. Second line." in markdown
    assert "OPENAI_API_KEY" not in markdown


def test_run_workspace_preserves_dotted_model_name(tmp_path):
    result = {
        "run": {
            "model": "gpt-5.6-luna",
            "reasoning_effort": "medium",
            "dspy_version": "3.3.0",
            "litellm_version": "1.91.4",
            "python_version": "3.12.9",
            "generated_at": "2026-08-04T00:00:00+00:00",
            "complete": True,
            "essay_count": 0,
            "question_count": 0,
            "organon_commit": "abc",
            "ontology_sha256": "o",
            "answer_form_sha256": "a",
            "questions_sha256": "q",
            "selection_sha256": None,
        },
        "essays": [],
    }
    run_dir = tmp_path / "gpt-5.6-luna-2026-08-04"
    MODULE.write_artifacts(result, run_dir)
    assert (run_dir / "candidate.json").is_file()
    assert (run_dir / "candidate.md").is_file()
