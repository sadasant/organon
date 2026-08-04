---
type: quarantine-proposal
status: promoted
binding: false
concept: world-and-substrate
created: 2026-08-03
updated: 2026-08-03
recommended_outcome: promoted-in-v0.12
statement_manifest: "world-and-substrate-claims.json"
formal_shadow: "../ontology/formal/WorldSubstrate.lean"
---
# World and Substrate

## Verdict

World and Substrate can leave quarantine together, provided neither is allowed to become a polite alias for Reality.

World names a participant-scoped Configuration in which Perception, Interpretation, and Action are possible through constrained Causal paths. Its scope does not make it arbitrary: a World must name an Invariant that persists across distinct access paths. Substrate names the contextual Configuration that supplies persistent input States and Constraints to a family of Transformations. It is neither passive matter nor a fundamental layer beneath Presence.

The joint promotion matters because an Entity never encounters an unqualified “raw world.” It acts through Constraints on a Substrate inside a scoped World. The resulting Perception or Map remains a Representation of that World, not the World itself.

## Termhood challenge

### World is not only Configuration, Environment, or Map

The strongest reduction is that a World is merely an Entity plus its Environment considered as a Configuration. That reduction omits two distinctions the corpus repeatedly needs:

1. not every environmental Presence is available to Perception or Action under the current Constraints; and
2. different constrained access paths can expose different States while bearing on a common Invariant.

Environment names what is related to an Entity but outside its identity. World includes participating Entities as well as selected Environment, available Causal paths, Scope, and the cross-path Invariant. Map and Reference remain Representations of that Configuration.

### Substrate is not only an input State

The strongest reduction is that a Substrate is merely the input State of a Transformation. That reduction loses Persistence across a family of Transformations and the fact that the source Configuration's own Constraints help determine what can be preserved, suppressed, or amplified. A single input State is sufficient for one Transformation; Substrate names the persistent, scoped Configuration that supplies the family.

Calling Substrate a fundamental kind would add no useful distinction and would conflict with the Absence/Presence partition. The same Configuration can serve as Substrate in one Scope and as Entity, Environment, Tool, represented target, or output in another.

## Proposed definitions

<!-- organon:proposal-statement WS-D1 type=proposed_definition -->
**WS-D1 — World:** A World is a scoped Configuration containing one or more Entities, selected Presence from their Environments, and the States, Relations, and Causal paths available to their Perception, Interpretation, or Action under named Constraints. Availability requires an included Causal path. At least one named Invariant must persist across distinct combinations of Senses, Maps, or References within the Scope.

<!-- organon:proposal-statement WS-D2 type=proposed_definition -->
**WS-D2 — Substrate:** A Substrate is a Configuration specified within a Scope as the persistent source of input States for a named family of Transformations. Those States Feed the Transformation inputs, while Constraints in the Configuration determine which Differences can be preserved, suppressed, or amplified in the outputs.

## Exact anti-entailments

<!-- organon:proposal-statement WS-C1 type=anti_collapse_constraint -->
**WS-C1 — World Scope need not be universal over its carrier type:** A World can be inhabited while excluding an inhabited State of the same formal carrier type from its Scope. This formal result does not encode Reality or prove the stronger World-Reality distinction, which remains binding in prose under C12.

<!-- organon:proposal-statement WS-C2 type=anti_collapse_constraint -->
**WS-C2 — Common World does not entail identical access:** Distinct access paths can disagree about an available State while the States they expose still satisfy the World's named Invariant.

<!-- organon:proposal-statement WS-C3 type=anti_collapse_constraint -->
**WS-C3 — Substrate Persistence does not entail output Persistence:** Every source State supplied by a Substrate can satisfy its carrier Invariant while a Transformation in the supported path produces an output that violates that Invariant.

<!-- organon:proposal-statement WS-C4 type=anti_collapse_constraint -->
**WS-C4 — Substrate does not entail persistence of what it carries:** A valid Substrate supplies no proof that a separately carried Representation, Invariant, Entity, or function persists. Such a proof first requires an explicit realization relation; Organon currently defines none.

These formal witnesses establish only the named scoped and anti-entailment results. They do not formalize Reality, claim that Worlds are fictional, claim that access paths never agree, or imply that Substrates normally destroy what they carry.

## World

### Availability without idealism

Participant-relative access does not make World participant-created. The Entity and its Constraints determine which Causal paths are available; Reality supplies the Presences and Relations those paths traverse. The named Invariant prevents the World from collapsing into one Perception or private Model.

The corpus phrase “the world does not change; the filters do” supplies the realism boundary. The later phrase “the reference spectrum is the world” is best read as editorial compression: the Reference captures the invariant structure by which multiple constrained views can be compared. Under Organon's binding terms, the Reference remains a constructed Map and cannot become the World without violating C5 and C12.

### Political world-making

An Order can change a World when its Rules, Boundaries, statuses, and enforced Consequences alter actual available Actions and Causal paths. A Declaration alone does not create a World. An Operationalized Representation can participate in Transformations that change one. Political world-making is therefore neither verbal magic nor creation of Reality from Absence.

## Substrate

### Context rather than essence

Substrate is indexed by Scope and a family of Transformations. White light can be Substrate for a prism; hardware State can be Substrate for executable Transformations; an Institution can be Substrate for Roles that persist across changes of Agents. None becomes Substrate absolutely.

