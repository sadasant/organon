import BridgeRelations
import Consciousness

/-!
# Embodiment and recurrent consciousness candidate: formal shadow

The candidate below obtains exactly when the embodied structural conjunction is
inhabited. It is not an independently authored predicate, and it does not
define a universal `Consciousness` predicate.
-/

universe u v w

namespace DanielOntology.EmbodiedConsciousnessProposal

open ConsciousnessProposal

instance stateDecidableEq {Carrier : Type u} [DecidableEq Carrier] :
    DecidableEq (State Carrier) := fun first second =>
  match first, second with
  | ⟨first⟩, ⟨second⟩ =>
    if equal : first = second then isTrue (by subst second; rfl)
    else isFalse (by intro same; cases same; exact equal rfl)

instance transformationDecidableEq {Carrier : Type u} [DecidableEq Carrier]
    {direction : Direction Carrier} : DecidableEq (Transformation direction) :=
  fun first second =>
    if inputEqual : first.input = second.input then
      if outputEqual : first.output = second.output then
        isTrue (by
          cases first with
          | mk firstInput firstOutput firstAdvances =>
            cases second with
            | mk secondInput secondOutput secondAdvances =>
              cases inputEqual
              cases outputEqual
              rfl)
      else isFalse (by intro same; cases same; exact outputEqual rfl)
    else isFalse (by intro same; cases same; exact inputEqual rfl)

structure Body
    (Part : Type u)
    {Feature : Type v}
    {Context : Type w}
    (entity : Entity (Feature × Context)) where
  states : List (State (Feature × Context))
  statesNonempty : states ≠ []
  statesWithinPersistence : ∀ state, state ∈ states →
    state ∈ entity.persistence.states
  statesOrdered : OrderedBy entity.persistenceDirection.before states
  partAt : State (Feature × Context) → Part → Prop
  eachStateHasConstituent : ∀ state, state ∈ states → ∃ part, partAt state part
  interior : Specification (State (Feature × Context))
  environment : Scope (State (Feature × Context))
  interiorEnvironmentDisjoint :
    ∀ state, interior.scope.includes state → ¬ environment.includes state
  recurringTransformations : List (Transformation entity.persistenceDirection)
  recurringNonempty : recurringTransformations ≠ []
  feeding : FeedRelation (Feature × Context)
  identityPath : CausalPath entity.persistenceDirection feeding
  identityPathNonempty : identityPath.steps ≠ []
  recurringOccursInPath : ∀ transformation,
    transformation ∈ recurringTransformations → transformation ∈ identityPath.steps
  recurringWithinInterior : ∀ transformation,
    transformation ∈ recurringTransformations →
      interior.conforms transformation.input ∧ interior.conforms transformation.output
  recurringAdmittedByBoundary : ∀ transformation,
    transformation ∈ recurringTransformations → ∀ constraint,
      constraint ∈ entity.boundary.constraints → constraint.permits transformation
  recurringPreservesIdentity : ∀ transformation,
    transformation ∈ recurringTransformations →
      entity.identity.holds transformation.input ∧ entity.identity.holds transformation.output

structure BodilyOrganization
    (Organ Part : Type u)
    {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)}
    (body : Body Part entity) where
  organs : List Organ
  organsNonempty : organs ≠ []
  organPart : Organ → Part
  organPresent : ∀ organ, organ ∈ organs →
    ∃ state, state ∈ body.states ∧ body.partAt state (organPart organ)
  recurring : Organ → Transformation entity.persistenceDirection
  recurringInBody : ∀ organ, organ ∈ organs →
    recurring organ ∈ body.recurringTransformations
  recurringPairwiseDistinct : ∀ first, first ∈ organs →
    ∀ second, second ∈ organs → first ≠ second →
      recurring first ≠ recurring second
  sustainingContribution : Organ →
    CausalContribution Feature Context entity.persistenceDirection body.feeding
  recurringOccursInContribution : ∀ organ, organ ∈ organs →
    recurring organ ∈ (sustainingContribution organ).leftPath.steps ∨
    recurring organ ∈ (sustainingContribution organ).rightPath.steps
  contributionSustainsIdentity : ∀ organ, organ ∈ organs →
    entity.identity.holds
      (sustainingContribution organ).downstreamChange.transformation.output
  coordinationWitness : ∃ first second,
    first ∈ organs ∧ second ∈ organs ∧ first ≠ second ∧
    body.feeding.feeds
      (sustainingContribution first).downstreamChange.transformation.output
      (recurring second).input ∧
    entity.persistenceDirection.before
      (sustainingContribution first).downstreamChange.transformation.output
      (recurring second).output

structure PerspectivePerception
    (Part : Type u)
    {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)}
    (body : Body Part entity)
    (conditionRepresentation contrastConditionRepresentation : Feature) where
  difference : contrastConditionRepresentation ≠ conditionRepresentation
  state : State (Feature × Context)
  stateIsInternal : body.interior.conforms state
  contribution :
    CausalContribution Feature Context entity.persistenceDirection body.feeding
  stateRegistersCondition :
    state = contribution.rightEndpoints.first.input
  differenceIsUpstream :
    contribution.leftEndpoints.first.input.value.1 =
        contrastConditionRepresentation ∧
    contribution.rightEndpoints.first.input.value.1 = conditionRepresentation

