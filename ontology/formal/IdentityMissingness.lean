import OrganonCore

/-!
# Identity, Difference, and specified-target Missingness

`Identity a b` is logical equality `a = b` within one carrier `α`, and
`Difference a b` is `¬ Identity a b`. This module fixes their contracts and
shows that the existing `Missingness` field, `¬ field.contains expected`, is
exactly the noncontainment of any item identical to the expected one.
`conditionMissing` covers explicitly supplied target conditions; the existing
point-target record is its equality-predicate special case, not its full range.

Boundaries:

* Carrier. Every theorem is relative to a caller-chosen local carrier `α`,
  read as a range of Presence. Lean equality on that carrier is the whole of
  Identity here; no claim is made about Reality as a whole, about empirical
  identification, or about any identity criterion beyond the chosen carrier.
* Expectation assignment. A `Field` carries only containment. The specified
  expected Presence or predicate is supplied separately; neither the record
  nor `conditionMissing` proves actual representation or expectation. An empty
  field fixes no expectation. A condition need not be inhabited or decidable;
  its specification does not instantiate a fictional referent.
* Decidability. The partition of Identity and Difference uses classical
  excluded middle. No `Decidable` instance for `Identity` is provided or
  implied; the witness carrier derives `DecidableEq` only for its own proofs.
* Models. The witnesses use a small `Token` carrier. They do not presuppose
  a canonically complete `Entity` or `Representation` model; `appearance` is a
  plain field, not a theory of representation.

Contracts IM-D1, IM-D2, IM-A5, IM-A6, IM-C1, and IM-C2 are marked for the schema-v2
manifest. The marked statement runs from the marker to the first `:=`.
-/

universe u

namespace DanielOntology.IdentityMissingness

open DanielOntology

/-! ## Identity -/

-- organon:contract IM-D1 begin
/-- organon:promotion-contract IM-D1 -/
theorem identityIffEq {α : Type u} (a b : α) :
    Identity a b ↔ a = b :=
  Iff.rfl
-- organon:contract IM-D1 end

theorem identityRefl {α : Type u} (a : α) : Identity a a := rfl

theorem identitySymm {α : Type u} {a b : α} (h : Identity a b) : Identity b a :=
  Eq.symm h

theorem identityTrans {α : Type u} {a b c : α}
    (hab : Identity a b) (hbc : Identity b c) : Identity a c :=
  Eq.trans hab hbc

/-- Substitution: every predicate on the carrier transfers along Identity. -/
theorem identitySubst {α : Type u} (motive : α → Prop) {a b : α}
    (h : Identity a b) (ha : motive a) : motive b :=
  h ▸ ha

/-! ## Difference -/

-- organon:contract IM-D2 begin
/-- organon:promotion-contract IM-D2 -/
theorem differencePartition {α : Type u} (a b : α) :
    (Difference a b ↔ ¬ Identity a b) ∧
    (Identity a b ∨ Difference a b) ∧
    ¬ (Identity a b ∧ Difference a b) :=
  ⟨Iff.rfl, Classical.em (Identity a b), fun ⟨same, differs⟩ => differs same⟩
-- organon:contract IM-D2 end

theorem differenceSymm {α : Type u} {a b : α} (h : Difference a b) :
    Difference b a :=
  fun same => h (identitySymm same)

theorem differenceIrrefl {α : Type u} (a : α) : ¬ Difference a a :=
  fun differs => differs (identityRefl a)

/-! ## Missingness as exact-target noncontainment -/

