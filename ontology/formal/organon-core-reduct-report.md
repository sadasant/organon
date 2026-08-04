---
type: formal-experiment-report
status: draft
canonicality: noncanonical
created: 2026-08-03
source_ontology: "../ontology.md"
---
# Absence-free OrganonCore Reduct

## Question

Can Organon's current formal classifications be stated without absolute Absence, and do those classifications remain unchanged when the Absence/Presence layer is added back?

This report distinguishes three claims that would otherwise be easy to collapse:

1. **Formal-shadow preservation:** every classifier currently encoded downstream of relational Missingness remains the same in an Absence-free module.
2. **Binding-seam challenge:** the highest-risk Presence → Reality → Missingness → Persistence → Entity path is tested through explicit reduct translations without treating a weaker formal shadow as the binding definition.
3. **Binding-ontology preservation:** every one of the 109 registered prose terms retains its extension after Absence is removed.

The experiment proves the first claim and four challenge classifications in the second. Reality leaves one representation decision pending: the local-carrier theorem is preserved, but the binding totality may be treated as ambient and metatheoretic or projected as a universe-indexed family. The third remains unproved because 103 further registered terms still lack exact paired classifiers.

## Construction

[`OrganonCore.lean`](./OrganonCore.lean) now contains relational Missingness and all downstream formal structures. It declares no `Absent`, `Present`, performative `Mark`, or Absence theorem.

[`DanielOntology.lean`](./DanielOntology.lean) imports `OrganonCore` and adds the local Absence/Presence shadow. It does not copy, wrap, or redefine a core classifier. The extension is conservative by construction: the core declarations visible after import are the exact declarations compiled in the reduct.

Every formal classifier module imports `OrganonCore` directly or imports another module whose root is `OrganonCore`. The finite [`Model.lean`](./Model.lean) executable also imports the reduct rather than the extension. Its former use of `Present (State MachineState)` was exactly `Nonempty (State MachineState)` by abbreviation and is stated directly as `Nonempty`; no classification changed.

[`OrganonCorePreservation.lean`](./OrganonCorePreservation.lean) makes the preservation boundary explicit. A core classifier is a predicate over core data. Adding arbitrary extension semantics cannot change its evaluation because the classifier has no extension parameter. `reductToExtensionPreserved` proves equality between reduct and extended evaluation; `classificationPreserved` and `classificationPreservedForAllValues` prove pointwise and universal invariance across extensions, all by definitional equality.

[`OrganonCoreChallenge.lean`](./OrganonCoreChallenge.lean) tests the first binding seam rather than relying only on import structure. It translates Presence to an inhabited carrier and Missingness to an expected carrier value omitted from a field. It also states a universe-relative local-Reality theorem, but does not identify one carrier with binding Reality. Finally, it classifies Persistence over an explicit directionally ordered history and requires every `Entity` to carry such a witness for its identity Invariant.

The adversarial finite model accepts `[idle, active]` as persistent and rejects `[idle, active, broken]` because the last State violates the identity Invariant. This exposed and repaired a fidelity defect in the earlier `Entity` shadow: present identity and a preservation-capable Boundary did not themselves select the ordered history required by the binding prose. The repair is independent of Absence, but necessary before Entity could participate honestly in the reduct test.

[`organon-core-term-audit.md`](./organon-core-term-audit.md) accounts for all 109 registry entries. Its generated status is checked from `terms.yaml`; a named compiled shadow is never reported as binding preservation without a paired translation.

`formalAbsenceExtension` proves that the existing `Absent`/`Present` interpretation inhabits the generic extension interface, including exclusivity and classical exhaustiveness. It is therefore one concrete extension covered by the preservation theorem rather than an unrelated parallel encoding.

The semantic checker enforces the module boundary. It rejects:

- Absence-extension declarations inside `OrganonCore.lean`;
- a `DanielOntology.lean` that does not extend `OrganonCore`; and
- any other formal module that imports `DanielOntology` and thereby bypasses the reduct boundary.

## Result

### Proven for the current formal shadow

The preservation hypothesis holds for every classifier and witness currently compiled through the reduct:

- State, Direction, Transformation, Feeds, and Causal Path;
- Constraint, Invariant, Boundary, Entity, Scope, and Specification;
- Capability, Permission, exercise, independence, and provenance;
- consciousness candidate, Attribution, and Designation;
- Operationalization;
- World and Substrate;
- Truth, Trust, and Alignment;
- Intelligence, Operative Knowledge, and Knowledge Transmission;
- factive and warranted operative knowledge;
- moral-status discourse;
- the four sovereignty profiles; and
- Preference, Utility Measure, Price, and institutional valuation.

