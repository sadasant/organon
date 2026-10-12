import OrganonCore

/-!
# Bounded tests for criterion-governed Care (D118)

The Specification is the existing formal type. Responses, operations, and
outcomes are supplied projections. These tests do not construct canonical
Attention, Entity identity, Action, Consequence, or Causal Contribution, nor
join a Specification's target to an attended Entity. They test the operative
criterion distinction, not complete Care, benefit, harm, or conscious goals.
-/

namespace DanielOntology.CareRevision

def responsive {Response Outcome Operation : Type}
    (select : Response → Specification Outcome → Operation)
    (response : Response) (spec : Specification Outcome) : Prop :=
  (∃ contrast, select response spec ≠ select contrast spec) ∧
  (∃ alternative, select response spec ≠ select response alternative)

def criterion (required : Bool) : Specification Bool where
  scope := ⟨fun _ => True⟩
  conforms := fun result => result = required
  decideConformity := fun result => decide (result = required)
  conformityCorrect := by intro result; simp
  conformityWithinScope := fun _ _ => trivial

def effect (condition operation : Bool) : Bool := Bool.xor condition operation

def selectOperation (represented : Bool) (spec : Specification Bool) : Bool :=
  Bool.xor represented (!spec.decideConformity false)

-- Opposite criteria can govern the same responsive mechanism. Neither criterion
-- is labeled intrinsically good; success here is relative to the supplied model.
theorem oppositeCriteriaSameMechanism (condition required : Bool) :
    (criterion required).conforms
      (effect condition (selectOperation condition (criterion required))) := by
  cases condition <;> cases required <;> rfl

theorem bothInputsConditionOperation (represented required : Bool) :
    responsive selectOperation represented (criterion required) := by
  refine ⟨⟨!represented, ?_⟩, ⟨criterion (!required), ?_⟩⟩ <;>
    cases represented <;> cases required <;> decide

-- The same responsive operation succeeds in the represented condition but fails
-- in the actual supplied condition. Successful conformity is not constitutive.
theorem mistakenConditionCanDefeatCriterion :
    responsive selectOperation false (criterion false) ∧
    (criterion false).conforms (effect false (selectOperation false (criterion false))) ∧
    ¬ (criterion false).conforms (effect true (selectOperation false (criterion false))) := by
  refine ⟨bothInputsConditionOperation false false, rfl, ?_⟩
  change ¬ (true = false)
  decide

theorem ignoredCriterionIsInsufficient (represented : Bool) (spec : Specification Bool) :
    ¬ responsive (fun response _ => response) represented spec := by
  rintro ⟨_, alternative, differs⟩
  exact differs rfl

-- Meeting the criterion by a state-insensitive policy supplies no response join.
theorem successAloneIsInsufficient :
    (criterion false).conforms (effect false false) ∧
    ¬ responsive (fun (_ : Bool) spec => !spec.decideConformity false)
      false (criterion false) := by
  refine ⟨rfl, ?_⟩
  rintro ⟨⟨contrast, differs⟩, _⟩
  exact differs rfl

end DanielOntology.CareRevision
