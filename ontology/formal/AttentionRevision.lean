import OrganonCore

/-!
Bounded tests for revised D114 in ontology/ontology.md.
This is NOT a complete canonical Attention encoding.
Entity identity and perceptual/interpretive response are supplied projections.
Natural numbers index a local trace, not a definition of Time. Scope declares
which samples are tested; no continuity between samples is proved. Response
contrast is a local causal model, not proof of a physical mechanism or canonical
Causal Contribution. No finite channel inventory or fixed focal/contrast pair
is required. Love is withdrawn; the historical finite measurement does not
prove revised Attention or the revised Attention-to-Action join of Care.
-/

namespace DanielOntology.AttentionRevision

def tracks {Participant TargetState Context Response : Type}
    (state : Participant → Nat → TargetState)
    (context : Nat → Context)
    (respond : Participant → Participant → Nat → TargetState → Context → Response)
    (scope : Scope Nat) (observer target : Participant) : Prop :=
  observer ≠ target ∧
  (∃ first second, scope.includes first ∧ scope.includes second ∧
    first < second ∧ state target first ≠ state target second) ∧
  ∀ step, scope.includes step → ∃ contrast,
    respond observer target step (state target step) (context step) ≠
      respond observer target step contrast (context step)

-- An unrelated/context-only response cannot supply target sensitivity.
theorem invariantResponseExcludesTracking {Participant TargetState Context Response : Type}
    (state : Participant → Nat → TargetState) (context : Nat → Context)
    (respond : Participant → Participant → Nat → TargetState → Context → Response)
    (scope : Scope Nat) (observer target : Participant) (step : Nat)
    (included : scope.includes step)
    (invariant : ∀ contrast,
      respond observer target step (state target step) (context step) =
        respond observer target step contrast (context step)) :
    ¬ tracks state context respond scope observer target := by
  intro tracking
  obtain ⟨contrast, different⟩ := tracking.2.2 step included
  exact different (invariant contrast)

def changingState (_participant : Bool) (step : Nat) : Bool := step == 1
def changingContext (step : Nat) : Bool := step == 1
def episode : Scope Nat := ⟨fun step => step < 2⟩
def extendedEpisode : Scope Nat := ⟨fun step => step < 3⟩
def singletonEpisode : Scope Nat := ⟨fun step => step = 0⟩

-- Only false's response to true is sensitive, and only during this episode.
def oneWay (observer target : Bool) (step : Nat) (state context : Bool) : Bool :=
  if observer = false ∧ target = true ∧ step < 2 then state else context

theorem directedTracking :
    tracks changingState changingContext oneWay episode false true := by
  refine ⟨by decide, ⟨0, 1, by simp [episode], by simp [episode], by decide, by decide⟩, ?_⟩
  intro step included
  refine ⟨!(changingState true step), ?_⟩
  have bound : step < 2 := included
  simp [oneWay, bound]

theorem noRequiredReciprocity :
    ¬ tracks changingState changingContext oneWay episode true false := by
  apply invariantResponseExcludesTracking _ _ _ _ _ _ 0 (by simp [episode])
  intro contrast
  simp [oneWay]

def reciprocal (observer target : Bool) (_step : Nat) (state context : Bool) : Bool :=
  if observer ≠ target then state else context

theorem reciprocityIsPermitted (observer target : Bool) (other : observer ≠ target) :
    tracks changingState changingContext reciprocal episode observer target := by
  refine ⟨other, ⟨0, 1, by simp [episode], by simp [episode], by decide, ?_⟩, ?_⟩
  · simp [changingState]
  · intro step _
    refine ⟨!(changingState target step), ?_⟩
    simp [reciprocal, other]

theorem attentionCanCease :
    tracks changingState changingContext oneWay episode false true ∧
    ¬ tracks changingState changingContext oneWay extendedEpisode false true := by
  refine ⟨directedTracking, ?_⟩
  apply invariantResponseExcludesTracking _ _ _ _ _ _ 2 (by simp [extendedEpisode])
  intro contrast
  simp [oneWay]

-- Context happens to covary with the target, but does not respond to it.
def contextOnly (_observer _target : Bool) (_step : Nat) (_state context : Bool) : Bool :=
  context

theorem covariationDoesNotSupplyTracking :
    (∀ step, contextOnly false true step (changingState true step) (changingContext step) =
      changingState true step) ∧
    ¬ tracks changingState changingContext contextOnly episode false true := by
  refine ⟨fun _ => rfl, ?_⟩
  apply invariantResponseExcludesTracking _ _ _ _ _ _ 0 (by simp [episode])
  exact fun _ => rfl

theorem isolatedSampleDoesNotSupplyPersistence :
    ¬ tracks changingState changingContext oneWay singletonEpisode false true := by
  rintro ⟨_, ⟨first, second, firstIncluded, secondIncluded, ordered, _⟩, _⟩
  have firstZero : first = 0 := firstIncluded
  have secondZero : second = 0 := secondIncluded
  omega

def pairedState (participant : Bool) (step : Nat) : Bool × Bool :=
  (changingState participant step, step == 2)

def narrowResponse (observer target : Bool) (step : Nat)
    (state : Bool × Bool) (context : Bool) : Bool :=
  oneWay observer target step state.1 context

theorem trackingNeedNotDetectEveryDifference :
    tracks pairedState changingContext narrowResponse episode false true ∧
    narrowResponse false true 0 (false, false) false =
      narrowResponse false true 0 (false, true) false := by
  refine ⟨⟨by decide, ⟨0, 1, by simp [episode], by simp [episode],
    by decide, by decide⟩, ?_⟩, rfl⟩
  intro step included
  refine ⟨(!(pairedState true step).1, (pairedState true step).2), ?_⟩
  have bound : step < 2 := included
  simp [narrowResponse, oneWay, bound]

end DanielOntology.AttentionRevision
