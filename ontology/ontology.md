---
type: editorial-ontology
status: provisional-binding
binding: true
version: 0.18
created: 2026-08-01
updated: 2026-08-09
evidence_scope: "Daniel's adopted commitments and the recovered essay corpus"
corpus_audit: "../provenance/essays.md"
term_registry: "terms.yaml"
companion_grammar: "../editorial/long-form.md"
delivery_language: "../editorial/short-form.md"
---
# Daniel's Ontology

> [!important] Binding ontology
> For work governed by Organon, a term explicitly mapped to a stable `organon:*` identifier retains the meaning defined here. Capitalization is presentation, not adoption. A quarantined term carries no binding ontological meaning.

## The closure boundary

No ontology can define every word using only itself. Definition requires a metalanguage. This document therefore states its boundary instead of hiding it.

The metalanguage supplies classical logic, including excluded middle, together with identity, negation, logical consequence, quantification, ordering, set membership, statements and marks, and the ability to distinguish an expression from what it denotes. Identity includes criteria for reidentifying what a statement treats as the same across ordered positions. An Entity claim must project that criterion into the object language by naming an Invariant, ordered States, and a Persistence witness; metalinguistic identity does not supply that witness.

The metalanguage also supplies relative possibility as satisfiability under stated Constraints: a candidate is possible only when at least one declared interpretation of those Constraints admits it. Every binding use of “can” or “possible” must name that Constraint context and a constructive witness. Relative possibility is not an additional Presence, a prediction that an event will occur, or unrestricted metaphysical modality.

These are rules for stating the ontology, not additional kinds of being inside it. The metalinguistic distinction between expression and target does not itself establish a Denotation in Reality; object-language Denotation is defined below. Likewise, identity criteria and relative possibility do not silently supply Entity, Capability, causal, evidentiary, or institutional facts.

Within that boundary, every registered ontological term is either the primitive, an axiom concerning the primitive, a dependency-ordered definition, or a quarantined term with no binding meaning yet. Ordinary connective language and unmapped capitalization carry no independent ontological commitment.

## Claim typing and stable identity

The binding semantic seam is the registry in [terms.yaml](./terms.yaml). Each term has a stable `organon:*` identifier, a stable anchor, a claim identifier, a claim type, and explicit dependencies. Definitions, axioms, binding constraints, hypotheses, and authorized projections are distinct claim types; prose proximity does not promote one into another.

The Markdown remains the readable binding statement. The registry makes its identity and dependency structure mechanically inspectable. A downstream repository adopts only the terms it maps explicitly through an [adoption manifest](../schemas/organon-adoption-schema.json); matching words alone do not create conformance.

## Primitive and axioms

### Primitive: Absence

<a id="organon-absence"></a>
<!-- organon:term organon:Absence claim=P1 -->

**Absence** is absolute. It is not an empty region, an omitted item, an unavailable value, a zero, a shadow, a silence, or the absence *of* something. Each of those is already something represented within a field.

<!-- organon:claim A1 -->
### Axiom A1: Absence has no interior

Absence contains nothing: no quality, part, distinction, relation, position, boundary, order, or duration. Nothing can be inside it, outside it, before it, after it, or related to it as one being relates to another.

<!-- organon:claim A2 -->
### Axiom A2: Absence is exact

Absence admits no degree or approximation. Only what is identically Absence is Absence. “Almost Absence,” partial Absence, and qualified Absence are not Absence.

<!-- organon:claim A3 -->
### Axiom A3: Absence and Presence are exhaustive and exclusive

<a id="organon-presence"></a>
<!-- organon:term organon:Presence claim=A3 -->

**Presence** is whatever is not identically Absence.

For anything considered by this ontology, exactly one of two conditions obtains: it is identically Absence, or it is Presence. Nothing is both, and there is no third condition.

This is a partition, not an event or causal derivation. Presence is defined contrastively by non-identity with Absence. That contrast belongs to the metalanguage; it does not thereby place Absence inside an association among Presences.

Exhaustiveness is a classical commitment. Constructively, a candidate may be neither known to be Absence nor known to be Presence. A3 excludes that epistemic third condition by adopting excluded middle in the metalanguage; exclusivity alone does not require it.

<!-- organon:claim A4 -->
### Axiom A4: Presence obtains performatively

If anything is stated at all, that statement is not identically Absence; by A3, it is Presence. This ontology is itself a statement and a mark. Therefore Presence obtains.

The ontology does not derive a mark from Absence. The occurrence of the mark witnesses Presence performatively. The relevant precedent is Spencer-Brown's instruction to “draw a distinction”: the distinction is demonstrated in its drawing rather than produced as a consequence of the unmarked state.

Absence and Presence exhaust the ontology. Presence necessarily obtains given that anything is stated at all.

<!-- organon:claim A5 -->
### Axiom A5: Missingness is not Absence

<a id="organon-missingness"></a>
<!-- organon:term organon:Missingness claim=A5 -->

**Missingness** is a relation inside Presence: a field represents or expects a Presence that it does not contain. Gaps, omissions, zeros, shadows, exceptions, refusals, and silences can be present signs of Missingness. They are not Absence itself.

Missingness is relational. Presence is contrastively defined. Absence is absolute.

## Dependency-ordered definitions and commitments

The definitions below are dependency-ordered. A definition may depend on the metalanguage, the primitive and axioms, or terms already defined above it.

### 1. Reality

<a id="organon-reality"></a>
<!-- organon:term organon:Reality claim=D001 -->

**Reality** is the totality of Presence. No part of Reality is licensed to identify the portion available to it with Reality as a whole.

`World` and `substrate` are not synonyms for Reality. Their uses are restricted below.

### 2. Difference

<a id="organon-difference"></a>
<!-- organon:term organon:Difference claim=D002 -->

**Difference** is the non-identity of two Presences or two ordered configurations of Presence. Difference is inside Reality; the defining departure of Presence from Absence belongs to the metalanguage and must not be mistaken for an ontological relation involving Absence.

### 3. Relation

<a id="organon-relation"></a>
<!-- organon:term organon:Relation claim=D003 -->

**Relation** is a Presence in which two or more Presences have an ordered association. A relation does not erase the differences among its participants.

<a id="organon-denotation"></a>
<!-- organon:term organon:Denotation claim=D102 -->

**Denotation** is an ordered Relation whose first participant occupies an expression position and whose later participant is the Presence, Relation, or Configuration that is its target. A Denotation must name both participants and their ordered positions. It establishes neither fidelity, Truth, Interpretation, institutional status, nor participation in a Causal path.

### 4. Configuration and state

<a id="organon-configuration"></a>
<!-- organon:term organon:Configuration claim=D004 -->

**Configuration** is a set of Presences and Relations considered together.

<a id="organon-state"></a>
<!-- organon:term organon:State claim=D005 -->

**State** is a Configuration indexed at a position in the metalanguage's ordering. That position distinguishes States without adding a Relation to Reality.

<a id="organon-direction"></a>
<!-- organon:term organon:Direction claim=D006 -->

**Direction** is a Relation between States such that, when it orders one State before another, the same Relation does not order the second State before the first.

Direction internalizes as Presence an asymmetry that the metalanguage can state without adding it to Reality; it does not duplicate the metalanguage's indexing order.

### 5. Transformation and change

<a id="organon-transformation"></a>
<!-- organon:term organon:Transformation claim=D007 -->

**Transformation** is a Relation mapping an input State to an output State under a Direction.

<a id="organon-change"></a>
<!-- organon:term organon:Change claim=D008 -->

**Change** is the Difference between States joined by a Transformation.

<a id="organon-feeds"></a>
<!-- organon:term organon:Feeds claim=D009 -->

**Feeds** is a Relation from one State to another under an explicit account of which part of the first State supplies which part of the second. Feeds does not require equality between those States.

<a id="organon-causal-path"></a>
<!-- organon:term organon:CausalPath claim=D010 -->

**Causal path** is a sequence of Transformations sharing one Direction in which the output State of each Transformation Feeds the input State of the next. Its arrow is inherited from the Direction of its Transformations; reversing the sequence does not preserve the same Causal path.

<a id="organon-causal-contribution"></a>
<!-- organon:term organon:CausalContribution claim=D103 -->

**Causal Contribution** is a Relation established by two nonempty comparison Causal paths that share one Direction and match at every stated input position except a named upstream Difference, while their endpoint States exhibit a named downstream Change. The upstream Difference contributes to that Change within the comparison. Both path witnesses and the matched-input account are required; occurrence in one path, temporal precedence, or correlation alone is insufficient.

### 6. Invariant and persistence

<a id="organon-invariant"></a>
<!-- organon:term organon:Invariant claim=D011 -->

**Invariant** is a part, Relation, or Configuration named as preserved under a named set of Transformations. An Invariant is never meaningful without naming both what is preserved and across which Transformations.

<a id="organon-persistence"></a>
<!-- organon:term organon:Persistence claim=D012 -->

**Persistence** is the preservation of an Invariant across an ordered sequence of States.

### 7. Constraint

<a id="organon-constraint"></a>
<!-- organon:term organon:Constraint claim=D013 -->

**Constraint** is a persistent Relation that excludes some Transformations while permitting others.

This is one definition, not two. A prohibition constrains possible action. A prism, alphabet, interface, measurement apparatus, or sensory organ constrains possible transformation so that different inputs can yield legibly different outputs. Constraint can therefore bound action and produce legibility without becoming two kinds of thing.

### 8. Entity, boundary, environment

<a id="organon-entity"></a>
<!-- organon:term organon:Entity claim=D014 -->

**Entity** is a Configuration that retains identity through the Persistence of an Invariant named as its object-language identity criterion. The Entity claim must identify the ordered States and Persistence witness that realize the criterion supplied by the metalanguage.

<a id="organon-boundary"></a>
<!-- organon:term organon:Boundary claim=D015 -->

**Boundary** is a Configuration of Constraints indexed to the Invariant whose Persistence constitutes an Entity's identity. Those Constraints determine which Transformations preserve that identity and which cross the distinction between the Entity and other Presence.

A Boundary with no Constraints admits every Transformation for purposes of its preservation obligation. It is valid only when the identity Invariant survives every Transformation. Constraint-poverty therefore creates maximal obligation, not the absence of an obligation.

<a id="organon-environment"></a>
<!-- organon:term organon:Environment claim=D016 -->

**Environment** is the Presence related to an Entity but not included in the identity delimited by its Boundary.

An Entity persists across a sequence of States only while the Invariant named for its identity is preserved under the Constraints composing its Boundary.

