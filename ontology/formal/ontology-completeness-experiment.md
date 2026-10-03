---
type: formal-experiment-report
status: nonbinding
binding: false
created: 2026-10-03
base_commit: "34e24ecb7e0b09618067547a2973979cb6af0bb3"
---

# Ontological frameworks and completeness

This experiment asks whether Organon can describe an ontology using its own vocabulary and then test precisely stated completeness claims in Lean. The initial results establish a conditional expressivity limit and a concrete limit of what the Body constraints determine. They also refute the inference that selectivity alone makes every framework incomplete. None establishes a universal theorem that every ontology fails to describe all Reality.

The experiment is on `experiment/ontology-completeness`, rebased onto main after [PR 16](https://github.com/sadasant/organon/pull/16) merged. The base above identifies that merge. Its files are separate from the Body implementation and its exact-source promotion review.

The [eight-term proposal](../../proposals/ontological-frameworks.md) contains the English definitions, termhood reductions, dependencies, and open gates. Daniel requested this combined review of his developing framework, probability, scarcity, and source-loss proposals. It remains nonbinding; merging this experiment does not update the adopted registry.

## Candidate definition using Organon

**Proposed derived profile:** An ontological framework is a Configuration of Representations, Constraints, and Rules that articulates distinctions among Presences, Relations, and Configurations within a declared Scope. Its Representations name their Denotations; its Rules specify admissible applications and Transformations of those Representations under the stated Constraints.

This is a proposed definition, not a binding `organon:Ontology` term. The strongest reduction is a Configuration of existing terms. No surviving need for a new primitive or stable term has been demonstrated. The categorical content of the Representations distinguishes this profile from an arbitrary Configuration; the declared joins, rather than the mere presence of those dependencies, must establish an instance.

The complete lexical dependency inventory of the candidate is Configuration, Representation, Constraint, Rule, Difference, Presence, Relation, Scope, Denotation, and Transformation. Specification is a transitive dependency through Rule. “Categorical” and the expression inventory remain declared metalanguage in this initial experiment. A definition need not define its own metalanguage to be stated within Organon, but it must expose that boundary.

Language, Agent, Institution, Authority, Map, Body, and Entity are not constitutive premises of this profile. Linguistic encoding, assertion by an Agent, institutional adoption, bodily enactment, and use as a Map are additional structures requiring their own witnesses. In particular, the definition does not assume omission by defining Ontology as a Map and then claim to have independently proved omission. Body is used below as a test case, not as a prerequisite of every ontology.

Rules may have constructively decidable local conformity without deciding every consequence of a theory. Defining this profile therefore does not grant an algorithm for arbitrary truth, inference, or metaphysical existence.

## What the Lean projection represents

[`OntologyCompleteness.lean`](./OntologyCompleteness.lean) imports the Body module and uses Organon's existing Scope and Denotation structures. `OntologyProjection` represents an active expression inventory, its target classifiers, scope confinement, and exact expression-to-predicate Denotations.

This is a coverage projection of the candidate, not term-for-term formal parity. It does not construct canonical categorical Representations as Presences, a persistent Language, general Rule objects, causal Interpretation, or an enacted Configuration. Predicate targets live in Lean's metatheory; that encoding does not establish their correspondence to all Presence. The proof results concern the explicitly stated carrier and interpretation, not Reality as an unrestricted totality.

## Completeness claims and checked results

| Question | Exact test | Result |
| --- | --- | --- |
| Target coverage | Every in-scope target receives an active classification | A universal category covers both Boolean targets but distinguishes neither. Coverage alone is too weak to express the philosophical claim. |
| Omission | A named in-scope target receives no classification | A selective one-category projection omits `true`; Lean proves failure of coverage. |
| Complete finite expressivity | Every predicate on a declared two-element carrier has an active expression | Four Boolean categories suffice. Lean proves predicate completeness using classical logic to select the predicate's truth bits. This is not an executable decision procedure for arbitrary Lean propositions. |
| Unrestricted expressivity over an infinite carrier | Natural-number-indexed expressions represent every predicate on the natural numbers | Impossible by diagonalization. The missing predicate differs from expression n at target n. The theorem assumes neither continuity nor Gödelian arithmetic proof machinery. |
| Determination by Body constraints | A named sensor-membership sentence has the same truth value in every Body interpretation over one fixed Entity | False. Two constructed Bodies preserve the same named State history and recurring Transformations but disagree about sensor membership at `forwardLow`. |
| Sound derivability for that sentence | A proof calculus sound in all those Body interpretations proves membership or its negation | Neither side can have a proof in such a calculus. This is conditional on that model class and soundness. No full Organon proof calculus is constructed here. |

The main theorem names are `coverageDoesNotEntailSeparation`, `selectiveHasAnOmittedTarget`, `finiteOntologyCanBePredicateComplete`, `countableExpressionsCannotExpressEveryPredicate`, `natProjectionCannotBePredicateComplete`, `sameEntityBodiesDisagreeAtNamedState`, `bodyConstraintsDoNotDetermineNamedMembership`, and `soundBodyCalculusCannotDecideMembership`.

## Interpretation of the Body result

The existing Body witness replaces a sensor constituent with a regulator across its history. `sensorOnlyBody` reuses that same Entity, State history, Boundary, Interior, transformations, and paths while keeping a sensor constituent. Both satisfy the formal Body structure. The named State belongs to the shared history, so the disagreement is not manufactured at an irrelevant out-of-scope State.

The result establishes underdetermination by the Body constraints for a named instance. It does not show inconsistency, lack of Entity Persistence, or a defect in allowing distinct Bodies. Supplying additional instance data can resolve the membership claim. The existing `Body.partAt` boundary is already acknowledged by the proposal; this experiment does not turn it into canonical mereology or claim that the full binding prose has been formalized.

## Philosophical boundary

The infinite-carrier result is a Cantor-style expressivity obstruction. It concerns all predicates, including ones outside any chosen object language. Requiring representation only of predicates definable in that same language is a different, weaker requirement. A finite vocabulary of schemas admitting parameters is also different from a fixed list of closed expressions; the diagonal theorem applies when instantiated expressions are indexed by Nat.

This is not Gödel's incompleteness theorem. To apply Gödel, Organon would need a specified formal language, an effective axiom and proof system, suitable arithmetic expressivity, and the relevant consistency assumptions. The current Lean formal shadow proves selected properties and supplies models; it does not identify those models with a complete axiomatization of Reality.

Nor does the distinction between categorical descriptions and Reality by itself prove that Reality is continuous, that every category is discontinuous, or that a finite selective framework is deductively incomplete. The finite completeness witness makes that last universal inference unavailable under this definition.

## Validation and remaining work

Run from `ontology/formal`:

```sh
lake build
lake exe ontology_check
lake env lean OntologyCompleteness.lean
```

The standalone experiment is checked by the last command; it is not silently included in the inherited default Lake target. The pinned Body build receipt and adversarial review attest their original sources, not this added experiment. Keeping this separate avoids changing those exact-source pins before the Body merge.

Lean 4.30.0 checks the module without `sorry`, `admit`, new axioms, or warnings. The diagonal theorem has no axiomatic dependencies. The finite completeness and Body-calculus results use the inherited standard Lean commitments `propext`, `Classical.choice`, and `Quot.sound`; they do not acquire `sorryAx` or a new incompleteness axiom.

Verification completed on 2026-10-03: the inherited 32-job Lake build, `ontology_check`, standalone experiment compilation, repository boundary and link check, semantic check (114 terms and 49 typed commitments), structure check, Body promotion-review check, and formal-receipt check all passed. These checks preserve the inherited Body attestation; they do not extend its proof-parity claim to this experimental definition.

Before promoting a stable term, complete the termhood challenge, choose the intended meaning of completeness, formalize the candidate's remaining Configuration and Rule joins, and supply exact prose parity and the repository's dependency-complete promotion evidence. A universal claim about Reality needs an explicit representation decision in addition to those gates. No blanket completeness or incompleteness claim is promoted by this experiment.

## Extended profiles and exact verification

The module now defines Classification, Ontological Framework, Granularity, Expressivity, Scarcity, a finite projection of Ontological Probability, Differentiation, and the source-relative Novelty criterion. Their English definitions and precise formal limits are in the dossier linked above.

Additional checked results include a finite framework/classification/rewrite witness; a blocked rewrite despite a satisfied rule; equivalence laws for granularity; reflexivity and transitivity of refinement; strict refinement; complete separation without complete predicate expressivity; individually feasible but jointly scarce requests; the same requests feasible under another allocation model; normalized probabilities differing despite equal outcome inventories; and source loss followed by reconnection. Novelty is explicitly the declared differentiation criterion, not independently derived metaphysical creation.

Run `python3 scripts/check-ontology-frameworks.py` from the repository root. It builds the existing shadow, compiles the standalone module, audits every theorem, and rejects placeholders, new axiom/opaque declarations, warnings, or dependencies outside Lean's standard `propext`, `Classical.choice`, and `Quot.sound`. The dedicated workflow runs this checker without altering the Body promotion's pinned Lake file or workflow.

This is a schema-v1 nonbinding dossier with explicit declaration mappings and a theorem/evidence ledger. It does not claim schema-v2 promotion-contract verification or promotion readiness. Full canonical joins, formal contract ledgers, and exact-source adversarial review remain gates before any binding promotion.
