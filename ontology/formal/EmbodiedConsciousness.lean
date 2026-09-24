import BridgeRelations
import Consciousness

/-!
# Embodiment and recurrent consciousness candidate: formal shadow

This noncanonical module formalizes one candidate condition for the still-
quarantined underlying condition of consciousness. It does not define a
universal `Consciousness` predicate and does not alter Attribution or
Designation.
-/

universe u v w x y z

namespace DanielOntology.EmbodiedConsciousnessProposal

open ConsciousnessProposal

structure Body
    (Part : Type u)
    {Feature : Type v}
    {Context : Type w}
    (entity : Entity (Feature × Context)) where
  states : List (State (Feature × Context))
  statesNonempty : states ≠ []
  identityHolds : ∀ state, state ∈ states → entity.identity.holds state
  partAt : State (Feature × Context) → Part → Prop
  interior : Scope (State (Feature × Context))
  environment : Scope (State (Feature × Context))
  interiorEnvironmentDisjoint :
    ∀ state, interior.includes state → ¬ environment.includes state
  boundaryConstraints : List (Constraint (Feature × Context))
  carriesEntityBoundary :
    ∀ constraint,
      constraint ∈ entity.boundary.constraints →
        constraint ∈ boundaryConstraints
  recurringTransformations :
    List (Transformation entity.persistenceDirection)
  recurringNonempty : recurringTransformations ≠ []
  feeding : FeedRelation (Feature × Context)
  identityPath : CausalPath entity.persistenceDirection feeding
  identityPathNonempty : identityPath.steps ≠ []
  recurringOccursInPath :
    ∀ transformation,
      transformation ∈ recurringTransformations →
        transformation ∈ identityPath.steps
  recurringWithinInterior :
    ∀ transformation,
      transformation ∈ recurringTransformations →
        interior.includes transformation.input ∧
        interior.includes transformation.output
  recurringPreservesIdentity :
    ∀ transformation,
      transformation ∈ recurringTransformations →
        entity.identity.holds transformation.input ∧
        entity.identity.holds transformation.output

structure BodilyOrganization
    (Organ Part : Type u)
    {Feature : Type v}
    {Context : Type w}
    {entity : Entity (Feature × Context)}
    (body : Body Part entity)
    (feeding : FeedRelation (Feature × Context)) where
  organs : List Organ
  organsNonempty : organs ≠ []
  organPart : Organ → Part
  recurring : Organ → Transformation entity.persistenceDirection
  recurringInBody :
    ∀ organ, organ ∈ organs → recurring organ ∈ body.recurringTransformations
  sustainingContribution :
    Organ → CausalContribution Feature Context entity.persistenceDirection feeding
  recurringOccursInContribution :
    ∀ organ, organ ∈ organs →
      recurring organ ∈ (sustainingContribution organ).leftPath.steps ∨
      recurring organ ∈ (sustainingContribution organ).rightPath.steps
  coordinated : Organ → Organ → Prop
  coordinationWitness :
    ∃ first second,
      first ∈ organs ∧ second ∈ organs ∧ first ≠ second ∧
        coordinated first second
  sustainsIdentity :
    ∀ organ, organ ∈ organs →
      entity.identity.holds (recurring organ).output
  contributionSustainsIdentity :
    ∀ organ, organ ∈ organs →
      entity.identity.holds
        (sustainingContribution organ).downstreamChange.transformation.output

