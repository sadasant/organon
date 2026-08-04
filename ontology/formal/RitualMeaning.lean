import BridgeRelations

/-!
# Flow, Ritual, and ritual-dependent Meaning

This noncanonical shadow reuses `Flow` for recurrence. It does not introduce a
second recurrence term. A Ritual adds participant-bound causal access to a
Flow; Meaning is the participant-indexed Relation sustained by that Ritual.
Records and Memories produced by Ritual remain ordinary derived effects rather
than a second container for Meaning.
-/

universe u v

namespace DanielOntology

/-! A Flow Rule belongs to a classification of a Flow, not to its obtainment. -/
structure FlowRule
    {Carrier : Type u}
    (direction : Direction Carrier) where
  specification : Specification (Transformation direction)

structure Flow
    {Carrier : Type u}
    (direction : Direction Carrier) where
  occurrences : List (Transformation direction)
  hasRepeatedOccurrences :
    ∃ first second rest,
      occurrences = first :: second :: rest ∧
      (first.input ≠ second.input ∨ first.output ≠ second.output)
  occurrencesOrdered : OrderedBy direction.before (occurrences.map (·.output))
  scope : Scope (Transformation direction)
  occurrencesInScope :
    ∀ occurrence, occurrence ∈ occurrences → scope.includes occurrence
  recurrence : Transformation direction → Transformation direction → Prop
  occurrencesRecur : OrderedBy recurrence occurrences
  persistence : PersistenceWitness direction
  occurrenceOutputsArePersistence :
    occurrences.map (·.output) = persistence.states

/-!
Classification is an epistemic and operational witness for a Flow Claim. It
does not constitute the Flow. The Rule owns the exact constructive
Specification, every selected occurrence conforms, and at least one in-Scope
non-occurrence is rejected so the classifier is not extensionally universal.
-/
structure FlowClassification
    {Carrier : Type u}
    {direction : Direction Carrier}
    (flow : Flow direction) where
  rule : FlowRule direction
  classificationScopeMatchesFlow :
    ∀ candidate,
      rule.specification.scope.includes candidate ↔
        flow.scope.includes candidate
  occurrencesConform :
    ∀ occurrence, occurrence ∈ flow.occurrences →
      rule.specification.conforms occurrence
  classificationTracksRecurrence :
    OrderedBy
      (fun earlier later =>
        rule.specification.conforms earlier ∧
          rule.specification.conforms later ∧
          flow.recurrence earlier later)
      flow.occurrences
  rejectsInScopeNonOccurrence :
    ∃ candidate,
      rule.specification.scope.includes candidate ∧
      candidate ∉ flow.occurrences ∧
      ¬ rule.specification.conforms candidate

structure RitualAccess
    {Carrier : Type u}
    {direction : Direction Carrier}
    (feeding : FeedRelation Carrier)
  (flow : Flow direction)
  (participant : Entity Carrier) where
  index : Nat
  indexInBounds : index < flow.occurrences.length
  occurrence : Transformation direction
  occursInFlow : occurrence ∈ flow.occurrences
  occurrenceAtIndex : flow.occurrences[index]? = some occurrence
  path : CausalPath direction feeding
  endpoints : PathEndpoints path
  beginsWithOccurrence : endpoints.first = occurrence
  effectEntersParticipantHistory :
    endpoints.last.output ∈ participant.persistence.states

/-!
Target continuity permits the target State to change while requiring every
State in the declared history to satisfy one identity Invariant. Exact State
equality is therefore neither required nor sufficient for continuity.
-/
structure TargetContinuity (Target : Type u) where
  direction : Direction Target
  persistence : PersistenceWitness direction
  current : State Target
  currentInPersistence : current ∈ persistence.states

