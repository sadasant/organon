import Base

# Proof connectives, retaining arbitrary Type-valued predicates.
type Both<-A: Type, -B: Type> is Type:
  Both{left: A, right: B}

type Iff<-A: Type, -B: Type> is Type:
  Iff{forward: A -> B, backward: B -> A}

type Nonempty<-A: Type> is Type:
  Nonempty{value: A}

type TypeEquiv<-A: Type, -B: Type> is Type:
  TypeEquiv{toFun: A -> B, invFun: B -> A,
    leftInv: @a: A -> {invFun(toFun(a)) == a : A},
    rightInv: @b: B -> {toFun(invFun(b)) == b : B}}

def emptyElim(-A: Type, e: Empty) -> A:
  match e:

def absenceElim(-A: Type, -B: Type, absent: A -> Empty, value: A) -> B:
  emptyElim(B, absent(value))

type Mark is Data:
  Drawn{}
