def reuse {A B : Type} (h : A → B) (x : A) : B × B := (h x, h x)
theorem reuseProof {A B : Prop} (h : A → B) (x : A) : B ∧ B := ⟨h x, h x⟩
