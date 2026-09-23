# Initial bounded comparison

These fixtures and [results](./results.json) are the initial comparison of
Bend 2.0.25 and Lean 4.30.0. They precede the broader candidate in the parent
directory. `Equivalent` contains selected constructive/decidable specializations;
it is not the complete Organon formalization. The deliberately invalid cases
are comparison inputs, not members of the clean proof gate.

From this directory, with the pinned Bend executable selected:

```sh
BEND_BIN=/tmp/organon-bend/bin/bend python3 run.py
```

The script warms each direct compiler once, measures seven alternating pairs,
and builds a fresh temporary copy of the original Lean formal directory. OS
caches are not flushed. Bend imports Base and Lean its default prelude. CLI
startup and parsing are included. It asserts the expected outcomes before
reporting timings. The recorded paths have been made portable; diagnostics,
exit statuses, durations, versions, and fixture hashes are retained.

The `Classical` files compare an unfilled Bend law with Lean's proved classical
exhaustiveness and explicitly noncomputable sum-valued counterpart. Rejecting
an unfilled law is not a proof that every possible encoding is impossible.
`Contraction` tests a direct generic translation; `ReusableData` records a
successful narrower workaround. `Unsafe` is check-only and is never executed;
Bend's zero exit with an unsafe notice must not be mistaken for a clean proof.

The original full Lean baseline remains the comparison reference. This script
does not compare a complete Bend port against a complete Lean project.
