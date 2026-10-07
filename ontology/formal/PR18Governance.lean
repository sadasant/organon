import AttentionLoveCare

/-! Exact causal selection and inhabited sensory/agency seams.
Generic Auto is deliberately not defined here: organizational production is not
equivalent to causal triggering, selection, Body membership or activity onset.
The Body-indexed structures are scoped witnesses, not necessary conditions for
all canonical Sense, Perception, Agency or Self-perception instances. -/
universe u v w
namespace DanielOntology.PR18Governance
open EmbodiedConsciousnessProposal AttentionLoveCareProposal

structure Governance {Feature : Type u} {Context : Type v}
    (direction : Direction (Feature × Context))
    (feeding : FeedRelation (Feature × Context)) where
  representation : Feature
  contrast : Feature
  difference : contrast ≠ representation
  contribution : CausalContribution Feature Context direction feeding
  upstream : contribution.leftEndpoints.first.input.value.1 = contrast ∧
    contribution.rightEndpoints.first.input.value.1 = representation
  selected : Transformation direction
  rejected : Transformation direction
  selectedIsChangedLast : selected = contribution.rightEndpoints.last
  rejectedIsContrastLast : rejected = contribution.leftEndpoints.last
  distinct : selected ≠ rejected
  availability : Specification (Transformation direction)
  selectedAvailable : availability.conforms selected
  rejectedAvailable : availability.conforms rejected
  constraints : List (Constraint (Feature × Context))
  admitted : ∀ constraint, constraint ∈ constraints →
    constraint.permits selected ∧ constraint.permits rejected
  denotation : Denotation Feature (State (Feature × Context))
  denotesSelected : denotation.expression = representation ∧
    denotation.target = selected.output
  exactOutput : contribution.downstreamChange.transformation.output = selected.output

def internalSelectionToGovernance
    {Part : Type u} {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} {body : Body Part entity}
    (selection : InternalActivitySelection Part body) :
    Governance entity.persistenceDirection body.feeding where
  representation := selection.representation
  contrast := selection.contrastRepresentation
  difference := selection.representationDifference
  contribution := selection.contribution
  upstream := selection.representationalDifferenceIsUpstream
  selected := selection.selected
  rejected := selection.rejected
  selectedIsChangedLast := selection.selectedIsChangedPathLast
  rejectedIsContrastLast := selection.rejectedIsContrastPathLast
  distinct := selection.discriminates
  availability := selection.availability
  selectedAvailable := (selection.availabilityExactlyOptions _).mpr selection.selectedInOptions
  rejectedAvailable := (selection.availabilityExactlyOptions _).mpr selection.rejectedInOptions
  constraints := entity.boundary.constraints
  admitted := by
    intro constraint member
    exact ⟨body.recurringAdmittedByBoundary _
      (selection.optionsWithinBody _ selection.selectedInOptions) _ member,
      body.recurringAdmittedByBoundary _
      (selection.optionsWithinBody _ selection.rejectedInOptions) _ member⟩
  denotation := selection.outcomeDenotation
  denotesSelected := ⟨selection.denotationNamesOutcome.1,
    selection.denotationNamesOutcome.2.trans selection.representedOutcomeIsSelectedOutput⟩
  exactOutput := selection.contributionSelects

structure BodySelfGovernance (Part : Type u)
    {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} (body : Body Part entity) where
  governance : Governance entity.persistenceDirection body.feeding
  governingStateIsOwn : body.interior.conforms
    governance.contribution.rightEndpoints.first.input
  selectedWithinBody : governance.selected ∈ body.recurringTransformations
  rejectedWithinBody : governance.rejected ∈ body.recurringTransformations
  constraintsAreOwn : governance.constraints = entity.boundary.constraints
  allAvailableWithinBody : ∀ transformation, governance.availability.conforms transformation →
    transformation ∈ body.recurringTransformations

def embodiedSelfGovernanceToSelfGovernance
    {Part : Type u} {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} {body : Body Part entity}
    (embodied : EmbodiedSelfGovernance Part body) : BodySelfGovernance Part body where
  governance := internalSelectionToGovernance embodied.selection
  governingStateIsOwn := by
    change body.interior.conforms embodied.selection.contribution.rightEndpoints.first.input
    rw [← embodied.perspectiveGuidesSelection.2,
      ← embodied.perspective.perception.stateRegistersCondition]
    exact embodied.perspective.perception.stateIsInternal
  selectedWithinBody := embodied.selection.optionsWithinBody _ embodied.selection.selectedInOptions
  rejectedWithinBody := embodied.selection.optionsWithinBody _ embodied.selection.rejectedInOptions
  constraintsAreOwn := rfl
  allAvailableWithinBody := by
    intro transformation available
    exact embodied.selection.optionsWithinBody transformation
      ((embodied.selection.availabilityExactlyOptions transformation).mp available)

