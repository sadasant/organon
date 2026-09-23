import Base
# Attempt to supply the classical premise as an explicit law.
# An unfilled law is not a trusted axiom in Bend.
law excluded_middle:
  for -A: Type
  Either<&1, &1, A, A -> Empty>
