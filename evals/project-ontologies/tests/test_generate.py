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
    assert args.max_deterministic_attempts == 3
    assert args.targets == ROOT / "inputs" / "targets.json"


def test_target_selection_is_exact():
    target = MODULE.select_target(
        ROOT / "inputs" / "targets.json", "kenogram-project-ontology"
    )
    assert target["project"] == "Kenogram"


def test_deterministic_failure_is_fed_to_a_bounded_retry(monkeypatch):
    calls = []

    class Draft:
        def __init__(self, markdown):
            self.draft = {"markdown": markdown}

    def program(**kwargs):
        calls.append(kwargs)
        return Draft("missing manifest" if len(calls) == 1 else "valid candidate")

    monkeypatch.setattr(
        MODULE.JUDGE,
        "deterministic_checks",
        lambda _target, markdown, *_args: (
            {"passed": True, "checks": {"manifest": True}}
            if markdown == "valid candidate"
            else (_ for _ in ()).throw(ValueError("missing mapping manifest"))
        ),
    )
    draft, deterministic, attempts = MODULE.generate_valid_draft(
        program,
        target={"id": "example"},
        ontology="ontology",
        registry_json="{}",
        documentation_rubric="rubric",
        source_dossier="dossier",
        current_candidate="",
        improvement_plan_json="{}",
        known_ids=set(),
        line_counts={},
        covered_ranges={},
        max_attempts=2,
    )
    assert draft["markdown"] == "valid candidate"
    assert deterministic["passed"] is True
    assert attempts == 2
    assert "missing mapping manifest" in calls[1]["target_json"]
