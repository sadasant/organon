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

structure Intention
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

inductive AttentionChannel where
  | perception
  | interpretation
  | action
deriving DecidableEq, Repr

/-- A declared partition of channel identities, with state-indexed availability. -/
structure ChannelInventory
    (Part : Type u)
    {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} (body : Body Part entity) where
  Channel : Type u
  kind : Channel → AttentionChannel
  availabilityAt : State (Feature × Context) → Specification Channel

/-- Local participant classification, insensitive to a current-state update.
Its parity with canonical numerical individuation remains gated. -/
structure EntityIndividuation (Carrier : Type u) where
  participant : Entity Carrier → Nat
  ignoresCurrent : ∀ (entity : Entity Carrier) (current : State Carrier)
    (within : current ∈ entity.persistence.states) (holds : entity.identity.holds current),
    participant ({ entity with
      current := current
      currentInPersistence := within
      identityHolds := holds }) = participant entity


/-- Organization is evaluated from the channel's causal data, independently of
its membership in any counted enumeration. Canonical channel parity remains gated. -/
def ContributionOrganizesChannel
    {Feature : Type v} {Context : Type w}
    {direction : Direction (Feature × Context)}
    {feeding : FeedRelation (Feature × Context)}
    (moment : State (Feature × Context)) (contrast focal : Feature)
    (result : State (Feature × Context))
    (contribution : CausalContribution Feature Context direction feeding) : Prop :=
  contribution.leftEndpoints.first.input.value.1 = contrast ∧
  contribution.rightEndpoints.first.input.value.1 = focal ∧
  contribution.downstreamChange.transformation.output = result ∧
  (result = moment ∨ direction.before result moment)

/-- The finite declared causal domain is independent of the counted list and
of the particular contribution selected as an organization witness. -/
def ChannelOrganizedByDifference
    {Feature : Type v} {Context : Type w}
    {direction : Direction (Feature × Context)}
    {feeding : FeedRelation (Feature × Context)}
    (moment : State (Feature × Context)) (contrast focal : Feature)
    (result : State (Feature × Context))
    (contributions : List (CausalContribution Feature Context direction feeding)) : Prop :=
  ∃ contribution, contribution ∈ contributions ∧
    ContributionOrganizesChannel moment contrast focal result contribution

@[simp] theorem channelOrganizationSingleton
    {Feature : Type v} {Context : Type w}
    {direction : Direction (Feature × Context)}
    {feeding : FeedRelation (Feature × Context)}
    (moment : State (Feature × Context)) (contrast focal : Feature)
    (result : State (Feature × Context))
    (contribution : CausalContribution Feature Context direction feeding) :
    ChannelOrganizedByDifference moment contrast focal result [contribution] ↔
      ContributionOrganizesChannel moment contrast focal result contribution := by
  simp [ChannelOrganizedByDifference]

structure Attention
    (Part : Type u)
    {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)}
    (body : Body Part entity) where
  moment : State (Feature × Context)
  momentWithinBody : moment ∈ body.states
  inventory : ChannelInventory Part body
  result : inventory.Channel → State (Feature × Context)
  focalRepresentation : Feature
  contrastRepresentation : Feature
  focalDifference : contrastRepresentation ≠ focalRepresentation
  available : List inventory.Channel
  availableExact : ∀ channel, channel ∈ available ↔
    (inventory.availabilityAt moment).conforms channel
  availableNonempty : available ≠ []
  availableUnique : available.Nodup
  organized : List inventory.Channel
  organizedWithinAvailable : ∀ item, item ∈ organized → item ∈ available
  countedOnce : ∃ enumeration,
    enumeration.Perm available ∧ organized.Sublist enumeration
  resultsAtOrBeforeMoment : ∀ item, item ∈ organized →
    result item = moment ∨ entity.persistenceDirection.before (result item) moment
  organizingContribution : inventory.Channel →
    CausalContribution Feature Context entity.persistenceDirection body.feeding
  causalContributions : inventory.Channel →
    List (CausalContribution Feature Context entity.persistenceDirection body.feeding)
  organizingContributionDeclared : ∀ item, item ∈ organized →
    organizingContribution item ∈ causalContributions item
  organizedByDifference : ∀ item, item ∈ organized →
    (organizingContribution item).leftEndpoints.first.input.value.1 =
        contrastRepresentation ∧
    (organizingContribution item).rightEndpoints.first.input.value.1 =
        focalRepresentation
  contributionProducesResult : ∀ item, item ∈ organized →
    (organizingContribution item).downstreamChange.transformation.output =
      result item
  organizedExact : ∀ item, item ∈ organized ↔
    item ∈ available ∧ ChannelOrganizedByDifference moment
      contrastRepresentation focalRepresentation (result item) (causalContributions item)
  degreeNumerator : Nat
  degreeDenominator : Nat
  degreeNumeratorExact : degreeNumerator = organized.length
  degreeDenominatorExact : degreeDenominator = available.length

