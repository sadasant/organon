import DanielOntology

/-!
# Consciousness proposal: formal shadow

This file formalizes the discourse and recognition machinery proposed for the
quarantined term `Consciousness`. It deliberately does not define a universal
Consciousness predicate or prove which entities instantiate one.

The formal result is a separation: a candidate condition, an attribution of
that condition, and an Order's recognition of the attribution can vary
independently. Recognition is institutionally real without becoming proof of
the candidate condition.
-/

universe u v w x y z

namespace DanielOntology.ConsciousnessProposal

structure CandidateCondition (Entity : Type u) (State : Type v) where
  specification : Specification (Entity × State)

def CandidateCondition.holds
    {Entity : Type u}
    {State : Type v}
    (candidate : CandidateCondition Entity State)
    (entity : Entity)
    (state : State) : Prop :=
  candidate.specification.conforms (entity, state)

structure ConsciousnessAttribution
    (Agent : Type u)
    (Entity : Type v)
    (State : Type w)
    (Language : Type x)
    (Rule : Type y) where
  claimId : Nat
  claimant : Agent
  target : Entity
  state : State
  candidate : CandidateCondition Entity State
  language : Language
  meaningRule : Rule
  inScope : candidate.specification.scope.includes (target, state)

structure RecognitionOrder
    (Attribution : Type u)
    (Entity : Type v)
    (State : Type w)
    (Rule : Type x) where
  admits : Rule → Attribution → Prop
  countsAsConscious : Entity → State → Prop

structure RecognizedConsciousness
    {Agent : Type u}
    {Entity : Type v}
    {State : Type w}
    {Language : Type x}
    {Rule : Type y}
    (order : RecognitionOrder
      (ConsciousnessAttribution Agent Entity State Language Rule)
      Entity State Rule) where
  attribution : ConsciousnessAttribution Agent Entity State Language Rule
  admissionRule : Rule
  admitted : order.admits admissionRule attribution
  counted : order.countsAsConscious attribution.target attribution.state

inductive EvidenceDisposition where
  | supported
  | defeated
  | underdetermined
deriving DecidableEq, Repr

structure EvidentiaryProfile
    {Agent : Type u}
    {Entity : Type v}
    {State : Type w}
    {Language : Type x}
    {Rule : Type y}
    (Observation : Type z)
    (Evidence : Type)
    (AdmissibilityRule : Type)
    (attribution : ConsciousnessAttribution Agent Entity State Language Rule) where
  observations : List Observation
  evidence : List Evidence
  admissibilityRule : AdmissibilityRule
  admittedFor : Evidence →
    ConsciousnessAttribution Agent Entity State Language Rule → Prop
  allEvidenceAdmitted : ∀ item, item ∈ evidence → admittedFor item attribution
  disposition : EvidenceDisposition

/-! ## Finite anti-collapse witness -/

inductive ToyEntity where
  | system
deriving DecidableEq, Repr

inductive ToyState where
  | running
deriving DecidableEq, Repr

inductive ToyLanguage where
  | ordinaryEnglish
deriving DecidableEq, Repr

inductive ToyRule where
  | selfReport
  | institutionalReview
deriving DecidableEq, Repr

def toyScope : Scope (ToyEntity × ToyState) where
  includes := fun pair => pair = (.system, .running)

def positiveCandidate : CandidateCondition ToyEntity ToyState where
  specification := {
    scope := toyScope
    conforms := fun pair => pair = (.system, .running)
    decideConformity := fun pair => decide (pair = (.system, .running))
    conformityCorrect := by intro pair; simp
    conformityWithinScope := by intro pair conforming; exact conforming
  }

def negativeCandidate : CandidateCondition ToyEntity ToyState where
  specification := {
    scope := toyScope
    conforms := fun _ => False
    decideConformity := fun _ => false
    conformityCorrect := by simp
    conformityWithinScope := by simp
  }

def selfAttribution :
    ConsciousnessAttribution ToyEntity ToyEntity ToyState ToyLanguage ToyRule where
  claimId := 1
  claimant := .system
  target := .system
  state := .running
  candidate := negativeCandidate
  language := .ordinaryEnglish
  meaningRule := .selfReport
  inScope := by simp [negativeCandidate, toyScope]

def recognizingOrder :
    RecognitionOrder
      (ConsciousnessAttribution ToyEntity ToyEntity ToyState ToyLanguage ToyRule)
      ToyEntity ToyState ToyRule where
  admits := fun rule attribution =>
    rule = .institutionalReview ∧ attribution.claimId = 1
  countsAsConscious := fun entity state =>
    entity = .system ∧ state = .running

def recognizedSelfAttribution : RecognizedConsciousness recognizingOrder where
  attribution := selfAttribution
  admissionRule := .institutionalReview
  admitted := by simp [recognizingOrder, selfAttribution]
  counted := by simp [recognizingOrder]

theorem recognitionDoesNotEntailCandidate :
    recognizingOrder.countsAsConscious .system .running ∧
    ¬ selfAttribution.candidate.holds .system .running := by
  constructor
  · simp [recognizingOrder]
  · simp [CandidateCondition.holds, selfAttribution, negativeCandidate]

theorem attributionDoesNotEntailCandidate :
    selfAttribution.claimant = selfAttribution.target ∧
    ¬ selfAttribution.candidate.holds selfAttribution.target selfAttribution.state := by
  constructor
  · rfl
  · simp [CandidateCondition.holds, selfAttribution, negativeCandidate]

def silentOrder :
    RecognitionOrder
      (ConsciousnessAttribution ToyEntity ToyEntity ToyState ToyLanguage ToyRule)
      ToyEntity ToyState ToyRule where
  admits := fun _ _ => False
  countsAsConscious := fun _ _ => False

theorem nonRecognitionDoesNotDecideCandidate :
    (¬ silentOrder.countsAsConscious .system .running) ∧
    positiveCandidate.holds .system .running ∧
    ¬ negativeCandidate.holds .system .running := by
  constructor
  · simp [silentOrder]
  · constructor
    · simp [CandidateCondition.holds, positiveCandidate]
    · simp [CandidateCondition.holds, negativeCandidate]

theorem formalWitnessIsInhabited :
    Nonempty (RecognizedConsciousness recognizingOrder) :=
  ⟨recognizedSelfAttribution⟩

end DanielOntology.ConsciousnessProposal