structure EmbodiedPerspective
    (Representation Percept Memory Part : Type u)
    {Feature : Type v}
    {Context : Type w}
    {entity : Entity (Feature × Context)}
    (body : Body Part entity)
    (feeding : FeedRelation (Feature × Context)) where
  representation : Representation
  perception : Percept
  memory : Memory
  representedCondition : State (Feature × Context)
  conditionDenotation : Denotation Representation (State (Feature × Context))
  denotationNamesCondition : conditionDenotation.expression = representation ∧
    conditionDenotation.target = representedCondition
  representedConditionIsInternal : body.interior.includes representedCondition
  availableTransformations :
    List (Transformation entity.persistenceDirection)
  availableNonempty : availableTransformations ≠ []
  availableWithinBody :
    ∀ transformation,
      transformation ∈ availableTransformations →
        transformation ∈ body.recurringTransformations
  perceptionContribution :
    CausalContribution Feature Context entity.persistenceDirection feeding
  memoryContribution :
    CausalContribution Feature Context entity.persistenceDirection feeding
  perceptionChangesInternal : body.interior.includes
    perceptionContribution.downstreamChange.transformation.output
  memoryChangesInternal : body.interior.includes
    memoryContribution.downstreamChange.transformation.output

structure RecurrentIntegration
    (Process : Type u)
    {Feature : Type v}
    {Context : Type w}
    (direction : Direction (Feature × Context))
    (feeding : FeedRelation (Feature × Context)) where
  firstProcess : Process
  secondProcess : Process
  processesDistinct : firstProcess ≠ secondProcess
  registersDifference : Process → Feature → Feature → Prop
  affectsProcess : Process → Change direction → Prop
  firstToSecond : CausalContribution Feature Context direction feeding
  secondToFirst : CausalContribution Feature Context direction feeding
  firstRegisters : registersDifference firstProcess
    firstToSecond.leftEndpoints.first.input.value.1
    firstToSecond.rightEndpoints.first.input.value.1
  secondAffected : affectsProcess secondProcess firstToSecond.downstreamChange
  secondRegisters : registersDifference secondProcess
    secondToFirst.leftEndpoints.first.input.value.1
    secondToFirst.rightEndpoints.first.input.value.1
  firstAffected : affectsProcess firstProcess secondToFirst.downstreamChange
  returnOccursLater : direction.before
    firstToSecond.downstreamChange.transformation.output
    secondToFirst.leftEndpoints.first.input

inductive RevisionMode where
  | select
  | continue
  | inhibit
  | revise
deriving DecidableEq, Repr

structure InternalActivitySelection
    (Representation Part : Type u)
    {Feature : Type v}
    {Context : Type w}
    {entity : Entity (Feature × Context)}
    (body : Body Part entity)
    (feeding : FeedRelation (Feature × Context)) where
  representation : Representation
  representedOutcome : State (Feature × Context)
  outcomeDenotation : Denotation Representation (State (Feature × Context))
  denotationNamesOutcome : outcomeDenotation.expression = representation ∧
    outcomeDenotation.target = representedOutcome
  contribution :
    CausalContribution Feature Context entity.persistenceDirection feeding
  options : List (Transformation entity.persistenceDirection)
  selected : Transformation entity.persistenceDirection
  rejected : Transformation entity.persistenceDirection
  selectedInOptions : selected ∈ options
  rejectedInOptions : rejected ∈ options
  optionsWithinBody :
    ∀ transformation,
      transformation ∈ options → transformation ∈ body.recurringTransformations
  discriminates : selected ≠ rejected
  representedOutcomeIsSelectedOutput : representedOutcome = selected.output
  contributionSelects :
    contribution.downstreamChange.transformation.output = selected.output
  mode : RevisionMode

structure EmbodiedConsciousnessCandidate
    (Subject Moment Condition Process Representation Percept Memory Part : Type u)
    {Feature : Type v}
    {Context : Type w}
    {entity : Entity (Feature × Context)}
    {feeding : FeedRelation (Feature × Context)}
    (body : Body Part entity) where
  subject : Subject
  moment : Moment
  candidate : CandidateCondition Subject Moment Condition
  obtains : candidate.holds subject moment
  perspective :
    EmbodiedPerspective Representation Percept Memory Part body feeding
  integration :
    RecurrentIntegration Process entity.persistenceDirection feeding
  selection : InternalActivitySelection Representation Part body feeding
  perspectiveGuidesSelection :
    perspective.representation = selection.representation ∧
    perspective.perceptionContribution = selection.contribution

