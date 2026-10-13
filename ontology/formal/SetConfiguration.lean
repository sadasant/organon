import OrganonCore

/-!
# Set and Configuration over a declared local domain

`Set α` is a membership predicate on one caller-supplied carrier `α`, read as a
declared local domain of Presence. A Set is fixed by its members: two Sets are
identical exactly when they contain the same members (SC-D1). `Configuration α`
is an abbreviation for `Set α`; it adds no membership condition, no Relation
requirement, and no closure under the participants of contained Relations
(SC-D2). Finite witnesses separate Sets from ordered or repeated listings and
show that a Configuration may contain a relation-like token without containing
its participants (SC-C1).

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
* Membership and Relation. Nothing here claims or refutes that membership can
  be modeled as a Relation. Relation-like tokens in the witness carry a
  designated participant list; they are not a canonical Relation classifier.
* Reduction. `Configuration` is definitionally `Set`. The retained role name and
  any identifier consolidation are open review questions (SC-G1), not a
  formal distinction.
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

/-- A Configuration is a Set of carrier values, which may stand for Presences
and Relations considered together. It adds no further condition. -/
abbrev Configuration (α : Type u) := Set α

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

-- organon:contract SC-D2 begin
/-- organon:promotion-contract SC-D2 -/
theorem configurationReduction {α : Type u} (c d : Configuration α) :
    Configuration α = Set α ∧
    (Identity c d ↔ ∀ a : α, (c.contains a ↔ d.contains a)) ∧
    (∀ s : Set α, ∃ k : Configuration α, Identity k s) ∧
    Nonempty {k : Configuration α // ∀ a : α, ¬ k.contains a} :=
  ⟨rfl, (setExtensionality c d).1, fun s => ⟨s, rfl⟩, emptySetInhabited α⟩
-- organon:contract SC-D2 end

/-! ## Finite witness carrier

Two plain tokens and one relation-like token whose designated participants are
the two plain tokens. -/

inductive Token where
  | ring
  | bar
  | link
deriving DecidableEq

/-- Designated participants of a relation-like token; plain tokens have none.
This is witness data, not a canonical Relation classifier. -/
def participants : Token → List Token
  | .link => [.ring, .bar]
  | _ => []

abbrev emptyConfiguration : Configuration Token := ofList []
abbrev ringOnly : Configuration Token := ofList [.ring]
abbrev linkOnly : Configuration Token := ofList [.link]

-- organon:contract SC-C1 begin
/-- organon:promotion-contract SC-C1 -/
theorem finiteAntiCollapse :
    (Identity (ofList [Token.ring, Token.bar]) (ofList [Token.bar, Token.ring]) ∧
      ¬ Identity [Token.ring, Token.bar] [Token.bar, Token.ring]) ∧
    (Identity (ofList [Token.ring, Token.ring]) ringOnly ∧
      ¬ Identity [Token.ring, Token.ring] [Token.ring]) ∧
    ((∀ a : Token, ¬ emptyConfiguration.contains a) ∧
      Identity emptyConfiguration (emptySet Token) ∧
      ¬ Identity emptyConfiguration ringOnly) ∧
    (∀ a : Token, ringOnly.contains a → participants a = []) ∧
    ((linkOnly : Configuration Token).contains Token.link ∧ Token.ring ∈ participants Token.link ∧
      ¬ linkOnly.contains Token.ring ∧ ¬ linkOnly.contains Token.bar) := by
  have emptyNone : ∀ a : Token, ¬ emptyConfiguration.contains a := by
    intro a member
    cases member
  refine ⟨⟨?_, ?_⟩, ⟨?_, ?_⟩, ⟨emptyNone, ?_, ?_⟩, ?_, ?_⟩
  · exact ofListIdentity _ _ fun a => by cases a <;> simp
  · simp [Identity]
  · exact ofListIdentity _ _ fun a => by cases a <;> simp
  · simp [Identity]
  · exact ((setExtensionality emptyConfiguration (emptySet Token)).2.2).mp emptyNone
  · intro same
    have ringIn : ringOnly.contains Token.ring := by simp [ringOnly, ofList]
    exact emptyNone Token.ring
      (((setExtensionality emptyConfiguration ringOnly).1.mp same Token.ring).mpr ringIn)
  · intro a member
    cases a <;> simp_all [ringOnly, ofList, participants]
  · simp [linkOnly, ofList, participants]

/-! ## Contract use on the witness -/

/-- A Configuration containing a relation-like token is not thereby closed
under that token's participants. -/
example : ∃ k : Configuration Token, ∃ r : Token,
    k.contains r ∧ ∃ p, p ∈ participants r ∧ ¬ k.contains p :=
  ⟨linkOnly, .link, finiteAntiCollapse.2.2.2.2.1, .ring,
    finiteAntiCollapse.2.2.2.2.2.1, finiteAntiCollapse.2.2.2.2.2.2.1⟩

end DanielOntology.SetConfiguration