-- organon:contract IM-A5 begin
/-- organon:promotion-contract IM-A5 -/
theorem missingnessExactTarget {α : Type u} (field : Field α) (expected : α) :
    (¬ field.contains expected ↔
      ¬ ∃ actual, field.contains actual ∧ Identity actual expected) ∧
    (Nonempty {m : Missingness α // m.field = field ∧ m.expected = expected} ↔
      ¬ ∃ actual, field.contains actual ∧ Identity actual expected) := by
  have core : ¬ field.contains expected ↔
      ¬ ∃ actual, field.contains actual ∧ Identity actual expected :=
    ⟨fun missing ⟨actual, contained, same⟩ => missing (same ▸ contained),
      fun none contained => none ⟨expected, contained, identityRefl expected⟩⟩
  refine ⟨core, ⟨?_, ?_⟩⟩
  · rintro ⟨m, rfl, rfl⟩
    exact core.mp m.missing
  · intro none
    exact ⟨⟨⟨field, expected, core.mpr none⟩, rfl, rfl⟩⟩
-- organon:contract IM-A5 end

/-- Every item a missing field does contain differs from the expected one. -/
theorem containedDiffersFromExpected {α : Type u} (m : Missingness α)
    {actual : α} (contained : m.field.contains actual) :
    Difference actual m.expected :=
  fun same => m.missing (same ▸ contained)

/-! ## Explicit target conditions -/

/-- Noncontainment for a supplied condition, conditional on separately justified
representation or expectation. It does not infer that assignment. -/
def conditionMissing {α : Type u} (field : Field α) (qualifies : α → Prop) : Prop :=
  ¬ ∃ actual, field.contains actual ∧ qualifies actual

-- organon:contract IM-A6 begin
/-- organon:promotion-contract IM-A6 -/
theorem missingnessCondition {α : Type u} (field : Field α)
    (qualifies : α → Prop) (expected : α) :
    (conditionMissing field qualifies ↔
      ∀ actual, field.contains actual → ¬ qualifies actual) ∧
    (conditionMissing field (fun actual => Identity actual expected) ↔
      Nonempty {m : Missingness α // m.field = field ∧ m.expected = expected}) := by
  refine ⟨⟨?_, ?_⟩, (missingnessExactTarget field expected).2.symm⟩
  · intro missing actual contained qualifiesProof
    exact missing ⟨actual, contained, qualifiesProof⟩
  · intro missing ⟨actual, contained, qualifiesProof⟩
    exact missing actual contained qualifiesProof
-- organon:contract IM-A6 end

/-! ## Witness carrier

Two tokens share one appearance yet are distinct. Fields are list-backed, so
containment ignores order while list configurations do not. -/

inductive Appearance where
  | ring
  | bar
deriving DecidableEq

structure Token where
  appearance : Appearance
  serial : Fin 2
deriving DecidableEq

def targetToken : Token := ⟨.ring, 0⟩
def lookalikeToken : Token := ⟨.ring, 1⟩

abbrev listField (items : List Token) : Field Token := ⟨fun item => item ∈ items⟩

abbrev emptyField : Field Token := listField []
abbrev lookalikeField : Field Token := listField [lookalikeToken]
abbrev targetField : Field Token := listField [targetToken]

def lookalikeMissing : Missingness Token where
  field := lookalikeField
  expected := targetToken
  missing := by decide

def emptyMissingTarget : Missingness Token where
  field := emptyField
  expected := targetToken
  missing := by decide

def emptyMissingLookalike : Missingness Token where
  field := emptyField
  expected := lookalikeToken
  missing := by decide

-- organon:contract IM-C1 begin
/-- organon:promotion-contract IM-C1 -/
theorem witnessedAntiCollapse :
    (targetToken.appearance = lookalikeToken.appearance ∧
      Difference targetToken lookalikeToken) ∧
    ((∃ actual, lookalikeField.contains actual) ∧
      Nonempty {m : Missingness Token //
        m.field = lookalikeField ∧ m.expected = targetToken}) ∧
    ¬ Nonempty {m : Missingness Token //
        m.field = targetField ∧ m.expected = targetToken} ∧
    ¬ Nonempty {m : Missingness Token //
        m.field = lookalikeField ∧ m.expected = lookalikeToken} ∧
    (emptyMissingTarget.field = emptyMissingLookalike.field ∧
      Difference emptyMissingTarget.expected emptyMissingLookalike.expected) ∧
    ((∀ item, item ∈ [targetToken, lookalikeToken] ↔
        item ∈ [lookalikeToken, targetToken]) ∧
      Difference [targetToken, lookalikeToken] [lookalikeToken, targetToken] ∧
      Difference (targetToken, lookalikeToken) (lookalikeToken, targetToken)) := by
  have distinct : Difference targetToken lookalikeToken := by
    simp [Difference, Identity, targetToken, lookalikeToken]
  have present (field : Field Token) (expected : Token)
      (contained : field.contains expected) :
      ¬ Nonempty {m : Missingness Token //
        m.field = field ∧ m.expected = expected} := fun witness =>
    ((missingnessExactTarget field expected).2.mp witness)
      ⟨expected, contained, identityRefl expected⟩
  refine ⟨⟨rfl, distinct⟩, ⟨⟨lookalikeToken, by decide⟩,
    ⟨⟨lookalikeMissing, rfl, rfl⟩⟩⟩, present _ _ (by decide),
    present _ _ (by decide), ⟨rfl, distinct⟩, ⟨?_, ?_, ?_⟩⟩
  · intro item
    simp [or_comm]
  · intro same
    exact distinct (List.cons.inj same).1
  · intro same
    exact distinct (Prod.mk.inj same).1

-- organon:contract IM-C2 begin
/-- organon:promotion-contract IM-C2 -/
theorem conditionAntiCollapse :
    conditionMissing lookalikeField (fun actual => Identity actual targetToken) ∧
    ¬ conditionMissing lookalikeField (fun actual => actual.appearance = .ring) ∧
    conditionMissing lookalikeField (fun actual => actual.appearance = .bar) ∧
    conditionMissing (listField [⟨.bar, 0⟩]) (fun actual => actual.appearance = .ring) ∧
    conditionMissing emptyField (fun actual => actual.appearance = .ring) ∧
    ¬ conditionMissing targetField (fun actual => Identity actual targetToken) := by
  simp [conditionMissing, Identity, targetToken, lookalikeToken]
-- organon:contract IM-C2 end

/-! ## Contract use on the witness

The general contracts specialize to the witness without extra assumptions. -/

example : Difference lookalikeToken lookalikeMissing.expected :=
  containedDiffersFromExpected lookalikeMissing
    (show lookalikeToken ∈ [lookalikeToken] by decide)

example : Difference lookalikeToken targetToken :=
  differenceSymm (witnessedAntiCollapse.1.2)

/-- Difference is not transitive, even on the same finite carrier. -/
theorem differenceNotTransitive :
    Difference targetToken lookalikeToken ∧
    Difference lookalikeToken targetToken ∧
    ¬ Difference targetToken targetToken :=
  ⟨witnessedAntiCollapse.1.2, differenceSymm witnessedAntiCollapse.1.2,
    differenceIrrefl targetToken⟩

/-- In the existing non-singleton Entity shadow, one Entity's history contains
unequal States preserving the same Invariant. This does not choose a canonical
empirical individuation criterion or require every prose history to be plural. -/
theorem entityHistoryContainsDifference {Carrier : Type u} (entity : Entity Carrier) :
    ∃ first second,
      first ∈ entity.persistence.states ∧ second ∈ entity.persistence.states ∧
      entity.identity.holds first ∧ entity.identity.holds second ∧
      Difference first second := by
  rcases entity.persistence.hasTransition with ⟨first, second, rest, history⟩
  have ordered : entity.persistenceDirection.before first second := by
    have full := entity.persistence.ordered
    rw [history] at full
    exact full.1
  have firstIn : first ∈ entity.persistence.states := by simp [history]
  have secondIn : second ∈ entity.persistence.states := by simp [history]
  refine ⟨first, second, firstIn, secondIn,
    entityIdentityPersists entity first firstIn,
    entityIdentityPersists entity second secondIn, ?_⟩
  intro same
  change first = second at same
  subst second
  exact entity.persistenceDirection.asymmetric ordered ordered

end DanielOntology.IdentityMissingness
