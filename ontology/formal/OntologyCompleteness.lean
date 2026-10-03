import EmbodiedConsciousness

/-!
# Scoped ontology and completeness experiment

Noncanonical coverage projection of the proposed ontological-framework profile.
This does not define Reality, promote Ontology, or formalize Gödel's theorem.
`Target` is a declared carrier, not the totality of Presence. Category predicates
and active expressions are metalinguistic data, not new canonical classifiers.
An exact Organon Denotation joins each active expression to its predicate.

Three independent questions are tested: target coverage, predicate expressivity,
and determination of sentences across admitted interpretations of Body.
-/

universe u v w

namespace DanielOntology.OntologyCompletenessExperiment

/-! Semantic Interpretation is a scoped assignment, not a practical
Transformation. Context and meaning carriers are mathematical projections;
full canonical Rule and Representation realization remains gated. -/
structure Interpretation (Expression : Type u) (SemanticTarget : Type v) (Context : Type w) where
  context : Context
  scope : Scope Expression
  assignment : Expression → Denotation Expression SemanticTarget
  namesExpression : ∀ expression, scope.includes expression →
    (assignment expression).expression = expression

structure OntologyProjection (Expression : Type u) (Target : Type v) where
  scope : Scope Target
  expressions : List Expression
  expressionsNonempty : expressions ≠ []
  classifies : Expression → Target → Prop
  classificationWithinScope : ∀ expression target,
    expression ∈ expressions → classifies expression target → scope.includes target
  interpretation : Interpretation Expression (Target → Prop) Unit
  activeWithinInterpretation : ∀ expression, expression ∈ expressions →
    interpretation.scope.includes expression
  denotationExact : ∀ expression, expression ∈ expressions →
    (interpretation.assignment expression).target = classifies expression

def CoversScope {Expression : Type u} {Target : Type v}
    (ontology : OntologyProjection Expression Target) : Prop :=
  ∀ target, ontology.scope.includes target →
    ∃ expression, expression ∈ ontology.expressions ∧
      ontology.classifies expression target

def SeparatesScope {Expression : Type u} {Target : Type v}
    (ontology : OntologyProjection Expression Target) : Prop :=
  ∀ left right, ontology.scope.includes left → ontology.scope.includes right →
    left ≠ right → ∃ expression, expression ∈ ontology.expressions ∧
      ¬ (ontology.classifies expression left ↔ ontology.classifies expression right)

def Expresses {Expression : Type u} {Target : Type v}
    (ontology : OntologyProjection Expression Target) (predicate : Target → Prop) : Prop :=
  ∃ expression, expression ∈ ontology.expressions ∧
    ∀ target, ontology.scope.includes target →
      (ontology.classifies expression target ↔ predicate target)

def PredicateComplete {Expression : Type u} {Target : Type v}
    (ontology : OntologyProjection Expression Target) : Prop :=
  ∀ predicate, Expresses ontology predicate

/-! Coverage can collapse every distinction without missing a target. -/

def collapsed : OntologyProjection Unit Bool where
  scope := ⟨fun _ => True⟩
  expressions := [()]
  expressionsNonempty := by simp
  classifies := fun _ _ => True
  classificationWithinScope := by simp
  interpretation := ⟨(), ⟨fun _ => True⟩,
    fun expression => ⟨expression, fun _ => True⟩, by simp⟩
  activeWithinInterpretation := by simp
  denotationExact := by simp

theorem coverageDoesNotEntailSeparation :
    CoversScope collapsed ∧ ¬ SeparatesScope collapsed := by
  constructor
  · intro target _
    exact ⟨(), by simp [collapsed], trivial⟩
  · intro separates
    obtain ⟨expression, _, distinguishes⟩ :=
      separates false true trivial trivial (by decide)
    exact distinguishes (by simp [collapsed])

/-! A selective projection can instead leave a concrete in-scope omission. -/

def selective : OntologyProjection Unit Bool where
  scope := ⟨fun _ => True⟩
  expressions := [()]
  expressionsNonempty := by simp
  classifies := fun _ target => target = false
  classificationWithinScope := by simp
  interpretation := ⟨(), ⟨fun _ => True⟩,
    fun expression => ⟨expression, fun target => target = false⟩, by simp⟩
  activeWithinInterpretation := by simp
  denotationExact := by simp

