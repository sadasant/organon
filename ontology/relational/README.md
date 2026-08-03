---
type: finite-relational-experiment
status: noncanonical
created: 2026-08-03
updated: 2026-08-03
prose_ontology: "../ontology.md"
---
# Complete Registry Relational Model

This directory asks one bounded question: can the complete Organon v0.15 registry inhabit one finite relational structure without violating the constraints encoded here?

The answer is yes. Alloy 6.2.0 found one nondegenerate global inhabitant. The constructive JSON witness and an independent Python checker agree on 104 terms, 34 commitments, 110 distinct nodes, 50 typed relation witnesses, 62 anti-entailment counterexamples, and 10 disjointness obligations.

The answer is deliberately narrower than “the ontology is consistent.” The model preserves the complete registry as exact metadata, but only 19 commitments currently contribute executable constraints. Fifteen commitments remain dependency-accurate metadata whose full prose semantics have not yet been translated into relational facts.

## Files

- [`registry-global.als`](./registry-global.als) is generated Alloy source. It encodes the exact registry topology, typed relation signatures, concrete classifications, positive joins, and selected no-collapse obligations.
- [`registry-global-instance.json`](./registry-global-instance.json) is the readable constructive inhabitant from which the fixed Alloy instance is generated.
- [`finite-global-inhabitant-report.md`](./finite-global-inhabitant-report.md) states the result, failed search, coverage boundary, and next falsification targets.
- [`analyzer-receipt.json`](./analyzer-receipt.json) records the exact model digest, Alloy distribution, solver, command, and satisfiable result.
- [`../../scripts/generate-relational-model.py`](../../scripts/generate-relational-model.py) regenerates both model artifacts from the binding registry and relation-signature table.
- [`../../scripts/check-relational-instance.py`](../../scripts/check-relational-instance.py) independently validates the constructive witness and registry dependency acyclicity.
- [`../../scripts/check-relational-receipt.py`](../../scripts/check-relational-receipt.py) binds the checked-in evidence to exact source digests and an ancestor commit.

## Local verification

```sh
python3 scripts/generate-relational-model.py
python3 scripts/check-relational-instance.py
python3 scripts/check-relational-receipt.py
```

To repeat the external solver run with the official Alloy 6.2.0 macOS arm64 bundle:

```sh
alloy exec -q -s glucose -c 0 -t none -o /tmp/organon-alloy ontology/relational/registry-global.als
```

The generated model intentionally does not ask Alloy to recompute the transitive closure of the fixed 104-term dependency graph. The independent checker verifies that exact graph and its acyclicity directly; adding the closure to the SAT problem dominated search without adding evidence about the inhabitant.

## Canonicality boundary

The Markdown ontology remains canonical. This model is a noncanonical challenge artifact. A satisfying finite instance refutes contradiction in the encoded projection; it cannot prove that omitted semantics are consistent, that every manual role normalization is the only faithful one, or that finite classifications exhaust Reality.
