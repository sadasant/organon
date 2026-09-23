import Base
import ./Logic.bend as Logic

type Field<-A: Type> is Type:
  Field{contains: A -> Type}

def Field.contains(-A: Type, v: Field<A>) -> A -> Type:
  match v:
    case Field{contains}: contains

type Missingness<-A: Type> is Type:
  Missingness{field: Field<A>,
    expected: A,
    missing: Field.contains(A, field)(expected) -> Empty}

def Missingness.field(-A: Type, v: Missingness<A>) -> Field<A>:
  match v:
    case Missingness{field, expected, missing}: field

def Missingness.expected(-A: Type, v: Missingness<A>) -> A:
  match v:
    case Missingness{field, expected, missing}: expected

def Missingness.missing(-A: Type, v: Missingness<A>) -> Field.contains(A, Missingness.field(A, v))(Missingness.expected(A, v)) -> Empty:
  match v:
    case Missingness{field, expected, missing}: missing

type Denotation<-Expression: Type, -Target: Type> is Type:
  Denotation{expression: Expression,
    target: Target}

def Denotation.expression(-Expression: Type, -Target: Type, v: Denotation<Expression, Target>) -> Expression:
  match v:
    case Denotation{expression, target}: expression

def Denotation.target(-Expression: Type, -Target: Type, v: Denotation<Expression, Target>) -> Target:
  match v:
    case Denotation{expression, target}: target

type State<-A: Type> is Type:
  State{value: A}

def State.value(-A: Type, v: State<A>) -> A:
  match v:
    case State{value}: value

type Direction<-A: Type> is Type:
  Direction{before: State<A> -> State<A> -> Type,
    asymmetric: @a: State<A> -> @b: State<A> -> before(a, b) -> before(b, a) -> Empty}

def Direction.before(-A: Type, v: Direction<A>) -> State<A> -> State<A> -> Type:
  match v:
    case Direction{before, asymmetric}: before

def Direction.asymmetric(-A: Type, v: Direction<A>) -> @a: State<A> -> @b: State<A> -> Direction.before(A, v)(a, b) -> Direction.before(A, v)(b, a) -> Empty:
  match v:
    case Direction{before, asymmetric}: asymmetric

type Transformation<-A: Type, -direction: Direction<A>> is Type:
  Transformation{input: State<A>,
    output: State<A>,
    advances: Direction.before(A, direction)(input, output)}

def Transformation.input(-A: Type, -direction: Direction<A>, v: Transformation<A, direction>) -> State<A>:
  match v:
    case Transformation{input, output, advances}: input

def Transformation.output(-A: Type, -direction: Direction<A>, v: Transformation<A, direction>) -> State<A>:
  match v:
    case Transformation{input, output, advances}: output

def Transformation.advances(-A: Type, -direction: Direction<A>, v: Transformation<A, direction>) -> Direction.before(A, direction)(Transformation.input(A, direction, v), Transformation.output(A, direction, v)):
  match v:
    case Transformation{input, output, advances}: advances

type Change<-A: Type, -direction: Direction<A>> is Type:
  Change{transformation: Transformation<A, direction>,
    differs: {Transformation.input(A, direction, transformation) != Transformation.output(A, direction, transformation) : State<A>}}

def Change.transformation(-A: Type, -direction: Direction<A>, v: Change<A, direction>) -> Transformation<A, direction>:
  match v:
    case Change{transformation, differs}: transformation

def Change.differs(-A: Type, -direction: Direction<A>, v: Change<A, direction>) -> {Transformation.input(A, direction, Change.transformation(A, direction, v)) != Transformation.output(A, direction, Change.transformation(A, direction, v)) : State<A>}:
  match v:
    case Change{transformation, differs}: differs

type FeedRelation<-A: Type> is Type:
  FeedRelation{feeds: State<A> -> State<A> -> Type}

def FeedRelation.feeds(-A: Type, v: FeedRelation<A>) -> State<A> -> State<A> -> Type:
  match v:
    case FeedRelation{feeds}: feeds

def chains(-A: Type, -direction: Direction<A>, feeding: FeedRelation<A>, steps: List<Transformation<A, direction>>) -> Type:
  match steps:
    case Nil{}: Unit
    case Con{first, tail}:
      match tail:
        case Nil{}: Unit
        case Con{second, rest}:
          Logic.Both<FeedRelation.feeds(A, feeding)(Transformation.output(A, direction, first), Transformation.input(A, direction, second)), chains(A, direction, feeding, Con{second, rest})>

type CausalPath<-A: Type, -direction: Direction<A>, -feeding: FeedRelation<A>> is Type:
  CausalPath{steps: List<Transformation<A, direction>>,
    connected: chains(A, direction, feeding, steps)}

def CausalPath.steps(-A: Type, -direction: Direction<A>, -feeding: FeedRelation<A>, v: CausalPath<A, direction, feeding>) -> List<Transformation<A, direction>>:
  match v:
    case CausalPath{steps, connected}: steps