/-!
This proposal-local uptake witness makes Memory load-bearing for
Interpretation. The earlier contribution endpoint is retained in the
participant history; the later path contains the Interpretation occurrence;
and a contrastive Memory changes the constructive Interpretation result.
-/
structure RitualUptake
    {Feature : Type u}
    {Context : Type v}
    {direction : Direction (Feature × Context)}
    (feeding : FeedRelation (Feature × Context))
    (flow : Flow direction)
    (classification : FlowClassification flow)
    (participant : Entity (Feature × Context)) where
  priorIndex : Nat
  currentIndex : Nat
  priorBeforeCurrent : priorIndex < currentIndex
  priorOccurrence : Transformation direction
  currentOccurrence : Transformation direction
  priorOccursInFlow : priorOccurrence ∈ flow.occurrences
  currentOccursInFlow : currentOccurrence ∈ flow.occurrences
  priorAtIndex : flow.occurrences[priorIndex]? = some priorOccurrence
  currentAtIndex : flow.occurrences[currentIndex]? = some currentOccurrence
  recurrenceHolds : flow.recurrence priorOccurrence currentOccurrence
  priorClassified : classification.rule.specification.conforms priorOccurrence
  currentClassified :
    classification.rule.specification.conforms currentOccurrence
  contribution : CausalContribution Feature Context direction feeding
  contributionBeginsWithPrior :
    contribution.leftEndpoints.first = priorOccurrence
  contributionBeginsWithCurrent :
    contribution.rightEndpoints.first = currentOccurrence
  memory : State (Feature × Context)
  memoryIsPriorEffect : contribution.leftEndpoints.last.output = memory
  memoryInParticipantHistory : memory ∈ participant.persistence.states
  currentPerception : State (Feature × Context)
  perceptionBeginsInterpretation : currentOccurrence.input = currentPerception
  interpretation : Transformation direction
  interpretationIsCurrentOccurrence : interpretation = currentOccurrence
  interpretationOccursInContribution :
    interpretation ∈ contribution.rightPath.steps
  interpretationRule :
    State (Feature × Context) →
      State (Feature × Context) → State (Feature × Context)
  interpretedState : State (Feature × Context)
  interpretationHolds :
    interpretationRule currentPerception memory = interpretedState
  interpretationProducesState : interpretation.output = interpretedState
  contributionEndsAtInterpretation :
    contribution.rightEndpoints.last.output = interpretedState
  interpretedStateInParticipantHistory :
    interpretedState ∈ participant.persistence.states
  contrastiveMemory : State (Feature × Context)
  contrastiveMemoryDiffers : contrastiveMemory ≠ memory
  contrastiveMemoryInParticipantHistory :
    contrastiveMemory ∈ participant.persistence.states
  memoryChangesInterpretation :
    interpretationRule currentPerception contrastiveMemory ≠ interpretedState
  contrastivePerception : State (Feature × Context)
  contrastivePerceptionDiffers : contrastivePerception ≠ currentPerception
  perceptionChangesInterpretation :
    interpretationRule contrastivePerception memory ≠ interpretedState

structure Ritual
    {Feature : Type u}
    {Context : Type v}
    {Target : Type u}
    {ParticipantIdentity : Type u}
    (direction : Direction (Feature × Context))
    (feeding : FeedRelation (Feature × Context)) where
  flow : Flow direction
  classification : FlowClassification flow
  participantIdentity : ParticipantIdentity
  participant : Entity (Feature × Context)
  target : TargetContinuity Target
  targetProjection : State (Feature × Context) → State Target
  targetStatesOccurThroughoutFlow :
    ∀ occurrence, occurrence ∈ flow.occurrences →
      targetProjection occurrence.output ∈ target.persistence.states
  accesses : List (RitualAccess feeding flow participant)
  accessesNonempty : accesses ≠ []
  everyOccurrenceAccessed :
    ∀ index, index < flow.occurrences.length →
      ∃ access : RitualAccess feeding flow participant,
        access ∈ accesses ∧ access.index = index
  uptakes : List (RitualUptake feeding flow classification participant)
  uptakesNonempty : uptakes ≠ []
  everyLaterOccurrenceUptaken :
    ∀ index, 0 < index → index < flow.occurrences.length →
      ∃ uptake : RitualUptake feeding flow classification participant,
        uptake ∈ uptakes ∧ uptake.currentIndex = index

inductive SustainingSide where
  | left
  | right
deriving DecidableEq, Repr

inductive MeaningSupportRoute where
  | direct
  | downstreamLeft
  | downstreamRight
deriving DecidableEq, Repr