structure SustainedAttention
    (Part : Type u)
    {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)}
    (body : Body Part entity) where
  commonInventory : ChannelInventory Part body
  states : List (State (Feature × Context))
  hasChangingStates : ∃ first second rest, states = first :: second :: rest
  statesWithinBody : ∀ state, state ∈ states → state ∈ body.states
  statesOrdered : OrderedBy entity.persistenceDirection.before states
  attentionAt : State (Feature × Context) → Attention Part body
  sameInventory : ∀ state, state ∈ states → (attentionAt state).inventory = commonInventory
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
    (item : attention.inventory.Channel) : Prop :=
  attention.inventory.kind item = .action ∧ item ∈ attention.available ∧
    ¬ ChannelOrganizedByDifference attention.moment
      attention.contrastRepresentation attention.focalRepresentation
      (attention.result item) (attention.causalContributions item)

theorem absoluteAttentionInhibitsFocusIndependentAction
    {Part : Type u} {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} {body : Body Part entity}
    (absolute : AbsoluteAttention Part body) :
    ∀ item, ¬ FocusIndependentAction absolute.attention item := by
  intro item independent
  rcases independent with ⟨_, available, notOrganized⟩
  apply notOrganized
  exact ((absolute.attention.organizedExact item).mp
    (absolute.allAvailableOrganized item available)).2

structure Love
    (Part : Type u)
    {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)}
    (body : Body Part entity) where
  beloved : Entity (Feature × Context)
  belovedIsOther : beloved ≠ entity
  individuation : EntityIndividuation (Feature × Context)
  belovedParticipantIsOther : individuation.participant beloved ≠ individuation.participant entity
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
  individuation : EntityIndividuation (Feature × Context)
  caredForParticipantIsOther : individuation.participant caredFor ≠ individuation.participant entity
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
  actionItem : attention.inventory.Channel
  itemIsAction : attention.inventory.kind actionItem = .action
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
  individuation : EntityIndividuation Carrier
  targetParticipantIsOther : individuation.participant target ≠ individuation.participant actor
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

inductive ToyChannel where
  | sensor | secondSensor | interpreter | effector
deriving DecidableEq, Repr

def perceptionItem : ToyChannel := .sensor
def interpretationItem : ToyChannel := .interpreter
def actionItem : ToyChannel := .effector

def toyKind : ToyChannel → AttentionChannel
  | .sensor | .secondSensor => .perception
  | .interpreter => .interpretation
  | .effector => .action

def toyResult : ToyChannel → State Carrier
  | .sensor | .secondSensor => state true .forwardHigh
  | .interpreter | .effector => state true .returnHigh

def toyAvailable (moment : State Carrier) (channel : ToyChannel) : Bool :=
  channel == .sensor ||
    (moment.value.2 == .returnHigh && (channel == .interpreter || channel == .effector))

def toyAvailability (moment : State Carrier) : Specification ToyChannel where
  scope := ⟨fun _ => True⟩
  conforms := fun channel => toyAvailable moment channel = true
  decideConformity := toyAvailable moment
  conformityCorrect := by intro channel; rfl
  conformityWithinScope := by intro channel _; trivial

def systemInventory : ChannelInventory ToyPart systemBody where
  Channel := ToyChannel
  kind := toyKind
  availabilityAt := toyAvailability

def contributionForItem : ToyChannel →
    CausalContribution Bool Stage systemDirection unconstrainedFeed
  | .sensor | .secondSensor => forwardContribution
  | .interpreter | .effector => returnContribution

def independentActionLeft : Transformation systemDirection where
  input := state true .returnInput
  output := state false .returnLow
  advances := by change 4 < 5; decide

def independentActionRight : Transformation systemDirection where
  input := state false .returnInput
  output := state true .returnHigh
  advances := by change 4 < 6; decide

def independentActionContribution :
    CausalContribution Bool Stage systemDirection unconstrainedFeed where
  leftPath := singletonPath independentActionLeft
  rightPath := singletonPath independentActionRight
  leftEndpoints := singletonEndpoints independentActionLeft
  rightEndpoints := singletonEndpoints independentActionRight
  sameDeclaredContext := rfl
  inputDiffers := by decide
  downstreamChange := ⟨returnChangeTransform, by simp [returnChangeTransform, state]⟩
  changeStartsAt := rfl
  changeEndsAt := rfl

def partialContributionForItem : ToyChannel →
    CausalContribution Bool Stage systemDirection unconstrainedFeed
  | .effector => independentActionContribution
  | channel => contributionForItem channel