def CausalPath.connected(-A: Type, -direction: Direction<A>, -feeding: FeedRelation<A>, v: CausalPath<A, direction, feeding>) -> chains(A, direction, feeding, CausalPath.steps(A, direction, feeding, v)):
  match v:
    case CausalPath{steps, connected}: connected

type Constraint<-A: Type> is Type:
  Constraint{permits: @-direction: Direction<A> -> Transformation<A, direction> -> Type}

def Constraint.permits(-A: Type, v: Constraint<A>) -> @-direction: Direction<A> -> Transformation<A, direction> -> Type:
  match v:
    case Constraint{permits}: permits

type Invariant<-A: Type> is Type:
  Invariant{holds: State<A> -> Type}

def Invariant.holds(-A: Type, v: Invariant<A>) -> State<A> -> Type:
  match v:
    case Invariant{holds}: holds

def orderedBy(-A: Type, relation: A -> A -> Type, states: List<A>) -> Type:
  match states:
    case Nil{}: Unit
    case Con{first, tail}:
      match tail:
        case Nil{}: Unit
        case Con{second, rest}:
          Logic.Both<relation(first, second), orderedBy(A, relation, Con{second, rest})>

def member(-A: Type, value: A, values: List<A>) -> Type:
  match values:
    case Nil{}: Empty
    case Con{first, rest}:
      Either<&2, &1, {value == first : A}, member(A, value, rest)>

def hasTransition(-A: Type, states: List<A>) -> Type:
  Exists(A, first => Exists(A, second => Exists(List<A>, rest => {states == Con{first, Con{second, rest}} : List<A>})))

type PersistenceWitness<-A: Type, -direction: Direction<A>> is Type:
  PersistenceWitness{states: List<State<A>>,
    hasTransition: hasTransition(State<A>, states),
    invariant: Invariant<A>,
    invariantHolds: @state: State<A> -> member(State<A>, state, states) -> Invariant.holds(A, invariant)(state),
    ordered: orderedBy(State<A>, Direction.before(A, direction), states)}

def PersistenceWitness.states(-A: Type, -direction: Direction<A>, v: PersistenceWitness<A, direction>) -> List<State<A>>:
  match v:
    case PersistenceWitness{states, hasTransition, invariant, invariantHolds, ordered}: states

def PersistenceWitness.hasTransition(-A: Type, -direction: Direction<A>, v: PersistenceWitness<A, direction>) -> hasTransition(State<A>, PersistenceWitness.states(A, direction, v)):
  match v:
    case PersistenceWitness{states, hasTransition, invariant, invariantHolds, ordered}: hasTransition

def PersistenceWitness.invariant(-A: Type, -direction: Direction<A>, v: PersistenceWitness<A, direction>) -> Invariant<A>:
  match v:
    case PersistenceWitness{states, hasTransition, invariant, invariantHolds, ordered}: invariant

def PersistenceWitness.invariantHolds(-A: Type, -direction: Direction<A>, v: PersistenceWitness<A, direction>) -> @state: State<A> -> member(State<A>, state, PersistenceWitness.states(A, direction, v)) -> Invariant.holds(A, PersistenceWitness.invariant(A, direction, v))(state):
  match v:
    case PersistenceWitness{states, hasTransition, invariant, invariantHolds, ordered}: invariantHolds

def PersistenceWitness.ordered(-A: Type, -direction: Direction<A>, v: PersistenceWitness<A, direction>) -> orderedBy(State<A>, Direction.before(A, direction), PersistenceWitness.states(A, direction, v)):
  match v:
    case PersistenceWitness{states, hasTransition, invariant, invariantHolds, ordered}: ordered

type Boundary<-A: Type, -identity: Invariant<A>> is Type:
  Boundary{constraints: List<Constraint<A>>,
    preserves: @-direction: Direction<A> -> @t: Transformation<A, direction> -> (@-c: Constraint<A> -> member(Constraint<A>, c, constraints) -> Constraint.permits(A, c)(direction, t)) -> Invariant.holds(A, identity)(Transformation.input(A, direction, t)) -> Invariant.holds(A, identity)(Transformation.output(A, direction, t))}

def Boundary.constraints(-A: Type, -identity: Invariant<A>, v: Boundary<A, identity>) -> List<Constraint<A>>:
  match v:
    case Boundary{constraints, preserves}: constraints

def Boundary.preserves(-A: Type, -identity: Invariant<A>, v: Boundary<A, identity>) -> @-direction: Direction<A> -> @t: Transformation<A, direction> -> (@-c: Constraint<A> -> member(Constraint<A>, c, Boundary.constraints(A, identity, v)) -> Constraint.permits(A, c)(direction, t)) -> Invariant.holds(A, identity)(Transformation.input(A, direction, t)) -> Invariant.holds(A, identity)(Transformation.output(A, direction, t)):
  match v:
    case Boundary{constraints, preserves}: preserves

