import Base
import ../Logic.bend as Logic
import ../Reduct.bend as Reduct

# Candidate interface only: the caller supplies classical bivalence.
# This does NOT construct it or make the original theorem closed in Bend.
def absent(A: Type) -> Type: A -> Empty

def present(A: Type) -> Type: Logic.Nonempty<A>

def exclusive(-A: Type, p: Logic.Both<(A -> Empty), Logic.Nonempty<A>>) -> Empty:
  match p:
    case Logic.Both{absent, present}:
      match present:
        case Logic.Nonempty{value}: absent(value)

def formalAbsenceExtension(classical: @-A: Type -> Either<&1, &1, A -> Empty, Logic.Nonempty<A>>) -> Reduct.ExtensionSemantics:
  Reduct.ExtensionSemantics{absent, present, exclusive, classical}
