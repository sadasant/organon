import AttentionLoveCare

/-! Nonbinding reading draft. Persistent participant identity, operative-role
realization, full Sense uptake and canonical Agency remain explicit boundaries. -/
universe u v w
namespace DanielOntology.PR18ReviewDraft
open EmbodiedConsciousnessProposal AttentionLoveCareProposal

def Self {EntityId : Type u} (subject target : EntityId) : Prop := subject = target
inductive ParticipationRole where | operator | input deriving DecidableEq, Repr

structure Auto {EntityId : Type u} {Feature : Type v} {Context : Type w}
    (entity : EntityId) (direction : Direction (Feature × Context))
    (feeding : FeedRelation (Feature × Context)) where
  activity : Transformation direction
  contribution : CausalContribution Feature Context direction feeding
  roleSpecification : Specification (EntityId × ParticipationRole)
  operatorAdmitted : roleSpecification.conforms (entity, .operator)
  inputAloneExcluded : ¬ roleSpecification.conforms (entity, .input)
  organizingOccurrence : Transformation direction
  organizingInChangedPath : organizingOccurrence ∈ contribution.rightPath.steps
  resultExact : contribution.downstreamChange.transformation.output = activity.output
  constraint : Constraint (Feature × Context)
  activityAdmitted : constraint.permits activity

structure Governance {EntityId : Type u} {Feature : Type v} {Context : Type w}
    (direction : Direction (Feature × Context)) (feeding : FeedRelation (Feature × Context)) where
  operator : EntityId
  governed : EntityId
  representation : Feature
  contrast : Feature
  different : contrast ≠ representation
  contribution : CausalContribution Feature Context direction feeding
  upstream : contribution.leftEndpoints.first.input.value.1 = contrast ∧
    contribution.rightEndpoints.first.input.value.1 = representation
  selected : Transformation direction
  rejected : Transformation direction
  alternativesDistinct : selected ≠ rejected
  available : Specification (Transformation direction)
  selectedAvailable : available.conforms selected
  rejectedAvailable : available.conforms rejected
  constraint : Constraint (Feature × Context)
  selectedAdmitted : constraint.permits selected
  rejectedAdmitted : constraint.permits rejected
  denotation : Denotation Feature (State (Feature × Context))
  exactDenotation : denotation.expression = representation ∧ denotation.target = selected.output
  exactSelection : contribution.downstreamChange.transformation.output = selected.output

structure SelfGovernance {EntityId : Type u} {Feature : Type v} {Context : Type w}
    (direction : Direction (Feature × Context)) (feeding : FeedRelation (Feature × Context)) where
  governance : Governance (EntityId := EntityId) direction feeding
  reflexive : Self governance.operator governance.governed

structure Autogovernance {EntityId : Type u} {Feature : Type v} {Context : Type w}
    (direction : Direction (Feature × Context)) (feeding : FeedRelation (Feature × Context)) where
  selfGovernance : SelfGovernance (EntityId := EntityId) direction feeding
  operative : Auto selfGovernance.governance.operator direction feeding
  sameActivity : operative.activity = selfGovernance.governance.selected
  sameContribution : operative.contribution = selfGovernance.governance.contribution

structure Autonomy (Part : Type u)
    {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} (body : Body Part entity) where
  governance : Autogovernance (EntityId := Unit) entity.persistenceDirection body.feeding
  selectedWithinBody : governance.selfGovernance.governance.selected ∈ body.recurringTransformations
  interpretation : Transformation entity.persistenceDirection
  action : Transformation entity.persistenceDirection
  crossingOutput : body.environment.includes action.output
  selectionToInterpretation : CausalContribution Feature Context entity.persistenceDirection body.feeding
  selectedDifferenceUpstream : selectionToInterpretation.rightEndpoints.first.input =
    governance.selfGovernance.governance.selected.output
  interpretationIsChanged : selectionToInterpretation.downstreamChange.transformation = interpretation
  interpretationToAction : CausalContribution Feature Context entity.persistenceDirection body.feeding
  interpretationDifferenceUpstream : interpretationToAction.rightEndpoints.first.input = interpretation.output
  actionIsChanged : interpretationToAction.downstreamChange.transformation = action

structure PerceptionUptake (EntityId : Type u) (Expression : Type v) where
  perceiver : EntityId
  representation : Expression
  sensedRepresentation : Expression → Prop
  registeredThroughSense : sensedRepresentation representation
  conditionHistory : EntityId → Nat → Prop

structure SelfPerception {EntityId : Type u} {Expression : Type v}
    (uptake : PerceptionUptake EntityId Expression) where
  target : EntityId
  reflexive : Self uptake.perceiver target
  condition : Option Nat
  conditionWithinHistory : ∀ value, value ∈ condition → uptake.conditionHistory target value
  denotation : Denotation Expression (EntityId × Option Nat)
  exactDenotation : denotation.expression = uptake.representation ∧ denotation.target = (target, condition)

