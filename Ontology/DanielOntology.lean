import Std

/-!
# Daniel's Ontology: formal spike

This file is a noncanonical formalization experiment corresponding to
`Contexts/Organon/Daniels-Ontology.md` v0.7. The Markdown ontology remains
binding until this artifact reaches term-for-term parity and Daniel adopts it.

The file distinguishes the object language from its metatheory. `Empty` is a
local formal shadow of absolute Absence: it is an uninhabited type inside the
already-present Lean metatheory, not absolute Absence itself. Successful
elaboration is therefore external Evidence that the mark occurred; it is not
an object-level theorem about the compiler.
-/

universe u v w

namespace DanielOntology

/-! ## Absence and Presence -/

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

/--
A3, exhaustiveness for types. This theorem makes the classical commitment
explicit; Lean's constructive core does not supply the dichotomy for arbitrary
types.
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

/--
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

/-! ## State, Direction, and Transformation -/

/--
A State carries a metalinguistic index. The index distinguishes positions but
does not itself add an ontological Relation.
-/
structure State (Carrier : Type u) where
  value : Carrier
  index : Nat

/--
Direction internalizes asymmetry as a first-class Relation among States.
Metalinguistic indexing can state positions without constructing this object.
-/
structure Direction (S : Type u) where
  before : S → S → Prop
  asymmetric : ∀ {a b}, before a b → ¬ before b a

/-- A directed mapping from an input State to an output State. -/
structure Transformation (S : Type u) where
  input : S
  output : S
  direction : Direction S
  advances : direction.before input output

/-! ## Constraint, Invariant, Boundary, and Entity -/

/-- A Constraint excludes some Transformations while permitting others. -/
structure Constraint (S : Type u) where
  permits : Transformation S → Prop

/-- An Invariant names what must hold across admitted Transformations. -/
structure Invariant (S : Type u) where
  holds : S → Prop

/--
A Boundary is a Configuration of Constraints indexed to an identity Invariant.
Its proof requires every Transformation admitted by all Boundary Constraints to
preserve that Invariant.
-/
structure Boundary (S : Type u) (identity : Invariant S) where
  constraints : List (Constraint S)
  preserves :
    ∀ t : Transformation S,
      (∀ c, c ∈ constraints → c.permits t) →
      identity.holds t.input →
      identity.holds t.output

/--
An Entity is a current State with an identity Invariant, a Boundary indexed to
that Invariant, and evidence that the current State satisfies the Invariant.
-/
structure Entity (S : Type u) where
  identity : Invariant S
  boundary : Boundary S identity
  current : S
  identityHolds : identity.holds current

/-! ## Scope, Specification, and dependent institutional records -/

/-- A Scope identifies the members to which a Representation or Constraint applies. -/
structure Scope (α : Type u) where
  includes : α → Prop

/--
A Specification identifies a Scope and conformity conditions whose truth value
is determinate. Determinacy is logical; no testing Agent is implicit.
-/
structure Specification (α : Type u) where
  scope : Scope α
  conforms : α → Prop
  determinate : ∀ x, conforms x ∨ ¬ conforms x

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

/--
Permission is an arity-rich dependent record rather than an untyped relation.
Its Action type depends on its Agent, and every scoped Action must be admitted
by that Agent's Capability.
-/
structure Permission
    (Principal : Type u)
    (Agent : Type v)
    (Action : Agent → Type w) where
  principal : Principal
  agent : Agent
  capability : Capability Agent Action agent
  scope : Scope (Action agent)
  interval : Interval
  withinCapability : ∀ action, scope.includes action → capability.can action

end DanielOntology