The source Configuration is active in the modest ontological sense already available to Organon: its Constraints exclude some Transformations and permit others. No additional substantial power is required. What appears as an undifferentiated whole under one Constraint can expose legible Differences under another.

### Carrier and carried Configuration

The present ontology does not yet contain a universal realization relation connecting physical carrier, Representation, function, and Entity identity. This proposal therefore refuses to say that a carried Configuration supervenes on, emerges from, or is reducible to its Substrate. It says only that named input States Feed a path and that the Substrate's Constraints participate in the supported Transformations.

## Intellectual shadows

### Uexküll and Gibson

Jakob von Uexküll's *A Foray into the Worlds of Animals and Humans* makes the accessible environment specific to an organism's perceptual and effectual capacities. James J. Gibson's ecological approach treats perception and possible Action as reciprocal with an Environment rather than as inspection of a neutral picture.

Organon inherits participant-relative availability and the perception-action relation. It does not inherit a private phenomenal bubble: distinct access paths must bear on a named common Invariant. It also does not inherit Gibson's direct realism, because every Organon Sense remains a Constraint and every Perception a State produced through that constrained path.

### Aristotle and Simondon

Aristotle's *Physics* treats an underlying subject as persisting through change. Gilbert Simondon's associated milieu is not passive matter; it conditions technical structures and is conditioned by them.

Organon inherits the questions of persistence through Transformation and active environmental condition. It rejects prime matter, a universal fundamental Substrate, and wholesale identification with Simondon's associated milieu. Substrate here is only a contextual Configuration specified by the input States it supplies and Constraints it contributes to a named family of Transformations.

## Formal shadow

The noncanonical [WorldSubstrate.lean](../ontology/formal/WorldSubstrate.lean) defines:

- `AccessPath`, with participant identity and a scoped availability predicate;
- `World`, with nonempty participants and States, distinct participant-bound access paths, causal witnesses for availability, and a common Invariant;
- `PersistenceWitness`, with an Invariant preserved across at least two directionally ordered States;
- `Substrate`, with ordered source Persistence, nonempty Constraints, a scoped Causal path, and explicit Feeds witnesses; and
- generic theorems exposing the access, invariant, constraint, and feeding obligations.

The finite model constructs one World containing active and standby machine States while excluding an inhabited broken State from its Scope. Each access path carries a nonempty Causal path beginning at its participant's current State, and every advertised available State is witnessed as an input or output on that path. The two paths expose different States under one common Invariant. The Substrate carries an ordered source-Persistence witness for idle then active, supplies those two inputs to an activation-then-break path, and admits a final output that violates the source Invariant. Carrier-to-content realization remains deliberately unformalized rather than represented by an unconstrained predicate.

<!-- organon:proposal-statement WS-G1 type=open_formalization_gate -->
### WS-G1 — Open formalization gate: access and realization joins

The formal shadow does not yet encode the complete Causal path from Environment through Sense into Perception, a semantic Map-to-World fidelity relation, qualitative semantics for preservation, suppression, or amplification of Differences, or a universal realization relation joining carrier, Representation, function, and Entity identity. Promotion is limited to the dependency seams and anti-entailments above. Any stronger Claim about direct access, convergence proving identity, supervenience, emergence, or substrate independence remains blocked until those joins are defined.

## Proposal statement registry

| ID | Type | Statement | Dependencies | Evidence or gate |
| --- | --- | --- | --- | --- |
| WS-D1 | Proposed definition | World | Configuration, Entity, Presence, Environment, State, Relation, Causal path, Perception, Interpretation, Action, Constraint, Sense, Map, Reference, Scope, Invariant, Persistence, Reality, Evidence, Evidential Bearing, Claim, Order, Rule, Boundary | Finite inhabited World |
| WS-D2 | Proposed definition | Substrate | Configuration, Scope, Persistence, Invariant, State, Transformation, Feeds, Constraint, Difference, Representation, Entity, Environment, Tool | Finite inhabited Substrate |
| WS-C1 | Anti-collapse constraint | World Scope need not include every State of its carrier type | WS-D1, State, Scope | `worldScopeCanExcludeCarrierState` |
| WS-C2 | Anti-collapse constraint | Common World does not entail identical access | WS-D1, Invariant | `worldAccessPathsNeedNotAgree` |
| WS-C3 | Anti-collapse constraint | Persistent source States do not entail invariant-preserving outputs | WS-D2, Persistence, Invariant, Transformation | `substrateInputPersistenceDoesNotEntailOutputPersistence` |
| WS-C4 | Anti-collapse constraint | Substrate does not entail persistence of what it carries | WS-D2, Persistence, realization relation | Blocked on WS-G1 realization relation |
| WS-G1 | Open formalization gate | Complete access, fidelity, and realization joins | World, Substrate, Environment, Sense, Perception, Map, Representation, Entity | Open |

## Promotion boundary

This dossier records the promotion enacted in Organon v0.12:

- World and Substrate received stable identifiers and exact dependencies;
- add C12 and C13 as binding anti-collapse constraints;
- add the optional `situated-world` adoption profile;
- preserve Reality, Environment, Map, Reference, and Substrate as distinct;
- preserve every stronger fidelity, realization, emergence, and direct-access Claim behind WS-G1; and
- keep the other quarantined vocabulary unchanged.

The dossier remains nonbinding provenance material. Promotion is enacted only by the single-file ontology and its governed registry, profiles, provenance, changelog, release note, and formal receipt; the dossier's lifecycle state records that outcome without becoming a second canonical ontology.