type Entity<-A: Type> is Type:
  Entity{identity: Invariant<A>,
    boundary: Boundary<A, identity>,
    persistenceDirection: Direction<A>,
    persistence: PersistenceWitness<A, persistenceDirection>,
    persistenceNamesIdentity: {PersistenceWitness.invariant(A, persistenceDirection, persistence) == identity : Invariant<A>},
    current: State<A>,
    currentInPersistence: member(State<A>, current, PersistenceWitness.states(A, persistenceDirection, persistence)),
    identityHolds: Invariant.holds(A, identity)(current)}

def Entity.identity(-A: Type, v: Entity<A>) -> Invariant<A>:
  match v:
    case Entity{identity, boundary, persistenceDirection, persistence, persistenceNamesIdentity, current, currentInPersistence, identityHolds}: identity

def Entity.boundary(-A: Type, v: Entity<A>) -> Boundary<A, Entity.identity(A, v)>:
  match v:
    case Entity{identity, boundary, persistenceDirection, persistence, persistenceNamesIdentity, current, currentInPersistence, identityHolds}: boundary

def Entity.persistenceDirection(-A: Type, v: Entity<A>) -> Direction<A>:
  match v:
    case Entity{identity, boundary, persistenceDirection, persistence, persistenceNamesIdentity, current, currentInPersistence, identityHolds}: persistenceDirection

def Entity.persistence(-A: Type, v: Entity<A>) -> PersistenceWitness<A, Entity.persistenceDirection(A, v)>:
  match v:
    case Entity{identity, boundary, persistenceDirection, persistence, persistenceNamesIdentity, current, currentInPersistence, identityHolds}: persistence

def Entity.persistenceNamesIdentity(-A: Type, v: Entity<A>) -> {PersistenceWitness.invariant(A, Entity.persistenceDirection(A, v), Entity.persistence(A, v)) == Entity.identity(A, v) : Invariant<A>}:
  match v:
    case Entity{identity, boundary, persistenceDirection, persistence, persistenceNamesIdentity, current, currentInPersistence, identityHolds}: persistenceNamesIdentity

def Entity.current(-A: Type, v: Entity<A>) -> State<A>:
  match v:
    case Entity{identity, boundary, persistenceDirection, persistence, persistenceNamesIdentity, current, currentInPersistence, identityHolds}: current

def Entity.currentInPersistence(-A: Type, v: Entity<A>) -> member(State<A>, Entity.current(A, v), PersistenceWitness.states(A, Entity.persistenceDirection(A, v), Entity.persistence(A, v))):
  match v:
    case Entity{identity, boundary, persistenceDirection, persistence, persistenceNamesIdentity, current, currentInPersistence, identityHolds}: currentInPersistence

def Entity.identityHolds(-A: Type, v: Entity<A>) -> Invariant.holds(A, Entity.identity(A, v))(Entity.current(A, v)):
  match v:
    case Entity{identity, boundary, persistenceDirection, persistence, persistenceNamesIdentity, current, currentInPersistence, identityHolds}: identityHolds

type Scope<-A: Type> is Type:
  Scope{includes: A -> Type}

def Scope.includes(-A: Type, v: Scope<A>) -> A -> Type:
  match v:
    case Scope{includes}: includes

type Specification<-A: Type> is Type:
  Specification{scope: Scope<A>,
    conforms: A -> Type,
    decideConformity: A -> Bool,
    conformityCorrect: @-x: A -> Logic.Iff<{decideConformity(x) == True{} : Bool}, conforms(x)>,
    conformityWithinScope: @-x: A -> conforms(x) -> Scope.includes(A, scope)(x)}

def Specification.scope(-A: Type, v: Specification<A>) -> Scope<A>:
  match v:
    case Specification{scope, conforms, decideConformity, conformityCorrect, conformityWithinScope}: scope

def Specification.conforms(-A: Type, v: Specification<A>) -> A -> Type:
  match v:
    case Specification{scope, conforms, decideConformity, conformityCorrect, conformityWithinScope}: conforms

def Specification.decideConformity(-A: Type, v: Specification<A>) -> A -> Bool:
  match v:
    case Specification{scope, conforms, decideConformity, conformityCorrect, conformityWithinScope}: decideConformity

def Specification.conformityCorrect(-A: Type, v: Specification<A>) -> @-x: A -> Logic.Iff<{Specification.decideConformity(A, v)(x) == True{} : Bool}, Specification.conforms(A, v)(x)>:
  match v:
    case Specification{scope, conforms, decideConformity, conformityCorrect, conformityWithinScope}: conformityCorrect

def Specification.conformityWithinScope(-A: Type, v: Specification<A>) -> @-x: A -> Specification.conforms(A, v)(x) -> Scope.includes(A, Specification.scope(A, v))(x):
  match v:
    case Specification{scope, conforms, decideConformity, conformityCorrect, conformityWithinScope}: conformityWithinScope
