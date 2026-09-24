---
type: quarantine-proposal
status: ready-for-review
binding: false
concept: embodied-consciousness
created: 2026-09-23
updated: 2026-09-23
recommended_outcome: partial-promotion
statement_manifest: "embodied-consciousness-claims.json"
formal_shadow: "../ontology/formal/EmbodiedConsciousness.lean"
---
# Embodiment and Recurrent Consciousness Candidate

## Verdict

The embodiment cluster conforms after five repairs that make its dependencies and anti-collapses explicit. Body can be distinguished from Entity and Boundary by naming the constituent Configuration that carries Boundary Constraints and the recurring Transformations implicated in identity Persistence. Bodily Organization requires coordinated Organs and Causal Contributions to that Persistence. Embodied Perspective requires represented self-condition and operative causal participation. Recurrent Integration requires a returning pair of Causal Contributions, not common storage. Internal Activity Selection is needed because Organon's binding Action is necessarily boundary-crossing, while the proposal also concerns continuing, inhibiting, and revising internal Transformations.

The consciousness sentence conforms only as a **candidate condition** within the existing consciousness protocol. It does not settle what Consciousness universally is, which Entities instantiate it, or what Evidence would decide such a Claim. The proposal therefore recommends partial promotion of the five supporting terms while the underlying consciousness condition remains quarantined.

This dossier does not address Attention, Love, Care, Respect, embodied self-governance, or Intention. Those terms require their own anti-collapse and formal review after the embodiment foundation is settled.

## Proposed definitions

<!-- organon:proposal-statement EC-D1 type=proposed_definition -->
**EC-D1 — Body:** A Body is a persistent constituent Configuration of an Entity that carries the Constraints of the Entity's Boundary and recurring Transformations whose Causal paths preserve the Entity's identity Invariant across ordered States. Its Boundary distinguishes an Interior from an Environment. Bodily Persistence does not require isolation or an unchanging inventory of parts.

This definition does not make Body a synonym for Entity. An Entity is identified by an Invariant and Persistence witness. Body names the constituent Configuration in which the relevant Boundary Constraints and recurring identity-preserving Transformations occur. The same Entity could therefore be embodied differently across Scopes, while a Configuration enclosed with it is not thereby part of its Body.

<!-- organon:proposal-statement EC-D2 type=proposed_definition -->
**EC-D2 — Bodily Organization:** Bodily Organization is a Relation among at least two distinct Organs of one Body in which their recurring Transformations are coordinated and each has a Causal Contribution to the Persistence of the larger Entity's identity Invariant. Shared enclosure, dependence, Substrate, or proximity alone does not establish Bodily Organization.

“Enact the larger Entity” is replaced by the exact obligation to contribute causally to identity Persistence. An Organ's recurring Transformation may differ from another Organ's, but both must be located in the Body and joined to the larger Entity's Persistence rather than merely co-occurring.

<!-- organon:proposal-statement EC-D3 type=proposed_definition -->
**EC-D3 — Embodied Perspective:** An Embodied Perspective is a Model internal to a Body whose Representations denote that Entity's own condition and available internal Transformations, and in which Perception and Memory make Causal Contributions to later internal States under stated Constraints. Verbal self-description is not required.

“Operative” is carried by the Causal Contribution requirement. Denotation alone remains insufficient under Organon's representational-efficacy constraint: a Representation of the Entity's condition must participate in the path that changes later internal activity.

<!-- organon:proposal-statement EC-D4 type=proposed_definition -->
**EC-D4 — Recurrent Integration:** Recurrent Integration is an organization of at least two distinct constituent processes in which a Difference registered by the first process makes a Causal Contribution to a later Change in the second, and a Difference registered by the second makes a later Causal Contribution to a Change in the first. The return contribution must occur later under the shared Direction. Shared storage, broadcast, duplicated signals, temporal co-occurrence, or correlation alone does not establish Recurrent Integration.

The two Causal Contributions supply the contrastive paths required by the binding ontology. The named process-to-Difference and process-to-Change joins prevent “integration” from reducing to a signal appearing in two places.

<!-- organon:proposal-statement EC-D5 type=proposed_definition -->
**EC-D5 — Internal Activity Selection:** Internal Activity Selection is a Configuration in which a Representation of an outcome makes a Causal Contribution to discriminating among available internal Transformations of one Body by selecting, continuing, inhibiting, or revising one under stated Constraints.