structure Sense (Part : Type u) {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} (body : Body Part entity) where
  contribution : CausalContribution Feature Context entity.persistenceDirection body.feeding
  sourcesEnvironmental : body.environment.includes contribution.leftEndpoints.first.input ∧
    body.environment.includes contribution.rightEndpoints.first.input
  outputsInternal : body.interior.conforms contribution.leftEndpoints.last.output ∧
    body.interior.conforms contribution.rightEndpoints.last.output
  boundaryConstraint : Constraint (Feature × Context)
  constraintIsOwn : boundaryConstraint ∈ entity.boundary.constraints
  uptakeAdmitted : boundaryConstraint.permits contribution.leftEndpoints.first ∧
    boundaryConstraint.permits contribution.rightEndpoints.first

structure Perception (Part : Type u) {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} (body : Body Part entity) where
  sense : Sense Part body
  state : State (Feature × Context)
  producedBySense : state = sense.contribution.rightEndpoints.last.output
  internal : body.interior.conforms state

structure Action (Part : Type u) {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} (body : Body Part entity) where
  path : CausalPath entity.persistenceDirection body.feeding
  endpoints : PathEndpoints path
  transformation : Transformation entity.persistenceDirection
  exactOccurrence : transformation = endpoints.last
  beginsInternal : body.interior.conforms endpoints.first.input
  crossingInput : body.interior.conforms transformation.input
  crossingOutput : body.environment.includes transformation.output
  admitted : ∀ constraint, constraint ∈ entity.boundary.constraints →
    constraint.permits transformation

def ExactChains {Carrier : Type u} {direction : Direction Carrier} :
    List (Transformation direction) → Prop
  | [] => True
  | [_] => True
  | first :: second :: rest => first.output = second.input ∧ ExactChains (second :: rest)

structure Interpretation (Part : Type u) {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} (body : Body Part entity) where
  perception : Perception Part body
  processing : CausalPath entity.persistenceDirection body.feeding
  processingEndpoints : PathEndpoints processing
  startsAtPerception : processingEndpoints.first.input = perception.state
  exactProcessing : ExactChains processing.steps
  transformation : Transformation entity.persistenceDirection
  occursInProcessing : transformation = processingEndpoints.last
  processingWithinBody : ∀ step, step ∈ processing.steps → step ∈ body.recurringTransformations
  selectedAction : Action Part body
  rejectedAction : Action Part body
  actionContribution : CausalContribution Feature Context entity.persistenceDirection body.feeding
  interpretedDifferenceUpstream : actionContribution.rightEndpoints.first.input = transformation.output
  selectedIsChangedLast : selectedAction.transformation = actionContribution.rightEndpoints.last
  rejectedIsContrastLast : rejectedAction.transformation = actionContribution.leftEndpoints.last
  actionsDistinct : selectedAction.transformation ≠ rejectedAction.transformation
  availability : Specification (Transformation entity.persistenceDirection)
  bothAvailable : availability.conforms selectedAction.transformation ∧
    availability.conforms rejectedAction.transformation

structure Agent (Part : Type u) {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} (body : Body Part entity) where
  interpretation : Interpretation Part body
  action : Action Part body
  interpretationSelectsAction : action.transformation = interpretation.selectedAction.transformation

structure Agency (Part : Type u) {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} (body : Body Part entity) where
  agent : Agent Part body
  contribution : CausalContribution Feature Context entity.persistenceDirection body.feeding
  exactContribution : contribution = agent.interpretation.actionContribution
  producesExactAction : contribution.rightEndpoints.last = agent.action.transformation

inductive PerceptualTarget (Carrier : Type u) where
  | entity (entity : Entity Carrier) (condition : Option (State Carrier))
  | category (index : Nat)

structure SelfPerception (Part : Type u) {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} (body : Body Part entity) where
  perception : Perception Part body
  representation : Feature
  registeredInternally : representation = perception.state.value.1
  condition : Option (State (Feature × Context))
  conditionIsOwn : ∀ state, state ∈ condition → state ∈ entity.persistence.states
  denotation : Denotation Feature (PerceptualTarget (Feature × Context))
  expressionExact : denotation.expression = representation
  targetExact : denotation.target = .entity entity condition