structure PerspectiveMemory
    (Part : Type u)
    {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)}
    (body : Body Part entity)
    (memoryRepresentation contrastMemoryRepresentation : Feature) where
  difference : contrastMemoryRepresentation ≠ memoryRepresentation
  recordedState : State (Feature × Context)
  persistence : PersistenceWitness entity.persistenceDirection
  recordedStateInPersistence : recordedState ∈ persistence.states
  recordedStateIsInternal : body.interior.conforms recordedState
  contribution :
    CausalContribution Feature Context entity.persistenceDirection body.feeding
  recordedStateSuppliesMemory :
    recordedState = contribution.rightEndpoints.first.input
  contributionResultInPersistence :
    contribution.downstreamChange.transformation.output ∈ persistence.states
  differenceIsUpstream :
    contribution.leftEndpoints.first.input.value.1 =
        contrastMemoryRepresentation ∧
    contribution.rightEndpoints.first.input.value.1 = memoryRepresentation

structure PerspectiveModel
    (Part : Type u)
    {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)}
    (body : Body Part entity)
    {conditionRepresentation contrastConditionRepresentation : Feature}
    {memoryRepresentation contrastMemoryRepresentation : Feature}
    (perception : PerspectivePerception Part body
      conditionRepresentation contrastConditionRepresentation)
    (memory : PerspectiveMemory Part body
      memoryRepresentation contrastMemoryRepresentation) where
  representations : List Feature
  conditionRepresentationInModel : conditionRepresentation ∈ representations
  contrastConditionRepresentationInModel :
    contrastConditionRepresentation ∈ representations
  memoryRepresentationInModel : memoryRepresentation ∈ representations
  contrastMemoryRepresentationInModel :
    contrastMemoryRepresentation ∈ representations
  transformations : List (Transformation entity.persistenceDirection)
  transformationsNonempty : transformations ≠ []
  transformationsWithinBody : ∀ transformation,
    transformation ∈ transformations →
      transformation ∈ body.recurringTransformations
  laterStates : List (State (Feature × Context))
  perceptionResultInLaterStates :
    perception.contribution.downstreamChange.transformation.output ∈ laterStates
  memoryResultInLaterStates :
    memory.contribution.downstreamChange.transformation.output ∈ laterStates
  constraints : List (Constraint (Feature × Context))
  constraintsNonempty : constraints ≠ []
  constraintsFromBoundary : ∀ constraint, constraint ∈ constraints →
    constraint ∈ entity.boundary.constraints

structure EmbodiedPerspective
    (Part : Type u)
    {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)}
    (body : Body Part entity) where
  conditionRepresentation : Feature
  contrastConditionRepresentation : Feature
  representedCondition : State (Feature × Context)
  conditionDenotation : Denotation Feature (State (Feature × Context))
  denotationNamesCondition :
    conditionDenotation.expression = conditionRepresentation ∧
    conditionDenotation.target = representedCondition
  representedConditionIsInternal : body.interior.conforms representedCondition
  availableTransformations : List (Transformation entity.persistenceDirection)
  availableNonempty : availableTransformations ≠ []
  availableWithinBody : ∀ transformation,
    transformation ∈ availableTransformations →
      transformation ∈ body.recurringTransformations
  availableRepresentation : Transformation entity.persistenceDirection → Feature
  availableDenotation : Transformation entity.persistenceDirection →
    Denotation Feature (State (Feature × Context))
  availableDenotationExact : ∀ transformation,
    transformation ∈ availableTransformations →
      (availableDenotation transformation).expression =
          availableRepresentation transformation ∧
      (availableDenotation transformation).target = transformation.output
  perception : PerspectivePerception Part body
    conditionRepresentation contrastConditionRepresentation
  memoryRepresentation : Feature
  contrastMemoryRepresentation : Feature
  memory : PerspectiveMemory Part body
    memoryRepresentation contrastMemoryRepresentation
  model : PerspectiveModel Part body perception memory
  perceptionChangesInternal : body.interior.conforms
    perception.contribution.downstreamChange.transformation.output
  memoryChangesInternal : body.interior.conforms
    memory.contribution.downstreamChange.transformation.output

structure TransformationFamily
    {Carrier : Type u} (direction : Direction Carrier) where
  transformations : List (Transformation direction)
  nonempty : transformations ≠ []

structure RecurrentIntegration
    {Feature : Type u} {Context : Type v}
    (direction : Direction (Feature × Context))
    (feeding : FeedRelation (Feature × Context)) where
  firstFamily : TransformationFamily direction
  secondFamily : TransformationFamily direction
  familiesDistinct : firstFamily.transformations ≠ secondFamily.transformations
  firstToSecond : CausalContribution Feature Context direction feeding
  secondToFirst : CausalContribution Feature Context direction feeding
  firstComparisonInFirstFamily :
    firstToSecond.leftEndpoints.first ∈ firstFamily.transformations ∧
    firstToSecond.rightEndpoints.first ∈ firstFamily.transformations
  firstChangeInSecondFamily :
    firstToSecond.downstreamChange.transformation ∈ secondFamily.transformations
  returnComparisonInSecondFamily :
    secondToFirst.leftEndpoints.first ∈ secondFamily.transformations ∧
    secondToFirst.rightEndpoints.first ∈ secondFamily.transformations
  returnChangeInFirstFamily :
    secondToFirst.downstreamChange.transformation ∈ firstFamily.transformations
  returnOccursLater : direction.before
    firstToSecond.downstreamChange.transformation.output
    secondToFirst.leftEndpoints.first.input

inductive RevisionMode where
  | select | continue | inhibit | revise
deriving DecidableEq, Repr

