import OrganonCore

/-!
# Set and Configuration over a declared local domain

`Set α` is extensional membership on a supplied local carrier (SC-D1).
`Configuration α realizes` retains a member Set AND a Set of specified
Relation/participant-tuple associations (SC-D2). The ambient `realizes` predicate
validates an association; selecting it cannot manufacture or rewire a Relation.
Every selected association has at least two participant positions and is tied to
the member Set by its Relation or at least one participant. Full participant
closure is not required. SC-C1 separates membership from relational structure.

Boundaries:

* Carrier. Every theorem is relative to a supplied carrier `α`. Nothing here
  constructs a carrier of all Presence, asserts unrestricted comprehension, or
  identifies any local `Set α` with Reality. The theorems neither assert nor
  refute that Reality could be described as a set; they only never license a
  local Set as exhaustive of Reality.
* Interpretation. `contains` is supplied by whoever builds the Set. No
  canonical classifier decides which actual Presences are members, which
  carrier values stand for Relations, or whether a carrier is adequate.
* Empty Set. The Set with no members is an inhabited value of `Set α`; it is a
  Presence fixed by having no member, not Absence. This module imports no
  Absence symbol.
* Relation. `realizes` is supplied interpretation, not a canonical classifier.
  Its adequacy, including the fixed participant roles of each actual Relation,
  remains an application gate. Lists encode finite ordered positions only;
  the canonical definition is not restricted to finite arity. Repeated values
  in different positions are allowed; a tuple is not a Set.
* Structure. Forgetting selected associations loses information. Re-encoding
  the complete structure as tagged sets would retain it, not identify the
  Configuration with its underlying member Set.
* Logic. Extensionality uses Lean's standard `propext` and `funext` (from
  `Quot.sound`); no `Classical.choice`, `sorry`, or project axiom is used. The finite witness derives `DecidableEq` only
  for its own comparisons.

The existing generic `State` record and other core structures are unchanged.

Contracts SC-D1, SC-D2, and SC-C1 are marked for the schema-v2 manifest. The
marked statement runs from the marker to the first `:=`.
-/

universe u

namespace DanielOntology.SetConfiguration

open DanielOntology

/-! ## Set -/

/-- A Set over a declared local domain `α`, fixed by its member predicate. -/
structure Set (α : Type u) where
  contains : α → Prop

/-- A local relational structure. Each selected association is realized and
involves a member, but may have participants outside the member Set. -/
structure Configuration (α : Type u) (realizes : α → List α → Prop) where
  members : Set α
  associations : Set (α × List α)
  valid : ∀ r ps, associations.contains (r, ps) →
    realizes r ps ∧ 2 ≤ ps.length ∧
      (members.contains r ∨ ∃ a, a ∈ ps ∧ members.contains a)

/-- The Set with no members over a declared local domain. -/
def emptySet (α : Type u) : Set α := ⟨fun _ => False⟩

/-- The Set whose members are exactly the items of a finite list. -/
def ofList {α : Type u} (items : List α) : Set α := ⟨fun item => item ∈ items⟩

theorem setExt {α : Type u} {s t : Set α}
    (same : ∀ a : α, s.contains a ↔ t.contains a) : s = t := by
  cases s with
  | mk sContains =>
    cases t with
    | mk tContains =>
      have : sContains = tContains := funext fun a => propext (same a)
      rw [this]

-- organon:contract SC-D1 begin
/-- organon:promotion-contract SC-D1 -/
theorem setExtensionality {α : Type u} (s t : Set α) :
    (Identity s t ↔ ∀ a : α, (s.contains a ↔ t.contains a)) ∧
    (∀ a : α, ¬ (emptySet α).contains a) ∧
    ((∀ a : α, ¬ s.contains a) ↔ Identity s (emptySet α)) := by
  refine ⟨⟨?_, setExt⟩, fun _ member => member, ⟨?_, ?_⟩⟩
  · intro same a
    cases same
    exact Iff.rfl
  · intro none
    exact setExt fun a => ⟨fun member => none a member, False.elim⟩
  · intro same a member
    cases same
    exact member
-- organon:contract SC-D1 end