/-! This profile is an inhabited internal-Governance-to-Agency chain. It does
not assert generic Auto or settle a universal Autonomy definition. -/
structure InternallyGovernedAgency (Part : Type u)
    {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} (body : Body Part entity) where
  governance : BodySelfGovernance Part body
  agency : Agency Part body
  selectionToInterpretation : CausalContribution Feature Context entity.persistenceDirection body.feeding
  exactSelectedInput : selectionToInterpretation.rightEndpoints.first.input = governance.governance.selected.output
  exactInterpretation : selectionToInterpretation.rightEndpoints.last = agency.agent.interpretation.transformation
  governingStateIsPerceived : governance.governance.contribution.rightEndpoints.first.input =
    agency.agent.interpretation.perception.state
  processingStartsWithSelection : agency.agent.interpretation.processingEndpoints.first = governance.governance.selected
  comparisonExactChains : ExactChains selectionToInterpretation.leftPath.steps ∧
    ExactChains selectionToInterpretation.rightPath.steps
  contrastInterpretationWithinBody : selectionToInterpretation.leftEndpoints.last ∈ body.recurringTransformations
  commonScope : Scope (State (Feature × Context))
  perceptionInScope : commonScope.includes agency.agent.interpretation.perception.state
  governingAlternativesInScope : ∀ transformation, governance.governance.availability.conforms transformation →
    commonScope.includes transformation.input ∧ commonScope.includes transformation.output
  governingComparisonInScope : ∀ transformation,
    transformation ∈ governance.governance.contribution.leftPath.steps ∨ transformation ∈ governance.governance.contribution.rightPath.steps →
    commonScope.includes transformation.input ∧ commonScope.includes transformation.output
  processingInScope : ∀ transformation,
    transformation ∈ agency.agent.interpretation.processing.steps →
    commonScope.includes transformation.input ∧ commonScope.includes transformation.output
  governingComparisonAdmitted : ∀ transformation,
    transformation ∈ governance.governance.contribution.leftPath.steps ∨ transformation ∈ governance.governance.contribution.rightPath.steps →
    ∀ constraint, constraint ∈ entity.boundary.constraints → constraint.permits transformation
  processingAdmitted : ∀ transformation,
    transformation ∈ agency.agent.interpretation.processing.steps →
    ∀ constraint, constraint ∈ entity.boundary.constraints → constraint.permits transformation
  interpretationComparisonAdmitted : ∀ transformation,
    transformation ∈ selectionToInterpretation.leftPath.steps ∨ transformation ∈ selectionToInterpretation.rightPath.steps →
    ∀ constraint, constraint ∈ entity.boundary.constraints → constraint.permits transformation
  actionComparisonAdmitted : ∀ transformation,
    transformation ∈ agency.agent.interpretation.actionContribution.leftPath.steps ∨ transformation ∈ agency.agent.interpretation.actionContribution.rightPath.steps →
    ∀ constraint, constraint ∈ entity.boundary.constraints → constraint.permits transformation
  interpretationComparisonInScope : ∀ transformation,
    transformation ∈ selectionToInterpretation.leftPath.steps ∨
    transformation ∈ selectionToInterpretation.rightPath.steps →
    commonScope.includes transformation.input ∧ commonScope.includes transformation.output
  actionComparisonInScope : ∀ transformation,
    transformation ∈ agency.agent.interpretation.actionContribution.leftPath.steps ∨
    transformation ∈ agency.agent.interpretation.actionContribution.rightPath.steps →
    commonScope.includes transformation.input ∧ commonScope.includes transformation.output

theorem governedPathOccurrencesAreScopedAndAdmitted
    {Part : Type u} {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} {body : Body Part entity}
    (profile : InternallyGovernedAgency Part body)
    (transformation : Transformation entity.persistenceDirection)
    (occurs : transformation ∈ profile.governance.governance.contribution.leftPath.steps ∨
      transformation ∈ profile.governance.governance.contribution.rightPath.steps) :
    profile.commonScope.includes transformation.input ∧
    profile.commonScope.includes transformation.output ∧
    (∀ constraint, constraint ∈ entity.boundary.constraints → constraint.permits transformation) :=
  ⟨(profile.governingComparisonInScope transformation occurs).1,
    (profile.governingComparisonInScope transformation occurs).2,
    profile.governingComparisonAdmitted transformation occurs⟩

theorem generalInternalSelectionLift
    {Part : Type u} {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} {body : Body Part entity}
    (selection : InternalActivitySelection Part body) :
    (internalSelectionToGovernance selection).selected = selection.selected ∧
    (internalSelectionToGovernance selection).rejected = selection.rejected ∧
    (internalSelectionToGovernance selection).contribution = selection.contribution ∧
    (internalSelectionToGovernance selection).availability = selection.availability :=
  ⟨rfl, rfl, rfl, rfl⟩

theorem generalEmbodiedSelfGovernanceLift
    {Part : Type u} {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} {body : Body Part entity}
    (embodied : EmbodiedSelfGovernance Part body) :
    (embodiedSelfGovernanceToSelfGovernance embodied).governance.selected = embodied.selection.selected ∧
    (embodiedSelfGovernanceToSelfGovernance embodied).governance.contribution = embodied.selection.contribution :=
  ⟨rfl, rfl⟩

theorem rejectsUnrelatedAlternative
    {Feature : Type u} {Context : Type v}
    {direction : Direction (Feature × Context)} {feeding : FeedRelation (Feature × Context)}
    (governance : Governance direction feeding)
    (unrelated : Transformation direction)
    (notActualContrast : unrelated ≠ governance.contribution.leftEndpoints.last) :
    unrelated ≠ governance.rejected := by
  simpa [governance.rejectedIsContrastLast] using notActualContrast

theorem categoryCannotBeSelfTarget
    {Part : Type u} {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} {body : Body Part entity}
    (perception : SelfPerception Part body) (category : Nat) :
    perception.denotation.target ≠ .category category := by
  rw [perception.targetExact]
  intro equal
  cases equal

theorem actionCannotBeInternalOccurrence
    {Part : Type u} {Feature : Type v} {Context : Type w}
    {entity : Entity (Feature × Context)} {body : Body Part entity}
    (profile : InternallyGovernedAgency Part body) :
    profile.governance.governance.selected ≠ profile.agency.agent.action.transformation := by
  intro equal
  have interior := (body.recurringWithinInterior _ profile.governance.selectedWithinBody).2
  have scope := body.interior.conformityWithinScope _ interior
  exact body.interiorEnvironmentDisjoint _ scope
    (equal ▸ profile.agency.agent.action.crossingOutput)

