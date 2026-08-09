#!/usr/bin/env python3
"""Generate or revise a project-ontology candidate from a pinned dossier."""

from __future__ import annotations

import argparse
import importlib.metadata
import importlib.util
import json
import os
import platform
import sys
from datetime import UTC, datetime
from pathlib import Path

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
    read_json,
    read_text,
    resolve_within,
    sha256_path,
    sha256_text,
)
from core.judging import call_structured_with_retry
from core.workspace import RunWorkspace


def load_judge_module():
    spec = importlib.util.spec_from_file_location(
        "organon_project_ontology_judges", EVAL_ROOT / "run.py"
    )
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


JUDGE = load_judge_module()
DEFAULT_TARGETS = EVAL_ROOT / "inputs" / "targets.json"
DEFAULT_ONTOLOGY = ROOT / "ontology" / "ontology.md"
DEFAULT_REGISTRY = ROOT / "ontology" / "terms.yaml"
DEFAULT_RUBRIC = EVAL_ROOT / "inputs" / "documentation-rubric.md"


class ProjectOntologyDraft(BaseModel):
    source_claims: list[str] = Field(
        description="Load-bearing project claims supported by the dossier."
    )
    unresolved_gates: list[str] = Field(
        description="Mappings or claims deliberately left unpromoted."
    )
    markdown: str = Field(
        description="Complete project ontology with frontmatter and mapping manifest."
    )


class GenerateProjectOntology(dspy.Signature):
    """Create or revise one complete project-ontology candidate.

    Describe the project's local vocabulary and mechanisms before mapping them.
    Preserve exact repository, branch, commit, and source coordinates. Classify
    every proposed correspondence as exact, refinement, conflict, or unmapped;
    plausible analogy is not refinement. Supply complete Organon dependency
    packets for promoted mappings and leave incomplete ones as explicit gates.
    Do not turn repository self-description into Truth, independent Evidence,
    adoption, security, completion, or institutional authority.

    Frontmatter must carry the exact project, repository, branch, commit, and
    Organon version from target_json, plus `status: generated-candidate`.
    The Markdown must contain these exact H2 headings, in a coherent order:
    `Scope and nonclaims`, `Project purpose`, `Local vocabulary`,
    `Participants and worlds`, `Load-bearing relations`,
    `Invariants and prohibited collapses`, `Organon mappings`, `Boundary cases`,
    and `Uncertainties and promotion gates`. End with one machine-readable
    manifest in this literal wrapper (replace the ellipsis with the complete
    mapping object):

    <!-- organon:mapping-manifest -->
    ```yaml
    schema_version: 1
    project: Project name
    commit: exact commit from target_json
    mappings: [...]
    ```

    Every manifest evidence item must be a path:start-end range present in the
    source index.
    On revision, change only what the supplied improvement plan requires and
    preserve source-backed distinctions and successful layers. Stop when the
    dossier is reviewable; do not pad it with the complete Organon vocabulary.
    """

    ontology: str = dspy.InputField()
    registry_json: str = dspy.InputField()
    documentation_rubric: str = dspy.InputField()
    target_json: str = dspy.InputField()
    source_dossier: str = dspy.InputField()
    current_candidate: str = dspy.InputField()
    improvement_plan_json: str = dspy.InputField()
    draft: ProjectOntologyDraft = dspy.OutputField()


def select_target(path: Path, target_id: str) -> dict:
    targets = read_json(path)["targets"]
    matches = [target for target in targets if target["id"] == target_id]
    if len(matches) != 1:
        raise ValueError(f"expected one target named {target_id}")
    return matches[0]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--targets", type=Path, default=DEFAULT_TARGETS)
    parser.add_argument("--target-id", required=True)
    parser.add_argument("--ontology", type=Path, default=DEFAULT_ONTOLOGY)
    parser.add_argument("--registry", type=Path, default=DEFAULT_REGISTRY)
    parser.add_argument("--documentation-rubric", type=Path, default=DEFAULT_RUBRIC)
    parser.add_argument("--candidate", type=Path)
    parser.add_argument("--improvement-plan", type=Path)
    parser.add_argument("--model", default="gpt-5.6-sol")
    parser.add_argument("--reasoning-effort", default="high")
    parser.add_argument("--request-timeout", type=float, default=600.0)
    parser.add_argument("--max-deterministic-attempts", type=int, default=3)
    parser.add_argument("--run-dir", type=Path, required=True)
    return parser.parse_args()


