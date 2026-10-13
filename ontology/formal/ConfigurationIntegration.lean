import SetConfiguration
import IntelligenceKnowledge

/-!
# Structured Configuration in State, Entity, Boundary, and Model

`SetConfiguration` retains a member Set together with selected Relation/ordered
participant associations. This module puts that structure to work in the
generic core records without retyping them:

* State. `ConfigState Index α realizes` instantiates the generic
  `State Carrier` at an explicit metalinguistic index paired with a structured
  Configuration. State Identity is exactly Identity of index, member Set, and
  selected associations. Equal inventories with different selected
  structure yield different States at one index; one Configuration at two
  distinct indices yields two States. The index is not an association, so it
  adds no Relation to the Configuration.
* Direction. The witness Direction `formation` is fixed by Configuration
  content and ignores the index; it does not duplicate the indexing order.
* Entity. The generic `Entity` is inhabited over unequal structured States: one
  Entity value carries an ordered history from an unlinked to a linked
  Configuration at distinct indices under one member-inventory Invariant. Every
  Entity whose carrier is `IndexedConfiguration` has two history States that
  do not agree in both index and Configuration.
* Boundary. `ConfiguredBoundary` retains the Constraint Configuration: its
  members are interpreted as Constraints, its selected associations may have
  participants that are neither members nor Constraints, and its preservation
  obligation quantifies over every member Constraint. `toBoundary` projects it
  to the unchanged core `Boundary` through an explicit finite listing. The
  projection forgets the selected structure: two Configured Boundaries with
  equal members and unequal structure project to the same core Boundary.
  `ConfiguredEntity` ties an Entity's core Boundary to such a retained
  Configuration by an equation.
* Model. `StructuredModel` is an organized Configuration whose members are each
  interpreted as a Representation (via a core `Denotation` whose expression is
  that member) or as a Transformation. It retains one selected join
  association between a Representation member and a Transformation member, and
  a supplied Constraint list permitting the joined Transformation. A discrete
  Configuration (no selected structure) cannot carry a StructuredModel. A
  concrete `CognitivePipeline` uses it as its `Model` parameter unchanged.

Boundaries:

* Interpretation. `realizes`, `constraintOf`, `denotationOf`, and
  `transformationOf` are supplied interpretations, not empirical classifiers.
  Nothing here decides which actual Presences are Constraints,
  Representations, or Transformations.
* Entity. The core `Entity` is an Entity claim's witness bundle over States,
  not the Presence it reidentifies or any one snapshot Configuration. Its
  record equality is not an empirical individuation criterion. The witness
  Invariant (a fixed member inventory) is a local criterion; satisfying it
  alone neither identifies an Entity nor places a State in its history.
* Boundary. Lists encode only finite Boundaries for the core projection; the
  Configured Boundary itself need not be finite. The core `Constraint` remains a
  predicate on Transformations, not a typed persistent Relation.
* Model. Perception and Memory are not typed canonically: the joined
  Transformation's input is a supplied State, and the pipeline reads its output
  as the later State. The Model's own Constraint list is supplied data, not a
  derived consequence of a Boundary.
* Logic. Theorems use at most `propext` and `Quot.sound`; no
  `Classical.choice`, `sorry`, or project axiom is used.

Generic State, Direction, Transformation, Entity, Boundary, and the
`IntelligenceKnowledge` pipeline are unchanged.
-/

universe u v w

namespace DanielOntology.ConfigurationIntegration

open DanielOntology
open DanielOntology.SetConfiguration

/-! ## Structured, indexed State -/

/-- A Configuration at a position in a supplied metalinguistic index. -/
abbrev IndexedConfiguration (Index : Type u) (α : Type v)
    (realizes : α → List α → Prop) :=
  Index × Configuration α realizes

/-- The generic core State instantiated at an indexed structured Configuration. -/
abbrev ConfigState (Index : Type u) (α : Type v) (realizes : α → List α → Prop) :=
  State (IndexedConfiguration Index α realizes)

def atIndex {Index : Type u} {α : Type v} {realizes : α → List α → Prop}
    (index : Index) (configuration : Configuration α realizes) :
    ConfigState Index α realizes :=
  ⟨(index, configuration)⟩