/-! ## Finite positive world with reachable environmental outputs -/
abbrev Carrier := Bool × Nat
def state (feature : Bool) (time : Nat) : State Carrier := ⟨(feature, time)⟩
def direction : Direction Carrier where
  before := fun first second => first.value.2 < second.value.2
  asymmetric := by intro first second forward backward; exact Nat.lt_asymm forward backward
def feeding : FeedRelation Carrier := ⟨fun _ _ => True⟩
def step (feature : Bool) (first last : Nat) (ordered : first < last) : Transformation direction :=
  ⟨state feature first, state feature last, ordered⟩
def organizationLow := step false 2 3 (by decide)
def organizationHigh := step true 2 4 (by decide)
def interpretationLow := step false 4 5 (by decide)
def interpretationHigh := step true 4 6 (by decide)
def actionLow := step false 6 9 (by decide)
def actionHigh := step true 6 10 (by decide)
def senseLow := step false 0 1 (by decide)
def senseHigh := step true 0 2 (by decide)
def singletonPath (transformation : Transformation direction) : CausalPath direction feeding :=
  ⟨[transformation], trivial⟩
def singletonEndpoints (transformation : Transformation direction) : PathEndpoints (singletonPath transformation) :=
  ⟨transformation, transformation, ⟨[], rfl⟩, ⟨[], rfl⟩⟩
def compare (low high : Transformation direction)
    (sameContext : low.input.value.2 = high.input.value.2)
    (different : low.input.value.1 ≠ high.input.value.1)
    (outputsOrdered : low.output.value.2 < high.output.value.2)
    (outputsDifferent : low.output ≠ high.output) :
    CausalContribution Bool Nat direction feeding where
  leftPath := singletonPath low
  rightPath := singletonPath high
  leftEndpoints := singletonEndpoints low
  rightEndpoints := singletonEndpoints high
  sameDeclaredContext := sameContext
  inputDiffers := different
  downstreamChange := ⟨⟨low.output, high.output, outputsOrdered⟩, outputsDifferent⟩
  changeStartsAt := rfl
  changeEndsAt := rfl
def organizationContribution := compare organizationLow organizationHigh rfl (by decide) (by decide) (by decide)
def interpretationContribution := compare interpretationLow interpretationHigh rfl (by decide) (by decide) (by decide)
def actionContribution := compare actionLow actionHigh rfl (by decide) (by decide) (by decide)
def senseContribution := compare senseLow senseHigh rfl (by decide) (by decide) (by decide)
def identity : Invariant Carrier := ⟨fun current => current.value.2 ≤ 12⟩
def constraint : Constraint Carrier := ⟨fun transformation => identity.holds transformation.output⟩
def boundary : Boundary Carrier identity where
  constraints := [constraint]
  preserves := by intro direction transformation admitted _; exact admitted constraint (by simp)
def persistence : PersistenceWitness direction where
  states := [state false 1, state true 2, state false 3, state true 4, state false 5, state true 6]
  hasTransition := ⟨state false 1, state true 2, [state false 3, state true 4, state false 5, state true 6], rfl⟩
  invariant := identity
  invariantHolds := by
    intro current member
    simp at member
    rcases member with rfl | rfl | rfl | rfl | rfl | rfl <;> simp [identity, state]
  ordered := by simp [OrderedBy, direction, state]
def entity : Entity Carrier :=
  ⟨identity, boundary, direction, persistence, rfl, state true 6, by simp [persistence], by simp [identity, state]⟩
def interior : Specification (State Carrier) where
  scope := ⟨fun current => 0 < current.value.2 ∧ current.value.2 < 9⟩
  conforms := fun current => 0 < current.value.2 ∧ current.value.2 < 9
  decideConformity := fun current => decide (0 < current.value.2 ∧ current.value.2 < 9)
  conformityCorrect := by simp
  conformityWithinScope := by intro current conforming; exact conforming
def organization : List (Transformation direction) :=
  [organizationLow, organizationHigh, interpretationLow, interpretationHigh]
theorem organizationLowMember : organizationLow ∈ organization :=
  List.mem_cons.mpr (Or.inl rfl)
theorem organizationHighMember : organizationHigh ∈ organization :=
  List.mem_cons.mpr (Or.inr (List.mem_cons.mpr (Or.inl rfl)))
theorem interpretationLowMember : interpretationLow ∈ organization :=
  List.mem_cons.mpr (Or.inr (List.mem_cons.mpr (Or.inr (List.mem_cons.mpr (Or.inl rfl)))))
theorem interpretationHighMember : interpretationHigh ∈ organization :=
  List.mem_cons.mpr (Or.inr (List.mem_cons.mpr (Or.inr (List.mem_cons.mpr (Or.inr (List.mem_singleton.mpr rfl))))))
