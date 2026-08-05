#!/usr/bin/env python3
"""Generate and judge long-form artifacts under Organon's instruments."""

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
DEFAULT_TARGETS = EVAL_ROOT / "targets.json"
DEFAULT_ONTOLOGY = ROOT / "ontology" / "ontology.md"
DEFAULT_SHORT_FORM = ROOT / "editorial" / "short-form.md"
DEFAULT_LONG_FORM = ROOT / "editorial" / "long-form.md"
MODEL_GUIDANCE_URL = "https://developers.openai.com/api/docs/guides/latest-model?model=gpt-5.6"
PROMPT_GUIDANCE_URL = "https://developers.openai.com/api/docs/guides/prompt-guidance-gpt-5p6.md"
PROMPT_CONTRACT_VERSION = "gpt-5.6-v1"


class LongFormDraft(BaseModel):
    title: str
    reader_start: str
    consequential_missingness: str
    honored_resistance: list[str]
    deliveries: list[str]
    inheritance: str
    source_anchors: list[str]
    markdown: str


class OntologyArtifactJudgment(BaseModel):
    term_fidelity: int = Field(ge=0, le=4)
    dependency_and_anti_collapse: int = Field(ge=0, le=4)
    epistemic_boundary: int = Field(ge=0, le=4)
    source_traceability: int = Field(ge=0, le=4)
    critical_violations: list[str]
    evidence: str
    revision: str


class DeliveryJudgment(BaseModel):
    literal_clarity: int = Field(ge=0, le=4)
    compression: int = Field(ge=0, le=4)
    actors_mechanism_stakes: int = Field(ge=0, le=4)
    ambiguity_humor_and_stopping: int = Field(ge=0, le=4)
    critical_violations: list[str]
    evidence: str
    revision: str


class LongFormJudgment(BaseModel):
    hospitality: int = Field(ge=0, le=4)
    consequential_missingness: int = Field(ge=0, le=4)
    negotiation: int = Field(ge=0, le=4)
    delivery: int = Field(ge=0, le=4)
    revaluation: int = Field(ge=0, le=4)
    inheritance: int = Field(ge=0, le=4)
    anti_formula_discipline: int = Field(ge=0, le=4)
    critical_violations: list[str]
    evidence: str
    revision: str


class GenerateLongForm(dspy.Signature):
    """Create the reviewable artifact described by the target.

    Success means the complete draft matches the target's audience, purpose,
    desired inheritance, artifact kind, and word range; preserves every
    safety-critical fact, command, status, nonclaim, and link needed by that
    purpose; honors at least one serious resistance; and uses only declared
    source anchors. For a replacement README, preserve its genre and factual
    claims first, then improve clarity, hierarchy, and flow without adding a
    promotional claim.

    Treat the ontology as binding vocabulary and anti-collapse discipline, not
    proof of a factual Claim. Use the long-form grammar for the reader's
    transition without exposing six formulaic section labels. Use short form
    only for one to five declared deliveries of 15 to 100 words each. Do not
    invent biography, history, results, metrics, citations, or capabilities.
    source_anchors may contain only exact supplied source or instrument paths.
    Stop when the target is operationally complete; omit optional background
    and repetition before omitting a required fact, boundary, or next action.
    """

    ontology: str = dspy.InputField()
    short_form: str = dspy.InputField()
    long_form: str = dspy.InputField()
    target_json: str = dspy.InputField()
    source_dossier: str = dspy.InputField()
    draft: LongFormDraft = dspy.OutputField()


class ReviseLongForm(dspy.Signature):
    """Return one complete replacement draft that resolves supplied failures.

    Preserve successful structure, source-backed facts, commands, links,
    boundaries, genre, and tone. Change only what the deterministic or judge
    evidence requires. Do not add claims, promotional language, or visible
    six-function scaffolding. Keep each delivery within 15 to 100 words and
    earn specialized terms after the concrete problem is clear. Stop once all
    reported failures and the target contract are satisfied.
    """

    ontology: str = dspy.InputField()
    short_form: str = dspy.InputField()
    long_form: str = dspy.InputField()
    target_json: str = dspy.InputField()
    source_dossier: str = dspy.InputField()
    current_draft_json: str = dspy.InputField()
    evaluation_feedback_json: str = dspy.InputField()
    draft: LongFormDraft = dspy.OutputField()