theorem selectiveHasAnOmittedTarget :
    selective.scope.includes true ∧
    (∀ expression, expression ∈ selective.expressions →
      ¬ selective.classifies expression true) ∧ ¬ CoversScope selective := by
  refine ⟨trivial, ?_, ?_⟩
  · simp [selective]
  · intro coverage
    obtain ⟨expression, _, covered⟩ := coverage true trivial
    simp [selective] at covered

/-!
Four categories express all predicates on the two-element carrier. Classical
logic is needed to choose the truth bits of an arbitrary Prop-valued predicate.
This is not an executable decision procedure for arbitrary Lean propositions.
-/

def finiteComplete : OntologyProjection (Bool × Bool) Bool where
  scope := ⟨fun _ => True⟩
  expressions := [(false, false), (false, true), (true, false), (true, true)]
  expressionsNonempty := by simp
  classifies := fun expression target =>
    (if target then expression.2 else expression.1) = true
  classificationWithinScope := by simp
  interpretation := ⟨(), ⟨fun _ => True⟩, fun expression =>
    ⟨expression, fun target => (if target then expression.2 else expression.1) = true⟩, by simp⟩
  activeWithinInterpretation := by simp
  denotationExact := by simp

theorem finiteOntologyCanBePredicateComplete : PredicateComplete finiteComplete := by
  classical
  intro predicate
  refine ⟨(decide (predicate false), decide (predicate true)), ?_, ?_⟩
  · cases decide (predicate false) <;>
      cases decide (predicate true) <;> simp [finiteComplete]
  · intro target _
    cases target <;> simp [finiteComplete]

theorem finiteCompleteCoversScope : CoversScope finiteComplete := by
  intro target _
  refine ⟨(true, true), by simp [finiteComplete], ?_⟩
  cases target <;> simp [finiteComplete]

/-!
Cantor-style diagonal obstruction, not Gödelian incompleteness. Even allowing
every Nat-indexed expression, no semantics expresses all predicates on Nat.
The proof is constructive; it assumes neither physical continuity nor arithmetic
proof rules. The phrase "all predicates" is a substantial expressivity demand.
-/

def AllPredicatesExpressible (classifies : Nat → Nat → Prop) : Prop :=
  ∀ predicate : Nat → Prop, ∃ expression,
    ∀ target, classifies expression target ↔ predicate target

theorem countableExpressionsCannotExpressEveryPredicate
    (classifies : Nat → Nat → Prop) : ¬ AllPredicatesExpressible classifies := by
  intro complete
  obtain ⟨expression, exactAt⟩ := complete (fun target => ¬ classifies target target)
  have self := exactAt expression
  have notSelf : ¬ classifies expression expression := fun holds => (self.mp holds) holds
  exact notSelf (self.mpr notSelf)

theorem natProjectionCannotBePredicateComplete
    (ontology : OntologyProjection Nat Nat)
    (scopeIsAllNat : ∀ target, ontology.scope.includes target) :
    ¬ PredicateComplete ontology := by
  intro complete
  apply countableExpressionsCannotExpressEveryPredicate ontology.classifies
  intro predicate
  obtain ⟨expression, _, exactAt⟩ := complete predicate
  exact ⟨expression, fun target => exactAt target (scopeIsAllNat target)⟩

/-!
An actual Body countermodel on PR #16. Only constituent membership changes;
the Entity, named State history, transformations, paths, Boundary, and Interior
are inherited unchanged. Body.partAt is already a declared formal boundary.
-/

open EmbodiedConsciousnessProposal

def sensorOnlyBody : Body ToyPart systemEntity :=
  { systemBody with
    partAt := fun _ part => part = .sensor
    eachStateHasConstituent := by intro current member; exact ⟨.sensor, rfl⟩ }

def NamedSensorMembership (body : Body ToyPart systemEntity) : Prop :=
  body.partAt (state false .forwardLow) .sensor

