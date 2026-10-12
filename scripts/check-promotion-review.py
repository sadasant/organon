#!/usr/bin/env python3
"""Verify adversarial review records for schema-v2 promotions.

Contract: the schema-v2 promotion review rules in CONTRIBUTING.md, applied to
reviews/promotion/<proposal>.json. A pending review pins every governed source
byte for byte. Once the reviewed commit is on the default branch the review is
enacted: its pins must still match the reviewed commit, and at HEAD only the
statements of its verified promotion contracts are frozen.
"""

from __future__ import annotations

import hashlib
import json
import re
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
PROPOSALS = ROOT / "proposals"
COMMIT = re.compile(r"^[0-9a-f]{40}$")
SHA256 = re.compile(r"^[0-9a-f]{64}$")
REVIEWED_STATUSES = {"promotion-ready"}
DEFAULT_BRANCH = "origin/main"
FINDING_DISPOSITIONS = {"resolved", "outside-formal-boundary"}


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def git(*args: str, text: bool = True) -> subprocess.CompletedProcess:
    return subprocess.run(
        ("git", *args), cwd=ROOT, capture_output=True, text=text, check=False
    )


def resolve_within_root(relative: str) -> Path | None:
    path = (ROOT / relative).resolve()
    try:
        path.relative_to(ROOT.resolve())
    except ValueError:
        return None
    return path


def enacted(commit: str) -> bool:
    """A review is enacted once its commit is on the default branch.

    Without a default-branch ref the review is treated as pending, which keeps
    the stricter byte-for-byte check.
    """
    return git("merge-base", "--is-ancestor", commit, DEFAULT_BRANCH).returncode == 0


def contract_statement(text: str, statement_id: str) -> str | None:
    """Return the whitespace-normalized statement of one marked contract theorem."""
    marker = f"/-- organon:promotion-contract {statement_id} -/"
    if text.count(marker) != 1:
        return None
    return " ".join(text.split(marker, 1)[1].split(":=", 1)[0].split())


def statement_drift(
    prefix: Path,
    contracts_path: Path,
    reviewed_commit: str,
    sources: dict,
    contract_ids: set[str],
) -> list[str]:
    current = contracts_path.read_text(encoding="utf-8") if contracts_path.is_file() else ""
    reviewed = [
        git("show", f"{reviewed_commit}:{relative}").stdout
        for relative in sources
        if isinstance(relative, str) and relative.endswith(".lean")
    ]
    errors: list[str] = []
    for statement_id in sorted(contract_ids):
        before = {
            statement
            for statement in (contract_statement(text, statement_id) for text in reviewed)
            if statement is not None
        }
        if len(before) != 1:
            errors.append(
                f"{prefix}: {statement_id} has no unique statement in reviewed_commit"
            )
        elif contract_statement(current, statement_id) not in before:
            errors.append(
                f"{prefix}: {statement_id} contract statement changed since review; "
                "a changed contract needs a new promotion review"
            )
    return errors


