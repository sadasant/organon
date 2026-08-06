import importlib.util
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location(
    "organon_project_ontology_generator", ROOT / "generate.py"
)
assert SPEC and SPEC.loader
MODULE = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = MODULE
SPEC.loader.exec_module(MODULE)


def test_generation_defaults_to_sol_and_shared_target_manifest(monkeypatch):
    monkeypatch.setattr(
        sys,
        "argv",
        [
            "generate.py",
            "--target-id",
            "engram-project-ontology",
            "--run-dir",
            "results/test",
        ],
    )
    args = MODULE.parse_args()
    assert args.model == "gpt-5.6-sol"
    assert args.reasoning_effort == "high"
    assert args.targets == ROOT / "inputs" / "targets.json"


def test_target_selection_is_exact():
    target = MODULE.select_target(
        ROOT / "inputs" / "targets.json", "kenogram-project-ontology"
    )
    assert target["project"] == "Kenogram"
