#!/usr/bin/env python3
"""Project one clean Organon Git tree into an Obsidian-readable mirror."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import shutil
import subprocess
import sys
import tempfile
import uuid
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path


SCRIPT = Path(__file__).resolve()
DEFAULT_SOURCE = SCRIPT.parent.parent
MANIFEST_NAME = "organon-sync-manifest.json"
SCHEMA_VERSION = 1
IGNORABLE_DESTINATION_FILES = {".DS_Store"}


class SyncError(RuntimeError):
    """A condition that makes a safe projection impossible."""


@dataclass(frozen=True)
class FileRecord:
    path: str
    sha256: str
    bytes: int
    executable: bool

    def as_json(self) -> dict:
        return {
            "path": self.path,
            "sha256": self.sha256,
            "bytes": self.bytes,
            "executable": self.executable,
        }


@dataclass(frozen=True)
class Plan:
    added: tuple[str, ...]
    updated: tuple[str, ...]
    removed: tuple[str, ...]
    conflicts: tuple[str, ...]
    unexpected: tuple[str, ...]

    @property
    def in_sync(self) -> bool:
        return not any(
            (self.added, self.updated, self.removed, self.conflicts, self.unexpected)
        )

    @property
    def safe_to_apply(self) -> bool:
        return not self.conflicts and not self.unexpected


def run_git(source: Path, *arguments: str) -> str:
    result = subprocess.run(
        ["git", "-C", str(source), *arguments],
        check=True,
        capture_output=True,
        text=True,
    )
    return result.stdout.strip()


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def tracked_records(source: Path) -> tuple[FileRecord, ...]:
    raw = subprocess.run(
        ["git", "-C", str(source), "ls-files", "-z"],
        check=True,
        capture_output=True,
    ).stdout
    records: list[FileRecord] = []
    for encoded in raw.split(b"\0"):
        if not encoded:
            continue
        relative = encoded.decode("utf-8")
        path = source / relative
        if path.is_symlink():
            raise SyncError(f"tracked symlink cannot enter vault projection: {relative}")
        if not path.is_file():
            raise SyncError(f"tracked path is not a regular file: {relative}")
        mode = path.stat().st_mode
        records.append(
            FileRecord(
                path=relative,
                sha256=sha256(path),
                bytes=path.stat().st_size,
                executable=bool(mode & 0o111),
            )
        )
    return tuple(sorted(records, key=lambda record: record.path))


def assert_clean_source(source: Path) -> None:
    if run_git(source, "status", "--porcelain=v1", "--untracked-files=all"):
        raise SyncError("source worktree is not clean")
    checker = source / "scripts" / "check-structure.py"
    result = subprocess.run(
        [sys.executable, str(checker)],
        cwd=source,
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        detail = result.stdout.strip() or result.stderr.strip()
        raise SyncError(f"source structure check failed:\n{detail}")


def read_manifest(destination: Path) -> dict | None:
    path = destination / MANIFEST_NAME
    if not path.is_file():
        return None
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as error:
        raise SyncError(f"destination manifest is invalid JSON: {error}") from error
    if data.get("schema_version") != SCHEMA_VERSION:
        raise SyncError("destination manifest has an unsupported schema version")
    files = data.get("files")
    if not isinstance(files, list):
        raise SyncError("destination manifest lacks a file list")
    return data


def actual_files(destination: Path) -> dict[str, str]:
    if not destination.exists():
        return {}
    files: dict[str, str] = {}
    for path in sorted(destination.rglob("*")):
        if path.is_symlink():
            raise SyncError(
                f"destination contains a symlink: {path.relative_to(destination)}"
            )
        if not path.is_file():
            continue
        relative = path.relative_to(destination).as_posix()
        if relative == MANIFEST_NAME or relative in IGNORABLE_DESTINATION_FILES:
            continue
        files[relative] = sha256(path)
    return files


def build_plan(
    desired_records: tuple[FileRecord, ...],
    destination: Path,
    manifest: dict | None,
) -> Plan:
    desired = {record.path: record.sha256 for record in desired_records}
    actual = actual_files(destination)
    previous = {
        item["path"]: item["sha256"]
        for item in (manifest or {}).get("files", [])
        if isinstance(item, dict) and "path" in item and "sha256" in item
    }

    unexpected = sorted(set(actual) - set(previous))
    conflicts: list[str] = []
    for relative, previous_hash in previous.items():
        actual_hash = actual.get(relative)
        desired_hash = desired.get(relative)
        if actual_hash is None or actual_hash == previous_hash or actual_hash == desired_hash:
            continue
        conflicts.append(relative)

    added = sorted(relative for relative in desired if relative not in actual)
    updated = sorted(
        relative
        for relative, digest in desired.items()
        if relative in actual and actual[relative] != digest and relative not in conflicts
    )
    removed = sorted(relative for relative in previous if relative not in desired)
    return Plan(
        added=tuple(added),
        updated=tuple(updated),
        removed=tuple(removed),
        conflicts=tuple(sorted(conflicts)),
        unexpected=tuple(unexpected),
    )


def source_identity(source: Path) -> dict:
    structure = json.loads((source / "organon-structure.json").read_text(encoding="utf-8"))
    return {
        "repository": structure["canonical_source"]["repository"],
        "branch": run_git(source, "branch", "--show-current"),
        "commit": run_git(source, "rev-parse", "HEAD"),
        "dirty": False,
    }


def make_manifest(source: Path, records: tuple[FileRecord, ...]) -> dict:
    return {
        "schema_version": SCHEMA_VERSION,
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "source": source_identity(source),
        "files": [record.as_json() for record in records],
    }


def write_json(path: Path, data: dict) -> None:
    path.write_text(json.dumps(data, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def stage_projection(
    source: Path,
    destination: Path,
    records: tuple[FileRecord, ...],
    manifest: dict,
) -> Path:
    destination.parent.mkdir(parents=True, exist_ok=True)
    stage = Path(
        tempfile.mkdtemp(prefix=f".{destination.name}.sync-", dir=destination.parent)
    )
    try:
        for record in records:
            source_path = source / record.path
            target = stage / record.path
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(source_path, target)
        write_json(stage / MANIFEST_NAME, manifest)
        return stage
    except Exception:
        shutil.rmtree(stage, ignore_errors=True)
        raise


def swap_projection(stage: Path, destination: Path) -> None:
    backup = destination.parent / f".{destination.name}.backup-{uuid.uuid4().hex}"
    had_destination = destination.exists()
    try:
        if had_destination:
            destination.rename(backup)
        stage.rename(destination)
    except Exception:
        if not destination.exists() and backup.exists():
            backup.rename(destination)
        raise
    else:
        if backup.exists():
            shutil.rmtree(backup)


def write_status_note(path: Path, manifest: dict) -> None:
    source = manifest["source"]
    body = (
        "# Organon mirror status\n\n"
        f"- Status: synchronized\n"
        f"- Repository: `{source['repository']}`\n"
        f"- Branch: `{source['branch']}`\n"
        f"- Commit: `{source['commit']}`\n"
        f"- Files: {len(manifest['files'])}\n"
        f"- Synchronized at: `{manifest['generated_at']}`\n\n"
        "The `Contexts/Organon` tree is a one-way projection. Record private "
        "notes and proposed edits in this workspace rather than editing the "
        "projection directly.\n"
    )
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(f".{path.name}.{uuid.uuid4().hex}.tmp")
    temporary.write_text(body, encoding="utf-8")
    os.replace(temporary, path)


def print_plan(plan: Plan) -> None:
    print(
        "plan: "
        f"{len(plan.added)} add, {len(plan.updated)} update, "
        f"{len(plan.removed)} remove, {len(plan.conflicts)} conflict, "
        f"{len(plan.unexpected)} unexpected"
    )
    for label, values in (
        ("ADD", plan.added),
        ("UPDATE", plan.updated),
        ("REMOVE", plan.removed),
        ("CONFLICT", plan.conflicts),
        ("UNEXPECTED", plan.unexpected),
    ):
        for value in values:
            print(f"{label}\t{value}")


def execute(command: str, source: Path, destination: Path, status_note: Path | None) -> int:
    source = source.expanduser().resolve()
    destination = destination.expanduser().resolve()
    if destination == source or source in destination.parents or destination in source.parents:
        raise SyncError("source and destination must be separate directory trees")

    records = tracked_records(source)
    manifest = read_manifest(destination)
    plan = build_plan(records, destination, manifest)

    if command == "plan":
        print_plan(plan)
        return 0 if plan.safe_to_apply else 1
    if command == "status":
        print_plan(plan)
        return 0 if plan.in_sync else 1
    if command == "verify":
        if manifest is None:
            raise SyncError("destination has no sync manifest")
        print_plan(plan)
        if not plan.in_sync:
            return 1
        print(
            f"verified {len(records)} files at "
            f"{manifest['source'].get('commit', 'UNKNOWN')}"
        )
        return 0
    if command != "apply":
        raise SyncError(f"unsupported command {command}")

    assert_clean_source(source)
    if destination.exists() and manifest is None:
        raise SyncError(
            "destination exists without a sync manifest; preserve or remove it explicitly"
        )
    if not plan.safe_to_apply:
        print_plan(plan)
        raise SyncError("destination contains conflicts or unmanaged files")

    new_manifest = make_manifest(source, records)
    stage = stage_projection(source, destination, records, new_manifest)
    try:
        swap_projection(stage, destination)
    finally:
        if stage.exists():
            shutil.rmtree(stage, ignore_errors=True)
    if status_note is not None:
        write_status_note(status_note.expanduser().resolve(), new_manifest)
    print(
        f"synchronized {len(records)} files from "
        f"{new_manifest['source']['commit']} to {destination}"
    )
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=("status", "plan", "apply", "verify"))
    parser.add_argument("--source", type=Path, default=DEFAULT_SOURCE)
    parser.add_argument("--destination", type=Path, required=True)
    parser.add_argument(
        "--status-note",
        type=Path,
        help="Private workspace Markdown note updated after a successful apply",
    )
    args = parser.parse_args()
    try:
        return execute(args.command, args.source, args.destination, args.status_note)
    except (SyncError, OSError, subprocess.CalledProcessError, KeyError) as error:
        print(f"sync failed: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
