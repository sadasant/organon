import DanielOntology

/-!
# Consciousness proposal: formal shadow

This file formalizes the candidate-condition, Claim, and institutional
designation machinery proposed for the quarantined term `Consciousness`. It
deliberately does not define a universal Consciousness predicate.

The theorems below state only the anti-entailments exhibited by their finite
countermodels.
-/

universe u v w x y z q r

namespace DanielOntology.ConsciousnessProposal

structure CandidateCondition
    (Entity : Type u)
    (State : Type v)
    (Condition : Type w) where
  condition : Condition
  obtains : Condition → Entity → State → Prop
  specification : Specification (Entity × State)
  specificationCorrect :
    ∀ entity state,
      specification.conforms (entity, state) ↔
        obtains condition entity state

def CandidateCondition.holds
    {Entity : Type u}
    {State : Type v}
    {Condition : Type w}
    (candidate : CandidateCondition Entity State Condition)
    (entity : Entity)
    (state : State) : Prop :=
  candidate.obtains candidate.condition entity state

inductive AttributionPerspective where
  | firstPerson
  | thirdPerson
deriving DecidableEq, Repr

structure ReferenceMap (Agent : Type u) (Entity : Type v) where
  asEntity : Agent → Entity
  sameUnder : Entity → Entity → Prop

structure AttributionSemantics
    (Representation : Type u)
    (Language : Type v)
    (Rule : Type w)
    (Candidate : Type x) where
  meansCandidate :
    Rule → Language → Representation → Candidate → Prop

structure ConsciousnessAttribution
    (Agent : Type u)
    (Entity : Type v)
    (State : Type w)
    (Condition : Type x)
    (Representation : Type y)
    (Language : Type z)
    (Rule : Type q)
    (referenceMap : ReferenceMap Agent Entity)
    (semantics : AttributionSemantics
      Representation Language Rule (CandidateCondition Entity State Condition)) where
  claimId : Nat
  claimant : Agent
  target : Entity
  state : State
  candidate : CandidateCondition Entity State Condition
  representation : Representation
  claimScope : Scope (Entity × State)
  language : Language
  meaningRule : Rule
  meaningHolds :
    semantics.meansCandidate meaningRule language representation candidate
  inClaimScope :
    claimScope.includes (target, state)
  candidateInScope :
    candidate.specification.scope.includes (target, state)
  perspective : AttributionPerspective
  perspectiveCorrect :
    perspective = .firstPerson ↔
      referenceMap.sameUnder (referenceMap.asEntity claimant) target

structure DesignationOrder
    (Attribution : Type u)
    (Entity : Type v)
    (State : Type w)
    (Rule : Type x)
    (Purpose : Type y) where
  admits :
    Rule → Purpose → Attribution → Prop
  countsAsConscious :
    Rule → Purpose → Attribution → Scope (Entity × State) → Prop
  countingRequiresAdmission :
    ∀ rule purpose attribution scope,
      countsAsConscious rule purpose attribution scope →
        admits rule purpose attribution

structure ConsciousnessDesignation
    {Agent : Type u}
    {Entity : Type v}
    {State : Type w}
    {Condition : Type x}
    {Representation : Type y}
    {Language : Type z}
    {Rule : Type q}
    {Purpose : Type r}
    {referenceMap : ReferenceMap Agent Entity}
    {semantics : AttributionSemantics
      Representation Language Rule (CandidateCondition Entity State Condition)}
    (order : DesignationOrder
      (ConsciousnessAttribution
        Agent Entity State Condition Representation Language Rule referenceMap semantics)
      Entity State Rule Purpose) where
  attribution :
    ConsciousnessAttribution
      Agent Entity State Condition Representation Language Rule referenceMap semantics
  rule : Rule
  purpose : Purpose
  scope : Scope (Entity × State)
  targetInScope :
    scope.includes (attribution.target, attribution.state)
  counted :
    order.countsAsConscious rule purpose attribution scope

def ConsciousnessDesignation.admitted
    {Agent : Type u}
    {Entity : Type v}
    {State : Type w}
    {Condition : Type x}
    {Representation : Type y}
    {Language : Type z}
    {Rule : Type q}
    {Purpose : Type r}
    {referenceMap : ReferenceMap Agent Entity}
    {semantics : AttributionSemantics
      Representation Language Rule (CandidateCondition Entity State Condition)}
    {order : DesignationOrder
      (ConsciousnessAttribution
        Agent Entity State Condition Representation Language Rule referenceMap semantics)
      Entity State Rule Purpose}
    (designation : ConsciousnessDesignation order) :
    order.admits designation.rule designation.purpose designation.attribution :=
  order.countingRequiresAdmission
    designation.rule designation.purpose designation.attribution designation.scope
    designation.counted

/-! ## Finite anti-entailment witnesses -/

inductive ToyEntity where
  | system
deriving DecidableEq, Repr

inductive ToyState where
  | running
deriving DecidableEq, Repr

inductive ToyCondition where
  | positive
  | negative
deriving DecidableEq, Repr

inductive ToyRepresentation where
  | selfReport
deriving DecidableEq, Repr

inductive ToyLanguage where
  | ordinaryEnglish
deriving DecidableEq, Repr

inductive ToyRule where
  | interpretSelfReport
  | institutionalReview
deriving DecidableEq, Repr

inductive ToyPurpose where
  | classification
deriving DecidableEq, Repr

def toyScope : Scope (ToyEntity × ToyState) where
  includes := fun pair => pair = (.system, .running)

def toyObtains : ToyCondition → ToyEntity → ToyState → Prop
  | .positive, .system, .running => True
  | .negative, .system, .running => False