The complete finite witness executable builds and runs from that import graph. The Absence/Presence extension builds as a separate default target. This refutes the claim that the current formal classifiers require Absence merely because they previously shared a source file with its local shadow.

Relational Missingness survives the reduct. It needs a field, an expected value, and proof of nonmembership; it does not need absolute Absence. The extension can still prove that an inhabited `Missingness α` type is `Present`, but that theorem is commentary about the extension rather than a prerequisite for classifying Missingness.

### The difficult seam did not refute the reduct; Reality requires a representation decision

Four declared challenge classifications survive the first falsification pass:

- **Presence:** `Present α` and reduct `CorePresence α` are both `Nonempty α` in the declared formal interpretation.
- **Missingness:** an expected value supplies the Presence witness; field nonmembership is the same load-bearing condition in both interpretations.
- **Persistence:** the same explicit ordered history and identity Invariant are evaluated independently of either extension.
- **Entity:** construction now requires the Persistence witness that the binding definition names, and every constructed Entity satisfies that challenge classifier.

No paired case in these four classifications changes when the Absence extension is removed. The breaking history is rejected by both interpretations. This is evidence against Absence being load-bearing there; it is not a proof about the other terms.

**Reality remains pending.** `localRealityReductPreserved` proves only that every value of one carrier belongs to that carrier's local totality. Binding Reality is the totality of all Presence. It can be treated as the ambient metatheoretic domain in which every formal carrier is a scoped region, or projected through a universe-polymorphic family such as `RealityAt u`. Lean cannot collect every universe into one same-level carrier, but Organon does not require Reality to be an ordinary member of itself. This is therefore a representation decision, not evidence that the ontology is inconsistent and not a counterexample to the reduct. The experiment refuses to choose on behalf of the binding ontology.

### Not proven for the binding ontology

The result does not establish preservation for all 109 registered terms. The audit records 4 proved challenge classifications, 1 pending Reality representation decision, 1 intentionally excluded primitive, and 103 `UNKNOWN` classifications. The formal spike remains intentionally partial. The v0.16 hidden-bridge audit made denotation, causal contribution, evidential bearing, constructive modal capability, cross-State identity criteria, and institutional eligibility explicit; v0.17 adds compiled Flow, Ritual, and Meaning shadows without claiming exact parity. Exact paired classifiers for the full registry remain absent.

The result also does not prove that absolute Absence is incoherent, eliminable from Daniel's metaphysics, or equivalent to a nonempty-domain convention. It proves a narrower architectural fact: the encoded applied classifiers do not inspect the Absence extension.

## Why the theorem is definitionally simple

`classificationPreserved` reduces to `rfl`. That simplicity is evidence of the chosen architecture, not an attempt to disguise the problem. A copied reduct would require 100 equivalence theorems and could drift from the extension. A shared core makes conservativity structural: the extension receives the exact same declarations, and an imported classifier cannot change based on data it cannot name.

The difficult proof obligation has therefore moved to the correct place: showing that each binding prose term is faithfully encoded as a core classifier. Until term-for-term parity exists, prose-wide preservation remains an open gate rather than a theorem manufactured from duplicate definitions.

## Refutation conditions

Formal-shadow preservation would be refuted by any downstream classifier that must import `DanielOntology` because its classification changes with `Absent`, `Present`, or the performative mark. The semantic checker now makes such a dependency visible.

Binding-ontology preservation would be refuted by a case that receives different classifications under:

1. the current Absence/Presence semantics; and
2. a declared reduct interpreting Presence as the nonempty discourse domain and Missingness as scoped nonmembership.

No such case appeared in the first binding seam. Exhaustive search remains unavailable until the complete binding vocabulary has executable paired semantics.

## Promotion boundary

This draft does not change the binding ontology, term registry, primitive, axioms, or adoption profiles. It promotes no term and removes none. It supplies a noncanonical architectural experiment and a maintainable import boundary.

The warranted conclusion is:

> Absolute Absence is not load-bearing for the classifications currently encoded in Lean or for four challenge classifications in the first binding seam. Full binding preservation is not proved: Reality's formal representation is pending, and 103 further terms remain UNKNOWN.

## Next gates

1. Decide whether a universe-indexed Reality projection is an acceptable formal shadow, or keep Reality explicitly metatheoretic.
2. Pair the remaining direct Presence users, beginning with Difference, Relation, Configuration, Environment, Representation, Sign, Claim, CountsAs, World, Truth, Alignment, Factive Operative Knowledge, and Price.
3. Propagate those translations through the registry dependency graph rather than treating transitive reachability as semantic dependence.
4. Add adversarial fixtures at each neighboring-term boundary and stop on the first divergent classification.
5. Replace each of the audit's 103 `UNKNOWN` results with a proof, a counterexample, or a narrower formalization gate.
