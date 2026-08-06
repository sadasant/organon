#!/usr/bin/env python3
"""Build a compact, line-addressed source dossier from ontology citations."""

from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
EVALS_ROOT = Path(__file__).resolve().parents[1]
if str(EVALS_ROOT) not in sys.path:
    sys.path.insert(0, str(EVALS_ROOT))

from io_contracts import resolve_within, sha256_path


SOURCE_REF = re.compile(r"(?P<path>[A-Za-z0-9_./-]+\.(?:md|go)):(?P<start>\d+)(?:-(?P<end>\d+))?")


def merge_ranges(ranges: list[tuple[int, int]]) -> list[tuple[int, int]]:
    merged: list[tuple[int, int]] = []
    for start, end in sorted(ranges):
        if merged and start <= merged[-1][1] + 1:
            merged[-1] = (merged[-1][0], max(merged[-1][1], end))
        else:
            merged.append((start, end))
    return merged


def cited_ranges(markdown: str) -> dict[str, list[tuple[int, int]]]:
    found: dict[str, list[tuple[int, int]]] = {}
    for match in SOURCE_REF.finditer(markdown):
        start = int(match.group("start"))
        end = int(match.group("end") or start)
        found.setdefault(match.group("path"), []).append((start, end))
    if not found:
        raise ValueError("ontology contains no path-and-line source citations")
    return {path: merge_ranges(ranges) for path, ranges in sorted(found.items())}


def build(repo: Path, ontology: Path, project: str, expected_commit: str) -> tuple[str, dict]:
    actual_commit = subprocess.run(
        ["git", "-C", str(repo), "rev-parse", "HEAD"],
        check=True,
        capture_output=True,
        text=True,
    ).stdout.strip()
    if actual_commit != expected_commit:
        raise ValueError(f"source checkout commit mismatch: expected {expected_commit}, got {actual_commit}")
    references = cited_ranges(ontology.read_text(encoding="utf-8"))
    sections = [
        "---",
        "type: project-ontology-source-dossier",
        f"project: {project}",
        f"commit: {expected_commit}",
        "generated_from: exact cited line ranges with two lines of context",
        "---",
        "",
        f"# {project} Source Dossier",
        "",
        "Every excerpt is copied from the exact public source commit above. Line numbers preserve upstream coordinates.",
    ]
    index = {
        "schema_version": 1,
        "project": project,
        "commit": expected_commit,
        "files": {},
    }
    for relative, exact_ranges in references.items():
        source = resolve_within(repo, relative, label="cited source path")
        lines = source.read_text(encoding="utf-8").splitlines()
        line_count = len(lines)
        for start, end in exact_ranges:
            if start < 1 or end < start or end > line_count:
                raise ValueError(f"citation outside source bounds: {relative}:{start}-{end}")
        covered = merge_ranges([
            (max(1, start - 2), min(line_count, end + 2))
            for start, end in exact_ranges
        ])
        index["files"][relative] = {
            "sha256": sha256_path(source),
            "line_count": line_count,
            "cited_ranges": [list(item) for item in exact_ranges],
            "covered_ranges": [list(item) for item in covered],
        }
        sections.extend(["", f"## `{relative}`", ""])
        for start, end in covered:
            sections.extend([f"### Lines {start}-{end}", "", "```text"])
            sections.extend(
                f"{number:05d} | {lines[number - 1]}"
                for number in range(start, end + 1)
            )
            sections.extend(["```", ""])
    return "\n".join(sections).rstrip() + "\n", index


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo", type=Path, required=True)
    parser.add_argument("--ontology", type=Path, required=True)
    parser.add_argument("--project", required=True)
    parser.add_argument("--expected-commit", required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--index-output", type=Path, required=True)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    dossier, index = build(args.repo, args.ontology, args.project, args.expected_commit)
    for path in (args.output, args.index_output):
        path.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(dossier, encoding="utf-8")
    args.index_output.write_text(
        json.dumps(index, indent=2, ensure_ascii=False) + "\n", encoding="utf-8"
    )


if __name__ == "__main__":
    main()
