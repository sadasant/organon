import DanielOntology
import Consciousness
import Operationalization

/-!
# Daniel's Ontology: finite inhabited model

This model exercises the selected formal machinery rather than merely proving
that a record with `True` fields can be constructed. Its Boundary admits one
identity-preserving Transformation and rejects one identity-breaking
Transformation. Its institutional witness contains one Order-indexed Permission
produced from a standing-aware Claim, scoped Authority, Grant, and Order
admission, plus one action-level PermissionExercise under a concrete Context.
-/

namespace DanielOntology.Model

inductive MachineState where
  | idle
  | active
  | broken
deriving DecidableEq, Repr

open MachineState

def idleState : State MachineState := ⟨idle⟩
def activeState : State MachineState := ⟨active⟩
def brokenState : State MachineState := ⟨broken⟩

def operationalDirection : Direction MachineState where
  before := fun input output =>
    (input.value = idle ∧ output.value = active) ∨
    (input.value = active ∧ output.value = broken)
  asymmetric := by
    intro a b hab hba
    rcases hab with hab | hab <;> rcases hba with hba | hba <;> simp_all

def activate : Transformation operationalDirection where
  input := idleState
  output := activeState
  advances := by simp [operationalDirection, idleState, activeState]

def breakMachine : Transformation operationalDirection where
  input := activeState
  output := brokenState
  advances := by simp [operationalDirection, activeState, brokenState]

def sequentialFeed : FeedRelation MachineState where
  feeds := fun output input => output.value = input.value

def activationThenBreaks : CausalPath operationalDirection sequentialFeed where
  steps := [activate, breakMachine]
  connected := by simp [Chains, sequentialFeed, activate, breakMachine, activeState]

def operationalIdentity : Invariant MachineState where
  holds := fun state => state.value ≠ broken

def activationOnly : Constraint MachineState where
  permits := fun transformation =>
    transformation.input.value = idle ∧ transformation.output.value = active

def machineBoundary : Boundary MachineState operationalIdentity where
  constraints := [activationOnly]
  preserves := by
    intro direction transformation admitted _
    have permitted := admitted activationOnly (by simp)
    rcases permitted with ⟨_, outputActive⟩
    simp [operationalIdentity, outputActive]

def machine : Entity MachineState where
  identity := operationalIdentity
  boundary := machineBoundary
  current := idleState
  identityHolds := by simp [operationalIdentity, idleState]

theorem boundaryAdmitsActivation : activationOnly.permits activate := by
  simp [activationOnly, activate, idleState, activeState]

theorem boundaryRejectsBreaking : ¬ activationOnly.permits breakMachine := by
  simp [activationOnly, breakMachine, activeState, brokenState]

theorem breakingViolatesIdentity :
    ¬ operationalIdentity.holds breakMachine.output := by
  simp [operationalIdentity, breakMachine, brokenState]

/-! ## Operationalized Representation witness -/

inductive MachineCommand where
  | activate
  | halt
deriving DecidableEq, Repr

open MachineCommand

def commandSelectionRule :
    SelectionRule MachineCommand operationalDirection where
  selects := fun command transformation =>
    match command with
    | .activate =>
        transformation.input.value = idle ∧
        transformation.output.value = active
    | .halt => False

def commandInterface : OperationalInterface operationalDirection where
  exposes := fun transformation =>
    transformation.input.value = idle ∧
    transformation.output.value = active

def commandScope :
    Scope (MachineCommand × Transformation operationalDirection) where
  includes := fun _ => True

def activationPath : CausalPath operationalDirection sequentialFeed where
  steps := [activate]
  connected := by simp [Chains]

def activateOperationalization :
    Operationalization MachineCommand operationalDirection sequentialFeed where
  representation := .activate
  rule := commandSelectionRule
  interface := commandInterface
  scope := commandScope
  path := activationPath
  selected := activate
  selectedByRule := by
    simp [commandSelectionRule, activate, idleState, activeState]
  exposedByInterface := by
    simp [commandInterface, activate, idleState, activeState]
  inScope := trivial
  occursInPath := by simp [activationPath]
  discriminating := by
    refine ⟨.halt, by decide, trivial, ?_⟩
    simp [commandSelectionRule]

def commandFaithful (_ : MachineCommand) : Prop := False

def commandAdmittedAsEvidence (_ : MachineCommand) : Prop := False

theorem operationalizationModelIsInhabited :
    Nonempty
      (Operationalization MachineCommand operationalDirection sequentialFeed) :=
  ⟨activateOperationalization⟩

theorem operationalizationDoesNotEntailFidelity :
    ∃ operationalization :
        Operationalization MachineCommand operationalDirection sequentialFeed,
      ¬ commandFaithful operationalization.representation := by
  exact ⟨activateOperationalization, by simp [commandFaithful]⟩

