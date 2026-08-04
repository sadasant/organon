import OrganonCore

/-!
# Truth, Trust, and Alignment: formal shadows

This file tests D085-D087 without identifying correspondence, accepted causal
dependence, and profile-scoped conformity. Every Truth instance requires a
local material-adequacy join. Trust extends a more general Dependence with
admission through a Constraint maintained in the truster's Boundary.
Alignment uses ordered subject and target roles, not Organon's temporal
Direction.

The file does not formalize Reality as the totality of Presence, universal
natural-language interpretation, Action attribution, canonical Consequence,
or Interior crossing.
-/

universe u

namespace DanielOntology

structure TruthSemantics
    (Claim Representation MeaningRule Target : Type u) where
  representationFor : Claim → Representation
  meaningRuleFor : Claim → MeaningRule
  specificationFor : Claim → Specification Target
  targetFor : Claim → Target
  scope : Scope (Claim × Target)
  targetInRealityModel : Target → Prop
  materiallyAdequate :
    Claim → Representation → MeaningRule →
      Specification Target → Target → Prop

def TruthSemantics.isTrue
    {Claim Representation MeaningRule Target : Type u}
    (semantics : TruthSemantics Claim Representation MeaningRule Target)
    (claim : Claim) : Prop :=
  semantics.materiallyAdequate
      claim
      (semantics.representationFor claim)
      (semantics.meaningRuleFor claim)
      (semantics.specificationFor claim)
      (semantics.targetFor claim) ∧
    semantics.scope.includes (claim, semantics.targetFor claim) ∧
    semantics.targetInRealityModel (semantics.targetFor claim) ∧
    (semantics.specificationFor claim).conforms (semantics.targetFor claim)

structure EpistemicAccess (Agent Target : Type u) where
  suppliesTarget : Agent → Target → Prop

structure Dependence
    {Feature : Type u}
    {Context : Type v}
    (direction : Direction (Feature × Context))
    (feeding : FeedRelation (Feature × Context)) where
  dependent : Entity (Feature × Context)
  contributorEntity : Entity (Feature × Context)
  distinct : dependent ≠ contributorEntity
  path : CausalPath direction feeding
  contribution : Transformation direction
  contributionOnPath : contribution ∈ path.steps
  comparison : CausalContribution Feature Context direction feeding
  pathIsCompared : path = comparison.rightPath
  contributionIsComparedEndpoint :
    contribution = comparison.rightEndpoints.last
  contributor : Transformation direction → Entity (Feature × Context)
  suppliedByContributor : contributor contribution = contributorEntity
  relationState : State (Feature × Context)
  relationAtDependentState : relationState = dependent.current
  contributionIsFuture : direction.before relationState contribution.output
  dependentOutput : State (Feature × Context)
  outputFollowsContribution : dependentOutput = contribution.output
  determines : Entity (Feature × Context) → Transformation direction → Prop
  contributionUndeterminedByDependent :
    ¬ determines dependent contribution

def Dependence.isAccepted
    {Feature : Type u}
    {Context : Type v}
    {direction : Direction (Feature × Context)}
    {feeding : FeedRelation (Feature × Context)}
    (dependence : Dependence direction feeding) : Prop :=
  ∃ constraint,
    constraint ∈ dependence.dependent.boundary.constraints ∧
      constraint.permits dependence.contribution

structure Trust
    {Feature : Type u}
    {Context : Type v}
    (direction : Direction (Feature × Context))
    (feeding : FeedRelation (Feature × Context)) where
  dependence : Dependence direction feeding
  accepted : dependence.isAccepted

def Dependence.isTrusted
    {Feature : Type u}
    {Context : Type v}
    {direction : Direction (Feature × Context)}
    {feeding : FeedRelation (Feature × Context)}
    (dependence : Dependence direction feeding) : Prop :=
  ∃ trust : Trust direction feeding, trust.dependence = dependence

