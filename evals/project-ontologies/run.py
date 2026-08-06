#!/usr/bin/env python3
"""Judge exact project-ontology dossiers against Organon and documentation form."""

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

import dspy
import yaml
from pydantic import BaseModel, Field


ROOT = Path(__file__).resolve().parents[2]
EVAL_ROOT = Path(__file__).resolve().parent
EVALS_ROOT = EVAL_ROOT.parent
if str(EVALS_ROOT) not in sys.path:
    sys.path.insert(0, str(EVALS_ROOT))

from io_contracts import (
    committed_input_manifest,
    git_head,
    resolve_within,
    sha256_path,
    sha256_text,
)


DEFAULT_TARGETS = EVAL_ROOT / "targets.json"
DEFAULT_ONTOLOGY = ROOT / "ontology" / "ontology.md"
DEFAULT_REGISTRY = ROOT / "ontology" / "terms.yaml"
DEFAULT_SHORT_FORM = ROOT / "editorial" / "short-form.md"
DEFAULT_LONG_FORM = ROOT / "editorial" / "long-form.md"
DEFAULT_DOCUMENTATION_RUBRIC = EVAL_ROOT / "documentation-rubric.md"
MODEL_GUIDANCE_URL = "https://developers.openai.com/api/docs/guides/latest-model?model=gpt-5.6"
PROMPT_GUIDANCE_URL = "https://developers.openai.com/api/docs/guides/prompt-guidance-gpt-5p6.md"
PROMPT_CONTRACT_VERSION = "gpt-5.6-project-ontology-v1"
MAPPING_BLOCK = re.compile(
    r"<!--\s*organon:mapping-manifest\s*-->\s*```yaml\s*(?P<body>.*?)\s*```",
    re.DOTALL,
)
SOURCE_REF = re.compile(r"^(?P<path>[^:#]+):(?P<start>\d+)(?:-(?P<end>\d+))?$")
REQUIRED_HEADINGS = {
    "Scope and nonclaims",
    "Project purpose",
    "Local vocabulary",
    "Participants and worlds",
    "Load-bearing relations",
    "Invariants and prohibited collapses",
    "Organon mappings",
    "Boundary cases",
    "Uncertainties and promotion gates",
}
ALLOWED_MAPPING_CLASSES = {"exact", "refinement", "conflict", "unmapped"}


class OntologyProjectJudgment(BaseModel):
    term_fidelity: int = Field(ge=0, le=4)
    dependency_order: int = Field(ge=0, le=4)
    anti_collapse_discipline: int = Field(ge=0, le=4)
    load_bearing_paths: int = Field(ge=0, le=4)
    epistemic_and_institutional_boundary: int = Field(ge=0, le=4)
    critical_violations: list[str]
    evidence: str
    revision: str


class DocumentationProjectJudgment(BaseModel):
    source_traceability: int = Field(ge=0, le=4)
    coverage_and_proportion: int = Field(ge=0, le=4)
    documentation_cadence: int = Field(ge=0, le=4)
    local_language_preservation: int = Field(ge=0, le=4)
    maintenance_readiness: int = Field(ge=0, le=4)
    sentence_delivery: int = Field(ge=0, le=4)
    critical_violations: list[str]
    evidence: str
    revision: str


class JudgeProjectOntology(dspy.Signature):
    """Judge one project ontology against the complete binding Organon ontology.

    Outcome: decide whether every material mapping preserves Organon's exact
    term definitions, dependency order, and anti-collapse rules while remaining
    faithful to the pinned project source. Score 0 to 4; 3 means review-ready
    with no load-bearing defect. Require causal and authority/evidence paths to
    join their named participants rather than decorate unrelated examples.
    Penalize project self-description promoted into Truth, Evidence, security,
    adoption, completion, or causal efficacy. Do not require the project to map
    every Organon term and do not prefer an Organon mapping over an honest
    conflict or unmapped result.
    """

    ontology: str = dspy.InputField()
    target_json: str = dspy.InputField()
    source_dossier: str = dspy.InputField()
    project_ontology: str = dspy.InputField()
    judgment: OntologyProjectJudgment = dspy.OutputField()


