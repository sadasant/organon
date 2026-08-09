import importlib.util
import json
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
SCRIPT = ROOT / "scripts" / "build-ontology-prompt.py"


def load_builder():
    spec = importlib.util.spec_from_file_location("build_ontology_prompt", SCRIPT)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def test_full_projection_covers_registry_and_is_current():
    registry = json.loads((ROOT / "ontology" / "terms.yaml").read_text())
    prompt, manifest = load_builder().build([])
    assert manifest["term_count"] == len(registry["terms"]) == 109
    assert manifest["commitment_count"] == len(registry["commitments"]) == 42
    assert "`organon:Absence`" in prompt
    assert "`C31`" in prompt
    subprocess.run([sys.executable, str(SCRIPT), "--check"], cwd=ROOT, check=True)


def test_selected_projection_is_dependency_closed_and_ordered():
    builder = load_builder()
    registry = json.loads((ROOT / "ontology" / "terms.yaml").read_text())
    selected = builder.dependency_closure(registry["terms"], ["organon:Agent"])
    ids = [term["id"] for term in selected]
    positions = {term_id: index for index, term_id in enumerate(ids)}
    assert ids[-1] == "organon:Agent"
    assert ids[0] == "organon:Absence"
    assert "organon:Price" not in ids
    for term in selected:
        assert all(positions[dependency] < positions[term["id"]] for dependency in term["depends_on"])
    prompt, manifest = builder.build(["organon:Agent"])
    assert manifest["projection_mode"] == "dependency-closed-selection"
    assert manifest["term_count"] < manifest["registry_term_count"]
    assert "`organon:Agent`" in prompt
    assert "`organon:Price`" not in prompt


def test_selected_projection_rejects_unknown_term():
    builder = load_builder()
    try:
        builder.build(["organon:NotRegistered"])
    except ValueError as error:
        assert "unknown selected term" in str(error)
    else:
        raise AssertionError("unknown term was accepted")
