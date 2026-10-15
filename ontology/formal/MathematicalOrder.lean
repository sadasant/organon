import SetConfiguration

/-!
# Mathematical Order over a declared member Set

`MemberOrder α` is a partial Order (non-strict, reflexive on members) carried by
an explicit binary `relation` on a supplied carrier `α` together with a declared
member `Set α` from `SetConfiguration`. The relation only holds between members,
is reflexive on members, antisymmetric, and transitive. Its strict part
`MemberOrder.strict` is the relation together with Difference; it is
irreflexive, asymmetric, and transitive, and for member inputs the relation is
recovered as strict-or-Identity (MO-D1). Conversely, every member-bounded
irreflexive transitive relation is exactly the strict part of some
`MemberOrder` on the same member Set (MO-D1). Total comparability is the
separate property `MemberOrder.Total`; it is never assumed. Finite countermodels
(MO-C1) give a non-total partial order with a real strict chain and an
incomparable member, a directed 3-cycle that satisfies core `Direction`
asymmetry but is not transitive and so is not the strict part of any
`MemberOrder`, and the empty member Set.

Boundaries:

* Name. `MemberOrder` is the generic mathematical structure. It is unrelated to
  the institutional Order shadows elsewhere in the spike (`DesignationOrder`,
  the `Order` index of Standing, Recognition, Permission, and Rule joins), which
  are not ordering relations and are neither replaced nor reinterpreted here.
  It also avoids Lean's root `PartialOrder` class, which is not used.
* Carrier. Every theorem is relative to a supplied carrier `α` and a supplied
  member Set. Carrier values outside the member Set are allowed and are never
  related. Nothing here constructs an ordering of all Presence or identifies a
  local order with Reality, time, causation, or rank.
* Interpretation. `relation` and the member predicate are supplied by whoever
  builds the order. No canonical classifier decides which actual Presences are
  members or which of them precede, contain, or outrank others. Adequacy of an
  interpretation remains an application gate.
* Direction. Core `Direction` only requires asymmetry of `before`. MO-C1 shows
  that this is strictly weaker than being the strict part of an order:
  Direction is not itself an order, and no transitivity is added to it here.
* Totality. A chain (total order) is a `MemberOrder` with a separately proved
  `Total`. A partial order may have incomparable members.
* Empty domain. The empty member Set, on any carrier including `Empty`, carries
  an order; this is a Presence with no member, not Absence. No Absence symbol is
  imported.
* Logic. Recovering the non-strict relation as strict-or-Identity uses
  `Classical.em` on Identity of the two inputs; this is the declared classical
  commitment. No `sorry` and no project axiom is used. The finite witnesses
  derive `DecidableEq` only for their own comparisons.

Local contracts MO-D1 and MO-C1 feed the schema-v2 OC contracts in
`OrderConfigurationContracts.lean`. A marked statement runs from its marker
to the first `:=`.
-/

universe u

namespace DanielOntology.MathematicalOrder

open DanielOntology
open DanielOntology.SetConfiguration

/-! ## Partial Order over a declared member Set -/

/-- A partial Order over the declared member Set `members`, given by an explicit
binary `relation` on the carrier `α`. -/
structure MemberOrder (α : Type u) where
  members : Set α
  relation : α → α → Prop
  bounded : ∀ a b, relation a b → members.contains a ∧ members.contains b
  reflexive : ∀ a, members.contains a → relation a a
  antisymmetric : ∀ a b, relation a b → relation b a → Identity a b
  transitive : ∀ a b c, relation a b → relation b c → relation a c

namespace MemberOrder

variable {α : Type u}

/-- The strict part: the relation together with Difference of the endpoints. -/
def strict (o : MemberOrder α) (a b : α) : Prop :=
  o.relation a b ∧ Difference a b

/-- Total comparability of members. A separate property, never a field. -/
def Total (o : MemberOrder α) : Prop :=
  ∀ a b, o.members.contains a → o.members.contains b →
    o.relation a b ∨ o.relation b a

/-- Two members are incomparable when neither is related to the other. -/
def Incomparable (o : MemberOrder α) (a b : α) : Prop :=
  o.members.contains a ∧ o.members.contains b ∧
    ¬ o.relation a b ∧ ¬ o.relation b a

theorem strictBounded (o : MemberOrder α) {a b : α} (h : o.strict a b) :
    o.members.contains a ∧ o.members.contains b :=
  o.bounded a b h.1

theorem strictIrreflexive (o : MemberOrder α) (a : α) : ¬ o.strict a a :=
  fun h => h.2 rfl

theorem strictAsymmetric (o : MemberOrder α) {a b : α}
    (h : o.strict a b) : ¬ o.strict b a :=
  fun h' => h.2 (o.antisymmetric a b h.1 h'.1)

theorem strictTransitive (o : MemberOrder α) {a b c : α}
    (hab : o.strict a b) (hbc : o.strict b c) : o.strict a c := by
  refine ⟨o.transitive a b c hab.1 hbc.1, ?_⟩
  intro same
  cases same
  exact hbc.2 (o.antisymmetric b a hbc.1 hab.1)

