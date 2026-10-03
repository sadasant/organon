---
type: ontology-proposal
status: ready-for-review
binding: false
created: 2026-10-03
---

# Ontological frameworks, distinctions, and source-relative novelty

This proposal makes eight of Daniel's developing concepts and his requested Interpretation/Understanding split available for review as precise English definitions and noncanonical Lean profiles. It addresses how a framework classifies reality at a particular granularity, what it can express, how competing access can become scarce, and how probability and source-link loss might describe actual processes. It does not conclude that every ontology is incomplete, socially effective frameworks are true, or all novelty consists in losing a source link.

Daniel requested one combined PR after reviewing these definitions. That requested review scope groups related concepts; it does not make them one ontological kind. Merging this dossier alone promotes none of its terms. The adopted ontology and registry remain v0.19.0.

Provenance is Daniel's Christias reading discussion: limited granularity and expressive frameworks; multidimensional scarcity and potentially illusory resource mappings; explicitly ontological probabilities; and actual differentiation through loss of a source signal. The definitions and formal encodings below are the assistant's proposed articulation, accepted by Daniel for incorporation into this review. They are not Christias's doctrine, a verified quotation, or proof that the proposed world-level interpretations hold.

## Interpretation and Understanding: requested split

Daniel explicitly requested this distinction after reviewing the original eight definitions. Within this nonbinding dossier the two capitalized names designate proposed meanings. The current adopted v0.19 `organon:Interpretation` still denotes practical orientation until a coordinated binding migration is approved and enacted. Do not apply the proposed semantic meaning to an existing v0.19 mapping.

<!-- organon:proposal-statement OF-D9 type=proposed_definition -->

### Interpretation

**Interpretation** is a scoped Relation assigning a Representation a target within a declared Configuration. The assignment names its Denotation and the context under which the expression is taken as concerning or applying to that target.

Interpretation concerns what a Representation means under a stated semantics. It does not itself require an Entity's Perception, Memory, practical orientation, or completed Action. A bare Denotation names an expression-target pair; Interpretation situates such assignments under an explicit context and Scope. The semantic use of “meaning” here is ordinary explanatory language, not a redefinition of Organon's ritual-dependent Meaning.

Lean represents this as a context-indexed assignment of expressions to exact Denotations within an expression Scope. A Classification names its expression and Interpretation; its membership condition is derived from that assignment's target. The framework projection proves that every active expression lies within its Interpretation's Scope and that the assigned target is exactly the advertised classifier. No independently assigned membership condition can silently disagree with the interpreted target.

<!-- organon:proposal-statement OF-D10 type=proposed_definition -->

### Understanding

**Understanding** is a Transformation joining an Entity's Perception, Memory, or Model to a distinction among available Actions.

Understanding concerns possibilities an Entity can distinguish from its situation. Distinguishing possibilities is not selecting or performing an Action; actual availability must remain answerable to the named Constraint context and constructive possibility witnesses. It need not involve an explicit verbal Representation or a semantic assignment in the modeled situation.

The Lean profile witnesses an orientation Transformation whose input and output lie in one Entity's ordered Persistence history. It names two distinct candidate possibilities in a declared Scope, a changed discrimination, and different discrimination responses at the output. The input kind is explicitly tagged Perception, Memory, or Model. These tags and candidate values are projections: full canonical Perception/Memory/Model ownership and Constraint-relative Action-possibility realization remain gates. Requiring a changed response makes this a local updating profile, not proof that every form of Understanding has this encoding.

No Action-producing event is a field of Understanding. A finite witness coexists with an explicitly empty execution Causal path, for which Lean proves no completed endpoint witness exists. This does not establish that no Action happens anywhere outside the declared trace.

## Candidate definitions

Definitions are ordered by dependency rather than their order in conversation. Numerical masses, inventories, conditions, and scale indices remain declared mathematical metalanguage. They have not silently become additional Organon primitives.

<!-- organon:proposal-statement OF-D1 type=proposed_definition -->

### Classification

**Classification** is a scoped Relation through which a Representation, under a declared Interpretation, groups targets according to a specified condition. Its Denotation and the classification condition must be named; membership applies only within the declared Scope.

Classification need not be exclusive, exhaustive, mechanically decidable, adopted, or enforced. Unlike Specification, it does not promise a constructive decision procedure. The Lean `Classification` structure records a Scope, an expression, its Interpretation, and confinement proofs. Its condition is derived from the exact Denotation assigned by that Interpretation. `classificationOf` extracts one active expression together with the same Interpretation from an `OntologyProjection`. The projection does not yet realize expression and predicate targets as canonical Presences.

