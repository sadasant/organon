import importlib.util
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location("organon_essay_refine", ROOT / "refine.py")
assert SPEC and SPEC.loader
MODULE = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = MODULE
SPEC.loader.exec_module(MODULE)


def test_merge_revisions_preserves_passing_answers_and_order():
    original = [
        {"question_id": "AA-1", "answer": "keep"},
        {"question_id": "AA-2", "answer": "replace"},
        {"question_id": "AA-3", "answer": "keep too"},
    ]
    revised = [{"question_id": "AA-2", "answer": "revised"}]
    merged = MODULE.merge_revisions(original, revised, ["AA-2"])
    assert [item["question_id"] for item in merged] == ["AA-1", "AA-2", "AA-3"]
    assert [item["answer"] for item in merged] == ["keep", "revised", "keep too"]


def test_merge_revisions_rejects_unrequested_id():
    import pytest

    with pytest.raises(ValueError, match="Expected revised IDs"):
        MODULE.merge_revisions(
            [{"question_id": "AA-1", "answer": "a"}],
            [{"question_id": "AA-2", "answer": "b"}],
            ["AA-1"],
        )