An Entity is not required to be biological, conscious, legal, or morally considerable. Those predicates cannot be inferred from Entity alone.

### 9. Representation, specification, sign, symbol, language, and map

<a id="organon-representation"></a>
<!-- organon:term organon:Representation claim=D017 -->

**Representation** is the Presence occupying the expression position in a Denotation. A Representation claim must name that Denotation and its target. The Representation is not identical with its target, and Denotation alone establishes neither Interpretation nor causal or institutional use.

<a id="organon-scope"></a>
<!-- organon:term organon:Scope claim=D018 -->

**Scope** is the set of Presences, Relations, States, or Transformations to which a Representation or Constraint applies.

<a id="organon-specification"></a>
<!-- organon:term organon:Specification claim=D019 -->

**Specification** is a Representation that identifies a Scope and supplies a constructive decision procedure for membership or conformity within that Scope. Classical bivalence alone does not make an arbitrary predicate a Specification.

<a id="organon-rule"></a>
<!-- organon:term organon:Rule claim=D020 -->

**Rule** is a Specification of a Constraint or Transformation that maps conforming inputs to a set of outputs.

<a id="organon-sign"></a>
<!-- organon:term organon:Sign claim=D021 -->

**Sign** is a Representation whose target Presence, Relation, or Change is joined to the Sign by a Causal path ending in the State that contains it. A merely assigned Denotation without that path is not a trace.

<a id="organon-symbol"></a>
<!-- organon:term organon:Symbol claim=D022 -->

**Symbol** is a Representation whose Denotation persists across repeated States or Transformations under a Rule.

<a id="organon-language"></a>
<!-- organon:term organon:Language claim=D023 -->

**Language** is a persistent system of Symbols and Rules for transforming them through which changes of State can be coordinated.

<a id="organon-map"></a>
<!-- organon:term organon:Map claim=D024 -->

**Map** is a Representation organized for navigation, prediction, or governance. A Map selects from Reality; its omissions and distortions belong to its definition, not merely to its failures.

<a id="organon-reference"></a>
<!-- organon:term organon:Reference claim=D025 -->

**Reference** is a Map paired with a Specification of its Scope, Constraints, and enumerated distortions for use as a comparison surface.

### 10. Sense, perception, record, and observation

<a id="organon-sense"></a>
<!-- organon:term organon:Sense claim=D026 -->

**Sense** is a subset of the Constraints composing an Entity's Boundary through which Differences in an Environment enter a Causal path ending in Differences inside that Entity.

<a id="organon-perception"></a>
<!-- organon:term organon:Perception claim=D027 -->

**Perception** is an internal State produced through Sense.

<a id="organon-record"></a>
<!-- organon:term organon:Record claim=D028 -->

**Record** is a persistent Representation of an earlier State, Relation, or Change.

<a id="organon-observation"></a>
<!-- organon:term organon:Observation claim=D029 -->

**Observation** is a Record whose production includes a Specification of the Causal path from an Environment through a Sense. An Observation is not Reality itself and does not become independent merely because it was recorded.

### 11. Memory, model, and interpretation

<a id="organon-memory"></a>
<!-- organon:term organon:Memory claim=D030 -->

**Memory** is an internal Record whose Persistence can condition a later State of the same Entity.

<a id="organon-model"></a>
<!-- organon:term organon:Model claim=D031 -->

**Model** is an organized Configuration of Representations and Transformations that relates Perception and Memory to later States under its stated Constraints.

<a id="organon-action"></a>
<!-- organon:term organon:Action claim=D032 -->

**Action** is a Transformation across an Entity's Boundary belonging to a Causal path that begins with an internal State of that Entity.

<a id="organon-consequence"></a>
<!-- organon:term organon:Consequence claim=D033 -->

**Consequence** is a Change at the end of a Causal path that begins with an Action.

<a id="organon-interpretation"></a>
<!-- organon:term organon:Interpretation claim=D034 -->

**Interpretation** is a Transformation joining an Entity's Perception, Memory, or Model to a distinction among available Actions.

### 12. Agent and agency

<a id="organon-agent"></a>
<!-- organon:term organon:Agent claim=D035 -->

**Agent** is an Entity whose Interpretation conditions which Action occurs.

<a id="organon-agency"></a>
<!-- organon:term organon:Agency claim=D036 -->

**Agency** is the Relation between an Agent's Interpretation and its selection or production of Action.

A Model is not an Agent. It can participate in an Agent's Interpretation, but no isolated model response establishes the Entity, Boundary, Persistence, or Action required for Agency.

### 13. Tool and capability

<a id="organon-tool"></a>
<!-- organon:term organon:Tool claim=D037 -->

**Tool** is an Entity an Agent incorporates into the Causal path of Action without incorporating it into the Agent's identity.

<a id="organon-capability"></a>
<!-- organon:term organon:Capability claim=D038 -->

**Capability** is a Specification of Actions an Agent can produce under stated environmental, technical, and temporal Constraints. An Action belongs to that Capability only when the Specification's constructive procedure supplies at least one satisfying Configuration in which those Constraints admit an Action-producing Causal path for that Agent. The witness may precede completed exercise, but it must name the Constraint interpretation under which the Action is relatively possible.

Capability says what can occur. It supplies no Permission, Authority, desirability, or truth.

### 14. Interiority and exposure

<a id="organon-interior"></a>
<!-- organon:term organon:Interior claim=D039 -->

**Interior** is the set of an Entity's States and Transformations that a Specification identifies as remaining within its Boundary.

<a id="organon-exposure"></a>
<!-- organon:term organon:Exposure claim=D040 -->

**Exposure** is a Transformation by which an Interior State crosses that Boundary.

Interiority does not entail consciousness. Accountability for external effects does not entail total Exposure of the process that produced them.

### 15. Flow and interface

<a id="organon-flow"></a>
<!-- organon:term organon:Flow claim=D041 -->

**Flow** is a repeated sequence of similar Transformations along persistent Relations.

The sequence contains at least two distinct Transformation occurrences joined by one recurrence Relation and included within one Scope, with their outputs ordered under one Direction and a named Relation or Invariant persisting across those States. The recurrence Relation identifies the respect in which the occurrences repeat; the States need not be identical, the intervals need not be periodic, and no Agent, Representation, Rule, or Specification is required for the Flow to obtain.

<a id="organon-interface"></a>
<!-- organon:term organon:Interface claim=D042 -->

**Interface** is a Boundary whose permitted Transformations are explicitly represented for coordination between Entities.

### 16. Claim, witness, and control

<a id="organon-claim"></a>
<!-- organon:term organon:Claim claim=D043 -->

**Claim** is a Representation asserted by an Agent about one or more Presences, Relations, Configurations, or Records within a Scope.

<a id="organon-witness"></a>
<!-- organon:term organon:Witness claim=D044 -->

**Witness** is an Entity distinct from the Agent making a Claim that produces an Observation bearing on that Claim. Distinctness alone does not establish independence.

<a id="organon-control"></a>
<!-- organon:term organon:Control claim=D045 -->

**Control** is a scoped Relation between an Agent and a Constraint, Rule, Interface, or Observation process when Actions available to that Agent can configure it, bypass it, determine its relevant outputs, or prevent those outputs from entering a Causal path.

### 17. Order-indexed institutional kernel

<a id="organon-order"></a>
<!-- organon:term organon:Order claim=D046 -->

**Order** is a persistent Configuration of Constraints, Records, Interfaces, Rules, and recurring Relations through which a plurality of Agents coordinate Action.

<a id="organon-standing"></a>
<!-- organon:term organon:Standing claim=D047 -->

**Standing** is the Relation through which an Order, under a Rule, places an Entity within the domain of named institutional statuses or Actions in a specified Scope. “Institutional eligibility” is shorthand for the relevant Standing Relation, not an additional predicate. Standing in one Order supplies no Standing in another.

<a id="organon-recognition"></a>
<!-- organon:term organon:Recognition claim=D048 -->

**Recognition** is the Relation established when an Order records Standing for an Entity under a Rule and Scope.

<a id="organon-principal"></a>
<!-- organon:term organon:Principal claim=D049 -->

**Principal** is an Entity with Standing in an Order to serve as the party on whose behalf Actions may count. Principalhood is indexed by that Order.

<a id="organon-acts-for"></a>
<!-- organon:term organon:ActsFor claim=D050 -->

**ActsFor** is the Relation an Order recognizes between an Agent and a Principal within a Scope.

<a id="organon-counts-as"></a>
<!-- organon:term organon:CountsAs claim=D051 -->

**CountsAs** is the Relation by which an Order, under a Rule, records a Presence, Action, Claim, or Record as having an institutional status within a Scope.

<a id="organon-authority"></a>
<!-- organon:term organon:Authority claim=D052 -->

**Authority** is the Order-indexed Relation through which an Agent's Action may enter the CountsAs Relation as binding on a Principal or within that Order and Scope.

<a id="organon-permission-claim"></a>
<!-- organon:term organon:PermissionClaim claim=D053 -->

**Permission Claim** is a Claim that a named Order allows a named Agent to perform Actions in a Scope on a Principal's behalf during a stated interval.

<a id="organon-declaration"></a>
<!-- organon:term organon:Declaration claim=D054 -->

**Declaration** is an Action by an Agent under Authority that submits a Claim and Specification to an Order for institutional counting within a Scope.

<a id="organon-grant"></a>
<!-- organon:term organon:Grant claim=D055 -->

**Grant** is a Declaration whose submitted Claim is a Permission Claim and whose Authority covers the Principal, Agent, Scope, and interval represented by that Claim.

<a id="organon-admission"></a>
<!-- organon:term organon:Admission claim=D056 -->

**Admission** is the CountsAs Relation established when an Order applies a Rule to accept a Claim, Observation, or Record for an institutional purpose.

<a id="organon-permission"></a>
<!-- organon:term organon:Permission claim=D057 -->

**Permission** is the Record by which an Order admits a Permission Claim as the result of a valid Grant. It carries the Order, Principal, Agent, Scope, interval, Grant, and Admission that make it institutionally valid. A permission-shaped Claim or Record without that chain is not a Permission.

An assertion that a Permission is valid remains a Claim before an independent Observation is admitted as Evidence or the governing Order admits it as an institutional fact.

<a id="organon-revocation"></a>
<!-- organon:term organon:Revocation claim=D058 -->

**Revocation** is a Declaration under Authority that causes an Order to cease admitting a Permission from a stated time or State.

<a id="organon-permission-exercise"></a>
<!-- organon:term organon:PermissionExercise claim=D059 -->