def focalCausalDomain (channel : ToyChannel) := [contributionForItem channel]
def partialCausalDomain (channel : ToyChannel) := [partialContributionForItem channel]

def changedResultContribution : ToyChannel →
    CausalContribution Bool Stage systemDirection unconstrainedFeed
  | .effector => independentActionContribution
  | _ => returnContribution

def changedResultCausalDomain (channel : ToyChannel) := [changedResultContribution channel]

def systemAttention : Attention ToyPart systemBody where
  moment := state true .returnHigh
  momentWithinBody := by simp [systemBody, systemPersistence]
  inventory := systemInventory
  result := toyResult
  focalRepresentation := true
  contrastRepresentation := false
  focalDifference := by decide
  available := [perceptionItem, interpretationItem, actionItem]
  availableExact := by
    intro channel
    change channel ∈ ([perceptionItem, interpretationItem, actionItem] : List ToyChannel) ↔
      toyAvailable (state true .returnHigh) channel = true
    cases channel <;> decide
  availableNonempty := by simp
  availableUnique := by simp [perceptionItem, interpretationItem, actionItem]
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
  organizingContribution := partialContributionForItem
  causalContributions := partialCausalDomain
  organizingContributionDeclared := by intro channel _; exact List.mem_singleton_self _
  organizedByDifference := by
    intro item member
    simp at member
    rcases member with rfl | rfl <;> exact ⟨rfl, rfl⟩
  contributionProducesResult := by
    intro item member
    simp at member
    rcases member with rfl | rfl <;> rfl
  organizedExact := by
      change ∀ channel : ToyChannel,
        channel ∈ [perceptionItem, interpretationItem] ↔
          channel ∈ [perceptionItem, interpretationItem, actionItem] ∧
            ChannelOrganizedByDifference (state true .returnHigh) false true
              (toyResult channel) (partialCausalDomain channel)
      intro channel
      cases channel <;> simp only [partialCausalDomain, channelOrganizationSingleton] <;>
        dsimp only [ContributionOrganizesChannel,
        focalCausalDomain, partialCausalDomain, changedResultCausalDomain, changedResultContribution, partialContributionForItem,
        contributionForItem, toyResult, perceptionItem, interpretationItem, actionItem,
        independentActionContribution, independentActionLeft, independentActionRight,
        forwardContribution, returnContribution, singletonEndpoints, singletonPath,
        forwardLowTransform, forwardHighTransform, forwardChangeTransform, returnLowTransform,
        returnHighTransform, returnChangeTransform, transform, systemEntity, systemDirection,
        state, Stage.rank] <;> simp
  degreeNumerator := 2
  degreeDenominator := 3
  degreeNumeratorExact := rfl
  degreeDenominatorExact := rfl

def earlyAttention : Attention ToyPart systemBody where
  moment := state true .forwardHigh
  momentWithinBody := by simp [systemBody, systemPersistence]
  inventory := systemInventory
  result := toyResult
  focalRepresentation := true
  contrastRepresentation := false
  focalDifference := by decide
  available := [perceptionItem]
  availableExact := by
    intro channel
    change channel ∈ ([perceptionItem] : List ToyChannel) ↔
      toyAvailable (state true .forwardHigh) channel = true
    cases channel <;> decide
  availableNonempty := by simp
  availableUnique := by simp
  organized := [perceptionItem]
  organizedWithinAvailable := by simp
  countedOnce := ⟨_, List.Perm.refl _, List.Sublist.refl _⟩
  resultsAtOrBeforeMoment := by intro item member; simp at member; subst item; exact Or.inl rfl
  organizingContribution := contributionForItem
  causalContributions := focalCausalDomain
  organizingContributionDeclared := by intro channel _; exact List.mem_singleton_self _
  organizedByDifference := by intro item member; simp at member; subst item; exact ⟨rfl, rfl⟩
  contributionProducesResult := by intro item member; simp at member; subst item; rfl
  organizedExact := by
      change ∀ channel : ToyChannel,
        channel ∈ [perceptionItem] ↔
          channel ∈ [perceptionItem] ∧
            ChannelOrganizedByDifference (state true .forwardHigh) false true
              (toyResult channel) (focalCausalDomain channel)
      intro channel
      cases channel <;> simp only [focalCausalDomain, channelOrganizationSingleton] <;>
        dsimp only [ContributionOrganizesChannel,
        focalCausalDomain, partialCausalDomain, changedResultCausalDomain, changedResultContribution, partialContributionForItem,
        contributionForItem, toyResult, perceptionItem, interpretationItem, actionItem,
        independentActionContribution, independentActionLeft, independentActionRight,
        forwardContribution, returnContribution, singletonEndpoints, singletonPath,
        forwardLowTransform, forwardHighTransform, forwardChangeTransform, returnLowTransform,
        returnHighTransform, returnChangeTransform, transform, systemEntity, systemDirection,
        state, Stage.rank] <;> simp
  degreeNumerator := 1
  degreeDenominator := 1
  degreeNumeratorExact := rfl
  degreeDenominatorExact := rfl

