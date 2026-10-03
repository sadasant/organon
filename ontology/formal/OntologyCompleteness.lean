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

universe u v

namespace DanielOntology.OntologyCompletenessExperiment

structure OntologyProjection (Expression : Type u) (Target : Type v) where
  scope : Scope Target
  expressions : List Expression
  expressionsNonempty : expressions ≠ []
  classifies : Expression → Target → Prop
  classificationWithinScope : ∀ expression target,
    expression ∈ expressions → classifies expression target → scope.includes target
  denotation : Expression → Denotation Expression (Target → Prop)
  denotationExact : ∀ expression, expression ∈ expressions →
    (denotation expression).expression = expression ∧
    (denotation expression).target = classifies expression

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
  denotation := fun expression => ⟨expression, fun _ => True⟩
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
  denotation := fun expression => ⟨expression, fun target => target = false⟩
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
  denotation := fun expression =>
    ⟨expression, fun target => (if target then expression.2 else expression.1) = true⟩
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

def Determines {Interpretation : Type u}
    (holds : Interpretation → Prop) : Prop :=
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

#print axioms countableExpressionsCannotExpressEveryPredicate
#print axioms finiteOntologyCanBePredicateComplete
#print axioms soundBodyCalculusCannotDecideMembership

end DanielOntology.OntologyCompletenessExperiment
