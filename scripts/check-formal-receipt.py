#!/usr/bin/env python3
"""Verify the Lean build receipt against files, Git history, and compiler."""

from __future__ import annotations

import hashlib
import re
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
RECEIPT = ROOT / "ontology" / "formal" / "build-receipt.md"
FORMAL_ROOT = RECEIPT.parent
COMMIT_FIELD = re.compile(r'^repository_commit: "([0-9a-f]{40})"$', re.MULTILINE)
COMPILER_FIELD = re.compile(r"^- Commit: `([0-9a-f]{40})`$", re.MULTILINE)
DIGEST_FIELD = re.compile(r"^- `([^`]+)`: `([0-9a-f]{64})`$", re.MULTILINE)
LEAN_COMMIT = re.compile(r"commit ([0-9a-f]{40})")


def run(*args: str, text: bool = True) -> subprocess.CompletedProcess:
    return subprocess.run(
        args,
        cwd=ROOT,
        check=False,
        capture_output=True,
        text=text,
    )


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def main() -> int:
    receipt = RECEIPT.read_text(encoding="utf-8")
    errors: list[str] = []

    commit_match = COMMIT_FIELD.search(receipt)
    compiler_match = COMPILER_FIELD.search(receipt)
    digests = DIGEST_FIELD.findall(receipt)
    if commit_match is None:
        errors.append("receipt missing repository_commit")
    if compiler_match is None:
        errors.append("receipt missing Lean compiler commit")
    if not digests:
        errors.append("receipt contains no source digests")
    if errors:
        return report(errors)

    attested_commit = commit_match.group(1)
    compiler_commit = compiler_match.group(1)

    commit_exists = run("git", "cat-file", "-e", f"{attested_commit}^{{commit}}")
    if commit_exists.returncode != 0:
        errors.append(f"attested commit does not exist: {attested_commit}")
    else:
        ancestor = run("git", "merge-base", "--is-ancestor", attested_commit, "HEAD")
        if ancestor.returncode != 0:
            errors.append(f"attested commit is not an ancestor of HEAD: {attested_commit}")

    for relative_name, expected in digests:
        current_path = FORMAL_ROOT / relative_name
        if not current_path.is_file():
            errors.append(f"missing receipt source: {relative_name}")
            continue

        current_digest = sha256(current_path.read_bytes())
        if current_digest != expected:
            errors.append(
                f"stale digest for {relative_name}: expected {expected}, "
                f"found {current_digest}"
            )

        repository_path = current_path.relative_to(ROOT).as_posix()
        historical = run(
            "git", "show", f"{attested_commit}:{repository_path}", text=False
        )
        if historical.returncode != 0:
            errors.append(
                f"{relative_name} is absent from attested commit {attested_commit}"
            )
        elif sha256(historical.stdout) != expected:
            errors.append(
                f"{relative_name} digest does not match attested commit "
                f"{attested_commit}"
            )

    lean = subprocess.run(
        ("lean", "--version"),
        cwd=FORMAL_ROOT,
        check=False,
        capture_output=True,
        text=True,
    )
    lean_match = LEAN_COMMIT.search(lean.stdout + lean.stderr)
    if lean.returncode != 0:
        errors.append("lean --version failed")
    elif lean_match is None:
        errors.append("could not read compiler commit from lean --version")
    elif lean_match.group(1) != compiler_commit:
        errors.append(
            f"Lean compiler commit mismatch: expected {compiler_commit}, "
            f"found {lean_match.group(1)}"
        )

    if errors:
        return report(errors)

    print(
        f"Formal receipt check passed: {len(digests)} digest(s), "
        f"commit {attested_commit[:8]}, compiler {compiler_commit[:8]}."
    )
    return 0


def report(errors: list[str]) -> int:
    print("Formal receipt check failed:")
    for error in errors:
        print(f"- {error}")
    return 1


if __name__ == "__main__":
    sys.exit(main())