def systemSustainedAttention : SustainedAttention ToyPart systemBody where
  commonInventory := systemInventory
  states := [state true .forwardHigh, state true .returnHigh]
  hasChangingStates := ⟨_, _, [], rfl⟩
  statesWithinBody := by simp [systemBody, systemPersistence]
  statesOrdered := by
    simp [OrderedBy, systemEntity, systemDirection, state, Stage.rank]
  attentionAt := fun current =>
    if current.value.2 = .forwardHigh then earlyAttention else systemAttention
  sameInventory := by
    intro current member
    simp at member
    rcases member with rfl | rfl <;> rfl
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
    organizingContribution := contributionForItem
    causalContributions := focalCausalDomain
    organizingContributionDeclared := by intro channel _; exact List.mem_singleton_self _
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
    organizedExact := by
      change ∀ channel : ToyChannel,
        channel ∈ [perceptionItem, interpretationItem, actionItem] ↔
          channel ∈ [perceptionItem, interpretationItem, actionItem] ∧
            ChannelOrganizedByDifference (state true .returnHigh) false true
              (toyResult channel) (focalCausalDomain channel)
      intro channel
      cases channel <;> simp only [focalCausalDomain, channelOrganizationSingleton] <;>
        dsimp only [ContributionOrganizesChannel,
        focalCausalDomain, partialCausalDomain, changedResultCausalDomain, changedResultContribution, partialContributionForItem,
        contributionForItem, toyResult, perceptionItem, interpretationItem, actionItem,
        independentActionContribution, independentActionLeft, independentActionRight,
        forwardContribution, returnContribution, singletonEndpoints, singletonPath,
        forwardLowTransform, forwardHighTransform, forwardChangeTransform, returnLowTransform,
        returnHighTransform, returnChangeTransform, transform, systemEntity, systemDirection,
        state, Stage.rank, systemAttention] <;> simp
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

def historyIndividuation : EntityIndividuation Carrier where
  participant := fun entity => entity.persistence.states.length
  ignoresCurrent := by intro entity current within holds; rfl

def systemLove : Love ToyPart systemBody where
  beloved := belovedEntity
  belovedIsOther := belovedIsOther
  individuation := historyIndividuation
  belovedParticipantIsOther := by decide
  attention := systemSustainedAttention
  belovedRepresentation := true
  belovedDenotation := ⟨true, belovedEntity⟩
  denotationNamesBeloved := ⟨rfl, rfl⟩
  attentionDirectedTowardBeloved := rfl

def systemCare : Care ToyPart systemBody where
  caredFor := belovedEntity
  caredForIsOther := belovedIsOther
  individuation := historyIndividuation
  caredForParticipantIsOther := by decide
  attendedState := belovedEntity.current
  attendedStateInHistory := belovedEntity.currentInPersistence
  targetRepresentation := true
  targetDenotation := ⟨true, (belovedEntity, belovedEntity.current)⟩
  denotationNamesTargetState := ⟨rfl, rfl⟩
  attention := systemAbsoluteAttention.attention
  attentionTargetsState := rfl
  actionItem := actionItem
  itemIsAction := rfl
  actionAvailable := by
    change (.effector : ToyChannel) ∈ ([.sensor, .interpreter, .effector] : List ToyChannel)
    decide
  actionOrganizedByAttention := by
    change (.effector : ToyChannel) ∈ ([.sensor, .interpreter, .effector] : List ToyChannel)
    decide

def systemRespect : Respect systemEntity belovedEntity where
  targetIsOther := belovedIsOther
  individuation := historyIndividuation
  targetParticipantIsOther := by decide
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
  change (.effector : ToyChannel) ∈ ([.sensor, .interpreter, .effector] : List ToyChannel) ∧
    (.effector : ToyChannel) ∉ ([.sensor, .interpreter] : List ToyChannel)
  decide

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
    (attention : Attention Part body) (item : attention.inventory.Channel) :
    attention.organized ≠ [item, item] := by
  intro duplicate
  have unique := (attentionDegreeBounded attention).2.2
  rw [duplicate] at unique
  simp at unique

theorem organizedResultCannotBeFuture
    {Part : Type u} {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} {body : Body Part entity}
    (attention : Attention Part body) (item : attention.inventory.Channel)
    (organized : item ∈ attention.organized) :
    ¬ entity.persistenceDirection.before attention.moment (attention.result item) := by
  intro future
  rcases attention.resultsAtOrBeforeMoment item organized with equal | earlier
  · rw [equal] at future
    exact entity.persistenceDirection.asymmetric future future
  · exact entity.persistenceDirection.asymmetric future earlier

