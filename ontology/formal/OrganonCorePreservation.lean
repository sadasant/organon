import OrganonCore

/-!
# Classification preservation under Absence extensions

An `OrganonCore` classifier is a predicate over core data. An Absence extension
may add arbitrary interpretation data, but the lifted classifier deliberately
cannot inspect it. The preservation theorem is definitional because the reduct
and extension share the same core declarations rather than maintaining copied
definitions that could drift.

This proves conservativity for classifiers encoded against `OrganonCore`. It
does not prove that every binding prose definition has such an encoding.
-/

universe u v

namespace DanielOntology.OrganonCoreReduct

abbrev Classifier (α : Type u) := α → Prop

structure ExtensionSemantics where
  absent : Type v → Prop
  present : Type v → Prop
  exclusive : ∀ α, ¬ (absent α ∧ present α)
  exhaustive : ∀ α, absent α ∨ present α

def evaluate
    {α : Type u}
    (classifier : Classifier α)
    (_extension : ExtensionSemantics)
    (value : α) : Prop :=
  classifier value

def evaluateReduct
    {α : Type u}
    (classifier : Classifier α)
    (value : α) : Prop :=
  classifier value

theorem reductToExtensionPreserved
    {α : Type u}
    (classifier : Classifier α)
    (extension : ExtensionSemantics)
    (value : α) :
    evaluateReduct classifier value ↔ evaluate classifier extension value := by
  rfl

theorem classificationPreserved
    {α : Type u}
    (classifier : Classifier α)
    (left right : ExtensionSemantics)
    (value : α) :
    evaluate classifier left value ↔ evaluate classifier right value := by
  rfl

theorem classificationPreservedForAllValues
    {α : Type u}
    (classifier : Classifier α)
    (left right : ExtensionSemantics) :
    (∀ value, evaluate classifier left value) ↔
      (∀ value, evaluate classifier right value) := by
  rfl

end DanielOntology.OrganonCoreReduct