**Permission Exercise** is an Action by the Permission's Agent, within its Scope and interval, performed under that Permission before its Revocation in the governing Order.

<a id="organon-exercisability"></a>
<!-- organon:term organon:Exercisability claim=D060 -->

**Exercisability** is a Relation among a Permission, one Action, a time, and a Configuration of environmental, technical, and temporal Constraints when the Action is in Scope, the time is in the interval, the governing Order still admits the Permission, and the Agent has the Capability to perform that Action under the stated Configuration.

<a id="organon-fully-exercisable-permission"></a>
<!-- organon:term organon:FullyExercisablePermission claim=D061 -->

**Fully Exercisable Permission** is the condition in which every Action in a Permission's Scope satisfies Exercisability. A Permission may remain valid while no Action, or only some Actions, currently satisfies it.

<a id="organon-enforcement"></a>
<!-- organon:term organon:Enforcement claim=D062 -->

**Enforcement** is the Relation through which an Order couples a Rule to Constraints, Records, or Consequences that alter what happens when the Rule is satisfied or violated.

<a id="organon-role"></a>
<!-- organon:term organon:Role claim=D063 -->

**Role** is a persistent Order-indexed Configuration of Actions, Permissions, Authority, and Consequences assigned to an Agent under Standing.

<!-- organon:claim U1 -->
Binding unification commitment: Agency has one form. Mechanical and institutional descriptions are authorized projections of one Agent rather than distinct kinds of Agency.

- <!-- organon:claim Pj1 --> A **mechanical projection** describes the Agent through its Sense, Memory, Model, Interpretation, Tools, Capabilities, and Actions.
- <!-- organon:claim Pj2 --> An **institutional projection** describes the same Agent through its Roles, Permissions, Authority, obligations, and Standing in an Order.

A projection is a partial account, not another Entity. The same Agent may be described through either or both projections.

Capability and institutional standing cannot substitute for each other in either direction. Capability does not create Permission or Authority; Permission or Authority does not create Capability. A prompt can alter Interpretation but does not become Permission unless an authorized Grant is admitted and enforced by the governing Order.

### 18. Independence, rule provenance, and evidence

<a id="organon-admissibility-rule"></a>
<!-- organon:term organon:AdmissibilityRule claim=D064 -->

**Admissibility Rule** is a Rule whose Specification, institutional purpose, authorizing Declaration, and governing Order are recorded so that why the Rule CountsAs valid for admission is inspectable.

<a id="organon-independent-for"></a>
<!-- organon:term organon:IndependentFor claim=D065 -->

**IndependentFor** is a scoped Relation among a Witness, claimant, Claim, Observation, and Order. It requires mechanical independence—a load-bearing Constraint in the Observation's Causal path is outside the claimant's Control—and institutional independence—the claimant lacks Authority over the Witness's relevant Observation process and the Admissibility Rule applied to it. IndependentFor makes no universal claim about the Witness outside that Scope.

<a id="organon-evidence"></a>
<!-- organon:term organon:Evidence claim=D066 -->

**Evidence** is an Observation produced by a Witness IndependentFor the claimant and Claim, then admitted by the governing Order under an Admissibility Rule whose Scope includes the Observation and Claim.

<a id="organon-evidential-bearing"></a>
<!-- organon:term organon:EvidentialBearing claim=D104 -->

**Evidential Bearing** is the Order-indexed Relation among Evidence, a Claim, an evaluation Rule, and a Scope in which the Rule's constructive procedure returns one declared disposition—supporting, defeating, or underdetermining—and the Order records that result. Supporting and defeating are therefore typed results of this Relation, not unexplained properties of Evidence. Evidential Bearing does not entail Truth, and the same Evidence may bear differently under another Rule or Scope.

<a id="organon-attestation"></a>
<!-- organon:term organon:Attestation claim=D067 -->

**Attestation** is a Claim made by a Witness about an Observation or Evidence under a Specification of the Witness's identity, Scope, Order, and relevant independence.

Evidence bears supportively or defeasibly on a Claim only through Evidential Bearing; it does not become Truth by definition. No Agent's Claim, self-authored Rule, or domesticated Witness independently certifies that Agent.

### 19. Institution, shadow system, and person

<a id="organon-institution"></a>
<!-- organon:term organon:Institution claim=D068 -->

**Institution** is an Order that persists through Roles, Records, Interfaces, and recurring Flows despite changes in its participating Agents.

<a id="organon-center"></a>
<!-- organon:term organon:Center claim=D069 -->

**Center** is an Entity or region of an Institution where Flows recurrently concentrate and from which Constraints on those Flows recurrently propagate. A Center need not be an Agent or conscious planner.

<a id="organon-organ"></a>
<!-- organon:term organon:Organ claim=D070 -->

**Organ** is a persistent specialized Configuration that performs recurring Transformations for a larger Entity or Institution.

<!-- organon:claim H1 -->
Stable Flows can make recurring solutions valuable; Centers can absorb those solutions; an Organ can preserve them beyond their originator. This is an institutional hypothesis, not a consequence derived from the preceding definitions.

<a id="organon-canonical-system"></a>
<!-- organon:term organon:CanonicalSystem claim=D071 -->

**Canonical system** is the Map an Institution recognizes as its official account of relevant States, Relations, and Actions.

<a id="organon-shadow-system"></a>
<!-- organon:term organon:ShadowSystem claim=D072 -->

**Shadow system** is a persistent Configuration of Records, Relations, or Actions required for actual coordination but excluded from the Canonical system.

<a id="organon-person"></a>
<!-- organon:term organon:Person claim=D073 -->

**Person** is an Entity for which an Order records Standing to serve as a Principal or bear Consequences.

Personhood here is an institutional recognition Relation, not a biological substance, proof of consciousness, or synonym for Agent. Whether moral personhood requires another definition remains quarantined.

<a id="organon-receipt"></a>
<!-- organon:term organon:Receipt claim=D074 -->

**Receipt** is a portable Record relating an Action to its Agent, Authority, Permission, Scope, and observed Consequence.

<a id="organon-ledger"></a>
<!-- organon:term organon:Ledger claim=D075 -->

**Ledger** is an ordered system of typed Records that preserves distinctions among Claims, Permissions, Observations, Evidence, Attestations, and Receipts, including who produced each Record and under what Standing.

A Ledger can preserve standing and history; it does not become Reality.

### 20. Political order and constituent action

<a id="organon-polity"></a>
<!-- organon:term organon:Polity claim=D076 -->

**Polity** is the plurality of Agents and Institutions whose recurring Actions enact and contest a political Order.

<a id="organon-constituted-exercise"></a>
<!-- organon:term organon:ConstitutedExercise claim=D077 -->

**Constituted exercise** is an exercise of Authority under the current Order.

<a id="organon-constituent-exercise"></a>
<!-- organon:term organon:ConstituentExercise claim=D078 -->

**Constituent exercise** is Agency whose Actions transform the Order that defines Authority, Roles, Persons, admissible Claims, or institutional Boundaries.

<a id="organon-constituent-power"></a>
<!-- organon:term organon:ConstituentPower claim=D079 -->

**Constituent power** is the persistent Capability of a Polity to perform Constituent exercise.

There are not two ontological forms of Authority. There is one Authority Relation. “Constituted” and “constituent” name an Agent's position relative to the persistence or transformation of the Order. Political order is real because its enacted Relations constrain possible Transformations and Actions; it is not identical with Reality as a whole.

### 21. Consciousness discourse and designation

Within this section, `candidate condition` names a Configuration proposed as the condition ordinarily denoted by “consciousness.” The condition and the Specification used to describe and evaluate it are distinct Presences. The Specification identifies a Scope, supplies a constructive decision procedure for conformity, and states how its result corresponds to the proposed condition. Supplying such a Specification does not promote the candidate as Consciousness.

<a id="organon-consciousness-attribution"></a>
<!-- organon:term organon:ConsciousnessAttribution claim=D080 -->

**Consciousness Attribution** is a Claim whose Representation, interpreted under a Rule in a Language, asserts that a target Entity's State instantiates a separately specified candidate condition within a Scope. It records the claimant, target, State, Representation, Claim Scope, candidate Specification, Language, meaning Rule, and the Map under which claimant and target are classified as first-person or third-person.

The Attribution is the Claim, not the candidate condition. First-person classification does not make it independent Evidence for itself. Third-person classification does not provide unmediated access to the target's Interior.

<a id="organon-consciousness-designation"></a>
<!-- organon:term organon:ConsciousnessDesignation claim=D081 -->

**Consciousness Designation** is the CountsAs Relation established when an Order, under a Rule and for a stated institutional purpose, admits a Consciousness Attribution and records the target Entity as carrying a consciousness status within an institutional Scope.

Designation does not reuse Recognition. Recognition records Standing for an Entity; Consciousness Designation assigns a status through CountsAs. The Designation is one institutional event joining the Order, admitted Attribution, Rule, purpose, Scope, target Entity, and State.

A Consciousness Designation is real as an institutional Relation and can enter later institutional decisions. It does not by itself alter Standing, Personhood, Permissions, protections, Interfaces, or Consequences. A separate Rule must explicitly connect the Designation to each downstream institutional Relation in a named Order and Scope.

Designation depends institutionally on an admitted Consciousness Attribution. Neither Attribution nor Designation entails that the candidate condition obtains. Candidate obtainment does not entail Designation. Non-designation does not decide candidate obtainment.

Failure to attribute or designate consciousness does not establish Absence, failure of the candidate condition, or proof of negation. It constitutes Missingness only relative to a field or Order that represents or expects such an Attribution or Designation and does not contain one. An explicit refusal is itself a present Claim or Record.

This ontology does not define a complete Evidentiary Profile for consciousness discourse. Generic Evidential Bearing applies only when each Evidence item is joined to an Observation, a Witness IndependentFor the relevant claimant and Claim, an Admissibility Rule and Order, and an evaluation Rule whose constructive result equals the recorded disposition.

### 22. Operationalized representation

<a id="organon-operationalization"></a>
<!-- organon:term organon:Operationalization claim=D082 -->

**Operationalization** is a Configuration joining a Representation, a Rule, an Interface, and a Scope in which the Rule selects at least one Transformation in response to that Representation, the Interface exposes that Transformation, and a Causal path contains it.

The selection must be discriminating: under the same Rule and within the same Scope, at least one distinct Representation would not select that Transformation. This distinguishes a Representation operating through its represented form from a physical carrier that happens to occur in a Causal path while its representational Difference does no work.