/-! ## Finite inhabited model -/

inductive Stage where
  | forwardInput
  | forwardLow
  | forwardHigh
  | returnInput
  | returnLow
  | returnHigh
  | environment
deriving DecidableEq, Repr

def Stage.rank : Stage → Nat
  | .forwardInput => 0
  | .forwardLow => 1
  | .forwardHigh => 2
  | .returnInput => 3
  | .returnLow => 4
  | .returnHigh => 5
  | .environment => 6

abbrev Carrier := Bool × Stage

def systemDirection : Direction Carrier where
  before := fun input output => input.value.2.rank < output.value.2.rank
  asymmetric := by
    intro input output forward reverse
    exact (Nat.not_lt_of_ge (Nat.le_of_lt reverse)) forward

def unconstrainedFeed : FeedRelation Carrier where
  feeds := fun _ _ => True

def state (feature : Bool) (stage : Stage) : State Carrier :=
  ⟨(feature, stage)⟩

def transform (feature : Bool) (input output : Stage)
    (advances : input.rank < output.rank) : Transformation systemDirection where
  input := state feature input
  output := state feature output
  advances := advances

def forwardLowTransform : Transformation systemDirection :=
  transform false .forwardInput .forwardLow (by decide)

def forwardHighTransform : Transformation systemDirection :=
  transform true .forwardInput .forwardHigh (by decide)

def forwardChangeTransform : Transformation systemDirection :=
  { input := state false .forwardLow
    output := state true .forwardHigh
    advances := by simp [systemDirection, state, Stage.rank] }

def returnLowTransform : Transformation systemDirection :=
  transform false .returnInput .returnLow (by decide)

def returnHighTransform : Transformation systemDirection :=
  transform true .returnInput .returnHigh (by decide)

def returnChangeTransform : Transformation systemDirection :=
  { input := state false .returnLow
    output := state true .returnHigh
    advances := by simp [systemDirection, state, Stage.rank] }

def singletonPath (transformation : Transformation systemDirection) :
    CausalPath systemDirection unconstrainedFeed where
  steps := [transformation]
  connected := trivial

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
  downstreamChange := {
    transformation := forwardChangeTransform
    differs := by simp [forwardChangeTransform, state]
  }
  changeStartsAt := rfl
  changeEndsAt := rfl

def returnContribution :
    CausalContribution Bool Stage systemDirection unconstrainedFeed where
  leftPath := singletonPath returnLowTransform
  rightPath := singletonPath returnHighTransform
  leftEndpoints := singletonEndpoints returnLowTransform
  rightEndpoints := singletonEndpoints returnHighTransform
  sameDeclaredContext := rfl
  inputDiffers := by decide
  downstreamChange := {
    transformation := returnChangeTransform
    differs := by simp [returnChangeTransform, state]
  }
  changeStartsAt := rfl
  changeEndsAt := rfl

def systemIdentity : Invariant Carrier where
  holds := fun current => current.value.2 ≠ .environment

def internalOnly : Constraint Carrier where
  permits := fun transformation => systemIdentity.holds transformation.output

def systemBoundary : Boundary Carrier systemIdentity where
  constraints := [internalOnly]
  preserves := by
    intro direction transformation admitted _
    exact admitted internalOnly (by simp)

def systemPersistence : PersistenceWitness systemDirection where
  states := [
    state false .forwardInput,
    state false .forwardLow,
    state true .forwardHigh,
    state false .returnInput,
    state false .returnLow,
    state true .returnHigh
  ]
  hasTransition := ⟨state false .forwardInput, state false .forwardLow,
    [state true .forwardHigh, state false .returnInput,
      state false .returnLow, state true .returnHigh], rfl⟩
  invariant := systemIdentity
  invariantHolds := by
    intro current member
    simp [systemIdentity, state] at member ⊢
    rcases member with rfl | rfl | rfl | rfl | rfl | rfl <;> decide
  ordered := by
    simp [OrderedBy, systemDirection, state, Stage.rank]

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
  | sensor
  | regulator
