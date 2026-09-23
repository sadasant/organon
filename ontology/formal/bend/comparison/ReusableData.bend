import Base
# Repair is available when the result is copyable Data, not arbitrary Type.
def reuse(-A: Data, -B: Data, h: A -> B, x: A) -> B & B:
  +y = h(x)
  (y, y)
