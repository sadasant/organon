import Base

# Constructive fragment of DanielOntology.absencePresenceExclusive.
def absence_presence_exclusive(-A: Type, absent: A -> Empty, present: A) -> Empty:
  absent(present)

# Finite, decidable Missingness. This does not replace arbitrary Prop predicates.
def missing(contains: Bool) -> Bool:
  match contains:
    case True{}: False{}
    case False{}: True{}

law missing_present:
  {missing(True{}) == False{} : Bool}
def missing_present(): {==}

law missing_absent:
  {missing(False{}) == True{} : Bool}
def missing_absent(): {==}

# A core classifier ignores extension data by construction.
def evaluate(-A: Data, classifier: A -> Bool, extension: Bool, value: A) -> Bool:
  classifier(value)

law classification_preserved:
  for -A: Data
  for classifier: A -> Bool
  for left: Bool
  for right: Bool
  for value: A
  {evaluate(A, classifier, left, value) == evaluate(A, classifier, right, value) : Bool}
def classification_preserved(A, classifier, left, right, value): {==}
