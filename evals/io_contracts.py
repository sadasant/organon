"""Fail-closed filesystem and repository provenance contracts for eval runners."""

from __future__ import annotations

import hashlib
import subprocess
from pathlib import Path
from typing import Iterable


def sha256_bytes(value: bytes) -> str:
    return hashlib.sha256(value).hexdigest()


def sha256_text(value: str) -> str:
    return sha256_bytes(value.encode("utf-8"))


def sha256_path(path: Path) -> str:
    return sha256_bytes(path.read_bytes())


def resolve_within(root: Path, selector: str | Path, *, label: str) -> Path:
    """Resolve one relative file selector beneath root, including symlink targets."""
    raw = Path(selector)
    if raw.is_absolute():
        raise ValueError(f"{label} must be relative to {root}")
    if ".." in raw.parts:
        raise ValueError(f"{label} escapes {root}: {selector}")
    resolved_root = root.resolve(strict=True)
    candidate = (resolved_root / raw).resolve(strict=True)
    try:
        candidate.relative_to(resolved_root)
    except ValueError as error:
        raise ValueError(f"{label} escapes {resolved_root}: {selector}") from error
    if not candidate.is_file():
        raise ValueError(f"{label} must resolve to a file: {selector}")
    return candidate


def repository_relative(repo_root: Path, path: Path, *, label: str) -> tuple[Path, str]:
    resolved_root = repo_root.resolve(strict=True)
    resolved = path.resolve(strict=True)
    try:
        relative = resolved.relative_to(resolved_root).as_posix()
    except ValueError as error:
        raise ValueError(f"{label} is outside repository {resolved_root}: {path}") from error
    if not resolved.is_file():
        raise ValueError(f"{label} must be a file: {path}")
    return resolved, relative


def git_head(repo_root: Path) -> str:
    return subprocess.run(
        ["git", "-C", str(repo_root), "rev-parse", "HEAD"],
        check=True,
        capture_output=True,
        text=True,
    ).stdout.strip()


def committed_input_manifest(repo_root: Path, paths: Iterable[Path]) -> dict[str, str]:
    """Require every control input to equal the blob recorded at repository HEAD."""
    manifest: dict[str, str] = {}
    for path in paths:
        resolved, relative = repository_relative(
            repo_root, path, label="evaluation control input"
        )
        subprocess.run(
            ["git", "-C", str(repo_root), "ls-files", "--error-unmatch", "--", relative],
            check=True,
            capture_output=True,
        )
        head_bytes = subprocess.run(
            ["git", "-C", str(repo_root), "show", f"HEAD:{relative}"],
            check=True,
            capture_output=True,
        ).stdout
        current_bytes = resolved.read_bytes()
        if current_bytes != head_bytes:
            raise RuntimeError(
                f"evaluation control input differs from HEAD: {relative}; "
                "commit the exact runner and prompt inputs before execution"
            )
        manifest[relative] = sha256_bytes(current_bytes)
    return dict(sorted(manifest.items()))