<!-- organon:proposal-statement OF-D2 type=proposed_definition -->

### Ontological Framework

**Ontological Framework** is a Configuration of Representations, Constraints, and Rules that articulates classifications within a declared Scope. Its Denotations specify what its Representations concern; its Rules specify admissible applications and transformations under the Constraints.

Language, social adoption, institutional authority, and embodiment are possible additional structures, not requirements of this definition. A framework may classify its own representations; that alone proves neither contradiction nor completeness.

The Lean profile combines the classification projection with expression-rewrite conditions. An admissible rewrite requires active input and output expressions, a satisfied rule condition, and a satisfied constraint condition. These local predicates are not yet complete canonical Rule/Specification/Constraint objects, and an admissible rewrite is not an actual causal Transformation. The finite witness admits an identity rewrite; a separate countermodel blocks a rule-satisfying rewrite through its constraint.

<!-- organon:proposal-statement OF-D3 type=proposed_definition -->

### Granularity

**Granularity** is the pattern of distinctions a Framework's classifications preserve within its Scope. Two targets are indistinguishable under the framework when every available classification applies to both or to neither.

One framework is finer than another, over the same Scope, when every distinction the latter preserves is also preserved by the former. Granularity is not necessarily a number, and frameworks distinguishing different features need not be comparable. Comparisons hold for a fixed expression inventory and interpretation; changing either can change granularity.

Lean proves reflexivity, symmetry, and transitivity of classification-response equivalence, and reflexivity and transitivity of refinement. A finite counterexample proves refinement can be strict. The equivalence relation is mathematically defined on the carrier; ontological interpretation and comparisons are restricted to in-scope targets.

<!-- organon:proposal-statement OF-D4 type=proposed_definition -->

### Expressivity

**Expressivity**, relative to a declared family of conditions and a Scope, consists of the conditions a Framework's available Representations express exactly within that Scope. An expression represents a condition exactly when its classification applies precisely to the in-scope targets satisfying that condition.

Expressive completeness means every condition in the declared family has such an expression. An expressive limitation is a named member of that family for which no exact expression exists. Coverage, target separation, truth, decidability, and deductive completeness are separate questions.

Lean proves complete target separation can fail to supply an expression for the universal grouping. Existing witnesses demonstrate coverage without separation and a complete four-category framework over two targets. The countably indexed infinite-carrier obstruction concerns all predicates, not merely conditions definable in the same object language. Allowing composed expressions requires including those expressions in the inventory before assessing expressivity.

<!-- organon:proposal-statement OF-D5 type=proposed_definition -->

### Scarcity

**Scarcity** is a scoped constraint under which a nonempty collection of specified uses or accesses cannot all be jointly realized.

This is relative to demands and feasible realizations, rather than mere rarity or a free-standing quantity. The definition allows outright inaccessibility; the stronger competitive case additionally requires each demand to be individually feasible. Uses may have multiplicity: two demands for the same kind of access are not automatically one demand.

The finite Lean allocation projection declares a request Scope, admits an empty allocation, and confines feasible request lists to that Scope. Scarcity also requires all named demands to lie within Scope. Two requests fit individually into one slot but cannot fit jointly. The same requests fit under a two-slot model. Thus a represented one-slot allocation can disagree with actual two-slot feasibility. This countermodel compares allocation models for the same demands; it does not itself instantiate canonical Perception, resource ownership, Trust, or Authority.

<!-- organon:proposal-statement OF-D6 type=proposed_definition -->

### Ontological Probability

**Ontological Probability** is a probability assignment to specified possible outcomes under stated conditions, interpreted as belonging to the modeled process rather than merely expressing an observer's uncertainty.

Its mathematical assignment and its ontological interpretation are separate obligations. The proposed profile requires explicit conditions, an outcome domain, and normalized nonnegative probabilities. No Gaussian shape, determinism, or observer access is presumed.

The Lean structure implements only a finite rational-mass projection: distinct outcomes, natural-number masses, a positive common denominator, exact normalization, zero mass outside the inventory, and individual bounds. Probability values are exact numerator/denominator pairs; unreduced fraction pairs are compared numerically by cross-multiplication, not pair inequality. Finite witnesses assign 1/2 and 1/3 to the same outcome while preserving the same outcome inventory and unit condition index. Continuous distributions, arbitrary real-valued probabilities, conditional updates, and correspondence to an actual process are outside this shadow.