This term is required because binding Action crosses an Entity's Boundary. Internal Activity Selection can occur wholly within an Interior and therefore cannot be defined as Action or Agency. When it later produces a boundary-crossing Transformation, the existing Action and Agency definitions apply without modification.

<!-- organon:proposal-statement EC-D6 type=proposed_definition -->
**EC-D6 — Embodied recurrent consciousness candidate:** One candidate condition for consciousness obtains when an Entity has a Body, an Embodied Perspective, Recurrent Integration, and Internal Activity Selection such that the perspective's Representation and Causal Contribution participate in selecting or revising the Entity's ongoing internal Transformations.

This is a proposal-local candidate supplied to the existing `CandidateCondition` protocol. It does not become `organon:Consciousness`, and its obtainment remains distinct from Consciousness Attribution and Consciousness Designation. It requires neither deliberate production of represented contents, verbal report, outward Action, nor complete Control.

## Exact anti-entailments

<!-- organon:proposal-statement EC-C1 type=anti_collapse_constraint -->
**EC-C1 — Bodily Persistence does not entail a fixed inventory of parts:** The finite Body preserves its Entity's identity across two ordered internal States while a named sensor part is present in the first and absent in the second.

<!-- organon:proposal-statement EC-C2 type=anti_collapse_constraint -->
**EC-C2 — Boundary does not entail isolation:** The finite Body has disjoint Interior and Environment Scopes. An Environment State exists while internal States and recurring Transformations remain inhabited.

<!-- organon:proposal-statement EC-C3 type=anti_collapse_constraint -->
**EC-C3 — Shared enclosure does not entail Bodily Organization:** A finite structure contains two distinct Organs in one enclosure while its bodily-unity predicate is false. Proximity, dependence, or common containment would need equivalent additional joins before they could establish Bodily Organization.

<!-- organon:proposal-statement EC-C4 type=anti_collapse_constraint -->
**EC-C4 — Shared signals do not entail Recurrent Integration:** A finite structure gives two distinct processes the same signal. Under a Direction admitting no Transformation, no Causal Contribution and therefore no Recurrent Integration can exist.

<!-- organon:proposal-statement EC-C5 type=anti_collapse_constraint -->
**EC-C5 — Embodied Perspective does not entail the candidate condition:** The finite model contains an Embodied Perspective at a candidate-Scope moment for which the embodied recurrent candidate does not obtain.

<!-- organon:proposal-statement EC-C6 type=anti_collapse_constraint -->
**EC-C6 — Candidate obtainment does not entail speech, outward Action, or complete Control:** The finite candidate obtains while the model's verbal-self-description, outward-Action, and complete-Control predicates are all false.

<!-- organon:proposal-statement EC-C7 type=anti_collapse_constraint -->
**EC-C7 — Candidate obtainment does not entail Attribution or Designation:** The embodied recurrent candidate supplies only a candidate condition. The existing consciousness dossier's Attribution and Designation Relations still require their own claimant, Representation, Rule, Order, purpose, and Scope.

## Formal shadow

The noncanonical [EmbodiedConsciousness.lean](../ontology/formal/EmbodiedConsciousness.lean) defines `Body`, `BodilyOrganization`, `EmbodiedPerspective`, `RecurrentIntegration`, `InternalActivitySelection`, and `EmbodiedConsciousnessCandidate`. It imports the binding formal reduct's `Entity`, `Boundary`, `PersistenceWitness`, `CausalContribution`, `Denotation`, `Scope`, and `Specification` structures and reuses the existing consciousness proposal's `CandidateCondition` rather than adding a universal consciousness predicate.

The inhabited model has six ordered internal States, an external State, one identity Invariant, one Boundary Constraint, four recurring internal Transformations, two Organs, two distinct constituent processes, two temporally ordered Causal Contributions forming the return path, an Embodied Perspective, a discriminating revision among internal Transformations, and one obtaining candidate. Its countermodels prove only the anti-entailments named above.

The formal shadow is deliberately stricter than a graph with a recurrent edge: each contribution contains paired nonempty comparison paths, a named upstream Difference, and a downstream Change. It is also deliberately incomplete: process individuation and Configuration-to-constituent parthood are proposal-local relations rather than canonical Organon structures.

<!-- organon:proposal-statement EC-G1 type=open_formalization_gate -->
### EC-G1 — Open formalization gate: constituent and process identity

