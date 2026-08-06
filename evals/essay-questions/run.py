#!/usr/bin/env python3
"""Run the Organon-guided DSPy essay-question evaluation."""

from __future__ import annotations

import argparse
import importlib.metadata
import json
import os
import platform
import re
import sys
from datetime import UTC, datetime
from pathlib import Path
from typing import Literal

import dspy
from pydantic import BaseModel, Field


ROOT = Path(__file__).resolve().parents[2]
EVAL_ROOT = Path(__file__).resolve().parent
EVALS_ROOT = EVAL_ROOT.parent
if str(EVALS_ROOT) not in sys.path:
    sys.path.insert(0, str(EVALS_ROOT))

from core import METHODOLOGY_VERSION
from core.contracts import (
    committed_input_manifest,
    git_head,
    methodology_inputs,
    read_text,
    resolve_within,
    sha256_text,
)
from core.judging import escape_cell
from core.workspace import RunWorkspace, write_projection

DEFAULT_QUESTIONS = EVAL_ROOT / "inputs" / "questions.md"
DEFAULT_ONTOLOGY = ROOT / "ontology" / "ontology.md"
DEFAULT_ANSWER_FORM = ROOT / "editorial" / "essay-answer-form.md"

ESSAY_HEADING = re.compile(r"^### (?P<title>.+)$")
ESSAY_FILE = re.compile(r"^<!-- essay-file: (?P<path>[^>]+) -->$")
QUESTION_ROW = re.compile(
    r"^\| (?P<id>[A-Z]{2}-\d+) \| (?P<lens>[^|]+?) \| "
    r"(?P<question>[^|]+?) \| (?P<pressure>[^|]+?) \|$"
)


class Question(BaseModel):
    id: str
    lens: str
    question: str
    pressure_point: str


class EssayQuestions(BaseModel):
    title: str
    essay_file: str
    questions: list[Question]


class InterlocutorHypothesis(BaseModel):
    probable_background: str = Field(
        description="The thinnest reader background supported by the question."
    )
    likely_purpose: str = Field(
        description="What the reader appears to be testing, deciding, or resisting."
    )
    shared_vocabulary: list[str] = Field(
        description="Terms the question itself makes safe to treat as shared."
    )
    possible_mistaken_premise: str = Field(
        description="A premise that may need repair, or 'none identified'."
    )
    confidence: Literal["low", "medium", "high"]
    question_evidence: list[str] = Field(
        description="Short phrases or features from the question supporting the hypothesis."
    )
    stopping_condition: str = Field(
        description="What would discharge this question's present pressure."
    )


class AnswerDraft(BaseModel):
    question_id: str = Field(description="Exact question ID supplied in the input.")
    disposition: Literal["answered", "partly_answered", "inferable", "open", "misframed"]
    interlocutor: InterlocutorHypothesis
    answer: str = Field(
        description="A 35 to 90 word direct answer in two to four sentences; the ceiling is not a target."
    )
    essay_anchors: list[str] = Field(
        description="Section headings or brief location descriptions from the essay."
    )
    limitation: str = Field(
        description="What remains unsupported, ambiguous, or outside the essay."
    )


class AnswerEssayQuestions(dspy.Signature):
    """Answer reader questions from the essay without inventing Daniel's position.

    First construct the thinnest interlocutor hypothesis supported by each
    question's words, lens, and pressure point. Do not invent biography, motive,
    status, or hostility. Then answer through the proposed Essay-Answer Form.
    Treat the ontology as binding vocabulary and anti-collapse discipline, not as
    evidence that the essay's factual claims are true and not as vocabulary that
    must be exhaustively rendered. State the answer early, supply only the bridge
    this reader needs, mark the epistemic boundary, and stop when the question's
    pressure is discharged. Keep the visible answer between 35 and 90 words in
    two to four sentences. Put anticipated follow-ups in metadata, not the answer.
    Use only anchors a reader can locate in the essay.
    Return exactly one answer for every supplied question ID and no others.
    """

    ontology: str = dspy.InputField(
        description="Complete binding Organon ontology in Markdown."
    )
    answer_form: str = dspy.InputField(
        description="Complete proposed Essay-Answer Form editorial instrument."
    )
    essay_title: str = dspy.InputField()
    essay: str = dspy.InputField(description="Complete canonical essay Markdown.")
    questions: list[Question] = dspy.InputField()
    retry_instruction: str = dspy.InputField(
        description="Empty on the first attempt; schema-repair instruction on retries."
    )
    answers: list[AnswerDraft] = dspy.OutputField()