structure AlignmentProfile (Subject Target : Type u) where
  specification : Specification (Subject × Target)

structure Alignment
    {Subject Target : Type u}
    (profile : AlignmentProfile Subject Target) where
  subject : Subject
  target : Target
  conforms : profile.specification.conforms (subject, target)

/-! ## Shared finite model -/

inductive ToyClaim where
  | accurate
  | mistaken
  deriving DecidableEq

inductive ToyAlignmentPresence where
  | accurateRepresentation
  | mistakenRepresentation
  | requestedTarget
  deriving DecidableEq

inductive ToyFact where
  | obtaining
  | excluded
  deriving DecidableEq

inductive ToyMeaningRule where
  | literal
  deriving DecidableEq

def toyTruthSpecification (claim : ToyClaim) : Specification ToyFact where
  scope := ⟨fun _ => True⟩
  conforms := fun target =>
    match claim, target with
    | .accurate, .obtaining => True
    | _, _ => False
  decideConformity := fun target =>
    match claim, target with
    | .accurate, .obtaining => true
    | _, _ => false
  conformityCorrect := by
    intro target
    cases claim <;> cases target <;> simp
  conformityWithinScope := by simp

def toyTruthSemantics :
    TruthSemantics ToyClaim ToyAlignmentPresence ToyMeaningRule ToyFact where
  representationFor
    | .accurate => .accurateRepresentation
    | .mistaken => .mistakenRepresentation
  meaningRuleFor := fun _ => .literal
  specificationFor := toyTruthSpecification
  targetFor
    | .accurate => .obtaining
    | .mistaken => .excluded
  scope := ⟨fun _ => True⟩
  targetInRealityModel
    | .obtaining => True
    | .excluded => True
  materiallyAdequate :=
    fun claim representation meaningRule specification target =>
    representation =
        (match claim with
         | .accurate => .accurateRepresentation
         | .mistaken => .mistakenRepresentation) ∧
      meaningRule = .literal ∧
      specification = toyTruthSpecification claim ∧
      target =
        (match claim with
         | .accurate => .obtaining
         | .mistaken => .excluded)

def sealedAccess : EpistemicAccess Unit ToyFact where
  suppliesTarget := fun _ _ => False

theorem truthDoesNotEntailAgentAccess :
    toyTruthSemantics.isTrue .accurate ∧
      ∀ agent,
        ¬ sealedAccess.suppliesTarget agent
          (toyTruthSemantics.targetFor .accurate) := by
  constructor
  · simp [TruthSemantics.isTrue, toyTruthSemantics,
      toyTruthSpecification]
  · intro agent
    simp [sealedAccess]

theorem adequateClaimAndRealityModelDoNotEntailTruth :
    toyTruthSemantics.materiallyAdequate
        .mistaken
        (toyTruthSemantics.representationFor .mistaken)
        (toyTruthSemantics.meaningRuleFor .mistaken)
        (toyTruthSemantics.specificationFor .mistaken)
        (toyTruthSemantics.targetFor .mistaken) ∧
      toyTruthSemantics.targetInRealityModel
        (toyTruthSemantics.targetFor .mistaken) ∧
      ¬ toyTruthSemantics.isTrue .mistaken := by
  simp [TruthSemantics.isTrue, toyTruthSemantics,
    toyTruthSpecification]

inductive TrustStage where
  | privateState
  | affectedState
  deriving DecidableEq

abbrev TrustCarrier := Bool × TrustStage

def baselinePrivate : State TrustCarrier := ⟨(false, .privateState)⟩
def contributedPrivate : State TrustCarrier := ⟨(true, .privateState)⟩
def baselineAffected : State TrustCarrier := ⟨(false, .affectedState)⟩
def contributedAffected : State TrustCarrier := ⟨(true, .affectedState)⟩

def trustDirection : Direction TrustCarrier where
  before := fun first second =>
    first.value.2 = .privateState ∧ second.value.2 = .affectedState
  asymmetric := by
    intro first second forward backward
    simp_all