class JudgeProjectOntologyDocumentation(dspy.Signature):
    """Judge one project ontology as maintainable open-source documentation.

    Outcome: decide whether a new maintainer can reconstruct the ontology's
    scope, source basis, local vocabulary, paths, mappings, and drift triggers.
    Apply the supplied project-ontology rubric first. Use long form only for
    reader progression and proportionality, and short form only for sentence
    clarity, concrete actors and mechanisms, compression, and stopping. Score
    0 to 4; 3 means review-ready. Do not demand essay theatrics, humor, marketing
    language, or exhaustive feature coverage.
    """

    documentation_rubric: str = dspy.InputField()
    short_form: str = dspy.InputField()
    long_form: str = dspy.InputField()
    target_json: str = dspy.InputField()
    source_dossier: str = dspy.InputField()
    project_ontology: str = dspy.InputField()
    judgment: DocumentationProjectJudgment = dspy.OutputField()


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def parse_frontmatter(markdown: str) -> dict:
    if not markdown.startswith("---\n"):
        raise ValueError("project ontology requires YAML frontmatter")
    end = markdown.find("\n---\n", 4)
    if end < 0:
        raise ValueError("project ontology frontmatter is not closed")
    parsed = yaml.safe_load(markdown[4:end])
    if not isinstance(parsed, dict):
        raise ValueError("project ontology frontmatter must be a mapping")
    return parsed


def parse_mapping_manifest(markdown: str) -> dict:
    match = MAPPING_BLOCK.search(markdown)
    if not match:
        raise ValueError("missing organon:mapping-manifest YAML block")
    parsed = yaml.safe_load(match.group("body"))
    if not isinstance(parsed, dict) or not isinstance(parsed.get("mappings"), list):
        raise ValueError("mapping manifest requires a mappings list")
    return parsed


def registry_ids(registry_path: Path) -> set[str]:
    registry = json.loads(read_text(registry_path))
    return {term["id"] for term in registry["terms"]}


def source_dossier(
    target: dict,
) -> tuple[str, dict[str, str], dict[str, int], dict[str, list[list[int]]]]:
    declared = target.get("source_digests")
    sources = target.get("source_files")
    if not isinstance(sources, list) or not sources:
        raise ValueError("target requires source_files")
    if not isinstance(declared, dict) or set(declared) != set(sources):
        raise ValueError("source_digests must pin every source_file exactly")
    sections: list[str] = []
    digests: dict[str, str] = {}
    for relative in sources:
        path = resolve_within(ROOT, relative, label="project source selector")
        text = read_text(path)
        digest = sha256_text(text)
        if digest != declared[relative]:
            raise ValueError(
                f"source digest mismatch for {relative}: expected {declared[relative]}, got {digest}"
            )
        digests[relative] = digest
        sections.append(f"# SOURCE DOSSIER: {relative}\n\n{text}")
    index_path = resolve_within(ROOT, target["source_index_file"], label="source index selector")
    if sha256_path(index_path) != target["source_index_sha256"]:
        raise ValueError(f"source index digest mismatch: {target['id']}")
    index = json.loads(read_text(index_path))
    if (
        index.get("project") != target["project"]
        or index.get("commit") != target["source_provenance"]["commit"]
    ):
        raise ValueError(f"source index provenance mismatch: {target['id']}")
    line_counts = {
        path: data["line_count"] for path, data in index["files"].items()
    }
    covered_ranges = {
        path: data["covered_ranges"] for path, data in index["files"].items()
    }
    return "\n\n".join(sections), digests, line_counts, covered_ranges


def validate_mapping_manifest(
    manifest: dict,
    target: dict,
    known_ids: set[str],
    line_counts: dict[str, int],
    covered_ranges: dict[str, list[list[int]]],
) -> dict:
    mappings = manifest["mappings"]
    checks = {
        "schema_version": manifest.get("schema_version") == 1,
        "project_matches": manifest.get("project") == target["project"],
        "snapshot_matches": manifest.get("commit") == target["source_provenance"]["commit"],
        "has_mappings": bool(mappings),
        "unique_mapping_pairs": len({
            (item.get("local_term"), item.get("organon_id")) for item in mappings
        }) == len(mappings),
        "known_mapping_classes": all(
            item.get("classification") in ALLOWED_MAPPING_CLASSES for item in mappings
        ),
        "registered_ids": all(
            item.get("classification") == "unmapped"
            or item.get("organon_id") in known_ids
            for item in mappings
        ),
        "evidence_present": all(item.get("evidence") for item in mappings),
        "evidence_valid": True,
    }
    for item in mappings:
        for reference in item.get("evidence", []):
            match = SOURCE_REF.fullmatch(str(reference))
            if not match:
                checks["evidence_valid"] = False
                continue
            path = match.group("path")
            start = int(match.group("start"))
            end = int(match.group("end") or start)
            covered = path in covered_ranges and any(
                range_start <= start and end <= range_end
                for range_start, range_end in covered_ranges.get(path, [])
            )
            if (
                path not in line_counts
                or start < 1
                or end < start
                or end > line_counts[path]
                or not covered
            ):
                checks["evidence_valid"] = False
    return checks