structure InternalActivitySelection
    (Part : Type u)
    {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)}
    (body : Body Part entity) where
  representation : Feature
  contrastRepresentation : Feature
  representationDifference : contrastRepresentation ≠ representation
  representedOutcome : State (Feature × Context)
  outcomeDenotation : Denotation Feature (State (Feature × Context))
  denotationNamesOutcome :
    outcomeDenotation.expression = representation ∧
    outcomeDenotation.target = representedOutcome
  contribution :
    CausalContribution Feature Context entity.persistenceDirection body.feeding
  representationalDifferenceIsUpstream :
    contribution.leftEndpoints.first.input.value.1 = contrastRepresentation ∧
    contribution.rightEndpoints.first.input.value.1 = representation
  options : List (Transformation entity.persistenceDirection)
  selected : Transformation entity.persistenceDirection
  rejected : Transformation entity.persistenceDirection
  availability : Specification (Transformation entity.persistenceDirection)
  availabilityExactlyOptions : ∀ transformation,
    availability.conforms transformation ↔ transformation ∈ options
  selectedIsChangedPathLast : selected = contribution.rightEndpoints.last
  rejectedIsContrastPathLast : rejected = contribution.leftEndpoints.last
  selectedInOptions : selected ∈ options
  rejectedInOptions : rejected ∈ options
  optionsWithinBody : ∀ transformation,
    transformation ∈ options → transformation ∈ body.recurringTransformations
  discriminates : selected ≠ rejected
  representedOutcomeIsSelectedOutput : representedOutcome = selected.output
  contributionSelects :
    contribution.downstreamChange.transformation.output = selected.output
  selectedIsInternal : body.interior.conforms selected.output
  rejectedIsInternal : body.interior.conforms rejected.output
  mode : RevisionMode

structure EmbodiedRecurrentStructure
    (Part : Type u)
    {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)}
    (body : Body Part entity)
    (moment : State (Feature × Context)) where
  momentInBodyStates : moment ∈ body.states
  perspective : EmbodiedPerspective Part body
  integration : RecurrentIntegration entity.persistenceDirection body.feeding
  selection : InternalActivitySelection Part body
  perspectiveAtMoment : perspective.representedCondition = moment
  firstFamilyWithinBody : ∀ transformation,
    transformation ∈ integration.firstFamily.transformations →
      transformation ∈ body.recurringTransformations
  secondFamilyWithinBody : ∀ transformation,
    transformation ∈ integration.secondFamily.transformations →
      transformation ∈ body.recurringTransformations
  perspectiveGuidesSelection :
    perspective.conditionRepresentation = selection.representation ∧
    perspective.perception.contribution = selection.contribution

def EmbodiedRecurrentAt
    {Part : Type u} {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)}
    (body : Body Part entity) (moment : State (Feature × Context)) : Prop :=
  Nonempty (EmbodiedRecurrentStructure Part body moment)

noncomputable def embodiedCandidateCondition
    {Part : Type u} {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} (body : Body Part entity) :
    CandidateCondition Unit (State (Feature × Context)) Unit := by
  classical
  exact {
    condition := ()
    obtains := fun _ _ moment => EmbodiedRecurrentAt body moment
    specification := {
      scope := ⟨fun pair => pair.2 ∈ body.states⟩
      conforms := fun pair => EmbodiedRecurrentAt body pair.2
      decideConformity := fun pair => decide (EmbodiedRecurrentAt body pair.2)
      conformityCorrect := by intro pair; simp
      conformityWithinScope := by
        intro pair conforms
        rcases conforms with ⟨candidateWitness⟩
        exact candidateWitness.momentInBodyStates
    }
    specificationCorrect := by intro subject moment; rfl
  }

theorem candidateHoldsIffEmbodiedRecurrentAt
    {Part : Type u} {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)}
    (body : Body Part entity) (moment : State (Feature × Context)) :
    (embodiedCandidateCondition body).holds () moment ↔
      EmbodiedRecurrentAt body moment := by rfl

/-! ## Finite inhabited model -/

inductive Stage where
  | environment | forwardInput | forwardLow | forwardHigh
  | returnInput | returnLow | returnHigh
deriving DecidableEq, Repr

def Stage.rank : Stage → Nat
  | .environment => 0 | .forwardInput => 1 | .forwardLow => 2
  | .forwardHigh => 3 | .returnInput => 4 | .returnLow => 5
  | .returnHigh => 6

abbrev Carrier := Bool × Stage

def systemDirection : Direction Carrier where
  before := fun input output => input.value.2.rank < output.value.2.rank
  asymmetric := by
    intro input output forward reverse
    exact (Nat.not_lt_of_ge (Nat.le_of_lt reverse)) forward

def unconstrainedFeed : FeedRelation Carrier := ⟨fun _ _ => True⟩
def state (feature : Bool) (stage : Stage) : State Carrier := ⟨(feature, stage)⟩

def transform (feature : Bool) (input output : Stage)
    (advances : input.rank < output.rank) : Transformation systemDirection :=
  ⟨state feature input, state feature output, advances⟩

def environmentalInputTransform := transform false .environment .forwardInput (by decide)
def forwardLowTransform := transform false .forwardInput .forwardLow (by decide)
def forwardHighTransform := transform true .forwardInput .forwardHigh (by decide)
def forwardChangeTransform : Transformation systemDirection where
  input := state false .forwardLow
  output := state true .forwardHigh
  advances := by change 2 < 3; decide
