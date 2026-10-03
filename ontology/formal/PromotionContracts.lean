import EmbodiedConsciousness

/-!
# Promotion contracts

These theorems are the proof-checked interface between the embodied-consciousness
proposal manifest and its formal shadow. Each theorem is deliberately redundant
with structure fields or a finite witness: that redundancy fixes the exact claim
CI must continue to elaborate when the underlying formalization changes.
-/

universe u v w

namespace DanielOntology.EmbodiedConsciousnessPromotionContracts

open ConsciousnessProposal
open EmbodiedConsciousnessProposal

/-- organon:promotion-contract EC-D1 -/
theorem bodyContract
    {Part : Type u} {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} (body : Body Part entity) :
    body.states ≠ [] ∧
    (∀ state, state ∈ body.states → state ∈ entity.persistence.states) ∧
    OrderedBy entity.persistenceDirection.before body.states ∧
    (∀ state, state ∈ body.states → ∃ part, body.partAt state part) ∧
    (∀ state, body.interior.scope.includes state →
      ¬ body.environment.includes state) ∧
    body.identityPath.steps ≠ [] ∧
    (∀ transformation,
      transformation ∈ body.recurringTransformations →
        transformation ∈ body.identityPath.steps ∧
        body.interior.conforms transformation.input ∧
        body.interior.conforms transformation.output ∧
        (∀ constraint,
          constraint ∈ entity.boundary.constraints →
            constraint.permits transformation) ∧
        entity.identity.holds transformation.input ∧
        entity.identity.holds transformation.output) := by
  refine ⟨body.statesNonempty, body.statesWithinPersistence, body.statesOrdered,
    body.eachStateHasConstituent, body.interiorEnvironmentDisjoint,
    body.identityPathNonempty, ?_⟩
  intro transformation member
  exact ⟨body.recurringOccursInPath transformation member,
    (body.recurringWithinInterior transformation member).1,
    (body.recurringWithinInterior transformation member).2,
    body.recurringAdmittedByBoundary transformation member,
    (body.recurringPreservesIdentity transformation member).1,
    (body.recurringPreservesIdentity transformation member).2⟩

/-- organon:promotion-contract EC-D2 -/
theorem bodilyOrganizationContract
    {Organ Part : Type u} {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} {body : Body Part entity}
    (organization : BodilyOrganization Organ Part body) :
    (∀ organ, organ ∈ organization.organs →
      ∃ state, state ∈ body.states ∧
        body.partAt state (organization.organPart organ)) ∧
    (∀ organ, organ ∈ organization.organs →
      entity.identity.holds
        (organization.sustainingContribution organ).downstreamChange.transformation.output) ∧
    (∀ organ, organ ∈ organization.organs →
      organization.recurring organ ∈ body.recurringTransformations) ∧
    (∀ first, first ∈ organization.organs →
      ∀ second, second ∈ organization.organs → first ≠ second →
        organization.recurring first ≠ organization.recurring second) ∧
    (∀ organ, organ ∈ organization.organs →
      organization.recurring organ ∈
          (organization.sustainingContribution organ).leftPath.steps ∨
      organization.recurring organ ∈
          (organization.sustainingContribution organ).rightPath.steps) ∧
    ∃ first second,
      first ∈ organization.organs ∧ second ∈ organization.organs ∧
      first ≠ second ∧
      body.feeding.feeds
        (organization.sustainingContribution first).downstreamChange.transformation.output
        (organization.recurring second).input ∧
      entity.persistenceDirection.before
        (organization.sustainingContribution first).downstreamChange.transformation.output
        (organization.recurring second).output := by
  exact ⟨organization.organPresent, organization.contributionSustainsIdentity,
    organization.recurringInBody,
    organization.recurringPairwiseDistinct,
    organization.recurringOccursInContribution,
    organization.coordinationWitness⟩