def reorderedAbsoluteAttention : AbsoluteAttention ToyPart systemBody where
  attention := {
    systemAbsoluteAttention.attention with
    organizingContributionDeclared := by intro channel _; exact List.mem_singleton_self _
    organized := [actionItem, interpretationItem, perceptionItem]
    organizedWithinAvailable := by
      intro item member
      change item ∈ ([perceptionItem, interpretationItem, actionItem] : List ToyChannel).reverse at member
      change item ∈ ([perceptionItem, interpretationItem, actionItem] : List ToyChannel)
      exact (List.reverse_perm _).mem_iff.mp member
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
    organizedExact := by
      change ∀ channel : ToyChannel,
        channel ∈ [actionItem, interpretationItem, perceptionItem] ↔
          channel ∈ [perceptionItem, interpretationItem, actionItem] ∧
            ChannelOrganizedByDifference (state true .returnHigh) false true
              (toyResult channel) (focalCausalDomain channel)
      intro channel
      cases channel <;> simp only [focalCausalDomain, channelOrganizationSingleton] <;>
        dsimp only [ContributionOrganizesChannel,
        focalCausalDomain, partialCausalDomain, changedResultCausalDomain, changedResultContribution, partialContributionForItem,
        contributionForItem, toyResult, perceptionItem, interpretationItem, actionItem,
        independentActionContribution, independentActionLeft, independentActionRight,
        forwardContribution, returnContribution, singletonEndpoints, singletonPath,
        forwardLowTransform, forwardHighTransform, forwardChangeTransform, returnLowTransform,
        returnHighTransform, returnChangeTransform, transform, systemEntity, systemDirection,
        state, Stage.rank, systemAttention, systemAbsoluteAttention] <;> simp
    degreeNumeratorExact := rfl
  }
  allAvailableOrganized := by
    intro item member
    change item ∈ ([perceptionItem, interpretationItem, actionItem] : List ToyChannel) at member
    change item ∈ ([perceptionItem, interpretationItem, actionItem] : List ToyChannel).reverse
    exact (List.reverse_perm _).mem_iff.mpr member


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

/-! ## Review blockers: scoped availability and numerical individuation -/

def sharedCriterionPersistence : PersistenceWitness systemDirection := {
  belovedPersistence with
  invariant := systemIdentity
  invariantHolds := by
    intro current member
    simp [belovedPersistence] at member
    rcases member with rfl | rfl | rfl <;> simp [systemIdentity, state]
}

def sharedCriterionEntity : Entity Carrier where
  identity := systemIdentity
  boundary := systemBoundary
  persistenceDirection := systemDirection
  persistence := sharedCriterionPersistence
  persistenceNamesIdentity := rfl
  current := state true .forwardHigh
  currentInPersistence := by simp [sharedCriterionPersistence, belovedPersistence]
  identityHolds := by simp [systemIdentity, state]

theorem sharedCriterionIsOther : sharedCriterionEntity ≠ systemEntity := by
  intro equal
  have histories := congrArg (fun entity => entity.persistence.states.length) equal
  change 3 = 6 at histories
  contradiction

def sharedCriterionLove : Love ToyPart systemBody := {
  systemLove with
  beloved := sharedCriterionEntity
  belovedIsOther := sharedCriterionIsOther
  belovedParticipantIsOther := by decide
  belovedDenotation := ⟨true, sharedCriterionEntity⟩
  denotationNamesBeloved := ⟨rfl, rfl⟩
}

def sharedCriterionCare : Care ToyPart systemBody := {
  systemCare with
  caredFor := sharedCriterionEntity
  caredForIsOther := sharedCriterionIsOther
  caredForParticipantIsOther := by decide
  attendedState := sharedCriterionEntity.current
  attendedStateInHistory := sharedCriterionEntity.currentInPersistence
  targetDenotation := ⟨true, (sharedCriterionEntity, sharedCriterionEntity.current)⟩
  denotationNamesTargetState := ⟨rfl, rfl⟩
}

def sharedCriterionRespect : Respect systemEntity sharedCriterionEntity where
  targetIsOther := sharedCriterionIsOther
  individuation := historyIndividuation
  targetParticipantIsOther := by decide
  constraint := internalOnly
  actionScope := ⟨fun transformation => transformation = forwardLowTransform⟩
  constrainedAction := forwardLowTransform
  actionInScope := rfl
  actionConstrained := by simp [internalOnly, systemIdentity, forwardLowTransform, transform, state]
  protection := .boundary
    (by simp [sharedCriterionEntity, systemIdentity, forwardLowTransform, transform, state])
    (by
      intro constraint member
      simp [sharedCriterionEntity, systemBoundary] at member
      subst constraint
      simp [internalOnly, systemIdentity, forwardLowTransform, transform, state])

