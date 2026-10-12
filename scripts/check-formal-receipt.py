#!/usr/bin/env python3
"""Verify that the Lean build receipt names the compiler CI actually uses.

Contract: ontology/formal/build-receipt.md. CI rebuilds every head with the
pinned toolchain, so the receipt records the toolchain rather than source bytes.
"""

from __future__ import annotations

import re
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
RECEIPT = ROOT / "ontology" / "formal" / "build-receipt.md"
FORMAL_ROOT = RECEIPT.parent
COMPILER_FIELD = re.compile(r"^- Commit: `([0-9a-f]{40})`$", re.MULTILINE)
PIN_FIELD = re.compile(r"^- Project pin: `([^`]+)`$", re.MULTILINE)
LEAN_COMMIT = re.compile(r"commit ([0-9a-f]{40})")


def main() -> int:
    receipt = RECEIPT.read_text(encoding="utf-8")
    errors: list[str] = []

    compiler_match = COMPILER_FIELD.search(receipt)
    pin_match = PIN_FIELD.search(receipt)
    if compiler_match is None:
        errors.append("receipt missing Lean compiler commit")
    if pin_match is None:
        errors.append("receipt missing project toolchain pin")
    if errors:
        return report(errors)

    toolchain = (FORMAL_ROOT / "lean-toolchain").read_text(encoding="utf-8").strip()
    if pin_match.group(1) != toolchain:
        errors.append(
            f"receipt pins {pin_match.group(1)} but lean-toolchain pins {toolchain}; "
            "update the receipt's Toolchain section"
        )

    compiler_commit = compiler_match.group(1)
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
        f"Formal receipt check passed: toolchain {toolchain}, "
        f"compiler {compiler_commit[:8]}."
    )
    return 0


def report(errors: list[str]) -> int:
    print("Formal receipt check failed:")
    for error in errors:
        print(f"- {error}")
    return 1


if __name__ == "__main__":
    sys.exit(main())
