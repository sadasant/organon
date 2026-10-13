---
type: formal-ontology-spike
status: noncanonical
created: 2026-08-02
updated: 2026-08-03
prose_ontology: "../ontology.md"
---
# Daniel's Ontology - Lean Spike

*First published August 2, 2026; last revised October 12, 2026. Noncanonical formal shadow.*

This directory tests whether selected regions of [Daniel's Ontology v0.21](../ontology.md) can become a proof-checked Lean artifact. It is deliberately **noncanonical**. The single-file Markdown ontology remains the readable binding artifact until Daniel explicitly promotes a formal artifact after term-for-term parity, a complete model, clean builds without `sorry`, and a stable Markdown projection. The v0.18 definition-admission strengthening of C1 is metalinguistic and is tested by the nonbinding algebra experiment rather than encoded as an object-language Lean term.

## Contents

- [Included in the spike](#included-in-the-spike)
- [Canonicality boundary](#canonicality-boundary)
- [Toolchain](#toolchain)
- [Build](#build)
- [Promotion gates](#promotion-gates)
  - [v0.20 promotion audit refinements](#v020-promotion-audit-refinements)
- [Bibliography](#bibliography)
- [Related entries](#related-entries)

## Included in the spike

- An Absence-free [`OrganonCore`](./OrganonCore.lean) module containing local-carrier Identity and Difference, relational Missingness and every downstream formal classifier. [`DanielOntology.lean`](./DanielOntology.lean) is a conservative extension that adds the local Absence/Presence shadow without redefining the core. The complete finite witness executable imports only the reduct; [the experiment report](./organon-core-reduct-report.md) and [117-term audit](./organon-core-term-audit.md) state the exact preservation result and its prose-parity limit.
- [`SetConfiguration.lean`](./SetConfiguration.lean) proves local membership extensionality and Configuration identity over both members and specified relational structure. Finite witnesses distinguish equal member Sets from unequal Configurations, preserve ordered participant roles, and allow external participants, isolated members and empty structure. The existing State wrapper retains this distinction without being retyped. The [dossier](../../proposals/set-and-configuration.md) records the correction to the earlier alias and the remaining interpretation and downstream-parity limits.
- [`IdentityMissingness.lean`](./IdentityMissingness.lean) proves equality laws, a classical Identity/Difference partition, and an exact-target Missingness equivalence without changing the existing record. Its asymmetric counterexamples distinguish lookalikes, wrong targets, target substitution, empty-field ambiguity and ordered configurations. A theorem about the existing Entity shadow shows that one Entity's history preserves its Invariant across unequal States. None of these results chooses empirical individuation or proves a field actually expects the supplied target. The [dossier](../../proposals/identity-and-missingness.md) and four typed contracts retain those limits.
- A [nonbinding representation-mediated bodily activity example](./RepresentationActivityExample.lean), included in the default build. General inverse conversions preserve the withdrawn Intention record as an existing Causal Contribution with bodily membership and an arbitrary State referent. The example proves referent independence and permits both result and non-result referents; it is not a replacement canonical term or a model of desire or goal pursuit.
- A nonbinding permission-coverage example in [`Model.lean`](./Model.lean), namespace `PermissionCoverageExample`: for one Permission, time, and resource Configuration, every scoped Action is individually exercisable. Operations costing one and two units each qualify with two units, but neither execution ordering can fund the other operation afterward. Three units fund both orderings; zero units fund neither, one unit funds only the cheaper operation, and a time outside the interval qualifies neither. This finite resource-feasibility projection is not a new term, a completed execution trace, or a full canonical encoding of Exercisability. Fully Exercisable Permission (D061) is retired.
- A local encoding of A1-A5 using an uninhabited-type predicate, `Nonempty`, and an inhabited `Mark`.
- Historical D112/D115/D116/D117 records and the old finite Attention/Care projections remain under `NonbindingExamples` in [`AttentionLoveCare.lean`](./AttentionLoveCare.lean). Full coverage and its Action-exclusion theorem concern that optional finite measurement, not revised Attention. Love is withdrawn, not renamed or given a mandatory composite definition.
- [`AttentionRevision.lean`](./AttentionRevision.lean) supplies eight bounded tests of directed persistent sensitivity, optional reciprocity, cessation, covariation rejection, and narrow focus. They run in the default build. Canonical Perception, Interpretation, Entity identity, Causal Contribution, uninterrupted persistence, and Care's Attention-to-Action join remain unproved. The schema-v2 contracts explicitly mark these unproved dependencies.
- [`CareRevision.lean`](./CareRevision.lean) supplies five bounded tests of response- and Specification-sensitive selection, opposite criteria, mistaken represented conditions, ignored criteria, and accidental success. Its current contract projects those operative input requirements, not the historical channel record. Canonical Attention, Action, Consequence, causal paths, and the same-Entity Specification target join remain open; no benefit, harm, or conscious-goal predicate is supplied.
- [`RespectRevision.lean`](./RespectRevision.lean) supplies seven bounded tests of expressed conditions overriding contextual defaults, implicit admission, participant and Scope joins, bounded accepted limitation, and actual versus planned intrusion. Its contract proves scoped condition resolution only. Canonical Entity, Action, Interpretation, condition provenance, consent, and causal regulation remain unproved. The old identity/option protection record is a nonbinding historical example, not current Respect.
- Separate placement-indexed Standing and same-index recorded Recognition. [`BridgeRelations.lean`](./BridgeRelations.lean) proves Recognition entails exact Standing, unrecorded Standing is possible, and a record alone need not supply either relation.
- [`InstitutionalRevision.lean`](./InstitutionalRevision.lean) retains the [approved institutional revision candidates](../../proposals/institutional-revision.md) as nonbinding tests in the default build: exact Order/Rule/conformity joins, Recognition-maintenance requirements, broad conditioning versus operative represented choice, and actual further Succession rather than mere capacity. Finite continuity does not certify unending survival. These tests do not replace canonical Authority or Standing; downstream migration and full institutional/epistemic parity remain open.
- [`EmbodiedConsciousness.lean`](./EmbodiedConsciousness.lean) retains a restricted temporal selection witness. `restrictedSelectionOrdersOutputs` proves that its rejected output precedes the selected output; Body membership also requires occurrence. Canonical D111 imposes neither requirement on rejection. EC-D5 and the dependent consciousness candidate therefore do not establish complete selection parity. Availability is exact declared membership, not demonstrated feasibility or computational constructivity.
- Explicit acknowledgement that `Empty` is an uninhabited type inside Lean's present metatheory, not absolute Absence.
- Typed Denotation, paired-path Causal Contribution carrying a named endpoint Change, constructive Capability realization, fully indexed Standing, and recorded in-Scope Evidential Bearing shadows from the [hidden-bridge audit](../hidden-bridge-audit.md). Finite witnesses show that Denotation need not be identity and supportive Evidential Bearing need not be Truth; Truth itself carries its exact Denotation join.
- Classical exhaustiveness of `Absent α ∨ Present α`, with the classical commitment visible in the theorem.
- State is the actual carrier of Direction, Transformation, Invariant, Boundary, and Entity; no object-level numeric index stands in for metalinguistic order.
- Transformation is indexed by Direction, making shared Direction a type-level fact for Causal paths.
- Constraint, Invariant, Boundary, Persistence, and Entity as dependent proof-carrying structures; every Entity carries an explicit directionally ordered history preserving its identity Invariant.
- Causal paths compose through an explicit `FeedRelation`; consecutive States need not be equal.
- Specification carries a Boolean decision procedure, a correctness proof, and scope coherence.
- Capability is parameterized by Context rather than treated as an intrinsic possession.
- Permission is produced through an Order-indexed chain of standing-aware claim, Authority, Grant, and Admission; exercise separately requires current Capability and absence of Revocation.
- Witness independence is scoped to witness, claimant, Claim, Observation, and Order, with mechanical non-control and institutional non-authority.
- One finite model admits an identity-preserving Transformation, rejects an identity-breaking one, evaluates a Specification, and inhabits Permission and PermissionExercise.
- A separate consciousness-proposal shadow distinguishes a candidate condition, its Specification, its Attribution, and an Order-indexed Consciousness Designation, with finite witnesses that Attribution and Designation do not entail candidate obtainment and that non-designation does not decide it.
- A finite Operationalization shadow joins a discriminating selection Rule, Interface, Scope, selected Transformation, and actual Causal-path membership. Countermodels show that this participation entails neither Map fidelity nor admission as Evidence.
- A finite World shadow carries nonempty participants and States plus distinct participant-bound access paths. Every path is nonempty, begins at its participant's current State, remains in Scope, and witnesses each advertised available State on an actual Transformation. Its model excludes one inhabited carrier State and lets two causal paths disagree without losing the shared Invariant; it does not formalize Reality.
- A finite Substrate shadow carries a source-Persistence witness with at least two directionally ordered States preserving one Invariant, plus nonempty Constraints, a scoped Causal path, and explicit Feeds witnesses. Its model separates ordered source Persistence from invariant-preserving outputs; carrier-to-content realization remains an explicit open gate.
- A finite Truth shadow requires a claim-indexed Denotation from the exact Representation to the Rule-Specification-Presence tuple used by constructive conformity while keeping Agent access separate. A proposal-local Dependence binds an other-supplied future Transformation to an actual Causal path, the canonical paired-path Causal Contribution, its named endpoint Change, and `dependentOutput`; Trust additionally requires admission through a Constraint maintained in the dependent Entity's Boundary. Shared countermodels show confidence plus involuntary Dependence without Trust, the same false Claim's Representation aligned under a profile, and one explicitly joined Claim-Trust-Alignment situation.
- One joined Agent-level Intelligence case constructs different Models and Interpretations for two States absent from an explicit Rule encoding, proves every Perception-to-Consequence seam load-bearing for the first, and produces conforming Consequences for both. Operative Knowledge requires a capable interpreter and forces an alternative Record to change Model, Interpretation, and Action while the effect can depend only on Action; the finite model separates it from Truth, dormant storage, and Intelligence under the same fully enumerating Rule. Knowledge Transmission reconstructs a conforming function across distinct stages while allowing different Records, Models, and either different or identical interpreter Agents; copied data alone supplies no recipient knowledge.
- Factive Operative Knowledge joins the exact Claim carried by an operative Record to Truth; Warranted Knowledge adds independently grounded and admitted Evidence with recorded, in-Scope supportive Evidential Bearing for that same Claim and proves that the Evidence claimant is the operative interpreter. Finite countermodels separate useful falsehood, inaccessible true Claims, factivity, and warrant.
- Moral Status Attribution and Moral Personhood Designation repeat the candidate-Claim-CountsAs seam without defining moral worth. Four separate sovereignty structures witness constituent exercise, maximal constituted Authority, effective Boundary Control with unequal outcomes, and Rule- and Scope-indexed external Recognition with own-Principal participation and explicit non-delegation. Preference, Utility Measure, Price, and institutional valuation remain separately satisfiable.
- Flow carries two distinct Transformation occurrences, a Scope containing every occurrence, one object-level recurrence predicate holding across the ordered list, and a `PersistenceWitness` whose State history is exactly the occurrence-output list. Flow contains no Rule or Specification. Separate `FlowClassification` owns the typed Rule, proves its Scope extensionally matches the Flow Scope, constructively classifies the selected occurrences together with their exact recurrence Relation, and rejects one in-Scope non-occurrence. A private Ritual carries that classifier and uses occurrence indices: every index has an exact participant-history access path, while every noninitial index has an uptake whose Memory source has a strictly earlier index. Each uptake proves its compared occurrences conform and recur, retains the prior contribution endpoint as Memory, contains the later Interpretation occurrence in the sustaining path, and constructively proves that changing either Perception or an admissible Memory changes the Interpretation result. `TargetContinuity` permits unequal target States while requiring one ordered Persistence history and Invariant. Meaning selects an actual Ritual uptake and proves its current contribution is direct support or begins downstream from the uptake's interpreted State. Its Relation contains a stable participant-identity index; a finite witness proves that equal current participant States do not erase relational nonidentity. The shadow does not yet type those local State roles as canonical Perception, Memory, or Interpretation, or construct represented-target Denotation.

- Body, Bodily Organization, Embodied Perspective, Recurrent Integration, and Internal Activity Selection have a finite [`EmbodiedConsciousness`](./EmbodiedConsciousness.lean) shadow. Body is a relation over an ordered nonempty subsequence of the Entity's Persistence States and has no separate identity. Bodily Organization requires pairwise distinct recurring Transformations for every pair of distinct named Organs. Embodied Perspective contains explicit Perception, persistent Memory, and Model projections joined to the advertised Differences, Causal Contributions, later States, Transformations, and Boundary Constraints. Exact part membership, transformation-family membership, selection, and same-Body joins determine the proposal-local candidate through `EmbodiedRecurrentAt`; there is no independent obtainment oracle. Five finite cases test the formalized anti-entailments. The speech, Action, complete-Control, Attribution, and Designation reverse anti-entailments are declared outside this Lean boundary rather than represented by proxy predicates.
- [`PromotionContracts`](./PromotionContracts.lean) restates every formally supported embodiment statement as a marked theorem with the exact advertised type. Every dependency of a proved schema-v2 statement has a checked formalized, represented, prose-only, or outside-boundary disposition. Any theorem with a prose-only or outside-boundary dependency is `proved_with_boundaries`; fully proved contracts may contain only formalized and represented dependencies. CI derives required symbols from that complete ledger and the subject symbols, rejects independent symbol whitelists, checks shared indices and direct `Prop` relations, and rejects source drift after adversarial review.

See [Formalization Decisions](./decisions.md) for commitments exposed by Lean and [Build Receipt](./build-receipt.md) for reproducible evidence.

The formal shadow models candidate conditions, Consciousness Attributions, and Order-indexed Consciousness Designations without defining a universal consciousness predicate. Its finite countermodels show that neither Attribution nor Designation entails candidate obtainment, and that candidate obtainment does not entail Designation. Designation remains institutionally dependent on an admitted Attribution. The artifact does not yet formalize evidentiary disposition.

## Canonicality boundary

The Lean source makes formal Claims. Successful elaboration by the pinned compiler is external Evidence that those Claims type-check. The theorem `presenceObtains` witnesses an inhabited mark inside Lean; the compiler receipt witnesses that the file itself was successfully elaborated. These levels must not be collapsed.

The OrganonCore split proves that the currently encoded downstream classifiers do not depend on the Absence extension. The falsification seam additionally preserves challenge classifiers for Presence, Missingness, Persistence, and Entity while rejecting an identity-breaking history in both interpretations. Reality's representation remains pending between an ambient metatheoretic domain and a universe-indexed projection; no local carrier is identified with Reality as a whole. The other 108 registered terms remain unknown; complete Markdown-to-Lean parity remains a promotion gate.

The formal spike does not yet cover the complete ontology, generate the Markdown projection, prove satisfiability beyond its small models, settle identity through time beyond a Boundary-indexed Invariant, connect proposal-local evidence and sovereignty predicates to every core institutional structure, define general consequence semantics, encode a complete Environment-Sense-Perception access path, define Map-to-World fidelity or a universal carrier-realization relation, define universal consciousness or moral-worth conditions, bridge toy truth targets to Reality, derive Trust contribution from Action, prove Interior-and-Boundary crossing, promote `dependentOutput` to canonical Consequence, or compose Alignment profiles. Local countermodel predicates prove only the stated anti-entailments without pretending to formalize those complete regions.

## Toolchain

- Project pin: `leanprover/lean4:v4.30.0`
- Verified local compiler: Lean 4.30.0, commit `d024af099ca4bf2c86f649261ebf59565dc8c622`
- Downloaded archive SHA-256: `072dca4a38fbc0d3cedb96fea886cc243b424f2bd16247596200b9a9ab93f0f5`

## Build

From this directory:

```sh
lake build
lake exe ontology_check
```

The local machine uses an Elan override named `organon-lean-4.30.0` because Elan's channel installer failed before extraction. The checked-in toolchain pin remains the standard portable identifier.

## Promotion gates

1. Every binding Markdown term maps to a Lean declaration or an explicitly metatheoretic statement.
2. No `sorry`, `admit`, or undeclared axiom remains.
3. At least one complete inhabited model elaborates.
4. Anti-collapse obligations are theorems or type-level impossibilities.
5. Markdown is rendered deterministically from Lean declarations and doc-comments.
6. The generated Markdown is readable in Obsidian and has stable internal links.
7. Daniel explicitly promotes Lean from experimental artifact to canonical ontology.

### v0.20 promotion audit refinements

`AttentionLoveCare.lean` preserves the historical finite measurement's positive denominator, bounded numerator, exact availability, and same-context snapshot comparisons. Its regression proofs still reject stale results, constant responses, mixed contexts, omitted qualifying channels, and duplicate counting. These are nonbinding example properties, not requirements of current Attention. The old sustained snapshots, target-Denotation construction, and exact-action identity protection also remain historical examples. Canonical causal/participant parity and empirical application remain gated.

`FocusIndependentAction` requires behavioral invariance, not merely failed organization. The nonempty declared causal domain must reproduce the current result under every response model, and switching the attended Representation to its contrast in the same context must leave that result unchanged. The partial Action follows a separate Boolean input; proofs vary both inputs independently. Reversed labels, a focus-sensitive alternative hidden behind an invariant selected response, an empty domain, and wrong or stale results cannot establish independence. The guarantee is relative to the named contrast and declared domain, not empirical completeness or universal independence.

`EntityIndividuation` receives only identity Invariant and Boundary. No admitted classifier can distinguish two records by history length, content, current State, or Direction alone. The former three-State prefix witness is rejected by the historical Respect/Love/Care examples. A replacement finite witness shares the actor's full history, current State, identity criterion, and constraint count, but differs in admission of an unrecorded Transformation; both Boundaries admit all recorded outputs. The behavioral classifier ignores duplicate constraints. Its classification is a local projection: equal classes do not prove one Entity, different Boundaries need not force different classes, and identity across Boundary changes remains an explicit canonical-parity gate.

## Bibliography

- de Moura, Leonardo, and Sebastian Ullrich. "The Lean 4 Theorem Prover and Programming Language." In *Automated Deduction – CADE 28*, 2021. [DOI](https://doi.org/10.1007/978-3-030-79876-5_37).

## Related entries

- [Formalization decisions](./decisions.md) and [build receipt](./build-receipt.md).
- [OrganonCore reduct report](./organon-core-reduct-report.md) and [term audit](./organon-core-term-audit.md).
- [Ontology completeness experiment](./ontology-completeness-experiment.md).
- [Daniel's Ontology](../ontology.md), which remains binding.
