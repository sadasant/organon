import Std

/-!
# Daniel's Ontology: formal spike

This file is a noncanonical formalization experiment corresponding to
`Daniels-Ontology.md`. The Markdown ontology remains binding until this artifact
reaches term-for-term parity and Daniel explicitly adopts it.

The file distinguishes the object language from its metatheory. An uninhabited
type is a local formal shadow of absolute Absence inside Lean's already-present
metatheory, not absolute Absence itself. Successful elaboration is external
Evidence that the mark occurred; it is not an object-level theorem about the
compiler.
-/

universe u v w

namespace DanielOntology

/-! ## Absence, Presence, and Missingness -/

/-- `Absent α` means that the type `α` has no inhabitants. -/
abbrev Absent (α : Type u) : Prop := α → False

/-- `Present α` means that the type `α` has at least one inhabitant. -/
abbrev Present (α : Type u) : Prop := Nonempty α

/-- A universe-polymorphic equivalence, kept local to avoid external libraries. -/
structure TypeEquiv (α : Type u) (β : Type v) where
  toFun : α → β
  invFun : β → α
  leftInv : ∀ a, invFun (toFun a) = a
  rightInv : ∀ b, toFun (invFun b) = b

/-- A1's local shadow: an inhabitant of an absent type eliminates into any sort. -/
def absenceElim {α : Type u} (h : Absent α) {β : Sort v} (a : α) : β :=
  False.elim (h a)

/-- A2's local shadow: all uninhabited types are equivalent, not definitionally equal. -/
def emptyEquiv {α : Type u} {β : Type v} (ha : Absent α) (hb : Absent β) : TypeEquiv α β where
  toFun a := False.elim (ha a)
  invFun b := False.elim (hb b)
  leftInv a := False.elim (ha a)
  rightInv b := False.elim (hb b)

/-- A3, exclusivity: no type is both uninhabited and inhabited. -/
theorem absencePresenceExclusive (α : Type u) : ¬ (Absent α ∧ Present α) := by
  intro h
  rcases h with ⟨ha, ⟨a⟩⟩
  exact ha a

/-!
A3's exhaustiveness is not constructive. The local `classical` declaration
prices the binding ontology's explicit choice of a classical metalanguage.
-/
theorem absencePresenceExhaustive (α : Type u) : Absent α ∨ Present α := by
  classical
  by_cases h : Nonempty α
  · exact Or.inr h
  · exact Or.inl (fun a => h ⟨a⟩)

/-- The formal mark used by A4's local, object-level witness. -/
inductive Mark where
  | drawn

/-- A4's local theorem: the declared mark inhabits its type. -/
theorem presenceObtains : Present Mark := ⟨Mark.drawn⟩

/-- A represented field whose contents can include or omit candidate Presences. -/
structure Field (α : Type u) where
  contains : α → Prop

/-!
A5's local shadow: Missingness names an expected inhabitant and evidence that a
present Field does not contain it. It is structured data, not `Absent α`.
-/
structure Missingness (α : Type u) where
  field : Field α
  expected : α
  missing : ¬ field.contains expected

/-- Any constructed Missingness is itself present in the formal system. -/
theorem missingnessIsPresent {α : Type u} (m : Missingness α) : Present (Missingness α) :=
  ⟨m⟩

/-! ## State, Direction, Transformation, and Causal path -/

/-!
A State carries the object-level value used by every later declaration. Any
ordering of declarations or observations remains metalinguistic until a
Direction internalizes asymmetry as a Relation.
-/
structure State (Carrier : Type u) where
  value : Carrier

/-- Direction is a first-class asymmetric Relation among States. -/
structure Direction (Carrier : Type u) where
  before : State Carrier → State Carrier → Prop
  asymmetric : ∀ {a b}, before a b → ¬ before b a

/-!
A Transformation is indexed by its Direction. Transformations sharing one
Direction therefore share it by type, not by equality between structures that
contain Prop-valued functions.
-/
structure Transformation {Carrier : Type u} (direction : Direction Carrier) where
  input : State Carrier
  output : State Carrier
  advances : direction.before input output

/-- Adjacent Transformations form one path when each output supplies the next input. -/
def Chains {Carrier : Type u} {direction : Direction Carrier} :
    List (Transformation direction) → Prop
  | [] => True
  | [_] => True
  | first :: second :: rest => first.output = second.input ∧ Chains (second :: rest)

/-- A Causal path shares one Direction as a type-level fact. -/
structure CausalPath {Carrier : Type u} (direction : Direction Carrier) where
  steps : List (Transformation direction)
  connected : Chains steps

/-! ## Constraint, Invariant, Boundary, and Entity -/

/-- A Constraint excludes some Transformations while permitting others. -/
structure Constraint (Carrier : Type u) where
  permits : {direction : Direction Carrier} → Transformation direction → Prop

/-- An Invariant names what must hold across admitted Transformations. -/
structure Invariant (Carrier : Type u) where
  holds : State Carrier → Prop

/-!
A Boundary is a Configuration of Constraints indexed to an identity Invariant.
Every Transformation admitted by all Boundary Constraints must preserve that
Invariant. The empty list admits every Transformation and therefore creates
the maximal preservation obligation.
-/
structure Boundary (Carrier : Type u) (identity : Invariant Carrier) where
  constraints : List (Constraint Carrier)
  preserves :
    ∀ {direction : Direction Carrier} (t : Transformation direction),
      (∀ c, c ∈ constraints → c.permits t) →
      identity.holds t.input →
      identity.holds t.output

/-- An empty Boundary must preserve identity under every Transformation. -/
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

/-!
An Entity is a current State with an identity Invariant, a Boundary indexed to
that Invariant, and evidence that the current State satisfies the Invariant.
-/
structure Entity (Carrier : Type u) where
  identity : Invariant Carrier
  boundary : Boundary Carrier identity
  current : State Carrier
  identityHolds : identity.holds current

/-! ## Scope, Specification, and dependent institutional records -/

/-- A Scope identifies the members to which a Representation or Constraint applies. -/
structure Scope (α : Type u) where
  includes : α → Prop

/-!
A Specification identifies a Scope and supplies constructive decision evidence
for conformity. Unlike classical bivalence, `DecidablePred` carries content
that can distinguish a Specification from an arbitrary predicate.
-/
structure Specification (α : Type u) where
  scope : Scope α
  conforms : α → Prop
  decidableConformity : DecidablePred conforms

/-- A closed temporal interval for institutional scope. -/
structure Interval where
  start : Nat
  finish : Nat
  ordered : start ≤ finish

/-- The Actions technically available to one particular Agent. -/
structure Capability
    (Agent : Type u)
    (Action : Agent → Type v)
    (agent : Agent) where
  can : Action agent → Prop

/-!
Permission is an institutional dependent record. It does not require current
technical Capability: standing authorization may precede or outlive the means
to exercise it.
-/
structure Permission
    (Principal : Type u)
    (Agent : Type v)
    (Action : Agent → Type w) where
  principal : Principal
  agent : Agent
  scope : Scope (Action agent)
  interval : Interval

/-!
ExercisablePermission records the additional coherence relation between a
Permission and a current Capability without redefining either as the other.
-/
structure ExercisablePermission
    (Principal : Type u)
    (Agent : Type v)
    (Action : Agent → Type w) where
  permission : Permission Principal Agent Action
  capability : Capability Agent Action permission.agent
  withinCapability :
    ∀ action, permission.scope.includes action → capability.can action

end DanielOntology
