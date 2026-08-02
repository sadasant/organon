---
type: formalization-decisions
status: noncanonical
created: 2026-08-02
updated: 2026-08-02
prose_ontology: "../Daniels-Ontology.md"
---
# Formalization Decisions

These decisions belong to the Lean spike. They expose choices priced by formalization. They do not independently revise [Daniel's Ontology v0.8](../Daniels-Ontology.md); accepted findings flow into the binding Markdown through its changelog.

## Absence is not `Empty`

`Absent α := α → False` is a local shadow inside Lean's already-present metatheory. It proves that a type has no inhabitants. It is not absolute Absence, which cannot become an object inside a formal system without contradicting its definition.

## Presence is type-relative

`Present α := Nonempty α` says that a particular type has an inhabitant. It does not yet encode Reality as the totality of every Presence.

## A3 currently commits to classical logic

Exclusivity is constructive. Exhaustiveness for an arbitrary type requires excluded middle in this encoding. The declaration makes that commitment locally visible with `classical`, and v0.8 now names classical logic in the binding metalanguage rather than presenting A3 as neutral.

## A4 has two evidence levels

`presenceObtains` is an object-level witness: the declared `Mark` has an inhabitant. Successful compilation is metatheoretic Evidence that the source file occurred and elaborated. Compilation does not turn the compiler into an object-level premise.

## A5 represents Missingness positively

`Missingness α` contains a Field, an expected inhabitant, and proof that the Field omits it. A value of this structure is itself present. Missingness therefore cannot collapse into the uninhabited-type predicate used as Absence's local shadow.

## Direction internalizes ordering

`State` is the object-level carrier used by all later machinery and has no numeric index. Declaration order remains metalinguistic. `Direction.before` is the first-class asymmetric Relation, and `Transformation direction` carries that Direction as a type parameter. A `CausalPath direction` therefore shares one Direction without requiring equality between Prop-valued functions.

## Specification carries constructive content

Classical `conforms x ∨ ¬ conforms x` is available for every predicate and therefore cannot distinguish a Specification. `Specification.decidableConformity : DecidablePred conforms` instead carries constructive decision evidence. It does not imply that an Agent has performed a test.

## Identity remains parameterized

An Entity supplies an identity Invariant, and its Boundary proves that admitted Transformations preserve that Invariant. Lean checks the dependency and preservation proof. It does not choose which Invariant genuinely constitutes an Entity's identity.

## Empty Boundary means maximal obligation

Boundary Constraints are conjunctive admission conditions. An empty list admits every Transformation, so the preservation proof must establish the identity Invariant for every Transformation. The theorem `emptyBoundaryRequiresUniversalPreservation` exposes this consequence. Constraint-poverty is maximal obligation, not proof-free openness.

## Permission does not imply Capability

`Permission` contains no Capability field. A Principal may authorize Actions that an Agent cannot currently perform. `ExercisablePermission` separately pairs Permission with Capability and proves that every scoped Action is technically available. This prevents the institutional layer from collapsing into the mechanical one in either direction.

## Relations use typed structures, not one universal relation type

Direction, Transformation, Boundary, Capability, and Permission have different arities and dependencies. The spike encodes each with the narrowest useful record. A later parity pass must decide whether the ontology benefits from a common first-class Relation interface or whether that abstraction would erase important types.

## Scope of the spike

The spike formalizes A1-A5 and selected high-risk dependency regions. Its finite model constructs one concrete Entity and one Permission over a toy Agent, plus a separately coherent ExercisablePermission. It does not yet cover all derived terms, relation signatures, anti-collapse rules, quarantined vocabulary, or deterministic Markdown rendering. Those remain promotion gates rather than implicit Claims of completeness.
