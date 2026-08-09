# Positive constructor calculus

> Generated from the complete v0.18 registry. This is a nonbinding operational reduction, not a replacement for the binding definitions.

## Result

The smallest positive constructor calculus by **registry-level rule cardinality** contains one rule:

> **G1 — Witnessed definition introduction.** A registered definition introduces its typed result when every declared dependency is present under one assignment and a constructive witness establishes conformity to the complete binding definition schema.

Zero positive constructors derive zero definitions because the six admissibility laws have no positive heads. G1 derives all **106 definitions**. Ablating G1 returns the derived count to zero. Therefore one is the cardinality minimum.

The result survives **825 one-step mutations**: removing any declared dependency or the conformity witness makes the complete constructor fail while the weakened near-miss would still admit the target. The six-law admissibility algebra supplies the corresponding type, index, participant, projection, witness, and underdetermination discipline.

## Anti-vacuity result

**G1 fails the semantic anti-vacuity gate.** The finite evaluator can verify that a `Conforms` witness is present and that removing it breaks introduction, but it cannot derive that witness from the prose definition. G1 therefore relocates all semantic work into an opaque parameter.

This is an operational lower bound, not a semantic reduction. G1 remains parameterized by all **106 binding definition schemas**. Replacing those schemas with the target labels would be circular; weakening them to dependency presence would be unsound. The ontology's meanings therefore remain where they belong: in the registered definitions. “Definition schema” belongs to the metalanguage here; it is not the object-language term `Specification`.

The exhaustive answer has two layers:

| Question | Answer |
|---|---|
| Smallest registry-level positive rule calculus | **1 constructor: G1** |
| Definitions generated | **106 of 106** |
| Definitions semantically eliminated | **0** |
| Semantic anti-vacuity gate | **failed: opaque conformity witness** |
| Binding foundation retained | **3 terms** |
| Admissibility basis | **6 candidate laws** |
| Complete ontology compressed to seven sentences | **No** |

## What the exhaustive search establishes

At the present level of proof, Organon's smallest registry-level admission architecture is:

1. the declared foundation and metalanguage;
2. 106 binding definition schemas in dependency order;
3. one generic witnessed-introduction constructor for those schemas; and
4. six candidate admissibility laws governing composition and prohibited collapse.

This removes duplicated introduction machinery without pretending that Daniel's distinctions are interchangeable. It is not eligible for promotion as the ontology's semantic constructor calculus. A nondegenerate reduction requires typed, proof-producing conformance predicates for each definition family; only then can constructor families be merged and ablated without hiding their content in an oracle. The current experiment proves no definition interdefinable, redundant, or eliminable, so it eliminates none.

## Machine evidence

The [constructor ledger](./constructor-ledger.yaml) records every definition's declared dependencies, complete conformity witness, canonical derivation, and every premise-removal mutation.
