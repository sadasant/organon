#!/usr/bin/env python3
"""Verify the finite relational analyzer receipt and attested sources."""

from __future__ import annotations

import hashlib
import json
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
RECEIPT = ROOT / "ontology" / "relational" / "analyzer-receipt.json"
INSTANCE = ROOT / "ontology" / "relational" / "registry-global-instance.json"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def run(*args: str, text: bool = True) -> subprocess.CompletedProcess:
    return subprocess.run(
        args,
        cwd=ROOT,
        check=False,
        capture_output=True,
        text=text,
    )


def main() -> int:
    errors: list[str] = []
    if not RECEIPT.is_file():
        return report(["missing ontology/relational/analyzer-receipt.json"])

    receipt = json.loads(RECEIPT.read_text(encoding="utf-8"))
    instance = json.loads(INSTANCE.read_text(encoding="utf-8"))
    attested_commit = receipt.get("repository_commit", "")
    if not isinstance(attested_commit, str) or len(attested_commit) != 40:
        errors.append("receipt has no full repository_commit")
    else:
        commit_exists = run("git", "cat-file", "-e", f"{attested_commit}^{{commit}}")
        if commit_exists.returncode != 0:
            errors.append(f"attested commit does not exist: {attested_commit}")
        elif run("git", "merge-base", "--is-ancestor", attested_commit, "HEAD").returncode != 0:
            errors.append(f"attested commit is not an ancestor of HEAD: {attested_commit}")

    if receipt.get("result") != "satisfiable":
        errors.append("receipt does not record a satisfiable result")
    if receipt.get("analyzer", {}).get("name") != "Alloy Analyzer":
        errors.append("unexpected analyzer name")
    if receipt.get("analyzer", {}).get("version") != "6.2.0":
        errors.append("unexpected Alloy version")
    if receipt.get("solver", {}).get("name") != "glucose":
        errors.append("unexpected solver")
    if receipt.get("command") != "run NondegenerateGlobalInhabitant for 0 Int":
        errors.append("unexpected Alloy command")

    counts = receipt.get("counts", {})
    expected_counts = {
        "terms": len(instance.get("terms", [])),
        "commitments": len(instance.get("commitments", [])),
        "nodes": len(instance.get("nodes", [])),
        "relation_witnesses": len(instance.get("relation_witnesses", [])),
        "anti_entailments": len(instance.get("anti_entailments", [])),
        "disjoint_classes": len(instance.get("disjoint_classes", [])),
    }
    if counts != expected_counts:
        errors.append(f"receipt counts are stale: expected {expected_counts}, found {counts}")

    digests = receipt.get("source_digests", {})
    if not isinstance(digests, dict) or not digests:
        errors.append("receipt has no source digests")
    else:
        for repository_path, expected_digest in digests.items():
            path = ROOT / repository_path
            if not path.is_file():
                errors.append(f"missing attested source: {repository_path}")
                continue
            if sha256(path) != expected_digest:
                errors.append(f"stale source digest: {repository_path}")
            if len(attested_commit) == 40:
                historical = run("git", "show", f"{attested_commit}:{repository_path}", text=False)
                if historical.returncode != 0:
                    errors.append(f"source absent from attested commit: {repository_path}")
                elif hashlib.sha256(historical.stdout).hexdigest() != expected_digest:
                    errors.append(f"attested commit digest mismatch: {repository_path}")

    if errors:
        return report(errors)
    print(
        "Relational receipt check passed: "
        f"Alloy {receipt['analyzer']['version']}, {receipt['result']}, "
        f"commit {attested_commit[:8]}."
    )
    return 0


def report(errors: list[str]) -> int:
    print("Relational receipt check failed:")
    for error in errors:
        print(f"- {error}")
    return 1


if __name__ == "__main__":
    sys.exit(main())