def body : Body Unit entity where
  states := persistence.states
  statesNonempty := by simp [persistence]
  statesWithinPersistence := by intro current member; exact member
  statesOrdered := persistence.ordered
  partAt := fun _ _ => True
  eachStateHasConstituent := by intros; exact ⟨(), trivial⟩
  interior := interior
  environment := ⟨fun current => current.value.2 = 0 ∨ 9 ≤ current.value.2⟩
  interiorEnvironmentDisjoint := by
    intro current internal external
    rcases external with zero | later
    · exact (Nat.ne_of_gt internal.1) zero
    · exact Nat.not_le_of_gt internal.2 later
  recurringTransformations := organization
  recurringNonempty := by simp [organization]
  feeding := feeding
  identityPath := ⟨organization, by simp [organization, Chains, feeding]⟩
  identityPathNonempty := by simp [organization]
  recurringOccursInPath := by intro transformation member; exact member
  recurringWithinInterior := by
    intro transformation member
    change Transformation direction at transformation
    change transformation ∈ [organizationLow, organizationHigh, interpretationLow, interpretationHigh] at member
    simp only [List.mem_cons, List.not_mem_nil, or_false] at member
    rcases member with rfl | rfl | rfl | rfl <;>
      simp [interior, entity, identity, organizationLow, organizationHigh, interpretationLow, interpretationHigh, step, state]
  recurringAdmittedByBoundary := by
    intro transformation member restriction restrictionMember
    simp [entity, boundary] at restrictionMember
    subst restriction
    change Transformation direction at transformation
    change transformation ∈ [organizationLow, organizationHigh, interpretationLow, interpretationHigh] at member
    simp only [List.mem_cons, List.not_mem_nil, or_false] at member
    rcases member with rfl | rfl | rfl | rfl <;>
      simp [entity, constraint, identity, organizationLow, organizationHigh, interpretationLow, interpretationHigh, step, state]
  recurringPreservesIdentity := by
    intro transformation member
    change Transformation direction at transformation
    change transformation ∈ [organizationLow, organizationHigh, interpretationLow, interpretationHigh] at member
    simp only [List.mem_cons, List.not_mem_nil, or_false] at member
    rcases member with rfl | rfl | rfl | rfl <;>
      simp [entity, identity, organizationLow, organizationHigh, interpretationLow, interpretationHigh, step, state]
def selection : InternalActivitySelection Unit body where
  representation := true
  contrastRepresentation := false
  representationDifference := by decide
  representedOutcome := state true 4
  outcomeDenotation := ⟨true, state true 4⟩
  denotationNamesOutcome := ⟨rfl, rfl⟩
  contribution := organizationContribution
  representationalDifferenceIsUpstream := ⟨rfl, rfl⟩
  options := [organizationLow, organizationHigh]
  selected := organizationHigh
  rejected := organizationLow
  availability := {
    scope := ⟨fun transformation => transformation ∈ [organizationLow, organizationHigh]⟩
    conforms := fun transformation => transformation ∈ [organizationLow, organizationHigh]
    decideConformity := fun transformation => decide (transformation ∈ [organizationLow, organizationHigh])
    conformityCorrect := by simp
    conformityWithinScope := by intro transformation member; exact member }
  availabilityExactlyOptions := by intro transformation; rfl
  selectedIsChangedPathLast := rfl
  rejectedIsContrastPathLast := rfl
  selectedInOptions := by simp
  rejectedInOptions := by simp
  optionsWithinBody := by
    intro transformation member
    simp only [List.mem_cons, List.not_mem_nil, or_false] at member
    rcases member with rfl | rfl
    · exact organizationLowMember
    · exact organizationHighMember
  discriminates := by
    intro equal
    have outputs := congrArg (fun transformation => transformation.output.value.2) equal
    simp [organizationHigh, organizationLow, step, state] at outputs
  representedOutcomeIsSelectedOutput := rfl
  contributionSelects := rfl
  selectedIsInternal := by change 0 < 4 ∧ 4 < 9; decide
  rejectedIsInternal := by change 0 < 3 ∧ 3 < 9; decide
  mode := .select
def selfGovernance : BodySelfGovernance Unit body where
  governance := internalSelectionToGovernance selection
  governingStateIsOwn := by change 0 < 2 ∧ 2 < 9; decide
  selectedWithinBody := organizationHighMember
  rejectedWithinBody := organizationLowMember
  constraintsAreOwn := rfl
  allAvailableWithinBody := by
    intro transformation available
    change transformation ∈ [organizationLow, organizationHigh] at available
    rcases List.mem_cons.mp available with low | high
    · rw [low]; exact organizationLowMember
    · rw [List.mem_singleton.mp high]; exact organizationHighMember
def sensed : Sense Unit body where
  contribution := senseContribution
  sourcesEnvironmental := by constructor <;> left <;> rfl
  outputsInternal := by change (0 < 1 ∧ 1 < 9) ∧ (0 < 2 ∧ 2 < 9); decide
  boundaryConstraint := constraint
  constraintIsOwn := by simp [entity, boundary]
  uptakeAdmitted := by change 1 ≤ 12 ∧ 2 ≤ 12; decide
def perceived : Perception Unit body := ⟨sensed, state true 2, rfl, by change 0 < 2 ∧ 2 < 9; decide⟩
def selectedAction : Action Unit body where
  path := singletonPath actionHigh
  endpoints := singletonEndpoints actionHigh
  transformation := actionHigh
  exactOccurrence := rfl
  beginsInternal := by change 0 < 6 ∧ 6 < 9; decide
  crossingInput := by change 0 < 6 ∧ 6 < 9; decide
  crossingOutput := by right; decide
  admitted := by
    intro restriction member
    simp [entity, boundary] at member
    subst restriction
    simp [constraint, identity, actionHigh, step, state]