/-!
`Meaning` is itself the participant-indexed Relation historically constituted
by the supplied Ritual. Its current sustaining contribution selects an actual
uptake and is either that uptake's contribution or begins downstream from its
interpreted State. It must also terminate in the participant State at which the
relation is currently carried, so it is not a decorative causal witness.
-/
structure Meaning
    {Feature : Type v}
    {Context : Type u}
    {Target : Type v}
    {ParticipantIdentity : Type v}
    {direction : Direction (Feature × Context)}
    {feeding : FeedRelation (Feature × Context)}
    (ritual : Ritual (Target := Target)
      (ParticipantIdentity := ParticipantIdentity) direction feeding)
    where
  scope : Scope (ParticipantIdentity × State Target)
  inScope :
    scope.includes (ritual.participantIdentity, ritual.target.current)
  supportingUptake :
    RitualUptake feeding ritual.flow ritual.classification ritual.participant
  supportingUptakeInRitual : supportingUptake ∈ ritual.uptakes
  sustainingContribution :
    CausalContribution Feature Context direction feeding
  supportRoute : MeaningSupportRoute
  supportJoined :
    match supportRoute with
    | .direct => sustainingContribution = supportingUptake.contribution
    | .downstreamLeft =>
        sustainingContribution.leftEndpoints.first.input =
          supportingUptake.interpretedState
    | .downstreamRight =>
        sustainingContribution.rightEndpoints.first.input =
          supportingUptake.interpretedState
  sustainingSide : SustainingSide
  contributionReachesParticipant :
    match sustainingSide with
    | .left =>
        sustainingContribution.leftEndpoints.last.output =
          ritual.participant.current
    | .right =>
        sustainingContribution.rightEndpoints.last.output =
          ritual.participant.current

def MeaningRelation
    {Feature : Type v}
    {Context : Type u}
    {Target : Type v}
    {ParticipantIdentity : Type v}
    {direction : Direction (Feature × Context)}
    {feeding : FeedRelation (Feature × Context)}
    {ritual : Ritual (Target := Target)
      (ParticipantIdentity := ParticipantIdentity) direction feeding}
    (_meaning : Meaning ritual) :
    ParticipantIdentity × State Target :=
  (ritual.participantIdentity, ritual.target.current)

theorem meaningSupportCarriesRitualTarget
    {Feature : Type v}
    {Context : Type u}
    {Target : Type v}
    {ParticipantIdentity : Type v}
    {direction : Direction (Feature × Context)}
    {feeding : FeedRelation (Feature × Context)}
    {ritual : Ritual (Target := Target)
      (ParticipantIdentity := ParticipantIdentity) direction feeding}
    (meaning : Meaning ritual) :
    ritual.targetProjection
        meaning.supportingUptake.priorOccurrence.output ∈
          ritual.target.persistence.states ∧
      ritual.targetProjection
        meaning.supportingUptake.currentOccurrence.output ∈
          ritual.target.persistence.states := by
  constructor
  · exact ritual.targetStatesOccurThroughoutFlow _
      meaning.supportingUptake.priorOccursInFlow
  · exact ritual.targetStatesOccurThroughoutFlow _
      meaning.supportingUptake.currentOccursInFlow

theorem meaningSupportPreservesTargetIdentity
    {Feature : Type v}
    {Context : Type u}
    {Target : Type v}
    {ParticipantIdentity : Type v}
    {direction : Direction (Feature × Context)}
    {feeding : FeedRelation (Feature × Context)}
    {ritual : Ritual (Target := Target)
      (ParticipantIdentity := ParticipantIdentity) direction feeding}
    (meaning : Meaning ritual) :
    ritual.target.persistence.invariant.holds
        (ritual.targetProjection
          meaning.supportingUptake.priorOccurrence.output) ∧
      ritual.target.persistence.invariant.holds
        (ritual.targetProjection
          meaning.supportingUptake.currentOccurrence.output) := by
  have targetStates := meaningSupportCarriesRitualTarget meaning
  constructor
  · exact ritual.target.persistence.invariantHolds _ targetStates.1
  · exact ritual.target.persistence.invariantHolds _ targetStates.2

/-!
Current maintenance is intentionally weaker than continuous visible
enactment. An actual causal effect can continue the Relation after the latest
enactment; mere storage or merely possible reuse cannot.
-/
def sustainingAvailable
    (enactmentActive derivedEffectContributes : Bool) : Bool :=
  enactmentActive || derivedEffectContributes

theorem derivedEffectCanSustainAfterEnactment :
    sustainingAvailable false true = true := by decide

theorem dormantResidueDoesNotSustain :
    sustainingAvailable false false = false := by decide

/-! ## Finite private Ritual and anti-collapse witnesses -/