def display_path(path: Path) -> str:
    try:
        return str(path.resolve().relative_to(ROOT.resolve()))
    except ValueError:
        return str(path.resolve())


def parse_questions(markdown: str) -> list[EssayQuestions]:
    essays: list[EssayQuestions] = []
    current: EssayQuestions | None = None

    for line in markdown.splitlines():
        heading = ESSAY_HEADING.match(line)
        if heading:
            current = EssayQuestions(
                title=heading.group("title"),
                essay_file="",
                questions=[],
            )
            essays.append(current)
            continue

        essay_file = ESSAY_FILE.match(line)
        if essay_file and current is not None:
            current.essay_file = essay_file.group("path").strip()
            continue

        row = QUESTION_ROW.match(line)
        if row and current is not None:
            current.questions.append(
                Question(
                    id=row.group("id"),
                    lens=row.group("lens").strip(),
                    question=row.group("question").strip(),
                    pressure_point=row.group("pressure").strip(),
                )
            )

    if len(essays) != 10:
        raise ValueError(f"Expected 10 essays, found {len(essays)}")
    if any(len(essay.questions) != 4 for essay in essays):
        counts = {essay.title: len(essay.questions) for essay in essays}
        raise ValueError(f"Expected four questions per essay: {counts}")
    if any(not essay.essay_file or not essay.essay_file.endswith(".md") for essay in essays):
        raise ValueError("Every essay requires one relative Markdown essay-file selector")
    if any(
        Path(essay.essay_file).is_absolute() or ".." in Path(essay.essay_file).parts
        for essay in essays
    ):
        raise ValueError("Essay-file selectors must remain beneath the canonical Works root")
    ids = [question.id for essay in essays for question in essay.questions]
    if len(ids) != 40 or len(ids) != len(set(ids)):
        raise ValueError("Question IDs must be exactly 40 unique values")
    return essays


def validate_answers(
    essay: EssayQuestions, answers: list[AnswerDraft]
) -> list[AnswerDraft]:
    expected = [question.id for question in essay.questions]
    actual = [answer.question_id for answer in answers]
    if len(actual) != len(set(actual)):
        raise ValueError(f"{essay.title}: model duplicated a question ID")
    if set(actual) != set(expected):
        raise ValueError(
            f"{essay.title}: expected IDs {expected}, received IDs {actual}"
        )
    by_id = {answer.question_id: answer for answer in answers}
    return [by_id[question_id] for question_id in expected]


def generate_with_retry(program, *, essay_set: EssayQuestions, **kwargs) -> list[AnswerDraft]:
    last_error: Exception | None = None
    for attempt in range(3):
        try:
            prediction = program(
                questions=essay_set.questions,
                retry_instruction=(
                    "" if attempt == 0 else
                    "The prior response was incomplete or invalid. Return exactly one "
                    "complete AnswerDraft for every supplied question ID. Every answer "
                    "must include all interlocutor fields, answer, essay_anchors, and limitation."
                ),
                **kwargs,
            )
            return validate_answers(essay_set, prediction.answers)
        except Exception as error:
            last_error = error
    assert last_error is not None
    raise last_error


def select_questions(
    essays: list[EssayQuestions], selection_path: Path | None
) -> tuple[list[EssayQuestions], str | None]:
    if selection_path is None:
        return essays, None
    selection_text = read_text(selection_path)
    selected_ids = json.loads(selection_text)["question_ids"]
    if not selected_ids or len(selected_ids) != len(set(selected_ids)):
        raise ValueError("Selection requires unique question IDs")
    known_ids = {question.id for essay in essays for question in essay.questions}
    unknown = set(selected_ids) - known_ids
    if unknown:
        raise ValueError(f"Selection contains unknown question IDs: {sorted(unknown)}")
    wanted = set(selected_ids)
    selected = []
    for essay in essays:
        questions = [question for question in essay.questions if question.id in wanted]
        if questions:
            selected.append(essay.model_copy(update={"questions": questions}))
    return selected, sha256_text(selection_text)


def resolve_essay_path(vault_root: Path, selector: str) -> Path:
    works_root = vault_root / "Contexts" / "Essays" / "Works"
    return resolve_within(works_root, selector, label="essay-file selector")