theorem othernessDoesNotRequireDifferentIdentityCriteria :
    sharedCriterionEntity.identity = systemEntity.identity ∧
    sharedCriterionLove.beloved = sharedCriterionEntity ∧
    sharedCriterionCare.caredFor = sharedCriterionEntity ∧
    Nonempty (Respect systemEntity sharedCriterionEntity) := by
  exact ⟨rfl, rfl, rfl, ⟨sharedCriterionRespect⟩⟩

theorem currentStateUpdateDoesNotChangeParticipant :
    historyIndividuation.participant earlierSystemSnapshot =
      historyIndividuation.participant systemEntity := by rfl

theorem omittedActionCannotSatisfyInventoryCoverage :
    ¬ (∀ channel : ToyChannel,
      channel ∈ [perceptionItem, interpretationItem] ↔
        (systemInventory.availabilityAt (state true .returnHigh)).conforms channel) := by
  intro coverage
  have action := (coverage .effector).mpr (by
    change toyAvailable (state true .returnHigh) .effector = true
    decide)
  have omitted : (.effector : ToyChannel) ∉ [perceptionItem, interpretationItem] := by decide
  exact omitted action

def sensorAvailability : Specification ToyChannel where
  scope := ⟨fun channel => channel = .sensor ∨ channel = .secondSensor⟩
  conforms := fun channel => channel = .sensor ∨ channel = .secondSensor
  decideConformity := fun channel => channel == .sensor || channel == .secondSensor
  conformityCorrect := by intro channel; cases channel <;> decide
  conformityWithinScope := by intro channel member; exact member

def twoSensorInventory : ChannelInventory ToyPart systemBody where
  Channel := ToyChannel
  kind := toyKind
  availabilityAt := fun _ => sensorAvailability

def twoSensorAttention : Attention ToyPart systemBody where
  moment := state true .forwardHigh
  momentWithinBody := by simp [systemBody, systemPersistence]
  inventory := twoSensorInventory
  result := toyResult
  focalRepresentation := true
  contrastRepresentation := false
  focalDifference := by decide
  available := [.sensor, .secondSensor]
  availableExact := by
    intro channel
    change channel ∈ ([.sensor, .secondSensor] : List ToyChannel) ↔
      channel = .sensor ∨ channel = .secondSensor
    exact List.mem_cons.trans (or_congr Iff.rfl List.mem_singleton)
  availableNonempty := by simp
  availableUnique := by
    change ([ToyChannel.sensor, ToyChannel.secondSensor] : List ToyChannel).Nodup
    decide
  organized := [.sensor, .secondSensor]
  organizedWithinAvailable := by intro channel member; exact member
  countedOnce := ⟨_, List.Perm.refl _, List.Sublist.refl _⟩
  resultsAtOrBeforeMoment := by
    intro channel member
    change channel ∈ ([.sensor, .secondSensor] : List ToyChannel) at member
    have split : channel = ToyChannel.sensor ∨ channel = ToyChannel.secondSensor :=
      (List.mem_cons.mp member).elim Or.inl (fun tail => Or.inr (List.mem_singleton.mp tail))
    rcases split with rfl | rfl <;> exact Or.inl rfl
  organizingContribution := contributionForItem
  causalContributions := focalCausalDomain
  organizingContributionDeclared := by intro channel _; exact List.mem_singleton_self _
  organizedByDifference := by
    intro channel member
    change channel ∈ ([.sensor, .secondSensor] : List ToyChannel) at member
    have split : channel = ToyChannel.sensor ∨ channel = ToyChannel.secondSensor :=
      (List.mem_cons.mp member).elim Or.inl (fun tail => Or.inr (List.mem_singleton.mp tail))
    rcases split with rfl | rfl <;> exact ⟨rfl, rfl⟩
  contributionProducesResult := by
    intro channel member
    change channel ∈ ([.sensor, .secondSensor] : List ToyChannel) at member
    have split : channel = ToyChannel.sensor ∨ channel = ToyChannel.secondSensor :=
      (List.mem_cons.mp member).elim Or.inl (fun tail => Or.inr (List.mem_singleton.mp tail))
    rcases split with rfl | rfl <;> rfl
  organizedExact := by
      change ∀ channel : ToyChannel,
        channel ∈ [.sensor, .secondSensor] ↔
          channel ∈ [.sensor, .secondSensor] ∧
            ChannelOrganizedByDifference (state true .forwardHigh) false true
              (toyResult channel) (focalCausalDomain channel)
      intro channel
      cases channel <;> simp only [focalCausalDomain, channelOrganizationSingleton] <;>
        dsimp only [ContributionOrganizesChannel,
        focalCausalDomain, partialCausalDomain, changedResultCausalDomain, changedResultContribution, partialContributionForItem,
        contributionForItem, toyResult, perceptionItem, interpretationItem, actionItem,
        independentActionContribution, independentActionLeft, independentActionRight,
        forwardContribution, returnContribution, singletonEndpoints, singletonPath,
        forwardLowTransform, forwardHighTransform, forwardChangeTransform, returnLowTransform,
        returnHighTransform, returnChangeTransform, transform, systemEntity, systemDirection,
        state, Stage.rank, systemAttention, systemAbsoluteAttention] <;> simp
  degreeNumerator := 2
  degreeDenominator := 2
  degreeNumeratorExact := rfl
  degreeDenominatorExact := rfl