<!-- organon:proposal-statement OF-D7 type=proposed_definition -->

### Differentiation

**Differentiation**, in this source-relative proposal, occurs when a specified linking signal or Relation no longer obtains between a target Entity and its source, within a declared Scope and scale, although it obtained at an earlier State.

The formal projection requires distinct source and target indices, ordered before/after history positions, both participants in Scope at both positions, and the named link obtaining before but not after. It models loss of an ongoing link, not erasure of historical causal descent. Actual Entity identity, signal realization, and causal-path evidence remain gates. The target is already separately indexed in the model; this is not yet a construction proving the emergence of a new Entity.

The scale parameter is explicit, but no threshold of partial signal loss is selected. A finite history proves that the link may subsequently return. Source-relative differentiation at one interval therefore does not entail permanent disconnection or independence at every scale.

<!-- organon:proposal-statement OF-D8 type=proposed_definition -->

### Novelty

**Novelty**, under Daniel's proposed source-loss criterion, is the actual source-relative Differentiation specified above, rather than merely a newly available description or an observer's inability to recover an origin.

In this experiment `Novelty` is deliberately an alias of `Differentiation`. Their equivalence is definitional. It does not supply an independent test of novelty or a proof that all metaphysical novelty obeys this criterion. Autonomy is not substituted for Daniel's signal-loss proposal. Whether both names deserve stable registry terms remains open; this dossier preserves both for explicit review.

<!-- organon:proposal-statement OF-H1 type=hypothesis -->

## Hypothesis: source loss and full novelty

Daniel's stronger proposal identifies actual novelty with loss of the source relation. This is a philosophical hypothesis to assess, not a theorem inferred from the alias above. The formal model tests consequences of adopting that criterion for a specified link, scale, and interval. It does not establish that no other kind of novelty exists or that a lost signal creates a new Entity.

<!-- organon:proposal-statement OF-H2 type=hypothesis -->

## Hypothesis: process-grounded probability

Daniel intends probabilities belonging to reality. Normalized numbers alone do not establish that intention's truth in a particular case. Observations, independently supported Claims, and Evidential Bearing concerning the specified process would be needed. Agreement, usefulness, or social authority would not substitute for those joins. No physical probability law is asserted by this dossier.

## Termhood and dependencies

| Candidate | Proposed kind | Strongest existing reduction | Distinction retained / review outcome |
| --- | --- | --- | --- |
| Interpretation | Scoped Relation profile | Denotation | Adds the declared semantic context and expression Scope; no practical orientation follows. |
| Understanding | Transformation profile | The current v0.19 Interpretation definition | Preserves practical orientation under a distinct name; no completed Action or active semantic assignment is required by the projection. |
| Classification | Relation | Representation plus Denotation plus Scope | Adds scoped membership conditions; no decision-procedure promise. |
| Ontological Framework | Configuration profile | Configuration of Representations, Constraints, and Rules | Names a joined categorical organization; no new primitive is justified. |
| Granularity | Relation profile | Differences among classification responses | Names preserved distinctions and refinement; Scope alone is insufficient. |
| Expressivity | Relation profile | Exact Denotation of classifications | Names representable condition families; separation alone is insufficient. |
| Scarcity | Constraint profile | Constraint over jointly attempted realizations | Demand-indexed infeasibility; rarity and numeric capacity alone are insufficient. |
| Ontological Probability | Conditional mathematical profile plus world-level hypothesis | Representation of possible outcomes | Adds normalized numerical weights; world correspondence remains unproved. |
| Differentiation | Temporal Relation profile | Difference between source-link States | Names loss of one link under one scope/scale; full emergence remains unproved. |
| Novelty | Hypothesis-backed alias | Differentiation under the declared criterion | No independent termhood survivor yet; retain the requested name transparently. |

The manifest lists canonical lexical dependencies and earlier proposal-statement dependencies. `local:*` entries declare the mathematical boundary rather than licensing hidden ontology terms. Local conditions and histories must be instantiated; declaring dependencies alone creates no instance.

## Semantic inputs and boundaries