def render_markdown(result: dict, obsidian_links: bool = False) -> str:
    metadata = result["run"]
    lines = [
        "---",
        "type: organon-evaluation",
        "evaluation: essay-questions",
        f"model: {metadata['model']}",
        f"reasoning_effort: {metadata['reasoning_effort']}",
        f"generated_at: {metadata['generated_at']}",
        f"complete: {str(metadata['complete']).lower()}",
        f"essay_count: {metadata['essay_count']}",
        f"question_count: {metadata['question_count']}",
        "---",
        "",
        "# Essay-question evaluation",
        "",
        "> [!summary]",
        f"> `{escape_cell(metadata['model'])}` answered {metadata['question_count']} reader questions across {metadata['essay_count']} essays with the complete binding ontology and proposed Essay-Answer Form in context. Each answer records a provisional interlocutor hypothesis. These are generated answers, not Daniel-authored positions or binding Organon Claims.",
        "",
        "## Run",
        "",
        "| Field | Value |",
        "|---|---|",
        f"| Model | `{escape_cell(metadata['model'])}` |",
        f"| Reasoning effort | `{escape_cell(metadata['reasoning_effort'])}` |",
        f"| DSPy | `{escape_cell(metadata['dspy_version'])}` |",
        f"| LiteLLM | `{escape_cell(metadata['litellm_version'])}` |",
        f"| Python | `{escape_cell(metadata['python_version'])}` |",
        f"| Generated | {escape_cell(metadata['generated_at'])} |",
        f"| Organon commit | `{escape_cell(metadata['organon_commit'])}` |",
        f"| Ontology SHA-256 | `{metadata['ontology_sha256']}` |",
        f"| Essay-Answer Form SHA-256 | `{metadata['answer_form_sha256']}` |",
        f"| Questions SHA-256 | `{metadata['questions_sha256']}` |",
        f"| Selection SHA-256 | `{metadata['selection_sha256'] or 'complete-set'}` |",
        "",
        "## Answers",
        "",
        "| Essay | ID | Lens | Disposition | Question | Interlocutor hypothesis | Answer | Essay anchors | Limitation |",
        "|---|---|---|---|---|---|---|---|---|",
    ]

    for essay in result["essays"]:
        if obsidian_links:
            note = f"Contexts/Essays/Works/{essay['essay_file'][:-3]}"
            essay_label = f"[[{note}|{essay['title']}]]"
        else:
            essay_label = essay["title"]
        for item in essay["answers"]:
            lines.append(
                "| "
                + " | ".join(
                    [
                        escape_cell(essay_label),
                        escape_cell(item["question_id"]),
                        escape_cell(item["lens"]),
                        escape_cell(item["disposition"]),
                        escape_cell(item["question"]),
                        escape_cell(
                            f"{item['interlocutor']['probable_background']} "
                            f"Purpose: {item['interlocutor']['likely_purpose']} "
                            f"Confidence: {item['interlocutor']['confidence']}."
                        ),
                        escape_cell(item["answer"]),
                        escape_cell("; ".join(item["essay_anchors"])),
                        escape_cell(item["limitation"]),
                    ]
                )
                + " |"
            )

    lines.extend(
        [
            "",
            "## Canonicality boundary",
            "",
            "The JSON artifact is the machine-readable run record. This table is its human-readable projection. Answers classify one model response under one exact prompt and source snapshot. They do not revise the essays, answer on Daniel's behalf, or establish the Truth of any Claim.",
            "",
        ]
    )
    return "\n".join(lines)


