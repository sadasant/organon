---
type: quarantine-proposal
status: promoted
binding: false
concept: truth-trust-and-alignment
created: 2026-08-03
updated: 2026-08-03
recommended_outcome: promoted-in-v0.13
statement_manifest: "truth-trust-and-alignment-claims.json"
formal_shadow: "../ontology/formal/TruthTrustAlignment.lean"
---
# Truth, Trust, and Alignment

## Verdict

Truth, Trust, and Alignment can leave quarantine together, but only as three different Relations.

Truth joins a Claim's declared truth-condition Specification to the Presence in Reality that the Claim is about. Trust joins one Entity's accepted exposure to another Entity's future contribution that the first does not determine. Alignment joins a subject Configuration to a target under a declared Specification of correspondence. The corpus often places all three near confidence, cooperation, and institutional acceptance; the proposal keeps those neighbors from becoming synonyms.

## Corpus survival test

### Truth

*Reasoning and Language* and *The Conspiracy of Reason* distinguish Maps and symbols from the Reality they may represent while refusing the conclusion that inaccessible Reality has no bearing on Claims. *Epistemic Capture* supplies the decisive counterexample: an Institution can preserve coordination around an admitted object after contrary Evidence exists. Truth therefore cannot be institutional acceptance, consensus, Evidence, or an Agent's present ability to decide.

The candidate survives if the Specification remains constructive but epistemic access is separate. Given the relevant Presence, the Specification decides conformity. Nothing in Truth guarantees that any Entity can identify, access, or supply that Presence to the procedure.

### Trust

The corpus uses confidence, relationship, history, delegation, and institutional acceptance as reasons or mechanisms for extending Trust. Their shared structure is not confidence. *Containment* treats uncertainty and mutual dependence as conditions of cooperation; *Epistemic Capture* shows familiar signals causing people to let another filter the World on their behalf; *Delete the Harness* locates a trust boundary where another process can affect credentials, networks, or the World.

The invariant is accepted exposure to another Entity's future contribution while that contribution is not determined by the trusting Entity. “Undetermined” is relational, not metaphysical: the trustee may be deterministic while the truster lacks Control sufficient to fix the relevant contribution. History, Evidence, reputation, confidence, Permission, and incentives may alter whether an Entity accepts that exposure. None is Trust itself.

### Alignment

The corpus applies Alignment to behavior, faithful Principal representation, incentives, and bounded Authority. What survives is a directional subject-to-target correspondence under a Specification that declares the relevant Scope and Differences. Profiles name what is being compared: behavior, representation, incentives, or authority. Alignment obtains only when the selected profile's Specification decides conformity.

This is more than possessing a Specification: Alignment is the Relation that obtains for a subject and target when the Specification is satisfied. It is less than identity, shared purpose, Truth, or global future agreement. The general Relation survives termhood; the four current profiles remain ordinary named Specifications until one acquires additional dependency-closed structure.

## Proposed definitions

<!-- organon:proposal-statement TA-D1 type=proposed_definition -->
**TA-D1 — Truth:** Truth is the Relation among a Claim, the Specification declared as its truth condition, and the Presence in Reality within the Claim's Scope to which that Specification applies. Truth obtains exactly when the relevant Presence conforms to the Specification. It does not depend on whether an Entity can identify, access, supply, prove, or institutionally admit that correspondence.

<!-- organon:proposal-statement TA-D2 type=proposed_definition -->
**TA-D2 — Trust:** Trust is a scoped Relation in which one Entity accepts Exposure or Consequences that depend on a future Action, Claim, or State introduced into a Causal path by another Entity, while the trusting Entity lacks Control sufficient to determine that contribution when the Relation obtains.

<!-- organon:proposal-statement TA-D3 type=proposed_definition -->
**TA-D3 — Alignment:** Alignment is a scoped, directional Relation from a subject Configuration to a target Presence under a Specification of their correspondence. It obtains when that Specification constructively decides that the subject conforms to the target with respect to the named States, Transformations, Relations, or Differences.

## Exact anti-entailments

<!-- organon:proposal-statement TA-C1 type=anti_collapse_constraint -->
**TA-C1 — Truth is not epistemic or institutional success:** Truth does not entail Agent access, Evidence, proof, consensus, Admission, or a decision by any Entity. A Claim, Presence in Reality, Evidence, consensus, or Admission does not separately entail Truth.