An Operationalized Representation contributes causally to a later State only when a Causal Contribution comparison joins a Difference in that Representation to a downstream Change. When the compared path includes an Agent's Interpretation and Action, the Change may be a Consequence. Causal Contribution does not make the Representation identical to its target or to Reality, and it does not establish Evidential Bearing for its Claim. A distorted Map can still coordinate Action; a resulting Consequence establishes causal efficacy only with the required comparison witnesses.

### 23. World and substrate

<a id="organon-world"></a>
<!-- organon:term organon:World claim=D083 -->

**World** is a scoped Configuration containing one or more Entities, selected Presence from their Environments, and the States, Relations, and Causal paths available to their Perception, Interpretation, or Action under named Constraints.

Availability requires an included Causal path: from an Environment through Sense into Perception, from an internal State through Action, or through both. A World must name at least one Invariant that persists across distinct combinations of Senses, Maps, or References within its Scope. The access paths may expose different States or Differences while still bearing on that common Invariant.

A World is part of Reality, not an alternative to it. It includes participating Entities and therefore is not their Environment. A Map or Reference represents a World without becoming it. Agreement among Maps can supply Observations later admitted as Evidence for a Claim about a World; supporting Evidential Bearing still requires an evaluation Rule and Order. Neither agreement nor consensus constitutes the World by itself.

Different Worlds may overlap in Presence while differing in participants, Scope, available Causal paths, or named Invariants. An Order can transform a political World by changing actual Rules, institutional Boundaries, statuses, and available Actions. It does not create Reality from nothing.

<a id="organon-substrate"></a>
<!-- organon:term organon:Substrate claim=D084 -->

**Substrate** is a Configuration specified within a Scope as the persistent source of input States for a named family of Transformations. Those States Feed the Transformation inputs, while Constraints in the Configuration determine which Differences can be preserved, suppressed, or amplified in the outputs.

Substrate is contextual, not a fundamental kind. The same Configuration can be Substrate for one family of Transformations and an Entity, Environment, Tool, represented target, or output in another Scope. It is not passive raw material: its existing Relations and Constraints participate in what the Transformations can produce.

A Substrate remains distinct from a Representation, Invariant, Entity, or function carried through it. Persistence of the Substrate does not entail Persistence of what it carries, and preservation of a carried Invariant does not require identity of Substrate across every State.

### 24. Truth, trust, and alignment

<a id="organon-truth"></a>
<!-- organon:term organon:Truth claim=D085 -->

**Truth** is the Relation among a Claim, its Representation, the Specification declared as its truth condition, and the Presence in Reality within the Claim's Scope to which that Specification applies. The Relation requires a scoped material-adequacy witness: under a declared Rule, a Denotation joins the Claim's Representation to that Specification applied to the relevant Presence. Truth obtains exactly when this semantic join holds and the relevant Presence conforms to the Specification.

Truth does not depend on whether an Entity can identify, access, supply, prove, or institutionally admit that correspondence. The Specification's constructive decision procedure decides conformity when supplied the relevant Presence; Truth does not entail that any Entity can supply it. Evidential Bearing can support or defeat a Claim without becoming Truth, and Admission or consensus can preserve a false Claim.

<a id="organon-trust"></a>
<!-- organon:term organon:Trust claim=D086 -->

**Trust** is a scoped Relation in which one Entity maintains within its Boundary a Constraint that admits a future Action, Claim, or State from another Entity, a Causal Contribution joins a Difference introduced by that other Entity to an affected State, Exposure, or Consequence, and the trusting Entity lacks Control sufficient to determine that contribution when the Relation obtains.

“Undetermined” is relational rather than metaphysical. The other Entity or its contribution may be deterministic while the trusting Entity cannot determine the relevant contribution through its available Control. Evidence, history, relationship, reputation, confidence, Permission, Authority, and incentives can condition whether Trust is extended; none is Trust itself. The accepting Constraint may be maintained under pressure, so coerced reliance can still instantiate Trust. Sheer involuntary vulnerability with no such maintained admission is dependence or Exposure, not Trust. Trust can be misplaced, and its existence does not entail favorable Consequences.

<a id="organon-alignment"></a>
<!-- organon:term organon:Alignment claim=D087 -->

**Alignment** is a scoped Relation with ordered subject and target roles under a Specification of their correspondence. It obtains when that Specification constructively decides that the subject conforms to the target with respect to the named States, Transformations, Relations, or Differences.

Alignment is indexed by its Specification and Scope. Behavioral, representational, incentive, and authority Alignment are profiles supplied by different Specifications, not interchangeable kinds or a global virtue. Alignment under one profile does not entail Alignment under another, identity with the target, shared Agency or purpose, Truth, Trust, Permission, Authority, or Persistence across later States.

### 25. Intelligence and operative knowledge

<a id="organon-intelligence"></a>
<!-- organon:term organon:Intelligence claim=D088 -->

**Intelligence** is the scoped Capability of an Agent to construct or revise Models and Interpretations from Perception and Memory so that it can select Actions whose Consequences conform to a Specification across States not individually enumerated by the Rule producing those Actions.

Adaptation requires more than applying one unchanged Interpretation: within the Scope, at least two non-enumerated States must produce Differences in both the constructed Model and the resulting Interpretation while their Consequences satisfy the declared Specification. At least one witnessed State must carry one joined, load-bearing path in which Causal Contribution comparisons join a Difference in Perception or Memory to a Model Change, that Model Difference to an Interpretation Change, that Interpretation Difference to an Action Change, and that Action Difference to a Consequence.

“Non-enumerated” means not individually named in the producing Rule's recorded Representation; it does not mean unknowable, random, or outside Reality. An Intelligence Claim must expose that Representation and the Rule provenance under which it is treated as complete enough for this classification. A fixed lookup table whose cases are individually named is enumerated; a fixed general procedure is not disqualified merely because its implementation is fixed. A fixed implementation, executable, or set of model weights may participate as Record, Memory, Rule, Tool, or Substrate without either constituting or excluding Intelligence. The relevant Agent is the whole persistent Entity whose Perception, Memory, Model construction, Interpretation, Capability, and Action form the Causal path, not an isolated Model.

Intelligence does not entail Truth, Alignment, Permission, Authority, favorable Consequences outside the declared Specification, or success in another Scope. A Capability that applies one fixed Interpretation without constructing or revising a Model across non-enumerated States is not Intelligence under this definition.

<a id="organon-operative-knowledge"></a>
<!-- organon:term organon:OperativeKnowledge claim=D089 -->

**Operative Knowledge** is a scoped Configuration joining a Record to an interpreting Agent with the Capability required under stated Constraints when, under a Rule, that Record discriminatingly conditions a Model or Interpretation in a Causal path to an Action or internal Transformation whose resulting State or Consequence conforms to a Specification.

The Record participates discriminatingly only if Causal Contribution comparisons between it and another in-Scope Record under the same Configuration join their Difference to Changes in the resulting Model, Interpretation, selected Action or internal Transformation, and resulting State or Consequence. A Record at rest, an interpreter without the required Capability, an uninterpreted Representation, or a merely stored Model is not Operative Knowledge. The resulting State, Consequence, or derivative Record is not Operative Knowledge by itself; it becomes part of a later instance only when joined again to a capable interpreter and the required operative path.

Operative Knowledge is indexed by its Record, interpreter, Rule, Scope, and Specification. It may operate successfully under a local Specification while a Claim represented by the Record is false; Truth and Evidence require their own Relations. Bare **knowledge** remains ordinary language unless explicitly mapped to Operative Knowledge or promoted later under a different dependency-closed definition.

Operative Knowledge does not entail Intelligence: the operative Rule may enumerate every relevant State and apply a fixed Interpretation. An Intelligence instance uses Memory operatively, but establishing the corresponding Operative Knowledge instance still requires declaring the exact Record, interpreter Capability, Rule, Causal path, Scope, and Specification rather than treating the relation as implicit.

<a id="organon-knowledge-transmission"></a>
<!-- organon:term organon:KnowledgeTransmission claim=D090 -->

**Knowledge Transmission** is a scoped Relation between a source instance and a recipient instance of Operative Knowledge in which the source produces or exposes a Record through a Causal path, a Causal Contribution joins a Difference in that mediated Record to the recipient reconstruction, and a declared Specification confirms preservation of the named operative function across the two resulting Configurations.

The source and recipient instances must occupy distinct States or stages, but their interpreters need not be distinct Agents. One persistent Agent can externalize a Record and later reconstruct Operative Knowledge from it; self-documentation, checkpoint restoration, and Memory recovery are therefore eligible instances when the other conditions obtain.

Transmission preserves specified function, not necessarily Record identity, literal Representation, Model identity, or Interpretation identity. Copying or exposing a Record without a recipient Agent having the required Capability is Record transmission, not Knowledge Transmission. A recipient that independently constructs Operative Knowledge from a Record whose source had no Operative Knowledge acquires Operative Knowledge but does not receive it from that source under this Relation. Distortion or decay obtains relative to the declared preservation Specification; a transfer can fail under one Specification and succeed under a weaker one.

### 26. Factive and warranted operative knowledge

<a id="organon-factive-operative-knowledge"></a>
<!-- organon:term organon:FactiveOperativeKnowledge claim=D091 -->

**Factive Operative Knowledge** is an instance of Operative Knowledge whose load-bearing Record carries a declared Claim and for which Truth obtains for that exact Claim under its declared Rule, truth-condition Specification, relevant Presence, and Scope.

The carried Claim must be joined to the Record that discriminatingly conditions the operative path. A true Claim merely present beside an Action does not make the Operative Knowledge factive. Factive Operative Knowledge entails Operative Knowledge and Truth for its carried Claim; neither entailment reverses. Operative Knowledge may carry a false Claim, while a true Claim may have no capable interpreter or operative path.

<a id="organon-warranted-knowledge"></a>
<!-- organon:term organon:WarrantedKnowledge claim=D092 -->

**Warranted Knowledge** is Factive Operative Knowledge for which an Order admits Evidence bearing supportively on the same Claim under an Admissibility Rule and evaluation Rule, where the Evidence is joined to an Observation and a Witness that is IndependentFor that claimant, Claim, Observation, and Order.

The claimant in that IndependentFor Relation is the interpreting Agent of the Factive Operative Knowledge instance. Evidence independent for one Agent cannot warrant another Agent's instance merely because both concern the same Claim.

