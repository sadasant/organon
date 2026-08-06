"""Coherent, non-overwriting run-directory output contract."""

from __future__ import annotations

import json
from pathlib import Path


class RunWorkspace:
    """Write one run as named artifacts under one directory."""

    def __init__(self, root: Path):
        self.root = root
        self.root.mkdir(parents=True, exist_ok=True)

    def path(self, relative: str) -> Path:
        candidate = Path(relative)
        if candidate.is_absolute() or ".." in candidate.parts:
            raise ValueError(f"run artifact path must be relative: {relative}")
        return self.root / candidate

    def write_text(self, relative: str, value: str) -> Path:
        path = self.path(relative)
        if path.exists():
            raise FileExistsError(f"refusing to overwrite run artifact: {path}")
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(value, encoding="utf-8")
        return path

    def write_json(self, relative: str, value: object) -> Path:
        return self.write_text(
            relative,
            json.dumps(value, indent=2, ensure_ascii=False) + "\n",
        )


def write_projection(path: Path | None, value: str) -> None:
    if path is None:
        return
    if path.exists():
        raise FileExistsError(f"refusing to overwrite projection: {path}")
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(value, encoding="utf-8")

