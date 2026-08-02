#!/usr/bin/env python3
"""Validate an Organon adoption manifest with standard-library Python."""

from __future__ import annotations

import argparse
import glob
import json
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
TERMS = next(
    path
    for path in (ROOT / "ontology" / "terms.yaml", ROOT / "Ontology" / "terms.yaml")
    if path.exists()
)
PROFILES = next(
    path
    for path in (ROOT / "ontology" / "profiles.json", ROOT / "Ontology" / "profiles.json")
    if path.exists()
)


def dependency_closure(roots: list[str], dependencies: dict[str, list[str]]) -> set[str]:
    closure: set[str] = set()
    pending = list(roots)
    while pending:
        term = pending.pop()
        if term in closure:
            continue
        closure.add(term)
        pending.extend(dependencies[term])
    return closure


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("manifest", type=Path)
    parser.add_argument("--repo-root", type=Path)
    args = parser.parse_args()

    manifest = json.loads(args.manifest.read_text(encoding="utf-8"))["organon"]
    terms = json.loads(TERMS.read_text(encoding="utf-8"))
    profiles = json.loads(PROFILES.read_text(encoding="utf-8"))
    known_terms = {term["id"] for term in terms["terms"]}
    dependencies = {term["id"]: term["depends_on"] for term in terms["terms"]}
    known_profiles = profiles["profiles"]
    errors: list[str] = []

    required = {"source", "version", "revision", "profiles", "governed_paths"}
    missing = sorted(required - manifest.keys())
    if missing:
        errors.append(f"missing required keys: {', '.join(missing)}")
    if manifest.get("version") != terms["ontology_version"]:
        errors.append(
            f"version {manifest.get('version')} does not match registry {terms['ontology_version']}"
        )

    selected = manifest.get("profiles", [])
    for profile in selected:
        if profile not in known_profiles:
            errors.append(f"unknown profile: {profile}")

    roots = [root for profile in selected if profile in known_profiles for root in known_profiles[profile]["roots"]]
    closure = dependency_closure(roots, dependencies) if roots else set()

    for mapping in manifest.get("mappings", []):
        term = mapping.get("term")
        if term not in known_terms:
            errors.append(f"mapping {mapping.get('local')}: unknown term {term}")
        elif term not in closure:
            errors.append(f"mapping {mapping.get('local')}: {term} is outside selected profiles")
        if mapping.get("relation") not in {"exact", "refinement", "conflict", "unmapped"}:
            errors.append(f"mapping {mapping.get('local')}: invalid relation")

    if args.repo_root:
        repo_root = args.repo_root.resolve()
        for pattern in manifest.get("governed_paths", []):
            matches = glob.glob(str(repo_root / pattern), recursive=True)
            if not matches:
                errors.append(f"governed path matches nothing: {pattern}")

    if errors:
        print("Adoption check failed:")
        for error in errors:
            print(f"- {error}")
        return 1

    print(
        f"Adoption check passed: {len(selected)} profiles, "
        f"{len(closure)} terms in dependency closure."
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