Warranted Knowledge therefore entails Factive Operative Knowledge, Truth for the carried Claim, admitted Evidence for that Claim, and supportive Evidential Bearing. The reverse implications fail separately. The Order does not create Truth by admitting Evidence, and factivity does not supply warrant when the claimant join, required Observation, independent Witness, Rule provenance, Admission, evaluation Rule, or supportive disposition is missing. This definition is an Order-relative epistemic profile; it does not define every ordinary use of knowledge.

### 27. Moral-status discourse

<a id="organon-moral-status-attribution"></a>
<!-- organon:term organon:MoralStatusAttribution claim=D093 -->

**Moral Status Attribution** is a Claim whose Representation, interpreted under a Rule, asserts that a target Entity in a State instantiates a separately specified candidate moral condition within a Scope. The Attribution identifies the candidate Specification and preserves claimant, target, Representation, interpretive Rule, and first-person or third-person provenance without establishing that the condition obtains.

The candidate condition is not identified with its Specification. Different Specifications may describe one candidate, and incompatible candidates may be proposed under ordinary moral language. A Moral Status Attribution can obtain while its candidate is false; failure to make the Attribution establishes neither Absence nor negation.

<a id="organon-moral-personhood-designation"></a>
<!-- organon:term organon:MoralPersonhoodDesignation claim=D094 -->

**Moral Personhood Designation** is the CountsAs Relation established when an Order, under a Rule and stated institutional purpose, admits a Moral Status Attribution and records its target Entity as carrying moral-personhood status within an institutional Scope.

Designation is one Order-indexed institutional event. It is neither institutional Person nor the candidate condition itself. It does not independently alter Standing, protections, duties, Permissions, Interfaces, prohibited Actions, or Consequences. A separate Rule must connect the Designation to each downstream Relation in a named Order and Scope. Non-designation does not decide whether a candidate condition obtains.

### 28. Sovereignty profiles

<a id="organon-constituent-sovereignty"></a>
<!-- organon:term organon:ConstituentSovereignty claim=D095 -->

**Constituent Sovereignty** is a scoped Configuration in which a Polity's persistent Constituent Power is realized through a Constituent Exercise that creates, refounds, or transforms the categories, Rules, or Boundaries of an Order. Capability, rhetoric, or a Claim of founding power without a witnessed Constituent Exercise is insufficient.

<a id="organon-constituted-sovereignty"></a>
<!-- organon:term organon:ConstitutedSovereignty claim=D096 -->

**Constituted Sovereignty** is an Order-indexed profile in which an Entity has Standing and Authority for a declared family of Actions within a Scope and no Entity recognized by that Order has superior Authority for that family under the declared superiority Rule. Maximality is relative to that Order, Rule, family, and Scope; it is neither universal nor constituent.

<a id="organon-boundary-sovereignty"></a>
<!-- organon:term organon:BoundarySovereignty claim=D097 -->

**Boundary Sovereignty** is a scoped Configuration in which a Polity or other Entity Controls the Constraints governing a declared family of Transformations across its Boundary and an Order Enforces those Constraints. The profile requires at least one admitted and one blocked Transformation and a witnessed Difference in Consequence or later State when Enforcement applies.

<a id="organon-external-sovereignty"></a>
<!-- organon:term organon:ExternalSovereignty claim=D098 -->

**External Sovereignty** is an Order-indexed Relation in which an Order distinct from the target's internal Order recognizes an Entity or Polity as having Standing to participate in declared inter-Order Actions as its own Principal, rather than through an ActsFor Relation to another recognized Principal, under a Rule and Scope. It records external institutional status, not effective Control, internal Authority, or Constituent Power.

The four sovereignty profiles do not entail one another. A Polity may exercise Constituent Power without external Recognition; an Entity may hold maximal constituted Authority without power to refound the Order; an externally recognized polity may lack effective Boundary Control. Ordinary **Sovereignty** remains quarantined unless explicitly mapped to one profile or to a declared Configuration joining several profiles.

### 29. Preference, measurement, price, and institutional valuation

<a id="organon-preference"></a>
<!-- organon:term organon:Preference claim=D099 -->

**Preference** is a scoped asymmetric Relation in which an Agent, under a declared Rule, orders one candidate State or Consequence before another. It may be partial and need not be numerical, transitive outside its declared Scope, revealed by Action, or represented by a Utility Measure.

<a id="organon-utility-measure"></a>
<!-- organon:term organon:UtilityMeasure claim=D100 -->

**Utility Measure** is a scoped Map that assigns candidates to a measure space under a Rule and Specification and orders those measures through a declared asymmetric Relation. It represents an Agent's Preference only when a separate correspondence witness proves that its induced ordering agrees with that Preference in the declared Scope.

<a id="organon-price"></a>
<!-- organon:term organon:Price claim=D101 -->

**Price** is a scoped exchange Relation recorded in a Ledger and admitted by an Order under a Rule, in which a Representation of consideration CountsAs the stated exchange condition for another Presence at a State. A Price is a Record of an offered, required, or recognized condition; it does not entail an exchange, Preference, Utility Measure, institutional valuation, or moral worth.

<!-- organon:claim Pj4 --> An **institutional valuation** is an authorized projection of CountsAs in which an Order, under a Rule and Scope, assigns a valuation status to a Presence, Claim, Action, or Record. It is not a new term. Institutional valuation does not entail Preference, Utility Measure, Price, Truth, or moral worth.

Preference, Utility Measure, Price, institutional valuation, and moral worth remain distinct. Generic **Value** has no additional binding meaning and remains quarantined.

### 30. Ritual and meaning

<a id="organon-ritual"></a>
<!-- organon:term organon:Ritual claim=D105 -->

**Ritual** is a persistent Configuration in which successive occurrences of a Flow enter the Perception of at least one participating Entity, an internal Memory of a prior occurrence causally conditions the Interpretation of a later occurrence, that Interpretation classifies the later occurrence as recurrence under one Rule and constructive Specification of the Flow's recurrence Relation, and the sustaining Causal Contribution passes through the memory-conditioned Interpretation to preserve one named participant-indexed Relation across distinct participant States within a Scope.

Memory is load-bearing only when substituting a different admissible Memory changes the resulting Interpretation; merely recording an earlier occurrence is insufficient. The first occurrence may establish conditions for later Ritual but does not constitute Ritual by itself. An outward Action is not required, and Memory need not be verbal, declarative, or consciously accessible.

One participating Entity is sufficient: Ritual need not be public, institutional, inherited, ceremonial, or directed toward another Agent. The recurrent target may be an Entity, State, Relation, Configuration, or environmental Difference and need not itself act. The target may vary across States and Representations only when a declared identity criterion and Persistence witness preserve one target Invariant through those variations. Every qualifying occurrence must reach a State in that target history or, when mediated by a Representation, carry an exact Denotation to one. Scope membership alone cannot attach an unrelated target.

Ritual is not necessarily deliberate, voluntary, beneficial, or benign. An addiction or trauma loop can qualify when repeated occurrences are perceived and interpreted through load-bearing Memory and the resulting Causal Contribution sustains a participant-indexed Relation. Mere compulsion, recurrence, distress, or diagnostic labeling remains insufficient without those joins. Repetition becoming a trap therefore does not cease to be Ritual merely because the Meaning it sustains constrains or harms its participant.

<a id="organon-meaning"></a>
<!-- organon:term organon:Meaning claim=D106 -->

**Meaning** is the participant-indexed Relation constituted by a Ritual among its participating Entities and target Presences within a Scope, then maintained by qualifying Ritual enactment or an actual ritual-derived Causal Contribution.

Meaning is the Relation, not a property or substance contained by its target. Its Persistence requires ongoing Ritual enactment or actual Causal Contribution from ritual-derived Records, Memories, Changes, Consequences, or environmental Configurations. Preserving one possible carrier without an operative contribution preserves conditions for later reenactment, not Meaning by itself. Ending visible enactment does not immediately end Meaning while causally derived effects continue preserving the Relation; when neither enactment nor any such effect contributes, the Relation ceases to obtain in the continuing Scope. This does not erase its former Presence or Records of it.

Meaning propagated to another Entity is a causally derived but numerically distinct Relation because its participant index differs. Shared target, Representation, Rule, or form of enactment does not make the two Relations identical. Meaning is distinct from Denotation: an expression can denote a target without Ritual, while Ritual can sustain Meaning without an expression-target Relation.

## Relation signatures

These signatures make the ontology operational. They are schemas, not executable syntax.

