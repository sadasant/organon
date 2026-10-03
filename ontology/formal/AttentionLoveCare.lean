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
  selectionIsGoverned : selection.selected ∈ governedTransformations
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
  moment : State (Feature × Context)
  momentWithinBody : moment ∈ body.states
  focalRepresentation : Feature
  contrastRepresentation : Feature
  focalDifference : contrastRepresentation ≠ focalRepresentation
  available : List (AttentionItem (Feature × Context))
  availableNonempty : available ≠ []
  availableUnique : available.Nodup
  organized : List (AttentionItem (Feature × Context))
  organizedWithinAvailable : ∀ item, item ∈ organized → item ∈ available
  countedOnce : ∃ enumeration,
    enumeration.Perm available ∧ organized.Sublist enumeration
  resultsAtOrBeforeMoment : ∀ item, item ∈ organized →
    item.result = moment ∨ entity.persistenceDirection.before item.result moment
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
  indexedAtState : ∀ state, state ∈ states → (attentionAt state).moment = state
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
  allAvailableOrganized : ∀ item, item ∈ attention.available →
    item ∈ attention.organized

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
  exact absolute.allAvailableOrganized item available

structure Love
    (Part : Type u)
    {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)}
    (body : Body Part entity) where
  beloved : Entity (Feature × Context)
  belovedIsOther : beloved ≠ entity
  belovedIdentityIsOther : beloved.identity ≠ entity.identity
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
  caredForIdentityIsOther : caredFor.identity ≠ entity.identity
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
      (boundaryAdmitted : ∀ protection, protection ∈ target.boundary.constraints →
        protection.permits action)
  | agency
      (options : List (Transformation target.persistenceDirection))
      (nonempty : options ≠ [])
      (retainedAfterAction : ∀ transformation, transformation ∈ options →
        transformation.input = action.output)
      (inputPreserved : target.identity.holds action.output)
      (admitted : ∀ transformation, transformation ∈ options →
        constraint.permits transformation)
      (identityPreserved : ∀ transformation, transformation ∈ options →
        target.identity.holds transformation.output)
  | selfDetermination
      (first second : Transformation target.persistenceDirection)
      (distinct : first ≠ second)
      (firstRetainedAfterAction : first.input = action.output)
      (secondRetainedAfterAction : second.input = action.output)
      (inputPreserved : target.identity.holds action.output)
      (firstAdmitted : constraint.permits first)
      (secondAdmitted : constraint.permits second)
      (firstPreserved : target.identity.holds first.output)
      (secondPreserved : target.identity.holds second.output)

structure Respect
    {Carrier : Type u}
    (actor target : Entity Carrier) where
  targetIsOther : target ≠ actor
  targetIdentityIsOther : target.identity ≠ actor.identity
  constraint : Constraint Carrier
  actionScope : Scope (Transformation actor.persistenceDirection)
  constrainedAction : Transformation actor.persistenceDirection
  actionInScope : actionScope.includes constrainedAction
  actionConstrained : constraint.permits constrainedAction
  protection : RespectProtection target constraint constrainedAction

theorem attentionDegreeBounded
    {Part : Type u} {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} {body : Body Part entity}
    (attention : Attention Part body) :
    attention.degreeNumerator ≤ attention.degreeDenominator ∧
    0 < attention.degreeDenominator ∧ attention.organized.Nodup := by
  rcases attention.countedOnce with ⟨enumeration, permutation, sublist⟩
  refine ⟨?_, ?_, sublist.nodup (attention.availableUnique.perm permutation.symm)⟩
  · rw [attention.degreeNumeratorExact, attention.degreeDenominatorExact,
      ← permutation.length_eq]
    exact sublist.length_le
  · rw [attention.degreeDenominatorExact]
    exact List.length_pos_iff.mpr attention.availableNonempty

