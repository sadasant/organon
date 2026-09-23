import Base
import ./Logic.bend as Logic
import ./Core.bend as Core

type MachineState is Data:
  Idle{}
  Active{}
  Standby{}
  Broken{}

def idleState() -> Core.State<MachineState>:
  Core.State{Idle{}}

def activeState() -> Core.State<MachineState>:
  Core.State{Active{}}

def standbyState() -> Core.State<MachineState>:
  Core.State{Standby{}}

def brokenState() -> Core.State<MachineState>:
  Core.State{Broken{}}

def before(a: Core.State<MachineState>, b: Core.State<MachineState>) -> Type:
  match a:
    case Core.State{x}:
      match x:
        case Idle{}:
          match b:
            case Core.State{y}:
              match y:
                case Idle{}: Empty
                case Active{}: Unit
                case Standby{}: Unit
                case Broken{}: Empty
        case Active{}:
          match b:
            case Core.State{y}:
              match y:
                case Idle{}: Empty
                case Active{}: Empty
                case Standby{}: Empty
                case Broken{}: Unit
        case Standby{}:
          match b:
            case Core.State{y}:
              match y:
                case Idle{}: Empty
                case Active{}: Empty
                case Standby{}: Empty
                case Broken{}: Empty
        case Broken{}:
          match b:
            case Core.State{y}:
              match y:
                case Idle{}: Empty
                case Active{}: Empty
                case Standby{}: Empty
                case Broken{}: Empty

def asymmetric(a: Core.State<MachineState>, b: Core.State<MachineState>, ab: before(a, b), ba: before(b, a)) -> Empty:
  match a:
    case Core.State{x}:
      match x:
        case Idle{}:
          match b:
            case Core.State{y}:
              match y:
                case Idle{}:
                  match ab:
                case Active{}:
                  match ba:
                case Standby{}:
                  match ba:
                case Broken{}:
                  match ab:
        case Active{}:
          match b:
            case Core.State{y}:
              match y:
                case Idle{}:
                  match ab:
                case Active{}:
                  match ab:
                case Standby{}:
                  match ab:
                case Broken{}:
                  match ba:
        case Standby{}:
          match b:
            case Core.State{y}:
              match y:
                case Idle{}:
                  match ab:
                case Active{}:
                  match ab:
                case Standby{}:
                  match ab:
                case Broken{}:
                  match ab:
        case Broken{}:
          match b:
            case Core.State{y}:
              match y:
                case Idle{}:
                  match ab:
                case Active{}:
                  match ab:
                case Standby{}:
                  match ab:
                case Broken{}:
                  match ab:

def direction() -> Core.Direction<MachineState>:
  Core.Direction{before, asymmetric}

def activate() -> Core.Transformation<MachineState, direction()>:
  Core.Transformation{idleState(), activeState(), Unit{}}

def breakMachine() -> Core.Transformation<MachineState, direction()>:
  Core.Transformation{activeState(), brokenState(), Unit{}}

def monitorMachine() -> Core.Transformation<MachineState, direction()>:
  Core.Transformation{idleState(), standbyState(), Unit{}}

def identityHolds(state: Core.State<MachineState>) -> Type:
  match state:
    case Core.State{value}:
      match value:
        case Broken{}: Empty
        case _: Unit

def identity() -> Core.Invariant<MachineState>:
  Core.Invariant{identityHolds}

def admits(input: Core.State<MachineState>, output: Core.State<MachineState>) -> Type:
  match input:
    case Core.State{a}:
      match a:
        case Idle{}:
          match output:
            case Core.State{b}:
              match b:
                case Active{}: Unit
                case _: Empty
        case _: Empty

def permits(-d: Core.Direction<MachineState>, t: Core.Transformation<MachineState, d>) -> Type:
  match t:
    case Core.Transformation{input, output, advances}: admits(input, output)

def activationOnly() -> Core.Constraint<MachineState>:
  Core.Constraint{permits}

def admittedOutputPreserved(input: Core.State<MachineState>, output: Core.State<MachineState>, allowed: admits(input, output)) -> identityHolds(output):
  match input:
    case Core.State{a}:
      match a:
        case Idle{}:
          match output:
            case Core.State{b}:
              match b:
                case Active{}: Unit{}
                case Idle{}: match allowed:
                case Standby{}: match allowed:
                case Broken{}: match allowed:
        case Active{}: match allowed:
        case Standby{}: match allowed:
        case Broken{}: match allowed:

def preserve(-d: Core.Direction<MachineState>, t: Core.Transformation<MachineState, d>, allowed: (@-c: Core.Constraint<MachineState> -> Core.member(Core.Constraint<MachineState>, c, [activationOnly()]) -> Core.Constraint.permits(MachineState, c)(d, t)), prior: identityHolds(Core.Transformation.input(MachineState, d, t))) -> identityHolds(Core.Transformation.output(MachineState, d, t)):
  match t:
    case Core.Transformation{input, output, advances}:
      admittedOutputPreserved(input, output, allowed(activationOnly(), Inl{{==}}))

def boundary() -> Core.Boundary<MachineState, identity()>:
  Core.Boundary{[activationOnly()], preserve}

def notBrokenEquality(-state: Core.State<MachineState>, holds: identityHolds(state), equal: {state == brokenState() : Core.State<MachineState>}) -> Empty:
  %equal : identityHolds(_)
  holds

def brokenNotInHistory(member: Core.member(Core.State<MachineState>, brokenState(), [idleState(), activeState()])) -> Empty:
  match member:
    case Inl{equal}:
      notBrokenEquality(idleState(), Unit{}, Equal.sym(Core.State<MachineState>, brokenState(), idleState(), equal))
    case Inr{tail}:
      match tail:
        case Inl{equal}:
          notBrokenEquality(activeState(), Unit{}, Equal.sym(Core.State<MachineState>, brokenState(), activeState(), equal))
        case Inr{none}:
          match none:

def historyInvariant(state: Core.State<MachineState>, member: Core.member(Core.State<MachineState>, state, [idleState(), activeState()])) -> identityHolds(state):
  match state:
    case Core.State{value}:
      match value:
        case Broken{}: brokenNotInHistory(member)
        case Idle{}: Unit{}
        case Active{}: Unit{}
        case Standby{}: Unit{}

def persistence() -> Core.PersistenceWitness<MachineState, direction()>:
  Core.PersistenceWitness{[idleState(), activeState()], (idleState(), (activeState(), (Nil{}, {==}))), identity(), historyInvariant, Logic.Both{Unit{}, Unit{}}}

def machine() -> Core.Entity<MachineState>:
  Core.Entity{identity(), boundary(), direction(), persistence(), {==}, idleState(), Inl{{==}}, Unit{}}
