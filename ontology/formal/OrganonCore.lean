import Std

/-!
# OrganonCore: Absence-free formal reduct

This file contains the formal structures and classifiers that do not mention
absolute Absence, its local `Absent` shadow, or contrastive `Present`.

The reduct retains relational Missingness as an expected value omitted from a
field. `DanielOntology.lean` is a conservative extension that imports this file
and adds the Absence/Presence experiment. Downstream formal modules import this
file directly, making their independence from that extension checkable through
Lean's module dependency graph.
-/

universe u v w x

namespace DanielOntology

/-! ## Relational Missingness without absolute Absence -/

structure Field (α : Type u) where
  contains : α → Prop

structure Missingness (α : Type u) where
  field : Field α
  expected : α
  missing : ¬ field.contains expected

/-! ## State, Direction, Transformation, Feeds, and Causal path -/

structure State (Carrier : Type u) where
  value : Carrier

structure Direction (Carrier : Type u) where
  before : State Carrier → State Carrier → Prop
  asymmetric : ∀ {a b}, before a b → ¬ before b a

structure Transformation {Carrier : Type u} (direction : Direction Carrier) where
  input : State Carrier
  output : State Carrier
  advances : direction.before input output

/-! `Feeds` can encode contribution without requiring State equality. -/
structure FeedRelation (Carrier : Type u) where
  feeds : State Carrier → State Carrier → Prop

def Chains
    {Carrier : Type u}
    {direction : Direction Carrier}
    (feeding : FeedRelation Carrier) :
    List (Transformation direction) → Prop
  | [] => True
  | [_] => True
  | first :: second :: rest =>
      feeding.feeds first.output second.input ∧ Chains feeding (second :: rest)

structure CausalPath
    {Carrier : Type u}
    (direction : Direction Carrier)
    (feeding : FeedRelation Carrier) where
  steps : List (Transformation direction)
  connected : Chains feeding steps

/-! ## Constraint, Invariant, Boundary, and Entity -/

structure Constraint (Carrier : Type u) where
  permits : {direction : Direction Carrier} → Transformation direction → Prop

structure Invariant (Carrier : Type u) where
  holds : State Carrier → Prop

def OrderedBy {α : Type u} (relation : α → α → Prop) : List α → Prop
  | [] => True
  | [_] => True
  | first :: second :: rest =>
      relation first second ∧ OrderedBy relation (second :: rest)

structure PersistenceWitness
    {Carrier : Type u}
    (direction : Direction Carrier) where
  states : List (State Carrier)
  hasTransition :
    ∃ first second rest, states = first :: second :: rest
  invariant : Invariant Carrier
  invariantHolds :
    ∀ state, state ∈ states → invariant.holds state
  ordered : OrderedBy direction.before states

structure Boundary (Carrier : Type u) (identity : Invariant Carrier) where
  constraints : List (Constraint Carrier)
  preserves :
    ∀ {direction : Direction Carrier} (t : Transformation direction),
      (∀ c, c ∈ constraints → c.permits t) →
      identity.holds t.input →
      identity.holds t.output

theorem emptyBoundaryRequiresUniversalPreservation
    {Carrier : Type u}
    {identity : Invariant Carrier}
    (boundary : Boundary Carrier identity)
    (empty : boundary.constraints = []) :
    ∀ {direction : Direction Carrier} (t : Transformation direction),
      identity.holds t.input → identity.holds t.output := by
  intro direction t inputHolds
  apply boundary.preserves t
  · intro constraint member
    rw [empty] at member
    cases member
  · exact inputHolds

structure Entity (Carrier : Type u) where
  identity : Invariant Carrier
  boundary : Boundary Carrier identity
  persistenceDirection : Direction Carrier
  persistence : PersistenceWitness persistenceDirection
  persistenceNamesIdentity : persistence.invariant = identity
  current : State Carrier
  currentInPersistence : current ∈ persistence.states
  identityHolds : identity.holds current

theorem entityIdentityPersists
    {Carrier : Type u}
    (entity : Entity Carrier) :
    ∀ state,
      state ∈ entity.persistence.states → entity.identity.holds state := by
  intro state member
  rw [← entity.persistenceNamesIdentity]
  exact entity.persistence.invariantHolds state member

/-! ## Scope, executable Specification, and temporal interval -/

structure Scope (α : Type u) where
  includes : α → Prop

