import DanielOntology

/-!
# Daniel's Ontology: finite inhabited model

This executable supplies one concrete Entity, one institutional Permission over
a toy Agent, and one separately coherent ExercisablePermission. These finite
inhabitants are machine-checked satisfiability witnesses for the encoded slice;
they do not claim that the model is intended, complete, or unique.
-/

namespace DanielOntology.Model

inductive MachineState where
  | idle
  | active
deriving DecidableEq, Repr

open MachineState

def idleState : State MachineState := ⟨idle⟩

def activeState : State MachineState := ⟨active⟩

def activationDirection : Direction MachineState where
  before := fun input output => input.value = idle ∧ output.value = active
  asymmetric := by
    intro a b hab hba
    rcases hab with ⟨aIdle, bActive⟩
    rcases hba with ⟨bIdle, aActive⟩
    simp_all

def activate : Transformation activationDirection where
  input := idleState
  output := activeState
  advances := by simp [activationDirection, idleState, activeState]

def activationPath : CausalPath activationDirection where
  steps := [activate]
  connected := trivial

def knownState : Invariant MachineState where
  holds := fun _ => True

def activationOnly : Constraint MachineState where
  permits := fun transformation =>
    transformation.input.value = idle ∧ transformation.output.value = active

def machineBoundary : Boundary MachineState knownState where
  constraints := [activationOnly]
  preserves := by
    intro _ _ _ _
    trivial

def machine : Entity MachineState where
  identity := knownState
  boundary := machineBoundary
  current := idleState
  identityHolds := trivial

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
  | controller
deriving DecidableEq, Repr

inductive ToyAction : ToyAgent → Type where
  | activate : ToyAction .controller

def controllerCapability : Capability ToyAgent ToyAction .controller where
  can := fun
    | .activate => True

def activationScope : Scope (ToyAction .controller) where
  includes := fun
    | .activate => True

def maintenanceWindow : Interval where
  start := 0
  finish := 1
  ordered := by decide

def activationPermission : Permission ToyPrincipal ToyAgent ToyAction where
  principal := .operator
  agent := .controller
  scope := activationScope
  interval := maintenanceWindow

def exercisableActivationPermission :
    ExercisablePermission ToyPrincipal ToyAgent ToyAction where
  permission := activationPermission
  capability := controllerCapability
  withinCapability := by
    intro action _
    cases action
    trivial

theorem missingnessModelIsInhabited : Nonempty (Missingness MachineState) :=
  ⟨missingActiveMachine⟩

theorem entityModelIsInhabited : Nonempty (Entity MachineState) :=
  ⟨machine⟩

theorem permissionModelIsInhabited :
    Nonempty (Permission ToyPrincipal ToyAgent ToyAction) :=
  ⟨activationPermission⟩

theorem exercisablePermissionModelIsInhabited :
    Nonempty (ExercisablePermission ToyPrincipal ToyAgent ToyAction) :=
  ⟨exercisableActivationPermission⟩

end DanielOntology.Model

def main : IO Unit :=
  IO.println "DanielOntology formal spike: finite model elaborated"
