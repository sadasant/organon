#!/usr/bin/env python3
"""Compare a baseline answer run with an Essay-Answer Form candidate."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from datetime import UTC, datetime
from pathlib import Path


SENTENCE_END = re.compile(r"[.!?](?:[\"'”’)]*)\s+")


def read_json(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8"))


def sha256_path(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def sentence_count(value: str) -> int:
    return len(SENTENCE_END.findall(value.strip() + " ")) or int(bool(value.strip()))


def escape(value: object) -> str:
    return " ".join(str(value).replace("|", r"\|").split())


def index_answers(result: dict) -> dict[str, tuple[dict, dict]]:
    return {
        answer["question_id"]: (essay, answer)
        for essay in result["essays"]
        for answer in essay["answers"]
    }


def index_judgments(result: dict) -> dict[str, dict]:
    return {
        judgment["question_id"]: judgment
        for essay in result["essays"]
        for judgment in essay["judgments"]
    }


def validate_evaluation_candidate(evaluation: dict, candidate_path: Path) -> None:
    run = evaluation.get("run", {})
    if run.get("source_result") != candidate_path.name:
        raise ValueError("Evaluation source-result name does not match the candidate")
    if run.get("source_result_sha256") != sha256_path(candidate_path):
        raise ValueError("Evaluation source-result digest does not match the candidate")


def build_comparison(baseline: dict, candidate: dict, evaluation: dict, args) -> dict:
    validate_evaluation_candidate(evaluation, args.candidate)
    old = index_answers(baseline)
    new = index_answers(candidate)
    judgments = index_judgments(evaluation)
    rows = []
    for essay in candidate["essays"]:
        for answer in essay["answers"]:
            question_id = answer["question_id"]
            if question_id not in old or question_id not in judgments:
                raise ValueError(f"Missing comparison input for {question_id}")
            old_answer = old[question_id][1]
            judgment = judgments[question_id]
            rows.append({
                "essay": essay["title"],
                "essay_file": essay["essay_file"],
                "question_id": question_id,
                "question": answer["question"],
                "baseline_answer": old_answer["answer"],
                "candidate_answer": answer["answer"],
                "baseline_word_count": len(old_answer["answer"].split()),
                "candidate_word_count": len(answer["answer"].split()),
                "baseline_sentence_count": sentence_count(old_answer["answer"]),
                "candidate_sentence_count": sentence_count(answer["answer"]),
                "interlocutor": answer["interlocutor"],
                "passed": judgment["passed"],
                "ontology": judgment["ontology"],
                "editorial": judgment["editorial"],
            })
    return {
        "schema_version": 1,
        "run": {
            "evaluation": "essay-answer-form-comparison",
            "generated_at": datetime.now(UTC).replace(microsecond=0).isoformat(),
            "baseline": args.baseline.name,
            "baseline_sha256": sha256_path(args.baseline),
            "candidate": args.candidate.name,
            "candidate_sha256": sha256_path(args.candidate),
            "evaluation_result": args.evaluation.name,
            "evaluation_sha256": sha256_path(args.evaluation),
            "question_count": len(rows),
            "passed_count": sum(int(row["passed"]) for row in rows),
        },
        "comparisons": rows,
    }


def render(result: dict, obsidian_links: bool = False) -> str:
    run = result["run"]
    old_total = sum(row["baseline_word_count"] for row in result["comparisons"])
    new_total = sum(row["candidate_word_count"] for row in result["comparisons"])
    lines = [
        "---",
        "type: organon-evaluation",
        "evaluation: essay-answer-form-comparison",
        f"generated_at: {run['generated_at']}",
        f"question_count: {run['question_count']}",
        "---",
        "",
        "# Essay-Answer Form calibration comparison",
        "",
        "> [!summary]",
        f"> Compared {run['question_count']} baseline answers governed by short-form delivery with candidates governed by the proposed Essay-Answer Form. {run['passed_count']} candidates passed the deterministic, ontology, and Essay-Answer Form gate. Total visible answer length changed from {old_total} to {new_total} words. Interlocutor hypotheses are generated and defeasible, not facts about actual readers.",
        "",
    ]
    for row in result["comparisons"]:
        title = row["essay"]
        if obsidian_links:
            note = f"Contexts/Essays/Works/{row['essay_file'][:-3]}"
            title = f"[[{note}|{title}]]"
        interlocutor = row["interlocutor"]
        ontology_min = min(
            value for key, value in row["ontology"].items()
            if key not in {"question_id", "critical_violations", "evidence", "revision"}
            and isinstance(value, int)
        )
        editorial_min = min(
            value for key, value in row["editorial"].items()
            if key not in {"question_id", "critical_violations", "evidence", "revision"}
            and isinstance(value, int)
        )
        lines.extend([
            f"## {escape(title)} — `{row['question_id']}`",
            "",
            f"**Question:** {row['question']}",
            "",
            f"**Interlocutor hypothesis ({interlocutor['confidence']} confidence):** {interlocutor['probable_background']} {interlocutor['likely_purpose']}",
            "",
            f"**Evidence for the hypothesis:** {'; '.join(interlocutor['question_evidence'])}",
            "",
            f"**Stopping condition:** {interlocutor['stopping_condition']}",
            "",
            f"**Baseline ({row['baseline_word_count']} words):** {row['baseline_answer']}",
            "",
            f"**Candidate ({row['candidate_word_count']} words):** {row['candidate_answer']}",
            "",
            f"**Gate:** {'pass' if row['passed'] else 'revise'} · ontology {ontology_min}/4 · Essay-Answer Form {editorial_min}/4",
            "",
            f"**Judge revision:** {row['ontology']['revision']} {row['editorial']['revision']}",
            "",
        ])
    return "\n".join(lines)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--baseline", type=Path, required=True)
    parser.add_argument("--candidate", type=Path, required=True)
    parser.add_argument("--evaluation", type=Path, required=True)
    parser.add_argument("--output-stem", type=Path, required=True)
    parser.add_argument("--obsidian-output", type=Path)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    result = build_comparison(
        read_json(args.baseline), read_json(args.candidate),
        read_json(args.evaluation), args,
    )
    json_path = Path(f"{args.output_stem}.json")
    markdown_path = Path(f"{args.output_stem}.md")
    for path in (json_path, markdown_path):
        if path.exists():
            raise FileExistsError(f"Refusing to overwrite {path}")
        path.parent.mkdir(parents=True, exist_ok=True)
    json_path.write_text(json.dumps(result, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    markdown_path.write_text(render(result), encoding="utf-8")
    if args.obsidian_output:
        if args.obsidian_output.exists():
            raise FileExistsError(f"Refusing to overwrite {args.obsidian_output}")
        args.obsidian_output.parent.mkdir(parents=True, exist_ok=True)
        args.obsidian_output.write_text(render(result, obsidian_links=True), encoding="utf-8")


if __name__ == "__main__":
    main()