def returnLowTransform := transform false .returnInput .returnLow (by decide)
def returnHighTransform := transform true .returnInput .returnHigh (by decide)
def returnChangeTransform : Transformation systemDirection where
  input := state false .returnLow
  output := state true .returnHigh
  advances := by change 5 < 6; decide

def singletonPath (transformation : Transformation systemDirection) :
    CausalPath systemDirection unconstrainedFeed := ⟨[transformation], trivial⟩

def singletonEndpoints (transformation : Transformation systemDirection) :
    PathEndpoints (singletonPath transformation) where
  first := transformation
  last := transformation
  startsWith := ⟨[], rfl⟩
  endsWith := ⟨[], rfl⟩

def forwardContribution :
    CausalContribution Bool Stage systemDirection unconstrainedFeed where
  leftPath := singletonPath forwardLowTransform
  rightPath := singletonPath forwardHighTransform
  leftEndpoints := singletonEndpoints forwardLowTransform
  rightEndpoints := singletonEndpoints forwardHighTransform
  sameDeclaredContext := rfl
  inputDiffers := by decide
  downstreamChange := ⟨forwardChangeTransform, by
    simp [forwardChangeTransform, state]⟩
  changeStartsAt := rfl
  changeEndsAt := by
    simp [singletonEndpoints, forwardChangeTransform, forwardHighTransform,
      transform]

def returnContribution :
    CausalContribution Bool Stage systemDirection unconstrainedFeed where
  leftPath := singletonPath returnLowTransform
  rightPath := singletonPath returnHighTransform
  leftEndpoints := singletonEndpoints returnLowTransform
  rightEndpoints := singletonEndpoints returnHighTransform
  sameDeclaredContext := rfl
  inputDiffers := by decide
  downstreamChange := ⟨returnChangeTransform, by
    simp [returnChangeTransform, state]⟩
  changeStartsAt := rfl
  changeEndsAt := by
    simp [singletonEndpoints, returnChangeTransform, returnHighTransform,
      transform]

def systemIdentity : Invariant Carrier :=
  ⟨fun current => current.value.2 ≠ .environment⟩

def internalOnly : Constraint Carrier :=
  ⟨fun transformation => systemIdentity.holds transformation.output⟩

def systemBoundary : Boundary Carrier systemIdentity where
  constraints := [internalOnly]
  preserves := by
    intro direction transformation admitted _
    exact admitted internalOnly (by simp)

def systemPersistence : PersistenceWitness systemDirection where
  states := [state false .forwardInput, state false .forwardLow,
    state true .forwardHigh, state false .returnInput,
    state false .returnLow, state true .returnHigh]
  hasTransition := ⟨state false .forwardInput, state false .forwardLow,
    [state true .forwardHigh, state false .returnInput,
      state false .returnLow, state true .returnHigh], rfl⟩
  invariant := systemIdentity
  invariantHolds := by
    intro current member
    simp [systemIdentity, state] at member ⊢
    rcases member with rfl | rfl | rfl | rfl | rfl | rfl <;> decide
  ordered := by simp [OrderedBy, systemDirection, state, Stage.rank]

def systemEntity : Entity Carrier where
  identity := systemIdentity
  boundary := systemBoundary
  persistenceDirection := systemDirection
  persistence := systemPersistence
  persistenceNamesIdentity := rfl
  current := state true .returnHigh
  currentInPersistence := by simp [systemPersistence]
  identityHolds := by simp [systemIdentity, state]

inductive ToyPart where
  | sensor | regulator
deriving DecidableEq, Repr

def internalSpecification : Specification (State Carrier) where
  scope := ⟨fun current => current.value.2 ≠ .environment⟩
  conforms := fun current => current.value.2 ≠ .environment
  decideConformity := fun current => decide (current.value.2 ≠ .environment)
  conformityCorrect := by simp
  conformityWithinScope := by simp

def systemBody : Body ToyPart systemEntity where
  states := systemPersistence.states
  statesNonempty := by simp [systemPersistence]
  statesWithinPersistence := by intro state member; exact member
  statesOrdered := systemPersistence.ordered
  partAt := fun current part =>
    (current = state false .forwardInput ∧ part = .sensor) ∨
    (current ≠ state false .forwardInput ∧ part = .regulator)
  eachStateHasConstituent := by
    intro current member
    by_cases first : current = state false .forwardInput
    · exact ⟨.sensor, Or.inl ⟨first, rfl⟩⟩
    · exact ⟨.regulator, Or.inr ⟨first, rfl⟩⟩
  interior := internalSpecification
  environment := ⟨fun current => current.value.2 = .environment⟩
  interiorEnvironmentDisjoint := by
    intro current internal external
    exact internal external
  recurringTransformations := [forwardLowTransform, forwardHighTransform,
    forwardChangeTransform, returnLowTransform, returnHighTransform,
    returnChangeTransform]
  recurringNonempty := by simp
  feeding := unconstrainedFeed
  identityPath := ⟨[forwardLowTransform, forwardHighTransform,
    forwardChangeTransform, returnLowTransform, returnHighTransform,
    returnChangeTransform], by simp [Chains, unconstrainedFeed]⟩
  identityPathNonempty := by simp
  recurringOccursInPath := by intro transformation member; simpa using member
  recurringWithinInterior := by
    intro transformation member
    simp at member
    rcases member with rfl | rfl | rfl | rfl | rfl | rfl <;>
      simp [internalSpecification, forwardLowTransform, forwardHighTransform,
        forwardChangeTransform, returnLowTransform, returnHighTransform,
        returnChangeTransform, transform, state]
  recurringAdmittedByBoundary := by
    intro transformation member constraint constraintMember
    simp [systemEntity, systemBoundary] at constraintMember
    subst constraint
    change systemIdentity.holds transformation.output
    simp at member
    rcases member with rfl | rfl | rfl | rfl | rfl | rfl <;>
      simp [systemIdentity, forwardLowTransform, forwardHighTransform,
        forwardChangeTransform, returnLowTransform, returnHighTransform,
        returnChangeTransform, transform, state]
  recurringPreservesIdentity := by
    intro transformation member
    simp at member
    rcases member with rfl | rfl | rfl | rfl | rfl | rfl <;>
      simp [systemEntity, systemIdentity, forwardLowTransform,
        forwardHighTransform, forwardChangeTransform, returnLowTransform,
        returnHighTransform, returnChangeTransform, transform, state]

