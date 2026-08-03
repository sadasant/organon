import OrganonCore
import OrganonCorePreservation

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

inductive Mark where
  | drawn

theorem presenceObtains : Present Mark := ⟨Mark.drawn⟩

theorem missingnessIsPresent {α : Type u} (m : Missingness α) :
    Present (Missingness α) :=
  ⟨m⟩

end DanielOntology
