---
type: formalization-decisions
status: noncanonical
created: 2026-08-02
updated: 2026-08-02
prose_ontology: "[[Contexts/Organon/Daniels-Ontology]]"
---
# Formalization Decisions

These decisions belong to the Lean spike. They expose choices that the binding Markdown ontology does not yet need to settle. They do not revise [[Contexts/Organon/Daniels-Ontology|Daniel's Ontology v0.7]].

## Absence is not `Empty`

`Absent α := α → False` is a local shadow inside Lean's already-present metatheory. It proves that a type has no inhabitants. It is not absolute Absence, which cannot become an object inside a formal system without contradicting its definition.

## Presence is type-relative

`Present α := Nonempty α` says that a particular type has an inhabitant. It does not yet encode Reality as the totality of every Presence.

## A3 currently commits to classical logic

Exclusivity is constructive. Exhaustiveness for an arbitrary type requires excluded middle in this encoding. The declaration makes that commitment locally visible with `classical`.

## A4 has two evidence levels

`presenceObtains` is an object-level witness: the declared `Mark` has an inhabitant. Successful compilation is metatheoretic Evidence that the source file occurred and elaborated. Compilation does not turn the compiler into an object-level premise.

## A5 represents Missingness positively

`Missingness α` contains a Field, an expected inhabitant, and proof that the Field omits it. A value of this structure is itself present. Missingness therefore cannot collapse into the uninhabited-type predicate used as Absence's local shadow.

## Direction internalizes ordering

`State.index` is a metalinguistic position. `Direction.before` is a first-class asymmetric relation. A Transformation must carry evidence that its input and output are related by its Direction; numerical index order alone creates no ontological Direction.

## Identity remains parameterized

An Entity supplies an identity Invariant, and its Boundary proves that admitted Transformations preserve that Invariant. Lean checks the dependency and preservation proof. It does not choose which Invariant genuinely constitutes an Entity's identity.

## Relations use typed structures, not one universal relation type

Direction, Transformation, Boundary, Capability, and Permission have different arities and dependencies. The spike encodes each with the narrowest useful record. A later parity pass must decide whether the ontology benefits from a common first-class Relation interface or whether that abstraction would erase important types.

## Scope of the spike

The spike formalizes A1-A5 and selected high-risk dependency regions. It does not yet cover all derived terms, relation signatures, anti-collapse rules, quarantined vocabulary, or deterministic Markdown rendering. Those remain promotion gates rather than implicit Claims of completeness.