theorem emptySetInhabited (α : Type u) :
    Nonempty {s : Set α // ∀ a : α, ¬ s.contains a} :=
  ⟨⟨emptySet α, fun _ member => member⟩⟩

/-- Finite listings with the same members fix one Set, whatever their order or
repetitions. -/
theorem ofListIdentity {α : Type u} (first second : List α)
    (same : ∀ a : α, a ∈ first ↔ a ∈ second) :
    Identity (ofList first) (ofList second) :=
  setExt same

/-! ## Configuration -/

/-- No associations are selected; this does not assert that none obtain. -/
def discrete {α : Type u} {realizes : α → List α → Prop}
    (members : Set α) : Configuration α realizes :=
  ⟨members, emptySet _, fun _ _ impossible => False.elim impossible⟩

theorem configurationExt {α : Type u} {realizes : α → List α → Prop}
    {c d : Configuration α realizes}
    (members : ∀ a, c.members.contains a ↔ d.members.contains a)
    (associations : ∀ r ps,
      c.associations.contains (r, ps) ↔ d.associations.contains (r, ps)) : c = d := by
  have hm := setExt members
  have ha := setExt (fun (p : α × List α) => associations p.1 p.2)
  cases c
  cases d
  cases hm
  cases ha
  rfl

-- organon:contract SC-D2 begin
/-- organon:promotion-contract SC-D2 -/
theorem configurationIdentity {α : Type u} {realizes : α → List α → Prop}
    (c d : Configuration α realizes) :
    (Identity c d ↔
      (∀ a : α, c.members.contains a ↔ d.members.contains a) ∧
      (∀ r ps, c.associations.contains (r, ps) ↔ d.associations.contains (r, ps))) ∧
    (∀ r ps, c.associations.contains (r, ps) →
      realizes r ps ∧ 2 ≤ ps.length ∧
        (c.members.contains r ∨ ∃ a, a ∈ ps ∧ c.members.contains a)) ∧
    (∀ s : Set α, ∃ k : Configuration α realizes,
      Identity k.members s ∧ ∀ r ps, ¬ k.associations.contains (r, ps)) := by
  refine ⟨⟨?_, fun h => configurationExt h.1 h.2⟩, c.valid, ?_⟩
  · intro same
    cases same
    exact ⟨fun _ => Iff.rfl, fun _ _ => Iff.rfl⟩
  · intro s
    exact ⟨discrete s, rfl, fun _ _ impossible => impossible⟩
-- organon:contract SC-D2 end

/-! ## Finite witness carrier

Three plain tokens and a Relation with two ordered participant positions. -/

inductive Token where
  | ring
  | bar
  | spare
  | link
deriving DecidableEq

/-- One realized association; the reversed tuple is not realized. -/
def realizes (r : Token) (ps : List Token) : Prop :=
  r = .link ∧ ps = [.ring, .bar]

def plain : Configuration Token realizes := discrete (ofList [.ring, .bar, .spare])

def linked : Configuration Token realizes where
  members := ofList [.ring, .bar, .spare]
  associations := ofList [(.link, [.ring, .bar])]
  valid := by
    intro r ps selected
    have h : (r, ps) = (Token.link, [Token.ring, Token.bar]) := by
      simpa [ofList] using selected
    cases h
    exact ⟨⟨rfl, rfl⟩, by decide, Or.inr ⟨.ring, by simp, by simp [ofList]⟩⟩

/-- The member is the Relation itself; both participants are external. -/
def external : Configuration Token realizes where
  members := ofList [.link]
  associations := ofList [(.link, [.ring, .bar])]
  valid := by
    intro r ps selected
    have h : (r, ps) = (Token.link, [Token.ring, Token.bar]) := by
      simpa [ofList] using selected
    cases h
    exact ⟨⟨rfl, rfl⟩, by decide, Or.inl (by simp [ofList])⟩

-- organon:contract SC-C1 begin
/-- organon:promotion-contract SC-C1 -/
theorem finiteAntiCollapse :
    (Identity (ofList [Token.ring, Token.bar]) (ofList [Token.bar, Token.ring]) ∧
      ¬ Identity [Token.ring, Token.bar] [Token.bar, Token.ring]) ∧
    Identity (ofList [Token.ring, Token.ring]) (ofList [Token.ring]) ∧
    (Identity plain.members linked.members ∧ ¬ Identity plain linked) ∧
    (linked.associations.contains (.link, [.ring, .bar]) ∧
      ¬ linked.associations.contains (.link, [.bar, .ring])) ∧
    (∀ c : Configuration Token realizes,
      ¬ c.associations.contains (.link, [.bar, .ring])) ∧
    (external.associations.contains (.link, [.ring, .bar]) ∧
      ¬ external.members.contains .ring ∧ ¬ external.members.contains .bar) ∧
    (linked.members.contains .spare ∧
      ∀ r ps, linked.associations.contains (r, ps) → Token.spare ∉ ps) ∧
    (∀ a : Token, ¬ (discrete (realizes := realizes) (emptySet Token)).members.contains a) := by
  refine ⟨⟨?_, ?_⟩, ?_, ⟨rfl, ?_⟩, ?_, ?_, ?_, ?_, ?_⟩
  · exact ofListIdentity _ _ fun a => by cases a <;> simp
  · simp [Identity]
  · exact ofListIdentity _ _ fun a => by simp
  · intro same
    have selected : linked.associations.contains (.link, [.ring, .bar]) := by
      simp [linked, ofList]
    have absent := ((configurationIdentity plain linked).1.mp same).2 .link [.ring, .bar]
    exact (absent.mpr selected : False)
  · simp [linked, ofList]
  · intro c selected
    have h := (c.valid _ _ selected).1.2
    cases h
  · simp [external, ofList]
  · refine ⟨by simp [linked, ofList], ?_⟩
    intro r ps selected
    have h : (r, ps) = (Token.link, [Token.ring, Token.bar]) := by
      simpa [linked, ofList] using selected
    cases h
    simp
  · exact fun _ impossible => impossible
-- organon:contract SC-C1 end

/-- The existing State wrapper retains structure, not just the member Set. -/
theorem structuredStatesDiffer :
    ¬ Identity (State.mk plain) (State.mk linked) := by
  intro same
  exact finiteAntiCollapse.2.2.1.2 (congrArg State.value same)

end DanielOntology.SetConfiguration