theorem equalKindAndResultDoNotCollapseDistinctChannels :
    (ToyChannel.sensor ≠ ToyChannel.secondSensor) ∧
    toyKind .sensor = toyKind .secondSensor ∧
    toyResult .sensor = toyResult .secondSensor ∧
    twoSensorAttention.degreeNumerator = 2 ∧ twoSensorAttention.degreeDenominator = 2 := by
  exact ⟨by decide, rfl, rfl, rfl, rfl⟩

theorem absoluteAttentionPermitsFocusOrganizedAction :
    systemAbsoluteAttention.attention.inventory.kind actionItem = .action ∧
    actionItem ∈ systemAbsoluteAttention.attention.organized := by
  exact ⟨rfl, systemCare.actionOrganizedByAttention⟩

def changedResultAttention : Attention ToyPart systemBody := {
  systemAttention with
  result := fun _ => state true .returnHigh
  organizingContribution := changedResultContribution
  causalContributions := changedResultCausalDomain
  organizingContributionDeclared := by intro channel _; exact List.mem_singleton_self _
  organizedByDifference := by
    intro channel member
    change channel ∈ [perceptionItem, interpretationItem] at member
    rcases List.mem_cons.mp member with first | second
    · subst channel; exact ⟨rfl, rfl⟩
    · have equal := List.mem_singleton.mp second
      subst channel; exact ⟨rfl, rfl⟩
  contributionProducesResult := by
    intro channel member
    cases channel <;> rfl
  resultsAtOrBeforeMoment := by intro channel member; exact Or.inl rfl
  organizedExact := by
      change ∀ channel : ToyChannel,
        channel ∈ [perceptionItem, interpretationItem] ↔
          channel ∈ [perceptionItem, interpretationItem, actionItem] ∧
            ChannelOrganizedByDifference (state true .returnHigh) false true
              (state true .returnHigh)
              (changedResultCausalDomain channel)
      intro channel
      cases channel <;> simp only [changedResultCausalDomain, channelOrganizationSingleton] <;>
        dsimp only [ContributionOrganizesChannel,
        focalCausalDomain, partialCausalDomain, changedResultCausalDomain, changedResultContribution, partialContributionForItem,
        contributionForItem, toyResult, perceptionItem, interpretationItem, actionItem,
        independentActionContribution, independentActionLeft, independentActionRight,
        forwardContribution, returnContribution, singletonEndpoints, singletonPath,
        forwardLowTransform, forwardHighTransform, forwardChangeTransform, returnLowTransform,
        returnHighTransform, returnChangeTransform, transform, systemEntity, systemDirection,
        state, Stage.rank, systemAttention, systemAbsoluteAttention] <;> simp
}

theorem changingResultDoesNotReindividuateChannel :
    changedResultAttention.result perceptionItem ≠ systemAttention.result perceptionItem ∧
    changedResultAttention.available = systemAttention.available ∧
    changedResultAttention.degreeDenominator = systemAttention.degreeDenominator := by
  refine ⟨?_, rfl, rfl⟩
  intro equal
  have values := congrArg State.value equal
  simp [changedResultAttention, systemAttention, toyResult, perceptionItem, state] at values

/-! ## Exact numerator regressions -/

theorem attentionCannotOmitOrganizedChannel
    {Part : Type u} {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} {body : Body Part entity}
    (attention : Attention Part body) (item : attention.inventory.Channel)
    (available : item ∈ attention.available)
    (causal : ChannelOrganizedByDifference attention.moment
      attention.contrastRepresentation attention.focalRepresentation
      (attention.result item) (attention.causalContributions item)) :
    item ∈ attention.organized :=
  (attention.organizedExact item).mpr ⟨available, causal⟩

theorem partialActionHasDifferentUpstreamDifference :
    (systemAttention.organizingContribution actionItem).downstreamChange.transformation.output =
      systemAttention.result actionItem ∧
    ¬ ChannelOrganizedByDifference systemAttention.moment
      systemAttention.contrastRepresentation systemAttention.focalRepresentation
      (systemAttention.result actionItem) (systemAttention.causalContributions actionItem) := by
  constructor
  · rfl
  · change ¬ ChannelOrganizedByDifference (state true .returnHigh) false true
      (state true .returnHigh) [independentActionContribution]
    rw [channelOrganizationSingleton]
    intro organized
    have impossible : true = false := organized.1
    contradiction