def indexOf {Index : Type u} {α : Type v} {realizes : α → List α → Prop}
    (state : ConfigState Index α realizes) : Index :=
  state.value.1

def configurationOf {Index : Type u} {α : Type v} {realizes : α → List α → Prop}
    (state : ConfigState Index α realizes) : Configuration α realizes :=
  state.value.2

/- State Identity is exactly Identity of index, member Set, and selected
associations. -/
-- organon:contract CI-D1 begin
/-- organon:promotion-contract CI-D1 -/
theorem configStateIdentity {Index : Type u} {α : Type v}
    {realizes : α → List α → Prop} (s t : ConfigState Index α realizes) :
    Identity s t ↔
      Identity (indexOf s) (indexOf t) ∧
      (∀ a, (configurationOf s).members.contains a ↔
        (configurationOf t).members.contains a) ∧
      (∀ r ps, (configurationOf s).associations.contains (r, ps) ↔
        (configurationOf t).associations.contains (r, ps)) := by
  constructor
  · intro same
    cases same
    exact ⟨rfl, fun _ => Iff.rfl, fun _ _ => Iff.rfl⟩
  · rintro ⟨sameIndex, sameMembers, sameAssociations⟩
    have sameConfiguration : configurationOf s = configurationOf t :=
      configurationExt sameMembers sameAssociations
    obtain ⟨⟨i, c⟩⟩ := s
    obtain ⟨⟨j, d⟩⟩ := t
    change i = j at sameIndex
    change c = d at sameConfiguration
    subst sameIndex
    subst sameConfiguration
    rfl
-- organon:contract CI-D1 end

/-- At one index, State Identity is Configuration Identity. -/
theorem sameIndexIdentity {Index : Type u} {α : Type v}
    {realizes : α → List α → Prop} (i : Index) (c d : Configuration α realizes) :
    Identity (atIndex i c) (atIndex i d) ↔ Identity c d := by
  constructor
  · intro same
    exact congrArg configurationOf same
  · intro same
    cases same
    rfl

/-- A selected association present in one Configuration and not the other
separates the States at one index, whatever their member Sets. -/
theorem structureSeparatesStates {Index : Type u} {α : Type v}
    {realizes : α → List α → Prop} (i : Index) (c d : Configuration α realizes)
    (r : α) (ps : List α)
    (selected : c.associations.contains (r, ps))
    (unselected : ¬ d.associations.contains (r, ps)) :
    Difference (atIndex i c) (atIndex i d) := by
  intro same
  have h := ((configStateIdentity _ _).mp same).2.2 r ps
  exact unselected (h.mp selected)

/-- One Configuration at two distinct indices gives two distinct States. -/
theorem indexSeparatesStates {Index : Type u} {α : Type v}
    {realizes : α → List α → Prop} (i j : Index) (c : Configuration α realizes)
    (distinct : Difference i j) :
    Difference (atIndex i c) (atIndex j c) := by
  intro same
  exact distinct (congrArg indexOf same)

/-- The index is not a selected association: placing a Configuration at an
index leaves its associations exactly as they were. -/
theorem indexAddsNoAssociation {Index : Type u} {α : Type v}
    {realizes : α → List α → Prop} (i : Index) (c : Configuration α realizes) :
    ∀ r ps, (configurationOf (atIndex i c)).associations.contains (r, ps) ↔
      c.associations.contains (r, ps) :=
  fun _ _ => Iff.rfl

