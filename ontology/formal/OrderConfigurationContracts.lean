import MathematicalOrder
import ConfigurationIntegration

/-!
# Order and Configuration integration promotion contracts

These theorems are the proof-checked interface between
`proposals/order-and-configuration-integration-claims.json` and its formal
shadows `MathematicalOrder` and `ConfigurationIntegration`. As in
`PromotionContracts.lean`, each theorem deliberately restates, as one exact
proposition, facts that already follow from structure fields, module lemmas, or
finite witnesses. The redundancy fixes the claim CI must keep elaborating if the
underlying modules change. The `OC-*` IDs are the manifest's statement IDs; the
module-local `MO-*` and `CI-*` markers are not reused.

Boundaries carried from the shadows:

* Order. `MemberOrder.relation` is a supplied metalinguistic extension of
  ordered pairs on a declared member Set. It is not the registered Relation, not
  an empirical classifier of which Presences precede others, and never total by
  assumption. The legacy institutional label (Coordination Order, D046) is not
  formalized here as a `MemberOrder`.
* Direction. Core `Direction` remains asymmetric only. OC-C1 exhibits a cyclic
  asymmetric Direction that is not the strict part of any `MemberOrder`.
* Entity. The core `Entity` record is a witness bundle for an Entity claim over
  States, not the Presence it reidentifies. Its record equality and its local
  Invariant are not an empirical individuation criterion.
* Model. Perception and Memory are not canonically typed; the concrete pipeline
  supplies them as constant functions.

Logic. Order identity uses `propext` and `funext` (via `setExt` and relation
extensionality) plus proof irrelevance for the law fields. OC-D1 also inherits
`Classical.choice` (through `Classical.em`) from the strict-or-Identity recovery
in `MathematicalOrder`; the other contracts use at most `propext` and
`Quot.sound`. No `sorry`, `admit`, or project axiom is used.
-/

universe u v

namespace DanielOntology.OrderConfigurationContracts

open DanielOntology
open DanielOntology.SetConfiguration
open DanielOntology.MathematicalOrder
open DanielOntology.ConfigurationIntegration

/-! ## Order -/

/-- Two member Orders with the same members and the same ordered-pair extension
are one Order; the law fields are proofs and add no identity. -/
theorem memberOrderExt {α : Type u} {o p : MemberOrder α}
    (members : ∀ a, o.members.contains a ↔ p.members.contains a)
    (relation : ∀ a b, o.relation a b ↔ p.relation a b) : o = p := by
  have hm : o.members = p.members := setExt members
  have hr : o.relation = p.relation :=
    funext fun a => funext fun b => propext (relation a b)
  cases o
  cases p
  cases hm
  cases hr
  rfl