def ritualFlowRule : FlowRule bridgeDirection where
  specification := {
    scope := ⟨fun _ => True⟩
    conforms := fun occurrence => occurrence.input.value.2 = .input
    decideConformity := fun occurrence =>
      occurrence.input.value.2 == .input
    conformityCorrect := by
      intro occurrence
      simp
    conformityWithinScope := by
      intro _ _
      trivial
  }

def bridgeInvariant : Invariant BridgeCarrier where
  holds := fun _ => True

def bridgeFlowPersistence : PersistenceWitness bridgeDirection where
  states := [lowOutputState, highOutputState]
  hasTransition := ⟨lowOutputState, highOutputState, [], rfl⟩
  invariant := bridgeInvariant
  invariantHolds := by
    intro _ _
    trivial
  ordered := by
    simp [OrderedBy, bridgeDirection, lowOutputState, highOutputState]

def bridgeFlowScope : Scope (Transformation bridgeDirection) :=
  ⟨fun _ => True⟩

def repeatedBridgeFlow : Flow bridgeDirection where
  occurrences := [lowTransformation, highTransformation]
  hasRepeatedOccurrences := by
    refine ⟨lowTransformation, highTransformation, [], rfl, ?_⟩
    left
    intro equal
    have values := congrArg (fun state : State BridgeCarrier => state.value.1) equal
    simp [lowTransformation, highTransformation, lowInputState,
      highInputState] at values
  occurrencesOrdered := by
    simp [OrderedBy, bridgeDirection, lowTransformation, highTransformation,
      lowOutputState, highOutputState]
  scope := bridgeFlowScope
  occurrencesInScope := by
    intro _ _
    trivial
  recurrence := fun earlier later =>
    earlier.output.value.2 = later.output.value.2 ∧
      earlier.output.value.1 ≠ later.output.value.1
  occurrencesRecur := by
    simp [OrderedBy, lowTransformation, highTransformation, lowOutputState,
      highOutputState]
  persistence := bridgeFlowPersistence
  occurrenceOutputsArePersistence := by
    simp [bridgeFlowPersistence, lowTransformation, highTransformation]

def ritualFlowClassification : FlowClassification repeatedBridgeFlow where
  rule := ritualFlowRule
  classificationScopeMatchesFlow := by
    intro _
    constructor <;> intro _ <;> trivial
  occurrencesConform := by
    intro occurrence member
    simp [repeatedBridgeFlow] at member
    rcases member with rfl | rfl
    · rfl
    · rfl
  classificationTracksRecurrence := by
    simp [OrderedBy, repeatedBridgeFlow, ritualFlowRule, lowTransformation,
      highTransformation, lowInputState, highInputState, lowOutputState,
      highOutputState]
  rejectsInScopeNonOccurrence := by
    refine ⟨bridgeOutputTransformation, trivial, ?_, ?_⟩
    · simp [repeatedBridgeFlow, bridgeOutputTransformation, lowTransformation,
        highTransformation, lowOutputState, highOutputState, lowInputState,
        highInputState]
    · simp [ritualFlowRule, bridgeOutputTransformation, lowOutputState]

def privateIdentity : Invariant BridgeCarrier where
  holds := fun _ => True

def privateBoundary : Boundary BridgeCarrier privateIdentity where
  constraints := []
  preserves := by
    intro _ _ _ _
    trivial

def privatePersistence : PersistenceWitness bridgeDirection where
  states := [lowOutputState, highOutputState]
  hasTransition := ⟨lowOutputState, highOutputState, [], rfl⟩
  invariant := privateIdentity
  invariantHolds := by
    intro _ _
    trivial
  ordered := by
    simp [OrderedBy, bridgeDirection, lowOutputState, highOutputState]

def privateParticipantAtLow : Entity BridgeCarrier where
  identity := privateIdentity
  boundary := privateBoundary
  persistenceDirection := bridgeDirection
  persistence := privatePersistence
  persistenceNamesIdentity := rfl
  current := lowOutputState
  currentInPersistence := by simp [privatePersistence]
  identityHolds := trivial

def privateParticipantAtHigh : Entity BridgeCarrier where
  identity := privateIdentity
  boundary := privateBoundary
  persistenceDirection := bridgeDirection
  persistence := privatePersistence
  persistenceNamesIdentity := rfl
  current := highOutputState
  currentInPersistence := by simp [privatePersistence]
  identityHolds := trivial