/-- Every Entity over indexed structured Configurations has two history States satisfying its
identity Invariant that do not agree in both index and Configuration. -/
theorem structuredEntityHistoryDiffers {Index : Type u} {α : Type v}
    {realizes : α → List α → Prop} (entity : Entity (IndexedConfiguration Index α realizes)) :
    ∃ first second,
      first ∈ entity.persistence.states ∧ second ∈ entity.persistence.states ∧
      entity.identity.holds first ∧ entity.identity.holds second ∧
      ¬ (Identity (indexOf first) (indexOf second) ∧
        Identity (configurationOf first) (configurationOf second)) := by
  rcases entity.persistence.hasTransition with ⟨first, second, rest, history⟩
  have ordered : entity.persistenceDirection.before first second := by
    have full := entity.persistence.ordered
    rw [history] at full
    exact full.1
  have firstIn : first ∈ entity.persistence.states := by simp [history]
  have secondIn : second ∈ entity.persistence.states := by simp [history]
  refine ⟨first, second, firstIn, secondIn,
    entityIdentityPersists entity first firstIn,
    entityIdentityPersists entity second secondIn, ?_⟩
  rintro ⟨sameIndex, sameConfiguration⟩
  have same : first = second := by
    obtain ⟨⟨i, c⟩⟩ := first
    obtain ⟨⟨j, d⟩⟩ := second
    change i = j at sameIndex
    change c = d at sameConfiguration
    subst sameIndex
    subst sameConfiguration
    rfl
  subst same
  exact entity.persistenceDirection.asymmetric ordered ordered

/-! ## Configured Boundary -/

/-- An explicit finite listing of a local Set. -/
structure FiniteListing {β : Type v} (s : Set β) where
  items : List β
  complete : ∀ b, s.contains b ↔ b ∈ items

/-- A Boundary retained as a Configuration of Constraints. Members are
interpreted as Constraints; selected associations need only involve a member,
so external participants need not be members or Constraints. -/
structure ConfiguredBoundary (Carrier : Type u) (identity : Invariant Carrier)
    (β : Type v) (realizes : β → List β → Prop) where
  configuration : Configuration β realizes
  constraintOf : β → Option (Constraint Carrier)
  membersAreConstraints :
    ∀ b, configuration.members.contains b → ∃ c, constraintOf b = some c
  preserves :
    ∀ {direction : Direction Carrier} (t : Transformation direction),
      (∀ b c, configuration.members.contains b → constraintOf b = some c →
        c.permits t) →
      identity.holds t.input → identity.holds t.output

/-- Projection to the unchanged core Boundary through a finite listing. The
selected associations are not carried by the projection. -/
def ConfiguredBoundary.toBoundary {Carrier : Type u} {identity : Invariant Carrier}
    {β : Type v} {realizes : β → List β → Prop}
    (boundary : ConfiguredBoundary Carrier identity β realizes)
    (listing : FiniteListing boundary.configuration.members) :
    Boundary Carrier identity where
  constraints := listing.items.filterMap boundary.constraintOf
  preserves := by
    intro direction t permitted inputHolds
    apply boundary.preserves t _ inputHolds
    intro b c member interpreted
    exact permitted c
      (List.mem_filterMap.mpr ⟨b, (listing.complete b).mp member, interpreted⟩)

/-- The projected core Constraints are exactly the interpreted members. -/
theorem toBoundaryConstraints {Carrier : Type u} {identity : Invariant Carrier}
    {β : Type v} {realizes : β → List β → Prop}
    (boundary : ConfiguredBoundary Carrier identity β realizes)
    (listing : FiniteListing boundary.configuration.members)
    (c : Constraint Carrier) :
    c ∈ (boundary.toBoundary listing).constraints ↔
      ∃ b, boundary.configuration.members.contains b ∧
        boundary.constraintOf b = some c := by
  change c ∈ listing.items.filterMap boundary.constraintOf ↔ _
  rw [List.mem_filterMap]
  constructor
  · rintro ⟨b, listed, interpreted⟩
    exact ⟨b, (listing.complete b).mpr listed, interpreted⟩
  · rintro ⟨b, member, interpreted⟩
    exact ⟨b, (listing.complete b).mp member, interpreted⟩

/-- An Entity whose core Boundary is the projection of a retained Constraint
Configuration. -/
structure ConfiguredEntity (Carrier : Type u) (β : Type v)
    (realizes : β → List β → Prop) where
  entity : Entity Carrier
  boundaryConfiguration : ConfiguredBoundary Carrier entity.identity β realizes
  listing : FiniteListing boundaryConfiguration.configuration.members
  boundaryProjects : entity.boundary = boundaryConfiguration.toBoundary listing