/-- organon:promotion-contract EC-D3 -/
theorem embodiedPerspectiveContract
    {Part : Type u} {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} {body : Body Part entity}
    (perspective : EmbodiedPerspective Part body) :
    perspective.conditionDenotation.expression =
        perspective.conditionRepresentation ∧
    perspective.conditionDenotation.target = perspective.representedCondition ∧
    body.interior.scope.includes perspective.representedCondition ∧
    perspective.perception.state =
      perspective.perception.contribution.rightEndpoints.first.input ∧
    body.interior.conforms perspective.perception.state ∧
    perspective.perception.contribution.leftEndpoints.first.input.value.1 =
        perspective.contrastConditionRepresentation ∧
    perspective.perception.contribution.rightEndpoints.first.input.value.1 =
        perspective.conditionRepresentation ∧
    perspective.memory.recordedState =
      perspective.memory.contribution.rightEndpoints.first.input ∧
    perspective.memory.recordedState ∈ perspective.memory.persistence.states ∧
    body.interior.conforms perspective.memory.recordedState ∧
    perspective.memory.contribution.downstreamChange.transformation.output ∈
      perspective.memory.persistence.states ∧
    perspective.memory.contribution.leftEndpoints.first.input.value.1 =
        perspective.contrastMemoryRepresentation ∧
    perspective.memory.contribution.rightEndpoints.first.input.value.1 =
        perspective.memoryRepresentation ∧
    perspective.conditionRepresentation ∈
      perspective.model.representations ∧
    perspective.contrastConditionRepresentation ∈
      perspective.model.representations ∧
    perspective.memoryRepresentation ∈ perspective.model.representations ∧
    perspective.contrastMemoryRepresentation ∈
      perspective.model.representations ∧
    (∀ transformation,
      transformation ∈ perspective.model.transformations →
        transformation ∈ body.recurringTransformations) ∧
    perspective.perception.contribution.downstreamChange.transformation.output ∈
      perspective.model.laterStates ∧
    perspective.memory.contribution.downstreamChange.transformation.output ∈
      perspective.model.laterStates ∧
    perspective.model.constraints ≠ [] ∧
    (∀ constraint, constraint ∈ perspective.model.constraints →
      constraint ∈ entity.boundary.constraints) ∧
    (∀ transformation,
      transformation ∈ perspective.availableTransformations →
        transformation ∈ body.recurringTransformations ∧
        (perspective.availableDenotation transformation).expression =
          perspective.availableRepresentation transformation ∧
        (perspective.availableDenotation transformation).target =
          transformation.output) ∧
    body.interior.conforms
      perspective.perception.contribution.downstreamChange.transformation.output ∧
    body.interior.conforms
      perspective.memory.contribution.downstreamChange.transformation.output := by
  refine ⟨perspective.denotationNamesCondition.1,
    perspective.denotationNamesCondition.2,
    body.interior.conformityWithinScope perspective.representedCondition
      perspective.representedConditionIsInternal,
    perspective.perception.stateRegistersCondition,
    perspective.perception.stateIsInternal,
    perspective.perception.differenceIsUpstream.1,
    perspective.perception.differenceIsUpstream.2,
    perspective.memory.recordedStateSuppliesMemory,
    perspective.memory.recordedStateInPersistence,
    perspective.memory.recordedStateIsInternal,
    perspective.memory.contributionResultInPersistence,
    perspective.memory.differenceIsUpstream.1,
    perspective.memory.differenceIsUpstream.2,
    perspective.model.conditionRepresentationInModel,
    perspective.model.contrastConditionRepresentationInModel,
    perspective.model.memoryRepresentationInModel,
    perspective.model.contrastMemoryRepresentationInModel,
    perspective.model.transformationsWithinBody,
    perspective.model.perceptionResultInLaterStates,
    perspective.model.memoryResultInLaterStates,
    perspective.model.constraintsNonempty,
    perspective.model.constraintsFromBoundary, ?_,
    perspective.perceptionChangesInternal,
    perspective.memoryChangesInternal⟩
  intro transformation member
  exact ⟨perspective.availableWithinBody transformation member,
    (perspective.availableDenotationExact transformation member).1,
    (perspective.availableDenotationExact transformation member).2⟩

/-- organon:promotion-contract EC-D4 -/
theorem recurrentIntegrationContract
    {Feature : Type u} {Context : Type v}
    {direction : Direction (Feature × Context)}
    {feeding : FeedRelation (Feature × Context)}
    (integration : RecurrentIntegration direction feeding) :
    integration.firstFamily.transformations ≠ [] ∧
    integration.secondFamily.transformations ≠ [] ∧
    integration.firstFamily.transformations ≠
      integration.secondFamily.transformations ∧
    integration.firstToSecond.leftEndpoints.first ∈
      integration.firstFamily.transformations ∧
    integration.firstToSecond.rightEndpoints.first ∈
      integration.firstFamily.transformations ∧
    integration.firstToSecond.downstreamChange.transformation ∈
      integration.secondFamily.transformations ∧
    integration.secondToFirst.leftEndpoints.first ∈
      integration.secondFamily.transformations ∧
    integration.secondToFirst.rightEndpoints.first ∈
      integration.secondFamily.transformations ∧
    integration.secondToFirst.downstreamChange.transformation ∈
      integration.firstFamily.transformations ∧
    direction.before
      integration.firstToSecond.downstreamChange.transformation.output
      integration.secondToFirst.leftEndpoints.first.input := by
  exact ⟨integration.firstFamily.nonempty, integration.secondFamily.nonempty,
    integration.familiesDistinct,
    integration.firstComparisonInFirstFamily.1,
    integration.firstComparisonInFirstFamily.2,
    integration.firstChangeInSecondFamily,
    integration.returnComparisonInSecondFamily.1,
    integration.returnComparisonInSecondFamily.2,
    integration.returnChangeInFirstFamily,
    integration.returnOccursLater⟩

