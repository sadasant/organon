"""Fail-closed input, snapshot, and provenance contracts."""

from __future__ import annotations

import hashlib
import json
import subprocess
from collections.abc import Iterable
from pathlib import Path


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def read_json(path: Path) -> dict:
    return json.loads(read_text(path))


def sha256_bytes(value: bytes) -> str:
    return hashlib.sha256(value).hexdigest()


def sha256_text(value: str) -> str:
    return sha256_bytes(value.encode("utf-8"))


def sha256_path(path: Path) -> str:
    return sha256_bytes(path.read_bytes())


def canonical_digest(value: object) -> str:
    encoded = json.dumps(
        value, sort_keys=True, separators=(",", ":"), ensure_ascii=False
    ).encode("utf-8")
    return sha256_bytes(encoded)


def resolve_within(root: Path, selector: str | Path, *, label: str) -> Path:
    root = root.resolve()
    candidate = Path(selector)
    if candidate.is_absolute():
        raise ValueError(f"{label} must be relative: {selector}")
    if ".." in candidate.parts:
        raise ValueError(f"{label} escapes via parent traversal: {selector}")
    resolved = (root / candidate).resolve(strict=True)
    try:
        resolved.relative_to(root)
    except ValueError as error:
        raise ValueError(f"{label} escapes its declared root: {selector}") from error
    if not resolved.is_file():
        raise ValueError(f"{label} is not a file: {selector}")
    return resolved


def repository_relative(
    repo_root: Path, path: Path, *, label: str
) -> tuple[Path, str]:
    repo_root = repo_root.resolve()
    resolved = path.resolve(strict=True)
    try:
        relative = resolved.relative_to(repo_root)
    except ValueError as error:
        raise ValueError(f"{label} must live inside the repository: {path}") from error
    return resolved, relative.as_posix()


def git_head(repo_root: Path) -> str:
    return subprocess.run(
        ["git", "-C", str(repo_root), "rev-parse", "HEAD"],
        check=True,
        capture_output=True,
        text=True,
    ).stdout.strip()


def committed_input_manifest(
    repo_root: Path, paths: Iterable[Path]
) -> dict[str, str]:
    manifest: dict[str, str] = {}
    for path in paths:
        resolved, relative = repository_relative(
            repo_root, path, label="governed input"
        )
        tracked = subprocess.run(
            ["git", "-C", str(repo_root), "ls-files", "--error-unmatch", relative],
            capture_output=True,
            text=True,
        )
        if tracked.returncode:
            raise ValueError(f"governed input is not tracked: {relative}")
        committed = subprocess.run(
            ["git", "-C", str(repo_root), "show", f"HEAD:{relative}"],
            check=True,
            capture_output=True,
        ).stdout
        current = resolved.read_bytes()
        if current != committed:
            raise ValueError(f"governed input differs from HEAD: {relative}")
        manifest[relative] = sha256_bytes(current)
    return dict(sorted(manifest.items()))


def methodology_inputs(evals_root: Path) -> list[Path]:
    """Return every shared implementation or methodology file governing a run."""
    paths = sorted((evals_root / "core").glob("*.py"))
    paths.extend(sorted((evals_root / "methodology").glob("*")))
    paths.append(evals_root / "requirements.txt")
    return [path for path in paths if path.is_file()]


def pinned_sources(
    repo_root: Path, source_files: list[str], source_digests: dict[str, str]
) -> tuple[str, dict[str, str], list[Path]]:
    if not source_files or set(source_digests) != set(source_files):
        raise ValueError("source_digests must pin every source_file exactly")
    sections: list[str] = []
    observed: dict[str, str] = {}
    paths: list[Path] = []
    for relative in source_files:
        path = resolve_within(repo_root, relative, label="source selector")
        digest = sha256_path(path)
        if digest != source_digests[relative]:
            raise ValueError(
                f"source digest mismatch for {relative}: "
                f"expected {source_digests[relative]}, got {digest}"
            )
        observed[relative] = digest
        paths.append(path)
        sections.append(f"# SOURCE: {relative}\n\n{read_text(path)}")
    return "\n\n".join(sections), observed, paths
