---
type: ontology-proposal
status: promoted
binding: false
created: 2026-10-13
updated: 2026-10-13
---
# Set and Configuration

*Implemented in the v0.21 review branch; publication awaits merge. This dossier is nonbinding provenance. The working ontology, not this document, states the definitions.*

Set fixes membership. Configuration retains that member Set together with specified Relations and their ordered participant positions. Forgetting structure loses information: the same members support different Configurations. Local Lean contracts prove this distinction without claiming an empirical Relation classifier or a universal carrier of Presence.

## Correction and provenance

The initial implementation incorrectly made Configuration an alias of Set. Its reduction theorem followed from that alias and did not establish equivalence of the intended concepts. That implementation and its review remain in [the prior source](https://github.com/sadasant/organon/commit/02253239e5006eec9a869fa272a84acfb8f85f42) and [superseded review](../reviews/promotion/set-and-configuration.json). The present contracts replace SC-D2 and SC-C1; SC-D1 is unchanged. This correction follows [Daniel's clarification](https://ampcode.com/threads/T-01a12b1e-60b5-77bc-8215-5fcd15da8088), not a newly invented distinction to rescue the term.

## Termhood and intellectual shadows

**Set** names extensional membership already used in the metalanguage. It is not an irreducible primitive or a derivation of set theory from Absence. Listing order and multiplicity are discarded. The empty Set is Presence, not Absence. Membership can be modeled as a Relation, and a list can represent members; neither makes membership itself an ordered listing or establishes that every purported member exists.

**Configuration** is a relational structure, not its underlying member Set. The rejected reduction forgets specified associations and their participant positions. This matters to downstream State, Entity, Boundary and Model: inventories alone do not identify structured situations. An encoding of the complete structure as tagged Sets would preserve the extra data; it would not justify erasing it. Configuration is derived from Set and Relation, not an additional primitive.

The mathematical precedents are extensionality in set theory and relational structures in model theory. The local predicate encoding of Set follows type-theoretic practice. Organon claims neither precedent as original. Its application is to named Presences and Relations in one dependency-ordered vocabulary. General ordering, numerical measures, geometry, connectedness and a universal domain are not silently imported.

## Statements and dependency closure

| ID | Subject | Dependencies | Formal status |
|---|---|---|---|
| SC-D1 | Set / D121 | Presence, Identity, Absence (exclusion), Relation (contrast), Reality (exclusion) | proved with boundaries |
| SC-D2 | Configuration / D004 | SC-D1, Presence, Relation, Identity | proved for the supplied local interpretation |
| SC-C1 | Finite non-collapse witnesses | SC-D1, SC-D2 | proved locally |
| SC-G1 | Application and downstream parity | SC-D1, SC-D2 | open |

<!-- organon:proposal-statement SC-D1 type=proposed_definition -->
**Set** is a Presence fixed by the member Presences it contains within a declared local domain. Two Sets over that domain are identical exactly when every Presence in the domain is a member of one if and only if it is a member of the other. A Set orders no members and contains no member twice. The Set with no members is permitted; it is a Presence, not Absence. Declaring a Set asserts no universal carrier of Reality and no unrestricted comprehension. No local Set licenses identifying its members with Reality as a whole. Membership itself imposes no ordered association among members. This definition neither asserts nor denies that membership can be modeled as a Relation.

<!-- organon:proposal-statement SC-D2 type=proposed_definition -->
**Configuration** is a Set of Presences together with specified relational structure. The structure specifies Relations and their participants in ordered positions. Each selected Relation is itself a member or has at least one member as a participant; other participants need not be members. Selection cannot invent or rewire a Relation. Identity requires the same members and the same specified associations, including participant positions. Member and association listing order or repetition is irrelevant; participant positions within an association are not. The selected family may be empty. A Set has a Configuration with no selected associations, but membership alone does not determine every Configuration on that Set.

<!-- organon:proposal-statement SC-C1 type=anti_collapse_constraint -->
Finite witnesses establish equal Sets from reversed and repeated listings; equal underlying members but unequal Configurations; a valid ordered association whose reversal no Configuration may select under the same interpretation; a selected Relation with both participants outside the member Set; an unconnected member; and an empty member Set with empty structure. These are counterexamples to collapsing structure into membership, ignoring role order, requiring participant closure, requiring complete connectivity, or requiring nonemptiness. They are not an additional numbered binding constraint.

## Formal contracts

`SetConfiguration.lean` imports `OrganonCore`. Its local namespace exports `Set` and `Configuration` for the explorer. `Set α` has a membership predicate. `Configuration α realizes` has `members : Set α`, `associations : Set (α × List α)`, and a validity proof. An association pairs a Relation Presence with its ordered participant tuple. The supplied `realizes` predicate validates those participants; selection is not a license to choose arbitrary tuples. Every association has at least two positions and involves the member Set through its Relation or a participant.

The semantic-field ledger records `Set.contains`, a predicate-valued datum. `Configuration.valid` is instead a proof of the stated realization, arity and incidence conditions, not an additional supplied predicate. SC-D2's `proved` status concerns the represented local interpretation; SC-G1 retains the limits of that representation.

- **SC-D1 / `setExtensionality`:** Identity is membership equivalence, and the empty Set is uniquely fixed by having no members. This contract is unchanged.
- **SC-D2 / `configurationIdentity`:** Identity compares both member and association membership extensionally. The contract also exposes realization, arity and member-incidence obligations, and a discrete Configuration for every Set. Proof fields do not create extra identities.
- **SC-C1 / `finiteAntiCollapse`:** `plain` and `linked` have the same three members but different selected structure. The ambient interpretation contains only `link(ring, bar)`, so the reversed tuple is rejected for every valid Configuration. `external` selects that Relation while including only `link` as a member. `spare` is an unconnected member of `linked`. The empty discrete Configuration remains inhabited.

These statements use ordinary Lean extensionality and proof irrelevance, without `sorry`, `admit`, or project axioms. The finite witness uses decidable token equality; no empirical decision procedure follows.

## Boundaries and downstream compatibility

- **No exhaustive structure requirement:** the specified family is explicit. Omitting an association does not assert that it fails to obtain. A Relation can be a member without being selected as structural data.
- **No participant closure:** a Configuration of Constraints can include a Constraint and its association without making its participant States or Transformations members. No blanket nonemptiness condition breaks the empty-Boundary case; Body retains its separate constituent-nonemptiness requirement.
- **No mandatory connectivity:** members can be isolated. The triangular glyph illustrates one case, not three-member cardinality, a complete graph, or a binary-only ontology.
- **Fixed interpretation:** comparisons use the same domain and the same realized Relations. The local encoding uses finite participant lists. Canonical Relation does not acquire a finite-arity restriction from this shadow.
- **Downstream projection limit:** generic `State Carrier` and existing core records remain unchanged. They can use a structured Configuration carrier, but their compilation is not proof that every previous downstream witness represents the revised canonical structure. The new State witness checks that the existing wrapper can retain a structural difference.

<!-- organon:proposal-statement SC-G1 type=open_evidence_gate -->
An application must justify its member domain, member identity, and which actual Relations obtain with which ordered participants. `realizes` is supplied interpretation, not a truth oracle. Canonical infinite-arity Relations and full downstream prose/shadow parity remain outside the current finite-tuple shadow. These limits do not reopen the disproved identification of a Configuration with its underlying member Set.

## Sources and related entries

- Rodríguez, Daniel. [Set and Configuration review](https://ampcode.com/threads/T-01a12b1e-60b5-77bc-8215-5fcd15da8088), October 13, 2026.
- Zermelo, Ernst. “Untersuchungen über die Grundlagen der Mengenlehre I.” *Mathematische Annalen* 65 (1908): 261–281. Extensionality and separation.
- Hodges, Wilfrid. *A Shorter Model Theory*. Cambridge University Press, 1997. Relational signatures and structures; not a claim that Organon adopts the entire framework.
- [Lean extensionality](https://lean-lang.org/theorem_proving_in_lean4/axioms_and_computation.html), [formal contracts](../ontology/formal/SetConfiguration.lean), and [typed claims](./set-and-configuration-claims.json).
- [Binding Configuration](../ontology/ontology.md#organon-configuration), [registry](../ontology/terms.yaml), [v0.21 release](../releases/v0-21-0.md), and [current source review](../reviews/promotion/set-and-configuration-structured.json).
