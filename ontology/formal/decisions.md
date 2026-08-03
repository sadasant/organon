---
type: formalization-decisions
status: noncanonical
created: 2026-08-02
updated: 2026-08-02
prose_ontology: "../ontology.md"
---
# Formalization Decisions

These decisions belong to the Lean spike. They expose choices priced by formalization. They do not independently revise [Daniel's Ontology v0.9](../ontology.md); accepted findings flow into the binding Markdown through its changelog.

## Absence is not `Empty`

`Absent α := α → False` is a local shadow inside Lean's already-present metatheory. It proves that a type has no inhabitants. It is not absolute Absence, which cannot become an object inside a formal system without contradicting its definition.

## Presence is type-relative

`Present α := Nonempty α` says that a particular type has an inhabitant. It does not yet encode Reality as the totality of every Presence.

## A3 currently commits to classical logic

Exclusivity is constructive. Exhaustiveness for an arbitrary type requires excluded middle in this encoding. The declaration makes that commitment locally visible with `classical`, and v0.9 names classical logic in the binding metalanguage rather than presenting A3 as neutral.

## A4 has two evidence levels

`presenceObtains` is an object-level witness: the declared `Mark` has an inhabitant. Successful compilation is metatheoretic Evidence that the source file occurred and elaborated. Compilation does not turn the compiler into an object-level premise.

## A5 represents Missingness positively

`Missingness α` contains a Field, an expected inhabitant, and proof that the Field omits it. A value of this structure is itself present. Missingness therefore cannot collapse into the uninhabited-type predicate used as Absence's local shadow.

## Direction internalizes ordering

`State` is the object-level carrier used by all later machinery and has no numeric index. Declaration order remains metalinguistic. `Direction.before` is the first-class asymmetric Relation, and `Transformation direction` carries that Direction as a type parameter. A `CausalPath direction feeding` therefore shares one Direction and composes through an explicit `FeedRelation` without requiring equality between adjacent States.

## Specification carries constructive content

Classical `conforms x ∨ ¬ conforms x` is available for every predicate and therefore cannot distinguish a Specification. `Specification.decideConformity : α → Bool` instead carries an executable decision interface, while `decision_correct` connects the result to the proposition and `conformityWithinScope` prevents out-of-scope conformity. Lean still permits noncomputable definitions to inhabit such a field, so concrete evaluation in the finite model is part of the receipt.

## Identity remains parameterized

An Entity supplies an identity Invariant, and its Boundary proves that admitted Transformations preserve that Invariant. Lean checks the dependency and preservation proof. It does not choose which Invariant genuinely constitutes an Entity's identity.

## Empty Boundary means maximal obligation

Boundary Constraints are conjunctive admission conditions. An empty list admits every Transformation, so the preservation proof must establish the identity Invariant for every Transformation. The theorem `emptyBoundaryRequiresUniversalPreservation` exposes this consequence. Constraint-poverty is maximal obligation, not proof-free openness.

## Permission is Order-indexed and does not imply Capability

`Permission` is admitted by an `InstitutionalOrder` from a standing-aware `PermissionClaim`, an authorized `Grant`, and the Order's admission judgment. It contains no Capability field. A Principal may authorize Actions that an Agent cannot currently perform. `PermissionExercise` separately names one Action and requires current contextual Capability, admission at the exercise State, and no applicable Revocation. This prevents the institutional layer from collapsing into the mechanical one in either direction.

## Independence is scoped, not intrinsic

`IndependentFor` is parameterized by Witness, claimant, Claim, Observation, and Order. It requires both absence of the claimant's mechanical control over the Witness and absence of institutional Authority over the Witness for the relevant Claim. The accompanying admissibility provenance records which Rule and Declaration made the judgment operative. Independence is therefore not an enduring property of a Witness in isolation.

## Consciousness discourse is formalized without a consciousness axiom

The consciousness proposal separates `CandidateCondition`, its `Specification`, `ConsciousnessAttribution`, and `ConsciousnessDesignation`. Attribution carries a Representation, independent Claim Scope, Language, meaning Rule, Reference Map, and checked first-person or third-person perspective without carrying a proof that the candidate obtains. Designation is one Order-indexed counting event; `DesignationOrder.countingRequiresAdmission` derives Admission from that event instead of storing an unrelated admission Claim. The finite witnesses establish only the named anti-entailments: Attribution does not entail candidate obtainment, Designation does not entail candidate obtainment, and non-designation does not decide candidate obtainment.

The formal artifact does not encode an evidentiary disposition. Such a structure remains blocked until Evidence is joined to Observation, scoped Witness independence, admissibility provenance, and a declared evaluation Rule whose proved result supplies the disposition.

The formal shadow models candidate conditions, Consciousness Attributions, and Order-indexed Consciousness Designations without defining a universal consciousness predicate. Its finite countermodels show that neither Attribution nor Designation entails candidate obtainment, and that candidate obtainment does not entail Designation. Designation remains institutionally dependent on an admitted Attribution. The artifact does not yet formalize evidentiary disposition.

## Relations use typed structures, not one universal relation type

Direction, Transformation, Boundary, Capability, and Permission have different arities and dependencies. The spike encodes each with the narrowest useful record. A later parity pass must decide whether the ontology benefits from a common first-class Relation interface or whether that abstraction would erase important types.

## Scope of the spike

The spike formalizes A1-A5 and selected high-risk dependency regions. Its finite models construct one concrete Entity with an admitted preserving Transformation and a rejected identity-breaking Transformation, one standing-aware Permission and one contextual PermissionExercise, and one Consciousness Designation whose candidate does not obtain. A silent Designation Order supplies the countermodel showing that non-designation does not decide candidate obtainment. The spike does not yet cover all derived terms, relation signatures, anti-collapse rules, quarantined vocabulary, or deterministic Markdown rendering. Those remain promotion gates rather than implicit Claims of completeness.
