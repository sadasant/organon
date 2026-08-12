from __future__ import annotations

import importlib.util
import json
import subprocess
import sys
from pathlib import Path

import pytest


ROOT = Path(__file__).resolve().parents[2]


def load_script(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


SYNC = load_script("organon_sync_vault", ROOT / "scripts" / "sync-vault.py")


def git(source: Path, *arguments: str) -> None:
    subprocess.run(["git", "-C", str(source), *arguments], check=True, capture_output=True)


def make_source(tmp_path: Path) -> Path:
    source = tmp_path / "source"
    (source / "scripts").mkdir(parents=True)
    (source / "README.md").write_text("# Source\n", encoding="utf-8")
    (source / "organon-structure.json").write_text(
        json.dumps(
            {
                "canonical_source": {
                    "repository": "https://example.invalid/organon",
                    "branch": "main",
                }
            }
        ),
        encoding="utf-8",
    )
    (source / "scripts" / "check-structure.py").write_text(
        "raise SystemExit(0)\n", encoding="utf-8"
    )
    git(source.parent, "init", "source")
    git(source, "config", "user.name", "Organon Test")
    git(source, "config", "user.email", "organon@example.invalid")
    git(source, "add", ".")
    git(source, "commit", "-m", "fixture")
    git(source, "branch", "-M", "main")
    return source


def test_apply_and_verify_projection(tmp_path: Path) -> None:
    source = make_source(tmp_path)
    destination = tmp_path / "vault" / "Contexts" / "Organon"
    status_note = tmp_path / "vault" / "Contexts" / "Organon-Workspace" / "sync-status.md"

    assert SYNC.execute("apply", source, destination, status_note) == 0
    assert (destination / "README.md").read_text(encoding="utf-8") == "# Source\n"
    manifest = json.loads(
        (destination / SYNC.MANIFEST_NAME).read_text(encoding="utf-8")
    )
    assert manifest["source"]["branch"] == "main"
    assert manifest["source"]["dirty"] is False
    assert {item["path"] for item in manifest["files"]} == {
        "README.md",
        "organon-structure.json",
        "scripts/check-structure.py",
    }
    assert status_note.is_file()
    assert SYNC.execute("verify", source, destination, None) == 0


def test_apply_refuses_edited_mirror_file(tmp_path: Path) -> None:
    source = make_source(tmp_path)
    destination = tmp_path / "mirror"
    assert SYNC.execute("apply", source, destination, None) == 0
    (destination / "README.md").write_text("edited in vault\n", encoding="utf-8")

    plan = SYNC.build_plan(
        SYNC.tracked_records(source),
        destination,
        SYNC.read_manifest(destination),
    )
    assert plan.conflicts == ("README.md",)
    with pytest.raises(SYNC.SyncError, match="conflicts or unmanaged files"):
        SYNC.execute("apply", source, destination, None)


def test_apply_refuses_unmanaged_destination(tmp_path: Path) -> None:
    source = make_source(tmp_path)
    destination = tmp_path / "mirror"
    destination.mkdir()
    (destination / "private-note.md").write_text("keep me\n", encoding="utf-8")

    with pytest.raises(SYNC.SyncError, match="without a sync manifest"):
        SYNC.execute("apply", source, destination, None)


def test_apply_removes_only_previously_managed_path(tmp_path: Path) -> None:
    source = make_source(tmp_path)
    destination = tmp_path / "mirror"
    assert SYNC.execute("apply", source, destination, None) == 0
    git(source, "rm", "README.md")
    git(source, "commit", "-m", "remove managed file")

    assert SYNC.execute("apply", source, destination, None) == 0
    assert not (destination / "README.md").exists()
    assert SYNC.execute("verify", source, destination, None) == 0


def test_apply_requires_clean_source(tmp_path: Path) -> None:
    source = make_source(tmp_path)
    destination = tmp_path / "mirror"
    (source / "README.md").write_text("dirty\n", encoding="utf-8")

    with pytest.raises(SYNC.SyncError, match="source worktree is not clean"):
        SYNC.execute("apply", source, destination, None)