class JudgeOntologyArtifact(dspy.Signature):
    """Judge the artifact against the complete binding ontology and sources.

    Score 0 to 4. A 3 means review-ready with no load-bearing defect. Penalize
    undefined capitalized use, dependency reversal, term collapse, formal
    overclaim, source invention, and use of ontology as factual Evidence.
    """

    ontology: str = dspy.InputField()
    target_json: str = dspy.InputField()
    source_dossier: str = dspy.InputField()
    draft_json: str = dspy.InputField()
    judgment: OntologyArtifactJudgment = dspy.OutputField()


class JudgeDeliveries(dspy.Signature):
    """Judge the declared deliveries under the canonical short-form instrument.

    Score 0 to 4. Do not require humor or imitation. Require literal clarity,
    compression, preserved actors/mechanism/stakes, disciplined ambiguity, and
    a clean stopping point. You receive only the declared sentence-scale
    deliveries, not the complete artifact. Judge each delivery against the
    explicit 15-to-100-word contract. Do not assess the complete artifact's
    length, sections, installation coverage, or operational completeness here;
    those belong to deterministic and long-form evaluation.
    """

    short_form: str = dspy.InputField()
    target_json: str = dspy.InputField()
    deliveries_json: str = dspy.InputField()
    judgment: DeliveryJudgment = dspy.OutputField()


class JudgeLongForm(dspy.Signature):
    """Judge the draft under the provisional long-form editorial grammar.

    Score every function from 0 to 4, where 3 is review-ready. Evaluate reader
    transition rather than visible headings. Penalize manufactured Missingness,
    straw resistance, unearned delivery, recap presented as revaluation,
    nonportable inheritance, and formulaic six-beat staging.
    Do not estimate or score word-count compliance; the deterministic layer
    computes it exactly. Judge structure and proportionality from the text.
    """

    long_form: str = dspy.InputField()
    target_json: str = dspy.InputField()
    draft_json: str = dspy.InputField()
    judgment: LongFormJudgment = dspy.OutputField()


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def sha256_text(value: str) -> str:
    return hashlib.sha256(value.encode("utf-8")).hexdigest()


def repository_commit() -> str:
    return subprocess.run(
        ["git", "rev-parse", "HEAD"], cwd=ROOT, check=True,
        capture_output=True, text=True,
    ).stdout.strip()


def escape_cell(value: object) -> str:
    return str(value).replace("|", "\\|").replace("\n", " ")


def score_values(judgment: dict) -> list[int]:
    excluded = {"critical_violations", "evidence", "revision"}
    return [value for key, value in judgment.items() if key not in excluded and isinstance(value, int)]


def judgment_passed(judgment: dict) -> bool:
    return not judgment["critical_violations"] and min(score_values(judgment)) >= 3


def delivery_target(target: dict) -> dict:
    """Give the delivery judge context without the artifact-length contract."""
    return {
        "id": target["id"],
        "audience": target["audience"],
        "purpose": target["purpose"],
        "delivery_contract": {
            "unit": "declared sentence-scale delivery, not complete artifact",
            "word_range": [15, 100],
            "artifact_completeness_out_of_scope": True,
        },
    }


def call_judge_with_retry(program, **kwargs):
    last_error: Exception | None = None
    target = json.loads(kwargs["target_json"])
    for attempt in range(3):
        call_kwargs = dict(kwargs)
        if attempt:
            call_target = dict(target)
            call_target["_retry_instruction"] = (
                "The previous response lacked the required structured judgment. "
                "Return one complete judgment matching the declared schema."
            )
            call_kwargs["target_json"] = json.dumps(call_target, ensure_ascii=False)
        try:
            return program(**call_kwargs).judgment.model_dump()
        except Exception as error:
            last_error = error
    assert last_error is not None
    raise last_error