def check_review(manifest_path: Path) -> list[str]:
    errors: list[str] = []
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    if manifest.get("schema_version") != 2:
        return errors
    if manifest.get("status") not in {"partially-promoted", "promoted"}:
        return errors

    review_selector = manifest.get("promotion_review")
    if not isinstance(review_selector, str):
        return [f"{manifest_path.name}: schema-v2 promotion requires promotion_review"]
    review_path = (manifest_path.parent / review_selector).resolve()
    try:
        review_path.relative_to(ROOT.resolve())
    except ValueError:
        return [f"{manifest_path.name}: promotion_review escapes repository root"]
    if not review_path.is_file():
        return [f"{manifest_path.name}: missing promotion review {review_path}"]

    review = json.loads(review_path.read_text(encoding="utf-8"))
    prefix = review_path.relative_to(ROOT)
    if review.get("schema_version") != 1:
        errors.append(f"{prefix}: unsupported schema_version")
    if review.get("proposal_id") != manifest.get("proposal_id"):
        errors.append(f"{prefix}: proposal_id does not match manifest")
    if review.get("status") not in REVIEWED_STATUSES:
        errors.append(f"{prefix}: review is not promotion-ready")

    reviewed_commit = review.get("reviewed_commit")
    if not isinstance(reviewed_commit, str) or not COMMIT.fullmatch(reviewed_commit):
        errors.append(f"{prefix}: reviewed_commit must be an exact commit")
        return errors
    if git("cat-file", "-e", f"{reviewed_commit}^{{commit}}").returncode != 0:
        errors.append(f"{prefix}: reviewed_commit does not exist")
        return errors
    if git("merge-base", "--is-ancestor", reviewed_commit, "HEAD").returncode != 0:
        errors.append(f"{prefix}: reviewed_commit is not an ancestor of HEAD")

    pending = not enacted(reviewed_commit)

    expected_tree = git("show", "-s", "--format=%T", reviewed_commit).stdout.strip()
    if review.get("reviewed_tree") != expected_tree:
        errors.append(f"{prefix}: reviewed_tree does not match reviewed_commit")

    sources = review.get("source_sha256")
    if not isinstance(sources, dict) or not sources:
        errors.append(f"{prefix}: source_sha256 must pin reviewed source files")
        return errors
    required_sources = {
        manifest_path.relative_to(ROOT).as_posix(),
        (manifest_path.parent / manifest["markdown"]).resolve()
            .relative_to(ROOT.resolve()).as_posix(),
        (manifest_path.parent / manifest["formal_shadow"]).resolve()
            .relative_to(ROOT.resolve()).as_posix(),
        (manifest_path.parent / manifest["promotion_contracts"]).resolve()
            .relative_to(ROOT.resolve()).as_posix(),
        "scripts/check-proposals.py",
        "scripts/check-promotion-review.py",
    }
    for relative in manifest.get("formal_evidence", []):
        evidence_path = (manifest_path.parent / relative).resolve()
        try:
            required_sources.add(evidence_path.relative_to(ROOT.resolve()).as_posix())
        except ValueError:
            errors.append(f"{prefix}: formal_evidence escapes repository root: {relative}")
    missing_sources = sorted(required_sources - set(sources))
    if pending and missing_sources:
        errors.append(f"{prefix}: missing required source pins {missing_sources}")

    for relative, expected in sources.items():
        if not isinstance(relative, str) or not isinstance(expected, str):
            errors.append(f"{prefix}: source pin entries must be strings")
            continue
        if not SHA256.fullmatch(expected):
            errors.append(f"{prefix}: invalid SHA-256 for {relative}")
            continue
        path = resolve_within_root(relative)
        if path is None:
            errors.append(f"{prefix}: invalid reviewed source {relative}")
            continue
        if pending and (not path.is_file() or digest(path) != expected):
            errors.append(f"{prefix}: reviewed source drift for {relative}")
        historical = git("show", f"{reviewed_commit}:{relative}", text=False)
        if historical.returncode != 0:
            errors.append(
                f"{prefix}: {relative} is absent from reviewed_commit"
            )
        elif hashlib.sha256(historical.stdout).hexdigest() != expected:
            errors.append(
                f"{prefix}: {relative} does not match reviewed_commit"
            )

    proved_contracts = {
        statement["id"]
        for statement in manifest.get("statements", [])
        if statement.get("formal_contract", {}).get("status") in {
            "proved", "proved_with_boundaries"
        }
    }
    recorded_contracts = set(review.get("verified_contracts", []))
    if recorded_contracts != proved_contracts:
        errors.append(
            f"{prefix}: verified contract drift; "
            f"missing {sorted(proved_contracts - recorded_contracts)}, "
            f"extra {sorted(recorded_contracts - proved_contracts)}"
        )
    if not pending:
        contracts_path = (manifest_path.parent / manifest["promotion_contracts"]).resolve()
        errors.extend(statement_drift(
            prefix, contracts_path, reviewed_commit, sources,
            recorded_contracts & proved_contracts,
        ))

    findings = review.get("findings")
    if not isinstance(findings, list) or not findings:
        errors.append(f"{prefix}: adversarial review must record findings")
    else:
        ids = [finding.get("id") for finding in findings]
        if len(ids) != len(set(ids)):
            errors.append(f"{prefix}: duplicate finding IDs")
        for finding in findings:
            if finding.get("disposition") not in FINDING_DISPOSITIONS:
                errors.append(
                    f"{prefix}: finding {finding.get('id')} remains unresolved"
                )
            if len(str(finding.get("resolution", "")).strip()) < 20:
                errors.append(
                    f"{prefix}: finding {finding.get('id')} lacks a resolution"
                )

    return errors


def main() -> int:
    errors: list[str] = []
    reviewed = 0
    for manifest_path in sorted(PROPOSALS.glob("*-claims.json")):
        manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
        if manifest.get("schema_version") == 2 and manifest.get("status") in {
            "partially-promoted", "promoted"
        }:
            reviewed += 1
            errors.extend(check_review(manifest_path))
    if errors:
        print("Promotion review check failed:")
        for error in errors:
            print(f"- {error}")
        return 1
    print(f"Promotion review check passed: {reviewed} review(s).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