| Formal field | Disposition |
| --- | --- |
| `OntologyProjection.classifies` | Local category-membership input; canonical realization gated. |
| `Interpretation.assignment` / `.scope` / `.context` | Explicit scoped semantic assignment, with exact expression-position proof; complete canonical contextual realization remains gated. |
| `Classification.condition` | Derived from the exact interpreted target; not an independent semantic oracle. |
| `Understanding.differentiate` and its input-kind/candidate data | Local practical-orientation projections over an actual core Entity and Transformation; canonical cognitive inputs and Action possibilities remain gated. |
| `OntologicalFramework.rule` / `.constraint` | Local rewrite predicates; full Rule/Specification/Constraint realization gated. |
| `AllocationModel.feasible` | Local joint-realizability condition; actual constraint witnesses gated. |
| `SourceLinkHistory.scope` / `.links` | Declared scope and link history; actual Entity/signal/causal-path joins gated. |
| Scope-confinement, allocation-confinement, exact-Denotation, nonempty-inventory, normalization, bounding, and history-confinement fields | Mathematical proof obligations; not free obtainment predicates. |
| `OntologicalProbability.condition`, `.outcomes`, `.mass`, `.total` | Declared data indexed by a condition; process correspondence not inferred. |

## Evidence ledger

All theorem names below are in [`OntologyCompleteness.lean`](../ontology/formal/OntologyCompleteness.lean). Every theorem receives an axiom audit. A schema-v1 declaration mapping is not a schema-v2 promotion contract.

| Result | Checked evidence |
| --- | --- |
| Classification membership equals its interpreted target | `classificationConditionIsItsInterpretedTarget` |
| Assignment without practical orientation under an empty possibility Scope | `semanticAssignmentDoesNotSupplyPracticalUnderstanding` |
| Practical orientation without an active assignment in the supplied situation | `practicalUnderstandingNeedsNoActiveSemanticAssignment` |
| Fixed assignment with different orientation / fixed orientation with different assignment | `sameSemanticAssignmentAllowsDifferentOrientations`, `sameOrientationAllowsDifferentSemanticAssignments` |
| Understanding without completed execution endpoints in the declared trace | `understandingDoesNotRequireCompletedExecutionTrace` |
| Inhabited framework, classification, and rewrite | `finiteFrameworkHasClassificationAndRewrite` |
| A satisfied rewrite rule need not suffice | `ruleAloneDoesNotAdmitRewrite` |
| Granularity equivalence and refinement laws | `granularityReflexive`, `granularitySymmetric`, `granularityTransitive`, `finerReflexive`, `finerTransitive` |
| Refinement can be strict | `finerDoesNotMeanEquivalent` |
| Coverage is weaker than separation | `coverageDoesNotEntailSeparation` |
| Separation is weaker than full predicate expressivity | `separationDoesNotEntailPredicateExpressivity` |
| Local completeness is possible | `finiteOntologyCanBePredicateComplete` |
| Countable expressions cannot express all predicates on Nat | `countableExpressionsCannotExpressEveryPredicate` |
| Individual access can coexist with joint scarcity | `jointlyScarceDespiteIndividualAccess` |
| The same demands can be feasible; maps may disagree | `sameDemandsNeedNotBeScarce`, `scarcityMapCanMisrepresentFeasibility` |
| Normalization and outcome inventories do not determine a unique distribution | `normalizedProbabilitiesHaveDifferentValues` |
| Novelty uses the declared criterion | `noveltyUsesDeclaredDifferentiationCriterion` (definition only) |
| Source loss need not be permanent | `sourceLossDoesNotEntailPermanentDisconnection` |
| Body constraints underdetermine a named membership fact | `bodyConstraintsDoNotDetermineNamedMembership`, `soundBodyCalculusCannotDecideMembership` |

No theorem equates a mathematical carrier with Reality, assumes reality is continuous, or generalizes Gödel to every ontology. The diagonal proof is constructive; the finite arbitrary-predicate completeness result and Body interpretation results expose standard classical dependencies.

## Exact proposed migration of the adopted vocabulary

This table specifies the coordinated binding change for later promotion; the experiment implements and tests the distinction now without relabeling the adopted registry piecemeal.