def deterministic_checks(
    draft: LongFormDraft, allowed_sources: set[str], target: dict | None = None
) -> dict:
    words = len(draft.markdown.split())
    minimum_words, maximum_words = (target or {}).get("word_range", [800, 2200])
    delivery_words = [len(delivery.split()) for delivery in draft.deliveries]
    checks = {
        "word_range": minimum_words <= words <= maximum_words,
        "title_present": bool(draft.title.strip()),
        "reader_start_present": bool(draft.reader_start.strip()),
        "missingness_present": bool(draft.consequential_missingness.strip()),
        "honors_resistance": bool(draft.honored_resistance),
        "delivery_count_1_5": 1 <= len(draft.deliveries) <= 5,
        "deliveries_word_range_15_100": bool(delivery_words)
        and all(15 <= count <= 100 for count in delivery_words),
        "inheritance_present": bool(draft.inheritance.strip()),
        "source_anchors_present": bool(draft.source_anchors),
        "source_anchors_declared": set(draft.source_anchors) <= allowed_sources,
        "no_private_path": "/Users/" not in draft.markdown and "/private/" not in draft.markdown,
    }
    return {
        "passed": all(checks.values()), "word_count": words,
        "required_word_range": [minimum_words, maximum_words],
        "delivery_word_counts": delivery_words, "checks": checks,
    }


def source_dossier(target: dict) -> tuple[str, dict[str, str]]:
    sections = []
    digests = {}
    for relative in target["source_files"]:
        text = read_text(ROOT / relative)
        digests[relative] = sha256_text(text)
        expected = target.get("source_digests", {}).get(relative)
        if expected and digests[relative] != expected:
            raise ValueError(
                f"source digest mismatch for {relative}: "
                f"expected {expected}, got {digests[relative]}"
            )
        sections.append(f"\n\n# SOURCE: {relative}\n\n{text}")
    return "".join(sections).lstrip(), digests


def evaluate_draft(
    draft: LongFormDraft,
    target: dict,
    allowed_sources: set[str],
    ontology: str,
    short_form: str,
    long_form: str,
    dossier: str,
    ontology_judge,
    delivery_judge,
    long_form_judge,
) -> dict:
    draft_json = draft.model_dump_json()
    deterministic = deterministic_checks(draft, allowed_sources, target)
    ontology_result = call_judge_with_retry(
        ontology_judge,
        ontology=ontology,
        target_json=json.dumps(target),
        source_dossier=dossier,
        draft_json=draft_json,
    )
    delivery_result = call_judge_with_retry(
        delivery_judge,
        short_form=short_form,
        target_json=json.dumps(delivery_target(target)),
        deliveries_json=json.dumps({"deliveries": draft.deliveries}, ensure_ascii=False),
    )
    long_form_result = call_judge_with_retry(
        long_form_judge,
        long_form=long_form,
        target_json=json.dumps(target),
        draft_json=draft_json,
    )
    passed = deterministic["passed"] and all(map(judgment_passed, [
        ontology_result, delivery_result, long_form_result
    ]))
    return {
        "passed": passed,
        "deterministic": deterministic,
        "ontology": ontology_result,
        "delivery": delivery_result,
        "long_form": long_form_result,
    }


