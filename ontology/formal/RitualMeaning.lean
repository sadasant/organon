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

/-!
The Rule owns the exact constructive Specification used to classify Flow
occurrences. The two cannot drift as parallel fields.
-/
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
  rule : FlowRule direction
  occurrencesConform :
    ∀ occurrence, occurrence ∈ occurrences →
      rule.specification.conforms occurrence
  persistence : PersistenceWitness direction
  occurrenceOutputsArePersistence :
    occurrences.map (·.output) = persistence.states

structure RitualAccess
    {Carrier : Type u}
    {direction : Direction Carrier}
    (feeding : FeedRelation Carrier)
    (flow : Flow direction)
    (participant : Entity Carrier) where
  occurrence : Transformation direction
  occursInFlow : occurrence ∈ flow.occurrences
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
    (participant : Entity (Feature × Context)) where
  priorOccurrence : Transformation direction
  currentOccurrence : Transformation direction
  priorOccursInFlow : priorOccurrence ∈ flow.occurrences
  currentOccursInFlow : currentOccurrence ∈ flow.occurrences
  occurrencesDistinct : priorOccurrence ≠ currentOccurrence
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
    (direction : Direction (Feature × Context))
    (feeding : FeedRelation (Feature × Context)) where
  flow : Flow direction
  participant : Entity (Feature × Context)
  target : TargetContinuity Feature
  targetStatesOccurThroughoutFlow :
    ∀ occurrence, occurrence ∈ flow.occurrences →
      (⟨occurrence.output.value.1⟩ : State Feature) ∈
        target.persistence.states
  accesses : List (RitualAccess feeding flow participant)
  accessesNonempty : accesses ≠ []
  everyOccurrenceAccessed :
    ∀ occurrence, occurrence ∈ flow.occurrences →
      ∃ access : RitualAccess feeding flow participant,
        access ∈ accesses ∧ access.occurrence = occurrence
  uptakes : List (RitualUptake feeding flow participant)
  uptakesNonempty : uptakes ≠ []
  everyLaterOccurrenceUptaken :
    ∀ occurrence, occurrence ∈ flow.occurrences.tail →
      ∃ uptake : RitualUptake feeding flow participant,
        uptake ∈ uptakes ∧ uptake.currentOccurrence = occurrence

inductive SustainingSide where
  | left
  | right
deriving DecidableEq, Repr

/-!
`Meaning` is itself the participant-indexed Relation. The sustaining
contribution must terminate in the participant State at which the relation is
currently carried; it is not a decorative causal witness beside the Ritual.
-/
structure Meaning
    {Feature : Type v}
    {Context : Type u}
    {direction : Direction (Feature × Context)}
    {feeding : FeedRelation (Feature × Context)}
    (ritual : Ritual direction feeding)
    where
  scope : Scope (State (Feature × Context) × State Feature)
  inScope :
    scope.includes (ritual.participant.current, ritual.target.current)
  sustainingContribution :
    CausalContribution Feature Context direction feeding
  leftOriginatesInFlow :
    sustainingContribution.leftEndpoints.first ∈ ritual.flow.occurrences
  rightOriginatesInFlow :
    sustainingContribution.rightEndpoints.first ∈ ritual.flow.occurrences
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
    {direction : Direction (Feature × Context)}
    {feeding : FeedRelation (Feature × Context)}
    {ritual : Ritual direction feeding}
    (_meaning : Meaning ritual) :
    State (Feature × Context) × State Feature :=
  (ritual.participant.current, ritual.target.current)

theorem meaningContributionCarriesRitualTarget
    {Feature : Type v}
    {Context : Type u}
    {direction : Direction (Feature × Context)}
    {feeding : FeedRelation (Feature × Context)}
    {ritual : Ritual direction feeding}
    (meaning : Meaning ritual) :
    (⟨meaning.sustainingContribution.leftEndpoints.first.output.value.1⟩ :
        State Feature) ∈ ritual.target.persistence.states ∧
      (⟨meaning.sustainingContribution.rightEndpoints.first.output.value.1⟩ :
        State Feature) ∈ ritual.target.persistence.states := by
  constructor
  · exact ritual.targetStatesOccurThroughoutFlow _ meaning.leftOriginatesInFlow
  · exact ritual.targetStatesOccurThroughoutFlow _ meaning.rightOriginatesInFlow

