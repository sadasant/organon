#!/usr/bin/env python3
"""Verify Organon's declared repository, lifecycle, and hydration structure."""

from __future__ import annotations

import json
import re
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
STRUCTURE = ROOT / "organon-structure.json"
PROPOSAL_LIFECYCLE = ROOT / "proposals" / "lifecycle.json"
PROMPT_MANIFEST = ROOT / "ontology" / "prompt-manifest.json"
EVAL_SUITES = (
    "editorial-artifacts",
    "essay-questions",
    "project-ontologies",
)
ALLOWED_EVALUATION_STATUSES = {"passed", "failed", "incomplete"}
ALLOWED_PROMOTION_STATUSES = {"hold", "proposed", "adopted", "rejected"}
ALLOWED_PROPOSAL_STATUSES = {
    "draft",
    "ready-for-review",
    "partially-promoted",
    "promoted",
    "rejected",
    "superseded",
}
FORBIDDEN_FILENAME_CHARACTERS = set('\\/:*?"<>|')
LINK_UNFRIENDLY_CHARACTERS = set("#^[]")
RESERVED_DEVICE_NAMES = {
    "CON",
    "PRN",
    "AUX",
    "NUL",
    *(f"COM{number}" for number in range(1, 10)),
    *(f"LPT{number}" for number in range(1, 10)),
}
NUMBERED_SIBLING = re.compile(r" .*[ ](?:[2-9]|[1-9][0-9]+)(?:\.[^/]*)?$")


def load_json(path: Path) -> dict:
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as error:
        raise ValueError(f"{path.relative_to(ROOT)}: cannot load JSON: {error}") from error


def repository_paths() -> list[str]:
    result = subprocess.run(
        ["git", "ls-files", "--cached", "--others", "--exclude-standard"],
        cwd=ROOT,
        check=True,
        capture_output=True,
        text=True,
    )
    return [line for line in result.stdout.splitlines() if line]


def check_portable_paths(paths: list[str]) -> list[str]:
    errors: list[str] = []
    for relative in paths:
        if NUMBERED_SIBLING.search(f" {relative}"):
            errors.append(f"{relative}: sync-style numbered sibling")
        for component in Path(relative).parts:
            illegal = sorted(set(component) & FORBIDDEN_FILENAME_CHARACTERS)
            if illegal:
                errors.append(
                    f"{relative}: reserved filename character(s) {''.join(illegal)}"
                )
            if any(ord(character) < 32 for character in component):
                errors.append(f"{relative}: control character in filename")
            if component.endswith((" ", ".")):
                errors.append(f"{relative}: trailing space or period")
            device_candidate = component.rsplit(".", 1)[0]
            if device_candidate.upper() in RESERVED_DEVICE_NAMES:
                errors.append(f"{relative}: Windows reserved device name")
            link_chars = sorted(set(component) & LINK_UNFRIENDLY_CHARACTERS)
            if link_chars:
                errors.append(
                    f"{relative}: Obsidian link character(s) {''.join(link_chars)}"
                )
    return errors


def check_root_manifest(paths: list[str]) -> list[str]:
    errors: list[str] = []
    data = load_json(STRUCTURE)
    if data.get("schema_version") != 1:
        errors.append("organon-structure.json: unsupported schema_version")

    canonical = data.get("canonical_source", {})
    if canonical.get("authority") != "tracked Git tree":
        errors.append("organon-structure.json: canonical authority must be tracked Git tree")
    if canonical.get("branch") != "main":
        errors.append("organon-structure.json: canonical branch must be main")

    regions = data.get("regions", [])
    region_paths = [item.get("path") for item in regions]
    if len(region_paths) != len(set(region_paths)):
        errors.append("organon-structure.json: duplicate region path")
    for item in regions:
        path = item.get("path")
        if not isinstance(path, str) or not path.endswith("/"):
            errors.append(f"organon-structure.json: invalid region path {path!r}")
            continue
        if not item.get("role") or not item.get("hydration"):
            errors.append(f"organon-structure.json: {path} lacks role or hydration rule")

    declared = {path.removesuffix("/") for path in region_paths if isinstance(path, str)}
    actual = {
        path.split("/", 1)[0]
        for path in paths
        if "/" in path
    }
    missing = sorted(actual - declared)
    stale = sorted(declared - actual)
    if missing:
        errors.append(f"organon-structure.json: undeclared top-level regions {missing}")
    if stale:
        errors.append(f"organon-structure.json: declared regions contain no files {stale}")

    for document in data.get("root_documents", []):
        if "/" in document or not (ROOT / document).is_file():
            errors.append(f"organon-structure.json: missing root document {document}")

    return errors