def ritualTargetDirection : Direction (Option Bool) where
  before := fun earlier later =>
    earlier.value = some false ∧ later.value = some true
  asymmetric := by
    intro earlier later forward reverse
    simp_all

def ritualTargetInvariant : Invariant (Option Bool) where
  holds := fun state => state.value ≠ none

def ritualTargetPersistence : PersistenceWitness ritualTargetDirection where
  states := [⟨some false⟩, ⟨some true⟩]
  hasTransition := ⟨⟨some false⟩, ⟨some true⟩, [], rfl⟩
  invariant := ritualTargetInvariant
  invariantHolds := by
    intro state member
    simp only [List.mem_cons, List.not_mem_nil, or_false] at member
    rcases member with rfl | rfl <;> simp [ritualTargetInvariant]
  ordered := by
    simp [OrderedBy, ritualTargetDirection]

def driftingRitualTarget : TargetContinuity (Option Bool) where
  direction := ritualTargetDirection
  persistence := ritualTargetPersistence
  current := ⟨some true⟩
  currentInPersistence := by simp [ritualTargetPersistence]

def memoryConditionedRitualInterpretation
    (perception memory : State BridgeCarrier) : State BridgeCarrier :=
  if perception.value.1 = memory.value.1 then
    lowOutputState
  else
    highOutputState

def privateRitualUptakeAtHigh :
    RitualUptake bridgeFeed repeatedBridgeFlow ritualFlowClassification
      privateParticipantAtHigh where
  priorIndex := 0
  currentIndex := 1
  priorBeforeCurrent := by decide
  priorOccurrence := lowTransformation
  currentOccurrence := highTransformation
  priorOccursInFlow := by simp [repeatedBridgeFlow]
  currentOccursInFlow := by simp [repeatedBridgeFlow]
  priorAtIndex := rfl
  currentAtIndex := rfl
  recurrenceHolds := by
    simp [repeatedBridgeFlow, lowTransformation, highTransformation,
      lowOutputState, highOutputState]
  priorClassified := rfl
  currentClassified := rfl
  contribution := bridgeContribution
  contributionBeginsWithPrior := rfl
  contributionBeginsWithCurrent := rfl
  memory := lowOutputState
  memoryIsPriorEffect := rfl
  memoryInParticipantHistory := by simp [privateParticipantAtHigh,
    privatePersistence]
  currentPerception := highInputState
  perceptionBeginsInterpretation := rfl
  interpretation := highTransformation
  interpretationIsCurrentOccurrence := rfl
  interpretationOccursInContribution := by
    simp [bridgeContribution, highPath]
  interpretationRule := memoryConditionedRitualInterpretation
  interpretedState := highOutputState
  interpretationHolds := by
    simp [memoryConditionedRitualInterpretation, highInputState,
      lowOutputState]
  interpretationProducesState := rfl
  contributionEndsAtInterpretation := rfl
  interpretedStateInParticipantHistory := by
    simp [privateParticipantAtHigh, privatePersistence]
  contrastiveMemory := highOutputState
  contrastiveMemoryDiffers := by
    intro equal
    have values := congrArg (fun state => state.value.1) equal
    simp [highOutputState, lowOutputState] at values
  contrastiveMemoryInParticipantHistory := by
    simp [privateParticipantAtHigh, privatePersistence]
  memoryChangesInterpretation := by
    simp [memoryConditionedRitualInterpretation, highOutputState,
      lowOutputState, highInputState]
  contrastivePerception := lowInputState
  contrastivePerceptionDiffers := by
    intro equal
    have values := congrArg (fun state => state.value.1) equal
    simp [lowInputState, highInputState] at values
  perceptionChangesInterpretation := by
    simp [memoryConditionedRitualInterpretation, lowInputState,
      lowOutputState, highOutputState]

def lowRitualAccess :
    RitualAccess bridgeFeed repeatedBridgeFlow privateParticipantAtHigh where
  index := 0
  indexInBounds := by decide
  occurrence := lowTransformation
  occursInFlow := by simp [repeatedBridgeFlow]
  occurrenceAtIndex := rfl
  path := lowPath
  endpoints := lowEndpoints
  beginsWithOccurrence := rfl
  effectEntersParticipantHistory := by
    simp [lowEndpoints, lowPath, lowTransformation, privateParticipantAtHigh,
      privatePersistence]

