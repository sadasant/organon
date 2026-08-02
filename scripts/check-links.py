#!/usr/bin/env python3
"""Reject repository-facing Markdown dependencies that escape Organon."""

from __future__ import annotations

import re
import subprocess
import sys
from pathlib import Path
from urllib.parse import unquote


ROOT = Path(__file__).resolve().parent.parent
HISTORICAL_PREFIX = "ontology/history/"
WIKILINK = re.compile(r"!?\[\[[^]]+\]\]")
MARKDOWN_LINK = re.compile(r"!?\[[^]]*\]\(([^)]+)\)")
SCHEME = re.compile(r"^[A-Za-z][A-Za-z0-9+.-]*:")
INLINE_CODE = re.compile(r"`[^`]*`")


def repository_markdown() -> list[Path]:
    result = subprocess.run(
        ["git", "ls-files", "--cached", "--", "*.md"],
        cwd=ROOT,
        check=True,
        capture_output=True,
        text=True,
    )
    return [ROOT / line for line in result.stdout.splitlines() if line]


def visible_lines(path: Path) -> list[tuple[int, str]]:
    visible: list[tuple[int, str]] = []
    fenced = False
    for number, raw in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        if raw.lstrip().startswith("```"):
            fenced = not fenced
            continue
        if not fenced:
            visible.append((number, INLINE_CODE.sub("", raw)))
    return visible


def local_target(raw: str) -> str | None:
    target = raw.strip()
    if target.startswith("<") and target.endswith(">"):
        target = target[1:-1]
    if " " in target:
        target = target.split(" ", 1)[0]
    if not target or target.startswith("#") or SCHEME.match(target):
        return None
    return unquote(target.split("#", 1)[0].split("?", 1)[0])


def main() -> int:
    errors: list[str] = []
    root = ROOT.resolve()

    for path in repository_markdown():
        relative = path.relative_to(ROOT).as_posix()
        if relative.startswith(HISTORICAL_PREFIX):
            if "Historical vault artifact" not in path.read_text(encoding="utf-8"):
                errors.append(f"{relative}: historical exemption lacks provenance notice")
            continue

        for number, line in visible_lines(path):
            if WIKILINK.search(line):
                errors.append(f"{relative}:{number}: Obsidian wikilink in active document")
            if "Contexts/" in line:
                errors.append(f"{relative}:{number}: private vault path in active document")

            for match in MARKDOWN_LINK.finditer(line):
                target = local_target(match.group(1))
                if target is None:
                    continue
                resolved = (path.parent / target).resolve()
                try:
                    resolved.relative_to(root)
                except ValueError:
                    errors.append(f"{relative}:{number}: link escapes repository: {target}")
                    continue
                if not resolved.exists():
                    errors.append(f"{relative}:{number}: missing local target: {target}")

    if errors:
        print("Repository boundary check failed:")
        for error in errors:
            print(f"- {error}")
        return 1

    print("Repository boundary check passed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
