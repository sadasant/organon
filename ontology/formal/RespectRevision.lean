import OrganonCore

/-!
# Bounded tests for condition-governed Respect (D119)

This is an admission projection, not a complete Respect instance. Participant,
operation, expressed conditions, and contextual interpretations are supplied.
It does not construct Entity identity, canonical Action or Interpretation,
the origin/accuracy of a condition, consent, or causal regulation of behavior.
An admitted operation alone therefore does not establish canonical Respect.
-/

namespace DanielOntology.RespectRevision

def admitted {Participant Operation : Type}
    (expressed : Participant → Operation → Option Bool)
    (contextual : Participant → Participant → Operation → Bool)
    (scope : Scope Operation) (actor target : Participant) (operation : Operation) : Prop :=
  scope.includes operation ∧
    (expressed target operation).getD (contextual actor target operation) = true

theorem expressedOverridesDefault {Participant Operation : Type}
    (expressed : Participant → Operation → Option Bool)
    (contextual : Participant → Participant → Operation → Bool)
    (scope : Scope Operation) (actor target : Participant) (operation : Operation)
    (decision : Bool) (specified : expressed target operation = some decision) :
    admitted expressed contextual scope actor target operation ↔
      scope.includes operation ∧ decision = true := by
  simp [admitted, specified]

theorem implicitUsesContext {Participant Operation : Type}
    (expressed : Participant → Operation → Option Bool)
    (contextual : Participant → Participant → Operation → Bool)
    (scope : Scope Operation) (actor target : Participant) (operation : Operation)
    (unspecified : expressed target operation = none) :
    admitted expressed contextual scope actor target operation ↔
      scope.includes operation ∧ contextual actor target operation = true := by
  simp [admitted, unspecified]

-- A nonintrusive operation is allowed, a close approach is refused by target
-- true only. This is not a rule inferred from the actor's own conditions.
def proximityCondition (target close : Bool) : Option Bool :=
  some (!(target && close))

theorem expressedRefusalIsTargetSpecific :
    ¬ admitted proximityCondition (fun _ _ _ => true) ⟨fun _ => True⟩ false true true ∧
    admitted proximityCondition (fun _ _ _ => true) ⟨fun _ => True⟩ true false true := by
  simp [admitted, proximityCondition]

-- Absence of an expression does not by itself admit or forbid proximity.
theorem silenceDoesNotDetermineAdmission :
    admitted (fun (_ : Bool) (_ : Bool) => none)
      (fun _ _ _ => true) ⟨fun _ => True⟩ false true true ∧
    ¬ admitted (fun (_ : Bool) (_ : Bool) => none)
      (fun _ _ _ => false) ⟨fun _ => True⟩ false true true := by
  simp [admitted]

theorem permissionDoesNotExtendScope :
    ¬ admitted (fun (_ : Bool) (_ : Bool) => some true)
      (fun _ _ _ => true) ⟨fun close => close = false⟩ false true true := by
  simp [admitted]

-- Local steps stand for the extent of an accepted limitation. The test checks
-- its expressed limit overriding a permissive default, not Agency loss,
-- restoration, or a Time primitive.
def boundedLimitation (_ : Bool) (step : Nat) : Option Bool :=
  some (decide (step < 2))

theorem acceptedLimitationDoesNotAuthorizeContinuation :
    admitted boundedLimitation (fun _ _ _ => true) ⟨fun _ => True⟩ false true 0 ∧
    admitted boundedLimitation (fun _ _ _ => true) ⟨fun _ => True⟩ false true 1 ∧
    ¬ admitted boundedLimitation (fun _ _ _ => true) ⟨fun _ => True⟩ false true 2 := by
  simp [admitted, boundedLimitation]

-- The planned nonintrusive operation qualifies, the actual intrusion does not.
-- No claim about motive, blame, or a persistent disposition follows.
theorem permittedPlanDoesNotCertifyActualIntrusion :
    admitted proximityCondition (fun _ _ _ => true) ⟨fun _ => True⟩ false true false ∧
    ¬ admitted proximityCondition (fun _ _ _ => true) ⟨fun _ => True⟩ false true true := by
  simp [admitted, proximityCondition]

end DanielOntology.RespectRevision