def highRitualAccess :
    RitualAccess bridgeFeed repeatedBridgeFlow privateParticipantAtHigh where
  index := 1
  indexInBounds := by decide
  occurrence := highTransformation
  occursInFlow := by simp [repeatedBridgeFlow]
  occurrenceAtIndex := rfl
  path := highPath
  endpoints := highEndpoints
  beginsWithOccurrence := rfl
  effectEntersParticipantHistory := by
    simp [highEndpoints, highPath, highTransformation,
      privateParticipantAtHigh, privatePersistence]

def privateRitual :
    Ritual (Target := Option Bool) (ParticipantIdentity := Bool)
      bridgeDirection bridgeFeed where
  flow := repeatedBridgeFlow
  classification := ritualFlowClassification
  participantIdentity := true
  participant := privateParticipantAtHigh
  target := driftingRitualTarget
  targetProjection := fun state => ⟨some state.value.1⟩
  targetStatesOccurThroughoutFlow := by
    intro occurrence member
    simp [repeatedBridgeFlow] at member
    rcases member with rfl | rfl
    · simp [driftingRitualTarget, ritualTargetPersistence, lowTransformation,
        lowOutputState]
    · simp [driftingRitualTarget, ritualTargetPersistence, highTransformation,
        highOutputState]
  accesses := [lowRitualAccess, highRitualAccess]
  accessesNonempty := by simp
  everyOccurrenceAccessed := by
    intro index bound
    cases index with
    | zero => exact ⟨lowRitualAccess, by simp, rfl⟩
    | succ index =>
        cases index with
        | zero => exact ⟨highRitualAccess, by simp, rfl⟩
        | succ index =>
            change index + 1 + 1 < 2 at bound
            omega
  uptakes := [privateRitualUptakeAtHigh]
  uptakesNonempty := by simp
  everyLaterOccurrenceUptaken := by
    intro index positive bound
    cases index with
    | zero => simp at positive
    | succ index =>
        cases index with
        | zero => exact ⟨privateRitualUptakeAtHigh, by simp, rfl⟩
        | succ index =>
            change index + 1 + 1 < 2 at bound
            omega

def bridgeMeaningScope :
    Scope (Bool × State (Option Bool)) :=
  ⟨fun _ => True⟩

def privateMeaning :
    Meaning privateRitual where
  scope := bridgeMeaningScope
  inScope := trivial
  supportingUptake := privateRitualUptakeAtHigh
  supportingUptakeInRitual := by
    change privateRitualUptakeAtHigh ∈ [privateRitualUptakeAtHigh]
    simp
  sustainingContribution := bridgeContribution
  supportRoute := .direct
  supportJoined := rfl
  sustainingSide := .right
  contributionReachesParticipant := rfl

theorem privateRitualIsInhabited :
    Nonempty (Ritual (Target := Option Bool) (ParticipantIdentity := Bool)
      bridgeDirection bridgeFeed) :=
  ⟨privateRitual⟩

theorem privateMeaningIsInhabited :
    Nonempty
      (Meaning privateRitual) :=
  ⟨privateMeaning⟩

theorem privateMeaningUsesRitualTarget :
    (MeaningRelation privateMeaning).2 = privateRitual.target.current := by
  rfl

theorem privateRitualTargetDriftsWithinIdentity :
    privateRitual.targetProjection lowTransformation.output ≠
        privateRitual.targetProjection highTransformation.output ∧
      privateRitual.target.persistence.invariant.holds
        (privateRitual.targetProjection lowTransformation.output) ∧
      privateRitual.target.persistence.invariant.holds
        (privateRitual.targetProjection highTransformation.output) := by
  constructor
  · intro equal
    have values := congrArg State.value equal
    simp [privateRitual, lowTransformation, highTransformation, lowOutputState,
      highOutputState] at values
  · constructor <;>
      simp [privateRitual, driftingRitualTarget, ritualTargetPersistence,
        ritualTargetInvariant, lowTransformation, highTransformation,
        lowOutputState, highOutputState]

theorem targetSubstitutionBreaksInvariant :
    ¬ driftingRitualTarget.persistence.invariant.holds ⟨none⟩ := by
  simp [driftingRitualTarget, ritualTargetPersistence, ritualTargetInvariant]

structure BareRepeatedFlow where
  flow : Flow bridgeDirection

def recurrenceWithoutParticipant : BareRepeatedFlow :=
  ⟨repeatedBridgeFlow⟩

