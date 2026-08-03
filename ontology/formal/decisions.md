---
type: formalization-decisions
status: noncanonical
created: 2026-08-02
updated: 2026-08-03
prose_ontology: "../ontology.md"
---
# Formalization Decisions

These decisions belong to the Lean spike. They expose choices priced by formalization. They do not independently revise [Daniel's Ontology v0.15](../ontology.md); accepted findings flow into the binding, single-file Markdown ontology through its changelog.

## Absence is not `Empty`

`Absent α := α → False` is a local shadow inside Lean's already-present metatheory. It proves that a type has no inhabitants. It is not absolute Absence, which cannot become an object inside a formal system without contradicting its definition.

## OrganonCore is an Absence-free conservative reduct

`OrganonCore.lean` contains relational Missingness and all downstream formal classifiers without declaring or importing `Absent`, `Present`, or the performative mark. `DanielOntology.lean` imports that module and adds the local Absence/Presence experiment without redefining core structures. Every classifier module and the complete finite witness executable compile against `OrganonCore` alone.

`OrganonCorePreservation.classificationPreserved` is definitionally true because extension semantics cannot be inspected by a core classifier. This establishes classification preservation for the current formal shadow and refutes the claim that those classifiers require Absence merely because the declarations previously occupied one file. It does not establish preservation for unformalized prose terms. The binding ontology has 104 registered terms; term-for-term formal parity remains necessary before the result can be generalized to the complete ontology.

The first falsification seam does more than inspect imports. `OrganonCoreChallenge` supplies challenge classifiers for Presence, Missingness, Persistence, and Entity. An adversarial identity-breaking history is rejected while a preserving ordered history is admitted. A local-Reality equivalence is proved but not promoted to preservation: one universe-relative carrier is not the totality of all Presence. Reality may instead remain ambient and metatheoretic or receive a universe-indexed projection; choosing between those representations belongs to the binding canonicalization follow-up. The generated registry audit therefore records four proved challenge classifications, one pending representation decision, one deliberately excluded primitive, and 98 unknowns. Unknown is binding: a compiled shadow without exact prose parity is not counted as a preserved term.

## Presence is type-relative

`Present α := Nonempty α` says that a particular type has an inhabitant. It does not yet encode Reality as the totality of every Presence.

## A3 currently commits to classical logic

Exclusivity is constructive. Exhaustiveness for an arbitrary type requires excluded middle in this encoding. The declaration makes that commitment locally visible with `classical`, and the binding ontology names classical logic in its metalanguage rather than presenting A3 as neutral.

## A4 has two evidence levels

`presenceObtains` is an object-level witness: the declared `Mark` has an inhabitant. Successful compilation is metatheoretic Evidence that the source file occurred and elaborated. Compilation does not turn the compiler into an object-level premise.

## A5 represents Missingness positively

`Missingness α` contains a Field, an expected inhabitant, and proof that the Field omits it. A value of this structure is itself present. Missingness therefore cannot collapse into the uninhabited-type predicate used as Absence's local shadow.

## Direction internalizes ordering

`State` is the object-level carrier used by all later machinery and has no numeric index. Declaration order remains metalinguistic. `Direction.before` is the first-class asymmetric Relation, and `Transformation direction` carries that Direction as a type parameter. A `CausalPath direction feeding` therefore shares one Direction and composes through an explicit `FeedRelation` without requiring equality between adjacent States.

## Specification carries constructive content

Classical `conforms x ∨ ¬ conforms x` is available for every predicate and therefore cannot distinguish a Specification. `Specification.decideConformity : α → Bool` instead carries an executable decision interface, while `decision_correct` connects the result to the proposition and `conformityWithinScope` prevents out-of-scope conformity. Lean still permits noncomputable definitions to inhabit such a field, so concrete evaluation in the finite model is part of the receipt.

## Identity remains parameterized and Persistence is explicit

An Entity supplies an identity Invariant, a Boundary proving that admitted Transformations preserve it, and an explicit directionally ordered Persistence witness whose States all satisfy that same Invariant. Lean checks the dependency, history, and preservation proof. It does not choose which Invariant genuinely constitutes an Entity's identity. The stronger record repairs an earlier shadow that established only present identity and possible Boundary preservation without selecting the ordered history required by the prose.

The current `PersistenceWitness` requires at least two States and therefore at least one transition. This reads “across an ordered sequence” as a non-vacuous preservation obligation. It is a surfaced formal commitment, not a theorem forced by the prose; a later parity review may weaken it if singleton Persistence must classify positively.

## Empty Boundary means maximal obligation

Boundary Constraints are conjunctive admission conditions. An empty list admits every Transformation, so the preservation proof must establish the identity Invariant for every Transformation. The theorem `emptyBoundaryRequiresUniversalPreservation` exposes this consequence. Constraint-poverty is maximal obligation, not proof-free openness.

## Permission is Order-indexed and does not imply Capability

`Permission` is admitted by an `InstitutionalOrder` from a standing-aware `PermissionClaim`, an authorized `Grant`, and the Order's admission judgment. It contains no Capability field. A Principal may authorize Actions that an Agent cannot currently perform. `PermissionExercise` separately names one Action and requires current contextual Capability, admission at the exercise State, and no applicable Revocation. This prevents the institutional layer from collapsing into the mechanical one in either direction.

## Independence is scoped, not intrinsic

`IndependentFor` is parameterized by Witness, claimant, Claim, Observation, and Order. It requires both absence of the claimant's mechanical control over the Witness and absence of institutional Authority over the Witness for the relevant Claim. The accompanying admissibility provenance records which Rule and Declaration made the judgment operative. Independence is therefore not an enduring property of a Witness in isolation.

## Consciousness discourse is formalized without a consciousness axiom

The consciousness proposal separates `CandidateCondition`, its `Specification`, `ConsciousnessAttribution`, and `ConsciousnessDesignation`. Attribution carries a Representation, independent Claim Scope, Language, meaning Rule, Reference Map, and checked first-person or third-person perspective without carrying a proof that the candidate obtains. Designation is one Order-indexed counting event; `DesignationOrder.countingRequiresAdmission` derives Admission from that event instead of storing an unrelated admission Claim. The finite witnesses establish only the named anti-entailments: Attribution does not entail candidate obtainment, Designation does not entail candidate obtainment, and non-designation does not decide candidate obtainment.

The formal artifact does not encode an evidentiary disposition. Such a structure remains blocked until Evidence is joined to Observation, scoped Witness independence, admissibility provenance, and a declared evaluation Rule whose proved result supplies the disposition.

## Relations use typed structures, not one universal relation type

Direction, Transformation, Boundary, Capability, and Permission have different arities and dependencies. The spike encodes each with the narrowest useful record. A later parity pass must decide whether the ontology benefits from a common first-class Relation interface or whether that abstraction would erase important types.

## Operationalization requires semantic discrimination

A representational carrier merely occurring in a Causal path is insufficient. `Operationalization` joins a Representation to a selection Rule, an Interface, a Scope, a selected Transformation, and proof that the Transformation occurs in the path. It also requires an in-scope alternative Representation for which the same Rule does not select that Transformation. The alternative witnesses that representational Difference, rather than only the carrier's physical presence, matters to selection.

The finite model proves the exact negative results claimed by C11: an inhabited Operationalization need not satisfy a fidelity predicate and need not be admitted as Evidence; even the selected Transformation reaching its output does not establish Evidence. These are countermodels to entailment, not definitions of Map fidelity, Evidence admission, or Consequence. Full joins to those ontology regions remain open formalization gates.

## World requires distinct access and a common Invariant

`World` is not encoded as an alias for a list of States. It carries nonempty participants, scoped States, distinct `AccessPath` values, and one Invariant proved for every World State. Each AccessPath carries its own nonempty Causal path, begins at its participant's current State, remains within the World Scope, and must locate every advertised available State at an input or output of an actual Transformation. This prices two commitments hidden by the ordinary word: access is participant-indexed and causally witnessed, and a World Claim requires more than one private Perception.

The finite model contains active and standby States while excluding the inhabited broken State from the World's Scope. One path reaches active and another reaches standby from the participant's current idle State; the paths therefore need not agree on availability even though both World States satisfy the common operational Invariant. This proves non-universal Scope over one carrier type and non-identical causal access. It is not a formalization of Reality or proof that the named Invariant uniquely identifies a World.

## Substrate is contextual; realization remains open

`Substrate` carries its Scope, an ordered source-Persistence witness, Constraints, Causal path, and explicit Feeds witnesses. `PersistenceWitness` requires at least two States, proves their order under one Direction, and proves one Invariant throughout that sequence. An earlier shadow used only pointwise satisfaction over an unordered list; that was rejected because it did not meet Organon's definition of Persistence. An earlier shadow also carried an arbitrary content value and a free `supports` predicate. That field was rejected as decorative because any predicate could inhabit it and therefore proved no realization or reduction relation.

The finite Substrate supplies the ordered idle-then-active source sequence to an activation-then-break path. The sequence preserves the operational Invariant and every Transformation is admitted by the named Constraint, yet the final output violates that Invariant. This proves only that ordered source Persistence does not entail preservation of the same Invariant in every supported output. Every carrier-to-content, supervenience, emergence, or realization Claim remains outside the formal boundary until Organon defines a proof-bearing realization relation.

## Truth separates correspondence from epistemic access

`TruthSemantics` maps each toy Claim to its Representation, meaning Rule, constructive Specification, target, and Scope inside a proposal-local reality model. `isTrue` additionally requires `materiallyAdequate` for that exact Claim-Representation-Rule-Specification-target tuple and Scope membership before target membership and conformity. An earlier draft allowed arbitrary assignment functions to manufacture Truth from a convenient validator; the per-instance semantic join was added because successful validation alone is not correspondence.

`EpistemicAccess` remains separate, so the finite model proves one materially adequate Claim true while no modeled Agent can supply its target. The model does not provide a universal natural-language semantics, unique Claim interpretation, or bridge from `targetInRealityModel` to Reality as the totality of Presence. Those remain explicit gates. A constructive Specification can decide conformity when given its target even when no Agent can access that target; computational decidability and epistemic availability therefore remain separate commitments.

## Intelligence requires a witnessed adaptive Difference

`CognitivePipeline` composes Perception, Memory, Model construction, Interpretation, Action selection, and Consequence production. The `AdaptiveRule` owns both that pipeline and a `RuleEncoding` containing the States individually named by the supplied Rule Representation. `JoinedAdaptiveCase` places two non-enumerated States, their actual Model and Interpretation Differences, both conforming Consequences, and every counterfactual seam into one witness. For the first State, Perception and Memory each alter Model construction, Model alters Interpretation, Interpretation alters Action, and Action alters Consequence. Fixed code is not excluded: the formal object is itself a fixed function. Non-enumeration is proved relative to the supplied explicit encoding; completeness of that encoding against a deployed executable remains an open evidence gate rather than a theorem.

## Operative Knowledge is configurational and non-factive

`OperativeKnowledge` is indexed by an `InterpretiveContext`; its interpreter must satisfy the context's capability predicate. Each instance carries one Rule through Model, Interpretation, and Action functions. Replacing the Record with its in-Scope alternative must change the Model, Interpretation, and selected Action under that Rule. `effectFrom` receives the selected Action but not the Record, preventing a Record-to-effect bypass. The finite witness deliberately uses a false `ToyClaim` that still produces local success, proving that this promoted operative sense does not silently absorb Truth. Its exact Rule individually names every toy State, so no `JoinedAdaptiveCase`—and therefore no Intelligence using that Rule—can be inhabited. The same Record type in a context with no capable interpreter cannot inhabit Operative Knowledge. The context predicate remains a local shadow rather than a fully joined Organon `Capability`, which is an explicit gate.

## Knowledge Transmission preserves specified function, not representation identity

`KnowledgeTransmission` takes inhabited source and recipient Operative Knowledge as parameters. Their stages must differ, but their interpreter Agents need not. A medium must be encoded from the source Record, the recipient Record must be reconstructed from that medium, and one constructive Specification must accept the two realized effects. One finite witness changes both Record and Model across different Agents while preserving success; another performs the same reconstruction across two stages of one persistent Agent. This establishes the anti-copy and self-transmission seams but not temporal ordering, universal semantic equivalence, transitivity, or a canonical encoding.

## Factivity and warrant are cumulative structures

`FactiveOperativeKnowledge` takes an inhabited `OperativeKnowledge` instance, a `RecordClaimSemantics` join proving which exact Claim its load-bearing Record carries, and `TruthSemantics.isTrue` for that Claim. This prevents a convenient true Claim elsewhere in the Configuration from factivizing an operative falsehood. The finite model reuses the v0.14 accurate and mistaken operative paths: the accurate path inhabits the factive structure, while the mistaken path cannot do so under the equality-based carrier. A true Claim paired with the dormant interpreter context still cannot inhabit Operative Knowledge.

`WarrantedKnowledge` adds an `EvidenceAdmission` for the factive instance's exact Claim. The Admission joins claimant, Evidence, Observation, Witness, Order, Rule, support, scoped independence, and institutional acceptance; `claimantMatches` additionally proves that this claimant is the interpreter of the operative instance. Evidence independent for one Agent therefore cannot warrant another Agent's instance merely because the Claim matches. An open finite evidence system inhabits the structure; a system whose Admission predicate is false cannot. The local predicates shadow Organon's complete Evidence machinery rather than replacing it. Deriving them from the core `IndependentFor`, `AdmissibilityRuleProvenance`, and a future canonical Evidence structure remains a parity gate.

## Moral status repeats the candidate-Claim-Designation seam

`MoralCandidateCondition` remains separate from its executable Specification. `MoralStatusAttribution` carries the candidate, Representation, Claim Scope, Language, meaning Rule, and checked perspective. `MoralPersonhoodDesignation` is one event under a `MoralDesignationOrder`, whose counting predicate implies Admission for the same Attribution, purpose, Rule, and Scope. The finite negative candidate can be attributed and designated without obtaining; the same silent Order leaves both an obtaining and non-obtaining candidate undesignated. No universal moral predicate or moral-worth relation is introduced.

## Sovereignty is four independently witnessed profiles

`SovereigntySemantics` exposes the predicates used by four structures instead of assigning one Boolean sovereign flag. Constituent Sovereignty requires persistent constituent power and an actual constituting exercise. Constituted Sovereignty requires Standing and Authority across an inhabited Action Scope plus absence of a recognized superior under the declared comparison. Boundary Sovereignty requires scoped controlled admitted and blocked crossings, explicitly unequal unenforced and enforced outcomes, and an Order-indexed enforcement Difference between them. External Sovereignty carries its Rule, Standing, an inhabited Action Scope containing the representative Action, Recognition by a distinct Order, participation by the target as its own Principal, and explicit exclusion of `ActsFor` relations to every distinct Principal for that Action. One combined finite world proves compatibility, while four profile-only worlds each inhabit exactly one structure and make the other three uninhabitable. Those are the pairwise non-entailment countermodels. The shadow does not yet derive these local seams from the core `Principal`, `ActsFor`, Order, Authority, Control, and Enforcement machinery; those realization joins remain parity gates.

## Valuation separates ordering, measurement, recording, and counting

`Preference` carries an Agent-indexed asymmetric ordering and an actual ordered pair. `UtilityMeasure` carries an executable Specification and a Map into an asymmetric measure order; correspondence to Preference is deliberately absent. The flat utility witness fails to represent the inhabited Preference, and a separate model has a Utility Measure while its Agent-preference predicate is false. An observed choice can also select the deferred option while the Preference remains inhabited. `Price` joins a Ledger Record, Order Admission, and stated exchange condition, while separate false predicates witness that neither exchange nor moral worth follows. `InstitutionalValuation` is encoded only as the proposal-local CountsAs projection; it is not promoted as a new term. Numerical arithmetic, core Action-to-choice attribution, revealed preference, market clearing, and moral worth remain outside the formal boundary.

## Trust is accepted Dependence, not involuntary vulnerability

`Dependence` carries two distinct Entities, a nonempty Causal path, a future Transformation on that path, a proposal-local contributor assignment identifying the other Entity, the Transformation's output as `dependentOutput`, and proof that the dependent Entity does not determine it. `Trust` extends that structure with `Dependence.isAccepted`: at least one Constraint maintained in the dependent Entity's Boundary permits the contribution. An earlier draft omitted acceptance, so ransomware and unavoidable hazards satisfied every formal Trust field; separating Dependence from admitted Dependence closes that collapse.

The shared finite model contains one accepted Dependence and one involuntary Dependence. The same unwilling principal and delegate satisfy confidence and causal Dependence while acceptance is impossible because the principal's Boundary maintains no Constraint. The accepted Trust independently carries neither confidence nor Permission.

The remaining gaps are exact rather than hidden: the core Lean ontology does not yet formalize Action attribution to an Entity or Interior membership crossing a Boundary, so the contributor assignment is not derived from Agency and `dependentOutput` is a State rather than D033 Consequence. Action attribution, Exposure, and Action-to-Change Consequence remain open gates.

## Alignment is conformity instantiated, not Specification possessed

`AlignmentProfile` carries a constructive Specification over ordered subject-target pairs. `Alignment` requires a particular pair and a proof that it conforms. It does not use Organon's `Direction`, which orders States asymmetrically; ordered participant roles do not imply temporal order or asymmetric conformity. The finite model aligns one subject to a distinct target under one profile while rejecting the same pair under an incompatible profile, so the anti-identity result uses actual inequality rather than a free identity predicate.

The false-Claim countermodel uses the exact Representation assigned to the same `ToyClaim.mistaken` whose materially adequate truth condition fails. `JointSituation` then connects one accurate Claim to the trusted contribution that carries it and to an Alignment whose subject is that Claim's Representation. These replace earlier cross-model conjunctions over unrelated participants. The model still does not prove composition among behavioral, representational, incentive, or authority profiles or connect an Alignment target to Reality.

## Scope of the spike

The spike formalizes A1-A5 and selected high-risk dependency regions. Its finite models construct one concrete Entity with an admitted preserving Transformation and a rejected identity-breaking Transformation, one standing-aware Permission and one contextual PermissionExercise, one Consciousness Designation whose candidate does not obtain, one discriminating Operationalization whose selected Transformation occurs in a Causal path, one scoped World with distinct access, one contextual Substrate with explicit feeding and constraint witnesses, one true Claim without modeled Agent access, one causally bound Trust, one profile-scoped Alignment, one joined adaptive Intelligence, three instances of Operative Knowledge, one inter-agent Knowledge Transmission, one self-transmission, factive and warranted operative profiles, moral Attribution and Designation, four noncomposing sovereignty profiles, and separate preference, utility, Price, and institutional-valuation witnesses. Silent or negative structures supply countermodels for the named anti-entailments. The spike does not yet cover all derived terms, relation signatures, anti-collapse rules, underlying quarantined conditions, or deterministic Markdown rendering. Those remain promotion gates rather than implicit Claims of completeness.
