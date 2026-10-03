import AttentionLoveCare

/-! Proof-checked promotion contracts for the attention, love, care, and respect dossier. -/

universe u v w

namespace DanielOntology.AttentionLoveCarePromotionContracts

open EmbodiedConsciousnessProposal
open AttentionLoveCareProposal

/-- organon:promotion-contract AC-D1 -/
theorem embodiedSelfGovernanceContract
    {Part : Type u} {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} {body : Body Part entity}
    (governance : EmbodiedSelfGovernance Part body) :
    governance.perspective.conditionRepresentation =
        governance.selection.representation ∧
    governance.perspective.perception.contribution =
        governance.selection.contribution ∧
    governance.governedTransformations ≠ [] ∧
    governance.selection.selected ∈ governance.governedTransformations ∧
    (∀ transformation,
      transformation ∈ governance.governedTransformations →
        governance.scope.includes transformation ∧
        transformation ∈ body.recurringTransformations ∧
        governance.constraint.permits transformation) ∧
    governance.constraint ∈ entity.boundary.constraints := by
  refine ⟨governance.perspectiveGuidesSelection.1,
    governance.perspectiveGuidesSelection.2,
    governance.governedNonempty, governance.selectionIsGoverned, ?_, governance.constraintFromBoundary⟩
  intro transformation member
  exact ⟨governance.governedInScope transformation member,
    governance.governedWithinBody transformation member,
    governance.governedAdmitted transformation member⟩

/-- organon:promotion-contract AC-D2 -/
theorem intentionContract
    {Part : Type u} {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} {body : Body Part entity}
    (intention : Intention Part body) :
    intention.contrastRepresentation ≠ intention.targetRepresentation ∧
    intention.targetDenotation.expression = intention.targetRepresentation ∧
    intention.targetDenotation.target = intention.targetOutcome ∧
    intention.contribution.leftEndpoints.first.input.value.1 =
        intention.contrastRepresentation ∧
    intention.contribution.rightEndpoints.first.input.value.1 =
        intention.targetRepresentation ∧
    intention.guidedActivity ∈ body.recurringTransformations ∧
    intention.contribution.downstreamChange.transformation =
        intention.guidedActivity := by
  exact ⟨intention.targetDifference,
    intention.denotationNamesTarget.1,
    intention.denotationNamesTarget.2,
    intention.targetGuidesActivity.1,
    intention.targetGuidesActivity.2,
    intention.guidedActivityWithinBody,
    intention.contributionGuidesActivity⟩

/-- organon:promotion-contract AC-D3 -/
theorem attentionContract
    {Part : Type u} {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} {body : Body Part entity}
    (attention : Attention Part body) :
    attention.contrastRepresentation ≠ attention.focalRepresentation ∧
    attention.available ≠ [] ∧
    attention.available.Nodup ∧ attention.organized.Nodup ∧
    attention.moment ∈ body.states ∧
    attention.degreeNumerator ≤ attention.degreeDenominator ∧
    0 < attention.degreeDenominator ∧
    attention.degreeNumerator = attention.organized.length ∧
    attention.degreeDenominator = attention.available.length ∧
    (∀ item, item ∈ attention.available →
      item.channel = .perception ∨
      item.channel = .interpretation ∨
      item.channel = .action) ∧
    (∀ item, item ∈ attention.organized →
      item ∈ attention.available ∧
      (attention.organizingContribution item).leftEndpoints.first.input.value.1 =
          attention.contrastRepresentation ∧
      (attention.organizingContribution item).rightEndpoints.first.input.value.1 =
          attention.focalRepresentation ∧
      (attention.organizingContribution item).downstreamChange.transformation.output =
          item.result ∧
      (item.result = attention.moment ∨
        entity.persistenceDirection.before item.result attention.moment)) := by
  have bounds := attentionDegreeBounded attention
  refine ⟨attention.focalDifference, attention.availableNonempty,
    attention.availableUnique, bounds.2.2, attention.momentWithinBody, bounds.1, bounds.2.1,
    attention.degreeNumeratorExact, attention.degreeDenominatorExact, ?_, ?_⟩
  · intro item _
    cases item.channel <;> simp
  intro item member
  exact ⟨attention.organizedWithinAvailable item member,
    (attention.organizedByDifference item member).1,
    (attention.organizedByDifference item member).2,
    attention.contributionProducesResult item member,
    attention.resultsAtOrBeforeMoment item member⟩