deriving DecidableEq, Repr

def systemBody : Body ToyPart systemEntity where
  states := systemPersistence.states
  statesNonempty := by simp [systemPersistence]
  identityHolds := by
    intro current member
    exact systemPersistence.invariantHolds current member
  partAt := fun current part =>
    (current = state false .forwardInput ∧ part = .sensor) ∨
    (current ≠ state false .forwardInput ∧ part = .regulator)
  interior := ⟨fun current => current.value.2 ≠ .environment⟩
  environment := ⟨fun current => current.value.2 = .environment⟩
  interiorEnvironmentDisjoint := by simp
  boundaryConstraints := [internalOnly]
  carriesEntityBoundary := by
    intro constraint member
    simpa [systemEntity, systemBoundary] using member
  recurringTransformations := [
    forwardLowTransform, forwardHighTransform,
    returnLowTransform, returnHighTransform
  ]
  recurringNonempty := by simp
  feeding := unconstrainedFeed
  identityPath := {
    steps := [
      forwardLowTransform, forwardHighTransform,
      returnLowTransform, returnHighTransform
    ]
    connected := by simp [Chains, unconstrainedFeed]
  }
  identityPathNonempty := by simp
  recurringOccursInPath := by
    intro transformation member
    simpa using member
  recurringWithinInterior := by
    intro transformation member
    simp at member
    rcases member with rfl | rfl | rfl | rfl <;>
      simp [systemEntity, systemIdentity, forwardLowTransform,
        forwardHighTransform, returnLowTransform, returnHighTransform,
        transform, state]
  recurringPreservesIdentity := by
    intro transformation member
    simp at member
    rcases member with rfl | rfl | rfl | rfl <;>
      simp [systemEntity, systemIdentity, forwardLowTransform,
        forwardHighTransform, returnLowTransform, returnHighTransform,
        transform, state]

theorem bodyCanPersistAcrossPartChange :
    systemDirection.before
      (state false .forwardInput) (state false .forwardLow) ∧
    systemEntity.identity.holds (state false .forwardInput) ∧
    systemEntity.identity.holds (state false .forwardLow) ∧
    systemBody.partAt (state false .forwardInput) .sensor ∧
    ¬ systemBody.partAt (state false .forwardLow) .sensor := by
  simp [systemDirection, systemEntity, systemIdentity, systemBody,
    state, Stage.rank]

theorem bodyBoundaryDoesNotRequireIsolation :
    systemBody.environment.includes (state false .environment) ∧
    ¬ systemBody.interior.includes (state false .environment) ∧
    systemBody.interior.includes (state false .forwardInput) := by
  simp [systemBody, state]

inductive ToyOrgan where
  | sensor
  | regulator
deriving DecidableEq, Repr

def systemOrganization :
    BodilyOrganization ToyOrgan ToyPart systemBody unconstrainedFeed where
  organs := [.sensor, .regulator]
  organsNonempty := by simp
  organPart := fun
    | .sensor => .sensor
    | .regulator => .regulator
  recurring := fun
    | .sensor => forwardLowTransform
    | .regulator => returnLowTransform
  recurringInBody := by intro organ _; cases organ <;> simp [systemBody]
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
  coordinated := (· ≠ ·)
  coordinationWitness := ⟨.sensor, .regulator, by simp, by simp, by decide, by decide⟩
  sustainsIdentity := by
    intro organ _
    cases organ <;>
      simp [systemEntity, systemIdentity, forwardLowTransform,
        returnLowTransform, transform, state]
  contributionSustainsIdentity := by
    intro organ _
    cases organ <;>
      simp [systemEntity, systemIdentity, forwardContribution,
        returnContribution, forwardChangeTransform, returnChangeTransform,
        state]