theorem partialActionIsCausallyIndependent :
    FocusIndependentAction systemAttention actionItem := by
  exact ⟨rfl, attentionDoesNotRequireAllAvailableItems.1,
    partialActionHasDifferentUpstreamDifference.2⟩

theorem omittingOrganizedActionCannotSatisfyExactCoverage :
    ¬ (∀ channel : ToyChannel,
      channel ∈ [perceptionItem, interpretationItem] ↔
        channel ∈ systemAbsoluteAttention.attention.available ∧
          ChannelOrganizedByDifference systemAbsoluteAttention.attention.moment
            systemAbsoluteAttention.attention.contrastRepresentation
            systemAbsoluteAttention.attention.focalRepresentation
            (systemAbsoluteAttention.attention.result channel)
            (systemAbsoluteAttention.attention.causalContributions channel)) := by
  intro coverage
  have counted := (coverage actionItem).mpr (by
    exact (systemAbsoluteAttention.attention.organizedExact actionItem).mp
      (by change actionItem ∈ [perceptionItem, interpretationItem, actionItem]; decide))
  have omitted : actionItem ∉ [perceptionItem, interpretationItem] := by decide
  exact omitted counted

theorem emptyNumeratorCannotHideOrganizedChannel
    {Part : Type u} {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} {body : Body Part entity}
    (attention : Attention Part body) (item : attention.inventory.Channel)
    (available : item ∈ attention.available)
    (causal : ChannelOrganizedByDifference attention.moment
      attention.contrastRepresentation attention.focalRepresentation
      (attention.result item) (attention.causalContributions item)) :
    attention.degreeNumerator ≠ 0 := by
  have member := attentionCannotOmitOrganizedChannel attention item available causal
  rw [attention.degreeNumeratorExact]
  exact Nat.ne_of_gt (List.length_pos_iff.mpr (by
    intro empty
    rw [empty] at member
    exact List.not_mem_nil member))


/-- A nonfocal selected witness cannot hide a focal alternative in the same
fixed declared causal domain. Availability, moment, focus, and result are fixed. -/
theorem focalAlternativeCannotBeOmitted
    (organized : List ToyChannel)
    (exactCoverage : ∀ channel : ToyChannel,
      channel ∈ organized ↔
        channel ∈ [perceptionItem, interpretationItem, actionItem] ∧
          ChannelOrganizedByDifference (state true .returnHigh) false true
            (toyResult channel)
            [partialContributionForItem channel, contributionForItem channel]) :
    actionItem ∈ organized ∧
      ¬ ContributionOrganizesChannel (state true .returnHigh) false true
        (toyResult actionItem) (partialContributionForItem actionItem) := by
  constructor
  · apply (exactCoverage actionItem).mpr
    constructor
    · decide
    · refine ⟨returnContribution, ?_, ?_⟩
      · exact List.mem_cons.mpr (Or.inr (List.mem_singleton_self _))
      · exact ⟨rfl, rfl, rfl, Or.inl rfl⟩
  · intro selected
    have impossible : true = false := selected.1
    contradiction


/-- Holding the declared causal situation and measurement context fixed,
exact unique coverage fixes the numerator regardless of enumeration order. -/
theorem fixedCausalDataDeterminesNumerator
    {Part : Type u} {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} {body : Body Part entity}
    (inventory : ChannelInventory Part body)
    (moment : State (Feature × Context)) (contrast focal : Feature)
    (result : inventory.Channel → State (Feature × Context))
    (causalDomain : inventory.Channel →
      List (CausalContribution Feature Context entity.persistenceDirection body.feeding))
    (available first second : List inventory.Channel)
    (firstUnique : first.Nodup) (secondUnique : second.Nodup)
    (firstExact : ∀ item, item ∈ first ↔ item ∈ available ∧
      ChannelOrganizedByDifference moment contrast focal (result item) (causalDomain item))
    (secondExact : ∀ item, item ∈ second ↔ item ∈ available ∧
      ChannelOrganizedByDifference moment contrast focal (result item) (causalDomain item)) :
    first.length = second.length := by
  classical
  have sameMembers : ∀ item, item ∈ first ↔ item ∈ second :=
    fun item => (firstExact item).trans (secondExact item).symm
  have permutation : first.Perm second := List.perm_iff_count.mpr (by
    intro item
    rw [firstUnique.count, secondUnique.count]
    simp only [sameMembers item])
  exact permutation.length_eq

end DanielOntology.AttentionLoveCareProposal