theorem operationalizationDoesNotEntailEvidence :
    ∃ operationalization :
        Operationalization MachineCommand operationalDirection sequentialFeed,
      ¬ commandAdmittedAsEvidence operationalization.representation := by
  exact ⟨activateOperationalization, by simp [commandAdmittedAsEvidence]⟩

theorem selectedConsequenceDoesNotEntailEvidence :
    activateOperationalization.selected.output.value = active ∧
    ¬ commandAdmittedAsEvidence
      activateOperationalization.representation := by
  constructor
  · rfl
  · simp [commandAdmittedAsEvidence]

def activeScope : Scope (State MachineState) where
  includes := fun state => state.value = active

def activeSpecification : Specification (State MachineState) where
  scope := activeScope
  conforms := fun state => state.value = active
  decideConformity := fun state => state.value == active
  conformityCorrect := by
    intro state
    cases state with
    | mk value => cases value <;> decide
  conformityWithinScope := by
    intro state conforming
    exact conforming

example : activeSpecification.decideConformity activeState = true := by decide
example : activeSpecification.decideConformity brokenState = false := by decide

def emptyMachineField : Field MachineState where
  contains := fun _ => False

def missingActiveMachine : Missingness MachineState where
  field := emptyMachineField
  expected := active
  missing := by simp [emptyMachineField]

inductive ToyPrincipal where
  | operator
deriving DecidableEq, Repr

inductive ToyAgent where
  | administrator
  | controller
deriving DecidableEq, Repr

inductive ToyAction : ToyAgent → Type where
  | grant : ToyAction .administrator
  | activate : ToyAction .controller

structure ToyContext where
  enabled : Bool

def toyOrder : InstitutionalOrder ToyPrincipal ToyAgent where
  recognizesPrincipal := fun
    | .operator => True
  recognizesAgent := fun
    | .administrator => True
    | .controller => True
  admits := fun claimId grantId permissionId _ =>
    claimId = 10 ∧ grantId = 20 ∧ permissionId = 30
  revokes := fun _ _ => False

def activationScope : Scope (ToyAction .controller) where
  includes := fun
    | .activate => True

def maintenanceWindow : Interval where
  start := 0
  finish := 10
  ordered := by decide

def activationClaim : PermissionClaim ToyPrincipal ToyAgent ToyAction toyOrder where
  claimId := 10
  principal := .operator
  principalStanding := trivial
  agent := .controller
  agentStanding := trivial
  scope := activationScope
  interval := maintenanceWindow

def administratorAuthority :
    Authority ToyPrincipal ToyAgent ToyAction toyOrder .operator .controller where
  holder := .administrator
  holderStanding := trivial
  actionScope := activationScope
  interval := maintenanceWindow

def activationGrant :
    Grant ToyPrincipal ToyAgent ToyAction toyOrder activationClaim where
  grantId := 20
  authority := administratorAuthority
  grantAction := .grant
  scopeCovered := by
    intro action included
    exact included
  intervalCovered := by
    intro time included
    exact included

def activationPermission : Permission ToyPrincipal ToyAgent ToyAction where
  order := toyOrder
  claim := activationClaim
  grant := activationGrant
  permissionId := 30
  admittedAt := 0
  admitted := by simp [toyOrder, activationClaim, activationGrant]

def controllerCapability :
    Capability ToyAgent ToyAction ToyContext .controller where
  can := fun context action =>
    match action with
    | .activate => context.enabled = true

def activationExercise :
    PermissionExercise ToyPrincipal ToyAgent ToyAction ToyContext where
  permission := activationPermission
  action := .activate
  time := 1
  context := ⟨true⟩
  inScope := trivial
  inInterval := by
    simp [Interval.contains, activationPermission, activationClaim, maintenanceWindow]
  capability := controllerCapability
  technicallyPossible := by rfl
  stillAdmitted := by
    simp [activationPermission, toyOrder, activationClaim, activationGrant]
  notRevoked := by simp [activationPermission, toyOrder]

theorem missingnessModelIsInhabited : Nonempty (Missingness MachineState) :=
  ⟨missingActiveMachine⟩

theorem entityModelIsInhabited : Nonempty (Entity MachineState) :=
  ⟨machine⟩

theorem permissionModelIsInhabited :
    Nonempty (Permission ToyPrincipal ToyAgent ToyAction) :=
  ⟨activationPermission⟩

theorem exerciseModelIsInhabited :
    Nonempty (PermissionExercise ToyPrincipal ToyAgent ToyAction ToyContext) :=
  ⟨activationExercise⟩

end DanielOntology.Model

def main : IO Unit :=
  IO.println "DanielOntology v0.11 spike: ontology, consciousness, and operationalization countermodels elaborated"
