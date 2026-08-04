#!/usr/bin/env python3
"""Run the Organon-guided DSPy essay-question evaluation."""

from __future__ import annotations

import argparse
import hashlib
import importlib.metadata
import json
import os
import platform
import re
import subprocess
from datetime import UTC, datetime
from pathlib import Path
from typing import Literal

import dspy
from pydantic import BaseModel, Field


ROOT = Path(__file__).resolve().parents[2]
EVAL_ROOT = Path(__file__).resolve().parent
DEFAULT_QUESTIONS = EVAL_ROOT / "questions.md"
DEFAULT_ONTOLOGY = ROOT / "ontology" / "ontology.md"
DEFAULT_SHORT_FORM = ROOT / "editorial" / "short-form.md"

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


class AnswerDraft(BaseModel):
    question_id: str = Field(description="Exact question ID supplied in the input.")
    disposition: Literal["answered", "partly_answered", "inferable", "open", "misframed"]
    answer: str = Field(
        description="A concise direct answer of roughly two to five sentences."
    )
    essay_anchors: list[str] = Field(
        description="Section headings or brief location descriptions from the essay."
    )
    limitation: str = Field(
        description="What remains unsupported, ambiguous, or outside the essay."
    )


class AnswerEssayQuestions(dspy.Signature):
    """Answer reader questions from the essay without inventing Daniel's position.

    Treat the ontology as binding vocabulary and anti-collapse discipline, not as
    evidence that the essay's factual claims are true. Treat the short-form
    instrument as guidance for clear, compact delivery, not permission to imitate
    samples or add jokes. For each question, distinguish what the essay answers,
    what can be cautiously inferred, and what remains open. Use only anchors that
    a reader can locate in the supplied essay. Return exactly one answer for every
    supplied question ID and no others.
    """

    ontology: str = dspy.InputField(
        description="Complete binding Organon ontology in Markdown."
    )
    short_form: str = dspy.InputField(
        description="Complete canonical short-form editorial instrument."
    )
    essay_title: str = dspy.InputField()
    essay: str = dspy.InputField(description="Complete canonical essay Markdown.")
    questions: list[Question] = dspy.InputField()
    answers: list[AnswerDraft] = dspy.OutputField()


def sha256_text(value: str) -> str:
    return hashlib.sha256(value.encode("utf-8")).hexdigest()


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


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


def git_head() -> str:
    result = subprocess.run(
        ["git", "-C", str(ROOT), "rev-parse", "HEAD"],
        check=True,
        capture_output=True,
        text=True,
    )
    return result.stdout.strip()


def escape_cell(value: str) -> str:
    return " ".join(value.replace("|", r"\|").split())


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
        f"> `{escape_cell(metadata['model'])}` answered {metadata['question_count']} reader questions across {metadata['essay_count']} essays with the complete binding ontology and canonical short-form instrument in context. These are generated answers, not Daniel-authored positions or binding Organon Claims.",
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
        f"| Short-form SHA-256 | `{metadata['short_form_sha256']}` |",
        f"| Questions SHA-256 | `{metadata['questions_sha256']}` |",
        "",
        "## Answers",
        "",
        "| Essay | ID | Lens | Disposition | Question | Answer | Essay anchors | Limitation |",
        "|---|---|---|---|---|---|---|---|",
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


def write_artifacts(result: dict, output_stem: Path, overwrite: bool) -> None:
    json_path = Path(f"{output_stem}.json")
    markdown_path = Path(f"{output_stem}.md")
    for path in (json_path, markdown_path):
        if path.exists() and not overwrite:
            raise FileExistsError(f"Refusing to overwrite {path}; pass --overwrite")
        path.parent.mkdir(parents=True, exist_ok=True)

    json_path.write_text(
        json.dumps(result, indent=2, ensure_ascii=False) + "\n", encoding="utf-8"
    )
    markdown_path.write_text(render_markdown(result), encoding="utf-8")


def write_obsidian_projection(result: dict, output: Path, overwrite: bool) -> None:
    if output.exists() and not overwrite:
        raise FileExistsError(f"Refusing to overwrite {output}; pass --overwrite")
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(render_markdown(result, obsidian_links=True), encoding="utf-8")


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
    parser.add_argument("--short-form", type=Path, default=DEFAULT_SHORT_FORM)
    parser.add_argument(
        "--model", default=os.environ.get("OPENAI_MODEL", "gpt-5.6-luna")
    )
    parser.add_argument(
        "--reasoning-effort",
        default=os.environ.get("OPENAI_REASONING_EFFORT", "medium"),
        choices=["none", "low", "medium", "high", "xhigh", "max"],
    )
    parser.add_argument("--max-tokens", type=int, default=5000)
    parser.add_argument("--output-stem", type=Path, required=True)
    parser.add_argument("--obsidian-output", type=Path)
    parser.add_argument("--overwrite", action="store_true")
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    if not os.environ.get("OPENAI_API_KEY"):
        raise SystemExit("OPENAI_API_KEY is required and is never written by this runner")
    if not args.vault_root or not args.vault_root.is_dir():
        raise SystemExit("--vault-root or PARERGON_VAULT must name the Parergon vault")

    questions_text = read_text(args.questions)
    ontology = read_text(args.ontology)
    short_form = read_text(args.short_form)
    essay_sets = parse_questions(questions_text)

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
        "schema_version": 1,
        "run": {
            "evaluation": "essay-questions",
            "model": args.model,
            "provider": "openai",
            "api_surface": "responses",
            "reasoning_effort": args.reasoning_effort,
            "dspy_version": importlib.metadata.version("dspy"),
            "litellm_version": importlib.metadata.version("litellm"),
            "python_version": platform.python_version(),
            "generated_at": generated_at,
            "organon_commit": git_head(),
            "ontology_path": display_path(args.ontology),
            "ontology_sha256": sha256_text(ontology),
            "short_form_path": display_path(args.short_form),
            "short_form_sha256": sha256_text(short_form),
            "questions_path": display_path(args.questions),
            "questions_sha256": sha256_text(questions_text),
            "essay_count": 0,
            "question_count": 0,
            "complete": False,
        },
        "essays": [],
    }

    for essay_set in essay_sets:
        essay_path = (
            args.vault_root / "Contexts" / "Essays" / "Works" / essay_set.essay_file
        )
        essay_text = read_text(essay_path)
        prediction = program(
            ontology=ontology,
            short_form=short_form,
            essay_title=essay_set.title,
            essay=essay_text,
            questions=essay_set.questions,
        )
        answers = validate_answers(essay_set, prediction.answers)
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
        result["run"]["essay_count"] == 10
        and result["run"]["question_count"] == 40
    )
    if not result["run"]["complete"]:
        raise RuntimeError("Evaluation did not produce the complete 10-essay/40-question set")
    write_artifacts(result, args.output_stem, args.overwrite)
    if args.obsidian_output:
        write_obsidian_projection(result, args.obsidian_output, args.overwrite)


if __name__ == "__main__":
    main()
