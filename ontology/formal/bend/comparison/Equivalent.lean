-- Same constructive and decidable fragment as Equivalent.bend, no Std import.
def absencePresenceExclusive {A : Type} (absent : A → False) (present : A) : False :=
  absent present

def missing : Bool → Bool
  | true => false
  | false => true

theorem missingPresent : missing true = false := rfl
theorem missingAbsent : missing false = true := rfl

def evaluate {A : Type} (classifier : A → Bool) (_extension : Bool) (value : A) : Bool :=
  classifier value

theorem classificationPreserved {A : Type} (classifier : A → Bool)
    (left right : Bool) (value : A) :
    evaluate classifier left value = evaluate classifier right value := rfl