theorem respectProtectionPreservesIdentity
    {Carrier : Type u} {target : Entity Carrier} {constraint : Constraint Carrier}
    {direction : Direction Carrier} {action : Transformation direction}
    (protection : RespectProtection target constraint action) :
    target.identity.holds action.output := by
  cases protection with
  | boundary inputPreserved boundaryAdmitted =>
    exact target.boundary.preserves action boundaryAdmitted inputPreserved
  | agency _ _ _ inputPreserved _ _ => exact inputPreserved
  | selfDetermination _ _ _ _ _ inputPreserved _ _ _ _ => exact inputPreserved

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
  selectionIsGoverned := by simp [systemSelection]
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
  moment := state true .returnHigh
  momentWithinBody := by simp [systemBody, systemPersistence]
  focalRepresentation := true
  contrastRepresentation := false
  focalDifference := by decide
  available := [perceptionItem, interpretationItem, actionItem]
  availableNonempty := by simp
  availableUnique := by simp [perceptionItem, interpretationItem, actionItem, AttentionItem.mk.injEq]
  organized := [perceptionItem, interpretationItem]
  organizedWithinAvailable := by simp
  countedOnce := ⟨_, List.Perm.refl _,
    .cons_cons _ (.cons_cons _ (.cons _ .slnil))⟩
  resultsAtOrBeforeMoment := by
    intro item member
    simp at member
    rcases member with rfl | rfl
    · exact Or.inr (by change 3 < 6; decide)
    · exact Or.inl rfl
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

def earlyAttention : Attention ToyPart systemBody where
  moment := state true .forwardHigh
  momentWithinBody := by simp [systemBody, systemPersistence]
  focalRepresentation := true
  contrastRepresentation := false
  focalDifference := by decide
  available := [perceptionItem]
  availableNonempty := by simp
  availableUnique := by simp
  organized := [perceptionItem]
  organizedWithinAvailable := by simp
  countedOnce := ⟨_, List.Perm.refl _, List.Sublist.refl _⟩
  resultsAtOrBeforeMoment := by intro item member; simp at member; subst item; exact Or.inl rfl
  organizingContribution := contributionForItem
  organizedByDifference := by intro item member; simp at member; subst item; exact ⟨rfl, rfl⟩
  contributionProducesResult := by intro item member; simp at member; subst item; rfl
  degreeNumerator := 1
  degreeDenominator := 1
  degreeNumeratorExact := rfl
  degreeDenominatorExact := rfl

def systemSustainedAttention : SustainedAttention ToyPart systemBody where
  states := [state true .forwardHigh, state true .returnHigh]
  hasChangingStates := ⟨_, _, [], rfl⟩
  statesWithinBody := by simp [systemBody, systemPersistence]
  statesOrdered := by
    simp [OrderedBy, systemEntity, systemDirection, state, Stage.rank]
  attentionAt := fun current =>
    if current.value.2 = .forwardHigh then earlyAttention else systemAttention
  indexedAtState := by
    intro current member
    simp at member
    rcases member with rfl | rfl <;> rfl
  maintained := by
    intro current member
    simp at member
    rcases member with rfl | rfl <;> simp [state, earlyAttention, systemAttention]
  commonFocalRepresentation := true
  commonContrastRepresentation := false
  sameDifference := by
    intro current member
    simp at member
    rcases member with rfl | rfl <;> simp [state, earlyAttention, systemAttention]