theorem meaningContributionPreservesTargetIdentity
    {Feature : Type v}
    {Context : Type u}
    {direction : Direction (Feature × Context)}
    {feeding : FeedRelation (Feature × Context)}
    {ritual : Ritual direction feeding}
    (meaning : Meaning ritual) :
    ritual.target.persistence.invariant.holds
        ⟨meaning.sustainingContribution.leftEndpoints.first.output.value.1⟩ ∧
      ritual.target.persistence.invariant.holds
        ⟨meaning.sustainingContribution.rightEndpoints.first.output.value.1⟩ := by
  have targetStates := meaningContributionCarriesRitualTarget meaning
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
    conforms := fun occurrence => occurrence.output.value.2 = .output
    decideConformity := fun occurrence =>
      occurrence.output.value.2 == .output
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
  rule := ritualFlowRule
  occurrencesConform := by
    intro occurrence member
    simp only [List.mem_cons, List.not_mem_nil, or_false] at member
    rcases member with rfl | rfl
    · rfl
    · rfl
  persistence := bridgeFlowPersistence
  occurrenceOutputsArePersistence := by
    simp [bridgeFlowPersistence, lowTransformation, highTransformation]

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

def ritualTargetDirection : Direction Bool where
  before := fun earlier later => earlier.value = false ∧ later.value = true
  asymmetric := by
    intro earlier later forward reverse
    simp_all

def ritualTargetInvariant : Invariant Bool where
  holds := fun _ => True

def ritualTargetPersistence : PersistenceWitness ritualTargetDirection where
  states := [⟨false⟩, ⟨true⟩]
  hasTransition := ⟨⟨false⟩, ⟨true⟩, [], rfl⟩
  invariant := ritualTargetInvariant
  invariantHolds := by
    intro _ _
    trivial
  ordered := by
    simp [OrderedBy, ritualTargetDirection]

def driftingRitualTarget : TargetContinuity Bool where
  direction := ritualTargetDirection
  persistence := ritualTargetPersistence
  current := ⟨true⟩
  currentInPersistence := by simp [ritualTargetPersistence]

def memoryConditionedRitualInterpretation
    (perception memory : State BridgeCarrier) : State BridgeCarrier :=
  if perception.value.1 = memory.value.1 then
    lowOutputState
  else
    highOutputState

def privateRitualUptakeAtHigh :
    RitualUptake bridgeFeed repeatedBridgeFlow privateParticipantAtHigh where
  priorOccurrence := lowTransformation
  currentOccurrence := highTransformation
  priorOccursInFlow := by simp [repeatedBridgeFlow]
  currentOccursInFlow := by simp [repeatedBridgeFlow]
  occurrencesDistinct := by
    intro equal
    have values := congrArg (fun occurrence => occurrence.input.value.1) equal
    simp [lowTransformation, highTransformation, lowInputState,
      highInputState] at values
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
  occurrence := lowTransformation
  occursInFlow := by simp [repeatedBridgeFlow]
  path := lowPath
  endpoints := lowEndpoints
  beginsWithOccurrence := rfl
  effectEntersParticipantHistory := by
    simp [lowEndpoints, lowPath, lowTransformation, privateParticipantAtHigh,
      privatePersistence]

def highRitualAccess :
    RitualAccess bridgeFeed repeatedBridgeFlow privateParticipantAtHigh where
  occurrence := highTransformation
  occursInFlow := by simp [repeatedBridgeFlow]
  path := highPath
  endpoints := highEndpoints
  beginsWithOccurrence := rfl
  effectEntersParticipantHistory := by
    simp [highEndpoints, highPath, highTransformation,
      privateParticipantAtHigh, privatePersistence]

def privateRitual : Ritual bridgeDirection bridgeFeed where
  flow := repeatedBridgeFlow
  participant := privateParticipantAtHigh
  target := driftingRitualTarget
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
    intro occurrence member
    simp [repeatedBridgeFlow] at member
    rcases member with rfl | rfl
    · exact ⟨lowRitualAccess, by simp, rfl⟩
    · exact ⟨highRitualAccess, by simp, rfl⟩
  uptakes := [privateRitualUptakeAtHigh]
  uptakesNonempty := by simp
  everyLaterOccurrenceUptaken := by
    intro occurrence member
    simp [repeatedBridgeFlow] at member
    rcases member with rfl
    exact ⟨privateRitualUptakeAtHigh, by simp, rfl⟩

def bridgeMeaningScope : Scope (State BridgeCarrier × State Bool) :=
  ⟨fun _ => True⟩

def privateMeaning :
    Meaning privateRitual where
  scope := bridgeMeaningScope
  inScope := trivial
  sustainingContribution := bridgeContribution
  leftOriginatesInFlow := by simp [repeatedBridgeFlow, privateRitual,
    bridgeContribution, lowEndpoints]
  rightOriginatesInFlow := by simp [repeatedBridgeFlow, privateRitual,
    bridgeContribution, highEndpoints]
  sustainingSide := .right
  contributionReachesParticipant := rfl

theorem privateRitualIsInhabited :
    Nonempty (Ritual bridgeDirection bridgeFeed) :=
  ⟨privateRitual⟩

