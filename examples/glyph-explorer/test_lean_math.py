import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

import lean_math


class SourceExtraction(unittest.TestCase):
    def test_nested_comments_multiline_conditions_and_named_arguments(self):
        source = """namespace Example
/- Not a field /- nor a declaration -/ -/
structure Witness {Carrier : Type u} (state : Carrier) where
  left : Carrier
  /- Keep the join, not just the two carriers. -/
  joined :
    left = state ∧
      state = left

def valid {Carrier : Type u}
    (w : Witness (Carrier := Carrier) state) : Prop :=
  ∃ other, other = w.left ∧ other = state

end Example
"""
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "Sample.lean").write_text(source)
            with patch.object(lean_math, "FORMAL", root), patch.object(lean_math, "ROOT", root):
                record = lean_math.declaration("Sample", "Witness")
                predicate = lean_math.declaration("Sample", "valid")
        self.assertEqual(record["fields"], [
            {"name": "left", "type": "Carrier"},
            {"name": "joined", "type": "left = state ∧\n      state = left"},
        ])
        self.assertEqual(predicate["body"], "∃ other, other = w.left ∧ other = state")
        self.assertEqual(predicate["binders"], [
            {"names": ["Carrier"], "type": "Type u", "implicit": True},
            {"names": ["w"], "type": "Witness (Carrier := Carrier) state", "implicit": False},
        ])
        for item in [record, predicate]:
            self.assertEqual(item["source"], "\n".join(source.splitlines()[item["line"] - 1:item["endLine"]]))
        self.assertIn("/- Keep the join", record["source"])

    def test_unsupported_record_fields_fail_instead_of_disappearing(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "Sample.lean").write_text("namespace Example\nstructure W where\n  value : Nat\n  check (x : Nat) : x = value\n")
            with patch.object(lean_math, "FORMAL", root), patch.object(lean_math, "ROOT", root):
                with self.assertRaisesRegex(ValueError, "Unparsed record field"):
                    lean_math.declaration("Sample", "W")


if __name__ == "__main__":
    unittest.main()
