import EmbodiedConsciousness

/-!
# Self-governance, intention, attention, love, care, and respect

This proposal-local shadow encodes the eight terms promoted after the
embodiment foundation. It does not define Consciousness, benefit, consent,
morality, reciprocity, understanding, possession, or complete Control.
-/

universe u v w

namespace DanielOntology.AttentionLoveCareProposal

open EmbodiedConsciousnessProposal

structure EmbodiedSelfGovernance
    (Part : Type u)
    {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)}
    (body : Body Part entity) where
  perspective : EmbodiedPerspective Part body
  selection : InternalActivitySelection Part body
  perspectiveGuidesSelection :
    perspective.conditionRepresentation = selection.representation ∧
    perspective.perception.contribution = selection.contribution
  scope : Scope (Transformation entity.persistenceDirection)
  governedTransformations : List (Transformation entity.persistenceDirection)
  governedNonempty : governedTransformations ≠ []
  governedInScope : ∀ transformation,
    transformation ∈ governedTransformations → scope.includes transformation
  governedWithinBody : ∀ transformation,
    transformation ∈ governedTransformations →
      transformation ∈ body.recurringTransformations
  constraint : Constraint (Feature × Context)
  constraintFromBoundary : constraint ∈ entity.boundary.constraints
  governedAdmitted : ∀ transformation,
    transformation ∈ governedTransformations → constraint.permits transformation

inductive ActivityGuidance where
  | select
  | continue
  | inhibit
  | revise
deriving DecidableEq, Repr

structure Intention
    (Part : Type u)
    {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)}
    (body : Body Part entity) where
  guidance : ActivityGuidance
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

inductive AttentionChannel where
  | perception
  | interpretation
  | action
deriving DecidableEq, Repr

structure AttentionItem (Carrier : Type u) where
  channel : AttentionChannel
  result : State Carrier

noncomputable instance : DecidableEq (AttentionItem Carrier) :=
  Classical.typeDecidableEq _

structure Attention
    (Part : Type u)
    {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)}
    (body : Body Part entity) where
  focalRepresentation : Feature
  contrastRepresentation : Feature
  focalDifference : contrastRepresentation ≠ focalRepresentation
  available : List (AttentionItem (Feature × Context))
  availableNonempty : available ≠ []
  organized : List (AttentionItem (Feature × Context))
  organizedWithinAvailable : ∀ item, item ∈ organized → item ∈ available
  organizingContribution : AttentionItem (Feature × Context) →
    CausalContribution Feature Context entity.persistenceDirection body.feeding
  organizedByDifference : ∀ item, item ∈ organized →
    (organizingContribution item).leftEndpoints.first.input.value.1 =
        contrastRepresentation ∧
    (organizingContribution item).rightEndpoints.first.input.value.1 =
        focalRepresentation
  contributionProducesResult : ∀ item, item ∈ organized →
    (organizingContribution item).downstreamChange.transformation.output =
      item.result
  degreeNumerator : Nat
  degreeDenominator : Nat
  degreeNumeratorExact : degreeNumerator = organized.length
  degreeDenominatorExact : degreeDenominator = available.length

structure SustainedAttention
    (Part : Type u)
    {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)}
    (body : Body Part entity) where
  states : List (State (Feature × Context))
  hasChangingStates : ∃ first second rest, states = first :: second :: rest
  statesWithinBody : ∀ state, state ∈ states → state ∈ body.states
  statesOrdered : OrderedBy entity.persistenceDirection.before states
  attentionAt : State (Feature × Context) → Attention Part body
  maintained : ∀ state, state ∈ states →
    (attentionAt state).organized ≠ []
  commonFocalRepresentation : Feature
  commonContrastRepresentation : Feature
  sameDifference : ∀ state, state ∈ states →
    (attentionAt state).focalRepresentation = commonFocalRepresentation ∧
    (attentionAt state).contrastRepresentation = commonContrastRepresentation

structure AbsoluteAttention
    (Part : Type u)
    {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)}
    (body : Body Part entity) where
  attention : Attention Part body
  allAvailableOrganized : attention.organized = attention.available

def FocusIndependentAction
    {Part : Type u} {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} {body : Body Part entity}
    (attention : Attention Part body)
    (item : AttentionItem (Feature × Context)) : Prop :=
  item.channel = .action ∧ item ∈ attention.available ∧
    item ∉ attention.organized

theorem absoluteAttentionInhibitsFocusIndependentAction
    {Part : Type u} {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} {body : Body Part entity}
    (absolute : AbsoluteAttention Part body) :
    ∀ item, ¬ FocusIndependentAction absolute.attention item := by
  intro item independent
  rcases independent with ⟨_, available, notOrganized⟩
  apply notOrganized
  rw [absolute.allAvailableOrganized]
  exact available

structure Love
    (Part : Type u)
    {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)}
    (body : Body Part entity) where
  beloved : Entity (Feature × Context)
  belovedIsOther : beloved ≠ entity
  attention : SustainedAttention Part body
  belovedRepresentation : Feature
  belovedDenotation : Denotation Feature (Entity (Feature × Context))
  denotationNamesBeloved :
    belovedDenotation.expression = belovedRepresentation ∧
    belovedDenotation.target = beloved
  attentionDirectedTowardBeloved :
    attention.commonFocalRepresentation = belovedRepresentation

