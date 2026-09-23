import Base
import ../Logic.bend as Logic

# Expected rejection: declaring classical bivalence does not prove it.
law absencePresenceExhaustive:
  for -A: Type
  Either<&1, &1, A -> Empty, Logic.Nonempty<A>>