def generate_valid_draft(
    program,
    *,
    target: dict,
    ontology: str,
    registry_json: str,
    documentation_rubric: str,
    source_dossier: str,
    current_candidate: str,
    improvement_plan_json: str,
    known_ids: set[str],
    line_counts: dict[str, int],
    covered_ranges: dict[str, list[list[int]]],
    max_attempts: int,
) -> tuple[dict, dict, int]:
    """Return the first draft that passes the deterministic ontology contract."""
    if max_attempts < 1:
        raise ValueError("max deterministic attempts must be positive")
    last_failure = "generation did not run"
    candidate = current_candidate
    for attempt in range(1, max_attempts + 1):
        attempt_target = dict(target)
        if attempt > 1:
            attempt_target["_deterministic_retry_instruction"] = (
                "The previous draft failed deterministic preflight: "
                f"{last_failure}. Return a complete corrected Markdown artifact. "
                "Preserve source-backed content, include every required H2 heading, "
                "and end with exactly one literal <!-- organon:mapping-manifest --> "
                "YAML block whose citations use only covered source ranges."
            )
        draft = call_structured_with_retry(
            program,
            output_field="draft",
            ontology=ontology,
            registry_json=registry_json,
            documentation_rubric=documentation_rubric,
            target_json=json.dumps(attempt_target, ensure_ascii=False),
            source_dossier=source_dossier,
            current_candidate=candidate,
            improvement_plan_json=improvement_plan_json,
        )
        candidate = draft["markdown"]
        try:
            deterministic = JUDGE.deterministic_checks(
                target, candidate, known_ids, line_counts, covered_ranges
            )
        except ValueError as error:
            last_failure = str(error)
            continue
        if deterministic["passed"]:
            return draft, deterministic, attempt
        last_failure = "; ".join(
            key for key, passed in deterministic["checks"].items() if not passed
        )
    raise ValueError(
        f"no candidate passed deterministic preflight after {max_attempts} attempts: "
        f"{last_failure}"
    )


def main() -> None:
    args = parse_args()
    if not os.environ.get("OPENAI_API_KEY"):
        raise SystemExit("OPENAI_API_KEY is required and is never written")
    if args.max_deterministic_attempts < 1:
        raise SystemExit("--max-deterministic-attempts must be positive")
    if bool(args.candidate) != bool(args.improvement_plan):
        raise SystemExit("revision requires both --candidate and --improvement-plan")
    target = select_target(args.targets, args.target_id)
    dossier, source_digests, line_counts, covered_ranges = JUDGE.source_dossier(target)
    source_paths = [
        resolve_within(ROOT, relative, label="project source selector")
        for relative in target["source_files"]
    ]
    source_paths.append(
        resolve_within(ROOT, target["source_index_file"], label="source index selector")
    )
    governed = methodology_inputs(EVALS_ROOT) + [
        Path(__file__), EVAL_ROOT / "run.py", args.targets, args.ontology,
        args.registry, args.documentation_rubric,
    ] + source_paths
    if args.candidate:
        governed.extend([args.candidate, args.improvement_plan])
    input_manifest = committed_input_manifest(ROOT, governed)

    current = read_text(args.candidate) if args.candidate else ""
    plan = read_json(args.improvement_plan) if args.improvement_plan else []
    if plan:
        matching = [item for item in plan if item["target_id"] == target["id"]]
        if len(matching) != 1:
            raise ValueError("improvement plan must contain exactly one target entry")
        plan = matching[0]

    lm = dspy.LM(
        f"openai/{args.model}",
        model_type="responses",
        reasoning_effort=args.reasoning_effort,
        max_tokens=14000,
        timeout=args.request_timeout,
        cache=True,
    )
    dspy.configure(lm=lm, adapter=dspy.JSONAdapter())
    draft, deterministic, deterministic_attempts = generate_valid_draft(
        dspy.Predict(GenerateProjectOntology),
        target=target,
        ontology=read_text(args.ontology),
        registry_json=read_text(args.registry),
        documentation_rubric=read_text(args.documentation_rubric),
        source_dossier=dossier,
        current_candidate=current,
        improvement_plan_json=json.dumps(plan, ensure_ascii=False),
        known_ids=JUDGE.registry_ids(args.registry),
        line_counts=line_counts,
        covered_ranges=covered_ranges,
        max_attempts=args.max_deterministic_attempts,
    )
    result = {
        "schema_version": 1,
        "run": {
            "artifact": "project-ontology-candidate",
            "methodology_version": METHODOLOGY_VERSION,
            "mode": "revision" if args.candidate else "generation",
            "generated_at": datetime.now(UTC).replace(microsecond=0).isoformat(),
            "model": args.model,
            "reasoning_effort": args.reasoning_effort,
            "dspy_version": importlib.metadata.version("dspy"),
            "python_version": platform.python_version(),
            "organon_commit": git_head(ROOT),
            "committed_inputs_sha256": input_manifest,
            "target_id": target["id"],
            "deterministic_attempts": deterministic_attempts,
            "source_digests": source_digests,
            "candidate_sha256": sha256_text(draft["markdown"]),
            "source_candidate_sha256": sha256_path(args.candidate) if args.candidate else None,
            "complete": deterministic["passed"],
        },
        "deterministic": deterministic,
        "draft": draft,
    }
    workspace = RunWorkspace(args.run_dir)
    workspace.write_json("candidate.json", result)
    workspace.write_text("candidate.md", draft["markdown"].rstrip() + "\n")


if __name__ == "__main__":
    main()