theorem sameEntityBodiesDisagreeAtNamedState :
    sensorOnlyBody.states = systemBody.states ∧
    sensorOnlyBody.recurringTransformations = systemBody.recurringTransformations ∧
    (state false .forwardLow) ∈ systemBody.states ∧
    NamedSensorMembership sensorOnlyBody ∧ ¬ NamedSensorMembership systemBody := by
  refine ⟨rfl, rfl, ?_, ?_, ?_⟩
  · simp [systemBody, systemPersistence]
  · rfl
  · simp [NamedSensorMembership, systemBody, state]

def Determines {ModelInstance : Type u}
    (holds : ModelInstance → Prop) : Prop :=
  (∀ interpretation, holds interpretation) ∨ (∀ interpretation, ¬ holds interpretation)

theorem bodyConstraintsDoNotDetermineNamedMembership :
    ¬ Determines NamedSensorMembership := by
  intro determines
  rcases determines with positive | negative
  · exact sameEntityBodiesDisagreeAtNamedState.2.2.2.2 (positive systemBody)
  · exact negative sensorOnlyBody sameEntityBodiesDisagreeAtNamedState.2.2.2.1

/-!
Any proof calculus sound in all these Body interpretations cannot derive either
side of this particular sentence. Proof inhabitation is distinct from Holds.
No such calculus, Gödel encoding, or exhaustive canonical Organon theory is
assumed to have been constructed by naming this parameter.
-/

inductive MembershipSentence where
  | sensorPresent | sensorNotPresent
deriving DecidableEq, Repr

def MembershipHolds (body : Body ToyPart systemEntity) : MembershipSentence → Prop
  | .sensorPresent => NamedSensorMembership body
  | .sensorNotPresent => ¬ NamedSensorMembership body

theorem soundBodyCalculusCannotDecideMembership
    (Proof : MembershipSentence → Type)
    (sound : ∀ sentence, Proof sentence →
      ∀ body : Body ToyPart systemEntity, MembershipHolds body sentence) :
    ¬ (Nonempty (Proof .sensorPresent) ∨ Nonempty (Proof .sensorNotPresent)) := by
  intro decided
  rcases decided with positive | negative
  · obtain ⟨proof⟩ := positive
    exact sameEntityBodiesDisagreeAtNamedState.2.2.2.2
      (sound .sensorPresent proof systemBody)
  · obtain ⟨proof⟩ := negative
    exact sound .sensorNotPresent proof sensorOnlyBody
      sameEntityBodiesDisagreeAtNamedState.2.2.2.1

/-! Nonbinding candidate profiles. Local predicates are explicit metalinguistic
inputs, not canonical Presence, Rule, Constraint, or CausalPath realization. -/

structure Classification (Expression : Type u) (Target : Type v) where
  scope : Scope Target
  expression : Expression
  interpretation : Interpretation Expression (Target → Prop) Unit
  expressionInScope : interpretation.scope.includes expression
  withinScope : ∀ target, (interpretation.assignment expression).target target →
    scope.includes target

def Classification.condition {E : Type u} {T : Type v}
    (classification : Classification E T) : T → Prop :=
  (classification.interpretation.assignment classification.expression).target

def classificationOf {E : Type u} {T : Type v}
    (p : OntologyProjection E T) (e : E) (active : e ∈ p.expressions) : Classification E T where
  scope := p.scope
  expression := e
  interpretation := p.interpretation
  expressionInScope := p.activeWithinInterpretation e active
  withinScope := by
    intro target holds
    rw [p.denotationExact e active] at holds
    exact p.classificationWithinScope e target active holds

structure OntologicalFramework (Expression : Type u) (Target : Type v) where
  projection : OntologyProjection Expression Target
  rule : Expression → Expression → Prop
  constraint : Expression → Expression → Prop

def AdmissibleRewrite {E : Type u} {T : Type v}
    (f : OntologicalFramework E T) (input output : E) : Prop :=
  input ∈ f.projection.expressions ∧ output ∈ f.projection.expressions ∧
    f.rule input output ∧ f.constraint input output

