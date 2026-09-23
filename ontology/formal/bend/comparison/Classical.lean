-- Same nonconstructive obligation used in DanielOntology.lean.
theorem absencePresenceExhaustive (A : Type) : (A → False) ∨ Nonempty A := by
  classical
  by_cases h : Nonempty A
  · exact Or.inr h
  · exact Or.inl (fun a => h ⟨a⟩)
#print axioms absencePresenceExhaustive

-- Closer computational counterpart of Bend's Either<A, A -> Empty>.
-- It is explicitly noncomputable; this is not an executable decision procedure.
noncomputable def excludedMiddle (A : Type) : Sum A (A → Empty) := by
  classical
  by_cases h : Nonempty A
  · exact Sum.inl (Classical.choice h)
  · exact Sum.inr (fun a => False.elim (h ⟨a⟩))