inductive ToyProcess where
  | sensory
  | regulatory
deriving DecidableEq, Repr

def systemIntegration :
    RecurrentIntegration ToyProcess systemDirection unconstrainedFeed where
  firstProcess := .sensory
  secondProcess := .regulatory
  processesDistinct := by decide
  registersDifference := fun _ low high => low = false ∧ high = true
  affectsProcess := fun _ _ => True
  firstToSecond := forwardContribution
  secondToFirst := returnContribution
  firstRegisters := by decide
  secondAffected := trivial
  secondRegisters := by decide
  firstAffected := trivial
  returnOccursLater := by
    change Stage.forwardHigh.rank < Stage.returnInput.rank
    decide

inductive ToyRepresentation where
  | ownCondition
deriving DecidableEq, Repr

def systemPerspective :
    EmbodiedPerspective ToyRepresentation Unit Unit ToyPart
      systemBody unconstrainedFeed where
  representation := .ownCondition
  perception := ()
  memory := ()
  representedCondition := state true .forwardHigh
  conditionDenotation := ⟨.ownCondition, state true .forwardHigh⟩
  denotationNamesCondition := ⟨rfl, rfl⟩
  representedConditionIsInternal := by simp [systemBody, state]
  availableTransformations := [forwardLowTransform, returnLowTransform]
  availableNonempty := by simp
  availableWithinBody := by
    intro transformation member
    simp at member
    rcases member with rfl | rfl <;> simp [systemBody]
  perceptionContribution := forwardContribution
  memoryContribution := returnContribution
  perceptionChangesInternal := by simp [systemBody, forwardContribution,
    forwardChangeTransform, state]
  memoryChangesInternal := by simp [systemBody, returnContribution,
    returnChangeTransform, state]

def systemSelection :
    InternalActivitySelection ToyRepresentation ToyPart
      systemBody unconstrainedFeed where
  representation := .ownCondition
  representedOutcome := state true .forwardHigh
  outcomeDenotation := ⟨.ownCondition, state true .forwardHigh⟩
  denotationNamesOutcome := ⟨rfl, rfl⟩
  contribution := forwardContribution
  options := [forwardLowTransform, forwardHighTransform]
  selected := forwardHighTransform
  rejected := forwardLowTransform
  selectedInOptions := by simp
  rejectedInOptions := by simp
  optionsWithinBody := by
    intro transformation member
    simp at member
    rcases member with rfl | rfl <;> simp [systemBody]
  discriminates := by
    intro equal
    have inputs := congrArg Transformation.input equal
    simp [forwardHighTransform, forwardLowTransform, transform, state] at inputs
  representedOutcomeIsSelectedOutput := rfl
  contributionSelects := rfl
  mode := .revise

inductive ToySubject where
  | system
deriving DecidableEq, Repr

inductive ToyMoment where
  | integrated
  | perspectiveOnly
deriving DecidableEq, Repr

inductive ToyCondition where
  | embodiedRecurrent
deriving DecidableEq, Repr

def candidateScope : Scope (ToySubject × ToyMoment) where
  includes := fun pair => pair.1 = .system

def candidateObtains : ToyCondition → ToySubject → ToyMoment → Prop
  | .embodiedRecurrent, .system, .integrated => True
  | .embodiedRecurrent, .system, .perspectiveOnly => False

def embodiedCandidateCondition :
    CandidateCondition ToySubject ToyMoment ToyCondition where
  condition := .embodiedRecurrent
  obtains := candidateObtains
  specification := {
    scope := candidateScope
    conforms := fun pair => pair = (.system, .integrated)
    decideConformity := fun pair => decide (pair = (.system, .integrated))
    conformityCorrect := by intro pair; simp
    conformityWithinScope := by
      intro pair conforming
      subst pair
      simp [candidateScope]
  }
  specificationCorrect := by
    intro subject moment
    cases subject <;> cases moment <;> simp [candidateObtains]

