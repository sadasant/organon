import DanielOntology

/-!
# World and Substrate: formal shadows

This file formalizes the dependency seams proposed by D083, D084, C12, and
C13. A World carries participants, scoped States, distinct access paths, an
included Causal path, and a common Invariant. A Substrate carries persistent
source States, Constraints, a scoped Causal path, and explicit Feeds witnesses.

The file does not formalize Reality as a total type, semantic Map fidelity,
the complete Sense/Perception path, or a universal realization relation.
-/

universe u v

namespace DanielOntology

structure AccessPath (Carrier : Type u) where
  pathId : Nat
  participant : Entity Carrier
  available : State Carrier → Prop

structure World
    {Carrier : Type u}
    (direction : Direction Carrier)
    (feeding : FeedRelation Carrier) where
  participants : List (Entity Carrier)
  participantsNonempty : participants ≠ []
  states : List (State Carrier)
  statesNonempty : states ≠ []
  scope : Scope (State Carrier)
  statesInScope : ∀ state, state ∈ states → scope.includes state
  accessPaths : List (AccessPath Carrier)
  accessPathsBelongToParticipants :
    ∀ access, access ∈ accessPaths → access.participant ∈ participants
  distinctAccessPaths :
    ∃ first,
      first ∈ accessPaths ∧
      ∃ second,
        second ∈ accessPaths ∧
        first.pathId ≠ second.pathId ∧
        ∃ state,
          state ∈ states ∧
          first.available state ≠ second.available state
  everyStateAvailable :
    ∀ state,
      state ∈ states →
        ∃ access, access ∈ accessPaths ∧ access.available state
  everyAccessPathAvailable :
    ∀ access,
      access ∈ accessPaths →
        ∃ state, state ∈ states ∧ access.available state
  accessAvailabilityWithinWorld :
    ∀ access,
      access ∈ accessPaths →
        ∀ state, access.available state → state ∈ states
  causalPath : CausalPath direction feeding
  causalPathInScope :
    ∀ transformation,
      transformation ∈ causalPath.steps →
        scope.includes transformation.input ∧
        scope.includes transformation.output
  commonInvariant : Invariant Carrier
  commonInvariantHolds :
    ∀ state, state ∈ states → commonInvariant.holds state

structure Substrate
    {Carrier : Type u}
    (direction : Direction Carrier)
    (feeding : FeedRelation Carrier) where
  carrierStates : List (State Carrier)
  carrierStatesNonempty : carrierStates ≠ []
  carrierInvariant : Invariant Carrier
  carrierInvariantHolds :
    ∀ state, state ∈ carrierStates → carrierInvariant.holds state
  constraints : List (Constraint Carrier)
  constraintsNonempty : constraints ≠ []
  scope : Scope (Transformation direction)
  path : CausalPath direction feeding
  pathNonempty : path.steps ≠ []
  pathInScope :
    ∀ transformation,
      transformation ∈ path.steps → scope.includes transformation
  admittedByConstraints :
    ∀ transformation,
      transformation ∈ path.steps →
        ∀ constraint,
          constraint ∈ constraints → constraint.permits transformation
  supplies :
    ∀ transformation,
      transformation ∈ path.steps →
        ∃ state,
          state ∈ carrierStates ∧
          feeding.feeds state transformation.input

theorem worldHasDistinctAccessPaths
    {Carrier : Type u}
    {direction : Direction Carrier}
    {feeding : FeedRelation Carrier}
    (world : World direction feeding) :
    ∃ first,
      first ∈ world.accessPaths ∧
      ∃ second,
        second ∈ world.accessPaths ∧
        first.pathId ≠ second.pathId ∧
        ∃ state,
          state ∈ world.states ∧
          first.available state ≠ second.available state :=
  world.distinctAccessPaths

theorem worldStatesShareInvariant
    {Carrier : Type u}
    {direction : Direction Carrier}
    {feeding : FeedRelation Carrier}
    (world : World direction feeding) :
    ∀ state, state ∈ world.states → world.commonInvariant.holds state :=
  world.commonInvariantHolds

theorem substrateSuppliesEveryStep
    {Carrier : Type u}
    {direction : Direction Carrier}
    {feeding : FeedRelation Carrier}
    (substrate : Substrate direction feeding) :
    ∀ transformation,
      transformation ∈ substrate.path.steps →
        ∃ state,
          state ∈ substrate.carrierStates ∧
          feeding.feeds state transformation.input :=
  substrate.supplies

theorem substrateConstraintsShapeEveryStep
    {Carrier : Type u}
    {direction : Direction Carrier}
    {feeding : FeedRelation Carrier}
    (substrate : Substrate direction feeding) :
    ∀ transformation,
      transformation ∈ substrate.path.steps →
        ∀ constraint,
          constraint ∈ substrate.constraints →
            constraint.permits transformation :=
  substrate.admittedByConstraints

end DanielOntology
