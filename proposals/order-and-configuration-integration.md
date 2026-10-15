---
type: ontology-proposal
status: promoted
binding: false
created: 2026-10-13
updated: 2026-10-13
---
# Order and Configuration integration

*Implemented in the v0.21 review branch; publication awaits merge. This dossier is nonbinding provenance. The working ontology, not this document, states the definitions.*

This change registers **Order** (D122, `organon:MathematicalOrder`) as a Set with a reflexive, antisymmetric and transitive binary relation on its members. The legacy institutional term keeps its stable identifier `organon:Order` (D046) under the label **Coordination Order**. The change also puts structured Configuration to work in State, Entity, Boundary and Model. Typed Lean contracts prove Order Identity, the strict-order laws, and finite counterexamples. They also prove indexed State Identity, the retained structure of a configured Boundary, one Entity witness across unequal structured States, and a Structured Model in one concrete pipeline. None of these is an empirical classifier. Perception and Memory parity and empirical individuation remain open.

The v0.21 review couples the foundational definitions with their glyph-explorer presentation. Choosing Set's three dots required distinguishing membership from Configuration's selected Relations; State then had to retain that structure and its index. Separating mathematical Order from Coordination Order required label-aware navigation without reassigning existing identifiers or font slots. The same review treats Absence separately from Presence in the graph: no luminous node or sky for Absence, and a canonical-position density cue for navigation through the remaining terms. The CSS fallback follows that cue when WebGL is unavailable. These are presentation choices, not extra ontological premises. The dossiers, contracts and generated projections record the definition changes behind the drawings; they do not turn a glyph choice into a proof.

## Contents

