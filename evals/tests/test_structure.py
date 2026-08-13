from __future__ import annotations

import importlib.util
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]


def load_script(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


STRUCTURE = load_script("organon_check_structure", ROOT / "scripts" / "check-structure.py")


def test_repository_structure_contract_passes() -> None:
    assert STRUCTURE.check_repository() == []


def test_numbered_sync_sibling_is_rejected() -> None:
    errors = STRUCTURE.check_portable_paths(["ontology/ontology 2.md"])
    assert errors == ["ontology/ontology 2.md: sync-style numbered sibling"]


def test_reserved_filename_is_rejected() -> None:
    errors = STRUCTURE.check_portable_paths(["notes/CON.md"])
    assert errors == ["notes/CON.md: Windows reserved device name"]