def render_markdown(result: dict) -> str:
    run = result["run"]
    lines = [
        "---",
        "type: organon-evaluation",
        "evaluation: editorial-artifacts",
        f"model: {run['generator_model']}",
        f"generated_at: {run['generated_at']}",
        f"complete: {str(run['complete']).lower()}",
        f"passed: {str(run['passed']).lower()}",
        "---",
        "",
        "# Long-form editorial artifacts",
        "",
        "> [!summary]",
        f"> Generated {run['target_count']} long-form artifacts under the current ontology, canonical short-form instrument, and provisional long-form grammar. Deterministic checks and three separate judge calls evaluated each final draft. These remain generated proposals for Daniel's review.",
        "",
        "## Run",
        "",
        "| Field | Value |",
        "|---|---|",
        f"| Generator | `{run['generator_model']}` / `{run['generator_reasoning_effort']}` |",
        f"| Judges | `{run['judge_model']}` / `{run['judge_reasoning_effort']}` |",
        f"| Ontology SHA-256 | `{run['ontology_sha256']}` |",
        f"| Short-form SHA-256 | `{run['short_form_sha256']}` |",
        f"| Long-form SHA-256 | `{run['long_form_sha256']}` |",
        f"| Complete gate | {run['passed_count']} pass / {run['revision_count']} revise |",
        "",
    ]
    for artifact in result["artifacts"]:
        draft = artifact["draft"]
        evaluation = artifact["evaluation"]
        lines.extend([
            f"## {draft['title']}",
            "",
            f"> Target: `{artifact['target_id']}` · Gate: **{'pass' if evaluation['passed'] else 'revise'}** · Attempt: {artifact['attempt']}",
            "",
            draft["markdown"].strip(),
            "",
            "### Evaluation",
            "",
            "| Layer | Minimum score | Critical violations | Revision |",
            "|---|---:|---|---|",
            f"| Deterministic | {'pass' if evaluation['deterministic']['passed'] else 'fail'} | — | — |",
        ])
        for key, label in (("ontology", "Ontology"), ("delivery", "Short-form delivery"), ("long_form", "Long-form grammar")):
            judgment = evaluation[key]
            lines.append(
                f"| {label} | {min(score_values(judgment))}/4 | "
                f"{escape_cell('; '.join(judgment['critical_violations']) or 'none')} | "
                f"{escape_cell(judgment['revision'] or 'none')} |"
            )
        lines.extend([
            "",
            f"**Reader start:** {draft['reader_start']}",
            "",
            f"**Consequential missingness:** {draft['consequential_missingness']}",
            "",
            f"**Inheritance:** {draft['inheritance']}",
            "",
            f"**Source anchors:** {', '.join(draft['source_anchors'])}",
            "",
        ])
    lines.extend([
        "## Canonicality boundary",
        "",
        "The generated drafts and judge verdicts are noncanonical observations. Passing the automated gate does not make either article Daniel-authored, establish its factual Claims, or promote the provisional long-form grammar. Same-model generation and judging is an explicit limitation even though prompts and calls are separate.",
        "",
    ])
    return "\n".join(lines)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--targets", type=Path, default=DEFAULT_TARGETS)
    parser.add_argument("--target-id", action="append", dest="target_ids")
    parser.add_argument("--ontology", type=Path, default=DEFAULT_ONTOLOGY)
    parser.add_argument("--short-form", type=Path, default=DEFAULT_SHORT_FORM)
    parser.add_argument("--long-form", type=Path, default=DEFAULT_LONG_FORM)
    parser.add_argument("--generator-model", default="gpt-5.6-sol")
    parser.add_argument("--judge-model", default="gpt-5.6-sol")
    parser.add_argument("--generator-reasoning-effort", default="high")
    parser.add_argument("--judge-reasoning-effort", default="high")
    parser.add_argument("--request-timeout", type=float, default=600.0)
    parser.add_argument("--max-revisions", type=int, default=1)
    parser.add_argument("--output-stem", type=Path, required=True)
    parser.add_argument("--artifact-output-dir", type=Path)
    parser.add_argument("--obsidian-output", type=Path)
    parser.add_argument("--obsidian-artifact-output-dir", type=Path)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    if not os.environ.get("OPENAI_API_KEY"):
        raise SystemExit("OPENAI_API_KEY is required and is never written")
    targets = json.loads(read_text(args.targets))["targets"]
    if not targets or len({target["id"] for target in targets}) != len(targets):
        raise SystemExit("The contract requires one or more uniquely identified targets")
    if any(not re.fullmatch(r"[a-z0-9]+(?:-[a-z0-9]+)*", target["id"]) for target in targets):
        raise SystemExit("Target IDs must be lowercase hyphenated path-safe names")
    if args.target_ids:
        requested = set(args.target_ids)
        known = {target["id"] for target in targets}
        unknown = requested - known
        if unknown:
            raise SystemExit(f"Unknown target IDs: {', '.join(sorted(unknown))}")
        targets = [target for target in targets if target["id"] in requested]
    ontology = read_text(args.ontology)
    short_form = read_text(args.short_form)
    long_form = read_text(args.long_form)

    generator_lm = dspy.LM(
        f"openai/{args.generator_model}", model_type="responses",
        reasoning_effort=args.generator_reasoning_effort, max_tokens=12000,
        timeout=args.request_timeout, cache=True,
    )
    judge_lm = dspy.LM(
        f"openai/{args.judge_model}", model_type="responses",
        reasoning_effort=args.judge_reasoning_effort, max_tokens=7000,
        timeout=args.request_timeout, cache=True,
    )
    dspy.configure(lm=generator_lm, adapter=dspy.JSONAdapter())
    generator = dspy.Predict(GenerateLongForm)
    reviser = dspy.Predict(ReviseLongForm)
    ontology_judge = dspy.Predict(JudgeOntologyArtifact)
    delivery_judge = dspy.Predict(JudgeDeliveries)
    long_form_judge = dspy.Predict(JudgeLongForm)
    artifacts = []

    for target in targets:
        print(f"[{target['id']}] generate", flush=True)
        dossier, source_digests = source_dossier(target)
        target_json = json.dumps(target, ensure_ascii=False)
        allowed_sources = set(target["source_files"]) | {
            "ontology/ontology.md", "editorial/short-form.md", "editorial/long-form.md"
        }
        dspy.configure(lm=generator_lm, adapter=dspy.JSONAdapter())
        draft = generator(
            ontology=ontology, short_form=short_form, long_form=long_form,
            target_json=target_json, source_dossier=dossier,
        ).draft
        attempts = []
        for attempt in range(args.max_revisions + 1):
            print(f"[{target['id']}] judge attempt {attempt + 1}", flush=True)
            dspy.configure(lm=judge_lm, adapter=dspy.JSONAdapter())
            evaluation = evaluate_draft(
                draft, target, allowed_sources, ontology, short_form, long_form,
                dossier, ontology_judge, delivery_judge, long_form_judge,
            )
            attempts.append({
                "attempt": attempt + 1,
                "draft": draft.model_dump(),
                "evaluation": evaluation,
            })
            if evaluation["passed"] or attempt == args.max_revisions:
                break
            print(f"[{target['id']}] revise", flush=True)
            dspy.configure(lm=generator_lm, adapter=dspy.JSONAdapter())
            draft = reviser(
                ontology=ontology, short_form=short_form, long_form=long_form,
                target_json=target_json, source_dossier=dossier,
                current_draft_json=draft.model_dump_json(),
                evaluation_feedback_json=json.dumps(evaluation),
            ).draft
        artifacts.append({
            "target_id": target["id"],
            "target": target,
            "source_digests": source_digests,
            "attempt": attempts[-1]["attempt"],
            "attempts": attempts,
            "draft": draft.model_dump(),
            "evaluation": attempts[-1]["evaluation"],
        })

    passed_count = sum(int(artifact["evaluation"]["passed"]) for artifact in artifacts)
    result = {
        "schema_version": 1,
        "run": {
            "evaluation": "editorial-artifacts",
            "generated_at": datetime.now(UTC).replace(microsecond=0).isoformat(),
            "generator_model": args.generator_model,
            "judge_model": args.judge_model,
            "generator_reasoning_effort": args.generator_reasoning_effort,
            "judge_reasoning_effort": args.judge_reasoning_effort,
            "model_guidance_url": MODEL_GUIDANCE_URL,
            "prompt_guidance_url": PROMPT_GUIDANCE_URL,
            "prompt_contract_version": PROMPT_CONTRACT_VERSION,
            "dspy_version": importlib.metadata.version("dspy"),
            "litellm_version": importlib.metadata.version("litellm"),
            "python_version": platform.python_version(),
            "organon_commit": repository_commit(),
            "ontology_sha256": sha256_text(ontology),
            "short_form_sha256": sha256_text(short_form),
            "long_form_sha256": sha256_text(long_form),
            "targets_sha256": sha256_text(read_text(args.targets)),
            "target_count": len(artifacts),
            "passed_count": passed_count,
            "revision_count": len(artifacts) - passed_count,
            "complete": len(artifacts) == len(targets),
            "passed": len(artifacts) == len(targets) and passed_count == len(targets),
        },
        "artifacts": artifacts,
    }
    json_path = Path(f"{args.output_stem}.json")
    markdown_path = Path(f"{args.output_stem}.md")
    json_path.parent.mkdir(parents=True, exist_ok=True)
    json_path.write_text(json.dumps(result, indent=2, ensure_ascii=False) + "\n")
    markdown = render_markdown(result)
    markdown_path.write_text(markdown)
    for output_dir in filter(None, [
        args.artifact_output_dir, args.obsidian_artifact_output_dir
    ]):
        output_dir.mkdir(parents=True, exist_ok=True)
        for artifact in artifacts:
            (output_dir / f"{artifact['target_id']}.md").write_text(
                artifact["draft"]["markdown"].strip() + "\n"
            )
    if args.obsidian_output:
        args.obsidian_output.parent.mkdir(parents=True, exist_ok=True)
        args.obsidian_output.write_text(markdown)


if __name__ == "__main__":
    main()