/-- organon:promotion-contract AC-D4 -/
theorem sustainedAttentionContract
    {Part : Type u} {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} {body : Body Part entity}
    (sustained : SustainedAttention Part body) :
    (∃ first second rest, sustained.states = first :: second :: rest) ∧
    OrderedBy entity.persistenceDirection.before sustained.states ∧
    (∀ state, state ∈ sustained.states →
      state ∈ body.states ∧
      (sustained.attentionAt state).moment = state ∧
      (sustained.attentionAt state).organized ≠ [] ∧
      (sustained.attentionAt state).focalRepresentation =
          sustained.commonFocalRepresentation ∧
      (sustained.attentionAt state).contrastRepresentation =
          sustained.commonContrastRepresentation) := by
  refine ⟨sustained.hasChangingStates, sustained.statesOrdered, ?_⟩
  intro state member
  exact ⟨sustained.statesWithinBody state member,
    sustained.indexedAtState state member,
    sustained.maintained state member,
    (sustained.sameDifference state member).1,
    (sustained.sameDifference state member).2⟩

/-- organon:promotion-contract AC-D5 -/
theorem absoluteAttentionContract
    {Part : Type u} {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} {body : Body Part entity}
    (absolute : AbsoluteAttention Part body) :
    (∀ item, item ∈ absolute.attention.available →
      item ∈ absolute.attention.organized) ∧
    (∀ item, ¬ FocusIndependentAction absolute.attention item) := by
  exact ⟨absolute.allAvailableOrganized,
    absoluteAttentionInhibitsFocusIndependentAction absolute⟩

/-- organon:promotion-contract AC-D6 -/
theorem loveContract
    {Part : Type u} {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} {body : Body Part entity}
    (love : Love Part body) :
    love.beloved ≠ entity ∧
    love.beloved.identity ≠ entity.identity ∧
    love.belovedDenotation.expression = love.belovedRepresentation ∧
    love.belovedDenotation.target = love.beloved ∧
    love.attention.commonFocalRepresentation = love.belovedRepresentation ∧
    (∀ state, state ∈ love.attention.states →
      (love.attention.attentionAt state).organized ≠ []) := by
  exact ⟨love.belovedIsOther, love.belovedIdentityIsOther, love.denotationNamesBeloved.1,
    love.denotationNamesBeloved.2, love.attentionDirectedTowardBeloved,
    love.attention.maintained⟩

/-- organon:promotion-contract AC-D7 -/
theorem careContract
    {Part : Type u} {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} {body : Body Part entity}
    (care : Care Part body) :
    care.caredFor ≠ entity ∧
    care.caredFor.identity ≠ entity.identity ∧
    care.targetDenotation.expression = care.targetRepresentation ∧
    care.targetDenotation.target = (care.caredFor, care.attendedState) ∧
    care.attendedState ∈ care.caredFor.persistence.states ∧
    care.attention.focalRepresentation = care.targetRepresentation ∧
    care.actionItem.channel = .action ∧
    care.actionItem ∈ care.attention.available ∧
    care.actionItem ∈ care.attention.organized := by
  exact ⟨care.caredForIsOther, care.caredForIdentityIsOther, care.denotationNamesTargetState.1,
    care.denotationNamesTargetState.2, care.attendedStateInHistory,
    care.attentionTargetsState,
    care.itemIsAction, care.actionAvailable, care.actionOrganizedByAttention⟩

/-- organon:promotion-contract AC-D8 -/
theorem respectContract
    {Carrier : Type u} {actor target : Entity Carrier}
    (respect : Respect actor target) :
    target ≠ actor ∧
    target.identity ≠ actor.identity ∧
    respect.actionScope.includes respect.constrainedAction ∧
    respect.constraint.permits respect.constrainedAction ∧
    target.identity.holds respect.constrainedAction.output ∧
    Nonempty (RespectProtection target respect.constraint
      respect.constrainedAction) := by
  exact ⟨respect.targetIsOther, respect.targetIdentityIsOther, respect.actionInScope,
    respect.actionConstrained, respectProtectionPreservesIdentity respect.protection,
    ⟨respect.protection⟩⟩

/-- organon:promotion-contract AC-C1 -/
theorem partialSelfGovernanceCountermodel :
    systemSelfGovernance.scope.includes forwardHighTransform ∧
    ¬ systemSelfGovernance.scope.includes returnLowTransform :=
  selfGovernanceCanBePartial

/-- organon:promotion-contract AC-C2 -/
theorem intentionOutcomeCountermodel :
    systemIntention.targetOutcome ≠ systemIntention.guidedActivity.output :=
  intentionNeedNotAchieveTarget

/-- organon:promotion-contract AC-C3 -/
theorem partialAttentionCountermodel :
    (¬ ∃ absolute : AbsoluteAttention ToyPart systemBody,
      absolute.attention = systemAttention) ∧
    actionItem ∈ systemAttention.available ∧
    actionItem ∉ systemAttention.organized := by
  exact ⟨systemAttentionIsNotAbsolute,
    attentionDoesNotRequireAllAvailableItems⟩

/-- organon:promotion-contract AC-C4 -/
theorem absoluteAttentionActionLimit :
    ∀ item, ¬ FocusIndependentAction systemAbsoluteAttention.attention item :=
  absoluteAttentionHasNoFocusIndependentAction

end DanielOntology.AttentionLoveCarePromotionContracts