/-- The bottom < middle < top chain without the incomparable `side` member. -/
def chainOnly : MemberOrder Mark :=
  ofStrict (ofList [.bottom, .middle, .top]) markLt
    (by intro a b h; cases a <;> cases b <;> simp_all [markLt, ofList])
    (by intro a h; cases a <;> exact h)
    (by intro a b c h h'; cases a <;> cases b <;> cases c <;> simp_all [markLt])

theorem chainOnlyTotal : chainOnly.Total := by
  intro a b ha hb
  cases a <;> cases b <;>
    simp_all [chainOnly, ofStrict, markLt, ofList, Identity]

-- organon:contract OC-D1 begin
/-- organon:promotion-contract OC-D1 -/
theorem orderDefinitionContract {α : Type u} :
    (∀ o p : MemberOrder α,
      Identity o p ↔
        (∀ a, o.members.contains a ↔ p.members.contains a) ∧
        (∀ a b, o.relation a b ↔ p.relation a b)) ∧
    (∀ o : MemberOrder α,
      (∀ a b, o.relation a b → o.members.contains a ∧ o.members.contains b) ∧
      (∀ a, o.members.contains a → o.relation a a) ∧
      (∀ a b, o.relation a b → o.relation b a → Identity a b) ∧
      (∀ a b c, o.relation a b → o.relation b c → o.relation a c) ∧
      (∀ a b, o.strict a b ↔ o.relation a b ∧ Difference a b) ∧
      (∀ a, ¬ o.strict a a) ∧
      (∀ a b, o.strict a b → ¬ o.strict b a) ∧
      (∀ a b c, o.strict a b → o.strict b c → o.strict a c) ∧
      (∀ a b, o.members.contains a → o.members.contains b →
        (o.relation a b ↔ o.strict a b ∨ Identity a b)) ∧
      (o.Total ↔ ∀ a b, o.members.contains a → o.members.contains b →
        o.strict a b ∨ Identity a b ∨ o.strict b a)) ∧
    (∀ (members : Set α) (lt : α → α → Prop),
      (∀ a b, lt a b → members.contains a ∧ members.contains b) →
      (∀ a, ¬ lt a a) →
      (∀ a b c, lt a b → lt b c → lt a c) →
      ∃ o : MemberOrder α, Identity o.members members ∧
        ∀ a b, (o.strict a b ↔ lt a b)) := by
  refine ⟨?_, ?_, orderStrictLaws.2⟩
  · intro o p
    constructor
    · intro same
      cases same
      exact ⟨fun _ => Iff.rfl, fun _ _ => Iff.rfl⟩
    · rintro ⟨sameMembers, sameRelation⟩
      exact memberOrderExt sameMembers sameRelation
  · intro o
    obtain ⟨_, irreflexive, asymmetric, transitive, recovery, total⟩ :=
      orderStrictLaws.1 o
    exact ⟨o.bounded, o.reflexive, o.antisymmetric, o.transitive,
      fun _ _ => Iff.rfl, irreflexive, asymmetric, transitive, recovery, total⟩
-- organon:contract OC-D1 end

-- organon:contract OC-C1 begin
/-- organon:promotion-contract OC-C1 -/
theorem orderCountermodelContract :
    (chainWithSide.strict .bottom .middle ∧ chainWithSide.strict .middle .top ∧
      chainWithSide.strict .bottom .top ∧ ¬ chainWithSide.strict .top .bottom ∧
      chainWithSide.Incomparable .side .middle ∧ ¬ chainWithSide.Total ∧
      ¬ chainWithSide.members.contains .outside ∧
      ¬ chainWithSide.relation .outside .outside) ∧
    (chainOnly.Total ∧ ¬ chainOnly.members.contains .side ∧
      ∀ a b, (chainOnly.strict a b ↔ chainWithSide.strict a b)) ∧
    ((∀ s t : State Turn, cycleDirection.before s t → ¬ cycleDirection.before t s) ∧
      cycleDirection.before ⟨.first⟩ ⟨.second⟩ ∧
      cycleDirection.before ⟨.second⟩ ⟨.third⟩ ∧
      cycleDirection.before ⟨.third⟩ ⟨.first⟩ ∧
      ¬ cycleDirection.before ⟨.first⟩ ⟨.third⟩ ∧
      ¬ ∃ o : MemberOrder (State Turn),
        ∀ s t, (o.strict s t ↔ cycleDirection.before s t)) ∧
    ((∀ a : Empty, ¬ (emptyOrder Empty).members.contains a) ∧
      (emptyOrder Empty).Total ∧
      ∀ α : Type u, ∀ a b : α,
        ¬ (emptyOrder α).members.contains a ∧ ¬ (emptyOrder α).relation a b) := by
  obtain ⟨chain, ⟨first, second, notThird, noOrder⟩, empty⟩ :=
    finiteOrderCountermodels.{u}
  refine ⟨chain, ⟨chainOnlyTotal, ?_, ?_⟩,
    ⟨fun _ _ h => cycleDirection.asymmetric h, first, second, trivial, notThird,
      noOrder⟩, empty⟩
  · simp [chainOnly, ofStrict, ofList]
  · intro a b
    exact (ofStrictStrict _ _ _ _ _ a b).trans (ofStrictStrict _ _ _ _ _ a b).symm
-- organon:contract OC-C1 end

/-! ## Indexed structured State -/

-- organon:contract OC-D2 begin
/-- organon:promotion-contract OC-D2 -/
theorem indexedStateContract {Index : Type u} {α : Type v}
    {realizes : α → List α → Prop} :
    (∀ s t : ConfigState Index α realizes,
      Identity s t ↔
        Identity (indexOf s) (indexOf t) ∧
        (∀ a, (configurationOf s).members.contains a ↔
          (configurationOf t).members.contains a) ∧
        (∀ r ps, (configurationOf s).associations.contains (r, ps) ↔
          (configurationOf t).associations.contains (r, ps))) ∧
    (∀ (i : Index) (c d : Configuration α realizes),
      Identity (atIndex i c) (atIndex i d) ↔ Identity c d) ∧
    (∀ (i : Index) (c d : Configuration α realizes) (r : α) (ps : List α),
      c.associations.contains (r, ps) → ¬ d.associations.contains (r, ps) →
        Difference (atIndex i c) (atIndex i d)) ∧
    (∀ (i j : Index) (c : Configuration α realizes),
      Difference i j → Difference (atIndex i c) (atIndex j c)) ∧
    (∀ (i : Index) (c : Configuration α realizes) (r : α) (ps : List α),
      (configurationOf (atIndex i c)).associations.contains (r, ps) ↔
        c.associations.contains (r, ps)) ∧
    (∀ (i : Index) (c : Configuration α realizes),
      Identity (indexOf (atIndex i c)) i ∧
        Identity (configurationOf (atIndex i c)) c) := by
  exact ⟨configStateIdentity, sameIndexIdentity,
    fun i c d r ps selected unselected =>
      structureSeparatesStates i c d r ps selected unselected,
    indexSeparatesStates, indexAddsNoAssociation, fun _ _ => ⟨rfl, rfl⟩⟩
-- organon:contract OC-D2 end

/-! ## Entity over indexed structured States -/

-- organon:contract OC-D3 begin
/-- organon:promotion-contract OC-D3 -/
theorem entityPresenceContract {Index : Type u} {α : Type v}
    {realizes : α → List α → Prop}
    (entity : Entity (IndexedConfiguration Index α realizes)) :
    Identity entity.persistence.invariant entity.identity ∧
    OrderedBy entity.persistenceDirection.before entity.persistence.states ∧
    (∀ state : ConfigState Index α realizes,
      state ∈ entity.persistence.states → entity.identity.holds state) ∧
    entity.current ∈ entity.persistence.states ∧
    (∃ first second : ConfigState Index α realizes,
      first ∈ entity.persistence.states ∧ second ∈ entity.persistence.states ∧
      entity.identity.holds first ∧ entity.identity.holds second ∧
      entity.persistenceDirection.before first second ∧
      ¬ (Identity (indexOf first) (indexOf second) ∧
        Identity (configurationOf first) (configurationOf second))) := by
  refine ⟨entity.persistenceNamesIdentity, entity.persistence.ordered,
    entityIdentityPersists entity, entity.currentInPersistence, ?_⟩
  rcases entity.persistence.hasTransition with ⟨first, second, rest, history⟩
  have ordered : entity.persistenceDirection.before first second := by
    have full := entity.persistence.ordered
    rw [history] at full
    exact full.1
  have firstIn : first ∈ entity.persistence.states := by simp [history]
  have secondIn : second ∈ entity.persistence.states := by simp [history]
  refine ⟨first, second, firstIn, secondIn,
    entityIdentityPersists entity first firstIn,
    entityIdentityPersists entity second secondIn, ordered, ?_⟩
  rintro ⟨sameIndex, sameConfiguration⟩
  have same : Identity first second :=
    (configStateIdentity first second).mpr
      ⟨sameIndex, fun a => by rw [sameConfiguration],
        fun r ps => by rw [sameConfiguration]⟩
  cases same
  exact entity.persistenceDirection.asymmetric ordered ordered
-- organon:contract OC-D3 end

/-! ## Configured Boundary -/

-- organon:contract OC-D4 begin
/-- organon:promotion-contract OC-D4 -/
theorem configuredBoundaryContract {Carrier : Type u} {β : Type v}
    {realizes : β → List β → Prop} :
    (∀ e : ConfiguredEntity Carrier β realizes,
      Identity e.entity.boundary (e.boundaryConfiguration.toBoundary e.listing) ∧
      (∀ b, e.boundaryConfiguration.configuration.members.contains b →
        ∃ c, e.boundaryConfiguration.constraintOf b = some c) ∧
      (∀ c, c ∈ e.entity.boundary.constraints ↔
        ∃ b, e.boundaryConfiguration.configuration.members.contains b ∧
          e.boundaryConfiguration.constraintOf b = some c) ∧
      (∀ {direction : Direction Carrier} (t : Transformation direction),
        (∀ b c, e.boundaryConfiguration.configuration.members.contains b →
          e.boundaryConfiguration.constraintOf b = some c → c.permits t) →
        e.entity.identity.holds t.input → e.entity.identity.holds t.output)) ∧
    (∀ (identity : Invariant Carrier)
      (first second : ConfiguredBoundary Carrier identity β realizes)
      (firstListing : FiniteListing first.configuration.members)
      (secondListing : FiniteListing second.configuration.members),
      Identity first.constraintOf second.constraintOf →
      Identity firstListing.items secondListing.items →
      Identity (first.toBoundary firstListing).constraints
        (second.toBoundary secondListing).constraints) := by
  refine ⟨fun e => ⟨e.boundaryProjects, e.boundaryConfiguration.membersAreConstraints,
    (configuredEntityBoundary e).1, fun t => (configuredEntityBoundary e).2 t⟩, ?_⟩
  intro identity first second firstListing secondListing sameInterpretation sameItems
  change firstListing.items.filterMap first.constraintOf =
    secondListing.items.filterMap second.constraintOf
  rw [sameInterpretation, sameItems]
-- organon:contract OC-D4 end

/-! ## Structured Model -/

-- organon:contract OC-D5 begin
/-- organon:promotion-contract OC-D5 -/
theorem structuredModelContract {Carrier : Type u} {direction : Direction Carrier}
    {β : Type u} {realizes : β → List β → Prop} {Target : Type u}
    (model : StructuredModel Carrier direction β realizes Target) :
    (∀ b, model.configuration.members.contains b →
      (∃ d, model.denotationOf b = some d) ∨
        (∃ t, model.transformationOf b = some t)) ∧
    model.configuration.associations.contains
        (model.joinRelation, [model.representation, model.transformation]) ∧
    model.configuration.members.contains model.representation ∧
    model.configuration.members.contains model.transformation ∧
    model.denotationOf model.representation = some model.denotation ∧
    Identity model.denotation.expression model.representation ∧
    model.transformationOf model.transformation = some model.joinedTransformation ∧
    (∀ c, c ∈ model.constraints → c.permits model.joinedTransformation) ∧
    (∀ s : Set β, Difference model.configuration (discrete s)) := by
  obtain ⟨joined, denotes, expression, realized, permitted, notDiscrete⟩ :=
    structuredModelRetainsJoin model
  exact ⟨model.membersOrganized, joined, model.representationMember,
    model.transformationMember, denotes, expression, realized, permitted, notDiscrete⟩
-- organon:contract OC-D5 end

/-! ## Finite downstream witnesses -/

-- organon:contract OC-C2 begin
/-- organon:promotion-contract OC-C2 -/
theorem stateBoundaryWitnessContract :
    (Identity (configurationOf (plainAt 0)).members
        (configurationOf (linkedAt 0)).members ∧
      Identity (indexOf (plainAt 0)) (indexOf (linkedAt 0)) ∧
      Difference (plainAt 0) (linkedAt 0)) ∧
    (Identity (configurationOf (linkedAt 0)) (configurationOf (linkedAt 1)) ∧
      Difference (linkedAt 0) (linkedAt 1)) ∧
    (Identity coupledBoundary.configuration.members looseBoundary.configuration.members ∧
      Identity coupledBoundary.constraintOf looseBoundary.constraintOf ∧
      coupledBoundary.configuration.associations.contains
        (.coupling, [.membersGuard, .medium]) ∧
      ¬ looseBoundary.configuration.associations.contains
        (.coupling, [.membersGuard, .medium]) ∧
      ¬ coupledBoundary.configuration.members.contains .medium ∧
      coupledBoundary.constraintOf .medium = none ∧
      Difference coupledBoundary looseBoundary ∧
      Identity (coupledBoundary.toBoundary guardListing).constraints
        (looseBoundary.toBoundary guardListing).constraints ∧
      Identity (coupledBoundary.toBoundary guardListing).constraints
        [membersGuard, linkGuard]) := by
  obtain ⟨⟨sameMembers, structureDiffers⟩, ⟨sameConfiguration, indexDiffers⟩⟩ :=
    witnessStateSeparation
  obtain ⟨sameGuards, boundariesDiffer, ⟨coupled, mediumOutside, _, mediumNone⟩,
    sameProjection⟩ := boundaryStructureRetained
  refine ⟨⟨sameMembers, rfl, structureDiffers⟩, ⟨sameConfiguration, indexDiffers⟩,
    ⟨sameGuards, rfl, coupled, ?_, mediumOutside, mediumNone, boundariesDiffer,
      congrArg Boundary.constraints sameProjection, rfl⟩⟩
  intro selected
  exact selected
-- organon:contract OC-C2 end

-- organon:contract OC-C3 begin
/-- organon:promotion-contract OC-C3 -/
theorem entityWitnessContract :
    Identity linkEntity.persistence.states [plainAt 0, linkedAt 1] ∧
    Identity linkEntity.current (linkedAt 1) ∧
    linkEntity.persistenceDirection.before (plainAt 0) (linkedAt 1) ∧
    linkEntity.identity.holds (plainAt 0) ∧
    linkEntity.identity.holds (linkedAt 1) ∧
    Difference (indexOf (plainAt 0)) (indexOf (linkedAt 1)) ∧
    Difference (configurationOf (plainAt 0)) (configurationOf (linkedAt 1)) ∧
    Identity (configurationOf (plainAt 0)).members
      (configurationOf (linkedAt 1)).members ∧
    (linkEntity.identity.holds (plainAt 5) ∧
      plainAt 5 ∉ linkEntity.persistence.states) ∧
    Identity linkConfiguredEntity.entity linkEntity ∧
    Identity linkEntity.boundary (coupledBoundary.toBoundary guardListing) ∧
    Identity linkEntity.boundary.constraints
      (looseBoundary.toBoundary guardListing).constraints := by
  obtain ⟨_, _, plainHolds, linkedHolds, _, indexDiffers, configurationDiffers,
    sameMembers, sameEntity⟩ := linkEntitySpansDistinctStates
  exact ⟨rfl, rfl, ⟨rfl, rfl⟩, plainHolds, linkedHolds, indexDiffers,
    configurationDiffers, sameMembers, invariantDoesNotAdmitHistory, sameEntity, rfl,
    congrArg Boundary.constraints boundaryStructureRetained.2.2.2⟩
-- organon:contract OC-C3 end

-- organon:contract OC-C4 begin
/-- organon:promotion-contract OC-C4 -/
theorem pipelineModelWitnessContract :
    Identity (structuredPipeline.modelFor ()) linkModel ∧
    (structuredPipeline.modelFor ()).configuration.associations.contains
        (.joins, [.sketch, .linking]) ∧
    Identity (structuredPipeline.modelFor ()).joinedTransformation linkFormation ∧
    Identity (structuredPipeline.modelFor ()).joinedTransformation.input
      (structuredPipeline.perceive ()) ∧
    Identity (structuredPipeline.modelFor ()).joinedTransformation.output (linkedAt 1) ∧
    Identity (structuredPipeline.modelFor ()).denotation.target (linkedAt 1) ∧
    Identity (structuredPipeline.interpretationFor ()) (linkedAt 1) ∧
    Identity (structuredPipeline.modelFor ()).constraints [membersGuard, linkGuard] ∧
    (∀ c, c ∈ (structuredPipeline.modelFor ()).constraints →
      c.permits (structuredPipeline.modelFor ()).joinedTransformation) ∧
    Identity (structuredPipeline.modelFor ()).constraints linkEntity.boundary.constraints ∧
    Identity (structuredPipeline.perceive ()) (structuredPipeline.remember ()) ∧
    Difference (structuredPipeline.modelFor ()).configuration
      (discrete modelConfiguration.members) := by
  obtain ⟨joined, sameConstraints, target, input, interpretation, notDiscrete⟩ :=
    structuredPipelineRetainsModel
  exact ⟨rfl, joined, rfl, input, rfl, target, interpretation, sameConstraints,
    (structuredModelRetainsJoin linkModel).2.2.2.2.1, rfl, rfl, notDiscrete⟩
-- organon:contract OC-C4 end

end DanielOntology.OrderConfigurationContracts
