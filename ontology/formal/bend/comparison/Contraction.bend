import Base
# Lean permits reusing arbitrary function-valued proof hypotheses.
def reuse(-A: Data, -B: Type, h: A -> B, +x: A) -> B & B:
  (h(x), h(x))
