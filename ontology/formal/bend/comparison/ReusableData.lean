def reuse {A B : Type} (h : A → B) (x : A) : B × B :=
  let y := h x
  (y, y)
