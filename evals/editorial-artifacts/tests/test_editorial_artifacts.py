import importlib.util
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location("organon_editorial_eval", ROOT / "run.py")
assert SPEC and SPEC.loader
MODULE = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = MODULE
SPEC.loader.exec_module(MODULE)


def draft_with_words(count: int = 900):
    return MODULE.LongFormDraft(
        title="An instrument",
        reader_start="The reader recognizes a vocabulary failure.",
        consequential_missingness="No shared distinction survives repository boundaries.",
        honored_resistance=["A local vocabulary may be better."],
        deliveries=[
            "A shared word becomes infrastructure only when its mapping, authority, "
            "and revision conditions remain inspectable by every adopting project."
        ],
        inheritance="Ask which definition and authority produced a classification.",
        source_anchors=["README.md", "ontology/ontology.md"],
        markdown=" ".join(["word"] * count),
    )


def test_deterministic_contract_accepts_complete_draft():
    result = MODULE.deterministic_checks(
        draft_with_words(), {"README.md", "ontology/ontology.md"}
    )
    assert result["passed"]
    assert result["word_count"] == 900


def test_deterministic_contract_rejects_undeclared_source():
    draft = draft_with_words()
    draft.source_anchors.append("private-note.md")
    result = MODULE.deterministic_checks(
        draft, {"README.md", "ontology/ontology.md"}
    )
    assert not result["passed"]
    assert not result["checks"]["source_anchors_declared"]


def test_deterministic_contract_rejects_underspecified_delivery():
    draft = draft_with_words()
    draft.deliveries = ["Vocabulary matters."]
    result = MODULE.deterministic_checks(
        draft, {"README.md", "ontology/ontology.md"}
    )
    assert not result["passed"]
    assert not result["checks"]["deliveries_word_range_15_100"]


def test_judgment_gate_requires_all_scores_at_least_three():
    judgment = {
        "term_fidelity": 3,
        "dependency_and_anti_collapse": 3,
        "epistemic_boundary": 4,
        "source_traceability": 3,
        "critical_violations": [],
        "evidence": "Exact.",
        "revision": "",
    }
    assert MODULE.judgment_passed(judgment)
    judgment["term_fidelity"] = 2
    assert not MODULE.judgment_passed(judgment)


def test_target_file_defines_unique_digest_pinned_targets():
    import json

    targets = json.loads((ROOT / "targets.json").read_text())["targets"]
    assert len(targets) == 4
    assert len({target["id"] for target in targets}) == len(targets)
    for target in targets:
        dossier, digests = MODULE.source_dossier(target)
        assert dossier
        assert set(digests) == set(target["source_files"])
        for path, expected in target.get("source_digests", {}).items():
            assert digests[path] == expected


def test_target_specific_word_range_is_enforced():
    target = {"word_range": [1000, 1200]}
    result = MODULE.deterministic_checks(
        draft_with_words(900), {"README.md", "ontology/ontology.md"}, target
    )
    assert not result["passed"]
    assert result["required_word_range"] == [1000, 1200]


def test_source_digest_mismatch_fails_closed(tmp_path, monkeypatch):
    source = tmp_path / "README.md"
    source.write_text("source\n")
    monkeypatch.setattr(MODULE, "ROOT", tmp_path)
    target = {
        "source_files": ["README.md"],
        "source_digests": {"README.md": "0" * 64},
    }
    try:
        MODULE.source_dossier(target)
    except ValueError as error:
        assert "source digest mismatch" in str(error)
    else:
        raise AssertionError("digest mismatch should fail closed")


def test_target_ids_are_path_safe():
    import json
    import re

    targets = json.loads((ROOT / "targets.json").read_text())["targets"]
    assert all(
        re.fullmatch(r"[a-z0-9]+(?:-[a-z0-9]+)*", target["id"])
        for target in targets
    )


def test_default_models_are_gpt_5_6_sol(monkeypatch):
    monkeypatch.setattr(sys, "argv", ["run.py", "--output-stem", "results/test"])
    args = MODULE.parse_args()
    assert args.generator_model == "gpt-5.6-sol"
    assert args.judge_model == "gpt-5.6-sol"
    assert args.request_timeout == 600.0


def test_delivery_judge_context_excludes_artifact_word_range():
    target = {
        "id": "readme",
        "audience": "operator",
        "purpose": "replace the README",
        "word_range": [1800, 3200],
    }
    context = MODULE.delivery_target(target)
    assert "word_range" not in context
    assert context["delivery_contract"]["word_range"] == [15, 100]
    assert context["delivery_contract"]["artifact_completeness_out_of_scope"]


def test_gpt_5_6_prompt_guidance_is_versioned():
    assert MODULE.PROMPT_CONTRACT_VERSION == "gpt-5.6-v1"
    assert MODULE.PROMPT_GUIDANCE_URL.endswith("prompt-guidance-gpt-5p6.md")
