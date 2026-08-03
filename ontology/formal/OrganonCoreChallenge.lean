import OrganonCorePreservation

/-!
# Falsification seam for the Absence-free reduct

This module states the smallest absence-free translations needed to challenge
the reduct at Presence, Reality, Missingness, Persistence, and Entity. It does
not claim term-for-term parity with the binding prose ontology.

The carrier type is the local universe of discourse. A value of the carrier is
therefore available without first classifying an object-level Absence. Reality
membership is total over that carrier. Missingness remains a scoped failure of
membership, not an uninhabited carrier.

Persistence and Entity are tested over explicit ordered histories. `Entity`
now carries the witness required by the binding prose rather than merely a
current State and a preservation-capable Boundary.
-/

universe u

namespace DanielOntology.OrganonCoreReduct

abbrev CorePresence (α : Type u) : Prop := Nonempty α

def CoreRealityMember {α : Type u} (_value : α) : Prop := True

def CoreMissingness
    {α : Type u}
    (field : Field α)
    (expected : α) : Prop :=
  ¬ field.contains expected

theorem everyValueIsInCoreReality {α : Type u} (value : α) :
    CoreRealityMember value :=
  trivial

theorem missingnessTranslation
    {α : Type u}
    (missingness : Missingness α) :
    CoreMissingness missingness.field missingness.expected :=
  missingness.missing

structure PersistenceCandidate
    {Carrier : Type u}
    (direction : Direction Carrier) where
  states : List (State Carrier)
  invariant : Invariant Carrier

def ClassifiesPersistence
    {Carrier : Type u}
    {direction : Direction Carrier}
    (candidate : PersistenceCandidate direction) : Prop :=
  (∃ first second rest, candidate.states = first :: second :: rest) ∧
  OrderedBy direction.before candidate.states ∧
  ∀ state, state ∈ candidate.states → candidate.invariant.holds state

/-!
For this challenge, the Configuration and identity Invariant are already
carried by `Entity`; the additional binding burden is an ordered history across
which that Invariant persists. This predicate is a challenge classifier, not a
replacement definition promoted into `OrganonCore`.
-/
def persistenceCandidate
    {Carrier : Type u}
    (entity : Entity Carrier) :
    PersistenceCandidate entity.persistenceDirection where
  states := entity.persistence.states
  invariant := entity.identity

theorem entityMeetsPersistenceClassification
    {Carrier : Type u}
    (entity : Entity Carrier) :
    ClassifiesPersistence (persistenceCandidate entity) := by
  constructor
  · exact entity.persistence.hasTransition
  constructor
  · exact entity.persistence.ordered
  · exact entityIdentityPersists entity

theorem historyClassificationPreserved
    {Carrier : Type u}
    {direction : Direction Carrier}
    (candidate : PersistenceCandidate direction)
    (left right : ExtensionSemantics) :
    evaluate (fun case => ClassifiesPersistence case) left candidate ↔
      evaluate (fun case => ClassifiesPersistence case) right candidate := by
  rfl

end DanielOntology.OrganonCoreReduct
