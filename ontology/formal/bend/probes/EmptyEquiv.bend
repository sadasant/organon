import Base
import ../Logic.bend as Logic

def emptyEquiv(-A: Type, -B: Type, ha: A -> Empty, hb: B -> Empty) -> Logic.TypeEquiv<A, B>:
  Logic.TypeEquiv{
    a => Logic.absenceElim(A, B, ha, a),
    b => Logic.absenceElim(B, A, hb, b),
    a => Logic.emptyElim({Logic.absenceElim(B, A, hb, Logic.absenceElim(A, B, ha, a)) == a : A}, ha(a)),
    b => Logic.emptyElim({Logic.absenceElim(A, B, ha, Logic.absenceElim(B, A, hb, b)) == b : B}, hb(b))}
