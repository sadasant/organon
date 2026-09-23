import Base
import ./Logic.bend as Logic
import ./Core.bend as Core

# Interpretations are explicit and cannot be inspected by a core classifier.
type ExtensionSemantics is Type:
  ExtensionSemantics{absent: Type -> Type, present: Type -> Type,
    exclusive: @-A: Type -> Logic.Both<absent(A), present(A)> -> Empty,
    exhaustive: @-A: Type -> Either<&1, &1, absent(A), present(A)>}

def evaluate(-A: Type, classifier: A -> Type, extension: ExtensionSemantics, value: A) -> Type:
  classifier(value)

def evaluateReduct(-A: Type, classifier: A -> Type, value: A) -> Type:
  classifier(value)

def classifiesPersistence(-A: Type, direction: Core.Direction<A>, states: List<Core.State<A>>, invariant: Core.Invariant<A>) -> Type:
  Logic.Both<Core.hasTransition(Core.State<A>, states),
    Logic.Both<Core.orderedBy(Core.State<A>, Core.Direction.before(A, direction), states),
      @state: Core.State<A> -> Core.member(Core.State<A>, state, states) -> Core.Invariant.holds(A, invariant)(state)>>