structure Care
    (Part : Type u)
    {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)}
    (body : Body Part entity) where
  caredFor : Entity (Feature × Context)
  caredForIsOther : caredFor ≠ entity
  attendedState : State (Feature × Context)
  attendedStateInHistory : attendedState ∈ caredFor.persistence.states
  targetRepresentation : Feature
  targetDenotation :
    Denotation Feature (Entity (Feature × Context) × State (Feature × Context))
  denotationNamesTargetState :
    targetDenotation.expression = targetRepresentation ∧
    targetDenotation.target = (caredFor, attendedState)
  attention : Attention Part body
  attentionTargetsState : attention.focalRepresentation = targetRepresentation
  actionItem : AttentionItem (Feature × Context)
  itemIsAction : actionItem.channel = .action
  actionAvailable : actionItem ∈ attention.available
  actionOrganizedByAttention : actionItem ∈ attention.organized

inductive RespectProtection
    {Carrier : Type u}
    (target : Entity Carrier)
    (constraint : Constraint Carrier)
    {direction : Direction Carrier}
    (action : Transformation direction) where
  | boundary
      (inputPreserved : target.identity.holds action.input)
      (outputPreserved : target.identity.holds action.output)
  | agency
      (options : List (Transformation target.persistenceDirection))
      (nonempty : options ≠ [])
      (admitted : ∀ transformation, transformation ∈ options →
        constraint.permits transformation)
      (identityPreserved : ∀ transformation, transformation ∈ options →
        target.identity.holds transformation.output)
  | selfDetermination
      (first second : Transformation target.persistenceDirection)
      (distinct : first ≠ second)
      (firstAdmitted : constraint.permits first)
      (secondAdmitted : constraint.permits second)
      (firstPreserved : target.identity.holds first.output)
      (secondPreserved : target.identity.holds second.output)

structure Respect
    {Carrier : Type u}
    (actor target : Entity Carrier) where
  targetIsOther : target ≠ actor
  constraint : Constraint Carrier
  actionScope : Scope (Transformation actor.persistenceDirection)
  constrainedAction : Transformation actor.persistenceDirection
  actionInScope : actionScope.includes constrainedAction
  actionConstrained : constraint.permits constrainedAction
  protection : RespectProtection target constraint constrainedAction

/-! ## Finite inhabited witnesses -/

open EmbodiedConsciousnessProposal

def systemSelfGovernance :
    EmbodiedSelfGovernance ToyPart systemBody where
  perspective := systemPerspective
  selection := systemSelection
  perspectiveGuidesSelection := by constructor <;> rfl
  scope := ⟨fun transformation => transformation = forwardHighTransform⟩
  governedTransformations := [forwardHighTransform]
  governedNonempty := by simp
  governedInScope := by simp
  governedWithinBody := by simp [systemBody]
  constraint := internalOnly
  constraintFromBoundary := by simp [systemEntity, systemBoundary]
  governedAdmitted := by
    intro transformation member
    simp at member
    subst transformation
    simp [internalOnly, systemIdentity, forwardHighTransform, transform, state]

theorem selfGovernanceCanBePartial :
    systemSelfGovernance.scope.includes forwardHighTransform ∧
    ¬ systemSelfGovernance.scope.includes returnLowTransform := by
  constructor
  · rfl
  · intro equal
    have inputs := congrArg Transformation.input equal
    simp [forwardHighTransform, returnLowTransform,
      transform, state] at inputs

def systemIntention : Intention ToyPart systemBody where
  guidance := .revise
  targetRepresentation := true
  contrastRepresentation := false
  targetDifference := by decide
  targetOutcome := state true .returnLow
  targetDenotation := ⟨true, state true .returnLow⟩
  denotationNamesTarget := ⟨rfl, rfl⟩
  contribution := forwardContribution
  targetGuidesActivity := ⟨rfl, rfl⟩
  guidedActivity := forwardChangeTransform
  guidedActivityWithinBody := by simp [systemBody]
  contributionGuidesActivity := rfl

theorem intentionNeedNotAchieveTarget :
    systemIntention.targetOutcome ≠ systemIntention.guidedActivity.output := by
  intro equal
  have values := congrArg State.value equal
  simp [systemIntention, forwardChangeTransform, state] at values

def perceptionItem : AttentionItem Carrier :=
  ⟨.perception, state true .forwardHigh⟩

def interpretationItem : AttentionItem Carrier :=
  ⟨.interpretation, state true .returnHigh⟩

def actionItem : AttentionItem Carrier :=
  ⟨.action, state true .returnHigh⟩

def contributionForItem : AttentionItem Carrier →
    CausalContribution Bool Stage systemDirection unconstrainedFeed
  | ⟨.perception, _⟩ => forwardContribution
  | ⟨.interpretation, _⟩ => returnContribution
  | ⟨.action, _⟩ => returnContribution

