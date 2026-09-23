import Base
import ./Model.bend as Model
import ./Reduct.bend as Reduct
import ./Logic.bend as Logic
import ./Core.bend as Core
import ./LAWS.bend as Laws

def Laws.missingnessTranslation(A, m):
  match m:
    case Core.Missingness{field, expected, missing}: missing

def Laws.entityIdentityPersists(A, entity, state, member):
  match entity:
    case Core.Entity{identity, boundary, direction, persistence, identityEq, current, currentIn, identityHolds}:
      match persistence:
        case Core.PersistenceWitness{states, hasTransition, invariant, invariantHolds, ordered}:
          %identityEq : Core.Invariant.holds(A, _)(state)
          invariantHolds(state, member)

def Laws.absencePresenceExclusive(A, absent, present):
  match present:
    case Logic.Nonempty{value}: absent(value)

def Laws.everyValueIsInCoreReality(A, value): Unit{}

def Laws.presenceReductPreserved(A): Logic.Iff{x => x, x => x}

def missingProjection(-A: Type, -field: Core.Field<A>, -expected: A, p: Logic.Both<Logic.Nonempty<A>, Core.Field.contains(A, field)(expected) -> Empty>) -> Core.Field.contains(A, field)(expected) -> Empty:
  match p:
    case Logic.Both{present, missing}: missing

def Laws.missingnessReductPreserved(A, field, expected):
  Logic.Iff{p => missingProjection(A, field, expected, p), missing => Logic.Both{Logic.Nonempty{expected}, missing}}



def Laws.reductToExtensionPreserved(A, classifier, extension, value):
  Logic.Iff{x => x, x => x}

def Laws.classificationPreserved(A, classifier, left, right, value):
  Logic.Iff{x => x, x => x}

def Laws.classificationPreservedForAllValues(A, classifier, left, right):
  Logic.Iff{x => x, x => x}

def correctedIdentity(-A: Type, -invariant: Core.Invariant<A>, -identity: Core.Invariant<A>, e: {invariant == identity : Core.Invariant<A>}, -state: Core.State<A>, proof: Core.Invariant.holds(A, invariant)(state)) -> Core.Invariant.holds(A, identity)(state):
  %e : Core.Invariant.holds(A, _)(state)
  proof

def Laws.entityMeetsPersistenceClassification(A, entity):
  match entity:
    case Core.Entity{identity, boundary, direction, persistence, identityEq, current, currentIn, identityHolds}:
      match persistence:
        case Core.PersistenceWitness{states, hasTransition, invariant, invariantHolds, ordered}:
          Logic.Both{hasTransition, Logic.Both{ordered,
            state => member => correctedIdentity(A, invariant, identity, identityEq, state, invariantHolds(state, member))}}


def Laws.boundaryAdmitsActivation(): Unit{}

def Laws.boundaryRejectsBreaking():
  e => e

def Laws.breakingViolatesIdentity():
  e => e

def Laws.entityModelIsInhabited():
  Logic.Nonempty{Model.machine()}

def Laws.localRealityReductPreserved(A, value):
  Logic.Iff{present => Unit{}, unit => Logic.Nonempty{value}}

def Laws.presenceObtains(): Logic.Nonempty{Logic.Drawn{}}

def Laws.missingnessIsPresent(A, m): Logic.Nonempty{m}

def Laws.historyClassificationPreserved(A, direction, states, invariant, left, right):
  Logic.Iff{x => x, x => x}

def Laws.preservingHistoryClassifiesAsPersistence():
  Laws.entityMeetsPersistenceClassification(Model.MachineState, Model.machine())

def brokenHistoryRefuted(classified: Reduct.classifiesPersistence(Model.MachineState, Model.direction(), [Model.idleState(), Model.activeState(), Model.brokenState()], Model.identity())) -> Empty:
  match classified:
    case Logic.Both{hasTransition, rest}:
      match rest:
        case Logic.Both{ordered, invariantHolds}:
          invariantHolds(Model.brokenState(), Inr{Inr{Inl{{==}}}})

def Laws.breakingHistoryDoesNotClassifyAsPersistence(): brokenHistoryRefuted

def Laws.machineCarriesBindingPersistence():
  Laws.entityMeetsPersistenceClassification(Model.MachineState, Model.machine())