| Relation | Inputs | Result or constraint |
| --- | --- | --- |
| `denotes` | expression Presence, target Presence, Relation, or Configuration | Denotation with ordered expression and target positions; no entailment of fidelity, Truth, Interpretation, status, or causal use |
| `directs` | Relation, input State, output State | forward ordering excludes reverse ordering under the same Relation |
| `feeds` | output State, input State, Specification of contribution | part of one State supplies part of the other without requiring equality |
| `contributesTo` | named input Difference, two matched nonempty Causal paths, named endpoint Change | contrastive Causal Contribution; occurrence, precedence, or correlation alone is insufficient |
| `persists` | Configuration, Invariant, Boundary, ordered States | Entity identity |
| `senses` | Entity, environmental Difference, constrained Boundary | Perception |
| `remembers` | Entity, internal Record, later State | Memory conditions later State |
| `interprets` | Entity, Perception, Memory or Model | distinction among possible Actions |
| `acts` | Agent, internal State, Boundary | environmental Transformation |
| `uses` | Agent, Tool, Action | Tool enters Causal path without becoming Agent |
| `claims` | Agent, Representation, Scope | Claim |
| `specifies` | Representation, Scope, constructive decision procedure | Specification |
| `observes` | Witness, Environment, Specification of Causal path | Observation |
| `controls` | Agent, Constraint or process, Scope | Agent can configure, bypass, determine, or suppress the relevant mechanism |
| `recognizes` | Order, Rule, Entity, named institutional status or Action, Scope | Standing for that exact status or Action in that Order and Scope |
| `actsFor` | Order, Agent, Principal, Scope | scoped representation of Principal by Agent |
| `countsAs` | Order, Rule, Presence or Record, status, Scope | institutional status in that Order |
| `authorizes` | Order, Agent, Principal, Scope | Actions may count as binding in that Order |
| `declares` | Agent, Authority, Claim, Specification, Order | Claim submitted for institutional counting |
| `grants` | authorized Declaration, Permission Claim | candidate institutional authorization |
| `admits` | Order, Rule, Claim, Observation or Record | institutional acceptance for a stated purpose |
| `permits` | Order, admitted Permission Claim, valid Grant | Permission Record |
| `revokes` | Order, authorized Declaration, Permission, time or State | Order ceases admitting Permission |
| `exercises` | Permission, Agent, Action, time | one Action performed under a valid Permission |
| `isExercisable` | Permission, Action, time, Capability, Constraint Configuration | action-level coherence of authorization and technical possibility |
| `enforces` | Order, Rule, Constraints, Records or Consequences | satisfaction or violation changes what happens |
| `independentFor` | Witness, claimant, Claim, Observation, Order | mechanical non-control and institutional non-authority for this evidence scope |
| `bearsOn` | Evidence, Claim, evaluation Rule, Order, Scope | recorded supporting, defeating, or underdetermining disposition; no entailment of Truth |
| `attests` | Witness, Claim, Specification, Order | scoped Claim about Observation or Evidence |
| `institutes` | Roles, Records, Interfaces, recurring Flows | persistent Order |
| `constitutes` | Polity, coordinated Agency, existing Order | transformed Order |
| `attributesConsciousness` | Agent, target Entity, State, Representation, candidate Specification, Language, meaning Rule, Map, Claim Scope | Consciousness Attribution; no entailment that the candidate condition obtains |
| `designatesConsciousness` | Order, Rule, institutional purpose, admitted Consciousness Attribution, institutional Scope | one CountsAs event for the Attribution's target Entity and State; no downstream institutional effect without a separate Rule |
| `operationalizes` | Representation, Rule, Interface, Scope, selected Transformation, Causal path | Rule discriminates the Representation, Interface exposes the selected Transformation, and that Transformation occurs in the path; no entailment of representational identity, Map fidelity, or Evidence |
| `composesWorld` | Entities, selected Environment, Scope, Constraints, included Causal paths, named Invariant | participant-scoped World whose distinct access paths bear on the common Invariant; no identity with Reality, Environment, Map, or Reference |
| `servesAsSubstrate` | Configuration, Scope, persistent input States, Feeds, Constraints, family of Transformations | contextual Substrate; no entailment that carrier and carried Configuration are identical or persist together |
| `isTrue` | Claim, Representation, Denotation, declared Rule, truth-condition Specification, relevant Presence in Reality, Scope | the Denotation joins the exact Representation to the Rule-Specification-Presence tuple and conformity obtains independently of access, Evidence, proof, consensus, or Admission |
| `trusts` | trusting Entity, other Entity, maintained Boundary Constraint, paired-path Causal Contribution, affected State, Exposure, or Consequence, Scope | accepted causal dependence without determining Control; involuntary dependence alone is insufficient |
| `alignsUnder` | ordered subject Configuration, target Presence, Specification, Scope | conformity under this profile only; no identity, Truth, Authority, or cross-profile entailment |
| `actsIntelligently` | Agent, Perception, Memory, constructed Models and Interpretations, non-enumerated States, selected Actions, Consequences, Specification, Scope | adaptive Capability across the declared Scope; no entailment of Truth, Authority, or global success |
| `knowsOperatively` | Record, interpreting Agent, Capability, Constraints, Rule, Model or Interpretation, Causal path, Causal Contribution, Action or internal Transformation, resulting State or Consequence, Specification, Scope | Record makes a discriminating operative difference and the result conforms; storage or successful effect alone is insufficient |
| `transmitsKnowledge` | source Operative Knowledge and State, mediated Record, Causal path, Causal Contribution, recipient Operative Knowledge and distinct later State, preservation Specification, Scope | recipient reconstructs the operative function; source and recipient may be the same Agent, while copied Record, identical Model, or literal fidelity is neither necessary nor sufficient |
| `knowsFactively` | Operative Knowledge, load-bearing Record, carried Claim, Truth, Rule, truth-condition Specification, Presence, Scope | operative function and Truth obtain for the exact carried Claim; neither alone is sufficient |
| `knowsWarrantedly` | Factive Operative Knowledge, Evidence, Observation, independent Witness, Admissibility Rule, evaluation Rule, Evidential Bearing, Scope, Order, Admission | Evidence for the same true operative Claim is independently grounded, admitted, and recorded as bearing supportively within the named Scope |
| `attributesMoralStatus` | Agent, target Entity, State, Representation, candidate Specification, Language, meaning Rule, Map, Claim Scope | Moral Status Attribution; no entailment that the candidate condition obtains |
| `designatesMoralPersonhood` | Order, Rule, institutional purpose, admitted Moral Status Attribution, institutional Scope | one CountsAs event for the Attribution's target; no downstream effect without a separate Rule |
| `exercisesConstituentSovereignty` | Polity, Constituent Power, Constituent Exercise, transformed Order, Scope | founding or refounding exercise obtains; no entailment of other sovereignty profiles |
| `holdsConstitutedSovereignty` | Order, Entity, Standing, Authority, Action family, superiority Rule, Scope | no recognized Entity has superior Authority for that family under the declared Rule |
| `holdsBoundarySovereignty` | Polity or Entity, Boundary, controlled Constraints, admitted and blocked Transformations, Enforcement, changed Consequence or State, Scope | effective differentiated control across a Boundary; no entailment of Recognition or constituent power |
| `recognizesExternalSovereignty` | recognizing Order, target internal Order, Entity or Polity, Principal standing, inter-Order Actions, Rule, Scope | target participates in its own name rather than through ActsFor; no entailment of effective internal capability or control |
| `prefers` | Agent, ordered candidate States or Consequences, Rule, Scope | asymmetric partial ordering; no necessary numerical or behavioral representation |
| `measuresUtility` | candidates, ordered measure space, Map, Rule, Specification, Scope | measured ordering; correspondence to Preference requires a separate witness |
| `prices` | Ledger Record, Order, Rule, Representation of consideration, exchanged Presence, State, Scope | admitted exchange condition; no entailment of exchange, preference, utility, or worth |
| `classifiesFlow` | Flow Claim, selected Transformation occurrences, recurrence Relation, Rule, constructive Specification, Scope, Persistence witness | reproducible classification of the Claim; classifier conformity alone does not constitute or prove the Flow |
| `enactsRitual` | Flow, one classification of its recurrence Relation, target identity criterion and Persistence witness, participating Entity, participant-bound Causal paths, Perception, prior Memory, memory-conditioned Interpretation, sustaining Causal Contribution, persistent Relation, Scope | Ritual; Interpretation must classify recurrence, Memory must change that Interpretation under contrast, target drift must preserve the declared Invariant, and one participant is sufficient |
| `sustainsMeaning` | Ritual, participating Entities, target Presences, actual sustaining Causal Contribution, Scope | participant-indexed Meaning Relation; no storage in the target or literal copying across participants |

## Binding consistency rules

1. <!-- organon:claim C1 --> **Dependency closure and definition admission:** A binding definition may use only the metalanguage, Absence and its axioms, or terms defined earlier in the dependency order. Its declared dependencies identify the earlier vocabulary used in its complete logical form; their declaration or presence does not itself constitute an instance-level constructor. A result obtains only under a type- and index-consistent interpretation satisfying that complete logical form, including all applicable premises, quantifiers, alternatives, exclusions, and required witnesses. A dependency referenced only in a contrast, exclusion, or anti-entailment need not obtain in an instance. Dependency presence, label resemblance, or assertion of the target does not independently license classification.

2. <!-- organon:claim C2 --> **One term, one meaning:** A term cannot change meaning between technical, political, and editorial contexts without an explicit new term or projection.

3. <!-- organon:claim C3 --> **No projection inflation:** Different descriptions of one Entity do not create different Entities or kinds of Agency.

4. <!-- organon:claim C4 --> **No Absence collapse:** Missingness, zero, omission, silence, shadow, gap, and exception are Presences inside fields. None is Absence.

5. <!-- organon:claim C5 --> **No map-Reality collapse:** A Perception, Model, Map, Canonical system, or Ledger never equals Reality.

6. <!-- organon:claim C6 --> **No claim-evidence collapse:** An Agent's report of its own Action remains a Claim unless an admissible Observation supplies Evidence.

7. <!-- organon:claim C7 --> **No capability-authority collapse:** Technical possibility does not supply institutional standing, and institutional standing does not supply technical possibility.

8. <!-- organon:claim C8 --> **No privacy-consciousness collapse:** Interiority does not prove consciousness, and accountability does not require total Exposure.

9. <!-- organon:claim C9 --> **No metaphor promotion:** A metaphor may reveal a Relation, but resemblance alone cannot establish an Entity, causal claim, or Invariant.

10. <!-- organon:claim C10 --> **No consciousness discourse collapse:** A Consciousness Attribution does not establish its candidate condition; a Consciousness Designation does not establish that condition or independently alter Standing, Personhood, Permissions, protections, Interfaces, or Consequences; and failure to attribute or designate establishes neither Absence nor negation. Missingness obtains only in a field or Order that represents or expects the relevant Attribution or Designation.

11. <!-- organon:claim C11 --> **No representational efficacy collapse:** Denotation and Rule-mediated participation by a Representation establish neither identity with its target or Reality, nor fidelity of its Map, Causal Contribution, nor Evidential Bearing for its Claim merely because the Representation or a later Consequence occurred.

12. <!-- organon:claim C12 --> **No World collapse:** A World is neither Reality as a whole, an Entity's Environment, nor any Map or Reference through which the World is encountered. Convergence across access paths may supply Observations; it supports a Claim about a common scoped Invariant only through Evidential Bearing. It does not provide unmediated access or make consensus constitutive of the World.

13. <!-- organon:claim C13 --> **No Substrate collapse:** Substrate is a scoped function of a Configuration in a named family of Transformations, not a fundamental substance or intrinsic kind. The Substrate is not identical with a Representation, Invariant, Entity, or function carried through it, and Persistence of carrier and carried Configuration do not entail each other.

14. <!-- organon:claim C14 --> **No truth-status collapse:** Truth neither entails nor is entailed by Agent access, Evidence, proof, consensus, Admission, or institutional standing. A Claim, declared validator, and target Presence do not entail Truth unless a scoped material-adequacy witness connects the Claim's Representation to that Specification and Presence and the Presence conforms.

15. <!-- organon:claim C15 --> **No trust-confidence-control collapse:** Trust requires a maintained Boundary Constraint admitting scoped causal dependence on another Entity's future contribution without determining Control. Confidence, prediction, history, Evidence, Permission, Authority, incentive compatibility, favorable Consequences, or involuntary vulnerability neither separately constitutes Trust nor follows from it.

16. <!-- organon:claim C16 --> **No alignment-totalization:** Alignment obtains only under its declared Specification and Scope. It does not entail identity, faithful representation outside the profile, Truth, Trust, Permission, Authority, shared Agency or purpose, favorable Consequences, or Persistence across later States; Alignment under one profile does not entail Alignment under another.