def finiteFramework : OntologicalFramework (Bool × Bool) Bool where
  projection := finiteComplete
  rule := fun input output => input = output
  constraint := fun _ _ => True

theorem finiteFrameworkHasClassificationAndRewrite :
    (classificationOf finiteFramework.projection (true, true) (by
      simp [finiteFramework, finiteComplete])).condition false ∧
    AdmissibleRewrite finiteFramework (true, true) (true, true) := by
  simp [Classification.condition, classificationOf, finiteFramework, finiteComplete, AdmissibleRewrite]

/-- Granularity is classification-response equivalence, compared within scope. -/
def Granularity {E : Type u} {T : Type v}
    (p : OntologyProjection E T) (left right : T) : Prop :=
  ∀ e, e ∈ p.expressions → (p.classifies e left ↔ p.classifies e right)

theorem granularityReflexive {E : Type u} {T : Type v} (p : OntologyProjection E T) (x : T) :
    Granularity p x x := fun _ _ => Iff.rfl

theorem granularitySymmetric {E : Type u} {T : Type v} (p : OntologyProjection E T)
    (x y : T) (same : Granularity p x y) : Granularity p y x :=
  fun e active => (same e active).symm

theorem granularityTransitive {E : Type u} {T : Type v} (p : OntologyProjection E T)
    (x y z : T) (xy : Granularity p x y) (yz : Granularity p y z) : Granularity p x z :=
  fun e active => (xy e active).trans (yz e active)

def FinerThan {E F : Type u} {T : Type v}
    (fine : OntologyProjection E T) (coarse : OntologyProjection F T) : Prop :=
  (∀ target, fine.scope.includes target ↔ coarse.scope.includes target) ∧
  ∀ x y, fine.scope.includes x → fine.scope.includes y →
    Granularity fine x y → Granularity coarse x y

theorem finerReflexive {E : Type u} {T : Type v} (p : OntologyProjection E T) : FinerThan p p :=
  ⟨fun _ => Iff.rfl, fun _ _ _ _ same => same⟩

theorem finerTransitive {E F G : Type u} {T : Type v}
    (a : OntologyProjection E T) (b : OntologyProjection F T) (c : OntologyProjection G T)
    (ab : FinerThan a b) (bc : FinerThan b c) : FinerThan a c := by
  refine ⟨fun x => (ab.1 x).trans (bc.1 x), ?_⟩
  intro x y hx hy same
  exact bc.2 x y ((ab.1 x).mp hx) ((ab.1 y).mp hy) (ab.2 x y hx hy same)

def Expressivity {E : Type u} {T : Type v} (p : OntologyProjection E T) : (T → Prop) → Prop :=
  Expresses p

def ExpressivelyCompleteRelative {E : Type u} {T : Type v}
    (p : OntologyProjection E T) (family : (T → Prop) → Prop) : Prop :=
  ∀ condition, family condition → Expressivity p condition

def ExpressiveLimitation {E : Type u} {T : Type v}
    (p : OntologyProjection E T) (family : (T → Prop) → Prop) (condition : T → Prop) : Prop :=
  family condition ∧ ¬ Expressivity p condition

def singletonCategories : OntologyProjection Bool Bool where
  scope := ⟨fun _ => True⟩
  expressions := [false, true]
  expressionsNonempty := by simp
  classifies := fun expression target => expression = target
  classificationWithinScope := by simp
  interpretation := ⟨(), ⟨fun _ => True⟩,
    fun expression => ⟨expression, fun target => expression = target⟩, by simp⟩
  activeWithinInterpretation := by simp
  denotationExact := by simp

theorem separationDoesNotEntailPredicateExpressivity :
    SeparatesScope singletonCategories ∧
    ExpressiveLimitation singletonCategories (fun _ => True) (fun _ => True) := by
  constructor
  · intro left right _ _ distinct
    refine ⟨left, ?_, ?_⟩
    · cases left <;> simp [singletonCategories]
    · simp only [singletonCategories]
      intro same
      exact distinct (same.mp trivial)
  · refine ⟨trivial, ?_⟩
    intro expressive
    obtain ⟨expression, _, exactAt⟩ := expressive
    have atFalse := (exactAt false trivial).mpr trivial
    have atTrue := (exactAt true trivial).mpr trivial
    cases expression <;> simp [singletonCategories] at atFalse atTrue