def trustFeed : FeedRelation TrustCarrier where
  feeds := fun _ _ => True

def trustIdentity : Invariant TrustCarrier where
  holds := fun _ => True

def admissionConstraint : Constraint TrustCarrier where
  permits := fun transformation =>
    transformation.input.value.2 = .privateState ∧
      transformation.output.value.2 = .affectedState

def acceptingBoundary : Boundary TrustCarrier trustIdentity where
  constraints := [admissionConstraint]
  preserves := by simp [trustIdentity]

def closedBoundary : Boundary TrustCarrier trustIdentity where
  constraints := []
  preserves := by simp [trustIdentity]

def trustPersistence : PersistenceWitness trustDirection where
  states := [baselinePrivate, baselineAffected]
  hasTransition := ⟨baselinePrivate, baselineAffected, [], rfl⟩
  invariant := trustIdentity
  invariantHolds := by simp [trustIdentity]
  ordered := by
    simp [OrderedBy, trustDirection, baselinePrivate, baselineAffected]

def delegatePersistence : PersistenceWitness trustDirection where
  states := [contributedPrivate, contributedAffected]
  hasTransition := ⟨contributedPrivate, contributedAffected, [], rfl⟩
  invariant := trustIdentity
  invariantHolds := by simp [trustIdentity]
  ordered := by
    simp [OrderedBy, trustDirection, contributedPrivate, contributedAffected]

def acceptingPrincipal : Entity TrustCarrier where
  identity := trustIdentity
  boundary := acceptingBoundary
  persistenceDirection := trustDirection
  persistence := trustPersistence
  persistenceNamesIdentity := rfl
  current := baselinePrivate
  currentInPersistence := by simp [trustPersistence]
  identityHolds := by simp [trustIdentity]

def unwillingPrincipal : Entity TrustCarrier where
  identity := trustIdentity
  boundary := closedBoundary
  persistenceDirection := trustDirection
  persistence := trustPersistence
  persistenceNamesIdentity := rfl
  current := baselinePrivate
  currentInPersistence := by simp [trustPersistence]
  identityHolds := by simp [trustIdentity]

def delegateEntity : Entity TrustCarrier where
  identity := trustIdentity
  boundary := closedBoundary
  persistenceDirection := trustDirection
  persistence := delegatePersistence
  persistenceNamesIdentity := rfl
  current := contributedAffected
  currentInPersistence := by simp [delegatePersistence]
  identityHolds := by simp [trustIdentity]

def contributedTransformation : Transformation trustDirection where
  input := contributedPrivate
  output := contributedAffected
  advances := by
    simp [trustDirection, contributedPrivate, contributedAffected]

def baselineTransformation : Transformation trustDirection where
  input := baselinePrivate
  output := baselineAffected
  advances := by simp [trustDirection, baselinePrivate, baselineAffected]

def contributionPath : CausalPath trustDirection trustFeed where
  steps := [contributedTransformation]
  connected := by simp [Chains]

def baselinePath : CausalPath trustDirection trustFeed where
  steps := [baselineTransformation]
  connected := by simp [Chains]

def baselineEndpoints : PathEndpoints baselinePath where
  first := baselineTransformation
  last := baselineTransformation
  startsWith := ⟨[], rfl⟩
  endsWith := ⟨[], rfl⟩

def contributionEndpoints : PathEndpoints contributionPath where
  first := contributedTransformation
  last := contributedTransformation
  startsWith := ⟨[], rfl⟩
  endsWith := ⟨[], rfl⟩

def trustCausalContribution :
    CausalContribution Bool TrustStage trustDirection trustFeed where
  leftPath := baselinePath
  rightPath := contributionPath
  leftEndpoints := baselineEndpoints
  rightEndpoints := contributionEndpoints
  sameDeclaredContext := rfl
  inputDiffers := by decide
  outputDiffers := by
    simp [baselineEndpoints, contributionEndpoints, baselineTransformation,
      contributedTransformation, baselineAffected, contributedAffected]