<!-- organon:proposal-statement TA-C2 type=anti_collapse_constraint -->
**TA-C2 — Trust is not confidence, prediction, or authorization:** Trust does not entail confidence, accurate prediction, Evidence, Permission, Authority, or favorable Consequences. None of those separately entails Trust. Trust requires the named exposure, dependency, futurity, other-supplied contribution, and absence of determining Control.

<!-- organon:proposal-statement TA-C3 type=anti_collapse_constraint -->
**TA-C3 — Alignment is profile-scoped correspondence:** Alignment under one Specification or Scope does not entail Alignment under another, identity with the target, faithful representation outside the profile, Truth, Trust, Permission, Authority, shared Agency, shared purpose, or persistence across later States.

<!-- organon:proposal-statement TA-C4 type=anti_collapse_constraint -->
**TA-C4 — No Truth-Trust-Alignment collapse:** A true Claim need not be trusted or aligned with an institutional target; Trust can attach to a contribution containing a false Claim or producing misalignment; and Alignment can obtain with a false target or Specification. Any connection among the three requires an additional declared Rule, Specification, or Causal path.

## Dependency audit

Truth depends on Claim, Specification, Reality, Presence, Scope, and Relation. `Specification` supplies constructive conformity; `Claim` supplies the asserted Representation and Scope; Reality supplies the truth-maker boundary. The definition adds no universal semantic theory joining every Representation to every Presence.

Trust depends on Relation, Entity, Direction, State, Action, Claim, Causal path, Exposure, Consequence, Control, and Scope. The phrase “contribution” is deliberately not a fourth ontological term: it abbreviates the Action, Claim, or State another Entity introduces into the named Causal path.

Alignment depends on Relation, Configuration, Presence, Specification, Scope, State, Transformation, Difference, and Direction. Direction belongs to subject-to-target evaluation; it does not assert that every profile uses a temporal Direction.

## Intellectual shadows

### Tarski and correspondence

Alfred Tarski's semantic conception disciplines the truth seam by separating object language from metalanguage and requiring materially adequate truth conditions. Organon inherits the demand that a Claim's truth not be manufactured by its Evidence or institutional treatment. It does not claim that Tarski supplied this ontology's Reality, Claim, Scope, or Specification machinery, and it does not reduce natural-language truth to one formal language.

### Baier, Jones, Hardin, and Luhmann

Annette Baier centers accepted vulnerability to another; Karen Jones centers an optimistic attitude about another's goodwill and competence; Russell Hardin centers encapsulated interest; Niklas Luhmann treats trust as a reduction of social complexity. Organon inherits Baier's exposure seam and the shared attention to dependency under uncertainty. It does not require optimism, goodwill, shared interest, or confidence. Those can explain why Trust is extended without constituting the Relation.

### Specification and AI alignment

The AI-alignment literature distinguishes intended, specified, and learned behavior, while interactive-alignment work separates specification, process, and evaluation alignment. Organon inherits the demand to name the target and evaluation profile. It rejects “aligned” as a global virtue: every Alignment is directional and scoped under one constructive Specification, and no result silently transfers between profiles.

The local contribution is the joint anti-collapse: correspondence to Reality, accepted exposure to another, and specified subject-target conformity must coexist in the same dependency system without standing in for one another.

## Formal shadow

The noncanonical [TruthTrustAlignment.lean](../ontology/formal/TruthTrustAlignment.lean) defines proposal-local `TruthSemantics`, `EpistemicAccess`, `Trust`, `AlignmentProfile`, and `Alignment` structures. The Trust witness binds the other-supplied contribution to an actual Transformation on a Causal path, identifies its output as the Consequence, and records the absence of determining Control. Its finite instance establishes:

- one true Claim whose target no modeled Agent can supply;
- one present target and Claim that do not satisfy their truth-condition Specification;
- one Trust Relation without confidence or Permission, and confidence without any possible Trust inhabitant;
- one Alignment that satisfies one profile but not an incompatible profile;
- Alignment between different carrier types without identity;
- Alignment with a Claim that is false under the toy truth semantics; and
- simultaneous inhabitation of Truth, Trust, and Alignment without identifying them.