/-- A Configured Entity's core Boundary Constraints come exactly from the
retained Configuration's members, and every Transformation permitted by all
member Constraints preserves the Entity's identity Invariant. -/
theorem configuredEntityBoundary {Carrier : Type u} {β : Type v}
    {realizes : β → List β → Prop} (e : ConfiguredEntity Carrier β realizes) :
    (∀ c, c ∈ e.entity.boundary.constraints ↔
      ∃ b, e.boundaryConfiguration.configuration.members.contains b ∧
        e.boundaryConfiguration.constraintOf b = some c) ∧
    (∀ {direction : Direction Carrier} (t : Transformation direction),
      (∀ b c, e.boundaryConfiguration.configuration.members.contains b →
        e.boundaryConfiguration.constraintOf b = some c → c.permits t) →
      e.entity.identity.holds t.input → e.entity.identity.holds t.output) := by
  refine ⟨?_, fun t => e.boundaryConfiguration.preserves t⟩
  intro c
  rw [e.boundaryProjects]
  exact toBoundaryConstraints _ _ c

/-! ## Structured Model -/

/-- An organized Configuration of Representations and Transformations with one
retained Representation/Transformation join and supplied Constraints. -/
structure StructuredModel (Carrier : Type u) (direction : Direction Carrier)
    (β : Type u) (realizes : β → List β → Prop) (Target : Type u) where
  configuration : Configuration β realizes
  denotationOf : β → Option (Denotation β Target)
  denotationExpression : ∀ b d, denotationOf b = some d → d.expression = b
  transformationOf : β → Option (Transformation direction)
  membersOrganized : ∀ b, configuration.members.contains b →
    (∃ d, denotationOf b = some d) ∨ (∃ t, transformationOf b = some t)
  constraints : List (Constraint Carrier)
  joinRelation : β
  representation : β
  transformation : β
  joinSelected :
    configuration.associations.contains
      (joinRelation, [representation, transformation])
  representationMember : configuration.members.contains representation
  transformationMember : configuration.members.contains transformation
  denotation : Denotation β Target
  representationDenotes : denotationOf representation = some denotation
  joinedTransformation : Transformation direction
  transformationRealized : transformationOf transformation = some joinedTransformation
  constraintsPermit : ∀ c, c ∈ constraints → c.permits joinedTransformation

/-- Every Structured Model retains its join, the join's Representation is the
expression of its Denotation, its joined Transformation satisfies every supplied
Constraint, and its Configuration is never a discrete one. -/
theorem structuredModelRetainsJoin {Carrier : Type u} {direction : Direction Carrier}
    {β : Type u} {realizes : β → List β → Prop} {Target : Type u}
    (model : StructuredModel Carrier direction β realizes Target) :
    model.configuration.associations.contains
        (model.joinRelation, [model.representation, model.transformation]) ∧
      model.denotationOf model.representation = some model.denotation ∧
      Identity model.denotation.expression model.representation ∧
      model.transformationOf model.transformation = some model.joinedTransformation ∧
      (∀ c, c ∈ model.constraints → c.permits model.joinedTransformation) ∧
      (∀ s : Set β, Difference model.configuration (discrete s)) := by
  refine ⟨model.joinSelected, model.representationDenotes,
    model.denotationExpression _ _ model.representationDenotes,
    model.transformationRealized, model.constraintsPermit, ?_⟩
  intro s same
  have selected := model.joinSelected
  rw [same] at selected
  exact selected

/-! ## Finite witnesses

The witness carrier reuses the SetConfiguration Tokens: `plain` and `linked`
share members and differ by the selected link association. -/

abbrev WitnessCarrier :=
  IndexedConfiguration Nat SetConfiguration.Token SetConfiguration.realizes

abbrev WitnessState := ConfigState Nat SetConfiguration.Token SetConfiguration.realizes

def plainAt (i : Nat) : WitnessState := atIndex i plain

def linkedAt (i : Nat) : WitnessState := atIndex i linked

