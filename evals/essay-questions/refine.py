#!/usr/bin/env python3
"""Refine only essay answers that failed the deterministic-plus-judge gate."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import os
import subprocess
import sys
from datetime import UTC, datetime
from pathlib import Path

import dspy


ROOT = Path(__file__).resolve().parents[2]
EVAL_ROOT = Path(__file__).resolve().parent


def load_run_module():
    spec = importlib.util.spec_from_file_location("organon_essay_run", EVAL_ROOT / "run.py")
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


RUN = load_run_module()


class RefineEssayAnswers(dspy.Signature):
    """Rewrite exactly the failed answer IDs using their recorded judge evidence.

    Preserve the essay's position and do not invent Daniel's answer. Resolve the
    ontology and editorial defects named by the judges, keep factual Claims
    bounded by the essay and retain locatable anchors. When compression or
    clarity failed, prefer the judge's proposed wording over adding ontology
    exposition: use 45 to 85 words, two to four sentences, and introduce only
    the ontology terms needed to prevent a specific collapse. Return exactly
    one revised AnswerDraft for every failed ID and no passing IDs.
    """

    ontology: str = dspy.InputField()
    short_form: str = dspy.InputField()
    essay_title: str = dspy.InputField()
    essay: str = dspy.InputField()
    failed_bundle_json: str = dspy.InputField()
    answers: list[RUN.AnswerDraft] = dspy.OutputField()


def sha256_path(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def git_head() -> str:
    result = subprocess.run(
        ["git", "-C", str(ROOT), "rev-parse", "HEAD"],
        check=True,
        capture_output=True,
        text=True,
    )
    return result.stdout.strip()


def merge_revisions(original: list[dict], revisions: list[dict], failed_ids: list[str]) -> list[dict]:
    actual = [revision["question_id"] for revision in revisions]
    if len(actual) != len(set(actual)) or set(actual) != set(failed_ids):
        raise ValueError(f"Expected revised IDs {failed_ids}, received {actual}")
    by_id = {revision["question_id"]: revision for revision in revisions}
    return [by_id.get(answer["question_id"], answer) for answer in original]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--source-result", type=Path, required=True)
    parser.add_argument("--evaluation", type=Path, required=True)
    parser.add_argument("--vault-root", type=Path, required=True)
    parser.add_argument("--ontology", type=Path, default=ROOT / "ontology" / "ontology.md")
    parser.add_argument("--short-form", type=Path, default=ROOT / "editorial" / "short-form.md")
    parser.add_argument("--model", default="gpt-5.6-luna")
    parser.add_argument("--reasoning-effort", default="high")
    parser.add_argument("--output-stem", type=Path, required=True)
    parser.add_argument("--obsidian-output", type=Path)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    if not os.environ.get("OPENAI_API_KEY"):
        raise SystemExit("OPENAI_API_KEY is required and is never written")
    source = json.loads(args.source_result.read_text())
    evaluation = json.loads(args.evaluation.read_text())
    ontology = args.ontology.read_text()
    short_form = args.short_form.read_text()
    if evaluation["run"]["source_result_sha256"] != sha256_path(args.source_result):
        raise SystemExit("Evaluation does not govern the supplied source result")

    judgments_by_title = {essay["title"]: essay for essay in evaluation["essays"]}
    lm = dspy.LM(
        f"openai/{args.model}", model_type="responses",
        reasoning_effort=args.reasoning_effort, max_tokens=7000, cache=True,
    )
    dspy.configure(lm=lm, adapter=dspy.JSONAdapter())
    program = dspy.Predict(RefineEssayAnswers)
    revised_ids = []

    for essay in source["essays"]:
        governed = judgments_by_title[essay["title"]]
        failed = [item for item in governed["judgments"] if not item["passed"]]
        if not failed:
            continue
        failed_ids = [item["question_id"] for item in failed]
        answers_by_id = {answer["question_id"]: answer for answer in essay["answers"]}
        bundle = [{
            "answer": answers_by_id[item["question_id"]],
            "evaluation": item,
        } for item in failed]
        essay_path = args.vault_root / "Contexts" / "Essays" / "Works" / essay["essay_file"]
        prediction = program(
            ontology=ontology,
            short_form=short_form,
            essay_title=essay["title"],
            essay=essay_path.read_text(),
            failed_bundle_json=json.dumps(bundle, ensure_ascii=False),
        )
        revisions = [answer.model_dump() for answer in prediction.answers]
        merged = merge_revisions(essay["answers"], revisions, failed_ids)
        questions_by_id = {answer["question_id"]: answer for answer in essay["answers"]}
        for answer in merged:
            original = questions_by_id[answer["question_id"]
            ]
            for field in ("lens", "question", "pressure_point"):
                answer[field] = original[field]
        essay["answers"] = merged
        revised_ids.extend(failed_ids)

    source["run"]["generated_at"] = datetime.now(UTC).replace(microsecond=0).isoformat()
    source["run"]["organon_commit"] = git_head()
    source["run"]["revision"] = {
        "source_result": args.source_result.name,
        "source_result_sha256": sha256_path(args.source_result),
        "evaluation": args.evaluation.name,
        "evaluation_sha256": sha256_path(args.evaluation),
        "model": args.model,
        "reasoning_effort": args.reasoning_effort,
        "revised_question_ids": revised_ids,
        "preserved_question_count": 40 - len(revised_ids),
    }
    RUN.write_artifacts(source, args.output_stem, overwrite=False)
    if args.obsidian_output:
        RUN.write_obsidian_projection(source, args.obsidian_output, overwrite=False)


if __name__ == "__main__":
    main()