theorem oneBodyRelationAllowsConstituentChange :
    systemBody.partAt (state false .forwardInput) .sensor ∧
    ¬ systemBody.partAt (state false .forwardLow) .sensor ∧
    systemEntity.identity.holds (state false .forwardInput) ∧
    systemEntity.identity.holds (state false .forwardLow) := by
  simp [systemBody, systemEntity, systemIdentity, state]

def environmentToInteriorPath : CausalPath systemDirection unconstrainedFeed :=
  singletonPath environmentalInputTransform

theorem bodyBoundaryDoesNotRequireIsolation :
    systemBody.environment.includes (state false .environment) ∧
    systemBody.interior.conforms (state false .forwardInput) ∧
    environmentToInteriorPath.steps = [environmentalInputTransform] ∧
    environmentalInputTransform.input = state false .environment ∧
    environmentalInputTransform.output = state false .forwardInput := by
  simp [systemBody, internalSpecification, environmentToInteriorPath,
    singletonPath, environmentalInputTransform, transform, state]

inductive ToyOrgan where
  | sensor | regulator
deriving DecidableEq, Repr

def systemOrganization : BodilyOrganization ToyOrgan ToyPart systemBody where
  organs := [.sensor, .regulator]
  organsNonempty := by simp
  organPart := fun | .sensor => .sensor | .regulator => .regulator
  organPresent := by
    intro organ member
    cases organ
    · exact ⟨state false .forwardInput,
        by simp [systemBody, systemPersistence], by simp [systemBody]⟩
    · exact ⟨state false .forwardLow,
        by simp [systemBody, systemPersistence], by simp [systemBody, state]⟩
  recurring := fun | .sensor => forwardLowTransform | .regulator => returnLowTransform
  recurringInBody := by intro organ _; cases organ <;> simp [systemBody]
  recurringPairwiseDistinct := by
    intro first _ second _ distinct
    cases first <;> cases second
    · exact False.elim (distinct rfl)
    · intro equal
      have outputs := congrArg Transformation.output equal
      simp [forwardLowTransform, returnLowTransform, transform, state] at outputs
    · intro equal
      have outputs := congrArg Transformation.output equal
      simp [forwardLowTransform, returnLowTransform, transform, state] at outputs
    · exact False.elim (distinct rfl)
  sustainingContribution := fun
    | .sensor => forwardContribution
    | .regulator => returnContribution
  recurringOccursInContribution := by
    intro organ _
    cases organ
    · left
      change forwardLowTransform ∈ [forwardLowTransform]
      simp
    · left
      change returnLowTransform ∈ [returnLowTransform]
      simp
  contributionSustainsIdentity := by
    intro organ _
    cases organ <;>
      simp [systemEntity, systemIdentity, forwardContribution,
        returnContribution, forwardChangeTransform, returnChangeTransform, state]
  coordinationWitness := by
    refine ⟨.sensor, .regulator, by simp, by simp, by decide, trivial, ?_⟩
    change Stage.forwardHigh.rank < Stage.returnLow.rank
    decide

def firstFamily : TransformationFamily systemDirection :=
  ⟨[forwardLowTransform, forwardHighTransform, returnChangeTransform], by simp⟩

def secondFamily : TransformationFamily systemDirection :=
  ⟨[returnLowTransform, returnHighTransform, forwardChangeTransform], by simp⟩

def systemIntegration : RecurrentIntegration systemDirection unconstrainedFeed where
  firstFamily := firstFamily
  secondFamily := secondFamily
  familiesDistinct := by
    intro equal
    have heads := congrArg List.head? equal
    simp [firstFamily, secondFamily, forwardLowTransform,
      returnLowTransform, transform, state] at heads
  firstToSecond := forwardContribution
  secondToFirst := returnContribution
  firstComparisonInFirstFamily := by
    constructor <;> simp [forwardContribution, singletonEndpoints, firstFamily]
  firstChangeInSecondFamily := by simp [forwardContribution, secondFamily]
  returnComparisonInSecondFamily := by
    constructor <;> simp [returnContribution, singletonEndpoints, secondFamily]
  returnChangeInFirstFamily := by simp [returnContribution, firstFamily]
  returnOccursLater := by
    change Stage.forwardHigh.rank < Stage.returnInput.rank
    decide

def memoryPersistence : PersistenceWitness systemDirection where
  states := [state true .returnInput, state true .returnHigh]
  hasTransition := ⟨state true .returnInput, state true .returnHigh, [], rfl⟩
  invariant := ⟨fun current => current.value.1 = true⟩
  invariantHolds := by
    intro current member
    simp [state] at member
    rcases member with rfl | rfl <;> rfl
  ordered := by simp [OrderedBy, systemDirection, state, Stage.rank]

