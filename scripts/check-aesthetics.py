#!/usr/bin/env python3
"""Run Aesthetics with complete authored-change evidence or fail before judging.

Generated projections are checked reproducibly by Verify/Glyph study instead.
Unlike Aesthetics' files.exclude, positional paths also filter the aggregate diff.
Retained reviews, changelogs, catalog inputs and generators are never omitted.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import subprocess


# Exact generated outputs, not directories that could acquire authored files.
GENERATED = {
    "ontology/prompt.md",
    "ontology/prompt-manifest.json",
    "ontology/algebra/coverage.md",
    "ontology/algebra/mutations.yaml",
    "ontology/algebra/fixtures/witnesses.yaml",
    "ontology/algebra/fixtures/countermodels.yaml",
    "ontology/algebra/constructor-ledger.yaml",
    "ontology/algebra/positive-calculus-report.md",
    "ontology/algebra/reduction-ledger.yaml",
    "ontology/algebra/complete-reduction-report.md",
    "proposals/glyph-atlas.md",
    "proposals/unicode-vocabulary-atlas.md",
    "proposals/glyph-assets/specimen.svg",
    "proposals/glyph-assets/OrganonSymbols.ttf",
    "proposals/glyph-assets/OrganonSymbols.woff2",
}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--base", help="Compare committed HEAD to this branch's merge base")
    parser.add_argument("paths", nargs="*", help="Paths for a manual file audit")
    args = parser.parse_args()
    if args.base and args.paths:
        parser.error("a PR review includes every authored changed path; do not supply paths")

    paths = args.paths
    omitted = []
    if args.base:
        changed = subprocess.check_output(
            ["git", "diff", "--name-only", "-z", f"{args.base}...HEAD"], text=True
        ).split("\0")[:-1]
        omitted = [path for path in changed if path in GENERATED]
        paths = [path for path in changed if path not in GENERATED]
        if not paths:
            print("No authored changes; generated outputs are covered by Verify/Glyph study.")
            return 0

    command = ["aesthetics", "check", *paths]
    if args.base:
        command += ["--base", args.base]
    plan = json.loads(subprocess.check_output(
        [*command, "--dry-run", "--format", "json"], text=True
    ))
    plan["generated_outputs_checked_elsewhere"] = omitted
    Path("aesthetics-plan.json").write_text(json.dumps(plan, indent=2) + "\n")
    print(f"Reviewing {len(paths)} selected paths; omitted generated outputs: {omitted}", flush=True)
    truncated = [artifact["path"] for artifact in plan["artifacts"] if artifact["truncated"]]
    if truncated:
        print(f"Incomplete Aesthetics evidence; refusing to judge truncated artifacts: {truncated}")
        return 3
    return subprocess.run([
        *command, "--color", "never", "--record", "aesthetics-record.json",
    ]).returncode


if __name__ == "__main__":
    raise SystemExit(main())