def write_artifacts(result: dict, run_dir: Path) -> None:
    workspace = RunWorkspace(run_dir)
    workspace.write_json("candidate.json", result)
    workspace.write_text("candidate.md", render_markdown(result))


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--vault-root",
        type=Path,
        default=Path(os.environ["PARERGON_VAULT"])
        if os.environ.get("PARERGON_VAULT")
        else None,
    )
    parser.add_argument("--questions", type=Path, default=DEFAULT_QUESTIONS)
    parser.add_argument("--ontology", type=Path, default=DEFAULT_ONTOLOGY)
    parser.add_argument("--answer-form", type=Path, default=DEFAULT_ANSWER_FORM)
    parser.add_argument(
        "--selection", type=Path,
        help="Optional JSON file containing a unique question_ids calibration subset.",
    )
    parser.add_argument(
        "--model", default=os.environ.get("OPENAI_MODEL", "gpt-5.6-luna")
    )
    parser.add_argument(
        "--reasoning-effort",
        default=os.environ.get("OPENAI_REASONING_EFFORT", "medium"),
        choices=["none", "low", "medium", "high", "xhigh", "max"],
    )
    parser.add_argument("--max-tokens", type=int, default=5000)
    parser.add_argument("--run-dir", type=Path, required=True)
    parser.add_argument("--obsidian-output", type=Path)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    if not os.environ.get("OPENAI_API_KEY"):
        raise SystemExit("OPENAI_API_KEY is required and is never written by this runner")
    if not args.vault_root or not args.vault_root.is_dir():
        raise SystemExit("--vault-root or PARERGON_VAULT must name the Parergon vault")

    questions_text = read_text(args.questions)
    ontology = read_text(args.ontology)
    answer_form = read_text(args.answer_form)
    control_inputs = methodology_inputs(EVALS_ROOT) + [
        Path(__file__), args.questions, args.ontology, args.answer_form
    ]
    if args.selection:
        control_inputs.append(args.selection)
    input_manifest = committed_input_manifest(ROOT, control_inputs)
    essay_sets, selection_sha256 = select_questions(
        parse_questions(questions_text), args.selection
    )

    lm = dspy.LM(
        f"openai/{args.model}",
        model_type="responses",
        reasoning_effort=args.reasoning_effort,
        max_tokens=args.max_tokens,
        cache=True,
    )
    dspy.configure(lm=lm, adapter=dspy.JSONAdapter())
    program = dspy.Predict(AnswerEssayQuestions)

    generated_at = datetime.now(UTC).replace(microsecond=0).isoformat()
    result: dict = {
        "schema_version": 2,
        "run": {
            "evaluation": "essay-questions",
            "methodology_version": METHODOLOGY_VERSION,
            "stages": [
                "snapshot",
                "deterministic-preflight",
                "generate",
                "ordered-judges",
                "bounded-revision",
                "compare",
                "human-promotion",
            ],
            "model": args.model,
            "provider": "openai",
            "api_surface": "responses",
            "reasoning_effort": args.reasoning_effort,
            "dspy_version": importlib.metadata.version("dspy"),
            "litellm_version": importlib.metadata.version("litellm"),
            "python_version": platform.python_version(),
            "generated_at": generated_at,
            "organon_commit": git_head(ROOT),
            "committed_inputs_sha256": input_manifest,
            "ontology_path": display_path(args.ontology),
            "ontology_sha256": sha256_text(ontology),
            "answer_form_path": display_path(args.answer_form),
            "answer_form_sha256": sha256_text(answer_form),
            "questions_path": display_path(args.questions),
            "questions_sha256": sha256_text(questions_text),
            "selection_path": display_path(args.selection) if args.selection else None,
            "selection_sha256": selection_sha256,
            "expected_essay_count": len(essay_sets),
            "expected_question_count": sum(len(essay.questions) for essay in essay_sets),
            "essay_count": 0,
            "question_count": 0,
            "complete": False,
        },
        "essays": [],
    }

    for essay_set in essay_sets:
        essay_path = resolve_essay_path(args.vault_root, essay_set.essay_file)
        essay_text = read_text(essay_path)
        answers = generate_with_retry(
            program,
            essay_set=essay_set,
            ontology=ontology,
            answer_form=answer_form,
            essay_title=essay_set.title,
            essay=essay_text,
        )
        questions_by_id = {question.id: question for question in essay_set.questions}
        answer_rows = []
        for answer in answers:
            question = questions_by_id[answer.question_id]
            row = answer.model_dump()
            row["lens"] = question.lens
            row["question"] = question.question
            row["pressure_point"] = question.pressure_point
            answer_rows.append(row)
        result["essays"].append(
            {
                "title": essay_set.title,
                "essay_file": essay_set.essay_file,
                "essay_sha256": sha256_text(essay_text),
                "answers": answer_rows,
            }
        )

    result["run"]["essay_count"] = len(result["essays"])
    result["run"]["question_count"] = sum(
        len(essay["answers"]) for essay in result["essays"]
    )
    result["run"]["complete"] = (
        result["run"]["essay_count"] == result["run"]["expected_essay_count"]
        and result["run"]["question_count"] == result["run"]["expected_question_count"]
    )
    if not result["run"]["complete"]:
        raise RuntimeError("Evaluation did not produce the complete selected question set")
    write_artifacts(result, args.run_dir)
    write_projection(
        args.obsidian_output,
        render_markdown(result, obsidian_links=True),
    )


if __name__ == "__main__":
    main()