structure AllocationModel (Request : Type u) where
  scope : Scope Request
  feasible : List Request → Prop
  emptyFeasible : feasible []
  feasibleWithinScope : ∀ requests, feasible requests →
    ∀ request, request ∈ requests → scope.includes request

/-- Specified demands cannot all be realized under the feasibility constraint. -/
def Scarcity {Request : Type u} (model : AllocationModel Request) (demands : List Request) : Prop :=
  demands ≠ [] ∧ (∀ request, request ∈ demands → model.scope.includes request) ∧
    ¬ model.feasible demands

def oneSlot : AllocationModel Bool where
  scope := ⟨fun _ => True⟩
  feasible := fun requests => requests.length ≤ 1
  emptyFeasible := by decide
  feasibleWithinScope := by simp

def twoSlots : AllocationModel Bool where
  scope := ⟨fun _ => True⟩
  feasible := fun requests => requests.length ≤ 2
  emptyFeasible := by decide
  feasibleWithinScope := by simp

theorem jointlyScarceDespiteIndividualAccess :
    Scarcity oneSlot [false, true] ∧ (∀ request : Bool, oneSlot.feasible [request]) := by
  constructor
  · refine ⟨by decide, ?_, ?_⟩
    · intro request _
      trivial
    · change ¬ ([false, true].length ≤ 1)
      decide
  · intro request
    simp [oneSlot]

theorem sameDemandsNeedNotBeScarce : ¬ Scarcity twoSlots [false, true] := by
  intro scarce
  exact scarce.2.2 (by change [false, true].length ≤ 2; decide)

/-- Finite rational masses. Normalization does not establish world correspondence. -/
structure OntologicalProbability (Condition : Type u) (Outcome : Type v) where
  condition : Condition
  outcomes : List Outcome
  distinct : outcomes.Nodup
  mass : Outcome → Nat
  total : Nat
  totalPositive : 0 < total
  normalized : (outcomes.map mass).sum = total
  outsideZero : ∀ outcome, outcome ∉ outcomes → mass outcome = 0
  bounded : ∀ outcome, outcome ∈ outcomes → mass outcome ≤ total

/-- Exact fraction numerator / denominator, without rounding. -/
def ProbabilityFraction {C : Type u} {O : Type v} (p : OntologicalProbability C O) (outcome : O) : Nat × Nat :=
  (p.mass outcome, p.total)

def balancedProbability : OntologicalProbability Unit Bool where
  condition := ()
  outcomes := [false, true]
  distinct := by decide
  mass := fun _ => 1
  total := 2
  totalPositive := by decide
  normalized := by decide
  outsideZero := by intro outcome absent; cases outcome <;> simp at absent
  bounded := by intro outcome _; decide

def tiltedProbability : OntologicalProbability Unit Bool where
  condition := ()
  outcomes := [false, true]
  distinct := by decide
  mass := fun outcome => if outcome then 2 else 1
  total := 3
  totalPositive := by decide
  normalized := by decide
  outsideZero := by intro outcome absent; cases outcome <;> simp at absent
  bounded := by intro outcome _; cases outcome <;> decide

theorem normalizedProbabilitiesHaveDifferentValues :
    balancedProbability.condition = tiltedProbability.condition ∧
    balancedProbability.outcomes = tiltedProbability.outcomes ∧
    (ProbabilityFraction balancedProbability false).1 *
      (ProbabilityFraction tiltedProbability false).2 ≠
    (ProbabilityFraction tiltedProbability false).1 *
      (ProbabilityFraction balancedProbability false).2 := by
  refine ⟨rfl, rfl, ?_⟩
  decide

/-- Time is a metalinguistic index. Scale and scope are explicit.
Canonical Entity identity and actual signal/causal-path joins remain gates. -/
structure SourceLinkHistory (Scale : Type u) (Being : Type v) where
  scope : Scale → Nat → Being → Prop
  links : Scale → Nat → Being → Being → Prop
  withinScope : ∀ scale time source target, links scale time source target →
    scope scale time source ∧ scope scale time target

