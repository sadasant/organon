"""Shared final-result envelope validation."""

from __future__ import annotations

import re

from . import METHODOLOGY_VERSION


HEX_40 = re.compile(r"^[0-9a-f]{40}$")
HEX_64 = re.compile(r"^[0-9a-f]{64}$")


def validate_evaluation_result(result: dict) -> None:
    if result.get("schema_version") != 2:
        raise ValueError("final evaluation schema_version must be 2")
    run = result.get("run")
    if not isinstance(run, dict):
        raise ValueError("final evaluation requires a run object")
    required = {
        "evaluation",
        "methodology_version",
        "stages",
        "organon_commit",
        "committed_inputs_sha256",
        "complete",
        "passed",
    }
    missing = required - set(run)
    if missing:
        raise ValueError(f"final evaluation run is missing: {sorted(missing)}")
    if run["methodology_version"] != METHODOLOGY_VERSION:
        raise ValueError("final evaluation methodology version mismatch")
    stages = run["stages"]
    if not isinstance(stages, list) or len(stages) < 4 or len(stages) != len(set(stages)):
        raise ValueError("final evaluation requires four or more unique stages")
    if not HEX_40.fullmatch(run["organon_commit"]):
        raise ValueError("final evaluation requires an exact Git commit")
    manifest = run["committed_inputs_sha256"]
    if not isinstance(manifest, dict) or not manifest:
        raise ValueError("final evaluation requires committed input digests")
    if not all(HEX_64.fullmatch(value) for value in manifest.values()):
        raise ValueError("committed input manifest contains a non-SHA-256 value")
    if not isinstance(result.get("improvement_plans"), list):
        raise ValueError("final evaluation requires improvement_plans")

