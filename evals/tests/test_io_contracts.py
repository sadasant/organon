import subprocess
from pathlib import Path

import pytest

import sys


EVALS_ROOT = Path(__file__).resolve().parents[1]
if str(EVALS_ROOT) not in sys.path:
    sys.path.insert(0, str(EVALS_ROOT))

from io_contracts import committed_input_manifest, resolve_within


def test_resolve_within_rejects_absolute_traversal_and_escaping_symlink(tmp_path):
    root = tmp_path / "root"
    root.mkdir()
    safe = root / "safe.md"
    safe.write_text("safe\n")
    outside = tmp_path / "outside.md"
    outside.write_text("outside\n")
    (root / "escape.md").symlink_to(outside)

    assert resolve_within(root, "safe.md", label="input") == safe
    with pytest.raises(ValueError, match="must be relative"):
        resolve_within(root, outside, label="input")
    with pytest.raises(ValueError, match="escapes"):
        resolve_within(root, "../outside.md", label="input")
    with pytest.raises(ValueError, match="escapes"):
        resolve_within(root, "escape.md", label="input")


def test_committed_input_manifest_rejects_dirty_control_input(tmp_path):
    subprocess.run(["git", "init", "-q", str(tmp_path)], check=True)
    control = tmp_path / "control.md"
    control.write_text("recorded\n")
    subprocess.run(["git", "-C", str(tmp_path), "add", "control.md"], check=True)
    subprocess.run(
        [
            "git", "-C", str(tmp_path), "-c", "user.name=Test",
            "-c", "user.email=test@example.invalid", "commit", "-qm", "record input",
        ],
        check=True,
    )
    assert "control.md" in committed_input_manifest(tmp_path, [control])
    control.write_text("dirty\n")
    with pytest.raises(RuntimeError, match="differs from HEAD"):
        committed_input_manifest(tmp_path, [control])