- [Problem and termhood](#problem-and-termhood)
- [Migration of identifiers](#migration-of-identifiers)
- [Partial, strict and total order](#partial-strict-and-total-order)
- [Statements and dependency closure](#statements-and-dependency-closure)
- [Formal contracts](#formal-contracts)
- [Downstream integration and its limits](#downstream-integration-and-its-limits)
- [Forbidden collapses](#forbidden-collapses)
- [Open gate](#open-gate)
- [Aesthetics findings and adjudication](#aesthetics-findings-and-adjudication)
- [Sources and related entries](#sources-and-related-entries)

## Problem and termhood

Two readings had shared the word "Order". The registered term D046 named a persistent Configuration through which Agents coordinate Action. Elsewhere the text used "order" in its mathematical sense: indexing positions, sequences of States, and Direction. Neither reading could be checked against the other, and a reader could import transitivity or totality into Direction, or rank into institutional Order, without noticing.

**Order** is derived mathematical structure in the same sense as Set. It is not an irreducible primitive. It names an extensional construction over member Presences: a member Set and an extension of ordered pairs of members. The relation is metalinguistic. Its extension fixes it. It is not a new definition of the registered Relation and does not require each ordered pair to be realized as a Relation. It does not classify which actual Presences precede, contain or outrank others, and it supplies no time, causation, rank or indexing order of the metalanguage. The registry records its dependencies as exactly Set, Identity, Relation and Presence.

**Coordination Order** keeps D046's definition and identifier. The new label marks that it is not an Order in the mathematical sense. Its member Set is its inventory of Constraints, Records, Interfaces, Rules and recurring Relations, and its coordinating structure is named separately. The institutional kernel's Order index (Standing, Recognition, Permission and the rest) refers to Coordination Order throughout.

The integration revisions follow from Set and Configuration ([dossier](./set-and-configuration.md)). Once Configuration retains selected structure beyond its members, records built on Configuration must keep that structure too. Otherwise equal inventories would silently identify different situations.

## Migration of identifiers

| Stable identifier | Claim | Label before | Label after | Change |
|---|---|---|---|---|
| `organon:Order` | D046 | Order | Coordination Order | Definition and identifier preserved; adds Set and `organon:MathematicalOrder` dependencies; inventory and coordinating structure separated |
| `organon:MathematicalOrder` | D122 | — (new) | Order | New derived definition; dependencies Set, Identity, Relation, Presence |
| `organon:Direction` | D006 | Direction | Direction | Adds `organon:MathematicalOrder` dependency; asymmetry is stated not to be a strict Order |
| `organon:Persistence` | D012 | Persistence | Persistence | Reading of "persistent Configuration" as indexed Configurations joined by a named Invariant |
| `organon:Entity` | D014 | Entity | Entity | A Presence reidentified across indexed Configurations, not one of them |
| `organon:Boundary` | D015 | Boundary | Boundary | Members are Constraints; specified structure identified separately |
| `organon:Model` | D031 | Model | Model | Requires a named join between a member Representation and a member Transformation |

Adoption manifests that bind `organon:Order` keep binding the same definition. A repository that wants the mathematical term must bind `organon:MathematicalOrder` explicitly. The bare label "Order" now resolves to D122.

## Partial, strict and total order

An **Order** (partial order) is reflexive, antisymmetric and transitive on its members. Its **strict part** relates *a* to *b* when *a* ≤ *b* and they differ. The strict part is irreflexive, asymmetric and transitive. Conversely, every member-bounded irreflexive and transitive relation is the strict part of an Order on the same members, its reflexive closure on members. **Total comparability**, where every two members are comparable, is a separate property. A total order (chain) is an Order with that property proved. It is never assumed.

Direction is weaker than all three. Core Direction requires only that its `before` relation be asymmetric. It is not required to be transitive, so a Direction need not be the strict part of any Order. OC-C1 proves this with a directed 3-cycle that is asymmetric but not transitive. Nothing here makes every Direction transitive, total, or aligned with the metalanguage's indexing order.

## Statements and dependency closure

| ID | Subject | Dependencies | Formal status |
|---|---|---|---|
| OC-D1 | Order / D122 | Set, Identity, Relation (contrast), Presence | proved with boundaries |
| OC-C1 | Finite Order and Direction countermodels | OC-D1, Direction | proved locally |
| OC-D2 | Indexed structured State / D005 | Configuration, Identity, Difference, Relation (prose) | proved with boundaries |
| OC-D3 | Entity over structured States / D014 | Presence (prose), Identity, Configuration, State, Persistence, Invariant | proved with boundaries |
| OC-D4 | Configured Boundary / D015 | Configuration, Constraint, Invariant, Persistence (prose), Entity, Relation (prose) | proved with boundaries |
| OC-D5 | Structured Model / D031 | Configuration, Representation, Transformation, Perception and Memory (outside), State (prose), Constraint, Relation | proved with boundaries |
| OC-C2 | State and Boundary witnesses | OC-D2, OC-D4 | proved locally |
| OC-C3 | One Entity witness across States | OC-D2, OC-D3, OC-D4, Presence (prose) | proved with boundaries |
| OC-C4 | Model in a concrete pipeline | OC-D5, OC-C3, Perception and Memory (prose) | proved with boundaries |
| OC-C5 | Coordination Order is not Order | OC-D1, Order (D046) | outside formal boundary |
| OC-G1 | Application adequacy and parity | OC-D1 to OC-D5 | open |

<!-- organon:proposal-statement OC-D1 type=proposed_definition -->
**Order** is a Set together with a reflexive, antisymmetric and transitive binary relation on its members. The relation is a metalinguistic extension of ordered pairs of members. It neither defines the registered Relation nor requires each pair to be realized as one. Two Orders have Identity exactly when they have the same members and the same extension. The strict part relates two different members when the first is related to the second. It is irreflexive, asymmetric and transitive, and on members the relation is recovered as strict-or-Identity. Every member-bounded irreflexive transitive relation is the strict part of an Order on the same members. Total comparability is equivalent to strict trichotomy on members and is not part of Order. An Order may have no members, and two members may be incomparable.

<!-- organon:proposal-statement OC-C1 type=anti_collapse_constraint -->
Finite witnesses establish: a strict chain bottom < middle < top with an incomparable member, so a partial Order need not be total; a carrier value outside the member Set that is related to nothing; the same chain without the incomparable member, which is total and has the same strict part; a Direction on three States whose `before` is a directed cycle, asymmetric but not transitive, which is the strict part of no Order; and an empty member Set, including on the empty carrier, that carries an Order and is vacuously total. These counterexamples block reading Order as total, Direction as a strict Order, or an empty Order as Absence.

<!-- organon:proposal-statement OC-D2 type=proposed_definition -->
A **State** is a Configuration indexed at a position. Two States have Identity exactly when they have the same index, the same members and the same selected associations. At one index, State Identity is Configuration Identity. A selected association present in one Configuration and missing from the other separates the States at one index, whatever their members. One Configuration at two different indices gives two States. Placing a Configuration at an index adds no selected association.

<!-- organon:proposal-statement OC-D3 type=proposed_definition -->
An **Entity** claim names an identity Invariant, an ordered history of States and a Persistence witness preserving that Invariant. Each history State satisfies the Invariant, and the history is ordered by the claim's Direction. Every such claim over indexed structured Configurations has two history States, the first before the second, that do not agree in both index and Configuration. The Entity is the Presence reidentified through that witness. It is neither the witness record nor any one snapshot Configuration, and record equality does not decide its empirical individuation.

<!-- organon:proposal-statement OC-D4 type=proposed_definition -->
A **Boundary** retained as a Configuration of Constraints has members that are each interpreted as a Constraint. Its selected associations may have participants that are neither members nor Constraints. Every Transformation permitted by all member Constraints preserves the identity Invariant. For an Entity whose core Boundary is projected from such a Configuration, the core Constraints are exactly the interpreted members. The projection depends only on the Constraint interpretation and the finite listing of members. It therefore cannot see selected structure.

<!-- organon:proposal-statement OC-D5 type=proposed_definition -->
A **Model** is an organized Configuration whose members are each interpreted as a Representation (through a Denotation whose expression is that member) or as a Transformation. It retains at least one selected join association between a member Representation and a member Transformation, and its stated Constraints all permit the joined Transformation. A discrete Configuration, with no selected structure, never carries a Model.

<!-- organon:proposal-statement OC-C2 type=anti_collapse_constraint -->
Finite witnesses establish: unlinked and linked Configurations at the same index have equal members and are different States; one linked Configuration at indices 0 and 1 gives different States; and two configured Boundaries with the same guard members and interpretation are different, because only one selects a coupling association with an external non-Constraint participant. They nonetheless project to the same core Constraint list. Inventory does not identify State, and the core Boundary is a lossy projection.

<!-- organon:proposal-statement OC-C3 type=anti_collapse_constraint -->
One Entity witness has the history unlinked-at-0 then linked-at-1, ordered by its Direction. Both States satisfy its inventory Invariant, and they differ in both index and Configuration while sharing members. A third State, unlinked at index 5, satisfies the same Invariant but is not in the history: satisfying the Invariant does not place a State in an Entity's history. The witness's core Boundary is the projection of the coupled configured Boundary and has the same Constraints as the uncoupled one.

<!-- organon:proposal-statement OC-C4 type=anti_collapse_constraint -->
In one concrete cognitive pipeline, the constructed Model is the Structured Model whose sketch denotes the linked State at index 1 and whose linking member is the link-forming Transformation. The Model retains its selected join. Its joined Transformation starts at the perceived State and ends at the linked State, which is also the pipeline's Interpretation. Its stated Constraints permit that Transformation and coincide with the Entity witness's core Boundary Constraints. Perceived and remembered inputs are the same supplied State, and the Model's Configuration is not discrete.

<!-- organon:proposal-statement OC-C5 type=anti_collapse_constraint -->
Coordination Order (D046) is not an Order. Its label names coordination through a persistent structured Configuration, not a reflexive, antisymmetric and transitive relation on members. An institutional "Order" index does not supply ranking, transitivity or totality, and mathematical Order does not supply institutional coordination.

## Formal contracts

`OrderConfigurationContracts.lean` imports `MathematicalOrder` and `ConfigurationIntegration`. It plays the role `PromotionContracts.lean` plays for embodied consciousness. Each theorem restates one exact proposition that the underlying modules already establish, so CI fails if those modules drift. The `OC-*` markers are new; the module-local `MO-D1`, `MO-C1`, `CI-D1`, `CI-C1` and `CI-C2` markers are not reused as statement IDs.

- **OC-D1 / `orderDefinitionContract`:** for every `o p : MemberOrder α`, `Identity o p` holds exactly when members and `relation` agree pointwise. For every Order, it states boundedness, reflexivity on members, antisymmetry, transitivity, `strict` as relation plus `Difference`, strict irreflexivity, asymmetry and transitivity, strict-or-Identity recovery, and `Total` iff strict trichotomy. Every member-bounded irreflexive transitive `lt` is the `strict` part of some Order with the same members. Identity is proved directly through `memberOrderExt` (Set extensionality, relation extensionality, proof irrelevance), independent of any later general identity lemma in `MathematicalOrder`.
- **OC-C1 / `orderCountermodelContract`:** `chainWithSide` has a strict three-step chain, `Incomparable side middle`, `¬ Total`, and a non-member `outside` related to nothing. `chainOnly` is `Total`, excludes `side`, and has the same `strict` part. `cycleDirection` is asymmetric, with first→second, second→third and third→first but not first→third, and no `MemberOrder` has it as its strict part. `emptyOrder` on `Empty` has no members and is `Total`; on every carrier it has no members and relates nothing.
- **OC-D2 / `indexedStateContract`:** for `s t : ConfigState Index α realizes`, Identity is index, member and association agreement. It also states same-index Identity as Configuration Identity, association separation at one index, index separation of one Configuration, `indexAddsNoAssociation`, and that `atIndex` is recovered by `indexOf` and `configurationOf`.
- **OC-D3 / `entityPresenceContract`:** for every `entity : Entity (IndexedConfiguration Index α realizes)`, the Persistence witness names the identity Invariant, the history is `OrderedBy` the claim's Direction, every history State satisfies the Invariant, the current State is in the history, and there are `first` before `second` in the history that do not agree in both index and Configuration.
- **OC-D4 / `configuredBoundaryContract`:** for every `ConfiguredEntity`, its core Boundary equals the projection, members are interpreted Constraints, the core Constraints are exactly the interpreted members, and member-permitted Transformations preserve the identity Invariant. For any two configured Boundaries with equal interpretation and equal listing items, the projected core Constraint lists are equal, whatever their selected associations.
- **OC-D5 / `structuredModelContract`:** every `StructuredModel` has organized members, retains its selected join, has both joined positions as members, a Denotation whose expression is the Representation member, a realized joined Transformation permitted by every stated Constraint, and a Configuration different from every `discrete` one.
- **OC-C2 / `stateBoundaryWitnessContract`:** `plainAt 0` and `linkedAt 0` share members and index and differ; `linkedAt 0` and `linkedAt 1` share a Configuration and differ. `coupledBoundary` and `looseBoundary` share members and interpretation, only the first selects `coupling(membersGuard, medium)`, `medium` is neither a member nor a Constraint, the two differ, and under `guardListing` both project to `[membersGuard, linkGuard]`.
- **OC-C3 / `entityWitnessContract`:** `linkEntity`'s history is exactly `[plainAt 0, linkedAt 1]`, ordered by its Direction. Its current State is `linkedAt 1`. Both States satisfy its Invariant and differ in index and Configuration with equal members. `plainAt 5` satisfies the Invariant and is not in the history. Its core Boundary is `coupledBoundary`'s projection and has `looseBoundary`'s projected Constraints.
- **OC-C4 / `pipelineModelWitnessContract`:** `structuredPipeline.modelFor ()` is `linkModel`, retains `joins(sketch, linking)`, and has joined Transformation `linkFormation` from the perceived State to `linkedAt 1`. Its Denotation target and `interpretationFor ()` are `linkedAt 1`, and its Constraints are `[membersGuard, linkGuard]`, permit the joined Transformation, and equal `linkEntity`'s core Boundary Constraints. `perceive ()` equals `remember ()`, and the Model's Configuration is not discrete.

The semantic-field ledger for the formal shadow `MathematicalOrder.lean` records `MemberOrder.relation`, its one predicate-valued field. The law fields are proofs, not additional supplied predicates. OC-D1 inherits `Classical.em` from strict-or-Identity recovery; the remaining contracts use at most `propext` and `Quot.sound`. No `sorry`, `admit` or project axiom is used. Formal evidence also includes `ConfigurationIntegration.lean`, `SetConfiguration.lean`, `OrganonCore.lean`, `IntelligenceKnowledge.lean` (the generic `CognitivePipeline`) and `EmbodiedConsciousness.lean`, whose `PerspectiveModel` remains the explorer's primary Model mapping in `examples/glyph-explorer/lean-math.json`; `StructuredModel` is recorded there only as support.

## Downstream integration and its limits

**State.** The generic `State Carrier` is unchanged. `ConfigState` instantiates it at a pair of an index and a structured Configuration. The index is any supplied type: its ordering is not represented, and the claim that the position adds no Relation to Reality is prose. The witness Direction `formation` depends only on Configuration content and does not duplicate the index order.

**Entity Presence versus its record.** The revised definition makes an Entity a Presence reidentified across ordered States, not a Configuration. The Lean `Entity` value is the witness bundle of an Entity claim: its Invariant, Boundary, Direction, Persistence witness and current State. It is a record of the claim, and its history States are snapshots. Neither is the Entity. Record equality is not an identity criterion for actual Presences, and the definition adds no new sufficient condition for Entity identity. The empirical individuation gate stays open: the Invariant must distinguish the particular Entity, and OC-C3 shows that merely satisfying it does not admit a State to the history. The witness's inventory Invariant is a local test criterion, not a model of how any real Entity is individuated.

**Boundary.** `ConfiguredBoundary` retains the Constraint Configuration and its preservation obligation. The older core `Boundary` is reached by an explicit finite listing and forgets selected structure. Lists encode only finite Boundaries for that projection, the configured Boundary itself need not be finite, and the core `Constraint` remains a predicate on Transformations rather than a typed persistent Relation. Persistence across an ordered history is not quantified by the Boundary contract.

**Model.** `StructuredModel` retains its join and supplied Constraints. It feeds the unchanged `CognitivePipeline` as its `Model` parameter in one concrete pipeline. In that pipeline, Perception and Memory are the same constant supplied State. The Model's Constraint list is supplied data that happens to match the Entity witness's Boundary Constraints; it is not derived from a Boundary. This is not full Perception or Memory parity. The Body- and perspective-indexed `PerspectiveModel` remains the fuller Model shadow, and `StructuredModel` does not replace it.

**Compatibility.** Generic State, Direction, Transformation, Entity, Boundary and the cognitive pipeline are unchanged. Their continued compilation shows compatibility with these records. It does not prove that every earlier downstream witness represents the revised canonical structure.

## Forbidden collapses

- **Order into Relation:** the ordered-pair extension is not the registered Relation and is not evidence that any Relation obtains.
- **Order into totality:** a partial Order may have incomparable members; total comparability is a separate, proved property.
- **Direction into strict Order:** asymmetry does not imply transitivity; a cyclic asymmetric Direction is the strict part of no Order.
- **Direction or Order into time, causation, rank or indexing:** none is supplied by either term.
- **Empty Order into Absence:** an Order with no members is a Presence with no member.
- **Coordination Order into Order:** the institutional term names coordination structure, not an ordering relation, and the reverse also fails.
- **State into inventory:** equal members with different selected structure, or the same Configuration at different indices, are different States.
- **Entity into a Configuration, record or snapshot:** the Entity is the reidentified Presence. Its witness record and history States are not the Entity.
- **Invariant into history or identity:** satisfying the named Invariant neither identifies an Entity nor places a State in its history.
- **Boundary into its Constraint list:** the core projection is lossy; configured Boundaries with different structure can project identically.
- **Model into a member list:** listed Representations and Transformations without a named join do not form a Model.

<!-- organon:proposal-statement OC-G1 type=open_evidence_gate -->
An application must justify which Presences are members of an Order and which pairs are ordered. It must also justify which actual Relations join a Boundary's Constraints or a Model's members, and how any Entity is empirically individuated. The supplied relation, interpretation and realization predicates are not truth oracles. Full Perception, Memory and prose/shadow parity for State, Entity, Boundary and Model remain unproved. These limits do not reopen the disproved identification of State with inventory or of Order with Direction.

## Open gate

OC-G1 above is the remaining gate. The [lifecycle registry](./lifecycle.json) records it as the quarantined remainder of this promotion.

## Aesthetics findings and adjudication

The [structured-Configuration CI run](https://github.com/sadasant/organon/actions/runs/38385898931) failed three error-level criteria. Its downloaded evaluation record supplies probabilities and localization choices, not explanatory reasoning. The whole-PR request was truncated at 397,312 diff characters before the later release and review evidence. These facts limit the diagnosis; they do not make a failure harmless or establish its cause.

- **Terms in binding sense:** a substantiated ambiguity remained. A Configuration has extensional Identity, yet Entity and institutional entries spoke of a persistent Configuration while its structure could change. The revised Entity definition distinguishes the reidentified Presence from its State Configurations; the Persistence clarification names the Invariant and witness. Downstream contracts retain structure rather than silently projecting it away. This is the local correction, not a claim that the model explained that exact defect.
- **Append-only records:** the broad judgment is not substantiated by the inspected history. The Configuration correction added a superseding changelog entry, retained the earlier reduction entry, and created new exact-source reviews instead of overwriting their predecessors. This follow-up likewise retains those records and adds new integration reviews. Current projections and current source pointers change; historical outcomes do not. Truncation omitted relevant evidence, so no categorical claim about the evaluator's reasoning is warranted.
- **Calibrated status:** the inspected records distinguish nonbinding shadows, provisional glyphs and application gates, and downstream evaluation remains incomplete/hold. No specific promotion-from-compilation claim was supplied. Nevertheless, current counts in the build receipt, Unicode introduction and explorer README had become stale; this follow-up corrects those summaries and separates the old build evidence from the current 58-job build. Passing tests do not establish empirical adequacy or reader recognition.

No CI rule, threshold or workflow is relaxed. This adjudication is a local source review, not an override or a claim that the failed run passed. The next exact-head CI result must be reported separately.

The [integration-head run](https://github.com/sadasant/organon/actions/runs/38411034065) still failed binding terminology, append-only records and change scope. A local rerun reproduced the terminology failure. Source inspection found that “strict Order” conflicted with Order's reflexivity, while calling State a Configuration left its index outside Configuration's extensional Identity criterion. The binding prose now says “strict part of an Order” and explicitly pairs a Configuration with its index, as OC-D2 and OC-C2 already require. Persistence also distinguishes Configuration comparisons at a given State from reidentification across States; Entity no longer calls the State itself a Configuration.

The retained whole-diff request stopped inside the generated glyph specimen, omitting later evidence. Raising the budget from 400,000 to 1,000,000 characters did not establish complete coverage: the October 15 review found that later input still truncated, with a measured diff of 1,262,447 bytes. The earlier “complete input” claim is withdrawn. A passing append-only criterion on one truncated request does not certify the whole change; later Aesthetics runs failed it again. Guidelines, severities, thresholds and exclusions remain unchanged. Daniel chose to keep this work in PR44, but that decision does not discharge the scope finding or make Aesthetics green. The presentation remains nonbinding.

## Sources and related entries

- Rodríguez, Daniel. Order and Configuration integration review, October 13, 2026, continuing the [Set and Configuration review](https://ampcode.com/threads/T-01a12b1e-60b5-77bc-8215-5fcd15da8088).
- Hausdorff, Felix. *Grundzüge der Mengenlehre*. Veit, 1914. Early systematic treatment of ordered sets.
- Birkhoff, Garrett. *Lattice Theory*. American Mathematical Society, 1940; 3rd ed. 1967. Partial orders, strict parts and chains.
- Davey, B. A., and H. A. Priestley. *Introduction to Lattices and Order*. 2nd ed. Cambridge University Press, 2002. Standard definitions of partial, strict and total order.
- Hodges, Wilfrid. *A Shorter Model Theory*. Cambridge University Press, 1997. Relational structures; Organon does not adopt the whole framework.
- Wiggins, David. *Sameness and Substance Renewed*. Cambridge University Press, 2001. Sortal-relative reidentification, the background for keeping Entity individuation as an application gate rather than a record equality.
- Organon claims none of these precedents as original. Its contribution is placing them in one dependency-ordered vocabulary with checked boundaries.
- [Formal contracts](../ontology/formal/OrderConfigurationContracts.lean), [MathematicalOrder](../ontology/formal/MathematicalOrder.lean), [ConfigurationIntegration](../ontology/formal/ConfigurationIntegration.lean), and [typed claims](./order-and-configuration-integration-claims.json).
- [Binding Order](../ontology/ontology.md#organon-mathematical-order), [Coordination Order](../ontology/ontology.md#organon-order), [registry](../ontology/terms.yaml), [v0.21 release](../releases/v0-21-0.md), [Set and Configuration dossier](./set-and-configuration.md), and [current source review](../reviews/promotion/order-review-resolution.json).