/-- organon:promotion-contract EC-D5 -/
theorem internalActivitySelectionContract
    {Part : Type u} {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} {body : Body Part entity}
    (selection : InternalActivitySelection Part body) :
    selection.contribution.leftEndpoints.first.input.value.1 =
        selection.contrastRepresentation ∧
    selection.contribution.rightEndpoints.first.input.value.1 =
        selection.representation ∧
    selection.outcomeDenotation.expression = selection.representation ∧
    selection.outcomeDenotation.target = selection.representedOutcome ∧
    selection.selected ∈ body.recurringTransformations ∧
    selection.rejected ∈ body.recurringTransformations ∧
    selection.selected ≠ selection.rejected ∧
    selection.representedOutcome = selection.selected.output ∧
    selection.contribution.downstreamChange.transformation.output =
      selection.selected.output ∧
    body.interior.conforms selection.selected.output ∧
    body.interior.conforms selection.rejected.output ∧
    body.interior.scope.includes selection.selected.output ∧
    body.interior.scope.includes selection.rejected.output ∧
    (∀ constraint, constraint ∈ entity.boundary.constraints →
      constraint.permits selection.selected) ∧
    (∀ constraint, constraint ∈ entity.boundary.constraints →
      constraint.permits selection.rejected) := by
  exact ⟨selection.representationalDifferenceIsUpstream.1,
    selection.representationalDifferenceIsUpstream.2,
    selection.denotationNamesOutcome.1,
    selection.denotationNamesOutcome.2,
    selection.optionsWithinBody selection.selected selection.selectedInOptions,
    selection.optionsWithinBody selection.rejected selection.rejectedInOptions,
    selection.discriminates, selection.representedOutcomeIsSelectedOutput,
    selection.contributionSelects,
    selection.selectedIsInternal,
    selection.rejectedIsInternal,
    body.interior.conformityWithinScope selection.selected.output
      selection.selectedIsInternal,
    body.interior.conformityWithinScope selection.rejected.output
      selection.rejectedIsInternal,
    body.recurringAdmittedByBoundary selection.selected
      (selection.optionsWithinBody selection.selected selection.selectedInOptions),
    body.recurringAdmittedByBoundary selection.rejected
      (selection.optionsWithinBody selection.rejected selection.rejectedInOptions)⟩

/-- organon:promotion-contract EC-D6 -/
theorem embodiedCandidateExactContract
    {Part : Type u} {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)}
    (body : Body Part entity) (moment : State (Feature × Context)) :
    (embodiedCandidateCondition body).holds () moment ↔
      Nonempty (EmbodiedRecurrentStructure Part body moment) := by
  exact candidateHoldsIffEmbodiedRecurrentAt body moment

/-- organon:promotion-contract EC-C1 -/
theorem bodyPartChangeCountermodel :
    systemBody.partAt (state false .forwardInput) .sensor ∧
    ¬ systemBody.partAt (state false .forwardLow) .sensor ∧
    state false .forwardInput ∈ systemBody.states ∧
    state false .forwardLow ∈ systemBody.states ∧
    state false .forwardInput ∈ systemEntity.persistence.states ∧
    state false .forwardLow ∈ systemEntity.persistence.states ∧
    systemEntity.identity.holds (state false .forwardInput) ∧
    systemEntity.identity.holds (state false .forwardLow) := by
  refine ⟨oneBodyRelationAllowsConstituentChange.1,
    oneBodyRelationAllowsConstituentChange.2.1, ?_, ?_, ?_, ?_,
    oneBodyRelationAllowsConstituentChange.2.2.1,
    oneBodyRelationAllowsConstituentChange.2.2.2⟩ <;>
    simp [systemBody, systemEntity, systemPersistence]

/-- organon:promotion-contract EC-C2 -/
theorem boundaryNonIsolationCountermodel :
    systemBody.environment.includes (state false .environment) ∧
    systemBody.interior.conforms (state false .forwardInput) ∧
    environmentToInteriorPath.steps = [environmentalInputTransform] ∧
    environmentalInputTransform.input = state false .environment ∧
    environmentalInputTransform.output = state false .forwardInput := by
  exact bodyBoundaryDoesNotRequireIsolation

/-- organon:promotion-contract EC-C3 -/
theorem sharedEnclosureCountermodel :
    Nonempty (SharedEnclosure ToyOrgan ToyPart perspectiveOnlyBody) ∧
    ¬ Nonempty (BodilyOrganization ToyOrgan ToyPart perspectiveOnlyBody) := by
  exact sharedEnclosureDoesNotEntailBodilyOrganization

/-- organon:promotion-contract EC-C4 -/
theorem sharedSignalCountermodel :
    Nonempty (SharedSignal ToyProcess Bool) ∧
    ¬ Nonempty (RecurrentIntegration noDirection noFeed) := by
  exact sharedSignalDoesNotEntailRecurrentIntegration

/-- organon:promotion-contract EC-C5 -/
theorem perspectiveOnlyCountermodel :
    Nonempty (EmbodiedPerspective ToyPart perspectiveOnlyBody) ∧
    perspectiveOnly.representedCondition = state true .forwardHigh ∧
    ¬ EmbodiedRecurrentAt perspectiveOnlyBody (state true .forwardHigh) := by
  exact ⟨⟨perspectiveOnly⟩, embodiedPerspectiveDoesNotEntailCandidate⟩

end DanielOntology.EmbodiedConsciousnessPromotionContracts
