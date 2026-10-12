import EmbodiedConsciousness

/-!
# Nonbinding example: representation-mediated bodily activity

This is an example Configuration, not a replacement term for withdrawn D113.
`HistoricalIntention` preserves the old record solely to check the reduction.
The two round trips preserve every field of that formal record; they do not
establish a general account of intention, goal pursuit, or semantic fidelity.
The contribution still uses the existing temporal CausalContribution shadow.
-/

universe u v w
namespace DanielOntology.RepresentationActivityExample
open EmbodiedConsciousnessProposal

structure Example (Part : Type u) {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} (body : Body Part entity) where
  contribution : CausalContribution Feature Context entity.persistenceDirection body.feeding
  bodily : contribution.downstreamChange.transformation ∈ body.recurringTransformations
  referent : State (Feature × Context)

structure HistoricalIntention
    (Part : Type u)
    {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)}
    (body : Body Part entity) where
  targetRepresentation : Feature
  contrastRepresentation : Feature
  targetDifference : contrastRepresentation ≠ targetRepresentation
  targetOutcome : State (Feature × Context)
  targetDenotation : Denotation Feature (State (Feature × Context))
  denotationNamesTarget :
    targetDenotation.expression = targetRepresentation ∧
    targetDenotation.target = targetOutcome
  contribution :
    CausalContribution Feature Context entity.persistenceDirection body.feeding
  targetGuidesActivity :
    contribution.leftEndpoints.first.input.value.1 = contrastRepresentation ∧
    contribution.rightEndpoints.first.input.value.1 = targetRepresentation
  guidedActivity : Transformation entity.persistenceDirection
  guidedActivityWithinBody : guidedActivity ∈ body.recurringTransformations
  contributionGuidesActivity :
    contribution.downstreamChange.transformation = guidedActivity

def reduce {Part : Type u} {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} {body : Body Part entity}
    (old : HistoricalIntention Part body) : Example Part body where
  contribution := old.contribution
  bodily := old.contributionGuidesActivity.symm ▸ old.guidedActivityWithinBody
  referent := old.targetOutcome

def expand {Part : Type u} {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} {body : Body Part entity}
    (sample : Example Part body) : HistoricalIntention Part body where
  targetRepresentation := sample.contribution.rightEndpoints.first.input.value.1
  contrastRepresentation := sample.contribution.leftEndpoints.first.input.value.1
  targetDifference := sample.contribution.inputDiffers
  targetOutcome := sample.referent
  targetDenotation := ⟨sample.contribution.rightEndpoints.first.input.value.1, sample.referent⟩
  denotationNamesTarget := ⟨rfl, rfl⟩
  contribution := sample.contribution
  targetGuidesActivity := ⟨rfl, rfl⟩
  guidedActivity := sample.contribution.downstreamChange.transformation
  guidedActivityWithinBody := sample.bodily
  contributionGuidesActivity := rfl

theorem reduceExpand {Part : Type u} {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} {body : Body Part entity}
    (sample : Example Part body) : reduce (expand sample) = sample := by
  cases sample
  rfl

theorem expandReduce {Part : Type u} {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} {body : Body Part entity}
    (old : HistoricalIntention Part body) : expand (reduce old) = old := by
  cases old with
  | mk target contrast different outcome denotation names contribution upstream activity bodily guides =>
    cases denotation
    simp_all [expand, reduce]
    exact ⟨names.1.symm, names.2.symm⟩

/-- The denoted State is independent of the represented feature and mechanism. -/
theorem changingReferentPreservesMechanism
    {Part : Type u} {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} {body : Body Part entity}
    (sample : Example Part body) (referent : State (Feature × Context)) :
    (expand { sample with referent := referent }).targetOutcome = referent ∧
    (expand { sample with referent := referent }).targetRepresentation =
      (expand sample).targetRepresentation ∧
    (expand { sample with referent := referent }).contribution = sample.contribution ∧
    (expand { sample with referent := referent }).guidedActivity =
      sample.contribution.downstreamChange.transformation := ⟨rfl, rfl, rfl, rfl⟩

def activity : Example ToyPart systemBody where
  contribution := forwardContribution
  bodily := by
    change forwardChangeTransform ∈ systemBody.recurringTransformations
    exact List.Mem.tail _ (List.Mem.tail _ (List.Mem.head _))
  referent := state true .returnLow

theorem referentNeedNotBeResult :
    activity.referent ≠ activity.contribution.downstreamChange.transformation.output := by
  intro equal
  have values := congrArg State.value equal
  simp [activity, forwardContribution, forwardChangeTransform, state] at values

theorem resultCanBeReferent :
    (expand { activity with
      referent := activity.contribution.downstreamChange.transformation.output }).targetOutcome =
      (expand activity).guidedActivity.output := rfl

end DanielOntology.RepresentationActivityExample