/-- Structure changes State Identity when inventories agree; equal
Configurations are distinguished at distinct indices. -/
theorem witnessStateSeparation :
    (Identity (configurationOf (plainAt 0)).members
        (configurationOf (linkedAt 0)).members ∧
      Difference (plainAt 0) (linkedAt 0)) ∧
    (Identity (configurationOf (linkedAt 0)) (configurationOf (linkedAt 1)) ∧
      Difference (linkedAt 0) (linkedAt 1)) := by
  refine ⟨⟨rfl, ?_⟩, ⟨rfl, ?_⟩⟩
  · intro same
    exact structureSeparatesStates 0 linked plain .link [.ring, .bar]
      finiteAntiCollapse.2.2.2.1.1 (fun impossible => impossible) (Eq.symm same)
  · exact indexSeparatesStates 0 1 linked (by simp [Difference, Identity])

/-- Linking orders an unlinked Configuration before a linked one, at any index. -/
def formation : Direction WitnessCarrier where
  before s t := Identity (configurationOf s) plain ∧ Identity (configurationOf t) linked
  asymmetric := by
    intro a b forward backward
    exact finiteAntiCollapse.2.2.1.2 (Eq.trans (Eq.symm backward.1) forward.2)

def linkFormation : Transformation formation where
  input := plainAt 0
  output := linkedAt 1
  advances := ⟨rfl, rfl⟩

def linkChange : Change formation where
  transformation := linkFormation
  differs := fun same => finiteAntiCollapse.2.2.1.2 (congrArg configurationOf same)

/-- The member inventory shared by `plain` and `linked`. -/
def inventory : Set SetConfiguration.Token := ofList [.ring, .bar, .spare]

def inventoryInvariant : Invariant WitnessCarrier where
  holds s := Identity (configurationOf s).members inventory

def membersGuard : Constraint WitnessCarrier where
  permits t := Identity (configurationOf t.output).members (configurationOf t.input).members

def linkGuard : Constraint WitnessCarrier where
  permits t :=
    (configurationOf t.input).associations.contains (.link, [.ring, .bar]) →
      (configurationOf t.output).associations.contains (.link, [.ring, .bar])

/-- Boundary carrier: two Constraint tokens, a coupling Relation, and an
external medium that is neither a member nor a Constraint. -/
inductive BoundaryToken where
  | membersGuard
  | linkGuard
  | coupling
  | medium
deriving DecidableEq

def boundaryRealizes (r : BoundaryToken) (ps : List BoundaryToken) : Prop :=
  r = .coupling ∧ ps = [.membersGuard, .medium]

def boundaryConstraintOf : BoundaryToken → Option (Constraint WitnessCarrier)
  | .membersGuard => some membersGuard
  | .linkGuard => some linkGuard
  | _ => none

def guardMembers : Set BoundaryToken := ofList [.membersGuard, .linkGuard]

def guardListing : FiniteListing guardMembers :=
  ⟨[.membersGuard, .linkGuard], fun _ => Iff.rfl⟩

def coupledGuards : Configuration BoundaryToken boundaryRealizes where
  members := guardMembers
  associations := ofList [(.coupling, [.membersGuard, .medium])]
  valid := by
    intro r ps selected
    have h : (r, ps) = (BoundaryToken.coupling, [BoundaryToken.membersGuard,
        BoundaryToken.medium]) := by
      simpa [ofList] using selected
    cases h
    exact ⟨⟨rfl, rfl⟩, by decide,
      Or.inr ⟨.membersGuard, by simp, by simp [guardMembers, ofList]⟩⟩

def looseGuards : Configuration BoundaryToken boundaryRealizes := discrete guardMembers

/-- Any Configuration over the two guards yields a Configured Boundary for the
inventory Invariant. -/
def guardBoundary (configuration : Configuration BoundaryToken boundaryRealizes)
    (members : configuration.members = guardMembers) :
    ConfiguredBoundary WitnessCarrier inventoryInvariant BoundaryToken boundaryRealizes where
  configuration := configuration
  constraintOf := boundaryConstraintOf
  membersAreConstraints := by
    intro b member
    rw [members] at member
    simp [guardMembers, ofList] at member
    rcases member with rfl | rfl
    · exact ⟨_, rfl⟩
    · exact ⟨_, rfl⟩
  preserves := by
    intro direction t permitted inputHolds
    have same : Identity (configurationOf t.output).members
        (configurationOf t.input).members :=
      permitted .membersGuard membersGuard
        (by rw [members]; simp [guardMembers, ofList]) rfl
    exact Eq.trans same inputHolds