def deterministic_checks(
    target: dict,
    ontology_text: str,
    known_ids: set[str],
    line_counts: dict[str, int],
    covered_ranges: dict[str, list[list[int]]],
) -> dict:
    frontmatter = parse_frontmatter(ontology_text)
    manifest = parse_mapping_manifest(ontology_text)
    headings = set(re.findall(r"^##\s+(.+?)\s*$", ontology_text, re.MULTILINE))
    mapping_checks = validate_mapping_manifest(
        manifest, target, known_ids, line_counts, covered_ranges
    )
    checks = {
        "frontmatter_project": frontmatter.get("project") == target["project"],
        "frontmatter_repository": frontmatter.get("repository") == target["source_provenance"]["repository"],
        "frontmatter_branch": frontmatter.get("branch") == target["source_provenance"]["ref"],
        "frontmatter_commit": frontmatter.get("commit") == target["source_provenance"]["commit"],
        "frontmatter_organon_version": str(frontmatter.get("organon_version")) == str(target["organon_version"]),
        "frontmatter_status": frontmatter.get("status") == "generated-candidate",
        "required_headings": REQUIRED_HEADINGS <= headings,
        "no_private_path": "/Users/" not in ontology_text and "/private/" not in ontology_text,
        **{f"mapping_{key}": value for key, value in mapping_checks.items()},
    }
    return {
        "passed": all(checks.values()),
        "checks": checks,
        "mapping_count": len(manifest["mappings"]),
    }


def score_values(judgment: dict) -> list[int]:
    excluded = {"critical_violations", "evidence", "revision"}
    return [
        value for key, value in judgment.items()
        if key not in excluded and isinstance(value, int)
    ]


def judgment_passed(judgment: dict) -> bool:
    return not judgment["critical_violations"] and min(score_values(judgment)) >= 3


def call_judge_with_retry(program, **kwargs) -> dict:
    last_error: Exception | None = None
    target = json.loads(kwargs["target_json"])
    for attempt in range(3):
        call_kwargs = dict(kwargs)
        if attempt:
            retry_target = dict(target)
            retry_target["_retry_instruction"] = (
                "Return one complete judgment matching every required field; do not omit scores."
            )
            call_kwargs["target_json"] = json.dumps(retry_target, ensure_ascii=False)
        try:
            return program(**call_kwargs).judgment.model_dump()
        except Exception as error:
            last_error = error
    assert last_error is not None
    raise last_error


def escape_cell(value: object) -> str:
    return " ".join(str(value).replace("|", "\\|").split())