/-- For member inputs, the relation is strict-or-Identity (uses `Classical.em`). -/
theorem relationIffStrictOrIdentity (o : MemberOrder α) {a b : α}
    (ha : o.members.contains a) (_hb : o.members.contains b) :
    o.relation a b ↔ o.strict a b ∨ Identity a b := by
  constructor
  · intro h
    rcases Classical.em (Identity a b) with same | differs
    · exact Or.inr same
    · exact Or.inl ⟨h, differs⟩
  · rintro (h | same)
    · exact h.1
    · cases same
      exact o.reflexive a ha

/-- Total comparability is equivalent to strict trichotomy on members. -/
theorem totalIffTrichotomy (o : MemberOrder α) :
    o.Total ↔ ∀ a b, o.members.contains a → o.members.contains b →
      o.strict a b ∨ Identity a b ∨ o.strict b a := by
  constructor
  · intro total a b ha hb
    rcases total a b ha hb with h | h
    · rcases (o.relationIffStrictOrIdentity ha hb).mp h with s | e
      · exact Or.inl s
      · exact Or.inr (Or.inl e)
    · rcases (o.relationIffStrictOrIdentity hb ha).mp h with s | e
      · exact Or.inr (Or.inr s)
      · exact Or.inr (Or.inl e.symm)
  · intro tri a b ha hb
    rcases tri a b ha hb with s | e | s
    · exact Or.inl s.1
    · cases e
      exact Or.inl (o.reflexive a ha)
    · exact Or.inr s.1

end MemberOrder

/-! ## From a strict relation to an order -/

/-- The reflexive closure on members of a member-bounded strict relation. -/
def ofStrict {α : Type u} (members : Set α) (lt : α → α → Prop)
    (ltBounded : ∀ a b, lt a b → members.contains a ∧ members.contains b)
    (ltIrreflexive : ∀ a, ¬ lt a a)
    (ltTransitive : ∀ a b c, lt a b → lt b c → lt a c) : MemberOrder α where
  members := members
  relation a b := lt a b ∨ (Identity a b ∧ members.contains a)
  bounded := by
    rintro a b (h | ⟨same, ha⟩)
    · exact ltBounded a b h
    · cases same
      exact ⟨ha, ha⟩
  reflexive a ha := Or.inr ⟨rfl, ha⟩
  antisymmetric := by
    rintro a b (hab | ⟨same, _⟩) hba
    · rcases hba with hba | ⟨same, _⟩
      · exact (ltIrreflexive a (ltTransitive a b a hab hba)).elim
      · exact same.symm
    · exact same
  transitive := by
    rintro a b c (hab | ⟨same, ha⟩) hbc
    · rcases hbc with hbc | ⟨same', _⟩
      · exact Or.inl (ltTransitive a b c hab hbc)
      · cases same'
        exact Or.inl hab
    · cases same
      exact hbc

theorem ofStrictStrict {α : Type u} (members : Set α) (lt : α → α → Prop)
    (ltBounded : ∀ a b, lt a b → members.contains a ∧ members.contains b)
    (ltIrreflexive : ∀ a, ¬ lt a a)
    (ltTransitive : ∀ a b c, lt a b → lt b c → lt a c) (a b : α) :
    (ofStrict members lt ltBounded ltIrreflexive ltTransitive).strict a b ↔ lt a b := by
  constructor
  · rintro ⟨h | ⟨same, _⟩, differs⟩
    · exact h
    · exact (differs same).elim
  · intro h
    refine ⟨Or.inl h, ?_⟩
    intro same
    cases same
    exact ltIrreflexive a h

-- organon:contract MO-D1 begin
/-- organon:promotion-contract MO-D1 -/
theorem orderStrictLaws {α : Type u} :
    (∀ o : MemberOrder α,
      (∀ a b, o.strict a b → o.members.contains a ∧ o.members.contains b) ∧
      (∀ a, ¬ o.strict a a) ∧
      (∀ a b, o.strict a b → ¬ o.strict b a) ∧
      (∀ a b c, o.strict a b → o.strict b c → o.strict a c) ∧
      (∀ a b, o.members.contains a → o.members.contains b →
        (o.relation a b ↔ o.strict a b ∨ Identity a b)) ∧
      (o.Total ↔ ∀ a b, o.members.contains a → o.members.contains b →
        o.strict a b ∨ Identity a b ∨ o.strict b a)) ∧
    (∀ (members : Set α) (lt : α → α → Prop),
      (∀ a b, lt a b → members.contains a ∧ members.contains b) →
      (∀ a, ¬ lt a a) →
      (∀ a b c, lt a b → lt b c → lt a c) →
      ∃ o : MemberOrder α, Identity o.members members ∧
        ∀ a b, (o.strict a b ↔ lt a b)) := by
  refine ⟨fun o => ⟨fun _ _ h => o.strictBounded h, o.strictIrreflexive,
    fun _ _ h => o.strictAsymmetric h, fun _ _ _ h h' => o.strictTransitive h h',
    fun _ _ ha hb => o.relationIffStrictOrIdentity ha hb, o.totalIffTrichotomy⟩, ?_⟩
  intro members lt hb hi ht
  exact ⟨ofStrict members lt hb hi ht, rfl, ofStrictStrict members lt hb hi ht⟩
