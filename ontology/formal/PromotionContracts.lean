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
    body.states = entity.persistence.states ∧
    (∀ state, state ∈ body.states → ∃ part, body.partAt state part) ∧
    (∀ transformation,
      transformation ∈ body.recurringTransformations →
        body.interior.conforms transformation.input ∧
        body.interior.conforms transformation.output ∧
        (∀ constraint,
          constraint ∈ entity.boundary.constraints →
            constraint.permits transformation) ∧
        entity.identity.holds transformation.input ∧
        entity.identity.holds transformation.output) := by
  refine ⟨body.statesArePersistence, body.eachStateHasConstituent, ?_⟩
  intro transformation member
  exact ⟨(body.recurringWithinInterior transformation member).1,
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
    ∃ first second,
      first ∈ organization.organs ∧ second ∈ organization.organs ∧
      first ≠ second ∧
      organization.recurring first ≠ organization.recurring second ∧
      body.feeding.feeds
        (organization.sustainingContribution first).downstreamChange.transformation.output
        (organization.recurring second).input ∧
      entity.persistenceDirection.before
        (organization.sustainingContribution first).downstreamChange.transformation.output
        (organization.recurring second).output := by
  exact ⟨organization.organPresent, organization.contributionSustainsIdentity,
    organization.coordinationWitness⟩

/-- organon:promotion-contract EC-D3 -/
theorem embodiedPerspectiveContract
    {Part : Type u} {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} {body : Body Part entity}
    (perspective : EmbodiedPerspective Part body) :
    perspective.conditionDenotation.expression =
        perspective.conditionRepresentation ∧
    perspective.conditionDenotation.target = perspective.representedCondition ∧
    (∀ transformation,
      transformation ∈ perspective.availableTransformations →
        transformation ∈ body.recurringTransformations ∧
        (perspective.availableDenotation transformation).expression =
          perspective.availableRepresentation transformation ∧
        (perspective.availableDenotation transformation).target =
          transformation.output) ∧
    perspective.perceptionContribution.leftEndpoints.first.input.value.1 =
        perspective.contrastConditionRepresentation ∧
    perspective.perceptionContribution.rightEndpoints.first.input.value.1 =
        perspective.conditionRepresentation ∧
    perspective.memoryContribution.leftEndpoints.first.input.value.1 =
        perspective.contrastMemoryRepresentation ∧
    perspective.memoryContribution.rightEndpoints.first.input.value.1 =
        perspective.memoryRepresentation := by
  refine ⟨perspective.denotationNamesCondition.1,
    perspective.denotationNamesCondition.2, ?_,
    perspective.perceptionDifferenceExact.1,
    perspective.perceptionDifferenceExact.2,
    perspective.memoryDifferenceExact.1,
    perspective.memoryDifferenceExact.2⟩
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
    selection.selected ∈ body.recurringTransformations ∧
    selection.rejected ∈ body.recurringTransformations ∧
    selection.selected ≠ selection.rejected ∧
    selection.representedOutcome = selection.selected.output ∧
    selection.contribution.downstreamChange.transformation.output =
      selection.selected.output := by
  exact ⟨selection.representationalDifferenceIsUpstream.1,
    selection.representationalDifferenceIsUpstream.2,
    selection.optionsWithinBody selection.selected selection.selectedInOptions,
    selection.optionsWithinBody selection.rejected selection.rejectedInOptions,
    selection.discriminates, selection.representedOutcomeIsSelectedOutput,
    selection.contributionSelects⟩

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
    systemEntity.identity.holds (state false .forwardInput) ∧
    systemEntity.identity.holds (state false .forwardLow) := by
  exact oneBodyRelationAllowsConstituentChange

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
