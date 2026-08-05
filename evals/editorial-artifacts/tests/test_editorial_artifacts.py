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


def test_target_file_defines_exactly_two_unique_targets():
    import json

    targets = json.loads((ROOT / "targets.json").read_text())["targets"]
    assert len(targets) == 2
    assert len({target["id"] for target in targets}) == 2
    for target in targets:
        dossier, digests = MODULE.source_dossier(target)
        assert dossier
        assert set(digests) == set(target["source_files"])
