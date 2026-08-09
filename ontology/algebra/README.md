---
type: ontology-algebra-experiment
status: nonbinding
ontology_version: "0.18.0"
source_lock: source-lock.json
---
# Candidate algebra experiment

Organon currently states licensed joins in definitions and prohibited collapses
in consistency rules. This experiment asks a second-order question: do several
of those local definitions and fences instantiate a smaller calculus over typed
participants, conserved indices, and explicit witnesses?

It does not shorten the binding term definitions. Version 0.18 is frozen by
commit and source digest in [source-lock.json](./source-lock.json); v0.18
promotes only the definition-admission invariant discovered here, while the
candidate laws and constructor remain nonbinding. The experiment is
falsification-first: a candidate law matters only when removing
it changes a finite classification, and a weakened definition matters only
when an explicit near-miss model satisfies the weakening while failing the
original join.

## Scope

The training surface follows the feedback's strong first experiment:

- identity: Entity and the hidden identity/Persistence bridge;
- semantic and causal bridges: Denotation and Causal Contribution;
- institutional action: Capability, Standing, and Exercisability;
- epistemic status: Evidence, Evidential Bearing, and Truth.

Consciousness and moral-status discourse, sovereignty and valuation profiles,
and Ritual and Meaning are held out until after the candidate basis is frozen.
The holdouts do not modify the laws.

## Files

```text
ontology/algebra/
├── README.md
├── source-lock.json
├── normal-forms.yaml
├── connective-audit.yaml
├── candidate-laws.yaml
├── claim-coverage.yaml
├── consistency-dispositions.yaml
├── positive-calculus.yaml
├── mutations.yaml
├── coverage.md
├── reduction-ledger.yaml
├── complete-reduction-report.md
├── constructor-ledger.yaml
├── positive-calculus-report.md
├── residuals.md
└── fixtures/
    ├── challenges.yaml
    ├── holdouts.yaml
    ├── witnesses.yaml
    └── countermodels.yaml
```

Files with a `.yaml` suffix contain JSON, matching the existing term registry's
dependency-free machine-readable convention.

## Witness normal form

Each card in [normal-forms.yaml](./normal-forms.yaml) names:

- one typed result predicate and kind;
- every typed variable, participant, and index;
- necessary premise atoms;
- existential witness atoms;
- variables that must be shared across atoms;
- positive entailments and normalized anti-entailments;
- the exact near-miss mutation operators applicable to that definition.

The evaluator treats a card as a conjunctive query. A result is licensed only
when one variable assignment satisfies every premise and witness. It therefore
cannot join one Entity's Interpretation to another Entity's Action merely
because both predicates occur somewhere in the model.

## Semantic mutation testing

`scripts/build-algebra.py` generates every declared one-step mutation:

1. remove each premise;
2. remove each witness;
3. split each repeated participant or index;
4. reverse each declared ordered relation;
5. substitute every declared causal, institutional, representational, or
   Persistence near miss.

For each mutation, the generator constructs a finite extensional model and
checks two facts:

- the weakened rule derives in that model;
- the original normal form does not.

This is a countermodel to the weakened classifier, not a proof that the prose
formalization is complete. Mutations that cannot satisfy both conditions must
fail generation or become explicit open gates; none is silently counted.

## Candidate basis

The six hypotheses in [candidate-laws.yaml](./candidate-laws.yaml) are:

1. participant and role distinction;
2. typed non-coercion;
3. index conservation;
4. witnessed promotion;
5. projection asymmetry;
6. underdetermination by default.

They are structural predicates over failure shapes, not new binding ontology.
The [connective audit](./connective-audit.yaml) separately resolves the twelve
load-bearing ordinary verbs named by the reduction procedure into existing
Relations, compositions, or declared boundaries.

## Result

The current run produces:

- 9 card-level witness models and 3 joined circuit witnesses;
- 136 one-step semantic mutations;
- 146 finite countermodels, including 10 explicit logical challenges;
- 10 held-out classifications;
- 6 candidate laws, each with an isolating ablation witness.

All prohibited holdouts are rejected by the unchanged basis. The complete
CountsAs holdout remains licensed: an Order may constitute an indexed
institutional status without constituting a material consciousness or moral
condition. That exception is part of the result, not an escape hatch added
afterward.

[Coverage](./coverage.md) records the generated matrix. [Residuals](./residuals.md)
states what this experiment has not established.

## Complete-registry result

The [complete reduction audit](./complete-reduction-report.md) extends the
experiment from its training surface to an exhaustive disposition of all 109
registered terms and all 42 commitments. It answers the reduction question in
the negative: the six laws form an admissibility algebra, not a generative
algebra. Nine definitions have positive normal forms, while 97 remain
positively underdetermined by the current basis. Twenty consistency clauses
receive candidate derivations, two remain governance constraints, and nine
require unencoded positive circuits.

This negative result is constructive. The generated
[reduction ledger](./reduction-ledger.yaml) supplies a paired interpretation
for every underdetermined definition and records every commitment exactly
once. A future complete reduction must eliminate those pairs by adding a small
positive constructor calculus; adding further prohibitions cannot suffice.

The follow-on [positive constructor experiment](./positive-calculus-report.md)
asks exactly how small that calculus can become. By registry-level rule
cardinality, the answer is one: witnessed definition introduction derives all 106 registered
definitions and zero constructors derive none. Its 825 premise-removal tests
show that every declared dependency and every conformity witness remains
load-bearing.

That operational minimum fails its semantic anti-vacuity gate. The one
constructor is parameterized by all 106 binding definition schemas, and its
conformity witness remains opaque to the finite evaluator. The experiment
therefore establishes the degenerate lower bound while proving no two
definitions interchangeable and eliminating no meaning from the binding
ontology.

## Run

```sh
python3 scripts/build-algebra.py
python3 scripts/build-algebra.py --check
python3 scripts/build-reduction-audit.py
python3 scripts/build-reduction-audit.py --check
python3 scripts/build-positive-calculus.py
python3 scripts/build-positive-calculus.py --check
```

The first command regenerates witnesses, mutations, countermodels, and coverage.
The second fails if any generated artifact is stale, a source lock drifts, a
normal form is ill-typed, a near-miss model no longer distinguishes the original
rule, a holdout escapes the unchanged basis, or a candidate law loses its
ablation witness.
