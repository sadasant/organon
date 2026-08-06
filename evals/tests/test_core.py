import json
from pathlib import Path

import pytest

from evals.core.contracts import pinned_sources
from evals.core.improvement import improvement_plan
from evals.core.judging import judgment_passed, score_values
from evals.core.result import validate_evaluation_result
from evals.core.workspace import RunWorkspace


def test_score_contract_rejects_decorative_judgment():
    with pytest.raises(ValueError, match="no integer score"):
        score_values({"critical_violations": [], "evidence": "", "revision": ""})


def test_critical_violation_blocks_high_scores():
    assert not judgment_passed(
        {"fidelity": 4, "critical_violations": ["collapse"], "evidence": "x"}
    )


def test_workspace_refuses_overwrite_and_escape(tmp_path: Path):
    workspace = RunWorkspace(tmp_path / "run")
    workspace.write_json("run.json", {"ok": True})
    assert json.loads((tmp_path / "run" / "run.json").read_text()) == {"ok": True}
    with pytest.raises(FileExistsError):
        workspace.write_json("run.json", {})
    with pytest.raises(ValueError):
        workspace.write_text("../escape.md", "no")


def test_pinned_sources_requires_complete_digest_map(tmp_path: Path):
    (tmp_path / "source.md").write_text("source")
    with pytest.raises(ValueError, match="pin every"):
        pinned_sources(tmp_path, ["source.md"], {})


def test_improvement_plan_does_not_invent_action_for_pass():
    plan = improvement_plan(
        target_id="readme",
        artifact_kind="documentation",
        passed=True,
        layers=[{"name": "ontology", "passed": True}],
        preserve=["commands"],
    )
    assert plan["disposition"] == "hold"
    assert plan["actions"] == []


def test_final_result_requires_exact_provenance_and_improvement_plans():
    result = {
        "schema_version": 2,
        "run": {
            "evaluation": "test",
            "methodology_version": "1.0",
            "stages": ["snapshot", "preflight", "judge", "promote"],
            "organon_commit": "a" * 40,
            "committed_inputs_sha256": {"input.md": "b" * 64},
            "complete": True,
            "passed": False,
        },
        "improvement_plans": [],
    }
    validate_evaluation_result(result)
    result["run"]["organon_commit"] = "main"
    with pytest.raises(ValueError, match="exact Git commit"):
        validate_evaluation_result(result)
