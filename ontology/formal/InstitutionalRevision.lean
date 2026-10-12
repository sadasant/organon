import OrganonCore

/-!
# PR18 institutional revision: nonbinding discussion tests

These are bounded constructions for the approved candidate wording in
`proposals/institutional-revision.md`, not replacements for canonical definitions.
Order adoption, institutional identity, canonical Action/Consequence parity,
and Authority's distinction from Constraint remain explicit promotion gates.
-/

namespace DanielOntology.InstitutionalRevision

/-! ## Standing: an exact Order/Rule/conformity join -/

def rulePlacement {Order Entity Action : Type}
    (rules : Order → Specification (Entity × Action))
    (order : Order) (rule : Specification (Entity × Action))
    (entity : Entity) (action : Action) (scope : Scope (Entity × Action)) : Prop :=
  rule = rules order ∧ scope = rule.scope ∧ rule.conforms (entity, action)

theorem standingIffConformity {Order Entity Action : Type}
    (rules : Order → Specification (Entity × Action))
    (order : Order) (entity : Entity) (action : Action) :
    Nonempty (StandingRelation (rulePlacement rules) order (rules order)
      entity action (rules order).scope) ↔ (rules order).conforms (entity, action) := by
  constructor
  · rintro ⟨standing⟩
    exact standing.placed.2.2
  · intro conforms
    exact ⟨{ inScope := (rules order).conformityWithinScope _ conforms,
             placed := ⟨rfl, rfl, conforms⟩ }⟩

theorem unrelatedRuleCannotSupplyStanding {Order Entity Action : Type}
    (rules : Order → Specification (Entity × Action)) (order : Order)
    (other : Specification (Entity × Action)) (different : other ≠ rules order)
    (entity : Entity) (action : Action) (scope : Scope (Entity × Action)) :
    ¬ Nonempty (StandingRelation (rulePlacement rules) order other entity action scope) := by
  rintro ⟨standing⟩
  exact different standing.placed.1

def participationRule : Specification (Bool × Bool) where
  scope := ⟨fun _ => True⟩
  conforms := fun pair => pair = (true, false)
  decideConformity := fun pair => decide (pair = (true, false))
  conformityCorrect := by intro pair; simp
  conformityWithinScope := fun _ _ => trivial

def exampleRules (_ : Unit) := participationRule
def occurred (_entity _action : Bool) : Prop := False

theorem standingWithoutOccurrence :
    Nonempty (StandingRelation (rulePlacement exampleRules) () participationRule
      true false participationRule.scope) ∧ ¬ occurred true false :=
  ⟨(standingIffConformity exampleRules () true false).mpr rfl, fun h => h⟩

theorem wrongEntityAndActionExcluded :
    ¬ Nonempty (StandingRelation (rulePlacement exampleRules) () participationRule
      false false participationRule.scope) ∧
    ¬ Nonempty (StandingRelation (rulePlacement exampleRules) () participationRule
      true true participationRule.scope) := by
  constructor
  · intro standing
    have conforms := (standingIffConformity exampleRules () false false).mp standing
    simp [exampleRules, participationRule] at conforms
  · intro standing
    have conforms := (standingIffConformity exampleRules () true true).mp standing
    simp [exampleRules, participationRule] at conforms

/-! ## Recognition requirements: maintenance, not a scalar authority score -/

def feasibleMaintenance {Recipient Plan : Type}
    (required : Recipient → Prop) (maintains : Plan → Recipient → Prop)
    (plan : Plan) : Prop := ∀ recipient, required recipient → maintains plan recipient

theorem moreRequirementsCannotAddPlans {Recipient Plan : Type}
    (smaller larger : Recipient → Prop) (maintains : Plan → Recipient → Prop)
    (includes : ∀ r, smaller r → larger r) (plan : Plan) :
    feasibleMaintenance larger maintains plan → feasibleMaintenance smaller maintains plan := by
  intro adequate recipient required
  exact adequate recipient (includes recipient required)

def oneRequired (recipient : Bool) : Prop := recipient = false
def bothRequired (_ : Bool) : Prop := True
def separateMaintenance (plan : Bool × Bool) (recipient : Bool) : Prop :=
  if recipient then plan.2 = true else plan.1 = true
def sharedMaintenance (plan : Bool) (_ : Bool) : Prop := plan = true

theorem newRequirementCanExcludePlan :
    feasibleMaintenance oneRequired separateMaintenance (true, false) ∧
    ¬ feasibleMaintenance bothRequired separateMaintenance (true, false) := by
  constructor
  · intro recipient required
    have equal : recipient = false := required
    subst recipient
    rfl
  · intro adequate
    have impossible := adequate true trivial
    simp [separateMaintenance] at impossible

theorem sharedMaintenanceCanCoverMore (plan : Bool) :
    feasibleMaintenance oneRequired sharedMaintenance plan ↔
    feasibleMaintenance bothRequired sharedMaintenance plan := by
  constructor
  · intro adequate _ _
    exact adequate false rfl
  · exact moreRequirementsCannotAddPlans oneRequired bothRequired
      sharedMaintenance (fun _ _ => trivial) plan

/-! ## Broad conditioning and represented causal choice are different axes

These Boolean response comparisons are not canonical temporal CausalContribution
or an astronomical model. No theorem measures the Sun's actual Authority/Power.
-/

def sourceResult (available : Bool) (_operation : Unit) : Bool := available
def downstreamAdmits (_recipient : Nat) (available operation : Bool) : Prop :=
  operation = false ∨ available = true