def rejectedAction : Action Unit body where
  path := singletonPath actionLow
  endpoints := singletonEndpoints actionLow
  transformation := actionLow
  exactOccurrence := rfl
  beginsInternal := by change 0 < 6 ∧ 6 < 9; decide
  crossingInput := by change 0 < 6 ∧ 6 < 9; decide
  crossingOutput := by right; decide
  admitted := by
    intro restriction member
    simp [entity, boundary] at member
    subst restriction
    simp [constraint, identity, actionLow, step, state]
def processing : CausalPath direction feeding :=
  ⟨[organizationHigh, interpretationHigh], by simp [Chains, feeding]⟩
def processingEndpoints : PathEndpoints processing :=
  ⟨organizationHigh, interpretationHigh, ⟨[interpretationHigh], rfl⟩, ⟨[organizationHigh], rfl⟩⟩
def interpreting : Interpretation Unit body where
  perception := perceived
  processing := processing
  processingEndpoints := processingEndpoints
  startsAtPerception := rfl
  exactProcessing := ⟨rfl, trivial⟩
  transformation := interpretationHigh
  occursInProcessing := rfl
  processingWithinBody := by
    intro transformation member
    change transformation ∈ [organizationHigh, interpretationHigh] at member
    rcases List.mem_cons.mp member with first | last
    · rw [first]; exact organizationHighMember
    · rw [List.mem_singleton.mp last]; exact interpretationHighMember
  selectedAction := selectedAction
  rejectedAction := rejectedAction
  actionContribution := actionContribution
  interpretedDifferenceUpstream := rfl
  selectedIsChangedLast := rfl
  rejectedIsContrastLast := rfl
  actionsDistinct := by
    intro equal
    have outputs := congrArg (fun transformation => transformation.output.value.2) equal
    simp [selectedAction, rejectedAction, actionLow, actionHigh, step, state] at outputs
  availability := {
    scope := ⟨fun transformation => transformation ∈ [actionLow, actionHigh]⟩
    conforms := fun transformation => transformation ∈ [actionLow, actionHigh]
    decideConformity := fun transformation => decide (transformation ∈ [actionLow, actionHigh])
    conformityCorrect := by simp
    conformityWithinScope := by intro transformation member; exact member }
  bothAvailable := by
    constructor
    · exact List.mem_cons.mpr (Or.inr (List.mem_singleton.mpr rfl))
    · exact List.mem_cons.mpr (Or.inl rfl)