theorem flowObtainsWithoutConstitutiveClassifier :
    Nonempty (Flow bridgeDirection) :=
  ⟨repeatedBridgeFlow⟩

theorem ritualFlowClassifierIsNonUniversal :
    ¬ ritualFlowClassification.rule.specification.conforms
      bridgeOutputTransformation := by
  simp [ritualFlowClassification, ritualFlowRule, bridgeOutputTransformation,
    lowOutputState]

theorem bareFlowCarriesNoParticipantAccess :
    Nonempty BareRepeatedFlow ∧
      (recurrenceWithoutParticipant.flow.occurrences.length = 2) := by
  exact ⟨⟨recurrenceWithoutParticipant⟩, by decide⟩

structure SinglePerception where
  path : CausalPath bridgeDirection bridgeFeed

def onePerception : SinglePerception := ⟨highPath⟩

theorem onePerceptionDoesNotSupplyFlow :
    onePerception.path.steps.length = 1 := by decide

def lowRitualAccessAtLow :
    RitualAccess bridgeFeed repeatedBridgeFlow privateParticipantAtLow where
  index := 0
  indexInBounds := by decide
  occurrence := lowTransformation
  occursInFlow := by simp [repeatedBridgeFlow]
  occurrenceAtIndex := rfl
  path := lowPath
  endpoints := lowEndpoints
  beginsWithOccurrence := rfl
  effectEntersParticipantHistory := by
    simp [lowEndpoints, lowPath, lowTransformation, privateParticipantAtLow,
      privatePersistence]

def highRitualAccessAtLow :
    RitualAccess bridgeFeed repeatedBridgeFlow privateParticipantAtLow where
  index := 1
  indexInBounds := by decide
  occurrence := highTransformation
  occursInFlow := by simp [repeatedBridgeFlow]
  occurrenceAtIndex := rfl
  path := highPath
  endpoints := highEndpoints
  beginsWithOccurrence := rfl
  effectEntersParticipantHistory := by
    simp [highEndpoints, highPath, highTransformation, privateParticipantAtLow,
      privatePersistence]

def privateRitualUptakeAtLow :
    RitualUptake bridgeFeed repeatedBridgeFlow ritualFlowClassification
      privateParticipantAtLow where
  priorIndex := 0
  currentIndex := 1
  priorBeforeCurrent := by decide
  priorOccurrence := lowTransformation
  currentOccurrence := highTransformation
  priorOccursInFlow := by simp [repeatedBridgeFlow]
  currentOccursInFlow := by simp [repeatedBridgeFlow]
  priorAtIndex := rfl
  currentAtIndex := rfl
  recurrenceHolds := privateRitualUptakeAtHigh.recurrenceHolds
  priorClassified := rfl
  currentClassified := rfl
  contribution := bridgeContribution
  contributionBeginsWithPrior := rfl
  contributionBeginsWithCurrent := rfl
  memory := lowOutputState
  memoryIsPriorEffect := rfl
  memoryInParticipantHistory := by simp [privateParticipantAtLow,
    privatePersistence]
  currentPerception := highInputState
  perceptionBeginsInterpretation := rfl
  interpretation := highTransformation
  interpretationIsCurrentOccurrence := rfl
  interpretationOccursInContribution := by
    simp [bridgeContribution, highPath]
  interpretationRule := memoryConditionedRitualInterpretation
  interpretedState := highOutputState
  interpretationHolds := by
    simp [memoryConditionedRitualInterpretation, highInputState,
      lowOutputState]
  interpretationProducesState := rfl
  contributionEndsAtInterpretation := rfl
  interpretedStateInParticipantHistory := by
    simp [privateParticipantAtLow, privatePersistence]
  contrastiveMemory := highOutputState
  contrastiveMemoryDiffers := by
    intro equal
    have values := congrArg (fun state => state.value.1) equal
    simp [highOutputState, lowOutputState] at values
  contrastiveMemoryInParticipantHistory := by
    simp [privateParticipantAtLow, privatePersistence]
  memoryChangesInterpretation := by
    simp [memoryConditionedRitualInterpretation, highOutputState,
      lowOutputState, highInputState]
  contrastivePerception := lowInputState
  contrastivePerceptionDiffers := by
    intro equal
    have values := congrArg (fun state => state.value.1) equal
    simp [lowInputState, highInputState] at values
  perceptionChangesInterpretation := by
    simp [memoryConditionedRitualInterpretation, lowInputState,
      lowOutputState, highOutputState]