theorem privateMeaningIsInhabited :
    Nonempty
      (Meaning privateRitual) :=
  ⟨privateMeaning⟩

theorem privateMeaningUsesRitualTarget :
    (MeaningRelation privateMeaning).2 = privateRitual.target.current := by
  rfl

theorem privateRitualTargetDriftsWithinIdentity :
    (⟨lowTransformation.output.value.1⟩ : State Bool) ≠
        ⟨highTransformation.output.value.1⟩ ∧
      privateRitual.target.persistence.invariant.holds
        ⟨lowTransformation.output.value.1⟩ ∧
      privateRitual.target.persistence.invariant.holds
        ⟨highTransformation.output.value.1⟩ := by
  constructor
  · intro equal
    have values := congrArg State.value equal
    simp [lowTransformation, highTransformation, lowOutputState,
      highOutputState] at values
  · exact ⟨trivial, trivial⟩

structure BareRepeatedFlow where
  flow : Flow bridgeDirection

def recurrenceWithoutParticipant : BareRepeatedFlow :=
  ⟨repeatedBridgeFlow⟩

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
  occurrence := lowTransformation
  occursInFlow := by simp [repeatedBridgeFlow]
  path := lowPath
  endpoints := lowEndpoints
  beginsWithOccurrence := rfl
  effectEntersParticipantHistory := by
    simp [lowEndpoints, lowPath, lowTransformation, privateParticipantAtLow,
      privatePersistence]

def highRitualAccessAtLow :
    RitualAccess bridgeFeed repeatedBridgeFlow privateParticipantAtLow where
  occurrence := highTransformation
  occursInFlow := by simp [repeatedBridgeFlow]
  path := highPath
  endpoints := highEndpoints
  beginsWithOccurrence := rfl
  effectEntersParticipantHistory := by
    simp [highEndpoints, highPath, highTransformation, privateParticipantAtLow,
      privatePersistence]

def privateRitualUptakeAtLow :
    RitualUptake bridgeFeed repeatedBridgeFlow privateParticipantAtLow where
  priorOccurrence := lowTransformation
  currentOccurrence := highTransformation
  priorOccursInFlow := by simp [repeatedBridgeFlow]
  currentOccursInFlow := by simp [repeatedBridgeFlow]
  occurrencesDistinct := privateRitualUptakeAtHigh.occurrencesDistinct
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

def privateRitualAtLow : Ritual bridgeDirection bridgeFeed where
  flow := repeatedBridgeFlow
  participant := privateParticipantAtLow
  target := driftingRitualTarget
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
    intro occurrence member
    simp [repeatedBridgeFlow] at member
    rcases member with rfl | rfl
    · exact ⟨lowRitualAccessAtLow, by simp, rfl⟩
    · exact ⟨highRitualAccessAtLow, by simp, rfl⟩
  uptakes := [privateRitualUptakeAtLow]
  uptakesNonempty := by simp
  everyLaterOccurrenceUptaken := by
    intro occurrence member
    simp [repeatedBridgeFlow] at member
    rcases member with rfl
    exact ⟨privateRitualUptakeAtLow, by simp, rfl⟩

def privateMeaningAtLow :
    Meaning privateRitualAtLow where
  scope := bridgeMeaningScope
  inScope := trivial
  sustainingContribution := bridgeContribution
  leftOriginatesInFlow := by simp [repeatedBridgeFlow, privateRitualAtLow,
    bridgeContribution, lowEndpoints]
  rightOriginatesInFlow := by simp [repeatedBridgeFlow, privateRitualAtLow,
    bridgeContribution, highEndpoints]
  sustainingSide := .left
  contributionReachesParticipant := rfl

structure DerivedMeaning
    (source :
      Meaning privateRitualAtLow)
    (recipient :
      Meaning privateRitual) where
  contribution : CausalContribution Bool BridgeStage bridgeDirection bridgeFeed
  sourceReached :
    contribution.leftEndpoints.last.output =
      privateRitualAtLow.participant.current
  recipientReached :
    contribution.rightEndpoints.last.output =
      privateRitual.participant.current

def transmittedMeaning : DerivedMeaning privateMeaningAtLow privateMeaning where
  contribution := bridgeContribution
  sourceReached := rfl
  recipientReached := rfl

theorem transmittedMeaningIsNotIdentical :
    MeaningRelation privateMeaningAtLow ≠ MeaningRelation privateMeaning := by
  intro equal
  have participants := congrArg Prod.fst equal
  have values := congrArg (fun state => state.value.1) participants
  simp [MeaningRelation, privateRitualAtLow, privateRitual, privateParticipantAtLow,
    privateParticipantAtHigh, lowOutputState, highOutputState] at values

end DanielOntology