def Differentiation {S : Type u} {B : Type v} (h : SourceLinkHistory S B)
    (scale : S) (source target : B) (before after : Nat) : Prop :=
  before < after ∧ source ≠ target ∧
  h.scope scale before source ∧ h.scope scale before target ∧
  h.scope scale after source ∧ h.scope scale after target ∧
  h.links scale before source target ∧ ¬ h.links scale after source target

/-- Daniel's proposed source-loss criterion; an explicit alias, not an
independently derived universal account of creation or autonomy. -/
def Novelty {S : Type u} {B : Type v} (h : SourceLinkHistory S B)
    (scale : S) (source target : B) (before after : Nat) : Prop :=
  Differentiation h scale source target before after

theorem noveltyUsesDeclaredDifferentiationCriterion {S : Type u} {B : Type v}
    (h : SourceLinkHistory S B) (scale : S) (source target : B) (before after : Nat) :
    Novelty h scale source target before after ↔
      Differentiation h scale source target before after := Iff.rfl

def reconnectingHistory : SourceLinkHistory Unit Bool where
  scope := fun _ _ _ => True
  links := fun _ time source target => source = false ∧ target = true ∧ time ≠ 1
  withinScope := by simp

theorem sourceLossDoesNotEntailPermanentDisconnection :
    Novelty reconnectingHistory () false true 0 1 ∧
    reconnectingHistory.links () 2 false true := by
  constructor
  · unfold Novelty Differentiation reconnectingHistory
    decide
  · change false = false ∧ true = true ∧ (2 : Nat) ≠ 1
    decide

def blockedFramework : OntologicalFramework (Bool × Bool) Bool where
  projection := finiteComplete
  rule := fun _ _ => True
  constraint := fun _ _ => False

theorem ruleAloneDoesNotAdmitRewrite :
    blockedFramework.rule (true, true) (true, true) ∧
    ¬ AdmissibleRewrite blockedFramework (true, true) (true, true) := by
  simp [blockedFramework, AdmissibleRewrite]

theorem finerDoesNotMeanEquivalent :
    FinerThan finiteComplete collapsed ∧ ¬ FinerThan collapsed finiteComplete := by
  constructor
  · refine ⟨fun _ => Iff.rfl, ?_⟩
    intro left right _ _ _
    simp [Granularity, collapsed]
  · intro reverse
    have same : Granularity collapsed false true := by simp [Granularity, collapsed]
    have fineSame := reverse.2 false true trivial trivial same
    have separates := fineSame (false, true) (by simp [finiteComplete])
    simp [finiteComplete] at separates

theorem scarcityMapCanMisrepresentFeasibility :
    Scarcity oneSlot [false, true] ∧ ¬ Scarcity twoSlots [false, true] :=
  ⟨jointlyScarceDespiteIndividualAccess.1, sameDemandsNeedNotBeScarce⟩


/-! Practical Understanding is a witnessed orientation Transformation over an
Entity's history. Input-kind tags and candidate possibilities are projections,
not complete canonical Perception/Memory/Model and Action realization. -/
inductive UnderstandingInput where
  | perception | memory | model
  deriving DecidableEq

structure Understanding {Carrier : Type u} (Candidate : Type v)
    (entity : Entity Carrier) (possibilities : Scope Candidate) where
  inputKind : UnderstandingInput
  orientation : Transformation entity.persistenceDirection
  inputInHistory : orientation.input ∈ entity.persistence.states
  outputInHistory : orientation.output ∈ entity.persistence.states
  left : Candidate
  right : Candidate
  leftPossible : possibilities.includes left
  rightPossible : possibilities.includes right
  candidatesDiffer : left ≠ right
  differentiate : State Carrier → Candidate → Bool
  outputDistinguishes : differentiate orientation.output left ≠
    differentiate orientation.output right
  orientationChangesPossibility : differentiate orientation.input left ≠
    differentiate orientation.output left