def agent : Agent Unit body := ⟨interpreting, selectedAction, rfl⟩
def agency : Agency Unit body := ⟨agent, actionContribution, rfl, rfl⟩
def activeProfile : InternallyGovernedAgency Unit body where
  governance := selfGovernance
  agency := agency
  selectionToInterpretation := interpretationContribution
  exactSelectedInput := rfl
  exactInterpretation := rfl
  governingStateIsPerceived := rfl
  processingStartsWithSelection := rfl
  comparisonExactChains := ⟨trivial, trivial⟩
  contrastInterpretationWithinBody := interpretationLowMember
  commonScope := ⟨fun current => current.value.2 ≤ 12⟩
  perceptionInScope := by change 2 ≤ 12; decide
  governingAlternativesInScope := by
    intro transformation available
    change Transformation direction at transformation
    change transformation ∈ [organizationLow, organizationHigh] at available
    rcases List.mem_cons.mp available with low | high
    · rw [low]; change 2 ≤ 12 ∧ 3 ≤ 12; decide
    · rw [List.mem_singleton.mp high]; change 2 ≤ 12 ∧ 4 ≤ 12; decide
  governingComparisonInScope := by
    intro transformation member
    change Transformation direction at transformation
    change transformation ∈ [organizationLow] ∨ transformation ∈ [organizationHigh] at member
    rcases member with low | high
    · rw [List.mem_singleton.mp low]; change organizationLow.input.value.2 ≤ 12 ∧ organizationLow.output.value.2 ≤ 12; decide
    · rw [List.mem_singleton.mp high]; change organizationHigh.input.value.2 ≤ 12 ∧ organizationHigh.output.value.2 ≤ 12; decide
  processingInScope := by
    intro transformation member
    change Transformation direction at transformation
    change transformation ∈ [organizationHigh, interpretationHigh] at member
    rcases List.mem_cons.mp member with low | high
    · rw [low]; change organizationHigh.input.value.2 ≤ 12 ∧ organizationHigh.output.value.2 ≤ 12; decide
    · rw [List.mem_singleton.mp high]; change interpretationHigh.input.value.2 ≤ 12 ∧ interpretationHigh.output.value.2 ≤ 12; decide
  governingComparisonAdmitted := by
    intro transformation member namedConstraint constraintMember
    change Transformation direction at transformation
    change namedConstraint ∈ [constraint] at constraintMember
    rw [List.mem_singleton.mp constraintMember]
    change transformation ∈ [organizationLow] ∨ transformation ∈ [organizationHigh] at member
    rcases member with low | high
    · rw [List.mem_singleton.mp low]; change organizationLow.output.value.2 ≤ 12; decide
    · rw [List.mem_singleton.mp high]; change organizationHigh.output.value.2 ≤ 12; decide
  processingAdmitted := by
    intro transformation member namedConstraint constraintMember
    change Transformation direction at transformation
    change namedConstraint ∈ [constraint] at constraintMember
    rw [List.mem_singleton.mp constraintMember]
    change transformation ∈ [organizationHigh, interpretationHigh] at member
    rcases List.mem_cons.mp member with low | high
    · rw [low]; change organizationHigh.output.value.2 ≤ 12; decide
    · rw [List.mem_singleton.mp high]; change interpretationHigh.output.value.2 ≤ 12; decide
  interpretationComparisonAdmitted := by
    intro transformation member namedConstraint constraintMember
    change Transformation direction at transformation
    change namedConstraint ∈ [constraint] at constraintMember
    rw [List.mem_singleton.mp constraintMember]
    change transformation ∈ [interpretationLow] ∨ transformation ∈ [interpretationHigh] at member
    rcases member with low | high
    · rw [List.mem_singleton.mp low]; change interpretationLow.output.value.2 ≤ 12; decide
    · rw [List.mem_singleton.mp high]; change interpretationHigh.output.value.2 ≤ 12; decide
  actionComparisonAdmitted := by
    intro transformation member namedConstraint constraintMember
    change Transformation direction at transformation
    change namedConstraint ∈ [constraint] at constraintMember
    rw [List.mem_singleton.mp constraintMember]
    change transformation ∈ [actionLow] ∨ transformation ∈ [actionHigh] at member
    rcases member with low | high
    · rw [List.mem_singleton.mp low]; change actionLow.output.value.2 ≤ 12; decide
    · rw [List.mem_singleton.mp high]; change actionHigh.output.value.2 ≤ 12; decide
  interpretationComparisonInScope := by
    intro transformation member
    change Transformation direction at transformation
    change transformation ∈ [interpretationLow] ∨ transformation ∈ [interpretationHigh] at member
    rcases member with low | high
    · rw [List.mem_singleton.mp low]; change 4 ≤ 12 ∧ 5 ≤ 12; decide
    · rw [List.mem_singleton.mp high]; change 4 ≤ 12 ∧ 6 ≤ 12; decide
  actionComparisonInScope := by
    intro transformation member
    change Transformation direction at transformation
    change transformation ∈ [actionLow] ∨ transformation ∈ [actionHigh] at member
    rcases member with low | high
    · rw [List.mem_singleton.mp low]; change 6 ≤ 12 ∧ 9 ≤ 12; decide
    · rw [List.mem_singleton.mp high]; change 6 ≤ 12 ∧ 10 ≤ 12; decide
def gpsSelfPerception : SelfPerception Unit body where
  perception := perceived
  representation := true
  registeredInternally := rfl
  condition := some (state true 2)
  conditionIsOwn := by intro current member; simp at member; subst current; simp [entity, persistence]
  denotation := ⟨true, .entity entity (some (state true 2))⟩
  expressionExact := rfl
  targetExact := rfl
def mirrorSelfPerception : SelfPerception Unit body := {
  gpsSelfPerception with
  condition := none
  conditionIsOwn := by simp
  denotation := ⟨true, .entity entity none⟩
  targetExact := rfl }

theorem governedAgencyInhabited : Nonempty (InternallyGovernedAgency Unit body) := ⟨activeProfile⟩
theorem actualCrossingIsReachable :
    direction.before selectedAction.transformation.input selectedAction.transformation.output ∧
    body.environment.includes selectedAction.transformation.output :=
  ⟨selectedAction.transformation.advances, selectedAction.crossingOutput⟩
theorem witnessedInternalExternalDistinction :
    activeProfile.governance.governance.selected ≠ activeProfile.agency.agent.action.transformation :=
  actionCannotBeInternalOccurrence activeProfile
theorem actualSenseAndSelfPerception :
    Nonempty (SelfPerception Unit body) ∧
    perceived.state = senseContribution.rightEndpoints.last.output := ⟨⟨gpsSelfPerception⟩, rfl⟩
theorem sameOutputDoesNotJoinUnrelatedContrast :
    interpretationLow ≠ (internalSelectionToGovernance selection).rejected := by
  intro equal
  have outputs := congrArg (fun transformation => transformation.output.value.2) equal
  simp [internalSelectionToGovernance, selection, interpretationLow, organizationLow, step, state] at outputs
theorem environmentalInputIsNotInternalUptake :
    ¬ body.interior.conforms (state true 0) := by change ¬ (0 < 0 ∧ 0 < 9); decide

def unrelatedSameOutput := step false 1 3 (by decide)

theorem outputEqualityAndAdmissionDoNotEstablishContrast :
    constraint.permits unrelatedSameOutput ∧
    unrelatedSameOutput.output = (internalSelectionToGovernance selection).rejected.output ∧
    unrelatedSameOutput ≠ (internalSelectionToGovernance selection).contribution.leftEndpoints.last := by
  refine ⟨?_, rfl, ?_⟩
  · change 3 ≤ 12; decide
  · intro equal
    have inputs := congrArg (fun transformation => transformation.input.value.2) equal
    simp [unrelatedSameOutput, internalSelectionToGovernance, selection,
      organizationContribution, compare, singletonEndpoints, organizationLow, step, state] at inputs

