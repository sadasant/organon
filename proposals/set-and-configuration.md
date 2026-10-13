---
type: ontology-proposal
status: promoted
binding: false
created: 2026-10-13
updated: 2026-10-13
---
# Set and Configuration

*Proposed October 13, 2026; implemented for the v0.21 PR. Nonbinding promotion dossier; the working ontology enacts the definitions, not this record. Publication awaits merge.*

Set names a Presence fixed by its member Presences within a declared local domain. Two Sets are identical exactly when they have the same members. Configuration keeps its existing wording, “a Set of Presences and Relations considered together,” and now depends on that explicit Set. It adds no membership condition. The formal contracts prove local-carrier extensionality, the reduction of Configuration to Set, and finite counterexamples. They do not supply a universal carrier of Reality, unrestricted comprehension, or a classifier of actual members.

## Contents

- [Problem and termhood](#problem-and-termhood)
- [Statements and dependency closure](#statements-and-dependency-closure)
- [Formal contracts and countermodels](#formal-contracts-and-countermodels)
- [Semantic boundaries](#semantic-boundaries)
- [Intellectual shadows](#intellectual-shadows)
- [Promotion and evidence](#promotion-and-evidence)
- [Sources](#sources)
- [Related entries](#related-entries)

## Problem and termhood

Configuration was defined as “a set of Presences and Relations considered together,” but “set” was not registered. Every Configuration-based definition, including State, Entity, Boundary, Model, Order, World, and Substrate, therefore relied on a collection notion the object language did not state. Readers could not tell whether a Configuration was ordered, could repeat members, could be empty, or had to contain the participants of its Relations.

**Set.** The strongest reduction is accepted: a Set is local extensional membership. It is a membership predicate over a declared domain, with identity fixed by membership alone. Registration does not claim an irreducible mechanism or a new kind of being. It names that predicate in the object language, so Configuration no longer borrows an unstated metalanguage notion. Rejected reductions are ordered lists, multisets, and mereological sums. Lists and multisets track order or multiplicity. A sum has no empty case. The finite witnesses show the first two failures. The third is a boundary claim, recorded with the shadows below.

**Configuration.** No distinction is invented. Configuration has the same membership condition, identity criterion, and permitted cases as Set, so it reduces extensionally to Set across the declared Scope. In Lean, `Configuration α` is an abbreviation for `Set α`. The retained name records the existing D004 identifier and its use as the role “Presences and Relations considered together” in later definitions. Under the collapse rule in [CONTRIBUTING](../CONTRIBUTING.md#2-challenge-termhood), this equivalence makes Configuration a consolidation candidate. This dossier does not decide whether the name and identifier should merge into Set. It does not certify that the retained role is a semantic distinction. That decision, together with identity criteria for application domains, remains open at SC-G1.

## Statements and dependency closure

| ID | Kind | Subject | Dependencies | Formal status |
|---|---|---|---|---|
| SC-D1 | proposed definition | Set | Presence, Identity, Absence (exclusion), Relation (contrast), Reality (exclusion) | proved with boundaries |
| SC-D2 | proposed definition revision | Configuration / D004 | SC-D1, Presence, Relation, Identity | proved with boundaries |
| SC-C1 | anti-collapse tests | Finite Set and Configuration witnesses | SC-D1, SC-D2 | proved for the stated local witnesses |
| SC-G1 | open gate | Carrier adequacy and Configuration consolidation | SC-D1, SC-D2 | open |

<!-- organon:proposal-statement SC-D1 type=proposed_definition -->
**Set** is a Presence fixed by the member Presences it contains within a declared local domain. Two Sets over that domain are identical exactly when every Presence in the domain is a member of one if and only if it is a member of the other. A Set orders no members and contains no member twice. The Set with no members is permitted; it is a Presence, not Absence. Declaring a Set asserts no universal carrier of Reality and no unrestricted comprehension. No local Set licenses identifying its members with Reality as a whole. Membership itself imposes no ordered association among members. This definition neither asserts nor denies that membership can be modeled as a Relation.

<!-- organon:proposal-statement SC-D2 type=proposed_definition -->
**Configuration** is a Set of Presences and Relations considered together. It adds no membership condition beyond Set. A Configuration may be empty or contain no Relation. Including a Relation does not require its participants to be members. Two Configurations are identical exactly when they have the same members.

<!-- organon:proposal-statement SC-C1 type=anti_collapse_constraint -->
In a finite token carrier, two lists with the same members in different orders fix one Set, though the lists differ. A list that repeats a member fixes the same Set as the list without repetition. The empty Configuration is identical to the empty Set and differs from a one-member Configuration. A Configuration containing only plain tokens contains no relation-like token. A Configuration containing a relation-like token can omit both of that token's designated participants. These are witnessed counterexamples to the stated reductions, not additional universal mechanisms or a new numbered binding constraint.

## Formal contracts and countermodels

`SetConfiguration.lean` imports only `OrganonCore` and declares its own namespace `DanielOntology.SetConfiguration`. `Set α` is a structure whose single field `contains : α → Prop` is supplied by whoever builds the Set; `Configuration α` is `abbrev Configuration α := Set α`. The generic `State` record and every existing core structure are unchanged. The module exports these Lean names for website mapping: `Set`, `Configuration`, `emptySet`, `ofList`, `setExt`, `setExtensionality`, `emptySetInhabited`, `ofListIdentity`, `configurationReduction`, `Token`, `participants`, `emptyConfiguration`, `ringOnly`, `linkOnly`, and `finiteAntiCollapse`.

- **SC-D1, `setExtensionality`:** for any carrier and Sets \(s, t\), \(\mathrm{Identity}(s,t) \Longleftrightarrow \forall a,\ s(a) \leftrightarrow t(a)\). The empty Set has no member, and a Set has no member exactly when it is identical to the empty Set. `emptySetInhabited` and `ofListIdentity` give the general empty witness and order- and repetition-insensitive finite listings.
- **SC-D2, `configurationReduction`:** `Configuration α = Set α` holds definitionally. Configuration identity is the same membership extensionality. Every Set is a Configuration, and an empty Configuration exists. No hypothesis about Relations, participants, or nonemptiness appears.
- **SC-C1, `finiteAntiCollapse`:** the carrier has `ring`, `bar`, and a relation-like `link` whose designated `participants` are `[ring, bar]`. The theorem proves each counterexample stated above. The trailing example derives the existence of a Configuration that contains a relation-like token without containing one of its participants.

Extensionality uses Lean's standard `propext` and `funext`, which comes from `Quot.sound`. No `Classical.choice`, `sorry`, `admit`, or project axiom is used. The finite witness derives `DecidableEq` only for its own tokens. The existing empty-Boundary theorem was not reused, because it concerns Constraint lists rather than Set membership; it would add a dependency, not evidence.

## Semantic boundaries

- **Empty Set versus Absence:** the empty Set is an inhabited value of `Set α` and a Presence fixed by having no member. It is not Absence, does not contain Absence, and is not a Missingness of any target.
- **No universal carrier:** every theorem quantifies over a supplied carrier. Lean's type-indexed `Set α` does not furnish a type of all Presence or a Set of everything. The proposal neither asserts nor denies that Reality could be described as a set. It asserts only that no local Set licenses identifying its members with Reality as a whole.
- **No unrestricted comprehension:** a Set is declared over its local domain. Nothing licenses forming a Set from an arbitrary condition over an undeclared totality.
- **Membership and Relation:** the definition does not claim that membership cannot be represented as a Relation. It claims only that being a member orders nothing and that a Set's identity depends on membership alone.
- **No endpoint closure:** including a Relation in a Configuration does not include its participants. A definition that needs participants must name them, as Denotation and later definitions already do.
- **Interpretation, not classification:** `contains`, the carrier, and the designation of relation-like tokens are supplied interpretation. No formal artifact here decides which actual Presences belong to a Set or are Relations.
- **Configuration-based definitions:** State, Entity, Boundary, and other definitions keep their own conditions. Reading Configuration as Set adds no order to them; any order they need comes from their own indices, such as State's metalanguage position or Persistence's ordered witness.

<!-- organon:proposal-statement SC-G1 type=open_evidence_gate -->
An application must justify its declared domain, membership assignment, Relation tokens, and identity criteria for its members; the proofs establish consequences once those choices are supplied, not their truth. Configuration is extensionally a Set. Whether its retained role name and the D004 identifier should be consolidated with Set, under the collapse rule and with the required migration record, remains an explicit open review question. This gate limits application and governance, not the proved local equivalences.

## Intellectual shadows

- **Extensionality** is inherited from set theory, where the axiom of extensionality fixes a set by its members. Organon contributes the local-domain restriction and the dependency order, not the principle.
- **Restricted comprehension** follows the lesson of Russell's paradox and Zermelo's separation: Sets are carved from a declared domain, not formed over everything. The proposal adopts no specific axiomatic set theory.
- **Type-theoretic sets:** representing a Set as a predicate on a carrier type follows the common Lean and Mathlib practice of treating `Set α` as `α → Prop`. The local structure is used to keep the Organon namespace and checker ledger self-contained.
- **Mereology:** a mereological sum has no empty case and identifies wholes by parts rather than members. The proposal does not adopt mereology and does not claim a Set is a whole composed of its members.

## Promotion and evidence

The smallest binding change is a Set definition registered after Relation and before Configuration, plus the D004 revision that capitalizes “Set” and records Set and Identity as dependencies. Set's dependencies on Absence and Reality record exclusions; its dependency on Relation records the contrast with ordered association. No other definition is reworded, and existing identifiers are not renumbered. The registry, ontology, profiles, provenance, changelog, adoption example, formal registration, and website must project that change.

Schema-v2 contracts record each dependency's formal disposition. A later exact-source review commit pins the implementation and reports adversarial findings. Passing checks mean local verification, not philosophical completeness.

## Sources

- Rodríguez, Daniel. *Daniel's Ontology*, v0.20 (2026): D004 Configuration as “a set of Presences and Relations considered together,” with “set” unregistered.
- Rodríguez, Daniel. [Approval of explicit Set before Configuration](https://ampcode.com/threads/T-01a12b1e-60b5-77bc-8215-5fcd15da8088) in the unpublished v0.21 pull request, October 13, 2026.
- Zermelo, Ernst. “Untersuchungen über die Grundlagen der Mengenlehre I.” *Mathematische Annalen* 65 (1908): 261–281. Extensionality and separation.
- Russell, Bertrand. *The Principles of Mathematics* (1903), chapter X: the contradiction motivating restricted comprehension.
- Lean community. *Theorem Proving in Lean 4*, “Axioms and Computation” (online manual): [propositional and functional extensionality](https://lean-lang.org/theorem_proving_in_lean4/axioms_and_computation.html).

## Related entries

- [Binding ontology](../ontology/ontology.md#organon-configuration) and [registry](../ontology/terms.yaml).
- [Core definitions](../ontology/formal/OrganonCore.lean) and [proofs and counterexamples](../ontology/formal/SetConfiguration.lean).
- [Typed claims](./set-and-configuration-claims.json) and [promotion review](../reviews/promotion/set-and-configuration.json).
- [Identity and exact-target Missingness](./identity-and-missingness.md), whose Identity this proposal uses.
- [v0.21 release note](../releases/v0-21-0.md).
