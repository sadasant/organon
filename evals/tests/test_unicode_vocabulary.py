"""The study must cover the pinned vocabulary, not merely have the right row count."""

import importlib.util
import json
from pathlib import Path
import subprocess
import sys

import pytest


ROOT = Path(__file__).resolve().parents[2]
SCRIPT = ROOT / "scripts/check-unicode-vocabulary.py"


def test_unicode_atlas_is_current_and_rejects_duplicate_substitution():
    subprocess.run([sys.executable, str(SCRIPT)], cwd=ROOT, check=True)
    spec = importlib.util.spec_from_file_location("unicode_vocabulary", SCRIPT)
    assert spec and spec.loader
    audit = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(audit)
    catalog = json.loads((ROOT / "proposals/unicode-vocabulary-candidates.json").read_text())
    registry = audit.load_sources(catalog)
    catalog["candidates"][-1] = dict(catalog["candidates"][0])
    with pytest.raises(ValueError, match="coverage mismatch") as failure:
        audit.render(catalog, registry)
    assert "missing=['Respect']" in str(failure.value)
    assert "duplicates=['Absence']" in str(failure.value)