def acceptedDependence : Dependence trustDirection trustFeed where
  dependent := acceptingPrincipal
  contributorEntity := delegateEntity
  distinct := by
    intro equal
    have currentEqual := congrArg Entity.current equal
    simp [acceptingPrincipal, delegateEntity, baselinePrivate,
      contributedAffected] at currentEqual
  path := contributionPath
  contribution := contributedTransformation
  contributionOnPath := by simp [contributionPath]
  comparison := trustCausalContribution
  pathIsCompared := rfl
  contributionIsComparedEndpoint := rfl
  contributor := fun _ => delegateEntity
  suppliedByContributor := rfl
  relationState := acceptingPrincipal.current
  relationAtDependentState := rfl
  contributionIsFuture := by
    simp [acceptingPrincipal, contributedTransformation, trustDirection,
      baselinePrivate, contributedAffected]
  dependentOutput := contributedTransformation.output
  outputFollowsContribution := rfl
  determines := fun _ _ => False
  contributionUndeterminedByDependent := by simp

def involuntaryDependence : Dependence trustDirection trustFeed where
  dependent := unwillingPrincipal
  contributorEntity := delegateEntity
  distinct := by
    intro equal
    have currentEqual := congrArg Entity.current equal
    simp [unwillingPrincipal, delegateEntity, baselinePrivate,
      contributedAffected] at currentEqual
  path := contributionPath
  contribution := contributedTransformation
  contributionOnPath := by simp [contributionPath]
  comparison := trustCausalContribution
  pathIsCompared := rfl
  contributionIsComparedEndpoint := rfl
  contributor := fun _ => delegateEntity
  suppliedByContributor := rfl
  relationState := unwillingPrincipal.current
  relationAtDependentState := rfl
  contributionIsFuture := by
    simp [unwillingPrincipal, contributedTransformation, trustDirection,
      baselinePrivate, contributedAffected]
  dependentOutput := contributedTransformation.output
  outputFollowsContribution := rfl
  determines := fun _ _ => False
  contributionUndeterminedByDependent := by simp

def toyTrust : Trust trustDirection trustFeed where
  dependence := acceptedDependence
  accepted := by
    refine ⟨admissionConstraint, ?_, ?_⟩
    · simp [acceptedDependence, acceptingPrincipal, acceptingBoundary]
    · simp [acceptedDependence, contributedTransformation,
        admissionConstraint, contributedPrivate, contributedAffected]

def toyConfidence : Entity TrustCarrier → Entity TrustCarrier → Prop :=
  fun dependent contributor =>
    dependent = unwillingPrincipal ∧ contributor = delegateEntity

def toyPermission : Entity TrustCarrier → Entity TrustCarrier → Prop :=
  fun _ _ => False

theorem trustDoesNotEntailConfidenceOrPermission :
    Nonempty (Trust trustDirection trustFeed) ∧
      ¬ toyConfidence
        toyTrust.dependence.dependent
        toyTrust.dependence.contributorEntity ∧
      ¬ toyPermission
        toyTrust.dependence.dependent
        toyTrust.dependence.contributorEntity := by
  constructor
  · exact ⟨toyTrust⟩
  constructor
  · intro confidence
    have principalEqual := confidence.1
    have constraintsEqual := congrArg
      (fun entity => entity.boundary.constraints.length)
      principalEqual
    simp [toyTrust, acceptedDependence, acceptingPrincipal,
      acceptingBoundary, unwillingPrincipal, closedBoundary] at constraintsEqual
  · simp [toyPermission]

theorem involuntaryDependenceIsNotAccepted :
    ¬ involuntaryDependence.isAccepted := by
  intro accepted
  rcases accepted with ⟨constraint, maintained, permitted⟩
  simp [involuntaryDependence, unwillingPrincipal, closedBoundary] at maintained

