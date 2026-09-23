# Bend migration candidate

Bend can check more of Organon's current proof structure than the initial
assessment suggested. This candidate translates arbitrary predicates,
Missingness, the dependent Entity/Persistence seam, classifier preservation,
and the original four-state machine's activation and breaking cases. It is
**partial and noncanonical**: 21 of the 99 Lean theorems have checked candidates;
78 remain on Lean. No binding ontology change or cross-language equivalence
proof is claimed.

## Run

Install the pinned, checksum-verified release into a new directory:

```sh
python3 scripts/install-bend.py --dest /tmp/organon-bend
BEND_BIN=/tmp/organon-bend/bin/bend python3 scripts/check-bend.py
```

The installer requires Python 3.12 or newer. It accepts Linux/macOS on arm64 or
x64, does not modify shell configuration, and refuses an existing destination.
The checker disables Bend's version-check telemetry, requires 2.0.25, and runs
nine positive, negative, and mutation checks. The existing Lean and repository
checks remain required.

The direct proof command, from this directory, is:

```sh
BEND_NO_TELEMETRY=1 bend PROOF.bend --check-only
```

Use the Python gate for CI: Bend can return exit zero when unsafe code is
present. The gate requires the exact clean verdict and tests that distinction.

That clean verdict is not currently sufficient to promote or extend the
migration. Bend 2.0.25 accepts a closed inhabitant of `Empty` through an opaque
template-name capture ([bendlang/bend#994](https://github.com/bendlang/bend/issues/994)).
The defect was reproduced against current upstream, and the proposed compiler
repair and regressions are in
[bendlang/bend#1006](https://github.com/bendlang/bend/pull/1006). The 21 counted
candidates contain no `~` template binders; the only one in this directory is
the explicitly non-preserving `EmptyEquivTemplate` probe. That limits exposure
to the reported mechanism but does not restore trust in the pinned checker's
clean verdict. A full migration remains blocked until the repair is merged,
released, pinned here, and the complete candidate is revalidated.

## What is checked

[LAWS.bend](./LAWS.bend) states the theorem candidates; [PROOF.bend](./PROOF.bend)
supplies their proofs. [Core.bend](./Core.bend) contains dependent records and
projections. [Reduct.bend](./Reduct.bend) makes extension independence explicit.
[Model.bend](./Model.bend) supplies an inhabited Entity with the same four named
machine states and three directed edges as the original finite machine. Its
Boundary admits activation, rejects breaking, and its history classifier rejects
a history containing the broken state. This is not the full Lean finite model;
institutional, World/Substrate, and other downstream witnesses remain to port.

The generic classifiers use arbitrary type-valued predicates, not Boolean
substitutes. Bend's types-as-propositions and quantities do not automatically
reproduce Lean's universes or proof irrelevance. The finite direction uses
`Unit`/`Empty` for its edge relation, replacing the original disjunction of
state equalities; its enumerated relation is the same, but this is a
representation change. Predicate signatures, nonempty witness representation,
and proof reuse still require semantic review. A checked candidate is not a
certificate that all those representations are equivalent.

[coverage.json](./coverage.json) pins all 13 original Lean source files and
inventories every top-level structure, definition, abbreviation, inductive, and
theorem. Each checked law maps to an original theorem. Unported declarations
stay explicitly pending; no unported theorem is deleted or accepted as an axiom.
The `translated-candidate` status describes compiler acceptance, not completed
semantic review. The checker detects changed baseline sources, inventory drift,
and an unmapped or missing Bend law.

## Decisions before replacement

- **Classical exhaustiveness:** [Classical.bend](./probes/Classical.bend) is
  intentionally rejected as an open law. The [explicit-premise
  candidate](./probes/ClassicalAssumption.bend) checks when its caller supplies
  classical bivalence, but does not construct that premise. Whether to expose
  this assumption or retain Lean for the closed theorem awaits Daniel's choice.
- **Generic empty equivalence:** [the direct translation](./probes/EmptyEquiv.bend)
  is intentionally rejected for reusing absence proofs. The [closed template
  specialization](./probes/EmptyEquivTemplate.bend) checks. Its compile-time
  argument requirement is a different interface; it is not counted as a
  completed port of `emptyEquiv`.
- **Remaining declarations:** 78 theorem candidates and downstream definitions
  and witnesses remain unported. The presence of corresponding vocabulary in
  this directory supplies no evidence about those obligations.

These choices must be settled before propagating a proof representation across
the remaining modules. The checker repair must also be released and pinned
before further migration. Lean remains the full verification gate meanwhile.

## Evidence and comparison

The initial matched, small proof fixture checked in 78 ms with Bend 2.0.25 and
166 ms with Lean 4.30.0 (seven interleaved samples, warm filesystem/toolchain caches,
process startup included). That is about 2.1x for that fixture, not a measured
speedup for a complete migration. A fresh-artifact build of the original full
Lean project took 5.47 seconds; an unchanged build took 153 ms. The initial
fixture and results are retained under [comparison/](./comparison/README.md).

The [candidate evidence](./evidence.json) records the pinned compiler version,
source digests, commands, observed verdicts, and timings for this candidate.
A proof missing its definition is rejected. Mutating rejection of breaking into
rejection of admitted activation is rejected. Making the broken state satisfy
the identity Invariant is rejected. Adding `@unsafe` is accepted by Bend with a
notice, and correctly fails the repository's clean-proof predicate.

No GPU benefit, full-port build speedup, or complete logical equivalence has
been measured. The candidate demonstrates feasibility and a concrete proof
review surface; it does not yet justify removing the existing Lean obligations.