| Current use | Proposed migration | Reason |
| --- | --- | --- |
| D034, `organon:Interpretation`: practical Transformation | Rename to `organon:Understanding`, preserving the practical definition and updating references | The existing operation differentiates available Actions. A changelog and versioned mapping migration must expose the identifier change. |
| New semantic assignment | Define `organon:Interpretation` separately, after Representation, Denotation, Scope, and the chosen context dependencies | This is a meaning change to a stable identifier, requiring a versioned release rather than a silent alias. |
| D035 Agent, D036 Agency, mechanical projection Pj1 | Use Understanding for orientation that conditions Action | Semantic assignment alone does not establish practical Agency. |
| D082 Operationalization, D083 World | Use Understanding where the current text concerns practical orientation; retain separately witnessed semantic Interpretation where a Representation is assigned a target | Causal use, semantic assignment, and world access remain different joins. |
| D088 Intelligence and C17 | Replace practical “Models and Interpretations” and the Perception/Memory–Model–Interpretation–Action chain with Understandings | Adaptive orientation is the operative condition; the semantic assignment can remain fixed. |
| D089 Operative Knowledge, D090 Knowledge Transmission, C18–C19 | Use Understanding for practical discrimination/reconstruction; preserve ordinary “interpreter” as a participant role unless separately typed | No arbitrary participant rename to “understander.” Semantic reconstruction may require an additional Interpretation join. |
| D105 Ritual, C25 and C31 | Split recurrence's semantic classifier from the memory-conditioned practical Transformation | Both occur in this region. Merely replacing every word would collapse the two operations again. Ritual still need not culminate in an outward Action. |
| Denotation and Representation anti-collapse explanations | Denotation alone supplies no Understanding, causal participation, or completed contextual Interpretation | A bare pair does not provide the entire scoped interpretation context. |
| `CognitivePipeline.interpret`, `interpretationFor`, `modelChangesInterpretation`, `interpretationChangesAction` | Rename the practical pipeline to `understand`, `understandingFor`, `modelChangesUnderstanding`, and `understandingChangesAction` | These fields construct practical orientation from Perception, Memory, and Model; their behavior is retained. |
| `RitualUptake.interpretation`, `interpretationRule`, `interpretedState`, memory/perception comparison fields | Separate its orientation Transformation as Understanding from the semantic `FlowClassification` | Source occurrence and causal-path joins must be retained, not replaced by an assignment function. |
| Model-theoretic Body “interpretations,” Constraint interpretations, and classifier semantics | Retain interpretation terminology | These are semantic structures or admitted models, not an Entity's practical Transformation. The `Determines` carrier is renamed `ModelInstance` to avoid shadowing the new structure name. |
| Registry, profiles, provenance, prompt, release, adoption mappings, formal receipts, exact-source reviews, and downstream generated audits | Regenerate and review together at binding promotion | This proposal does not bypass existing promotion contracts or silently rewrite historical releases. |

The two proposed definitions are related by possible mechanisms, not an identification: a semantic assignment may affect a Model and then Understanding; Understanding may motivate revising an assignment. Neither relation follows just because both profiles are present. No such cross-operation Causal Contribution is proved here.

## Intellectual shadows

The discussion arose during Christias reading, but these candidate definitions are not attributed to him. The Interpretation/Understanding distinction is Daniel's requested synthesis.