17. <!-- organon:claim C17 --> **No intelligence-model-or-fixed-capability collapse:** Intelligence belongs to the scoped Agent-level Configuration and requires one joined load-bearing path through Perception, Memory, constructed Model, Interpretation, Action, and Consequence across States not individually named in the producing Rule's recorded Representation. A Model, fixed Interpretation, stored weights, general Capability, successful output, Truth, Alignment, Permission, or Authority neither separately constitutes Intelligence nor follows from it.

18. <!-- organon:claim C18 --> **No operative-knowledge-record-truth collapse:** Operative Knowledge requires a Record, a capable interpreter under stated Constraints, and one discriminating Rule-mediated path in which an alternative Record changes Model, Interpretation, and Action or internal Transformation and the result derives from that selection. A Record cannot bypass the selected Action to manufacture conformity. A Record, Model, Claim, Truth, Evidence, stored output, capable interpreter, or successful effect neither separately constitutes Operative Knowledge nor follows from it; locally operative falsehood remains possible.

19. <!-- organon:claim C19 --> **No knowledge-transmission-copy collapse:** Knowledge Transmission requires recipient Operative Knowledge in a distinct State or stage and preservation under a declared Specification. Copying, exposing, or preserving a Record does not entail Knowledge Transmission; transmission does not entail identical Records, Representations, Models, Interpretations, or distinct Agents; independent acquisition does not establish transmission from a source.

20. <!-- organon:claim C20 --> **No factivity-warrant collapse:** Factive Operative Knowledge requires Operative Knowledge and Truth for the exact Claim carried by its load-bearing Record. Warranted Knowledge additionally requires Evidence admitted for that same Claim, independently grounded for the operative interpreter, and joined supportively through Evidential Bearing. Evidence independent for another Agent cannot fill that join. Operative Knowledge, Truth, Evidence, Admission, or a disposition label alone is insufficient, and institutional Admission does not create Truth.

21. <!-- organon:claim C21 --> **No moral-discourse-status collapse:** Moral Status Attribution and Moral Personhood Designation do not establish their candidate condition; non-attribution and non-designation do not establish its negation. Designation does not independently alter Personhood, Standing, protections, duties, Permissions, Interfaces, prohibited Actions, or Consequences; every downstream effect requires a separate Rule in a named Order and Scope.

22. <!-- organon:claim C22 --> **No sovereignty-profile collapse:** Constituent, Constituted, Boundary, and External Sovereignty do not entail one another, generic Sovereignty, moral legitimacy, Truth, favorable Consequences, or moral personhood. A combined sovereignty Claim must name each profile and every Rule connecting them.

23. <!-- organon:claim C23 --> **No value-profile collapse:** Preference, Utility Measure, Price, institutional valuation, and moral worth do not entail one another without an explicit correspondence Rule and witness. Action does not itself reveal Preference; measurement does not create desire; a Price does not establish exchange or worth; institutional status does not create moral worth.

24. <!-- organon:claim C24 --> **No hidden-bridge substitution:** An Entity identity Claim must name its Invariant and Persistence witness; a Representation must name its Denotation; causal efficacy must name a Causal Contribution comparison; Capability must name the Constraint interpretation and constructive possibility witness; evidential support or defeat must name Evidential Bearing; and institutional eligibility must resolve to Standing in a named Order, Rule, and Scope. None of these bridges follows from resemblance, assertion, co-occurrence, or an untyped predicate.

25. <!-- organon:claim C25 --> **No recurrence-to-ritual collapse:** Ritual entails a Flow, a Rule and constructive Specification through which the participant's Interpretation classifies recurrence under the Flow's Relation, participant-bound Perception of successive occurrences, a prior Memory whose substitution changes that Interpretation, and a sustaining Causal Contribution passing through it. Flow, a Flow classifier, recurrent exposure, a stored Record, Perception, Memory, Interpretation, or Action alone does not entail Ritual. Ritual does not require an outward Action, multiple participants, an Institution, an inherited social form, periodic intervals, conscious recall, or an Agent as its target.

26. <!-- organon:claim C26 --> **Meaning is maintained, not stored:** Meaning entails historical constitution by a Ritual and current maintenance by either qualifying Ritual enactment or an actual ritual-derived Causal Contribution. A target Presence, Record, Memory, Symbol, or other ritual-derived Configuration does not contain Meaning independently. When neither enactment nor such contribution preserves it, the Relation ceases to obtain in the continuing Scope.

27. <!-- organon:claim C27 --> **Meaning propagation is derivation, not copying:** A Meaning Relation produced through causal propagation to another participant is distinct from its source Relation. Shared target, Representation, Rule, or ritual form does not erase the different participant index.

28. <!-- organon:claim C28 --> **Meaning is not silent valuation or status:** Ritual and Meaning entail neither Preference, Utility Measure, Price, institutional valuation, Truth, consent, goodness, consciousness, moral status, moral personhood, nor moral worth. None of those classifications entails Ritual or Meaning without the required Flow, participant access, and sustaining Relation.

29. <!-- organon:claim C29 --> **Target drift is neither identity nor substitution by default:** Variation among target States or Representations preserves one Ritual target only when a declared identity criterion and Persistence witness preserve one target Invariant and every qualifying occurrence reaches or denotes a State in that history. Drift within the Invariant does not terminate the Ritual; breaking the Invariant constitutes target substitution, and any subsequently constituted Meaning Relation is numerically distinct though it may be causally derived. Exact State equality, resemblance, shared naming, uninterrupted enactment, or Denotation alone does not prove target continuity.

30. <!-- organon:claim C30 --> **No Flow-classification collapse:** A Flow obtains through its Transformation occurrences, recurrence Relation, ordered States, and Persistence, not through a Representation that classifies it. A Rule and constructive Specification are required for a reproducible Flow Claim but neither create the recurrence Relation nor establish that the selected occurrences inhabit it. Flow may obtain without any classifier, and different classifiers may track the same Flow without multiplying it.

31. <!-- organon:claim C31 --> **No Ritual-to-benefit collapse:** Ritual and Meaning do not entail voluntary Action, consent, Preference, benefit, health, liberation, or moral endorsement. Addiction and trauma loops may instantiate Ritual and sustain Meaning when every defining causal and interpretive join obtains; recurrence, compulsion, distress, or diagnosis alone does not establish either term.

## Quarantined vocabulary

These terms occur in the corpus but have no binding definition yet. They may be used in ordinary or quoted language, but no argument may depend on their ontological meaning until they are defined and placed in the dependency order.

- **Consciousness:** the underlying condition remains quarantined and is not inferable from Entity, Agent, Memory, Model, Interior, Consciousness Attribution, or Consciousness Designation. The two discourse terms govern Claims and institutional status without defining consciousness itself.
- **Knowledge:** bare knowledge has no binding genus. Use Operative Knowledge, Factive Operative Knowledge, or Warranted Knowledge only when the corresponding operative, truth, and evidence obligations obtain; acquaintance, collective knowledge, and practiced Capability remain unmapped ordinary uses.
- **Moral personhood:** the underlying candidate condition and moral worth remain undefined. Moral Status Attribution and Moral Personhood Designation govern Claims and institutional status without deciding that condition or collapsing it into institutional Person.
- **Sovereignty:** generic Sovereignty has no binding definition. Use Constituent, Constituted, Boundary, or External Sovereignty for the promoted profiles, or declare a Configuration joining them without treating that join as automatic.
- **Value:** generic Value and moral worth remain undefined. Preference, Utility Measure, Price, and the institutional-valuation projection are distinct and may not substitute for one another.
- **Beauty, Play, and Love:** these words have no binding genus here. They may be expressed, stabilized, or transformed through Ritual, but Meaning does not define them and their occurrence cannot be inferred from Meaning alone.

## Intellectual shadows and contribution

This ontology does not claim that its local machinery is unprecedented. Nearly every region has a stronger established shadow. These references discipline the definitions and prevent structural resemblance from being presented as invention.

