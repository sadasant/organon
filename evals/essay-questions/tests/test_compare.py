import importlib.util
import sys
from argparse import Namespace
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location("organon_essay_compare", ROOT / "compare.py")
assert SPEC and SPEC.loader
MODULE = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = MODULE
SPEC.loader.exec_module(MODULE)


def test_sentence_count_handles_bounded_answer():
    assert MODULE.sentence_count("One sentence. Another sentence.") == 2


def test_indexes_answers_by_question_id():
    result = {
        "essays": [{
            "title": "Essay",
            "answers": [{"question_id": "AA-1", "answer": "Answer."}],
        }]
    }
    assert MODULE.index_answers(result)["AA-1"][1]["answer"] == "Answer."