def systemAttention : Attention ToyPart systemBody where
  focalRepresentation := true
  contrastRepresentation := false
  focalDifference := by decide
  available := [perceptionItem, interpretationItem, actionItem]
  availableNonempty := by simp
  organized := [perceptionItem, interpretationItem]
  organizedWithinAvailable := by simp
  organizingContribution := contributionForItem
  organizedByDifference := by
    intro item member
    simp at member
    rcases member with rfl | rfl <;> exact ⟨rfl, rfl⟩
  contributionProducesResult := by
    intro item member
    simp at member
    rcases member with rfl | rfl <;> rfl
  degreeNumerator := 2
  degreeDenominator := 3
  degreeNumeratorExact := rfl
  degreeDenominatorExact := rfl

def systemSustainedAttention : SustainedAttention ToyPart systemBody where
  states := [state false .forwardLow, state true .forwardHigh]
  hasChangingStates := ⟨_, _, [], rfl⟩
  statesWithinBody := by simp [systemBody, systemPersistence]
  statesOrdered := by
    simp [OrderedBy, systemEntity, systemDirection, state, Stage.rank]
  attentionAt := fun _ => systemAttention
  maintained := by simp [systemAttention]
  commonFocalRepresentation := true
  commonContrastRepresentation := false
  sameDifference := by simp [systemAttention]

def systemAbsoluteAttention : AbsoluteAttention ToyPart systemBody where
  attention := {
    systemAttention with
    organized := [perceptionItem, interpretationItem, actionItem]
    organizedWithinAvailable := by simp [systemAttention]
    organizedByDifference := by
      intro item member
      simp at member
      rcases member with rfl | rfl | rfl <;> exact ⟨rfl, rfl⟩
    contributionProducesResult := by
      intro item member
      simp at member
      rcases member with rfl | rfl | rfl <;> rfl
    degreeNumerator := 3
    degreeNumeratorExact := rfl
  }
  allAvailableOrganized := rfl

def belovedEntity : Entity Carrier where
  identity := systemIdentity
  boundary := systemBoundary
  persistenceDirection := systemDirection
  persistence := systemPersistence
  persistenceNamesIdentity := rfl
  current := state true .forwardHigh
  currentInPersistence := by simp [systemPersistence]
  identityHolds := by simp [systemIdentity, state]

theorem belovedIsOther : belovedEntity ≠ systemEntity := by
  intro equal
  have currents := congrArg Entity.current equal
  simp [belovedEntity, systemEntity, state] at currents

def systemLove : Love ToyPart systemBody where
  beloved := belovedEntity
  belovedIsOther := belovedIsOther
  attention := systemSustainedAttention
  belovedRepresentation := true
  belovedDenotation := ⟨true, belovedEntity⟩
  denotationNamesBeloved := ⟨rfl, rfl⟩
  attentionDirectedTowardBeloved := rfl

def systemCare : Care ToyPart systemBody where
  caredFor := belovedEntity
  caredForIsOther := belovedIsOther
  attendedState := belovedEntity.current
  attendedStateInHistory := belovedEntity.currentInPersistence
  targetRepresentation := true
  targetDenotation := ⟨true, (belovedEntity, belovedEntity.current)⟩
  denotationNamesTargetState := ⟨rfl, rfl⟩
  attention := systemAbsoluteAttention.attention
  attentionTargetsState := rfl
  actionItem := actionItem
  itemIsAction := rfl
  actionAvailable := by simp [systemAbsoluteAttention, systemAttention]
  actionOrganizedByAttention := by simp [systemAbsoluteAttention, systemAttention]

def systemRespect : Respect systemEntity belovedEntity where
  targetIsOther := belovedIsOther
  constraint := internalOnly
  actionScope := ⟨fun transformation => transformation = forwardLowTransform⟩
  constrainedAction := forwardLowTransform
  actionInScope := rfl
  actionConstrained := by
    simp [internalOnly, systemIdentity, forwardLowTransform, transform, state]
  protection := .boundary
    (by simp [belovedEntity, systemIdentity, forwardLowTransform, transform, state])
    (by simp [belovedEntity, systemIdentity, forwardLowTransform, transform, state])

theorem attentionDoesNotRequireAllAvailableItems :
    actionItem ∈ systemAttention.available ∧
    actionItem ∉ systemAttention.organized := by
  simp [systemAttention, actionItem, perceptionItem, interpretationItem]

theorem systemAttentionIsNotAbsolute :
    ¬ ∃ absolute : AbsoluteAttention ToyPart systemBody,
      absolute.attention = systemAttention := by
  rintro ⟨absolute, attentionEqual⟩
  have allOrganized := absolute.allAvailableOrganized
  rw [attentionEqual] at allOrganized
  have separation := attentionDoesNotRequireAllAvailableItems
  exact separation.2 (allOrganized.symm ▸ separation.1)

theorem absoluteAttentionHasNoFocusIndependentAction :
    ∀ item, ¬ FocusIndependentAction systemAbsoluteAttention.attention item :=
  absoluteAttentionInhibitsFocusIndependentAction systemAbsoluteAttention

end DanielOntology.AttentionLoveCareProposal