The reality predicate is explicitly a `targetInRealityModel` relation rather than Organon's totality of Presence. The finite theorem therefore tests correspondence and epistemic independence, not a complete formalization of Reality.

<!-- organon:proposal-statement TA-G1 type=open_formalization_gate -->
### TA-G1 — Open formalization gate: complete Claim semantics and Reality bridge

Promotion does not supply a universal Map from every natural-language Claim to one truth-condition Specification and target Presence, nor a formal bridge identifying Lean's `targetInRealityModel` with Organon's Reality. Claims of semantic completeness, unique interpretation, or machine decision of Truth remain blocked until those joins exist.

<!-- organon:proposal-statement TA-G2 type=open_formalization_gate -->
### TA-G2 — Open formalization gate: Trust contribution and profile dynamics

The formal shadow proves the proposed dependency shape for one finite future contribution on a Causal path. It treats the contributing Transformation as the exposure event but does not yet join that event to a formal Interior-and-Boundary crossing, quantify degree of Exposure, or model how Evidence, repeated interaction, Enforcement, or reputation changes an Entity's acceptance of exposure. Those dynamics remain blocked rather than being inferred from the existence of Trust.

<!-- organon:proposal-statement TA-G3 type=open_formalization_gate -->
### TA-G3 — Open formalization gate: Alignment profile composition and persistence

The formal shadow models conformity under separate Specifications. It does not prove that behavioral, representational, incentive, or authority profiles compose, that any profile tracks human values, or that present conformity persists after a Transformation or outside Scope. Those stronger Claims require separate Specifications, cross-profile Rules, and Persistence witnesses.

## Proposal statement registry

| ID | Type | Statement | Dependencies | Evidence or gate |
| --- | --- | --- | --- | --- |
| TA-D1 | Proposed definition | Truth | Relation, Claim, Specification, Reality, Presence, Scope | `TruthSemantics.isTrue` |
| TA-D2 | Proposed definition | Trust | Relation, Entity, Direction, State, Action, Claim, Causal path, Exposure, Consequence, Control, Scope | `Trust` finite inhabitant |
| TA-D3 | Proposed definition | Alignment | Relation, Configuration, Presence, Specification, Scope, State, Transformation, Difference, Direction | `Alignment` finite inhabitant |
| TA-C1 | Anti-collapse constraint | Truth is not epistemic or institutional success | TA-D1, Evidence, Admission | `truthDoesNotEntailAgentAccess`, `claimAndRealityModelDoNotEntailTruth`; other joins gated by TA-G1 |
| TA-C2 | Anti-collapse constraint | Trust is not confidence, prediction, or authorization | TA-D2, Permission, Authority, Evidence | `trustDoesNotEntailConfidenceOrPermission`, `confidenceDoesNotEntailTrust`; other joins gated by TA-G2 |
| TA-C3 | Anti-collapse constraint | Alignment is profile-scoped correspondence | TA-D3, Identity, Truth, Trust, Permission, Authority, Persistence | `alignmentIsProfileScoped`, `alignmentDoesNotEntailIdentity`, `alignmentDoesNotEntailTruth`; other joins gated by TA-G3 |
| TA-C4 | Anti-collapse constraint | No Truth-Trust-Alignment collapse | TA-D1, TA-D2, TA-D3 | Finite cross-countermodels and open gates |
| TA-G1 | Open formalization gate | Complete Claim semantics and Reality bridge | TA-D1, Claim, Map, Reality | Open |
| TA-G2 | Open formalization gate | Trust contribution and profile dynamics | TA-D2, Causal path, Exposure, Evidence, Enforcement | Open |
| TA-G3 | Open formalization gate | Alignment profile composition and Persistence | TA-D3, Specification, Rule, Persistence | Open |

## Promotion boundary

This dossier records the promotion enacted in Organon v0.13:

- promote Truth, Trust, and Alignment with stable identifiers and exact dependencies;
- add three binding anti-collapse constraints preserving epistemic, relational, and profile boundaries;
- add an optional `correspondence-and-coordination` adoption profile;
- add corpus and intellectual-shadow provenance;
- keep confidence, prediction, value, purpose, and contribution as ordinary language rather than silently promoting them; and
- preserve TA-G1 through TA-G3 as explicit limits on formal and semantic completeness.

The dossier remains nonbinding provenance material. Promotion occurs only through the canonical single-file ontology and governed projections.