/-!
The Boolean function and correctness proof are explicit data. A concrete
Specification still requires evaluation evidence before its implementation may
be advertised as operationally executable: Lean permits noncomputable values.
-/
structure Specification (α : Type u) where
  scope : Scope α
  conforms : α → Prop
  decideConformity : α → Bool
  conformityCorrect : ∀ x, decideConformity x = true ↔ conforms x
  conformityWithinScope : ∀ x, conforms x → scope.includes x

structure Interval where
  start : Nat
  finish : Nat
  ordered : start ≤ finish

def Interval.contains (interval : Interval) (time : Nat) : Prop :=
  interval.start ≤ time ∧ time ≤ interval.finish

/-! ## Contextual Capability and Order-indexed Permission -/

structure Capability
    (Agent : Type u)
    (Action : Agent → Type v)
    (Context : Type w)
    (agent : Agent) where
  can : Context → Action agent → Prop

structure InstitutionalOrder (Principal : Type u) (Agent : Type v) where
  recognizesPrincipal : Principal → Prop
  recognizesAgent : Agent → Prop
  admits : Nat → Nat → Nat → Nat → Prop
  revokes : Nat → Nat → Prop

structure PermissionClaim
    (Principal : Type u)
    (Agent : Type v)
    (Action : Agent → Type w)
    (order : InstitutionalOrder Principal Agent) where
  claimId : Nat
  principal : Principal
  principalStanding : order.recognizesPrincipal principal
  agent : Agent
  agentStanding : order.recognizesAgent agent
  scope : Scope (Action agent)
  interval : Interval

structure Authority
    (Principal : Type u)
    (Agent : Type v)
    (Action : Agent → Type w)
    (order : InstitutionalOrder Principal Agent)
    (principal : Principal)
    (target : Agent) where
  holder : Agent
  holderStanding : order.recognizesAgent holder
  actionScope : Scope (Action target)
  interval : Interval

structure Grant
    (Principal : Type u)
    (Agent : Type v)
    (Action : Agent → Type w)
    (order : InstitutionalOrder Principal Agent)
    (claim : PermissionClaim Principal Agent Action order) where
  grantId : Nat
  authority : Authority Principal Agent Action order claim.principal claim.agent
  grantAction : Action authority.holder
  scopeCovered :
    ∀ action, claim.scope.includes action → authority.actionScope.includes action
  intervalCovered :
    ∀ time, claim.interval.contains time → authority.interval.contains time

structure Permission
    (Principal : Type u)
    (Agent : Type v)
    (Action : Agent → Type w) where
  order : InstitutionalOrder Principal Agent
  claim : PermissionClaim Principal Agent Action order
  grant : Grant Principal Agent Action order claim
  permissionId : Nat
  admittedAt : Nat
  admitted : order.admits claim.claimId grant.grantId permissionId admittedAt

structure PermissionExercise
    (Principal : Type u)
    (Agent : Type v)
    (Action : Agent → Type w)
    (Context : Type x) where
  permission : Permission Principal Agent Action
  action : Action permission.claim.agent
  time : Nat
  context : Context
  inScope : permission.claim.scope.includes action
  inInterval : permission.claim.interval.contains time
  capability : Capability Agent Action Context permission.claim.agent
  technicallyPossible : capability.can context action
  stillAdmitted :
    permission.order.admits
      permission.claim.claimId
      permission.grant.grantId
      permission.permissionId
      time
  notRevoked :
    ∀ revokedAt,
      permission.order.revokes permission.permissionId revokedAt →
      ¬ revokedAt ≤ time

/-! ## Scoped independence and Rule provenance -/

structure AdmissibilityRuleProvenance
    (Agent : Type u)
    (Order : Type v)
    (Rule : Type w)
    (Declaration : Type x) where
  order : Order
  rule : Rule
  declaration : Declaration
  authorizer : Agent
  authorized : Agent → Order → Declaration → Rule → Prop
  authorizationHolds : authorized authorizer order declaration rule

structure IndependentFor
    (Agent : Type u)
    (Witness : Type v)
    (Claim : Type w)
    (Observation : Type x)
    (Order Rule Constraint Process Declaration : Type) where
  witness : Witness
  claimant : Agent
  claim : Claim
  observation : Observation
  provenance : AdmissibilityRuleProvenance Agent Order Rule Declaration
  process : Process
  loadBearing : Constraint
  controls : Agent → Constraint → Prop
  observationAuthority : Agent → Order → Process → Prop
  ruleAuthority : Agent → Order → Rule → Prop
  outsideControl : ¬ controls claimant loadBearing
  noObservationAuthority :
    ¬ observationAuthority claimant provenance.order process
  noRuleAuthority :
    ¬ ruleAuthority claimant provenance.order provenance.rule

end DanielOntology