theorem conditioningWithoutSourceChoice :
    (∀ a b, sourceResult true a = sourceResult true b) ∧
    (∀ recipient, downstreamAdmits recipient true true ∧
      ¬ downstreamAdmits recipient false true) := by
  refine ⟨fun _ _ => rfl, ?_⟩
  intro recipient
  simp [downstreamAdmits]

-- The Representation input must change the selected operation and its effect.
-- This is only a local operative-contrast test, not a complete Power definition.
def operativeContrast (select effect : Bool → Bool) : Prop :=
  select true ≠ select false ∧ effect (select true) ≠ effect (select false)

theorem representedChoiceProducesDifferentEffects : operativeContrast id id := by
  simp [operativeContrast]

theorem dormantRepresentationIsInsufficient :
    ¬ operativeContrast (fun _ => false) id := by
  simp [operativeContrast]

def strike (weather : Bool) (_exploit : Bool) : Bool := weather
def retreat (weather exploit : Bool) : Bool := weather && exploit

theorem exploitingAnEventDoesNotRequireProducingIt :
    (∀ weather, strike weather true = strike weather false) ∧
    operativeContrast id (retreat true) ∧
    ¬ operativeContrast id (retreat false) := by
  exact ⟨fun _ => rfl, by simp [operativeContrast, retreat],
    by simp [operativeContrast, retreat]⟩

def effectInContext (context action : Bool) : Bool := if context then action else !action

theorem causalChoiceDoesNotSupplyContextFreePrediction :
    (∀ context, effectInContext context true ≠ effectInContext context false) ∧
    ¬ (∃ forecast : Bool → Bool,
      ∀ context action, forecast action = effectInContext context action) := by
  constructor
  · intro context
    cases context <;> decide
  · rintro ⟨forecast, correct⟩
    have contradiction := (correct true true).symm.trans (correct false true)
    simp [effectInContext] at contradiction

-- Stable-law counterexample to inevitable prediction decay. Arbitrary external
-- changes to the unobserved component do not invalidate this scoped forecast.
def evolve (environment : Nat → Bool) : Nat → (Bool × Bool) → (Bool × Bool)
  | 0, initial => initial
  | n + 1, initial => (!(evolve environment n initial).1, environment n)
def forecast : Nat → Bool → Bool
  | 0, initial => initial
  | n + 1, initial => !(forecast n initial)

theorem fixedForecastCanRemainAdequate (environment : Nat → Bool)
    (initial : Bool × Bool) (n : Nat) :
    forecast n initial.1 = (evolve environment n initial).1 := by
  induction n with
  | zero => rfl
  | succ n ih => simp only [forecast, evolve, ih]

/-! ## Actual further succession, not merely an available successor

Actual occurrences are read at adjacent indices in a supplied history. A named
institution and continuity relation are shared across both handoffs. The supplied
history is evidence assumed by the theorem, not proof that real events occurred.
-/

def handoffAt {Institution Participant : Type} (institution : Institution)
    (continues : Institution → Participant → Participant → Prop)
    (history : List Participant) (index : Nat) : Prop :=
  ∃ predecessor successor,
    history[index]? = some predecessor ∧ history[index + 1]? = some successor ∧
    predecessor ≠ successor ∧ continues institution predecessor successor

def successfulSuccessionAt {Institution Participant : Type} (institution : Institution)
    (continues : Institution → Participant → Participant → Prop)
    (history : List Participant) (index : Nat) : Prop :=
  handoffAt institution continues history index ∧
  handoffAt institution continues history (index + 1)

def toyContinuity (institution : Bool) (before after : Nat) : Prop :=
  institution = true ∧ after = before + 1

theorem actualFurtherSuccessionWitness :
    successfulSuccessionAt true toyContinuity [0, 1, 2] 0 := by
  constructor
  · exact ⟨0, 1, rfl, rfl, by decide, rfl, rfl⟩
  · exact ⟨1, 2, rfl, rfl, by decide, rfl, rfl⟩

theorem capacityAndHandoffDoNotSupplyFurtherOccurrence :
    handoffAt true toyContinuity [0, 1] 0 ∧
    (∃ successor, toyContinuity true 1 successor) ∧
    ¬ successfulSuccessionAt true toyContinuity [0, 1] 0 := by
  refine ⟨⟨0, 1, rfl, rfl, by decide, rfl, rfl⟩, ⟨2, rfl, rfl⟩, ?_⟩
  rintro ⟨_, predecessor, successor, _, missing, _⟩
  simp at missing

theorem replacementWithoutContinuityIsNotSuccess :
    ¬ successfulSuccessionAt true toyContinuity [0, 1, 9] 0 := by
  rintro ⟨_, predecessor, successor, before, after, _, continuous⟩
  have hp : predecessor = 1 := by simpa using before.symm
  have hs : successor = 9 := by simpa using after.symm
  subst predecessor
  subst successor
  simp [toyContinuity] at continuous

-- The Boolean history abstracts a fixed institutional continuity criterion.
-- A bounded observed prefix cannot establish all future continuation.
def terminalAfter (last stage : Nat) : Bool := decide (stage ≤ last)

theorem finiteHistoryDoesNotCertifyUnendingContinuity (last : Nat) :
    ¬ (∀ history : Nat → Bool,
      (∀ stage, stage ≤ last → history stage = true) →
      ∀ stage, history stage = true) := by
  intro certify
  have observed : ∀ stage, stage ≤ last → terminalAfter last stage = true := by
    intro stage within
    simp [terminalAfter, within]
  have purported := certify (terminalAfter last) observed (last + 1)
  have terminal : terminalAfter last (last + 1) = false := by simp [terminalAfter]
  rw [terminal] at purported
  contradiction

end DanielOntology.InstitutionalRevision