-- organon:contract MO-D1 end

/-! ## Finite witnesses -/

/-- Four member tokens and one carrier value outside the member Set. -/
inductive Mark where
  | bottom
  | middle
  | top
  | side
  | outside
deriving DecidableEq

/-- The member Set; `outside` is in the carrier but not a member. -/
def markMembers : Set Mark := ofList [.bottom, .middle, .top, .side]

/-- Strict chain bottom < middle < top (with its transitive edge); `side` is
related to nothing but itself. -/
def markLt : Mark → Mark → Prop
  | .bottom, .middle => True
  | .middle, .top => True
  | .bottom, .top => True
  | _, _ => False

def chainWithSide : MemberOrder Mark :=
  ofStrict markMembers markLt
    (by intro a b h; cases a <;> cases b <;> simp_all [markLt, markMembers, ofList])
    (by intro a h; cases a <;> exact h)
    (by intro a b c h h'; cases a <;> cases b <;> cases c <;> simp_all [markLt])

/-- Three positions of a directed cycle. -/
inductive Turn where
  | first
  | second
  | third
deriving DecidableEq

def turnStep : Turn → Turn → Prop
  | .first, .second => True
  | .second, .third => True
  | .third, .first => True
  | _, _ => False

/-- A core Direction whose `before` is the directed 3-cycle. -/
def cycleDirection : Direction Turn where
  before s t := turnStep s.value t.value
  asymmetric := by
    intro s t h h'
    rcases s with ⟨s⟩
    rcases t with ⟨t⟩
    cases s <;> cases t <;> simp_all [turnStep]

/-- The empty member Set with the empty relation, on any carrier. -/
def emptyOrder (α : Type u) : MemberOrder α where
  members := emptySet α
  relation _ _ := False
  bounded _ _ h := h.elim
  reflexive _ h := h.elim
  antisymmetric _ _ h := h.elim
  transitive _ _ _ h := h.elim

-- organon:contract MO-C1 begin
/-- organon:promotion-contract MO-C1 -/
theorem finiteOrderCountermodels :
    (chainWithSide.strict .bottom .middle ∧ chainWithSide.strict .middle .top ∧
      chainWithSide.strict .bottom .top ∧ ¬ chainWithSide.strict .top .bottom ∧
      chainWithSide.Incomparable .side .middle ∧ ¬ chainWithSide.Total ∧
      ¬ chainWithSide.members.contains .outside ∧
      ¬ chainWithSide.relation .outside .outside) ∧
    (cycleDirection.before ⟨.first⟩ ⟨.second⟩ ∧
      cycleDirection.before ⟨.second⟩ ⟨.third⟩ ∧
      ¬ cycleDirection.before ⟨.first⟩ ⟨.third⟩ ∧
      ¬ ∃ o : MemberOrder (State Turn),
        ∀ s t, (o.strict s t ↔ cycleDirection.before s t)) ∧
    ((∀ a : Empty, ¬ (emptyOrder Empty).members.contains a) ∧
      (emptyOrder Empty).Total ∧
      ∀ α : Type u, ∀ a b : α,
        ¬ (emptyOrder α).members.contains a ∧ ¬ (emptyOrder α).relation a b) := by
  refine ⟨⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩, ⟨trivial, trivial, id, ?_⟩, ?_⟩
  · exact (ofStrictStrict _ _ _ _ _ _ _).mpr trivial
  · exact (ofStrictStrict _ _ _ _ _ _ _).mpr trivial
  · exact (ofStrictStrict _ _ _ _ _ _ _).mpr trivial
  · intro h
    exact ((ofStrictStrict _ _ _ _ _ _ _).mp h : False)
  · refine ⟨by simp [chainWithSide, ofStrict, markMembers, ofList],
      by simp [chainWithSide, ofStrict, markMembers, ofList], ?_, ?_⟩ <;>
      simp [chainWithSide, ofStrict, markLt, Identity]
  · intro total
    have side : chainWithSide.members.contains .side := by
      simp [chainWithSide, ofStrict, markMembers, ofList]
    have middle : chainWithSide.members.contains .middle := by
      simp [chainWithSide, ofStrict, markMembers, ofList]
    rcases total .side .middle side middle with h | h <;>
      simp [chainWithSide, ofStrict, markLt, Identity] at h
  · simp [chainWithSide, ofStrict, markMembers, ofList]
  · simp [chainWithSide, ofStrict, markLt, markMembers, ofList]
  · rintro ⟨o, exact⟩
    have h12 := (exact ⟨.first⟩ ⟨.second⟩).mpr trivial
    have h23 := (exact ⟨.second⟩ ⟨.third⟩).mpr trivial
    exact ((exact ⟨.first⟩ ⟨.third⟩).mp (o.strictTransitive h12 h23) : False)
  · refine ⟨fun a => a.elim, fun a => a.elim, fun _ _ _ => ⟨id, id⟩⟩
-- organon:contract MO-C1 end

end DanielOntology.MathematicalOrder