def selectionGovernance : Governance (EntityId := Unit) systemDirection unconstrainedFeed where
  operator := ()
  governed := ()
  representation := systemSelection.representation
  contrast := systemSelection.contrastRepresentation
  different := systemSelection.representationDifference
  contribution := systemSelection.contribution
  upstream := systemSelection.representationalDifferenceIsUpstream
  selected := systemSelection.selected
  rejected := systemSelection.rejected
  alternativesDistinct := systemSelection.discriminates
  available := {
    scope := ⟨fun transformation => transformation.input.value.2 = Stage.forwardInput ∧
      (transformation.output.value = (false, Stage.forwardLow) ∨
       transformation.output.value = (true, Stage.forwardHigh))⟩
    conforms := fun transformation => transformation.input.value.2 = Stage.forwardInput ∧
      (transformation.output.value = (false, Stage.forwardLow) ∨
       transformation.output.value = (true, Stage.forwardHigh))
    decideConformity := fun transformation => decide
      (transformation.input.value.2 = Stage.forwardInput ∧
       (transformation.output.value = (false, Stage.forwardLow) ∨
        transformation.output.value = (true, Stage.forwardHigh)))
    conformityCorrect := by intro transformation; simp
    conformityWithinScope := by intro transformation member; exact member }
  selectedAvailable := by simp [systemSelection, forwardHighTransform, transform, state]
  rejectedAvailable := by simp [systemSelection, forwardLowTransform, transform, state]
  constraint := internalOnly
  selectedAdmitted := by simp [systemSelection, internalOnly, systemIdentity, forwardHighTransform, transform, state]
  rejectedAdmitted := by simp [systemSelection, internalOnly, systemIdentity, forwardLowTransform, transform, state]
  denotation := systemSelection.outcomeDenotation
  exactDenotation := ⟨systemSelection.denotationNamesOutcome.1,
    systemSelection.denotationNamesOutcome.2.trans systemSelection.representedOutcomeIsSelectedOutput⟩
  exactSelection := systemSelection.contributionSelects

def operatorSpecification : Specification (Unit × ParticipationRole) where
  scope := ⟨fun _ => True⟩
  conforms := fun pair => pair.2 = .operator
  decideConformity := fun pair => decide (pair.2 = .operator)
  conformityCorrect := by simp
  conformityWithinScope := by intros; trivial

def regulatorAuto : Auto () systemDirection unconstrainedFeed where
  activity := forwardHighTransform
  contribution := forwardContribution
  roleSpecification := operatorSpecification
  operatorAdmitted := rfl
  inputAloneExcluded := by simp [operatorSpecification]
  organizingOccurrence := forwardHighTransform
  organizingInChangedPath := by simp [forwardContribution, singletonPath]
  resultExact := rfl
  constraint := internalOnly
  activityAdmitted := by simp [internalOnly, systemIdentity, forwardHighTransform, transform, state]

def regulatorGovernance : Autogovernance (EntityId := Unit) systemDirection unconstrainedFeed where
  selfGovernance := ⟨selectionGovernance, rfl⟩
  operative := regulatorAuto
  sameActivity := rfl
  sameContribution := rfl

theorem governanceInhabited : Nonempty (Governance (EntityId := Unit) systemDirection unconstrainedFeed) := ⟨selectionGovernance⟩
theorem autogovernanceInhabited : Nonempty (Autogovernance (EntityId := Unit) systemDirection unconstrainedFeed) := ⟨regulatorGovernance⟩
theorem causalInputDoesNotMeetOperatorSpecification :
    ¬ operatorSpecification.conforms ((), ParticipationRole.input) := by simp [operatorSpecification]

def inputSpecification : Specification (Unit × ParticipationRole) where
  scope := ⟨fun _ => True⟩
  conforms := fun pair => pair.2 = .input
  decideConformity := fun pair => decide (pair.2 = .input)
  conformityCorrect := by simp
  conformityWithinScope := by intros; trivial

theorem reflexiveInputIsNotAutoOperator : Self () () ∧
    inputSpecification.conforms ((), .input) ∧
    ¬ inputSpecification.conforms ((), .operator) := by simp [Self, inputSpecification]

theorem selectionCannotBeItsCrossingAction (autonomy : Autonomy ToyPart systemBody) :
    autonomy.governance.selfGovernance.governance.selected.output ≠ autonomy.action.output := by
  intro equal
  have within := (systemBody.recurringWithinInterior _ autonomy.selectedWithinBody).2
  have scope := systemBody.interior.conformityWithinScope _ within
  exact systemBody.interiorEnvironmentDisjoint _ scope (equal ▸ autonomy.crossingOutput)

inductive Device where | camera | otherCamera | gps deriving DecidableEq
inductive Label where | ownCamera | genericCamera | ownPosition | externalLabel deriving DecidableEq
def cameraUptake : PerceptionUptake Device Label :=
  ⟨.camera, .ownCamera, fun label => label = .ownCamera, rfl, fun _ _ => True⟩
def mirrorPerception : SelfPerception cameraUptake :=
  ⟨.camera, rfl, none, by simp, ⟨.ownCamera, (.camera, none)⟩, ⟨rfl, rfl⟩⟩
def gpsUptake : PerceptionUptake Device Label :=
  ⟨.gps, .ownPosition, fun label => label = .ownPosition, rfl, fun _ value => value = 42⟩
def gpsPerception : SelfPerception gpsUptake :=
  ⟨.gps, rfl, some 42, by intro value member; simpa [gpsUptake, eq_comm] using member, ⟨.ownPosition, (.gps, some 42)⟩, ⟨rfl, rfl⟩⟩
theorem mirrorAndGpsInhabited : Nonempty (SelfPerception cameraUptake) ∧
    Nonempty (SelfPerception gpsUptake) := ⟨⟨mirrorPerception⟩, ⟨gpsPerception⟩⟩
theorem genericCameraLabelInsufficient : Label.genericCamera ≠ mirrorPerception.denotation.expression := by decide
theorem otherCameraNotReflexive : ¬ Self Device.camera Device.otherCamera := by simp [Self]
theorem externalAttributionNotUptake : ¬ gpsUptake.sensedRepresentation Label.externalLabel := by simp [gpsUptake]
theorem embodiedSelfGovernanceConfigurationInhabited :
    Nonempty (EmbodiedSelfGovernance ToyPart systemBody) := ⟨systemSelfGovernance⟩

end DanielOntology.PR18ReviewDraft