Alfred Tarski, [“The Semantic Conception of Truth and the Foundations of Semantics” (1944)](https://inters.org/files/tarski1944.pdf), §5 (p. 345) and §11 (pp. 352–353), supplies the semantic lineage: expression–object relations and recursive satisfaction. This motivates the assignment/satisfaction role; the article is not an adoption of Organon's proposed definition, nor a proof that assignment supplies every kind of meaning.

Martin Heidegger, *Being and Time*, §31, [pp. 184–185 in Macquarrie–Robinson](https://www.beyng.com/pages/en/BeingandTimeMR/BeingandTimeMR.185.html), treats Understanding as disclosure of possibilities through projection. Organon's generalization to Entity, Perception, Memory, Model, and Action is Daniel's operational formulation, not Heidegger's own definition for all entities. Heidegger's §32, [pp. 188–189](https://www.beyng.com/pages/en/BeingandTimeMR/BeingandTimeMR.188.html), calls the development of Understanding *Auslegung*. That hermeneutic “interpretation” is not identical to the Tarskian assignment adopted here. The two-lineage split is therefore an explicit synthesis rather than a terminological distinction borrowed unchanged from Heidegger.

 The nearby Sellars/Brandom discussion concerns learned classifications, reasons, and worldly correction; that comparison does not prove Daniel's scarcity or novelty proposals. Equivalence classes and refinement supply established mathematical machinery for granularity; predicate denotation and Cantor diagonalization supply the exact expressivity tests. Finite normalized mass assignments supply conventional probability mathematics, without settling an interpretation of physical probability. The finite feasibility examples express competing demands without adopting an economic theory of value or trust as fungible stock.

## Material decisions and failures

- Rebased the separate experiment onto the main merge of Body PR 16 before extension.
- Kept the combined scope at Daniel's explicit request; the original eight candidates and the Interpretation/Understanding split remain separately reviewable.
- Extended `FinerThan` to compare different expression types over the same target carrier, so a one-category and four-category framework can be compared without inventing expressions.
- Kept the broad Scarcity definition separate from its stronger individually-feasible competitive witness.
- Used exact finite rational masses and cross-multiplication; did not introduce approximate floating-point probabilities or claim support for continuous distributions.
- Made Novelty an explicit alias and recorded its stronger interpretation as a hypothesis. A reconnection countermodel prevents silently equating source loss with permanent autonomy.
- Initial compilation exposed a wrong proof argument, missing local decidability unfolding, and an overly restrictive shared-expression type in refinement. These were corrected semantically; the final checker rejects compiler warnings and proof placeholders.
- Added a dedicated CI workflow instead of changing the exact-source-pinned Body Lake file, workflow, or promotion-contract artifacts.
- Daniel requested separating semantic Interpretation from practical Understanding. Classification now derives its condition from an explicit Interpretation; no whole-repository search-and-replace was used. The exact binding migration is specified above and remains subject to the same promotion boundary as the original candidates.
- Formal orientation cases share one Entity and possibility Scope; paired situations hold semantics fixed while orientation changes, and vice versa. Primary Heidegger pages were retrieved directly when browser extraction failed; a Yale result was recognized as seminar notes and not substituted for the primary text.
- The host Python 3.14 lacked pytest and could not install the pinned LiteLLM version; used an isolated Python 3.12 environment with the unchanged repository requirements.

<!-- organon:proposal-statement OF-G1 type=open_formalization_gate -->

## Gate: canonical realization and promotion

Full Configuration/Representation/Rule/Constraint realization, category targets as Presences, complete semantic contexts, canonical Perception/Memory/Model-to-Understanding joins and Constraint-relative Action possibilities, actual allocation constraints, conditioned probability-to-process joins, Entity emergence, and source-signal Causal paths remain open. Binding promotion additionally requires termhood decisions, schema-v2 theorem contracts with complete dependency and semantic-field ledgers, adversarial review, exact-source receipts, and coordinated changes to the ontology and projections. This PR is ready for proposal review, not certified promotion-ready.

<!-- organon:proposal-statement OF-G2 type=open_evidence_gate -->

## Gate: social effectiveness and epistemic adequacy

The authority discussion is preserved as provenance: verbal or nonverbal distinctions can become operative, and perceived scarcity maps may be illusory. This module does not derive Authority, Recognition, CountsAs, or Trust from Scarcity, and does not derive Truth from shared use. It also does not prove their reverse anti-entailments: full canonical countermodels joining those regions remain outside this experiment. Those joins would be a distinct extension, not an implied consequence of these eight definitions.

## Statement registry

| ID | Type | Subject | Formal mapping |
| --- | --- | --- | --- |
| OF-D9 | proposed_definition | Interpretation | Interpretation |
| OF-D10 | proposed_definition | Understanding | Understanding |
| OF-D1 | proposed_definition | Classification | Classification |
| OF-D2 | proposed_definition | Ontological Framework | OntologicalFramework |
| OF-D3 | proposed_definition | Granularity | Granularity |
| OF-D4 | proposed_definition | Expressivity | Expressivity |
| OF-D5 | proposed_definition | Scarcity | Scarcity |
| OF-D6 | proposed_definition | Ontological Probability | OntologicalProbability |
| OF-D7 | proposed_definition | Differentiation | Differentiation |
| OF-D8 | proposed_definition | Novelty | Novelty |
| OF-H1 | hypothesis | Source-loss criterion of full novelty | Outside formal boundary / open gate |
| OF-H2 | hypothesis | Probability belongs to the modeled process | Outside formal boundary / open gate |
| OF-G1 | open_formalization_gate | Complete canonical realization and promotion contracts | Outside formal boundary / open gate |
| OF-G2 | open_evidence_gate | Authority and epistemic adequacy remain separate | Outside formal boundary / open gate |

## Verification and review

Run `python3 scripts/check-ontology-frameworks.py` from the repository root, alongside the standard repository checks in [CONTRIBUTING](../CONTRIBUTING.md). The checker builds the formal shadow, compiles the experiment, and audits all theorem dependencies against Lean's standard axioms. A dedicated CI job repeats it on the PR.

Review the English definitions before their implementation choices. In particular: whether source-relative Novelty warrants a separate term; whether the broad scarcity definition should include singleton inaccessibility; and what would count as evidence for process-grounded probability. Those are review questions, not unresolved compiler errors.
