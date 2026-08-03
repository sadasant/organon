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

This report distinguishes two claims that would otherwise be easy to collapse:

1. **Formal-shadow preservation:** every classifier currently encoded downstream of relational Missingness remains the same in an Absence-free module.
2. **Binding-ontology preservation:** every one of the 104 registered prose terms retains its extension after Absence is removed.

The experiment proves the first claim. The second remains unproved because the formal shadow does not yet encode every registered term or a semantics for arbitrary Markdown definitions.

## Construction

[`OrganonCore.lean`](./OrganonCore.lean) now contains relational Missingness and all downstream formal structures. It declares no `Absent`, `Present`, performative `Mark`, or Absence theorem.

[`DanielOntology.lean`](./DanielOntology.lean) imports `OrganonCore` and adds the local Absence/Presence shadow. It does not copy, wrap, or redefine a core classifier. The extension is conservative by construction: the core declarations visible after import are the exact declarations compiled in the reduct.

Every formal classifier module imports `OrganonCore` directly or imports another module whose root is `OrganonCore`. The finite [`Model.lean`](./Model.lean) executable also imports the reduct rather than the extension. Its former use of `Present (State MachineState)` was exactly `Nonempty (State MachineState)` by abbreviation and is stated directly as `Nonempty`; no classification changed.

[`OrganonCorePreservation.lean`](./OrganonCorePreservation.lean) makes the preservation boundary explicit. A core classifier is a predicate over core data. Adding arbitrary extension semantics cannot change its evaluation because the classifier has no extension parameter. `reductToExtensionPreserved` proves equality between reduct and extended evaluation; `classificationPreserved` and `classificationPreservedForAllValues` prove pointwise and universal invariance across extensions, all by definitional equality.

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

### Not proven for the binding ontology

The result does not establish preservation for all 104 registered terms. The formal spike remains intentionally partial, and several prose definitions depend on notions that are neither Absence nor formal core declarations, including identity criteria, representation or use, causal relevance, modality, support, denotation, material adequacy, and institutional eligibility.

The result also does not prove that absolute Absence is incoherent, eliminable from Daniel's metaphysics, or equivalent to a nonempty-domain convention. It proves a narrower architectural fact: the encoded applied classifiers do not inspect the Absence extension.

## Why the theorem is definitionally simple

`classificationPreserved` reduces to `rfl`. That simplicity is evidence of the chosen architecture, not an attempt to disguise the problem. A copied reduct would require 100 equivalence theorems and could drift from the extension. A shared core makes conservativity structural: the extension receives the exact same declarations, and an imported classifier cannot change based on data it cannot name.

The difficult proof obligation has therefore moved to the correct place: showing that each binding prose term is faithfully encoded as a core classifier. Until term-for-term parity exists, prose-wide preservation remains an open gate rather than a theorem manufactured from duplicate definitions.

## Refutation conditions

Formal-shadow preservation would be refuted by any downstream classifier that must import `DanielOntology` because its classification changes with `Absent`, `Present`, or the performative mark. The semantic checker now makes such a dependency visible.

Binding-ontology preservation would be refuted by a case that receives different classifications under:

1. the current Absence/Presence semantics; and
2. a declared reduct interpreting Presence as the nonempty discourse domain and Missingness as scoped nonmembership.

No such case can be searched exhaustively until the complete binding vocabulary has an executable classification semantics.

## Promotion boundary

This draft does not change the binding ontology, term registry, primitive, axioms, or adoption profiles. It promotes no term and removes none. It supplies a noncanonical architectural experiment and a maintainable import boundary.

The warranted conclusion is:

> Absolute Absence is not load-bearing for the classifications currently encoded in Lean. Whether it is load-bearing for the complete binding ontology remains UNKNOWN pending term-for-term parity or an explicit counterexample.

## Next gates

1. Map every registered term to a formal declaration, an explicitly metalinguistic statement, or a documented unformalized gate.
2. Define the Absence-free prose translation for Presence, Reality, and Missingness rather than leaving it implicit.
3. Add paired classification fixtures for the translated definitions.
4. Search for a counterexample with a finite model finder once the prose signatures are executable.
5. Prove per-term equivalence or record the first classification that fails.
