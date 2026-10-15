import json
import os
import subprocess
from pathlib import Path

import pytest

import sys


EVALS_ROOT = Path(__file__).resolve().parents[1]
if str(EVALS_ROOT) not in sys.path:
    sys.path.insert(0, str(EVALS_ROOT))

from core.contracts import committed_input_manifest, resolve_within


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
    with pytest.raises(ValueError, match="differs from HEAD"):
        committed_input_manifest(tmp_path, [control])


@pytest.mark.parametrize("truncated,judgment_status,expected", [(False, 0, 0), (False, 1, 1), (True, 0, 3)])
def test_aesthetics_preserves_authored_evidence_and_rejects_truncation(
    tmp_path, truncated, judgment_status, expected
):
    def git(*args):
        return subprocess.check_output(["git", *args], cwd=tmp_path, text=True).strip()

    git("init", "-q")
    git("-c", "user.name=Test", "-c", "user.email=test@example.invalid",
        "commit", "--allow-empty", "-qm", "base")
    base = git("rev-parse", "HEAD")
    authored = ["ontology/changelog.md", "proposals/glyph-catalog.mjs",
                "reviews/promotion/review.json", "proposals/glyph-assets/authored note.md"]
    generated = "proposals/glyph-assets/specimen.svg"
    for name in [*authored, generated]:
        path = tmp_path / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text("changed\n")
    git("add", ".")
    git("-c", "user.name=Test", "-c", "user.email=test@example.invalid",
        "commit", "-qm", "change")

    # A local evaluator stands in for the paid service; Git selection is real.
    binary = tmp_path / "aesthetics"
    binary.write_text(f"""#!{sys.executable}
import json, sys
from pathlib import Path
paths = sys.argv[2:sys.argv.index('--base')]
if '--dry-run' in sys.argv:
    print(json.dumps({{'artifacts': [{{'path': p, 'truncated': {truncated}}} for p in paths]}}))
else:
    Path('judged.json').write_text(json.dumps(paths))
    sys.exit({judgment_status})
""")
    binary.chmod(0o755)
    result = subprocess.run(
        [sys.executable, str(EVALS_ROOT.parent / "scripts/check-aesthetics.py"), "--base", base],
        cwd=tmp_path, env={**os.environ, "PATH": f"{tmp_path}:{os.environ['PATH']}"},
        capture_output=True, text=True,
    )
    assert result.returncode == expected, result.stdout + result.stderr
    plan = json.loads((tmp_path / "aesthetics-plan.json").read_text())
    assert {a["path"] for a in plan["artifacts"]} == set(authored)
    assert plan["generated_outputs_checked_elsewhere"] == [generated]
    if truncated:
        assert not (tmp_path / "judged.json").exists()
    else:
        assert set(json.loads((tmp_path / "judged.json").read_text())) == set(authored)
