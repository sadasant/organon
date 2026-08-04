import OrganonCore

/-!
# Hidden bridge relations

This module prices the three object-language relations promoted by the v0.16
hidden-bridge audit. Identity criteria and relative possibility remain declared
metalanguage, while Entity and Capability must carry their object-level
witnesses. Institutional eligibility reduces to Standing rather than receiving
a second predicate.
-/

universe u v w x

namespace DanielOntology

inductive EvidentialDisposition where
  | supporting
  | defeating
  | underdetermining
deriving DecidableEq, Repr

structure EvidentialBearing
    (Evidence : Type u)
    (Claim : Type v)
    (Rule : Type w)
    (Order : Type x) where
  evidence : Evidence
  claim : Claim
  rule : Rule
  order : Order
  scope : Scope (Evidence × Claim)
  inScope : scope.includes (evidence, claim)
  evaluate : Rule → Evidence → Claim → EvidentialDisposition
  disposition : EvidentialDisposition
  evaluationHolds : evaluate rule evidence claim = disposition
  records :
    Order → Evidence → Claim → Rule → Scope (Evidence × Claim) →
      EvidentialDisposition → Prop
  recorded : records order evidence claim rule scope disposition

theorem capabilitySuppliesRealization
    {Agent : Type u}
    {Action : Agent → Type v}
    {Context : Type w}
    {agent : Agent}
    (capability : Capability Agent Action Context agent)
    (context : Context)
    (action : Action agent)
    (possible : capability.can context action) :
    Nonempty (capability.realization context action) :=
  possible

/-! ## Finite witnesses and anti-collapse cases -/

def unequalDenotation : Denotation Bool Bool where
  expression := false
  target := true

theorem denotationDoesNotEntailIdentity :
    unequalDenotation.expression ≠ unequalDenotation.target := by
  decide

inductive BridgeStage where
  | input
  | output
deriving DecidableEq, Repr

open BridgeStage

abbrev BridgeCarrier := Bool × BridgeStage

def lowInputState : State BridgeCarrier := ⟨(false, input)⟩
def highInputState : State BridgeCarrier := ⟨(true, input)⟩
def lowOutputState : State BridgeCarrier := ⟨(false, output)⟩
def highOutputState : State BridgeCarrier := ⟨(true, output)⟩

def bridgeDirection : Direction BridgeCarrier where
  before := fun input output =>
    (input = lowInputState ∧ output = lowOutputState) ∨
    (input = highInputState ∧ output = highOutputState) ∨
    (input = lowOutputState ∧ output = highOutputState)
  asymmetric := by
    intro input output forward reverse
    rcases forward with ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩ <;>
      simp [lowInputState, highInputState, lowOutputState,
        highOutputState] at reverse

def bridgeFeed : FeedRelation BridgeCarrier where
  feeds := fun _ _ => True

def lowTransformation : Transformation bridgeDirection where
  input := lowInputState
  output := lowOutputState
  advances := by left; exact ⟨rfl, rfl⟩

def highTransformation : Transformation bridgeDirection where
  input := highInputState
  output := highOutputState
  advances := by right; left; exact ⟨rfl, rfl⟩

def bridgeOutputTransformation : Transformation bridgeDirection where
  input := lowOutputState
  output := highOutputState
  advances := by right; right; exact ⟨rfl, rfl⟩

def bridgeOutputChange : Change bridgeDirection where
  transformation := bridgeOutputTransformation
  differs := by
    intro equal
    have values := congrArg State.value equal
    simp [bridgeOutputTransformation, lowOutputState, highOutputState] at values

def lowPath : CausalPath bridgeDirection bridgeFeed where
  steps := [lowTransformation]
  connected := trivial

def highPath : CausalPath bridgeDirection bridgeFeed where
  steps := [highTransformation]
  connected := trivial

def lowEndpoints : PathEndpoints lowPath where
  first := lowTransformation
  last := lowTransformation
  startsWith := ⟨[], rfl⟩
  endsWith := ⟨[], rfl⟩

def highEndpoints : PathEndpoints highPath where
  first := highTransformation
  last := highTransformation
  startsWith := ⟨[], rfl⟩
  endsWith := ⟨[], rfl⟩

def bridgeContribution :
    CausalContribution Bool BridgeStage bridgeDirection bridgeFeed where
  leftPath := lowPath
  rightPath := highPath
  leftEndpoints := lowEndpoints
  rightEndpoints := highEndpoints
  sameDeclaredContext := rfl
  inputDiffers := by decide
  downstreamChange := bridgeOutputChange
  changeStartsAt := rfl
  changeEndsAt := rfl

theorem contributionRequiresTwoNonemptyPaths
    (contribution :
      CausalContribution Bool BridgeStage bridgeDirection bridgeFeed) :
    contribution.leftPath.steps ≠ [] ∧
      contribution.rightPath.steps ≠ [] := by
  constructor
  · rintro empty
    obtain ⟨rest, starts⟩ := contribution.leftEndpoints.startsWith
    rw [empty] at starts
    cases starts
  · rintro empty
    obtain ⟨rest, starts⟩ := contribution.rightEndpoints.startsWith
    rw [empty] at starts
    cases starts

inductive ToyEvidence where
  | observation
deriving DecidableEq, Repr

inductive ToyBridgeClaim where
  | mistaken
deriving DecidableEq, Repr

inductive ToyEvaluationRule where
  | accepts
deriving DecidableEq, Repr

inductive ToyBearingOrder where
  | laboratory
deriving DecidableEq, Repr

def supportiveFalseBearing :
    EvidentialBearing ToyEvidence ToyBridgeClaim ToyEvaluationRule
      ToyBearingOrder where
  evidence := .observation
  claim := .mistaken
  rule := .accepts
  order := .laboratory
  scope := ⟨fun pair => pair = (.observation, .mistaken)⟩
  inScope := rfl
  evaluate := fun _ _ _ => .supporting
  disposition := .supporting
  evaluationHolds := rfl
  records := fun _ _ _ _ _ disposition => disposition = .supporting
  recorded := rfl

inductive ToyStandingEntity where
  | participant
deriving DecidableEq, Repr

inductive ToyStandingStatus where
  | mayReview
deriving DecidableEq, Repr

def toyStandingScope : Scope (ToyStandingEntity × ToyStandingStatus) :=
  ⟨fun pair => pair = (.participant, .mayReview)⟩

def toyStandingRecords :
    ToyBearingOrder → ToyEvaluationRule → ToyStandingEntity →
      ToyStandingStatus → Scope (ToyStandingEntity × ToyStandingStatus) → Prop :=
  fun order rule entity status scope =>
    order = .laboratory ∧ rule = .accepts ∧
      scope.includes (entity, status)

def finiteStandingWitness :
    StandingRelation toyStandingRecords .laboratory .accepts
      .participant .mayReview toyStandingScope where
  inScope := rfl
  recorded := by simp [toyStandingRecords, toyStandingScope]

def bridgeTruth : ToyBridgeClaim → Prop := fun _ => False

theorem supportiveBearingDoesNotEntailTruth :
    supportiveFalseBearing.disposition = .supporting ∧
      ¬ bridgeTruth supportiveFalseBearing.claim := by
  exact ⟨rfl, by simp [bridgeTruth]⟩

end DanielOntology