def privateRitualAtLow :
    Ritual (Target := Option Bool) (ParticipantIdentity := Bool)
      bridgeDirection bridgeFeed where
  flow := repeatedBridgeFlow
  classification := ritualFlowClassification
  participantIdentity := false
  participant := privateParticipantAtLow
  target := driftingRitualTarget
  targetProjection := fun state => ⟨some state.value.1⟩
  targetStatesOccurThroughoutFlow := by
    intro occurrence member
    simp [repeatedBridgeFlow] at member
    rcases member with rfl | rfl
    · simp [driftingRitualTarget, ritualTargetPersistence, lowTransformation,
        lowOutputState]
    · simp [driftingRitualTarget, ritualTargetPersistence, highTransformation,
        highOutputState]
  accesses := [lowRitualAccessAtLow, highRitualAccessAtLow]
  accessesNonempty := by simp
  everyOccurrenceAccessed := by
    intro index bound
    cases index with
    | zero => exact ⟨lowRitualAccessAtLow, by simp, rfl⟩
    | succ index =>
        cases index with
        | zero => exact ⟨highRitualAccessAtLow, by simp, rfl⟩
        | succ index =>
            change index + 1 + 1 < 2 at bound
            omega
  uptakes := [privateRitualUptakeAtLow]
  uptakesNonempty := by simp
  everyLaterOccurrenceUptaken := by
    intro index positive bound
    cases index with
    | zero => simp at positive
    | succ index =>
        cases index with
        | zero => exact ⟨privateRitualUptakeAtLow, by simp, rfl⟩
        | succ index =>
            change index + 1 + 1 < 2 at bound
            omega

def privateMeaningAtLow :
    Meaning privateRitualAtLow where
  scope := bridgeMeaningScope
  inScope := trivial
  supportingUptake := privateRitualUptakeAtLow
  supportingUptakeInRitual := by
    change privateRitualUptakeAtLow ∈ [privateRitualUptakeAtLow]
    simp
  sustainingContribution := bridgeContribution
  supportRoute := .direct
  supportJoined := rfl
  sustainingSide := .left
  contributionReachesParticipant := rfl

structure DerivedMeaning
    (source :
      Meaning privateRitualAtLow)
    (recipient :
      Meaning privateRitual) where
  contribution : CausalContribution Bool BridgeStage bridgeDirection bridgeFeed
  participantIdentitiesDiffer :
    privateRitualAtLow.participantIdentity ≠
      privateRitual.participantIdentity
  sourceReached :
    contribution.leftEndpoints.last.output =
      privateRitualAtLow.participant.current
  recipientReached :
    contribution.rightEndpoints.last.output =
      privateRitual.participant.current

def transmittedMeaning : DerivedMeaning privateMeaningAtLow privateMeaning where
  contribution := bridgeContribution
  participantIdentitiesDiffer := by decide
  sourceReached := rfl
  recipientReached := rfl

theorem transmittedMeaningIsNotIdentical :
    MeaningRelation privateMeaningAtLow ≠ MeaningRelation privateMeaning := by
  intro equal
  exact transmittedMeaning.participantIdentitiesDiffer (congrArg Prod.fst equal)

def privateRitualSameStateOtherIdentity :
    Ritual (Target := Option Bool) (ParticipantIdentity := Bool)
      bridgeDirection bridgeFeed :=
  { privateRitual with participantIdentity := false }

def privateMeaningSameStateOtherIdentity :
    Meaning privateRitualSameStateOtherIdentity where
  scope := bridgeMeaningScope
  inScope := trivial
  supportingUptake := privateRitualUptakeAtHigh
  supportingUptakeInRitual := by
    change privateRitualUptakeAtHigh ∈ [privateRitualUptakeAtHigh]
    simp
  sustainingContribution := bridgeContribution
  supportRoute := .direct
  supportJoined := rfl
  sustainingSide := .right
  contributionReachesParticipant := rfl

theorem equalCurrentStateDoesNotEraseParticipantIndex :
    privateRitualSameStateOtherIdentity.participant.current =
        privateRitual.participant.current ∧
      MeaningRelation privateMeaningSameStateOtherIdentity ≠
        MeaningRelation privateMeaning := by
  constructor
  · rfl
  · simp [MeaningRelation, privateRitualSameStateOtherIdentity, privateRitual]

end DanielOntology