def systemAbsoluteAttention : AbsoluteAttention ToyPart systemBody where
  attention := {
    systemAttention with
    organized := [perceptionItem, interpretationItem, actionItem]
    organizedWithinAvailable := by simp [systemAttention]
    countedOnce := ⟨_, List.Perm.refl _, List.Sublist.refl _⟩
    resultsAtOrBeforeMoment := by
      intro item member
      simp at member
      rcases member with rfl | rfl | rfl
      · exact Or.inr (by change 3 < 6; decide)
      · exact Or.inl rfl
      · exact Or.inl rfl
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
  allAvailableOrganized := by intro item member; exact member

def belovedIdentity : Invariant Carrier :=
  ⟨fun current => current.value.2 = .forwardInput ∨
    current.value.2 = .forwardLow ∨ current.value.2 = .forwardHigh⟩

def belovedConstraint : Constraint Carrier :=
  ⟨fun transformation => belovedIdentity.holds transformation.output⟩

def belovedBoundary : Boundary Carrier belovedIdentity where
  constraints := [belovedConstraint]
  preserves := by
    intro direction transformation admitted _
    exact admitted belovedConstraint (by simp)

def belovedPersistence : PersistenceWitness systemDirection where
  states := [state false .forwardInput, state false .forwardLow, state true .forwardHigh]
  hasTransition := ⟨_, _, [_], rfl⟩
  invariant := belovedIdentity
  invariantHolds := by
    intro current member
    simp at member
    rcases member with rfl | rfl | rfl <;> simp [belovedIdentity, state]
  ordered := by simp [OrderedBy, systemDirection, state, Stage.rank]

def belovedEntity : Entity Carrier where
  identity := belovedIdentity
  boundary := belovedBoundary
  persistenceDirection := systemDirection
  persistence := belovedPersistence
  persistenceNamesIdentity := rfl
  current := state true .forwardHigh
  currentInPersistence := by simp [belovedPersistence]
  identityHolds := by simp [belovedIdentity, state]

theorem belovedIdentityIsOther : belovedEntity.identity ≠ systemEntity.identity := by
  intro equal
  have distinction := congrArg (fun identity => identity.holds (state true .returnHigh)) equal
  simp [belovedEntity, belovedIdentity, systemEntity, systemIdentity, state] at distinction

theorem belovedIsOther : belovedEntity ≠ systemEntity := by
  intro equal
  exact belovedIdentityIsOther (congrArg Entity.identity equal)

def systemLove : Love ToyPart systemBody where
  beloved := belovedEntity
  belovedIsOther := belovedIsOther
  belovedIdentityIsOther := belovedIdentityIsOther
  attention := systemSustainedAttention
  belovedRepresentation := true
  belovedDenotation := ⟨true, belovedEntity⟩
  denotationNamesBeloved := ⟨rfl, rfl⟩
  attentionDirectedTowardBeloved := rfl

def systemCare : Care ToyPart systemBody where
  caredFor := belovedEntity
  caredForIsOther := belovedIsOther
  caredForIdentityIsOther := belovedIdentityIsOther
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
  targetIdentityIsOther := belovedIdentityIsOther
  constraint := internalOnly
  actionScope := ⟨fun transformation => transformation = forwardLowTransform⟩
  constrainedAction := forwardLowTransform
  actionInScope := rfl
  actionConstrained := by
    simp [internalOnly, systemIdentity, forwardLowTransform, transform, state]
  protection := .boundary
    (by simp [belovedEntity, belovedIdentity, forwardLowTransform, transform, state])
    (by
      intro protection member
      simp [belovedEntity, belovedBoundary] at member
      subst protection
      simp [belovedConstraint, belovedIdentity, forwardLowTransform, transform, state])

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
  exact separation.2 (allOrganized actionItem separation.1)

theorem absoluteAttentionHasNoFocusIndependentAction :
    ∀ item, ¬ FocusIndependentAction systemAbsoluteAttention.attention item :=
  absoluteAttentionInhibitsFocusIndependentAction systemAbsoluteAttention

/-! ## Adversarial regression witnesses -/

theorem attentionCannotCountOneItemTwice
    {Part : Type u} {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} {body : Body Part entity}
    (attention : Attention Part body) (item : AttentionItem (Feature × Context)) :
    attention.organized ≠ [item, item] := by
  intro duplicate
  have unique := (attentionDegreeBounded attention).2.2
  rw [duplicate] at unique
  simp at unique

theorem organizedResultCannotBeFuture
    {Part : Type u} {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} {body : Body Part entity}
    (attention : Attention Part body) (item : AttentionItem (Feature × Context))
    (organized : item ∈ attention.organized) :
    ¬ entity.persistenceDirection.before attention.moment item.result := by
  intro future
  rcases attention.resultsAtOrBeforeMoment item organized with equal | earlier
  · rw [equal] at future
    exact entity.persistenceDirection.asymmetric future future
  · exact entity.persistenceDirection.asymmetric future earlier

def reorderedAbsoluteAttention : AbsoluteAttention ToyPart systemBody where
  attention := {
    systemAbsoluteAttention.attention with
    organized := [actionItem, interpretationItem, perceptionItem]
    organizedWithinAvailable := by simp [systemAbsoluteAttention, systemAttention]
    countedOnce := ⟨_, List.reverse_perm _, List.Sublist.refl _⟩
    resultsAtOrBeforeMoment := by
      intro item member
      simp at member
      rcases member with rfl | rfl | rfl
      · exact Or.inl rfl
      · exact Or.inl rfl
      · exact Or.inr (by change 3 < 6; decide)
    organizedByDifference := by
      intro item member
      simp at member
      rcases member with rfl | rfl | rfl <;> exact ⟨rfl, rfl⟩
    contributionProducesResult := by
      intro item member
      simp at member
      rcases member with rfl | rfl | rfl <;> rfl
    degreeNumeratorExact := rfl
  }
  allAvailableOrganized := by simp [systemAbsoluteAttention, systemAttention]

theorem absoluteAttentionDoesNotDependOnEnumerationOrder :
    reorderedAbsoluteAttention.attention.organized ≠
      reorderedAbsoluteAttention.attention.available ∧
    (∀ item, ¬ FocusIndependentAction reorderedAbsoluteAttention.attention item) := by
  constructor
  · intro equal
    have first := congrArg List.head? equal
    simp [reorderedAbsoluteAttention, systemAbsoluteAttention, systemAttention,
      actionItem, perceptionItem] at first
  · exact absoluteAttentionInhibitsFocusIndependentAction reorderedAbsoluteAttention

def earlierSystemSnapshot : Entity Carrier := {
  systemEntity with
  current := state true .forwardHigh
  currentInPersistence := by simp [systemEntity, systemPersistence]
  identityHolds := by simp [systemEntity, systemIdentity, state]
}

theorem differentCurrentDoesNotEstablishAnotherIdentity :
    earlierSystemSnapshot ≠ systemEntity ∧
    earlierSystemSnapshot.identity = systemEntity.identity := by
  constructor
  · intro equal
    have currents := congrArg Entity.current equal
    simp [earlierSystemSnapshot, systemEntity, state] at currents
  · rfl

theorem respectRejectsIdentityDestroyingAction :
    internalOnly.permits returnChangeTransform ∧
    ¬ Nonempty (RespectProtection belovedEntity internalOnly returnChangeTransform) := by
  constructor
  · simp [internalOnly, systemIdentity, returnChangeTransform, state]
  · rintro ⟨protection⟩
    have preserved := respectProtectionPreservesIdentity protection
    simp [belovedEntity, belovedIdentity, returnChangeTransform, state] at preserved

def systemAgencyRespect : Respect systemEntity belovedEntity := {
  systemRespect with
  protection := .agency [forwardChangeTransform] (by simp)
    (by intro transformation member; simp at member; subst transformation; rfl)
    (by simp [systemRespect, belovedEntity, belovedIdentity, forwardLowTransform, transform, state])
    (by intro transformation member; simp at member; subst transformation;
        simp [systemRespect, internalOnly, systemIdentity, forwardChangeTransform, state])
    (by intro transformation member; simp at member; subst transformation;
        simp [belovedEntity, belovedIdentity, forwardChangeTransform, state])
}

def alternativeForwardChoice := transform false .forwardLow .forwardHigh (by decide)

def systemSelfDeterminationRespect : Respect systemEntity belovedEntity := {
  systemRespect with
  protection := .selfDetermination forwardChangeTransform alternativeForwardChoice
    (by
      intro equal
      have outputs := congrArg Transformation.output equal
      simp [forwardChangeTransform, alternativeForwardChoice, transform, state] at outputs)
    rfl rfl
    (by simp [systemRespect, belovedEntity, belovedIdentity, forwardLowTransform, transform, state])
    (by simp [systemRespect, internalOnly, systemIdentity, forwardChangeTransform, state])
    (by simp [systemRespect, internalOnly, systemIdentity, alternativeForwardChoice, transform, state])
    (by simp [belovedEntity, belovedIdentity, forwardChangeTransform, state])
    (by simp [belovedEntity, belovedIdentity, alternativeForwardChoice, transform, state])
}

end DanielOntology.AttentionLoveCareProposal