theorem sameOutputCannotReplaceActualRejectedOccurrence :
    ¬ ∃ governance : Governance direction feeding,
      governance.contribution = organizationContribution ∧ governance.rejected = unrelatedSameOutput := by
  rintro ⟨governance, contribution, rejected⟩
  have exact := governance.rejectedIsContrastLast
  rw [contribution, rejected] at exact
  exact outputEqualityAndAdmissionDoNotEstablishContrast.2.2 exact

def laterSelection : InternalActivitySelection Unit body where
  representation := true
  contrastRepresentation := false
  representationDifference := by decide
  representedOutcome := state true 6
  outcomeDenotation := ⟨true, state true 6⟩
  denotationNamesOutcome := ⟨rfl, rfl⟩
  contribution := interpretationContribution
  representationalDifferenceIsUpstream := ⟨rfl, rfl⟩
  options := [interpretationLow, interpretationHigh]
  selected := interpretationHigh
  rejected := interpretationLow
  availability := {
    scope := ⟨fun transformation => transformation ∈ [interpretationLow, interpretationHigh]⟩
    conforms := fun transformation => transformation ∈ [interpretationLow, interpretationHigh]
    decideConformity := fun transformation => decide (transformation ∈ [interpretationLow, interpretationHigh])
    conformityCorrect := by simp
    conformityWithinScope := by intro transformation member; exact member }
  availabilityExactlyOptions := by intro transformation; rfl
  selectedIsChangedPathLast := rfl
  rejectedIsContrastPathLast := rfl
  selectedInOptions := by simp
  rejectedInOptions := by simp
  optionsWithinBody := by
    intro transformation member
    rcases List.mem_cons.mp member with low | high
    · rw [low]; exact interpretationLowMember
    · rw [List.mem_singleton.mp high]; exact interpretationHighMember
  discriminates := by
    intro equal
    have outputs := congrArg (fun transformation => transformation.output.value.2) equal
    simp [interpretationHigh, interpretationLow, step, state] at outputs
  representedOutcomeIsSelectedOutput := rfl
  contributionSelects := rfl
  selectedIsInternal := by change 0 < 6 ∧ 6 < 9; decide
  rejectedIsInternal := by change 0 < 5 ∧ 5 < 9; decide
  mode := .select

def laterSelfGovernance : BodySelfGovernance Unit body where
  governance := internalSelectionToGovernance laterSelection
  governingStateIsOwn := by change 0 < 4 ∧ 4 < 9; decide
  selectedWithinBody := interpretationHighMember
  rejectedWithinBody := interpretationLowMember
  constraintsAreOwn := rfl
  allAvailableWithinBody := by
    intro transformation available
    change transformation ∈ [interpretationLow, interpretationHigh] at available
    rcases List.mem_cons.mp available with low | high
    · rw [low]; exact interpretationLowMember
    · rw [List.mem_singleton.mp high]; exact interpretationHighMember

theorem unrelatedGovernanceAndAgencyExist :
    Nonempty (BodySelfGovernance Unit body) ∧ Nonempty (Agency Unit body) ∧
    laterSelfGovernance.governance.contribution.rightEndpoints.first.input ≠
      agency.agent.interpretation.perception.state := by
  refine ⟨⟨laterSelfGovernance⟩, ⟨agency⟩, ?_⟩
  intro equal
  have times := congrArg (fun current => current.value.2) equal
  change 4 = 2 at times
  contradiction

theorem unrelatedInstancesCannotSupplyGovernedAgency :
    ¬ ∃ profile : InternallyGovernedAgency Unit body,
      profile.governance = laterSelfGovernance ∧ profile.agency = agency := by
  rintro ⟨profile, governance, agency⟩
  have exact := profile.governingStateIsPerceived
  rw [governance, agency] at exact
  exact unrelatedGovernanceAndAgencyExist.2.2 exact

theorem externalAssignmentCannotSupplyInternalSelfPerception :
    ¬ ∃ perception : SelfPerception Unit body, perception.perception.state = state true 0 := by
  rintro ⟨perception, external⟩
  have internal := perception.perception.internal
  rw [external] at internal
  exact environmentalInputIsNotInternalUptake internal

theorem genericCategoryCannotSupplySelfPerception :
    ¬ ∃ perception : SelfPerception Unit body, perception.denotation.target = .category 0 := by
  rintro ⟨perception, category⟩
  exact categoryCannotBeSelfTarget perception 0 category

theorem arbitraryConditionCannotSupplySelfPerception :
    ¬ ∃ perception : SelfPerception Unit body, perception.condition = some (state true 99) := by
  rintro ⟨perception, condition⟩
  have member := perception.conditionIsOwn (state true 99)
  have own : state true 99 ∈ entity.persistence.states := member (condition ▸ by simp)
  change state true 99 ∈ persistence.states at own
  simp [persistence, state] at own

end DanielOntology.PR18Governance
