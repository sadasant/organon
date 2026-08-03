import OrganonCore
import OrganonCorePreservation
import OrganonCoreChallenge

/-!
# Daniel's Ontology: Absence/Presence extension

This noncanonical module extends the Absence-free `OrganonCore` reduct with the
local formal shadows of absolute Absence, contrastive Presence, and the
performative mark. It does not change or redefine any core classifier.

An uninhabited type is a shadow inside Lean's already-present metatheory, not
absolute Absence itself. Successful elaboration is external Evidence about this
artifact, not an object-level theorem about the compiler or Reality.
-/

universe u v

namespace DanielOntology

abbrev Absent (α : Type u) : Prop := α → False

abbrev Present (α : Type u) : Prop := Nonempty α

structure TypeEquiv (α : Type u) (β : Type v) where
  toFun : α → β
  invFun : β → α
  leftInv : ∀ a, invFun (toFun a) = a
  rightInv : ∀ b, toFun (invFun b) = b

def absenceElim {α : Type u} (h : Absent α) {β : Sort v} (a : α) : β :=
  False.elim (h a)

def emptyEquiv {α : Type u} {β : Type v}
    (ha : Absent α) (hb : Absent β) : TypeEquiv α β where
  toFun a := False.elim (ha a)
  invFun b := False.elim (hb b)
  leftInv a := False.elim (ha a)
  rightInv b := False.elim (hb b)

theorem absencePresenceExclusive (α : Type u) :
    ¬ (Absent α ∧ Present α) := by
  intro h
  rcases h with ⟨ha, ⟨a⟩⟩
  exact ha a

/-! A3 exhaustiveness explicitly prices the ontology's classical metalanguage. -/
theorem absencePresenceExhaustive (α : Type u) :
    Absent α ∨ Present α := by
  classical
  by_cases h : Nonempty α
  · exact Or.inr h
  · exact Or.inl (fun a => h ⟨a⟩)

def formalAbsenceExtension :
    OrganonCoreReduct.ExtensionSemantics where
  absent := Absent
  present := Present
  exclusive := absencePresenceExclusive
  exhaustive := absencePresenceExhaustive

/-!
The first three binding-seam translations are exact for this formal shadow.
`CorePresence` removes only the contrastive name; `CoreRealityMember` treats
the carrier as the local totality; and an expected value supplies the Presence
witness required by the full Missingness statement.
-/
theorem presenceReductPreserved (α : Type u) :
    Present α ↔ OrganonCoreReduct.CorePresence α := by
  rfl

/-!
This theorem is deliberately named `local`: one Lean carrier is not Organon's
binding Reality as the totality of all Presence. Lean's stratified universes
make the global translation a separate formalization decision.
-/
def FullLocalRealityMember {α : Type u} (_value : α) : Prop := Present α

theorem localRealityReductPreserved {α : Type u} (value : α) :
    FullLocalRealityMember value ↔
      OrganonCoreReduct.CoreRealityMember value := by
  constructor
  · intro _
    trivial
  · intro _
    exact ⟨value⟩

def FullMissingness
    {α : Type u}
    (field : Field α)
    (expected : α) : Prop :=
  Present α ∧ ¬ field.contains expected

theorem missingnessReductPreserved
    {α : Type u}
    (field : Field α)
    (expected : α) :
    FullMissingness field expected ↔
      OrganonCoreReduct.CoreMissingness field expected := by
  constructor
  · exact fun full => full.2
  · exact fun missing => ⟨⟨expected⟩, missing⟩

inductive Mark where
  | drawn

theorem presenceObtains : Present Mark := ⟨Mark.drawn⟩

theorem missingnessIsPresent {α : Type u} (m : Missingness α) :
    Present (Missingness α) :=
  ⟨m⟩

end DanielOntology