def coupledBoundary := guardBoundary coupledGuards rfl

def looseBoundary := guardBoundary looseGuards rfl

/- The Configured Boundary retains structure the core projection forgets, and
its selected association has an external non-Constraint participant. -/
-- organon:contract CI-C1 begin
/-- organon:promotion-contract CI-C1 -/
theorem boundaryStructureRetained :
    Identity coupledBoundary.configuration.members looseBoundary.configuration.members ∧
    Difference coupledBoundary looseBoundary ∧
    (coupledBoundary.configuration.associations.contains
        (.coupling, [.membersGuard, .medium]) ∧
      ¬ coupledBoundary.configuration.members.contains .medium ∧
      ¬ coupledBoundary.configuration.members.contains .coupling ∧
      coupledBoundary.constraintOf .medium = none) ∧
    Identity (coupledBoundary.toBoundary guardListing)
      (looseBoundary.toBoundary guardListing) := by
  refine ⟨rfl, ?_, ⟨?_, ?_, ?_, rfl⟩, rfl⟩
  · intro same
    have selected : coupledBoundary.configuration.associations.contains
        (.coupling, [.membersGuard, .medium]) := by
      simp [coupledBoundary, guardBoundary, coupledGuards, ofList]
    rw [same] at selected
    exact selected
  · simp [coupledBoundary, guardBoundary, coupledGuards, ofList]
  · simp [coupledBoundary, guardBoundary, coupledGuards, guardMembers, ofList]
  · simp [coupledBoundary, guardBoundary, coupledGuards, guardMembers, ofList]
-- organon:contract CI-C1 end

def formationPersistence : PersistenceWitness formation where
  states := [plainAt 0, linkedAt 1]
  hasTransition := ⟨_, _, [], rfl⟩
  invariant := inventoryInvariant
  invariantHolds := by
    intro s member
    simp at member
    rcases member with rfl | rfl <;> rfl
  ordered := ⟨⟨rfl, rfl⟩, trivial⟩

/-- One Entity whose history runs from an unlinked to a linked Configuration. -/
def linkEntity : Entity WitnessCarrier where
  identity := inventoryInvariant
  boundary := coupledBoundary.toBoundary guardListing
  persistenceDirection := formation
  persistence := formationPersistence
  persistenceNamesIdentity := rfl
  current := linkedAt 1
  currentInPersistence := by simp [formationPersistence]
  identityHolds := rfl

def linkConfiguredEntity : ConfiguredEntity WitnessCarrier BoundaryToken boundaryRealizes where
  entity := linkEntity
  boundaryConfiguration := coupledBoundary
  listing := guardListing
  boundaryProjects := rfl

/- One Entity witness spans two States differing in index and structure under
one Invariant, while their inventories agree. -/
-- organon:contract CI-C2 begin
/-- organon:promotion-contract CI-C2 -/
theorem linkEntitySpansDistinctStates :
    plainAt 0 ∈ linkEntity.persistence.states ∧
    linkedAt 1 ∈ linkEntity.persistence.states ∧
    linkEntity.identity.holds (plainAt 0) ∧
    linkEntity.identity.holds (linkedAt 1) ∧
    Difference (plainAt 0) (linkedAt 1) ∧
    Difference (indexOf (plainAt 0)) (indexOf (linkedAt 1)) ∧
    Difference (configurationOf (plainAt 0)) (configurationOf (linkedAt 1)) ∧
    Identity (configurationOf (plainAt 0)).members
      (configurationOf (linkedAt 1)).members ∧
    linkConfiguredEntity.entity = linkEntity := by
  refine ⟨by simp [linkEntity, formationPersistence],
    by simp [linkEntity, formationPersistence], rfl, rfl,
    linkChange.differs, by simp [Difference, Identity, indexOf, plainAt, linkedAt, atIndex],
    finiteAntiCollapse.2.2.1.2, rfl, rfl⟩
-- organon:contract CI-C2 end

