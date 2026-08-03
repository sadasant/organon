---
type: formalization-decisions
status: noncanonical
created: 2026-08-02
updated: 2026-08-03
prose_ontology: "../ontology.md"
---
# Formalization Decisions

These decisions belong to the Lean spike. They expose choices priced by formalization. They do not independently revise [Daniel's Ontology v0.12](../ontology.md); accepted findings flow into the binding, single-file Markdown ontology through its changelog.

## Absence is not `Empty`

`Absent α := α → False` is a local shadow inside Lean's already-present metatheory. It proves that a type has no inhabitants. It is not absolute Absence, which cannot become an object inside a formal system without contradicting its definition.

## Presence is type-relative

`Present α := Nonempty α` says that a particular type has an inhabitant. It does not yet encode Reality as the totality of every Presence.

## A3 currently commits to classical logic

Exclusivity is constructive. Exhaustiveness for an arbitrary type requires excluded middle in this encoding. The declaration makes that commitment locally visible with `classical`, and the binding ontology names classical logic in its metalanguage rather than presenting A3 as neutral.

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

## Relations use typed structures, not one universal relation type

Direction, Transformation, Boundary, Capability, and Permission have different arities and dependencies. The spike encodes each with the narrowest useful record. A later parity pass must decide whether the ontology benefits from a common first-class Relation interface or whether that abstraction would erase important types.

## Operationalization requires semantic discrimination

A representational carrier merely occurring in a Causal path is insufficient. `Operationalization` joins a Representation to a selection Rule, an Interface, a Scope, a selected Transformation, and proof that the Transformation occurs in the path. It also requires an in-scope alternative Representation for which the same Rule does not select that Transformation. The alternative witnesses that representational Difference, rather than only the carrier's physical presence, matters to selection.

The finite model proves the exact negative results claimed by C11: an inhabited Operationalization need not satisfy a fidelity predicate and need not be admitted as Evidence; even the selected Transformation reaching its output does not establish Evidence. These are countermodels to entailment, not definitions of Map fidelity, Evidence admission, or Consequence. Full joins to those ontology regions remain open formalization gates.

## World requires distinct access and a common Invariant

`World` is not encoded as an alias for a list of States. It carries nonempty participants, scoped States, distinct `AccessPath` values, and one Invariant proved for every World State. Each AccessPath carries its own nonempty Causal path, begins at its participant's current State, remains within the World Scope, and must locate every advertised available State at an input or output of an actual Transformation. This prices two commitments hidden by the ordinary word: access is participant-indexed and causally witnessed, and a World Claim requires more than one private Perception.

The finite model contains active and standby States while excluding the inhabited broken State from the World's Scope. One path reaches active and another reaches standby from the participant's current idle State; the paths therefore need not agree on availability even though both World States satisfy the common operational Invariant. This proves non-universal Scope over one carrier type and non-identical causal access. It is not a formalization of Reality or proof that the named Invariant uniquely identifies a World.

## Substrate is contextual; realization remains open

`Substrate` carries its Scope, an ordered source-Persistence witness, Constraints, Causal path, and explicit Feeds witnesses. `PersistenceWitness` requires at least two States, proves their order under one Direction, and proves one Invariant throughout that sequence. An earlier shadow used only pointwise satisfaction over an unordered list; that was rejected because it did not meet Organon's definition of Persistence. An earlier shadow also carried an arbitrary content value and a free `supports` predicate. That field was rejected as decorative because any predicate could inhabit it and therefore proved no realization or reduction relation.

The finite Substrate supplies the ordered idle-then-active source sequence to an activation-then-break path. The sequence preserves the operational Invariant and every Transformation is admitted by the named Constraint, yet the final output violates that Invariant. This proves only that ordered source Persistence does not entail preservation of the same Invariant in every supported output. Every carrier-to-content, supervenience, emergence, or realization Claim remains outside the formal boundary until Organon defines a proof-bearing realization relation.

## Scope of the spike

The spike formalizes A1-A5 and selected high-risk dependency regions. Its finite models construct one concrete Entity with an admitted preserving Transformation and a rejected identity-breaking Transformation, one standing-aware Permission and one contextual PermissionExercise, one Consciousness Designation whose candidate does not obtain, one discriminating Operationalization whose selected Transformation occurs in a Causal path, one scoped World with distinct access, and one contextual Substrate with explicit feeding and constraint witnesses. Silent or negative structures supply countermodels for the named consciousness, representational, World, and Substrate anti-entailments. The spike does not yet cover all derived terms, relation signatures, anti-collapse rules, quarantined vocabulary, or deterministic Markdown rendering. Those remain promotion gates rather than implicit Claims of completeness.