def embodiedCandidate :
    @EmbodiedConsciousnessCandidate
      ToySubject ToyMoment ToyCondition ToyProcess ToyRepresentation
      Unit Unit ToyPart Bool Stage systemEntity unconstrainedFeed systemBody where
  subject := .system
  moment := .integrated
  candidate := embodiedCandidateCondition
  obtains := by simp [CandidateCondition.holds, embodiedCandidateCondition,
    candidateObtains]
  perspective := systemPerspective
  integration := systemIntegration
  selection := systemSelection
  perspectiveGuidesSelection := ⟨rfl, rfl⟩

theorem embodiedCandidateIsInhabited :
    Nonempty
      (@EmbodiedConsciousnessCandidate
        ToySubject ToyMoment ToyCondition ToyProcess ToyRepresentation
        Unit Unit ToyPart Bool Stage systemEntity unconstrainedFeed systemBody) :=
  ⟨embodiedCandidate⟩

def verbalSelfDescription (_ : ToySubject) (_ : ToyMoment) : Prop := False
def outwardAction (_ : ToySubject) (_ : ToyMoment) : Prop := False
def completeControl (_ : ToySubject) (_ : ToyMoment) : Prop := False

theorem candidateDoesNotRequireSpeechActionOrCompleteControl :
    embodiedCandidate.candidate.holds
      embodiedCandidate.subject embodiedCandidate.moment ∧
    ¬ verbalSelfDescription embodiedCandidate.subject embodiedCandidate.moment ∧
    ¬ outwardAction embodiedCandidate.subject embodiedCandidate.moment ∧
    ¬ completeControl embodiedCandidate.subject embodiedCandidate.moment := by
  simp [embodiedCandidate, CandidateCondition.holds, embodiedCandidateCondition,
    candidateObtains, verbalSelfDescription, outwardAction, completeControl]

theorem embodiedPerspectiveDoesNotEntailCandidate :
    Nonempty
      (EmbodiedPerspective ToyRepresentation Unit Unit ToyPart
        systemBody unconstrainedFeed) ∧
    ¬ embodiedCandidateCondition.holds .system .perspectiveOnly := by
  exact ⟨⟨systemPerspective⟩, by
    simp [CandidateCondition.holds, embodiedCandidateCondition, candidateObtains]⟩

structure SharedSignal (Process Signal : Type u) where
  first : Process
  second : Process
  distinct : first ≠ second
  shared : Signal

def sharedSignal : SharedSignal ToyProcess Bool where
  first := .sensory
  second := .regulatory
  distinct := by decide
  shared := true

def noDirection : Direction (Bool × Unit) where
  before := fun _ _ => False
  asymmetric := by simp

def noFeed : FeedRelation (Bool × Unit) where
  feeds := fun _ _ => True

theorem sharedSignalDoesNotEntailRecurrentIntegration :
    Nonempty (SharedSignal ToyProcess Bool) ∧
    ¬ Nonempty (RecurrentIntegration ToyProcess noDirection noFeed) := by
  constructor
  · exact ⟨sharedSignal⟩
  · rintro ⟨integration⟩
    exact integration.firstToSecond.leftEndpoints.first.advances

structure SharedEnclosure (Entity Organ : Type u) where
  entity : Entity
  organs : List Organ
  organsNonempty : organs ≠ []

def enclosedOrgans : SharedEnclosure Unit ToyOrgan where
  entity := ()
  organs := [.sensor, .regulator]
  organsNonempty := by simp

def hasBodilyUnity (_ : SharedEnclosure Unit ToyOrgan) : Prop := False

theorem sharedEnclosureDoesNotEntailBodilyOrganization :
    Nonempty (SharedEnclosure Unit ToyOrgan) ∧
    ¬ hasBodilyUnity enclosedOrgans := by
  exact ⟨⟨enclosedOrgans⟩, by simp [hasBodilyUnity]⟩

end DanielOntology.EmbodiedConsciousnessProposal