def render_markdown(result: dict) -> str:
    run = result["run"]
    lines = [
        "---",
        "type: organon-evaluation",
        "evaluation: project-ontologies",
        f"model: {run['judge_model']}",
        f"generated_at: {run['generated_at']}",
        f"complete: {str(run['complete']).lower()}",
        f"passed: {str(run['passed']).lower()}",
        "---",
        "",
        "# Project Ontology Assessments",
        "",
        "> [!summary]",
        f"> Deterministic contracts and two ordered judges assessed {run['target_count']} exact project-ontology snapshots. The Organon judge ran first; the documentation judge then assessed source traceability, cadence, maintenance readiness, and delivery. These verdicts are generated evidence about this run, not project adoption or independent certification.",
        "",
        "## Run",
        "",
        "| Field | Value |",
        "|---|---|",
        f"| Judge | `{run['judge_model']}` / `{run['judge_reasoning_effort']}` |",
        f"| Organon commit | `{run['organon_commit']}` |",
        f"| Ontology SHA-256 | `{run['ontology_sha256']}` |",
        f"| Documentation rubric SHA-256 | `{run['documentation_rubric_sha256']}` |",
        f"| Judge order | {' -> '.join(run['judge_order'])} |",
        f"| Gate | {run['passed_count']} pass / {run['revision_count']} revise |",
        "",
    ]
    for assessment in result["assessments"]:
        deterministic = assessment["deterministic"]
        ontology = assessment["ontology"]
        documentation = assessment["documentation"]
        lines.extend([
            f"## {assessment['project']}",
            "",
            f"> Snapshot: `{assessment['repository']}@{assessment['commit']}` · Gate: **{'pass' if assessment['passed'] else 'revise'}**",
            "",
            "| Layer | Result | Minimum score | Critical violations | Revision |",
            "|---|---|---:|---|---|",
            f"| Deterministic | {'pass' if deterministic['passed'] else 'fail'} | - | - | {escape_cell('; '.join(key for key, value in deterministic['checks'].items() if not value) or 'none')} |",
            f"| Organon ontology | {'pass' if judgment_passed(ontology) else 'revise'} | {min(score_values(ontology))}/4 | {escape_cell('; '.join(ontology['critical_violations']) or 'none')} | {escape_cell(ontology['revision'] or 'none')} |",
            f"| Documentation | {'pass' if judgment_passed(documentation) else 'revise'} | {min(score_values(documentation))}/4 | {escape_cell('; '.join(documentation['critical_violations']) or 'none')} | {escape_cell(documentation['revision'] or 'none')} |",
            "",
            f"**Ontology evidence:** {ontology['evidence']}",
            "",
            f"**Documentation evidence:** {documentation['evidence']}",
            "",
        ])
    lines.extend([
        "## Canonicality boundary",
        "",
        "The project ontologies remain generated candidates until project maintainers review and adopt them. A passing assessment means the exact dossiers survived this declared deterministic and same-model judge contract. It does not establish that the mapped claims are true, complete, externally adopted, or stable across later project revisions.",
        "",
    ])
    return "\n".join(lines)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--targets", type=Path, default=DEFAULT_TARGETS)
    parser.add_argument("--target-id", action="append", dest="target_ids")
    parser.add_argument("--ontology", type=Path, default=DEFAULT_ONTOLOGY)
    parser.add_argument("--registry", type=Path, default=DEFAULT_REGISTRY)
    parser.add_argument("--short-form", type=Path, default=DEFAULT_SHORT_FORM)
    parser.add_argument("--long-form", type=Path, default=DEFAULT_LONG_FORM)
    parser.add_argument(
        "--documentation-rubric", type=Path, default=DEFAULT_DOCUMENTATION_RUBRIC
    )
    parser.add_argument("--judge-model", default="gpt-5.6-sol")
    parser.add_argument("--judge-reasoning-effort", default="high")
    parser.add_argument("--request-timeout", type=float, default=600.0)
    parser.add_argument("--output-stem", type=Path, required=True)
    parser.add_argument("--obsidian-output", type=Path)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    if not os.environ.get("OPENAI_API_KEY"):
        raise SystemExit("OPENAI_API_KEY is required and is never written")
    targets_text = read_text(args.targets)
    targets = json.loads(targets_text)["targets"]
    if args.target_ids:
        requested = set(args.target_ids)
        known = {target["id"] for target in targets}
        if requested - known:
            raise SystemExit(f"Unknown target IDs: {sorted(requested - known)}")
        targets = [target for target in targets if target["id"] in requested]
    if not targets or len({target["id"] for target in targets}) != len(targets):
        raise SystemExit("Targets must be nonempty and uniquely identified")

    ontology = read_text(args.ontology)
    short_form = read_text(args.short_form)
    long_form = read_text(args.long_form)
    documentation_rubric = read_text(args.documentation_rubric)
    known_ids = registry_ids(args.registry)
    prepared = []
    source_paths: list[Path] = []
    for target in targets:
        ontology_path = resolve_within(ROOT, target["ontology_file"], label="project ontology selector")
        ontology_text = read_text(ontology_path)
        if sha256_text(ontology_text) != target["ontology_sha256"]:
            raise ValueError(f"ontology digest mismatch: {target['id']}")
        dossier, source_digests, line_counts, covered_ranges = source_dossier(target)
        deterministic = deterministic_checks(
            target, ontology_text, known_ids, line_counts, covered_ranges
        )
        prepared.append((target, ontology_path, ontology_text, dossier, source_digests, deterministic))
        source_paths.extend(
            resolve_within(ROOT, relative, label="project source selector")
            for relative in target["source_files"]
        )
        source_paths.append(
            resolve_within(ROOT, target["source_index_file"], label="source index selector")
        )

    input_manifest = committed_input_manifest(
        ROOT,
        [
            Path(__file__), EVAL_ROOT / "build-source-dossier.py", args.targets, args.ontology, args.registry,
            args.short_form, args.long_form, args.documentation_rubric,
        ]
        + [item[1] for item in prepared]
        + source_paths,
    )

    judge_lm = dspy.LM(
        f"openai/{args.judge_model}",
        model_type="responses",
        reasoning_effort=args.judge_reasoning_effort,
        max_tokens=8000,
        timeout=args.request_timeout,
        cache=True,
    )
    dspy.configure(lm=judge_lm, adapter=dspy.JSONAdapter())
    ontology_judge = dspy.Predict(JudgeProjectOntology)
    documentation_judge = dspy.Predict(JudgeProjectOntologyDocumentation)
    assessments = []
    for target, _, ontology_text, dossier, source_digests, deterministic in prepared:
        target_json = json.dumps(target, ensure_ascii=False)
        print(f"[{target['id']}] Organon judge", flush=True)
        ontology_result = call_judge_with_retry(
            ontology_judge,
            ontology=ontology,
            target_json=target_json,
            source_dossier=dossier,
            project_ontology=ontology_text,
        )
        print(f"[{target['id']}] documentation judge", flush=True)
        documentation_result = call_judge_with_retry(
            documentation_judge,
            documentation_rubric=documentation_rubric,
            short_form=short_form,
            long_form=long_form,
            target_json=target_json,
            source_dossier=dossier,
            project_ontology=ontology_text,
        )
        passed = (
            deterministic["passed"]
            and judgment_passed(ontology_result)
            and judgment_passed(documentation_result)
        )
        assessments.append({
            "target_id": target["id"],
            "project": target["project"],
            "repository": target["source_provenance"]["repository"],
            "commit": target["source_provenance"]["commit"],
            "ontology_file": target["ontology_file"],
            "ontology_sha256": target["ontology_sha256"],
            "source_digests": source_digests,
            "deterministic": deterministic,
            "ontology": ontology_result,
            "documentation": documentation_result,
            "passed": passed,
        })

    passed_count = sum(int(item["passed"]) for item in assessments)
    result = {
        "schema_version": 1,
        "run": {
            "evaluation": "project-ontologies",
            "generated_at": datetime.now(UTC).replace(microsecond=0).isoformat(),
            "judge_model": args.judge_model,
            "judge_reasoning_effort": args.judge_reasoning_effort,
            "judge_order": ["organon-ontology", "open-source-documentation"],
            "dspy_version": importlib.metadata.version("dspy"),
            "litellm_version": importlib.metadata.version("litellm"),
            "python_version": platform.python_version(),
            "organon_commit": git_head(ROOT),
            "committed_inputs_sha256": input_manifest,
            "ontology_sha256": sha256_text(ontology),
            "registry_sha256": sha256_path(args.registry),
            "short_form_sha256": sha256_text(short_form),
            "long_form_sha256": sha256_text(long_form),
            "documentation_rubric_sha256": sha256_text(documentation_rubric),
            "targets_sha256": sha256_text(targets_text),
            "model_guidance_url": MODEL_GUIDANCE_URL,
            "prompt_guidance_url": PROMPT_GUIDANCE_URL,
            "prompt_contract_version": PROMPT_CONTRACT_VERSION,
            "target_count": len(assessments),
            "passed_count": passed_count,
            "revision_count": len(assessments) - passed_count,
            "complete": len(assessments) == len(targets),
            "passed": len(assessments) == len(targets) and passed_count == len(targets),
        },
        "assessments": assessments,
    }
    json_path = Path(f"{args.output_stem}.json")
    markdown_path = Path(f"{args.output_stem}.md")
    for path in (json_path, markdown_path):
        if path.exists():
            raise FileExistsError(f"Refusing to overwrite {path}")
        path.parent.mkdir(parents=True, exist_ok=True)
    json_path.write_text(json.dumps(result, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    markdown = render_markdown(result)
    markdown_path.write_text(markdown, encoding="utf-8")
    if args.obsidian_output:
        if args.obsidian_output.exists():
            raise FileExistsError(f"Refusing to overwrite {args.obsidian_output}")
        args.obsidian_output.parent.mkdir(parents=True, exist_ok=True)
        args.obsidian_output.write_text(markdown, encoding="utf-8")


if __name__ == "__main__":
    main()
