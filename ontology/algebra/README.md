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
candidate disciplines and registry-reflection control remain nonbinding. The
experiment is falsification-first: a candidate discipline is retained only
when it uniquely annotates an isolating fixture, and a weakened definition
matters only when an explicit near-miss structure satisfies the weakening
while failing the original join.

## Scope

The training surface follows the feedback's strong first experiment:

- identity: Entity and the hidden identity/Persistence bridge;
- semantic and causal bridges: Denotation and Causal Contribution;
- institutional action: Capability, Standing, and Exercisability;
- epistemic status: Evidence, Evidential Bearing, and Truth.

Consciousness and moral-status discourse, sovereignty and valuation profiles,
and Ritual and Meaning are held out until after the candidate-discipline file
is procedurally frozen. Its digest records which file the holdouts were tested
against; it does not prove that the freeze preceded their authorship.

## Files

```text
ontology/algebra/
├── README.md
├── source-lock.json
├── normal-forms.yaml
├── predicate-signatures.yaml
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

The evaluator treats each card as a typed conjunctive query. A result is
licensed only when one variable assignment satisfies every premise and
witness. [Predicate signatures](./predicate-signatures.yaml) enforce the arity
and argument kinds of every predicate used by cards, substitutions, and joined
circuits. Ordered participant roles and conserved indices remain declared on
the cards. The evaluator therefore cannot join one Entity's Interpretation to
another Entity's Action merely because both predicates occur somewhere in the
model.

## Structural mutation testing

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

This is an extensional query countermodel to the weakened classifier, not a
broad semantic countermodel or proof that the prose formalization is complete.
Mutations that cannot satisfy both conditions must fail generation or become
explicit open gates; none is silently counted.

## Candidate discipline taxonomy

The six hypotheses in [candidate-laws.yaml](./candidate-laws.yaml) are:

1. participant and role distinction;
2. typed non-coercion;
3. index conservation;
4. witnessed promotion;
5. projection asymmetry;
6. underdetermination by default.

They are human-authored annotations over failure shapes, not independently
executed inference laws or new binding ontology. The checker verifies that
each labeled case maps to the stated disciplines and that each discipline has
one unique isolating fixture. It does not derive the blocked classification by
executing the discipline statement. The historical `laws` and `blocked_by`
field names remain for schema continuity.

The six currently fall into three provisional chambers rather than a proven
minimal basis: binding and substitution discipline (`L1`, `L2`, `L3`, `L5`),
introduction discipline (`L4`), and consequence semantics (`L6`). This
organization is a hypothesis, not a reduction result.
The [connective audit](./connective-audit.yaml) separately resolves the twelve
load-bearing ordinary verbs named by the reduction procedure into existing
Relations, compositions, or declared boundaries.

## Result

The current run produces:

- 9 card-level witness models and 3 joined circuit witnesses;
- 138 one-step structural constructor mutations;
- 148 structural near-miss fixtures, including 10 explicit logical challenges;
- 10 held-out classifications;
- 6 candidate disciplines, each uniquely represented by an isolating labeled fixture.

All prohibited holdouts map to prohibiting disciplines in the unchanged
taxonomy. The complete
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
the negative: the six disciplines are an annotation taxonomy, not a generative
algebra. Nine definitions have typed normal forms, while 97 remain positively
underdetermined by the current machinery. Twenty consistency clauses receive
candidate annotations, two remain governance constraints, and nine require
unencoded positive circuits.

This negative result is constructive. The generated
[reduction ledger](./reduction-ledger.yaml) supplies a paired target-extension sketch
for every underdetermined definition and records every commitment exactly
once. A future complete reduction must replace those sketches with actual
models or proofs and add a nondegenerate positive constructor calculus; adding
further prohibitions cannot suffice.

The follow-on [degenerate registry-reflection control](./positive-calculus-report.md)
tests whether a universal wrapper can replay the registry. It reflects all 106
definitions only when handed their complete schemas, every lexical dependency
as a positive fact over one candidate, and an opaque conformity witness. Its
825 dependency-removal fixtures show wrapper sensitivity, not ontological
necessity or an exhaustive constructor search.

The wrapper fails its semantic anti-vacuity gate: it erases participant
structure and relocates all term meaning into the supplied schema and witness.
The positive-constructor question therefore remains open.

## Run

```sh
python3 scripts/build-algebra.py
python3 scripts/build-algebra.py --check
python3 scripts/build-reduction-audit.py
python3 scripts/build-reduction-audit.py --check
python3 scripts/build-positive-calculus.py
python3 scripts/build-positive-calculus.py --check
```

The first command regenerates witnesses, mutations, structural fixtures, and coverage.
The second fails if any generated artifact is stale, a source lock drifts, a
normal form is ill-typed, a near-miss model no longer distinguishes the original
rule, a holdout escapes the unchanged taxonomy, or a candidate discipline
loses its unique labeled fixture.
