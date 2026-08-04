import importlib.util
import sys
from pathlib import Path

import pytest


ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location("organon_essay_eval", ROOT / "run.py")
assert SPEC and SPEC.loader
MODULE = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = MODULE
SPEC.loader.exec_module(MODULE)


def test_question_snapshot_is_exactly_ten_by_four():
    essays = MODULE.parse_questions((ROOT / "questions.md").read_text())
    assert len(essays) == 10
    assert sum(len(essay.questions) for essay in essays) == 40
    assert len({q.id for essay in essays for q in essay.questions}) == 40


def test_answer_validation_restores_question_order():
    essay = MODULE.EssayQuestions(
        title="Test",
        vault_path="Contexts/Essays/Works/test.md",
        questions=[
            MODULE.Question(id="AA-1", lens="Argument", question="One?", pressure_point="P1"),
            MODULE.Question(id="AA-2", lens="Evidence", question="Two?", pressure_point="P2"),
            MODULE.Question(id="AA-3", lens="Boundary", question="Three?", pressure_point="P3"),
            MODULE.Question(id="AA-4", lens="Definition", question="Four?", pressure_point="P4"),
        ],
    )
    answers = [
        MODULE.AnswerDraft(question_id=f"AA-{number}", disposition="open", answer="A", essay_anchors=[], limitation="L")
        for number in (4, 3, 2, 1)
    ]
    ordered = MODULE.validate_answers(essay, answers)
    assert [answer.question_id for answer in ordered] == ["AA-1", "AA-2", "AA-3", "AA-4"]


def test_answer_validation_rejects_missing_ids():
    essay = MODULE.EssayQuestions(
        title="Test",
        vault_path="Contexts/Essays/Works/test.md",
        questions=[
            MODULE.Question(id=f"AA-{number}", lens="Argument", question="Q", pressure_point="P")
            for number in range(1, 5)
        ],
    )
    answers = [
        MODULE.AnswerDraft(question_id=f"AA-{number}", disposition="open", answer="A", essay_anchors=[], limitation="L")
        for number in range(1, 4)
    ]
    with pytest.raises(ValueError, match="expected IDs"):
        MODULE.validate_answers(essay, answers)


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
            "short_form_sha256": "s",
            "questions_sha256": "q",
        },
        "essays": [
            {
                "title": "Essay",
                "vault_path": "Contexts/Essays/Works/Essay.md",
                "answers": [
                    {
                        "question_id": "AA-1",
                        "lens": "Evidence",
                        "disposition": "open",
                        "question": "A | B?",
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