def positiveCandidate : CandidateCondition ToyEntity ToyState ToyCondition where
  condition := .positive
  obtains := toyObtains
  specification := {
    scope := toyScope
    conforms := fun pair => pair = (.system, .running)
    decideConformity := fun pair => decide (pair = (.system, .running))
    conformityCorrect := by intro pair; simp
    conformityWithinScope := by intro pair conforming; exact conforming
  }
  specificationCorrect := by intro entity state; cases entity <;> cases state <;> simp [toyObtains]

def negativeCandidate : CandidateCondition ToyEntity ToyState ToyCondition where
  condition := .negative
  obtains := toyObtains
  specification := {
    scope := toyScope
    conforms := fun _ => False
    decideConformity := fun _ => false
    conformityCorrect := by simp
    conformityWithinScope := by simp
  }
  specificationCorrect := by intro entity state; cases entity <;> cases state <;> simp [toyObtains]

def toyReferenceMap : ReferenceMap ToyEntity ToyEntity where
  asEntity := id
  sameUnder := Eq

def toyAttributionSemantics :
    AttributionSemantics
      ToyRepresentation ToyLanguage ToyRule
      (CandidateCondition ToyEntity ToyState ToyCondition) where
  meansCandidate := fun rule language representation _ =>
    rule = .interpretSelfReport ∧
    language = .ordinaryEnglish ∧
    representation = .selfReport

abbrev ToyAttribution :=
  ConsciousnessAttribution
    ToyEntity ToyEntity ToyState ToyCondition ToyRepresentation
    ToyLanguage ToyRule toyReferenceMap toyAttributionSemantics

def negativeAttribution : ToyAttribution where
  claimId := 1
  claimant := .system
  target := .system
  state := .running
  candidate := negativeCandidate
  representation := .selfReport
  claimScope := toyScope
  language := .ordinaryEnglish
  meaningRule := .interpretSelfReport
  meaningHolds := by simp [toyAttributionSemantics]
  inClaimScope := by simp [toyScope]
  candidateInScope := by simp [negativeCandidate, toyScope]
  perspective := .firstPerson
  perspectiveCorrect := by simp [toyReferenceMap]

def positiveAttribution : ToyAttribution where
  claimId := 2
  claimant := .system
  target := .system
  state := .running
  candidate := positiveCandidate
  representation := .selfReport
  claimScope := toyScope
  language := .ordinaryEnglish
  meaningRule := .interpretSelfReport
  meaningHolds := by simp [toyAttributionSemantics]
  inClaimScope := by simp [toyScope]
  candidateInScope := by simp [positiveCandidate, toyScope]
  perspective := .firstPerson
  perspectiveCorrect := by simp [toyReferenceMap]

def designatingOrder :
    DesignationOrder ToyAttribution ToyEntity ToyState ToyRule ToyPurpose where
  admits := fun rule purpose attribution =>
    rule = .institutionalReview ∧
    purpose = .classification ∧
    attribution.claimId = 1
  countsAsConscious := fun rule purpose attribution scope =>
    rule = .institutionalReview ∧
    purpose = .classification ∧
    attribution.claimId = 1 ∧
    scope.includes (attribution.target, attribution.state)
  countingRequiresAdmission := by
    intro rule purpose attribution scope counted
    exact ⟨counted.1, counted.2.1, counted.2.2.1⟩

def designatedAttribution : ConsciousnessDesignation designatingOrder where
  attribution := negativeAttribution
  rule := .institutionalReview
  purpose := .classification
  scope := toyScope
  targetInScope := by simp [negativeAttribution, toyScope]
  counted := by simp [designatingOrder, negativeAttribution, toyScope]

theorem attributionDoesNotEntailCandidate :
    ∃ attribution : ToyAttribution,
      attribution.perspective = .firstPerson ∧
      ¬ attribution.candidate.holds attribution.target attribution.state := by
  refine ⟨negativeAttribution, rfl, ?_⟩
  simp [CandidateCondition.holds, negativeAttribution, negativeCandidate, toyObtains]

theorem designationDoesNotEntailCandidate :
    ∃ designation : ConsciousnessDesignation designatingOrder,
      ¬ designation.attribution.candidate.holds
        designation.attribution.target designation.attribution.state := by
  refine ⟨designatedAttribution, ?_⟩
  simp [CandidateCondition.holds, designatedAttribution, negativeAttribution,
    negativeCandidate, toyObtains]

def silentOrder :
    DesignationOrder ToyAttribution ToyEntity ToyState ToyRule ToyPurpose where
  admits := fun _ _ _ => False
  countsAsConscious := fun _ _ _ _ => False
  countingRequiresAdmission := by simp

theorem nonDesignationDoesNotDecideCandidate :
    (¬ silentOrder.countsAsConscious
      .institutionalReview .classification positiveAttribution toyScope) ∧
    positiveAttribution.candidate.holds
      positiveAttribution.target positiveAttribution.state ∧
    (¬ silentOrder.countsAsConscious
      .institutionalReview .classification negativeAttribution toyScope) ∧
    ¬ negativeAttribution.candidate.holds
      negativeAttribution.target negativeAttribution.state := by
  constructor
  · simp [silentOrder]
  · constructor
    · simp [CandidateCondition.holds, positiveAttribution, positiveCandidate, toyObtains]
    · constructor
      · simp [silentOrder]
      · simp [CandidateCondition.holds, negativeAttribution, negativeCandidate, toyObtains]

theorem formalWitnessIsInhabited :
    Nonempty (ConsciousnessDesignation designatingOrder) :=
  ⟨designatedAttribution⟩

end DanielOntology.ConsciousnessProposal