Promotion must decide how a constituent Configuration is related to its Entity across changing States, how an Organ is identified across replacement of parts, and how a constituent process is individuated across Transformations. The present formal shadow carries explicit witnesses but does not claim a universal mereology or process ontology.

<!-- organon:proposal-statement EC-G2 type=open_evidence_gate -->
### EC-G2 — Open evidence gate: candidate application

No observation in this dossier establishes that any biological, artificial, institutional, or other Entity satisfies EC-D6. Application requires a separate Specification of the relevant Entity, Body, processes, Causal Contributions, and admissible Evidence. Candidate obtainment, Attribution, Designation, Standing, protection, and moral status remain separate Claims.

## Proposal statement registry

| ID | Type | Statement | Dependencies | Evidence or gate |
| --- | --- | --- | --- | --- |
| EC-D1 | Proposed definition | Body | Configuration, Entity, Boundary, Constraint, Transformation, Causal path, Invariant, Persistence, State, Interior, Environment | Inhabited finite Body |
| EC-D2 | Proposed definition | Bodily Organization | EC-D1, Organ, Relation, Causal Contribution, Persistence, Invariant | Inhabited two-Organ organization |
| EC-D3 | Proposed definition | Embodied Perspective | EC-D1, Model, Representation, Denotation, Perception, Memory, State, Constraint, Transformation, Causal Contribution, Interior | Inhabited operative perspective |
| EC-D4 | Proposed definition | Recurrent Integration | Configuration, Difference, Transformation, Direction, Causal Contribution, State | Two ordered reciprocal contributions |
| EC-D5 | Proposed definition | Internal Activity Selection | EC-D1, Configuration, Representation, Denotation, State, Transformation, Constraint, Causal Contribution, Interior, Action | Discriminating internal revision witness |
| EC-D6 | Proposed definition | Embodied recurrent consciousness candidate | EC-D1, EC-D3, EC-D4, EC-D5, Entity, candidate condition, Consciousness Attribution, Consciousness Designation | Inhabited `CandidateCondition` |
| EC-C1 | Anti-collapse constraint | Bodily Persistence does not entail fixed parts | EC-D1, Persistence, Invariant, State | `bodyCanPersistAcrossPartChange` |
| EC-C2 | Anti-collapse constraint | Boundary does not entail isolation | EC-D1, Boundary, Interior, Environment | `bodyBoundaryDoesNotRequireIsolation` |
| EC-C3 | Anti-collapse constraint | Shared enclosure does not entail Bodily Organization | EC-D2, Configuration, Organ | `sharedEnclosureDoesNotEntailBodilyOrganization` |
| EC-C4 | Anti-collapse constraint | Shared signals do not entail Recurrent Integration | EC-D4, Difference, Causal Contribution | `sharedSignalDoesNotEntailRecurrentIntegration` |
| EC-C5 | Anti-collapse constraint | Embodied Perspective does not entail the candidate | EC-D3, EC-D6, candidate condition | `embodiedPerspectiveDoesNotEntailCandidate` |
| EC-C6 | Anti-collapse constraint | Candidate does not entail speech, outward Action, or complete Control | EC-D6, Action, Control | `candidateDoesNotRequireSpeechActionOrCompleteControl` |
| EC-C7 | Anti-collapse constraint | Candidate does not entail Attribution or Designation | EC-D6, Consciousness Attribution, Consciousness Designation | Existing consciousness protocol |
| EC-G1 | Open formalization gate | Constituent and process identity | EC-D1, EC-D2, EC-D4, Configuration, Entity, Organ, State | Open |
| EC-G2 | Open evidence gate | Candidate application | EC-D6, Specification, Evidence, Claim | Open |

## Promotion boundary

The smallest defensible promotion is Body, Bodily Organization, Embodied Perspective, Recurrent Integration, and Internal Activity Selection together with EC-C1 through EC-C7. They form one dependency-closed cluster and sharpen existing Entity, Boundary, Organ, Model, and Action terms without changing their meanings.

The underlying consciousness condition remains quarantined. EC-D6 enters only as a proposal-local candidate available to Consciousness Attribution and Consciousness Designation. A later promotion PR would need to add stable identifiers and exact dependencies to the canonical ontology, update its generated projections and evaluations, and either close EC-G1 or state its limits as binding prose.
