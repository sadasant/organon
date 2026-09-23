import Base
import ./Model.bend as Model
import ./Reduct.bend as Reduct
import ./Logic.bend as Logic
import ./Core.bend as Core

law missingnessTranslation:
  for -A: Type
  for m: Core.Missingness<A>
  Core.Field.contains(A, Core.Missingness.field(A, m))(Core.Missingness.expected(A, m)) -> Empty

law entityIdentityPersists:
  for -A: Type
  for entity: Core.Entity<A>
  for state: Core.State<A>
  for member: Core.member(Core.State<A>, state, Core.PersistenceWitness.states(A, Core.Entity.persistenceDirection(A, entity), Core.Entity.persistence(A, entity)))
  Core.Invariant.holds(A, Core.Entity.identity(A, entity))(state)

law absencePresenceExclusive:
  for -A: Type
  for absent: A -> Empty
  for present: Logic.Nonempty<A>
  Empty

law everyValueIsInCoreReality:
  for -A: Type
  for value: A
  Unit

law presenceReductPreserved:
  for -A: Type
  Logic.Iff<Logic.Nonempty<A>, Logic.Nonempty<A>>

law missingnessReductPreserved:
  for -A: Type
  for -field: Core.Field<A>
  for expected: A
  Logic.Iff<Logic.Both<Logic.Nonempty<A>, Core.Field.contains(A, field)(expected) -> Empty>, Core.Field.contains(A, field)(expected) -> Empty>


law reductToExtensionPreserved:
  for -A: Type
  for -classifier: A -> Type
  for -extension: Reduct.ExtensionSemantics
  for -value: A
  Logic.Iff<Reduct.evaluateReduct(A, classifier, value), Reduct.evaluate(A, classifier, extension, value)>

law classificationPreserved:
  for -A: Type
  for -classifier: A -> Type
  for -left: Reduct.ExtensionSemantics
  for -right: Reduct.ExtensionSemantics
  for -value: A
  Logic.Iff<Reduct.evaluate(A, classifier, left, value), Reduct.evaluate(A, classifier, right, value)>

law classificationPreservedForAllValues:
  for -A: Type
  for -classifier: A -> Type
  for -left: Reduct.ExtensionSemantics
  for -right: Reduct.ExtensionSemantics
  Logic.Iff<@value: A -> Reduct.evaluate(A, classifier, left, value), @value: A -> Reduct.evaluate(A, classifier, right, value)>

law entityMeetsPersistenceClassification:
  for -A: Type
  for entity: Core.Entity<A>
  Reduct.classifiesPersistence(A, Core.Entity.persistenceDirection(A, entity), Core.PersistenceWitness.states(A, Core.Entity.persistenceDirection(A, entity), Core.Entity.persistence(A, entity)), Core.Entity.identity(A, entity))

law boundaryAdmitsActivation:
  Model.permits(Model.direction(), Model.activate())

law boundaryRejectsBreaking:
  Model.permits(Model.direction(), Model.breakMachine()) -> Empty

law breakingViolatesIdentity:
  Model.identityHolds(Core.Transformation.output(Model.MachineState, Model.direction(), Model.breakMachine())) -> Empty

law entityModelIsInhabited:
  Logic.Nonempty<Core.Entity<Model.MachineState>>

law localRealityReductPreserved:
  for -A: Type
  for value: A
  Logic.Iff<Logic.Nonempty<A>, Unit>

law presenceObtains:
  Logic.Nonempty<Logic.Mark>

law missingnessIsPresent:
  for -A: Type
  for m: Core.Missingness<A>
  Logic.Nonempty<Core.Missingness<A>>

law historyClassificationPreserved:
  for -A: Type
  for -direction: Core.Direction<A>
  for -states: List<Core.State<A>>
  for -invariant: Core.Invariant<A>
  for -left: Reduct.ExtensionSemantics
  for -right: Reduct.ExtensionSemantics
  Logic.Iff<Reduct.evaluate(Unit, ignored => Reduct.classifiesPersistence(A, direction, states, invariant), left, Unit{}), Reduct.evaluate(Unit, ignored => Reduct.classifiesPersistence(A, direction, states, invariant), right, Unit{})>

law preservingHistoryClassifiesAsPersistence:
  Reduct.classifiesPersistence(Model.MachineState, Model.direction(), [Model.idleState(), Model.activeState()], Model.identity())

law breakingHistoryDoesNotClassifyAsPersistence:
  Reduct.classifiesPersistence(Model.MachineState, Model.direction(), [Model.idleState(), Model.activeState(), Model.brokenState()], Model.identity()) -> Empty

law machineCarriesBindingPersistence:
  Reduct.classifiesPersistence(Model.MachineState, Core.Entity.persistenceDirection(Model.MachineState, Model.machine()), Core.PersistenceWitness.states(Model.MachineState, Core.Entity.persistenceDirection(Model.MachineState, Model.machine()), Core.Entity.persistence(Model.MachineState, Model.machine())), Core.Entity.identity(Model.MachineState, Model.machine()))