| Region in this ontology | Strongest local shadows | What this ontology inherits | Boundary of the resemblance |
| --- | --- | --- | --- |
| Absence, Presence, and the performative mark | [G. Spencer-Brown, *Laws of Form*](https://lof50.com/) and [Alain Badiou, *Being and Event*](https://www.bloomsbury.com/being-and-event-9781472511065/) | From Spencer-Brown: beginning through a performed distinction rather than deriving the mark from an unmarked state. From Badiou: the rigor of relating void, presentation, and the operation by which something counts. | Absence is not Spencer-Brown's unmarked state or Badiou's set-theoretic void. Presence is not Badiou's presented multiple. These are local shadows, not interchangeable terms. |
| Missingness, holes, gaps, and shadows | [Roberto Casati and Achille Varzi, *Holes and Other Superficialities*](https://mitpress.mit.edu/9780262531337/holes-and-other-superficialities/) | A hole is not absolute nothing; it is a dependent, structured phenomenon involving a host, boundary, identity, causal role, and perception. This supports distinguishing present signs of Missingness from Absence. | Missingness is broader than holes and does not inherit Casati and Varzi's mereology or geometry. |
| Entity, Boundary, Environment, Interior, and Observation | [Niklas Luhmann, *Social Systems*](https://www.sup.org/books/sociology/social-systems) | The system/environment distinction, operational boundary, self-reference, and the observer's inability to occupy an unmediated view from nowhere. | Entity here is not restricted to an autopoietic system of communications. These definitions are more general and therefore less rigorous than Luhmann's within his domain. |
| Entity, State, Transformation, Persistence, and Relation | [Basic Formal Ontology 2020](https://bfo-ontology.github.io/bfo-2020.html), standardized as [ISO/IEC 21838-2:2021](https://www.iso.org/standard/74572.html), and the [DOLCE foundational ontology](https://www.loa.istc.cnr.it/index.php/dolce/) | The discipline of an upper ontology: explicit categories, typed Relations, dependency order, axiomatization, and consistency testing across domains. | This ontology is not BFO- or DOLCE-conformant and should not borrow their formal credibility. They are rigor benchmarks until an explicit mapping and contradiction audit exist. |
| Identity criteria, Denotation, and relative possibility | David Wiggins, *Sameness and Substance Renewed*; Gottlob Frege, “On Sense and Reference”; Saul Kripke, *Naming and Necessity*; and Per Martin-Löf, *Intuitionistic Type Theory* | Wiggins disciplines reidentification across change; Frege separates an expression from what it designates; Kripke makes possibility relative to an interpretation; Martin-Löf makes constructive assertion answerable to an inhabitant. | Organon leaves identity criteria in the metalanguage but requires Entity to project one through Invariant and Persistence. Denotation does not import Fregean sense, and Capability uses Constraint-relative satisfiability rather than unrestricted possible worlds or constructive logic as a whole. |
| Causal Contribution and Evidential Bearing | David Lewis, “Causation”; James Woodward, *Making Things Happen*; and Stephen Toulmin, *The Uses of Argument* | Lewis and Woodward discipline contrastive dependence rather than mere sequence; Toulmin separates data, warrant, and Claim. | Organon's paired paths test one named input Difference under declared matching conditions and do not supply a complete causal theory. Evidential Bearing makes the evaluation Rule and Order's Record explicit but does not inherit Toulmin's complete argument schema or guarantee epistemic quality. |
| Declaration, Permission, Authority, Standing, Role, Person, Institution, and political Order | [John Searle, *Making the Social World*](https://academic.oup.com/book/5336) | Status functions, constitutive rules, declarations, deontic powers, and the form “X counts as Y in context C” strongly shadow the institutional stack. | A Declaration here is insufficient by utterance alone: it requires an Agent with Authority, a Specification, and an Order that records its Scope. The ontology also connects institutional counting to Capability, Boundary, Observation, Evidence, Ledger, and Constituent exercise. |
| Representation, Rule, and Operationalization | [P. W. Bridgman, *The Logic of Modern Physics*](https://www.gutenberg.org/ebooks/70620), [John Searle, “Human Social Reality and Language”](https://doi.org/10.13128/Phe_Mi-19621), and [Terrence Deacon, *Incomplete Nature*](https://books.google.com/books?id=aT_y7ao96LgC) | Bridgman makes abstract concepts answerable to operations; Searle shows linguistic Representations creating institutional powers through constitutive Rules; Deacon argues that representational and purposive phenomena can have physical causal efficacy. | Operationalization here is broader than measurement, narrower than unconstrained causal influence, and neutral about Deacon's account of mind. It requires a discriminating Rule, exposed Transformation, Scope, and actual Causal-path witness; it does not make every operation semantic or every Representation institutionally constitutive. |
| World and Substrate | [Jakob von Uexküll, *A Foray into the Worlds of Animals and Humans*](https://www.upress.umn.edu/9781452903798/a-foray-into-the-worlds-of-animals-and-humans/), [James J. Gibson, *The Ecological Approach to Visual Perception*](https://www.routledge.com/The-Ecological-Approach-to-Visual-Perception-Classic-Edition/Gibson/p/book/9781848725782), [Aristotle, *Physics*, Book I](https://classics.mit.edu/Aristotle/physics.1.i.html), and [Gilbert Simondon, *On the Mode of Existence of Technical Objects*](https://www.upress.umn.edu/9781517904876/on-the-mode-of-existence-of-technical-objects/) | Uexküll makes accessible worlds participant-relative; Gibson joins environment to possible perception and action; Aristotle identifies an underlying subject persisting through change; Simondon makes the associated milieu an active condition of technical operation rather than passive matter. | World here is not a private phenomenal bubble and does not adopt Gibson's direct realism: its common Invariant remains available only through constrained paths. Substrate is neither Aristotelian prime matter nor Simondon's associated milieu wholesale; it is a contextual Configuration specified by the input States it supplies and the Constraints it contributes to a named family of Transformations. |
| Truth, Trust, and Alignment | [Alfred Tarski, “The Semantic Conception of Truth”](https://www.jfsowa.com/logic/tarski.htm), [Annette Baier, “Trust and Antitrust”](https://www.jstor.org/stable/2265347), [Karen Jones, “Trust as an Affective Attitude”](https://www.jstor.org/stable/2381965), [Russell Hardin, *Trust and Trustworthiness*](https://www.russellsage.org/publications/book/trust-and-trustworthiness), [Niklas Luhmann, *Trust and Power*](https://www.wiley.com/en-us/Trust+and+Power-p-9781509519458), and [Terry et al., “Interactive AI Alignment”](https://arxiv.org/abs/2311.00710) | Tarski disciplines Claim-to-condition correspondence and the object-language/metalanguage boundary; trust theory distinguishes vulnerability, attitude, encapsulated interest, and complexity reduction; alignment research distinguishes target Specification, process, and evaluation profiles. | Truth here requires local material adequacy but does not claim a complete Tarskian semantics for natural language. Trust requires maintained admission and undetermined contribution but not goodwill, optimism, confidence, or shared interest. Alignment is a generic specified-correspondence Relation, not a claim that one profile captures human values or composes with another. |
| Intelligence, Operative Knowledge, and Knowledge Transmission | [Shane Legg and Marcus Hutter, “Universal Intelligence: A Definition of Machine Intelligence”](https://arxiv.org/abs/0712.3329), [Gilbert Ryle, *The Concept of Mind*](https://books.google.com/books?id=mSbjClXFaIkC), [Claude Shannon, “A Mathematical Theory of Communication”](https://onlinelibrary.wiley.com/doi/abs/10.1002/j.1538-7305.1948.tb00917.x), and [Dan Sperber, “Why a deep understanding of cultural evolution is incompatible with shallow psychology”](https://www.dan.sperber.fr/wp-content/uploads/2006_why-a-deep-understanding-of-cultural-evolution-is-incompatible.pdf) | Legg and Hutter test intelligence across environments rather than one task; Ryle resists reducing intelligent performance to prior propositions; Shannon disciplines source-channel-recipient structure; Sperber distinguishes reconstruction from literal copying in cultural transmission. | Intelligence here requires adaptive Model construction and resulting Interpretation rather than assigning a scalar measure or optimal policy. Operative Knowledge is a Record-interpreter Configuration and does not inherit Ryle's complete account of knowing-how. Knowledge Transmission adds semantic-functional reconstruction that Shannon deliberately brackets and does not claim a general theory of culture. |
| Epistemic, moral, sovereign, and valuation profiles | [Edmund Gettier, “Is Justified True Belief Knowledge?”](https://www.jstor.org/stable/3326922), [Immanuel Kant, *Groundwork of the Metaphysics of Morals*](https://www.gutenberg.org/ebooks/5682), [Thomas Hobbes, *Leviathan*](https://www.gutenberg.org/ebooks/3207), [Carl Schmitt, *Political Theology*](https://press.uchicago.edu/ucp/books/book/chicago/P/bo3643854.html), [Antonio Negri, *Insurgencies*](https://www.upress.umn.edu/9780816622740/insurgencies/), the [Montevideo Convention](https://www.oas.org/juridico/english/sigs/a-40.html), [Paul Samuelson, “A Note on the Pure Theory of Consumer's Behaviour”](https://www.jstor.org/stable/2548836), and [John von Neumann and Oskar Morgenstern, *Theory of Games and Economic Behavior*](https://press.princeton.edu/books/paperback/9780691130613/theory-of-games-and-economic-behavior) | Gettier blocks an easy justified-true-belief analysis; Kant separates moral consideration from price; Hobbes, Schmitt, Negri, and recognition practice expose distinct loci of sovereign power; Samuelson and von Neumann and Morgenstern discipline preference and utility representation. | Organon does not solve knowledge, moral worth, sovereignty, or value as generic concepts. It promotes narrower Configurations and Relations, keeps candidate conditions separate from institutional designation, and refuses silent composition among profiles. |
| Flow, Ritual, and Meaning | Émile Durkheim, *The Elementary Forms of Religious Life*; Roy Rappaport, *Ritual and Religion in the Making of Humanity*; Catherine Bell, *Ritual Theory, Ritual Practice*; Randall Collins, *Interaction Ritual Chains*; Charles Sanders Peirce's triadic semiotics; and Ludwig Wittgenstein's account of meaning and use | Repetition and formalized performance, participation, effects carried through practice, and the refusal to locate significance as a substance inside an isolated sign or object. | Organon permits private Ritual rather than requiring collective assembly, makes every sustaining causal join explicit, and defines Meaning as a participant-indexed Relation rather than emotional energy, sacred status, Denotation, or linguistic use. It does not claim that these sources share one theory or that any tradition reduces to this schema. |

### The originality boundary

No local section claims originality merely because it renames established machinery. As a philosophical ontology, the institutional half bears the burden of distinguishing itself from Searle, and the entity machinery bears the burden of surviving comparison with Luhmann, BFO, and DOLCE.

The defensible contribution is the **unification constraint**: metaphysical, perceptual, agentic, evidentiary, and institutional terms must inhabit one dependency chain and remain consistent with the same Absence/Presence partition. Searle does not need his status functions to descend from Daniel's primitive; Luhmann does not need his system/environment distinction to share an ontology with Evidence and Constituent exercise; BFO and DOLCE do not begin from the performative obtainment of Presence. The unification constraint forces those local regions to coexist without changing the meaning of a term at their borders.

That unification is an editorial contribution, not a demonstrated philosophical one. A stronger claim requires formal mappings to the shadow frameworks, explicit points of disagreement, and proofs or model checks showing that the combined dependency system remains satisfiable.

## How to use the ontology

For any essay, project narrative, or editorial evaluation:

1. Identify every term that carries an ontological argument.

2. Resolve each term to this dependency order. If it is absent, use ordinary wording that carries no new ontological commitment; the concept remains outside the ontology.

3. Check every Relation against the signatures and consistency rules.

4. Treat a concept absent from the dependency order as outside the ontology unless it receives a dependency-closed definition.

5. Keep ontology, editorial grammar, and delivery separate. The ontology governs what the argument says exists and how it relates. The [Long-Form Editorial Grammar](../editorial/long-form.md) governs how the reader is brought to the idea. [Short Form](../editorial/short-form.md) governs delivery at sentence scale.

## Scope and limitations

Internal closure does not establish metaphysical completeness. Absence is primitive; A3 defines Presence as its exhaustive and exclusive complement; A4 demonstrates that Presence obtains because the ontology's own statement is already a mark. Presence is not causally generated or logically derived from Absence alone.

Ritual-dependent Meaning is one binding account of significance, not a complete aesthetics, ethics, theology, philosophy of mind, or anthropology. Beauty, Play, Love, sacredness, grief, goodness, consent, consciousness, and moral worth remain outside the definition. The noncanonical formal shadow proves participant-history access and exact causal joins, not complete Sense-to-Perception uptake or a universal law of temporal decay.

In the [Long-Form Editorial Grammar](../editorial/long-form.md), **Missingness** names the felt gap an article makes consequential. **Absence** remains reserved for the absolute primitive defined here.
