---
type: ontology-proposal
status: promoted
binding: false
created: 2026-10-12
updated: 2026-10-15
---
# Identity, Difference, and specified-target Missingness

*Proposed October 12, 2026; revised October 15, 2026 for explicit target conditions in the v0.21 PR. Nonbinding promotion dossier; the working ontology enacts the definitions, not this record. Publication awaits merge.*

Identity names logical equality restricted to Presence, making Difference's existing non-identity test explicit. Missingness names either a particular represented or expected Presence or an explicitly specified target condition, and excludes every contained match. The October 15 extension retains the exact-target case without reducing a class expectation to an arbitrary representative. It does not derive expectation from an empty field, decide empirical identity, or turn Absence into a participant. Its formal contracts prove local-carrier equivalences and counterexamples, not a universal model of Reality.

## Contents

- [Problem and termhood](#problem-and-termhood)
- [Statements and dependency closure](#statements-and-dependency-closure)
- [Formal contracts and countermodels](#formal-contracts-and-countermodels)
- [Semantic boundaries](#semantic-boundaries)
- [Promotion and evidence](#promotion-and-evidence)
- [Sources](#sources)
- [Related entries](#related-entries)

## Problem and termhood

Difference already used non-identity, and the closure boundary explicitly supplied logical identity. There was no hidden logical primitive to discover. The gap was in the registered vocabulary: readers could name non-equality inside Presence but not its exact counterpart without returning to the metalanguage. Missingness also left its exact target comparison implicit.

The strongest reduction is accepted, not concealed: Identity is equality, restricted to Presence. It is not an irreducible mechanism, a second logical equality, or a new kind of being. Registration names the domain-restricted predicate and excludes likeness, observation-relative indistinguishability, and equivalence under a lossy projection. Those restrictions survive reduction to an arbitrary similarity or shared-property predicate, but not reduction to logical equality on the correctly specified carrier. This is the same explicit internal vocabulary role already served by Difference, not a claim that symmetry alone proves new ontological content.

Identity is a condition on comparison positions, not a new Relation structure. Thus it introduces no circular dependency on Relation or Entity, and does not require a comparison event to occur. The ordinary ordered configurations used at this early boundary are metalinguistic, as they already were for Difference; they do not invoke the later registered Configuration definition. Logical equality remains available in the metalanguage before Presence is defined.

## Statements and dependency closure

| ID | Kind | Subject | Dependencies | Formal status |
|---|---|---|---|---|
| IM-D1 | proposed definition | Identity / D120 | Absence (exclusion), Presence | proved with boundaries |
| IM-D2 | proposed definition revision | Difference / D002 | Absence (exclusion), Presence, IM-D1, Reality | proved with boundaries |
| IM-A5 | proposed axiom clarification | Missingness / A5 | Absence (exclusion), Presence, IM-D1 | proved with boundaries |
| IM-C1 | anti-collapse tests | Exact identity and specified targets | IM-D1, IM-D2, IM-A5 | proved for the stated local witnesses |
| IM-A6 | proposed extension of A5 | Explicit target conditions | Absence (exclusion), Presence, IM-D1, IM-A5 | proved with boundaries |
| IM-C2 | anti-collapse tests | Particular target versus qualifying target | IM-D1, IM-A6 | proved for the stated local witnesses |
| IM-G1 | open evidence gate | Application to actual fields and participants | IM-D1, IM-D2, IM-A5, IM-A6 | open |

<!-- organon:proposal-statement IM-D1 type=proposed_definition -->
**Identity** obtains when two compared items are one and the same Presence, or one and the same ordered configuration of Presence. It is reflexive, symmetric, transitive and substitutive, not similarity under selected properties. This definition's use of equality does not claim to construct logical equality from other terms.

<!-- organon:proposal-statement IM-D2 type=proposed_definition -->
**Difference** is failure of Identity for the same compared Presences or ordered configurations. Equality and non-equality are classically exclusive and exhaustive. Neither observation nor a decision procedure follows. The Absence/Presence contrast remains metalinguistic, not a Difference involving Absence as a participant.

<!-- organon:proposal-statement IM-A5 type=proposed_definition -->
The **particular-target case of Missingness** is a relation within Presence in which a field represents or expects a specified Presence but contains nothing identical to that Presence. The representation or expectation assignment remains a separate requirement; noncontainment is not its evidence. The existing generic Lean `Missingness` record is preserved as this special case, with a theorem establishing the identity-based reformulation of its containment field.

<!-- organon:proposal-statement IM-C1 type=anti_collapse_constraint -->
In a finite token carrier, equal appearance need not be Identity; a nonempty field containing a lookalike can still omit the exact target; containing that target rules out its Missingness; changing the expected target can reverse the result. An empty field admits different missing targets and does not select its own expectation. Equal unordered membership does not imply Identity of ordered lists or pairs. These are witnessed counterexamples to those reductions, not additional universal mechanisms or a new numbered binding constraint.

<!-- organon:proposal-statement IM-A6 type=proposed_definition -->
**Target-condition Missingness** requires a separately represented or expected predicate and no contained satisfier. The particular-target case is the predicate of Identity with that target. Requiring the absence of one representative is too weak: another qualifying item can fulfill the class expectation. No decidability, nonempty class, empirical expectation or existence of a fictional referent follows from supplying a predicate. This extends A5, not the list of binding axioms.

<!-- organon:proposal-statement IM-C2 type=anti_collapse_constraint -->
A field containing the other ring-shaped token lacks the particular target but does not lack a ring-shaped token. The same field lacks a bar-shaped token. A nonempty field containing only a bar-shaped token lacks a ring-shaped token; an empty field does too. A field containing the exact target does not lack that target. Thus particular and qualifying expectations differ, and neither field emptiness nor one arbitrary representative defines the condition case.

## Formal contracts and countermodels

In `OrganonCore.lean`, `Identity a b` is `a = b`; `Difference a b` is its negation. Both are predicates over a supplied carrier, which may be a carrier of items or an ordered configuration type. They import no Absence-extension symbol. `IdentityMissingness.lean` is compiled by the default finite-model target.

The exact Missingness contract proves, for the same field and expected value:

\[
\neg f(p)\;\Longleftrightarrow\;\neg\exists x,\; f(x)\land x=p.
\]

It also proves this condition equivalent to inhabiting the existing Missingness record with those exact indices. Its converse uses the expected value itself, so the argument does not merely say that a Missingness instance implies noncontainment. Existing record constructors and preservation contracts keep their signatures.

For a supplied condition \(q\), `conditionMissing f q` is \(\neg\exists x, f(x)\land q(x)\). IM-A6 proves equivalence to every contained item failing the condition and proves that \(q(x) = (x=p)\) recovers the existing exact-target record. IM-C2 tests both sides of fulfillment, including a nonempty wrong-class field and a different qualifying item. These contracts address noncontainment, not the provenance of an expectation.

The witness carrier has two tokens with identical appearance and distinct serials. The serials are local mathematical individuation, not a claim that equal serials certify real objects. Tests compare a field containing only the wrong token, a field containing the target, and an empty field. Both target choices are exercised. Reversing an asymmetric two-item list or pair changes Identity despite unchanged unordered membership.

Reflexivity, symmetry, transitivity and substitution are proved generally. The exclusive partition uses classical excluded middle but supplies no computable equality test. Failure to prove equality is not a proof of inequality. The finite witnesses use decidable equality only for their finite comparisons; general theorems do not impose it on arbitrary carriers.

## Semantic boundaries

- **Identity versus Persistence:** Identity of an Entity does not assert equality of its successive States. A named reidentification criterion, Invariant and Persistence witness remain necessary. Sharing an Invariant does not individuate two Entities. The formal tests do not repair the existing model's known gap between an arbitrary preservation property and canonical numerical Entity identity.
- **Specific item versus class:** “this key” and “any compatible key” are different expectations, both now covered. An arbitrary class representative is not a substitute for the latter. The general carrier must be chosen so its elements, equality and qualifying predicate match the actual target condition; quotienting away distinctions changes the question.
- **Fictional referents:** a description is Presence, but that does not instantiate its referent. Neither the prose nor the local Lean value licenses deriving the existence of a fictional object from its expectation. A theory of descriptions of nonexistent or merely possible targets is not introduced here.
- **Expectation is not membership:** the Lean record supplies an `expected` value and the generalized predicate takes a supplied condition, but neither proves that an actual field represents or expects it. This remains an application premise. A mathematical instance is not evidence that an arbitrary physical field has that expectation.
- **Absence is excluded:** all local values are interpreted within Presence. The exactness of Absence is still stated with logical identity in the metalanguage; no new Identity, Difference or Missingness participant is introduced for Absence.
- **No global universe:** Lean's carrier-indexed equality does not furnish a complete type of all Presence or identify Reality with a local type. Model equality is not an empirical individuation procedure.

<!-- organon:proposal-statement IM-G1 type=open_evidence_gate -->
An application must independently justify its carrier, actual individuation, containment and represented/expected target. Those choices require the relevant observations and evidence of the application; the present proofs establish consequences once the choices are supplied, not their truth. These gates limit empirical realization, not the proved local equivalences.

## Promotion and evidence

The smallest binding change is D120 plus explicit joins in A5 and D002, with a clarification at D014 distinguishing Identity from same-State equality and shared Invariants. Existing identifiers are not renumbered. The registry is dependency-ordered with Identity immediately after Presence; Absence dependencies in the revised entries record exclusions, not ontological links. The prompt, provenance, profiles, adoption example, formal audit, algebra accounting and website must project that registry.

Schema-v2 contracts record each dependency's formal disposition; the later exact-source review commit pins the implementation and reports adversarial findings. Passing checks mean local verification, not philosophical completeness. Glyph choices remain nonbinding and are reviewed after the definitions. Published private-use slots must not move when Identity is inserted into canonical order.

## Sources

- Rodríguez, Daniel. *Daniel's Ontology*, v0.20 (2026): closure boundary, A5, D002 and D014. The predecessor already supplied logical identity explicitly.
- Rodríguez, Daniel. [Identity and Missingness review conversation](https://ampcode.com/threads/T-01a12b1e-60b5-77bc-8215-5fcd15da8088), October 12, 2026: approval of explicit Identity and exact-target Missingness.
- The same review conversation, October 15, 2026: Daniel selected explicit target-condition Missingness, retaining the exact-target case and requiring the condition rather than an arbitrary representative.
- Lean community. *Theorem Proving in Lean 4*, “Quantifiers and Equality” (online manual): [logical equality and substitution](https://lean-lang.org/theorem_proving_in_lean4/quantifiers_and_equality.html). These logical laws are inherited, not Organon inventions.

## Related entries

- [Binding ontology](../ontology/ontology.md#organon-identity) and [registry](../ontology/terms.yaml).
- [Core definitions](../ontology/formal/OrganonCore.lean) and [proofs and counterexamples](../ontology/formal/IdentityMissingness.lean).
- [Typed claims](./identity-and-missingness-claims.json) and [current target-condition review](../reviews/promotion/identity-condition-targets.json). The [original review](../reviews/promotion/identity-and-missingness.json), [Configuration correction](../reviews/promotion/identity-structured-configuration.json), and [State clarification review](../reviews/promotion/identity-state-clarification.json) remain historical evidence.
- [v0.21 release note](../releases/v0-21-0.md) and [glyph study](./glyph-atlas.md).