def systemPerception : PerspectivePerception ToyPart systemBody true false where
  difference := by decide
  state := state true .forwardInput
  stateIsInternal := by simp [systemBody, internalSpecification, state]
  contribution := forwardContribution
  stateRegistersCondition := rfl
  differenceIsUpstream := ⟨rfl, rfl⟩

def systemMemory : PerspectiveMemory ToyPart systemBody true false where
  difference := by decide
  recordedState := state true .returnInput
  persistence := memoryPersistence
  recordedStateInPersistence := by simp [memoryPersistence]
  recordedStateIsInternal := by simp [systemBody, internalSpecification, state]
  contribution := returnContribution
  recordedStateSuppliesMemory := rfl
  contributionResultInPersistence := by
    simp [memoryPersistence, returnContribution, returnChangeTransform]
  differenceIsUpstream := ⟨rfl, rfl⟩

def systemPerspectiveModel :
    PerspectiveModel ToyPart systemBody systemPerception systemMemory where
  representations := [true, false]
  conditionRepresentationInModel := by simp
  contrastConditionRepresentationInModel := by simp
  memoryRepresentationInModel := by simp
  contrastMemoryRepresentationInModel := by simp
  transformations := [forwardLowTransform, returnLowTransform]
  transformationsNonempty := by simp
  transformationsWithinBody := by
    intro transformation member
    simp at member
    rcases member with rfl | rfl <;> simp [systemBody]
  laterStates := [state true .forwardHigh, state true .returnHigh]
  perceptionResultInLaterStates := by
    simp [systemPerception, forwardContribution, forwardChangeTransform]
  memoryResultInLaterStates := by
    simp [systemMemory, returnContribution, returnChangeTransform]
  constraints := [internalOnly]
  constraintsNonempty := by simp
  constraintsFromBoundary := by
    intro constraint member
    simpa [systemEntity, systemBoundary] using member

def systemPerspective : EmbodiedPerspective ToyPart systemBody where
  conditionRepresentation := true
  contrastConditionRepresentation := false
  representedCondition := state true .forwardHigh
  conditionDenotation := ⟨true, state true .forwardHigh⟩
  denotationNamesCondition := ⟨rfl, rfl⟩
  representedConditionIsInternal := by
    simp [systemBody, internalSpecification, state]
  availableTransformations := [forwardLowTransform, returnLowTransform]
  availableNonempty := by simp
  availableWithinBody := by
    intro transformation member
    simp at member
    rcases member with rfl | rfl <;> simp [systemBody]
  availableRepresentation := fun transformation => transformation.output.value.1
  availableDenotation := fun transformation =>
    ⟨transformation.output.value.1, transformation.output⟩
  availableDenotationExact := by simp
  perception := systemPerception
  memoryRepresentation := true
  contrastMemoryRepresentation := false
  memory := systemMemory
  model := systemPerspectiveModel
  perceptionChangesInternal := by
    simp [systemPerception, systemBody, internalSpecification, forwardContribution,
      forwardChangeTransform, state]
  memoryChangesInternal := by
    simp [systemMemory, systemBody, internalSpecification, returnContribution,
      returnChangeTransform, state]

def systemSelection : InternalActivitySelection ToyPart systemBody where
  representation := true
  contrastRepresentation := false
  representationDifference := by decide
  representedOutcome := state true .forwardHigh
  outcomeDenotation := ⟨true, state true .forwardHigh⟩
  denotationNamesOutcome := ⟨rfl, rfl⟩
  contribution := forwardContribution
  representationalDifferenceIsUpstream := ⟨rfl, rfl⟩
  options := [forwardLowTransform, forwardHighTransform]
  selected := forwardHighTransform
  rejected := forwardLowTransform
  availability := {
    scope := ⟨fun transformation => transformation ∈ [forwardLowTransform, forwardHighTransform]⟩
    conforms := fun transformation => transformation ∈ [forwardLowTransform, forwardHighTransform]
    decideConformity := fun transformation => decide (transformation ∈ [forwardLowTransform, forwardHighTransform])
    conformityCorrect := by simp
    conformityWithinScope := by intro transformation member; exact member }
  availabilityExactlyOptions := by intro transformation; rfl
  selectedIsChangedPathLast := rfl
  rejectedIsContrastPathLast := rfl
  selectedInOptions := by simp
  rejectedInOptions := by simp
  optionsWithinBody := by
    intro transformation member
    simp at member
    rcases member with rfl | rfl <;> simp [systemBody]
  discriminates := by
    intro equal
    have outputs := congrArg Transformation.output equal
    simp [forwardHighTransform, forwardLowTransform, transform, state] at outputs
  representedOutcomeIsSelectedOutput := rfl
  contributionSelects := rfl
  selectedIsInternal := by
    simp [systemBody, internalSpecification, forwardHighTransform, transform, state]
  rejectedIsInternal := by
    simp [systemBody, internalSpecification, forwardLowTransform, transform, state]
  mode := .revise