/-- A shared property does not place another State in the Entity's history. -/
theorem invariantDoesNotAdmitHistory :
    linkEntity.identity.holds (plainAt 5) ∧
      plainAt 5 ∉ linkEntity.persistence.states := by
  refine ⟨rfl, ?_⟩
  simp only [linkEntity, formationPersistence, List.mem_cons, List.not_mem_nil, or_false]
  rintro (same | same)
  · have := congrArg indexOf same
    simp [indexOf, plainAt, atIndex] at this
  · have := congrArg indexOf same
    simp [indexOf, plainAt, linkedAt, atIndex] at this

/-! ## Concrete Structured Model in a Cognitive Pipeline -/

inductive ModelToken where
  | sketch
  | linking
  | joins
deriving DecidableEq

def modelRealizes (r : ModelToken) (ps : List ModelToken) : Prop :=
  r = .joins ∧ ps = [.sketch, .linking]

def modelConfiguration : Configuration ModelToken modelRealizes where
  members := ofList [.sketch, .linking]
  associations := ofList [(.joins, [.sketch, .linking])]
  valid := by
    intro r ps selected
    have h : (r, ps) = (ModelToken.joins, [ModelToken.sketch, ModelToken.linking]) := by
      simpa [ofList] using selected
    cases h
    exact ⟨⟨rfl, rfl⟩, by decide, Or.inr ⟨.sketch, by simp, by simp [ofList]⟩⟩

def sketchDenotation : Denotation ModelToken WitnessState := ⟨.sketch, linkedAt 1⟩

abbrev LinkModel := StructuredModel WitnessCarrier formation ModelToken modelRealizes WitnessState

/-- A Model whose sketch denotes the later linked State and whose linking member
is the link-forming Transformation, under both guard Constraints. -/
def linkModel : LinkModel where
  configuration := modelConfiguration
  denotationOf
    | .sketch => some sketchDenotation
    | _ => none
  denotationExpression := by
    intro b d interpreted
    cases b <;> simp at interpreted
    cases interpreted
    rfl
  transformationOf
    | .linking => some linkFormation
    | _ => none
  membersOrganized := by
    intro b member
    cases b
    · exact Or.inl ⟨_, rfl⟩
    · exact Or.inr ⟨_, rfl⟩
    · simp [modelConfiguration, ofList] at member
  constraints := [membersGuard, linkGuard]
  joinRelation := .joins
  representation := .sketch
  transformation := .linking
  joinSelected := by simp [modelConfiguration, ofList]
  representationMember := by simp [modelConfiguration, ofList]
  transformationMember := by simp [modelConfiguration, ofList]
  denotation := sketchDenotation
  representationDenotes := rfl
  joinedTransformation := linkFormation
  transformationRealized := rfl
  constraintsPermit := by
    intro c member
    simp at member
    rcases member with rfl | rfl
    · rfl
    · intro selected
      exact selected.elim

/-- The generic pipeline's `Model` parameter carries the Structured Model
unchanged; Interpretation reads the later State from its joined Transformation. -/
def structuredPipeline : CognitivePipeline
    Unit WitnessState WitnessState LinkModel WitnessState WitnessState WitnessState where
  perceive := fun _ => plainAt 0
  remember := fun _ => plainAt 0
  constructModel := fun _ _ => linkModel
  interpret := fun _ _ model => model.joinedTransformation.output
  selectAction := id
  consequence := fun _ action => action

/-- The pipeline's constructed Model retains its join and supplied Constraints,
and relates the perceived State to the later linked State. -/
theorem structuredPipelineRetainsModel :
    (structuredPipeline.modelFor ()).configuration.associations.contains
        (.joins, [.sketch, .linking]) ∧
      (structuredPipeline.modelFor ()).constraints = [membersGuard, linkGuard] ∧
      (structuredPipeline.modelFor ()).denotation.target = linkedAt 1 ∧
      (structuredPipeline.modelFor ()).joinedTransformation.input =
        structuredPipeline.perceive () ∧
      structuredPipeline.interpretationFor () = linkedAt 1 ∧
      Difference (structuredPipeline.modelFor ()).configuration
        (discrete modelConfiguration.members) := by
  refine ⟨(structuredModelRetainsJoin linkModel).1, rfl, rfl, rfl, rfl,
    (structuredModelRetainsJoin linkModel).2.2.2.2.2 _⟩

end DanielOntology.ConfigurationIntegration