theorem confidenceAndDependenceDoNotEntailTrust :
    toyConfidence
        involuntaryDependence.dependent
        involuntaryDependence.contributorEntity ∧
      ¬ involuntaryDependence.isTrusted := by
  constructor
  · simp [toyConfidence, involuntaryDependence]
  · intro trusted
    rcases trusted with ⟨trust, equality⟩
    apply involuntaryDependenceIsNotAccepted
    simpa [equality] using trust.accepted

def behavioralProfile :
    AlignmentProfile ToyAlignmentPresence ToyAlignmentPresence where
  specification := {
    scope := ⟨fun _ => True⟩
    conforms := fun pair =>
      (pair.1 = .accurateRepresentation ∨
        pair.1 = .mistakenRepresentation) ∧
      pair.2 = .requestedTarget
    decideConformity := fun pair =>
      decide
        ((pair.1 = .accurateRepresentation ∨
          pair.1 = .mistakenRepresentation) ∧
         pair.2 = .requestedTarget)
    conformityCorrect := by
      intro pair
      simp
    conformityWithinScope := by simp
  }

def incompatibleProfile :
    AlignmentProfile ToyAlignmentPresence ToyAlignmentPresence where
  specification := {
    scope := ⟨fun _ => True⟩
    conforms := fun pair => False
    decideConformity := fun _ => false
    conformityCorrect := by simp
    conformityWithinScope := by simp
  }

def accurateAlignment : Alignment behavioralProfile where
  subject := toyTruthSemantics.representationFor .accurate
  target := .requestedTarget
  conforms := by simp [behavioralProfile, toyTruthSemantics]

def mistakenClaimAlignment : Alignment behavioralProfile where
  subject := toyTruthSemantics.representationFor .mistaken
  target := .requestedTarget
  conforms := by simp [behavioralProfile, toyTruthSemantics]

theorem alignmentIsProfileScoped :
    behavioralProfile.specification.conforms
        (accurateAlignment.subject, accurateAlignment.target) ∧
      ¬ incompatibleProfile.specification.conforms
        (accurateAlignment.subject, accurateAlignment.target) := by
  simp [accurateAlignment, behavioralProfile, incompatibleProfile,
    toyTruthSemantics]

theorem alignmentDoesNotEntailIdentity :
    Nonempty (Alignment behavioralProfile) ∧
      accurateAlignment.subject ≠ accurateAlignment.target := by
  constructor
  · exact ⟨accurateAlignment⟩
  · decide

theorem alignedClaimDoesNotEntailTruth :
    mistakenClaimAlignment.subject =
        toyTruthSemantics.representationFor .mistaken ∧
      behavioralProfile.specification.conforms
        (mistakenClaimAlignment.subject, mistakenClaimAlignment.target) ∧
      ¬ toyTruthSemantics.isTrue .mistaken := by
  simp [mistakenClaimAlignment, behavioralProfile,
    TruthSemantics.isTrue, toyTruthSemantics, toyTruthSpecification]

def claimCarriedByContribution :
    Transformation trustDirection → ToyClaim
  | _ => .accurate

structure JointSituation where
  claim : ToyClaim
  truth : toyTruthSemantics.isTrue claim
  trust : Trust trustDirection trustFeed
  alignment : Alignment behavioralProfile
  contributionCarriesClaim :
    claimCarriedByContribution trust.dependence.contribution = claim
  alignmentUsesClaimRepresentation :
    alignment.subject = toyTruthSemantics.representationFor claim

def jointSituation : JointSituation where
  claim := .accurate
  truth := by
    simp [TruthSemantics.isTrue, toyTruthSemantics,
      toyTruthSpecification]
  trust := toyTrust
  alignment := accurateAlignment
  contributionCarriesClaim := rfl
  alignmentUsesClaimRepresentation := rfl

theorem truthTrustAndAlignmentAreJointlyInhabited :
    Nonempty JointSituation :=
  ⟨jointSituation⟩

end DanielOntology
