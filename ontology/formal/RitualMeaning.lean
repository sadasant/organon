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

structure Flow
    {Carrier : Type u}
    (direction : Direction Carrier) where
  occurrences : List (Transformation direction)
  hasRepeatedOccurrences :
    ∃ first second rest,
      occurrences = first :: second :: rest ∧
      (first.input ≠ second.input ∨ first.output ≠ second.output)
  occurrencesOrdered : OrderedBy direction.before (occurrences.map (·.output))
  specification : Specification (Transformation direction)
  occurrencesConform :
    ∀ occurrence, occurrence ∈ occurrences →
      specification.conforms occurrence
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

structure Ritual
    {Carrier : Type u}
    (direction : Direction Carrier)
    (feeding : FeedRelation Carrier) where
  flow : Flow direction
  participant : Entity Carrier
  target : State Carrier
  accesses : List (RitualAccess feeding flow participant)
  accessesNonempty : accesses ≠ []
  everyOccurrenceAccessed :
    ∀ occurrence, occurrence ∈ flow.occurrences →
      ∃ access : RitualAccess feeding flow participant,
        access ∈ accesses ∧ access.occurrence = occurrence

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
  scope : Scope (State (Feature × Context) × State (Feature × Context))
  inScope : scope.includes (ritual.participant.current, ritual.target)
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
    State (Feature × Context) × State (Feature × Context) :=
  (ritual.participant.current, ritual.target)

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

def ritualFlowSpecification :
    Specification (Transformation bridgeDirection) where
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
  specification := ritualFlowSpecification
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
  target := highInputState
  accesses := [lowRitualAccess, highRitualAccess]
  accessesNonempty := by simp
  everyOccurrenceAccessed := by
    intro occurrence member
    simp [repeatedBridgeFlow] at member
    rcases member with rfl | rfl
    · exact ⟨lowRitualAccess, by simp, rfl⟩
    · exact ⟨highRitualAccess, by simp, rfl⟩

def bridgeMeaningScope : Scope (State BridgeCarrier × State BridgeCarrier) :=
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

theorem meaningIsNotItsTarget :
    (MeaningRelation privateMeaning).1 ≠ (MeaningRelation privateMeaning).2 := by
  intro equal
  have values := congrArg (fun state => state.value.2) equal
  simp [MeaningRelation, privateRitual,
    privateParticipantAtHigh, highOutputState, highInputState] at values

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

def privateRitualAtLow : Ritual bridgeDirection bridgeFeed where
  flow := repeatedBridgeFlow
  participant := privateParticipantAtLow
  target := highInputState
  accesses := [lowRitualAccessAtLow, highRitualAccessAtLow]
  accessesNonempty := by simp
  everyOccurrenceAccessed := by
    intro occurrence member
    simp [repeatedBridgeFlow] at member
    rcases member with rfl | rfl
    · exact ⟨lowRitualAccessAtLow, by simp, rfl⟩
    · exact ⟨highRitualAccessAtLow, by simp, rfl⟩

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
