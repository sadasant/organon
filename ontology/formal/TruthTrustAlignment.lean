import DanielOntology

/-!
# Truth, Trust, and Alignment: formal shadows

This file tests the three relations proposed by D085-D087. It keeps their
participants explicit so correspondence, exposure, and conformity cannot be
identified merely because the same Claim or Entity participates in each.

`TruthSemantics` is a local bridge from a Claim to its declared Specification
and target in a reality model. It does not formalize Reality as the totality of
Presence. `Trust` records future, other-supplied, consequential exposure that
the trusting Entity does not determine. `AlignmentProfile` supplies the
directional Specification under which a subject may align to a reference.
-/

universe u v w x y

namespace DanielOntology

structure TruthSemantics (Claim Target : Type u) where
  specificationFor : Claim → Specification Target
  targetFor : Claim → Target
  targetInRealityModel : Target → Prop

def TruthSemantics.isTrue
    {Claim Target : Type u}
    (semantics : TruthSemantics Claim Target)
    (claim : Claim) : Prop :=
  semantics.targetInRealityModel (semantics.targetFor claim) ∧
    (semantics.specificationFor claim).conforms (semantics.targetFor claim)

structure EpistemicAccess (Agent Target : Type u) where
  suppliesTarget : Agent → Target → Prop

structure Trust
    {Carrier : Type u}
    (direction : Direction Carrier)
    (feeding : FeedRelation Carrier) where
  truster : Entity Carrier
  trustee : Entity Carrier
  distinct : truster ≠ trustee
  path : CausalPath direction feeding
  contribution : Transformation direction
  contributionOnPath : contribution ∈ path.steps
  contributor : Transformation direction → Entity Carrier
  suppliedByTrustee : contributor contribution = trustee
  relationState : State Carrier
  relationAtTrusterState : relationState = truster.current
  contributionIsFuture : direction.before relationState contribution.output
  consequence : State Carrier
  consequenceIsOutput : consequence = contribution.output
  exposureTransformation : Transformation direction
  exposureOnPath : exposureTransformation ∈ path.steps
  exposureIsContribution : exposureTransformation = contribution
  determines : Entity Carrier → Transformation direction → Prop
  contributionUndeterminedByTruster : ¬ determines truster contribution

structure AlignmentProfile (Subject Reference : Type u) where
  specification : Specification (Subject × Reference)

structure Alignment
    {Subject Reference : Type u}
    (profile : AlignmentProfile Subject Reference) where
  subject : Subject
  reference : Reference
  conforms : profile.specification.conforms (subject, reference)

/-! ## Finite satisfiability and anti-entailment witnesses -/

inductive ToyClaim where
  | accurate
  | mistaken
  deriving DecidableEq

inductive ToyTarget where
  | obtaining
  | excluded
  deriving DecidableEq

def toyTruthSpecification (claim : ToyClaim) : Specification ToyTarget where
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

def toyTruthSemantics : TruthSemantics ToyClaim ToyTarget where
  specificationFor := toyTruthSpecification
  targetFor
    | .accurate => .obtaining
    | .mistaken => .excluded
  targetInRealityModel
    | .obtaining => True
    | .excluded => True

def sealedAccess : EpistemicAccess Unit ToyTarget where
  suppliesTarget := fun _ _ => False

theorem truthDoesNotEntailAgentAccess :
    toyTruthSemantics.isTrue .accurate ∧
      ∀ agent,
        ¬ sealedAccess.suppliesTarget agent
          (toyTruthSemantics.targetFor .accurate) := by
  constructor
  · simp [TruthSemantics.isTrue, toyTruthSemantics, toyTruthSpecification]
  · intro agent
    simp [sealedAccess]

theorem claimAndRealityModelDoNotEntailTruth :
    toyTruthSemantics.targetInRealityModel
        (toyTruthSemantics.targetFor .mistaken) ∧
      ¬ toyTruthSemantics.isTrue .mistaken := by
  simp [TruthSemantics.isTrue, toyTruthSemantics, toyTruthSpecification]

inductive TrustCarrier where
  | privateState
  | deployedState
  deriving DecidableEq

def trustDirection : Direction TrustCarrier where
  before := fun first second =>
    first.value = .privateState ∧ second.value = .deployedState
  asymmetric := by
    intro first second forward backward
    simp_all

def trustFeed : FeedRelation TrustCarrier where
  feeds := fun _ _ => True

def trustIdentity : Invariant TrustCarrier where
  holds := fun _ => True

def trustBoundary : Boundary TrustCarrier trustIdentity where
  constraints := []
  preserves := by simp [trustIdentity]

def principalEntity : Entity TrustCarrier where
  identity := trustIdentity
  boundary := trustBoundary
  current := ⟨.privateState⟩
  identityHolds := by simp [trustIdentity]

def delegateEntity : Entity TrustCarrier where
  identity := trustIdentity
  boundary := trustBoundary
  current := ⟨.deployedState⟩
  identityHolds := by simp [trustIdentity]