def embodiedStructure :
    EmbodiedRecurrentStructure ToyPart systemBody (state true .forwardHigh) where
  momentInBodyStates := by simp [systemBody, systemPersistence]
  perspective := systemPerspective
  integration := systemIntegration
  selection := systemSelection
  perspectiveAtMoment := rfl
  firstFamilyWithinBody := by
    intro transformation member
    change transformation ∈
      [forwardLowTransform, forwardHighTransform, returnChangeTransform] at member
    change transformation ∈ [forwardLowTransform, forwardHighTransform,
      forwardChangeTransform, returnLowTransform, returnHighTransform,
      returnChangeTransform]
    rcases List.mem_cons.mp member with first | member
    · rw [first]
      exact List.mem_cons.mpr (Or.inl rfl)
    · rcases List.mem_cons.mp member with second | third
      · rw [second]
        exact List.mem_cons.mpr (Or.inr (List.mem_cons.mpr (Or.inl rfl)))
      · rw [List.mem_singleton.mp third]
        exact List.mem_cons.mpr (Or.inr (List.mem_cons.mpr (Or.inr
          (List.mem_cons.mpr (Or.inr (List.mem_cons.mpr (Or.inr
            (List.mem_cons.mpr (Or.inr (List.mem_singleton.mpr rfl))))))))))
  secondFamilyWithinBody := by
    intro transformation member
    change transformation ∈
      [returnLowTransform, returnHighTransform, forwardChangeTransform] at member
    change transformation ∈ [forwardLowTransform, forwardHighTransform,
      forwardChangeTransform, returnLowTransform, returnHighTransform,
      returnChangeTransform]
    rcases List.mem_cons.mp member with first | member
    · rw [first]
      exact List.mem_cons.mpr (Or.inr (List.mem_cons.mpr (Or.inr
        (List.mem_cons.mpr (Or.inr (List.mem_cons.mpr (Or.inl rfl)))))))
    · rcases List.mem_cons.mp member with second | third
      · rw [second]
        exact List.mem_cons.mpr (Or.inr (List.mem_cons.mpr (Or.inr
          (List.mem_cons.mpr (Or.inr (List.mem_cons.mpr (Or.inr
            (List.mem_cons.mpr (Or.inl rfl)))))))))
      · rw [List.mem_singleton.mp third]
        exact List.mem_cons.mpr (Or.inr (List.mem_cons.mpr (Or.inr
          (List.mem_cons.mpr (Or.inl rfl)))))
  perspectiveGuidesSelection := by
    constructor <;> rfl

theorem embodiedCandidateIsInhabited :
    EmbodiedRecurrentAt systemBody (state true .forwardHigh) :=
  ⟨embodiedStructure⟩

def perspectiveOnlyBody : Body ToyPart systemEntity where
  states := systemPersistence.states
  statesNonempty := by simp [systemPersistence]
  statesWithinPersistence := by intro state member; exact member
  statesOrdered := systemPersistence.ordered
  partAt := fun _ _ => True
  eachStateHasConstituent := by intro state member; exact ⟨.sensor, trivial⟩
  interior := internalSpecification
  environment := ⟨fun current => current.value.2 = .environment⟩
  interiorEnvironmentDisjoint := by
    intro current internal external
    exact internal external
  recurringTransformations := [forwardLowTransform]
  recurringNonempty := by simp
  feeding := unconstrainedFeed
  identityPath := singletonPath forwardLowTransform
  identityPathNonempty := by simp [singletonPath]
  recurringOccursInPath := by
    intro transformation member
    simp at member
    subst transformation
    exact List.mem_cons_self
  recurringWithinInterior := by
    intro transformation member
    simp at member
    subst transformation
    simp [internalSpecification, forwardLowTransform, transform, state]
  recurringAdmittedByBoundary := by
    intro transformation member constraint constraintMember
    simp at member
    subst transformation
    simp [systemEntity, systemBoundary] at constraintMember
    subst constraint
    simp [internalOnly, systemIdentity, forwardLowTransform, transform, state]
  recurringPreservesIdentity := by
    intro transformation member
    simp at member
    subst transformation
    simp [systemEntity, systemIdentity, forwardLowTransform, transform, state]

def perspectiveOnlyPerception :
    PerspectivePerception ToyPart perspectiveOnlyBody true false where
  difference := by decide
  state := state true .forwardInput
  stateIsInternal := by
    simp [perspectiveOnlyBody, internalSpecification, state]
  contribution := forwardContribution
  stateRegistersCondition := rfl
  differenceIsUpstream := ⟨rfl, rfl⟩

def perspectiveOnlyMemory :
    PerspectiveMemory ToyPart perspectiveOnlyBody true false where
  difference := by decide
  recordedState := state true .returnInput
  persistence := memoryPersistence
  recordedStateInPersistence := by simp [memoryPersistence]
  recordedStateIsInternal := by
    simp [perspectiveOnlyBody, internalSpecification, state]
  contribution := returnContribution
  recordedStateSuppliesMemory := rfl
  contributionResultInPersistence := by
    simp [memoryPersistence, returnContribution, returnChangeTransform]
  differenceIsUpstream := ⟨rfl, rfl⟩

def perspectiveOnlyModel :
    PerspectiveModel ToyPart perspectiveOnlyBody
      perspectiveOnlyPerception perspectiveOnlyMemory where
  representations := [true, false]
  conditionRepresentationInModel := by simp
  contrastConditionRepresentationInModel := by simp
  memoryRepresentationInModel := by simp
  contrastMemoryRepresentationInModel := by simp
  transformations := [forwardLowTransform]
  transformationsNonempty := by simp
  transformationsWithinBody := by simp [perspectiveOnlyBody]
  laterStates := [state true .forwardHigh, state true .returnHigh]
  perceptionResultInLaterStates := by
    simp [perspectiveOnlyPerception, forwardContribution, forwardChangeTransform]
  memoryResultInLaterStates := by
    simp [perspectiveOnlyMemory, returnContribution, returnChangeTransform]
  constraints := [internalOnly]
  constraintsNonempty := by simp
  constraintsFromBoundary := by
    intro constraint member
    simpa [systemEntity, systemBoundary] using member

