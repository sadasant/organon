---
type: formal-ontology-spike
status: noncanonical
created: 2026-08-02
updated: 2026-08-03
prose_ontology: "../ontology.md"
---
# Daniel's Ontology - Lean Spike

This directory tests whether selected regions of [Daniel's Ontology v0.17](../ontology.md) can become a proof-checked Lean artifact. It is deliberately **noncanonical**. The single-file Markdown ontology remains the readable binding artifact until Daniel explicitly promotes a formal artifact after term-for-term parity, a complete model, clean builds without `sorry`, and a stable Markdown projection.

## Included in the spike

- An Absence-free [`OrganonCore`](./OrganonCore.lean) module containing relational Missingness and every downstream formal classifier. [`DanielOntology.lean`](./DanielOntology.lean) is a conservative extension that adds the local Absence/Presence shadow without redefining the core. The complete finite witness executable imports only the reduct; [the experiment report](./organon-core-reduct-report.md) and [109-term audit](./organon-core-term-audit.md) state the exact preservation result and its prose-parity limit.
- A local encoding of A1-A5 using an uninhabited-type predicate, `Nonempty`, and an inhabited `Mark`.
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

See [Formalization Decisions](./decisions.md) for commitments exposed by Lean and [Build Receipt](./build-receipt.md) for reproducible evidence.

The formal shadow models candidate conditions, Consciousness Attributions, and Order-indexed Consciousness Designations without defining a universal consciousness predicate. Its finite countermodels show that neither Attribution nor Designation entails candidate obtainment, and that candidate obtainment does not entail Designation. Designation remains institutionally dependent on an admitted Attribution. The artifact does not yet formalize evidentiary disposition.

## Canonicality boundary

The Lean source makes formal Claims. Successful elaboration by the pinned compiler is external Evidence that those Claims type-check. The theorem `presenceObtains` witnesses an inhabited mark inside Lean; the compiler receipt witnesses that the file itself was successfully elaborated. These levels must not be collapsed.

The OrganonCore split proves that the currently encoded downstream classifiers do not depend on the Absence extension. The falsification seam additionally preserves challenge classifiers for Presence, Missingness, Persistence, and Entity while rejecting an identity-breaking history in both interpretations. Reality's representation remains pending between an ambient metatheoretic domain and a universe-indexed projection; no local carrier is identified with Reality as a whole. The other 103 registered terms remain unknown; complete Markdown-to-Lean parity remains a promotion gate.

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