def trustedTransformation : Transformation trustDirection where
  input := ⟨.privateState⟩
  output := ⟨.deployedState⟩
  advances := by simp [trustDirection]

def trustedPath : CausalPath trustDirection trustFeed where
  steps := [trustedTransformation]
  connected := by simp [Chains]

def toyTrust :
    Trust trustDirection trustFeed where
  truster := principalEntity
  trustee := delegateEntity
  distinct := by
    intro equal
    have currentEqual := congrArg Entity.current equal
    simp [principalEntity, delegateEntity] at currentEqual
  path := trustedPath
  contribution := trustedTransformation
  contributionOnPath := by simp [trustedPath]
  contributor := fun _ => delegateEntity
  suppliedByTrustee := rfl
  relationState := principalEntity.current
  relationAtTrusterState := rfl
  contributionIsFuture := by
    simp [principalEntity, trustedTransformation, trustDirection]
  consequence := trustedTransformation.output
  consequenceIsOutput := rfl
  exposureTransformation := trustedTransformation
  exposureOnPath := by simp [trustedPath]
  exposureIsContribution := rfl
  determines := fun _ _ => False
  contributionUndeterminedByTruster := by simp

def toyConfidence : Entity TrustCarrier → Entity TrustCarrier → Prop :=
  fun _ _ => False
def toyPermission : Entity TrustCarrier → Entity TrustCarrier → Prop :=
  fun _ _ => False

theorem trustDoesNotEntailConfidenceOrPermission :
    Nonempty (Trust trustDirection trustFeed) ∧
      ¬ toyConfidence toyTrust.truster toyTrust.trustee ∧
      ¬ toyPermission toyTrust.truster toyTrust.trustee := by
  exact ⟨⟨toyTrust⟩, by simp [toyConfidence], by simp [toyPermission]⟩

def confidentWithoutExposure :
    Entity TrustCarrier → Entity TrustCarrier → Prop :=
  fun truster trustee => truster = principalEntity ∧ trustee = delegateEntity

def emptyDirection : Direction Empty where
  before := fun _ _ => False
  asymmetric := by simp

def emptyFeed : FeedRelation Empty where
  feeds := fun _ _ => False

theorem confidenceDoesNotEntailTrust :
    confidentWithoutExposure principalEntity delegateEntity ∧
      ¬ Nonempty (Trust emptyDirection emptyFeed) := by
  constructor
  · simp [confidentWithoutExposure]
  · intro witness
    rcases witness with ⟨trust⟩
    exact Empty.elim trust.truster.current.value

inductive ToySubject where
  | first
  | second
  deriving DecidableEq

inductive ToyReference where
  | requested
  deriving DecidableEq

def behavioralProfile : AlignmentProfile ToySubject ToyReference where
  specification := {
    scope := ⟨fun _ => True⟩
    conforms := fun pair => pair.1 = .first
    decideConformity := fun pair => decide (pair.1 = .first)
    conformityCorrect := by
      intro pair
      simp
    conformityWithinScope := by simp
  }

def incompatibleProfile : AlignmentProfile ToySubject ToyReference where
  specification := {
    scope := ⟨fun _ => True⟩
    conforms := fun pair => pair.1 = .second
    decideConformity := fun pair => decide (pair.1 = .second)
    conformityCorrect := by
      intro pair
      simp
    conformityWithinScope := by simp
  }

def toyAlignment : Alignment behavioralProfile where
  subject := .first
  reference := .requested
  conforms := by simp [behavioralProfile]

def toyIdentity : ToySubject → ToyReference → Prop := fun _ _ => False

theorem alignmentIsProfileScoped :
    behavioralProfile.specification.conforms
        (toyAlignment.subject, toyAlignment.reference) ∧
      ¬ incompatibleProfile.specification.conforms
        (toyAlignment.subject, toyAlignment.reference) := by
  simp [toyAlignment, behavioralProfile, incompatibleProfile]

theorem alignmentDoesNotEntailIdentity :
    Nonempty (Alignment behavioralProfile) ∧
      ¬ toyIdentity toyAlignment.subject toyAlignment.reference := by
  constructor
  · exact ⟨toyAlignment⟩
  · simp [toyIdentity]

theorem alignmentDoesNotEntailTruth :
    Nonempty (Alignment behavioralProfile) ∧
      ¬ toyTruthSemantics.isTrue .mistaken := by
  exact ⟨⟨toyAlignment⟩, by
    simp [TruthSemantics.isTrue, toyTruthSemantics, toyTruthSpecification]⟩

theorem truthTrustAndAlignmentAreJointlyInhabited :
    toyTruthSemantics.isTrue .accurate ∧
      Nonempty (Trust trustDirection trustFeed) ∧
      Nonempty (Alignment behavioralProfile) := by
  exact ⟨by
    simp [TruthSemantics.isTrue, toyTruthSemantics, toyTruthSpecification],
    ⟨toyTrust⟩,
    ⟨toyAlignment⟩⟩

end DanielOntology