def perspectiveOnly : EmbodiedPerspective ToyPart perspectiveOnlyBody where
  conditionRepresentation := true
  contrastConditionRepresentation := false
  representedCondition := state true .forwardHigh
  conditionDenotation := ⟨true, state true .forwardHigh⟩
  denotationNamesCondition := ⟨rfl, rfl⟩
  representedConditionIsInternal := by
    simp [perspectiveOnlyBody, internalSpecification, state]
  availableTransformations := [forwardLowTransform]
  availableNonempty := by simp
  availableWithinBody := by simp [perspectiveOnlyBody]
  availableRepresentation := fun transformation => transformation.output.value.1
  availableDenotation := fun transformation =>
    ⟨transformation.output.value.1, transformation.output⟩
  availableDenotationExact := by simp
  perception := perspectiveOnlyPerception
  memoryRepresentation := true
  contrastMemoryRepresentation := false
  memory := perspectiveOnlyMemory
  model := perspectiveOnlyModel
  perceptionChangesInternal := by
    simp [perspectiveOnlyPerception, perspectiveOnlyBody,
      internalSpecification, forwardContribution, forwardChangeTransform, state]
  memoryChangesInternal := by
    simp [perspectiveOnlyMemory, perspectiveOnlyBody,
      internalSpecification, returnContribution, returnChangeTransform, state]

theorem perspectiveOnlyHasNoSelection :
    ¬ Nonempty (InternalActivitySelection ToyPart perspectiveOnlyBody) := by
  rintro ⟨selection⟩
  have selectedMember := selection.optionsWithinBody
    selection.selected selection.selectedInOptions
  have rejectedMember := selection.optionsWithinBody
    selection.rejected selection.rejectedInOptions
  have selectedEq : selection.selected = forwardLowTransform := by
    simpa [perspectiveOnlyBody] using selectedMember
  have rejectedEq : selection.rejected = forwardLowTransform := by
    simpa [perspectiveOnlyBody] using rejectedMember
  exact selection.discriminates (selectedEq.trans rejectedEq.symm)

theorem embodiedPerspectiveDoesNotEntailCandidate :
    perspectiveOnly.representedCondition = state true .forwardHigh ∧
    ¬ EmbodiedRecurrentAt perspectiveOnlyBody (state true .forwardHigh) := by
  constructor
  · rfl
  · rintro ⟨candidate⟩
    exact perspectiveOnlyHasNoSelection ⟨candidate.selection⟩

structure SharedSignal (Process Signal : Type u) where
  first : Process
  second : Process
  distinct : first ≠ second
  shared : Signal

inductive ToyProcess where
  | sensory | regulatory
deriving DecidableEq, Repr

def sharedSignal : SharedSignal ToyProcess Bool :=
  ⟨.sensory, .regulatory, by decide, true⟩

def noDirection : Direction (Bool × Unit) where
  before := fun _ _ => False
  asymmetric := by simp

def noFeed : FeedRelation (Bool × Unit) := ⟨fun _ _ => True⟩

theorem sharedSignalDoesNotEntailRecurrentIntegration :
    Nonempty (SharedSignal ToyProcess Bool) ∧
    ¬ Nonempty (RecurrentIntegration noDirection noFeed) := by
  constructor
  · exact ⟨sharedSignal⟩
  · rintro ⟨integration⟩
    exact integration.firstToSecond.leftEndpoints.first.advances

structure SharedEnclosure
    (Organ Part : Type u) (body : Body Part systemEntity) where
  first : Organ
  second : Organ
  distinct : first ≠ second
  organPart : Organ → Part
  firstPresent : ∃ state, body.partAt state (organPart first)
  secondPresent : ∃ state, body.partAt state (organPart second)

def enclosedOrgans : SharedEnclosure ToyOrgan ToyPart perspectiveOnlyBody where
  first := .sensor
  second := .regulator
  distinct := by decide
  organPart := fun | .sensor => .sensor | .regulator => .regulator
  firstPresent := ⟨state false .forwardInput, trivial⟩
  secondPresent := ⟨state false .forwardInput, trivial⟩

theorem sharedEnclosureDoesNotEntailBodilyOrganization :
    Nonempty (SharedEnclosure ToyOrgan ToyPart perspectiveOnlyBody) ∧
    ¬ Nonempty (BodilyOrganization ToyOrgan ToyPart perspectiveOnlyBody) := by
  constructor
  · exact ⟨enclosedOrgans⟩
  · rintro ⟨organization⟩
    obtain ⟨first, second, firstMember, secondMember, distinct, _, _⟩ :=
      organization.coordinationWitness
    have recurringDistinct := organization.recurringPairwiseDistinct
      first firstMember second secondMember distinct
    have firstInBody := organization.recurringInBody first firstMember
    have secondInBody := organization.recurringInBody second secondMember
    have firstEq : organization.recurring first = forwardLowTransform := by
      simpa [perspectiveOnlyBody] using firstInBody
    have secondEq : organization.recurring second = forwardLowTransform := by
      simpa [perspectiveOnlyBody] using secondInBody
    exact recurringDistinct (firstEq.trans secondEq.symm)

end DanielOntology.EmbodiedConsciousnessProposal