def check_current_evaluations() -> list[str]:
    errors: list[str] = []
    prompt = load_json(PROMPT_MANIFEST)
    ontology_version = prompt.get("ontology_version")
    ontology_sha256 = prompt.get("sources_sha256", {}).get("ontology/ontology.md")

    for suite in EVAL_SUITES:
        base = ROOT / "evals" / suite
        path = base / "current.json"
        data = load_json(path)
        prefix = path.relative_to(ROOT)
        if data.get("schema_version") != 1:
            errors.append(f"{prefix}: unsupported schema_version")
        if data.get("suite") != suite:
            errors.append(f"{prefix}: suite does not match directory")
        if data.get("evaluation_status") not in ALLOWED_EVALUATION_STATUSES:
            errors.append(f"{prefix}: unsupported evaluation_status")
        if data.get("promotion_status") not in ALLOWED_PROMOTION_STATUSES:
            errors.append(f"{prefix}: unsupported promotion_status")
        if data.get("ontology_version") != ontology_version:
            errors.append(f"{prefix}: ontology_version does not match prompt manifest")
        if data.get("ontology_sha256") != ontology_sha256:
            errors.append(f"{prefix}: ontology_sha256 does not match prompt manifest")

        current = base / str(data.get("current_run", ""))
        predecessor = base / str(data.get("predecessor", ""))
        if not current.is_dir() or current.parent != base / "results":
            errors.append(f"{prefix}: current_run must name one results directory")
            continue
        if not predecessor.is_dir() or predecessor.parent != base / "results":
            errors.append(f"{prefix}: predecessor must name one results directory")
        run_record = current / str(data.get("run_record", ""))
        primary = current / str(data.get("primary_artifact", ""))
        if not run_record.is_file():
            errors.append(f"{prefix}: missing run_record {run_record.name}")
            continue
        if not primary.is_file():
            errors.append(f"{prefix}: missing primary_artifact {primary.name}")

        record = load_json(run_record).get("run", {})
        if record.get("complete") is not True:
            errors.append(f"{prefix}: current run is not complete")
        expected_passed = data.get("evaluation_status") == "passed"
        if bool(record.get("passed")) != expected_passed:
            errors.append(f"{prefix}: current run pass state disagrees with pointer")
        if record.get("ontology_sha256") != ontology_sha256:
            errors.append(f"{prefix}: current run uses a different ontology snapshot")
    return errors


def check_proposal_lifecycle() -> list[str]:
    errors: list[str] = []
    lifecycle = load_json(PROPOSAL_LIFECYCLE)
    if lifecycle.get("schema_version") != 1:
        errors.append("proposals/lifecycle.json: unsupported schema_version")
    entries = lifecycle.get("entries", [])
    entry_manifests = [item.get("manifest") for item in entries]
    if len(entry_manifests) != len(set(entry_manifests)):
        errors.append("proposals/lifecycle.json: duplicate manifest entry")

    actual = sorted(path.name for path in (ROOT / "proposals").glob("*-claims.json"))
    if sorted(entry_manifests) != actual:
        errors.append(
            "proposals/lifecycle.json: entries must cover every proposal manifest exactly"
        )
    for item in entries:
        manifest_name = item.get("manifest")
        if not isinstance(manifest_name, str):
            continue
        manifest_path = ROOT / "proposals" / manifest_name
        if not manifest_path.is_file():
            continue
        manifest = load_json(manifest_path)
        status = item.get("status")
        if status not in ALLOWED_PROPOSAL_STATUSES:
            errors.append(f"proposals/lifecycle.json: unsupported status {status}")
        if status != manifest.get("status"):
            errors.append(f"proposals/lifecycle.json: {manifest_name} status drift")
        if item.get("dossier") != manifest.get("markdown"):
            errors.append(f"proposals/lifecycle.json: {manifest_name} dossier drift")
        release = item.get("binding_release")
        if release is not None and not (ROOT / "releases" / f"v{release.replace('.', '-')}.md").is_file():
            errors.append(
                f"proposals/lifecycle.json: {manifest_name} names missing release {release}"
            )
        remaining = item.get("remaining_quarantine")
        if not isinstance(remaining, list) or not all(
            isinstance(value, str) and value for value in remaining
        ):
            errors.append(
                f"proposals/lifecycle.json: {manifest_name} has invalid remaining_quarantine"
            )
    return errors


def check_repository() -> list[str]:
    paths = repository_paths()
    errors = check_portable_paths(paths)
    errors.extend(check_root_manifest(paths))
    errors.extend(check_current_evaluations())
    errors.extend(check_proposal_lifecycle())
    return errors


def main() -> int:
    try:
        errors = check_repository()
    except (ValueError, subprocess.CalledProcessError) as error:
        errors = [str(error)]
    if errors:
        print("Repository structure check failed:")
        for error in errors:
            print(f"- {error}")
        return 1
    print(
        "Repository structure check passed: declared regions, current evals, "
        "proposal lifecycle, and portable paths."
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
