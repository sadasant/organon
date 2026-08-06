#!/usr/bin/env python3
"""Evaluate recorded essay-question answers with deterministic checks and judges."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
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
DEFAULT_ONTOLOGY = ROOT / "ontology" / "ontology.md"
DEFAULT_ANSWER_FORM = ROOT / "editorial" / "essay-answer-form.md"
DEFAULT_QUESTIONS = EVAL_ROOT / "questions.md"
SENTENCE_END = re.compile(r"[.!?](?:[\"'”’)]*)\s+")
ALLOWED_DISPOSITIONS = {
    "answered",
    "partly_answered",
    "inferable",
    "open",
    "misframed",
}


def load_run_module():
    spec = importlib.util.spec_from_file_location("organon_essay_run_for_judges", EVAL_ROOT / "run.py")
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


RUN = load_run_module()


class OntologyJudgment(BaseModel):
    question_id: str
    term_fidelity: int = Field(ge=0, le=4)
    anti_collapse_discipline: int = Field(ge=0, le=4)
    epistemic_discipline: int = Field(ge=0, le=4)
    source_grounding: int = Field(ge=0, le=4)
    critical_violations: list[str]
    evidence: str
    revision: str


class EditorialJudgment(BaseModel):
    question_id: str
    responsiveness: int = Field(ge=0, le=4)
    interlocutor_fit: int = Field(ge=0, le=4)
    proportionality: int = Field(ge=0, le=4)
    necessary_bridge: int = Field(ge=0, le=4)
    epistemic_boundary: int = Field(ge=0, le=4)
    stopping_discipline: int = Field(ge=0, le=4)
    critical_violations: list[str]
    evidence: str
    revision: str


class JudgeOntologyAnswers(dspy.Signature):
    """Judge answer fidelity to the supplied essay and binding ontology.

    Score each criterion from 0 to 4. A 3 means the answer satisfies the
    instrument with only non-load-bearing imperfections; 4 means unusually
    exact. Penalize invented authorial positions, ontology-term substitution,
    silent anti-collapse violations, and claims stronger than the essay. This
    is a correctness guard: do not require the visible answer to restate a full
    ontology dependency chain unless the question itself asks for one.
    Quote or precisely locate evidence from the answer. Return exactly one
    judgment for every supplied question ID and no others.
    """

    ontology: str = dspy.InputField()
    essay_title: str = dspy.InputField()
    essay: str = dspy.InputField()
    answer_bundle_json: str = dspy.InputField()
    judgments: list[OntologyJudgment] = dspy.OutputField()


class JudgeEditorialAnswers(dspy.Signature):
    """Judge answer delivery under the proposed Essay-Answer Form.

    Score responsiveness, interlocutor fit, proportionality, the necessary
    bridge, epistemic boundary, and stopping discipline from 0 to 4. A 3 means
    fit for review without a load-bearing defect. Check that the interlocutor
    hypothesis is thin, evidenced, and defeasible; do not reward invented
    biography or exhaustive background. Judge whether the visible answer pays
    this question's debt for this hypothesized reader, not whether it could
    survive as a standalone essay. Quote evidence from the answer. Return
    exactly one judgment for every supplied question ID and no others.
    """

    answer_form: str = dspy.InputField()
    essay_title: str = dspy.InputField()
    answer_bundle_json: str = dspy.InputField()
    judgments: list[EditorialJudgment] = dspy.OutputField()


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def sha256_text(value: str) -> str:
    return hashlib.sha256(value.encode("utf-8")).hexdigest()


def sha256_path(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def canonical_digest(value: object) -> str:
    return sha256_text(json.dumps(value, sort_keys=True, ensure_ascii=False))


def can_reuse_judgment(
    answer: dict,
    essay_sha256: str,
    prior_answer_sha256: str | None,
    prior_essay_sha256: str | None,
) -> bool:
    return (
        prior_answer_sha256 == canonical_digest(answer)
        and prior_essay_sha256 == essay_sha256
    )


def escape_cell(value: str) -> str:
    return " ".join(value.replace("|", r"\|").split())


def sentence_count(value: str) -> int:
    stripped = value.strip()
    if not stripped:
        return 0
    return len(SENTENCE_END.findall(stripped + " ")) or 1


def deterministic_checks(answer: dict) -> dict:
    words = len(answer["answer"].split())
    sentences = sentence_count(answer["answer"])
    checks = {
        "known_disposition": answer["disposition"] in ALLOWED_DISPOSITIONS,
        "answer_word_range_35_90": 35 <= words <= 90,
        "answer_sentence_range_2_4": 2 <= sentences <= 4,
        "has_locatable_anchor": bool(answer["essay_anchors"]),
        "has_limitation": bool(answer["limitation"].strip()),
        "has_interlocutor_background": bool(
            answer.get("interlocutor", {}).get("probable_background", "").strip()
        ),
        "has_interlocutor_purpose": bool(
            answer.get("interlocutor", {}).get("likely_purpose", "").strip()
        ),
        "has_interlocutor_evidence": bool(
            answer.get("interlocutor", {}).get("question_evidence", [])
        ),
        "has_stopping_condition": bool(
            answer.get("interlocutor", {}).get("stopping_condition", "").strip()
        ),
        "known_interlocutor_confidence": answer.get("interlocutor", {}).get("confidence")
        in {"low", "medium", "high"},
        "has_question_and_pressure": bool(answer["question"].strip())
        and bool(answer["pressure_point"].strip()),
    }
    return {
        "passed": all(checks.values()),
        "word_count": words,
        "sentence_count": sentences,
        "checks": checks,
    }


def validate_judgment_ids(expected: list[str], judgments: list[BaseModel]) -> list:
    actual = [judgment.question_id for judgment in judgments]
    if len(actual) != len(set(actual)) or set(actual) != set(expected):
        raise ValueError(f"Expected judgment IDs {expected}, received {actual}")
    by_id = {judgment.question_id: judgment for judgment in judgments}
    return [by_id[question_id] for question_id in expected]


def call_judge_with_id_retry(program, expected: list[str], bundle: str, **kwargs):
    last_error: ValueError | None = None
    answers = json.loads(bundle)
    for attempt in range(3):
        judge_bundle = bundle if attempt == 0 else json.dumps({
            "required_ids": expected,
            "answers": answers,
            "retry_instruction": (
                "The previous response was incomplete. Return exactly one complete "
                "judgment for every required ID and no others."
            ),
        }, ensure_ascii=False)
        prediction = program(answer_bundle_json=judge_bundle, **kwargs)
        try:
            return validate_judgment_ids(expected, prediction.judgments)
        except ValueError as error:
            last_error = error
    assert last_error is not None
    raise last_error


def score_values(judgment: dict) -> list[int]:
    return [value for key, value in judgment.items() if key not in {
        "question_id", "critical_violations", "evidence", "revision"
    } and isinstance(value, int)]


def judge_passed(judgment: dict) -> bool:
    return not judgment["critical_violations"] and min(score_values(judgment)) >= 3


def render_markdown(result: dict, obsidian_links: bool = False) -> str:
    run = result["run"]
    lines = [
        "---",
        "type: organon-evaluation",
        "evaluation: essay-question-judgments",
        f"model: {run['judge_model']}",
        f"generated_at: {run['generated_at']}",
        f"complete: {str(run['complete']).lower()}",
        f"passed: {str(run['passed']).lower()}",
        "---",
        "",
        "# Essay-question judgments",
        "",
        "> [!summary]",
        f"> Deterministic checks plus separate ontology and Essay-Answer Form judges evaluated {run['question_count']} generated answers. {run['passed_count']} passed the complete gate and {run['revision_count']} require revision. Judge output is generated Evidence about this run, not an independent proof or Daniel-authored verdict.",
        "",
        "## Run",
        "",
        "| Field | Value |",
        "|---|---|",
        f"| Source result | `{run['source_result']}` |",
        f"| Source SHA-256 | `{run['source_result_sha256']}` |",
        f"| Judge model | `{run['judge_model']}` |",
        f"| Judge reasoning | `{run['judge_reasoning_effort']}` |",
        f"| Ontology SHA-256 | `{run['ontology_sha256']}` |",
        f"| Essay-Answer Form SHA-256 | `{run['answer_form_sha256']}` |",
        f"| Complete gate | {run['passed_count']} pass / {run['revision_count']} revise |",
        "",
        "## Judgments",
        "",
        "| Essay | ID | Gate | Deterministic | Ontology | Editorial | Evidence | Revision |",
        "|---|---|---|---|---:|---:|---|---|",
    ]
    for essay in result["essays"]:
        label = essay["title"]
        if obsidian_links:
            note = f"Contexts/Essays/Works/{essay['essay_file'][:-3]}"
            label = f"[[{note}|{label}]]"
        for item in essay["judgments"]:
            ontology_min = min(score_values(item["ontology"]))
            editorial_min = min(score_values(item["editorial"]))
            evidence = (
                f"Ontology: {item['ontology']['evidence']} "
                f"Editorial: {item['editorial']['evidence']}"
            )
            revisions = [
                item["ontology"]["revision"],
                item["editorial"]["revision"],
            ]
            lines.append(
                "| " + " | ".join([
                    escape_cell(label),
                    item["question_id"],
                    "pass" if item["passed"] else "revise",
                    "pass" if item["deterministic"]["passed"] else "fail",
                    str(ontology_min),
                    str(editorial_min),
                    escape_cell(evidence),
                    escape_cell(" ".join(value for value in revisions if value)),
                ]) + " |"
            )
    lines.extend([
        "",
        "## Gate semantics",
        "",
        "An answer passes only when all deterministic checks pass, every ontology and Essay-Answer Form criterion scores at least 3/4, and neither judge reports a critical violation. The ontology judge guards correctness without demanding exhaustive dependency rendering. The editorial judge evaluates the answer relative to its evidenced interlocutor hypothesis. The judges use the same named model family as generation but separate prompts and calls. Their agreement is not independent human validation.",
        "",
    ])
    return "\n".join(lines)


def write_artifacts(result: dict, stem: Path, obsidian_output: Path | None) -> None:
    json_path = Path(f"{stem}.json")
    markdown_path = Path(f"{stem}.md")
    json_path.parent.mkdir(parents=True, exist_ok=True)
    json_path.write_text(json.dumps(result, indent=2, ensure_ascii=False) + "\n")
    markdown_path.write_text(render_markdown(result))
    if obsidian_output:
        obsidian_output.parent.mkdir(parents=True, exist_ok=True)
        obsidian_output.write_text(render_markdown(result, obsidian_links=True))


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--source-result", type=Path, required=True)
    parser.add_argument("--vault-root", type=Path, required=True)
    parser.add_argument("--ontology", type=Path, default=DEFAULT_ONTOLOGY)
    parser.add_argument("--answer-form", type=Path, default=DEFAULT_ANSWER_FORM)
    parser.add_argument("--judge-model", default="gpt-5.6-luna")
    parser.add_argument("--judge-reasoning-effort", default="high")
    parser.add_argument("--output-stem", type=Path, required=True)
    parser.add_argument("--obsidian-output", type=Path)
    parser.add_argument(
        "--baseline-evaluation", type=Path,
        help="Reuse judgments only for byte-equivalent answer records from a prior evaluation",
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    if not os.environ.get("OPENAI_API_KEY"):
        raise SystemExit("OPENAI_API_KEY is required and is never written")
    source = json.loads(read_text(args.source_result))
    ontology = read_text(args.ontology)
    answer_form = read_text(args.answer_form)
    input_manifest = RUN.committed_input_manifest(
        ROOT, [Path(__file__), EVAL_ROOT / "run.py", args.ontology, args.answer_form]
    )
    if source["run"]["ontology_sha256"] != sha256_text(ontology):
        raise SystemExit("Source result ontology digest does not match current input")
    if source["run"]["answer_form_sha256"] != sha256_text(answer_form):
        raise SystemExit("Source result Essay-Answer Form digest does not match current input")

    lm = dspy.LM(
        f"openai/{args.judge_model}",
        model_type="responses",
        reasoning_effort=args.judge_reasoning_effort,
        max_tokens=7000,
        cache=True,
    )
    dspy.configure(lm=lm, adapter=dspy.JSONAdapter())
    ontology_judge = dspy.Predict(JudgeOntologyAnswers)
    editorial_judge = dspy.Predict(JudgeEditorialAnswers)
    essays = []
    passed_count = 0
    reused_count = 0
    baseline_rows = {}
    baseline_answers = {}
    baseline_essay_digests = {}
    if args.baseline_evaluation:
        baseline = json.loads(read_text(args.baseline_evaluation))
        if baseline["run"]["ontology_sha256"] != sha256_text(ontology):
            raise SystemExit("Baseline evaluation ontology digest does not match current input")
        if baseline["run"]["answer_form_sha256"] != sha256_text(answer_form):
            raise SystemExit("Baseline evaluation Essay-Answer Form digest does not match current input")
        baseline_source_path = RUN.resolve_within(
            args.baseline_evaluation.parent,
            baseline["run"]["source_result"],
            label="baseline source-result selector",
        )
        if sha256_path(baseline_source_path) != baseline["run"]["source_result_sha256"]:
            raise SystemExit("Baseline source result digest does not match its evaluation")
        baseline_source = json.loads(read_text(baseline_source_path))
        for baseline_essay, baseline_eval_essay in zip(
            baseline_source["essays"], baseline["essays"], strict=True
        ):
            for answer, judgment in zip(
                baseline_essay["answers"], baseline_eval_essay["judgments"], strict=True
            ):
                key = (baseline_essay["essay_file"], answer["question_id"])
                baseline_answers[key] = canonical_digest(answer)
                baseline_essay_digests[key] = baseline_essay["essay_sha256"]
                baseline_rows[key] = judgment

    for essay in source["essays"]:
        essay_path = RUN.resolve_essay_path(args.vault_root, essay["essay_file"])
        essay_text = read_text(essay_path)
        if sha256_text(essay_text) != essay["essay_sha256"]:
            raise SystemExit(f"Essay digest changed: {essay['title']}")
        changed_answers = [
            answer for answer in essay["answers"]
            if not can_reuse_judgment(
                answer,
                essay["essay_sha256"],
                baseline_answers.get((essay["essay_file"], answer["question_id"])),
                baseline_essay_digests.get((essay["essay_file"], answer["question_id"])),
            )
        ]
        expected_ids = [answer["question_id"] for answer in changed_answers]
        ontology_by_id = {}
        editorial_by_id = {}
        if changed_answers:
            bundle = json.dumps(changed_answers, ensure_ascii=False)
            ontology_by_id = {
                result.question_id: result.model_dump()
                for result in call_judge_with_id_retry(
                    ontology_judge, expected_ids, bundle, ontology=ontology,
                    essay_title=essay["title"], essay=essay_text,
                )
            }
            editorial_by_id = {
                result.question_id: result.model_dump()
                for result in call_judge_with_id_retry(
                    editorial_judge, expected_ids, bundle, answer_form=answer_form,
                    essay_title=essay["title"],
                )
            }
        rows = []
        for answer in essay["answers"]:
            key = (essay["essay_file"], answer["question_id"])
            deterministic = deterministic_checks(answer)
            if answer["question_id"] in ontology_by_id:
                ontology_data = ontology_by_id[answer["question_id"]]
                editorial_data = editorial_by_id[answer["question_id"]]
            else:
                prior = baseline_rows[key]
                ontology_data = prior["ontology"]
                editorial_data = prior["editorial"]
                reused_count += 1
            passed = deterministic["passed"] and judge_passed(ontology_data) and judge_passed(editorial_data)
            passed_count += int(passed)
            rows.append({
                "question_id": answer["question_id"],
                "passed": passed,
                "deterministic": deterministic,
                "ontology": ontology_data,
                "editorial": editorial_data,
            })
        essays.append({
            "title": essay["title"],
            "essay_file": essay["essay_file"],
            "judgments": rows,
        })

    question_count = sum(len(essay["judgments"]) for essay in essays)
    expected_question_count = source["run"].get("expected_question_count", 40)
    result = {
        "schema_version": 1,
        "run": {
            "evaluation": "essay-question-judgments",
            "generated_at": datetime.now(UTC).replace(microsecond=0).isoformat(),
            "judge_model": args.judge_model,
            "judge_reasoning_effort": args.judge_reasoning_effort,
            "dspy_version": importlib.metadata.version("dspy"),
            "litellm_version": importlib.metadata.version("litellm"),
            "python_version": platform.python_version(),
            "organon_commit": RUN.git_head(ROOT),
            "committed_inputs_sha256": input_manifest,
            "source_result": args.source_result.name,
            "source_result_sha256": sha256_path(args.source_result),
            "ontology_sha256": sha256_text(ontology),
            "answer_form_sha256": sha256_text(answer_form),
            "question_count": question_count,
            "expected_question_count": expected_question_count,
            "selection_sha256": source["run"].get("selection_sha256"),
            "passed_count": passed_count,
            "revision_count": question_count - passed_count,
            "reused_judgment_count": reused_count,
            "rejudged_count": question_count - reused_count,
            "baseline_evaluation": args.baseline_evaluation.name if args.baseline_evaluation else None,
            "baseline_evaluation_sha256": sha256_path(args.baseline_evaluation) if args.baseline_evaluation else None,
            "complete": question_count == expected_question_count,
            "passed": question_count == expected_question_count and passed_count == question_count,
        },
        "essays": essays,
    }
    write_artifacts(result, args.output_stem, args.obsidian_output)


if __name__ == "__main__":
    main()