/-- Assignment use, scoped to expressions; no Entity or Action premise. -/
def Interprets {E : Type u} {T : Type v} {C : Type w}
    (semantics : Interpretation E T C) (expression : E) (target : T) : Prop :=
  semantics.scope.includes expression ∧ (semantics.assignment expression).target = target

def orientationDirection : Direction (Nat × Bool) where
  before := fun a b => a.value.1 < b.value.1
  asymmetric := by intro a b before reverse; exact Nat.lt_asymm before reverse

def orientationInvariant : Invariant (Nat × Bool) := ⟨fun _ => True⟩

def orientationBoundary : Boundary (Nat × Bool) orientationInvariant where
  constraints := []
  preserves := by simp [orientationInvariant]

def orientationEntity : Entity (Nat × Bool) where
  identity := orientationInvariant
  boundary := orientationBoundary
  persistenceDirection := orientationDirection
  persistence := {
    states := [⟨(0, false)⟩, ⟨(1, true)⟩, ⟨(2, false)⟩]
    hasTransition := ⟨⟨(0, false)⟩, ⟨(1, true)⟩, [⟨(2, false)⟩], rfl⟩
    invariant := orientationInvariant
    invariantHolds := by simp [orientationInvariant]
    ordered := by simp [OrderedBy, orientationDirection] }
  persistenceNamesIdentity := rfl
  current := ⟨(2, false)⟩
  currentInPersistence := by simp
  identityHolds := trivial

def allPossibilities : Scope Bool := ⟨fun _ => True⟩
def noPossibilities : Scope Bool := ⟨fun _ => False⟩

def firstUnderstanding : Understanding Bool orientationEntity allPossibilities where
  inputKind := .memory
  orientation := ⟨⟨(0, false)⟩, ⟨(1, true)⟩, by change (0 : Nat) < 1; decide⟩
  inputInHistory := by simp [orientationEntity]
  outputInHistory := by simp [orientationEntity]
  left := false
  right := true
  leftPossible := trivial
  rightPossible := trivial
  candidatesDiffer := by decide
  differentiate := fun state option => if state.value.2 then option else !option
  outputDistinguishes := by decide
  orientationChangesPossibility := by decide

def secondUnderstanding : Understanding Bool orientationEntity allPossibilities where
  inputKind := .perception
  orientation := ⟨⟨(1, true)⟩, ⟨(2, false)⟩, by change (1 : Nat) < 2; decide⟩
  inputInHistory := by simp [orientationEntity]
  outputInHistory := by simp [orientationEntity]
  left := false
  right := true
  leftPossible := trivial
  rightPossible := trivial
  candidatesDiffer := by decide
  differentiate := fun state option => if state.value.2 then option else !option
  outputDistinguishes := by decide
  orientationChangesPossibility := by decide

def alternateInterpretation : Interpretation Bool (Bool → Prop) Unit where
  context := ()
  scope := ⟨fun _ => True⟩
  assignment := fun expression => ⟨expression, fun target => expression ≠ target⟩
  namesExpression := by simp

def noActiveInterpretation : Interpretation Bool (Bool → Prop) Unit where
  context := ()
  scope := ⟨fun _ => False⟩
  assignment := fun expression => ⟨expression, fun _ => False⟩
  namesExpression := by simp

theorem semanticAssignmentDoesNotSupplyPracticalUnderstanding :
    singletonCategories.interpretation.scope.includes false ∧
    ¬ Nonempty (Understanding Bool orientationEntity noPossibilities) := by
  refine ⟨trivial, ?_⟩
  rintro ⟨orientation⟩
  exact orientation.leftPossible

theorem practicalUnderstandingNeedsNoActiveSemanticAssignment :
    Nonempty (Understanding Bool orientationEntity allPossibilities) ∧
    ∀ expression target, ¬ Interprets noActiveInterpretation expression target := by
  refine ⟨⟨firstUnderstanding⟩, ?_⟩
  intro expression target assignment
  exact assignment.1

structure SituatedOrientation where
  semantics : Interpretation Bool (Bool → Prop) Unit
  understanding : Understanding Bool orientationEntity allPossibilities

def firstSituatedOrientation : SituatedOrientation :=
  ⟨singletonCategories.interpretation, firstUnderstanding⟩
