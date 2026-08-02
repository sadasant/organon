import DanielOntology

/-!
# Daniel's Ontology: inhabited spike model

This executable supplies one complete finite instance of the formal spike. It
is deliberately small: the purpose is to prove that the signatures can coexist,
not to claim that this is the intended or unique model of the ontology.
-/

namespace DanielOntology.Model

inductive MachineState where
  | idle
  | active
deriving DecidableEq, Repr

open MachineState

def activationDirection : Direction MachineState where
  before
    | idle, active => True
    | _, _ => False
  asymmetric := by
    intro a b hab hba
    cases a <;> cases b <;> simp_all

def activate : Transformation MachineState where
  input := idle
  output := active
  direction := activationDirection
  advances := trivial

def knownState : Invariant MachineState where
  holds := fun _ => True

def activationOnly : Constraint MachineState where
  permits := fun t => t.input = idle ∧ t.output = active

def machineBoundary : Boundary MachineState knownState where
  constraints := [activationOnly]
  preserves := by
    intro _ _ _
    trivial

def machine : Entity MachineState where
  identity := knownState
  boundary := machineBoundary
  current := idle
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
  capability := controllerCapability
  scope := activationScope
  interval := maintenanceWindow
  withinCapability := by
    intro action _
    cases action
    trivial

theorem entityModelIsInhabited : Nonempty (Entity MachineState) := ⟨machine⟩

theorem missingnessModelIsInhabited : Nonempty (Missingness MachineState) :=
  ⟨missingActiveMachine⟩

theorem permissionModelIsInhabited :
    Nonempty (Permission ToyPrincipal ToyAgent ToyAction) :=
  ⟨activationPermission⟩

end DanielOntology.Model

def main : IO Unit :=
  IO.println "DanielOntology formal spike: model elaborated"