def reorientedSituation : SituatedOrientation :=
  ⟨singletonCategories.interpretation, secondUnderstanding⟩
def reinterpretedSituation : SituatedOrientation :=
  ⟨alternateInterpretation, firstUnderstanding⟩

theorem sameSemanticAssignmentAllowsDifferentOrientations :
    firstSituatedOrientation.semantics = reorientedSituation.semantics ∧
    firstSituatedOrientation.understanding.differentiate
      firstSituatedOrientation.understanding.orientation.output false ≠
    reorientedSituation.understanding.differentiate
      reorientedSituation.understanding.orientation.output false := by
  constructor
  · rfl
  · decide

theorem sameOrientationAllowsDifferentSemanticAssignments :
    firstSituatedOrientation.understanding.orientation =
      reinterpretedSituation.understanding.orientation ∧
    (firstSituatedOrientation.semantics.assignment false).target false ∧
    ¬ (reinterpretedSituation.semantics.assignment false).target false := by
  refine ⟨rfl, rfl, ?_⟩
  simp [reinterpretedSituation, alternateInterpretation]

/-- An explicitly empty execution path has no completed endpoint witness.
This does not assert that no Action occurs anywhere outside this trace. -/
def emptyExecutionTrace : CausalPath orientationDirection (⟨fun _ _ => True⟩) where
  steps := []
  connected := trivial

theorem understandingDoesNotRequireCompletedExecutionTrace :
    Nonempty (Understanding Bool orientationEntity allPossibilities) ∧
    ¬ Nonempty (PathEndpoints emptyExecutionTrace) := by
  refine ⟨⟨firstUnderstanding⟩, ?_⟩
  rintro ⟨endpoints⟩
  obtain ⟨rest, starts⟩ := endpoints.startsWith
  have impossible : ([] : List (Transformation orientationDirection)) = endpoints.first :: rest := starts
  cases impossible

theorem classificationConditionIsItsInterpretedTarget {E : Type u} {T : Type v}
    (p : OntologyProjection E T) (e : E) (active : e ∈ p.expressions) :
    (classificationOf p e active).condition = (p.interpretation.assignment e).target ∧
    (classificationOf p e active).condition = p.classifies e := by
  exact ⟨rfl, p.denotationExact e active⟩


#print axioms coverageDoesNotEntailSeparation
#print axioms selectiveHasAnOmittedTarget
#print axioms finiteOntologyCanBePredicateComplete
#print axioms finiteCompleteCoversScope
#print axioms countableExpressionsCannotExpressEveryPredicate
#print axioms natProjectionCannotBePredicateComplete
#print axioms sameEntityBodiesDisagreeAtNamedState
#print axioms bodyConstraintsDoNotDetermineNamedMembership
#print axioms soundBodyCalculusCannotDecideMembership
#print axioms finiteFrameworkHasClassificationAndRewrite
#print axioms granularityReflexive
#print axioms granularitySymmetric
#print axioms granularityTransitive
#print axioms finerReflexive
#print axioms finerTransitive
#print axioms separationDoesNotEntailPredicateExpressivity
#print axioms jointlyScarceDespiteIndividualAccess
#print axioms sameDemandsNeedNotBeScarce
#print axioms normalizedProbabilitiesHaveDifferentValues
#print axioms noveltyUsesDeclaredDifferentiationCriterion
#print axioms sourceLossDoesNotEntailPermanentDisconnection
#print axioms ruleAloneDoesNotAdmitRewrite
#print axioms finerDoesNotMeanEquivalent
#print axioms scarcityMapCanMisrepresentFeasibility
#print axioms semanticAssignmentDoesNotSupplyPracticalUnderstanding
#print axioms practicalUnderstandingNeedsNoActiveSemanticAssignment
#print axioms sameSemanticAssignmentAllowsDifferentOrientations
#print axioms sameOrientationAllowsDifferentSemanticAssignments
#print axioms understandingDoesNotRequireCompletedExecutionTrace
#print axioms classificationConditionIsItsInterpretedTarget

end DanielOntology.OntologyCompletenessExperiment
