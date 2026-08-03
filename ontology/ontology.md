---
type: editorial-ontology
status: provisional-binding
binding: true
version: 0.12
created: 2026-08-01
updated: 2026-08-03
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

The metalanguage supplies classical logic, including excluded middle, together with identity, negation, logical consequence, quantification, ordering, set membership, statements and marks, and the ability to distinguish an expression from what it denotes. These are rules for stating the ontology, not additional kinds of being inside it.

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

**Entity** is a Configuration that retains identity through the Persistence of an Invariant named for that identity.

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

**Representation** is a Presence used within a Relation to stand for another Presence, Relation, or Configuration. It is not identical with what it represents.

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

**Sign** is a Representation used as a trace of another Presence, Relation, or Change.

<a id="organon-symbol"></a>
<!-- organon:term organon:Symbol claim=D022 -->

**Symbol** is a Representation whose use is stabilized through repetition.

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

**Model** is an organized Configuration of Representations and Transformations used to relate Perception and Memory to possible later States.

<a id="organon-action"></a>
<!-- organon:term organon:Action claim=D032 -->

**Action** is a Transformation across an Entity's Boundary belonging to a Causal path that begins with an internal State of that Entity.

<a id="organon-consequence"></a>
<!-- organon:term organon:Consequence claim=D033 -->

**Consequence** is a Change at the end of a Causal path that begins with an Action.

<a id="organon-interpretation"></a>
<!-- organon:term organon:Interpretation claim=D034 -->

**Interpretation** is a Transformation by which an Entity uses Perception, Memory, or a Model to distinguish among available Actions.

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

**Capability** is the set of Actions an Agent can produce under stated environmental, technical, and temporal Constraints.

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

**Standing** is the Relation through which an Order records an Entity as eligible within a specified institutional Scope. Standing in one Order supplies no Standing in another.

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

<a id="organon-attestation"></a>
<!-- organon:term organon:Attestation claim=D067 -->

**Attestation** is a Claim made by a Witness about an Observation or Evidence under a Specification of the Witness's identity, Scope, Order, and relevant independence.

Evidence can support or defeat a Claim; it does not become truth by definition. No Agent's Claim, self-authored Rule, or domesticated Witness independently certifies that Agent.

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

This ontology does not define an Evidentiary Profile for consciousness discourse. Supported, defeated, and underdetermined remain ordinary disposition labels until each Evidence item is joined to an Observation, a Witness IndependentFor the relevant claimant and Claim, an Admissibility Rule and Order, and an evaluation Rule whose result is proved equal to the recorded disposition.

### 22. Operationalized representation

<a id="organon-operationalization"></a>
<!-- organon:term organon:Operationalization claim=D082 -->

**Operationalization** is a Configuration joining a Representation, a Rule, an Interface, and a Scope in which the Rule selects at least one Transformation in response to that Representation, the Interface exposes that Transformation, and a Causal path contains it.

The selection must be discriminating: under the same Rule and within the same Scope, at least one distinct Representation would not select that Transformation. This distinguishes a Representation operating through its represented form from a physical carrier that happens to occur in a Causal path while its representational Difference does no work.

An Operationalized Representation can contribute causally to later States and, when the path includes an Agent's Interpretation and Action, to Consequences. Causal efficacy does not make the Representation identical to what it represents or to Reality. It does not establish that a Claim expressed by the Representation is supported by Evidence. A distorted Map can still coordinate Action; the resulting Consequence establishes that the Representation participated through a Rule in a Causal path, not that it represented its target faithfully.

### 23. World and substrate

<a id="organon-world"></a>
<!-- organon:term organon:World claim=D083 -->

**World** is a scoped Configuration containing one or more Entities, selected Presence from their Environments, and the States, Relations, and Causal paths available to their Perception, Interpretation, or Action under named Constraints.

Availability requires an included Causal path: from an Environment through Sense into Perception, from an internal State through Action, or through both. A World must name at least one Invariant that persists across distinct combinations of Senses, Maps, or References within its Scope. The access paths may expose different States or Differences while still bearing on that common Invariant.

A World is part of Reality, not an alternative to it. It includes participating Entities and therefore is not their Environment. A Map or Reference represents a World without becoming it. Agreement among Maps can supply Evidence for a Claim about a World; neither agreement nor consensus constitutes the World by itself.

Different Worlds may overlap in Presence while differing in participants, Scope, available Causal paths, or named Invariants. An Order can transform a political World by changing actual Rules, institutional Boundaries, statuses, and available Actions. It does not create Reality from nothing.

<a id="organon-substrate"></a>
<!-- organon:term organon:Substrate claim=D084 -->

**Substrate** is a Configuration specified within a Scope as the persistent source of input States for a named family of Transformations. Those States Feed the Transformation inputs, while Constraints in the Configuration determine which Differences can be preserved, suppressed, or amplified in the outputs.

Substrate is contextual, not a fundamental kind. The same Configuration can be Substrate for one family of Transformations and an Entity, Environment, Tool, represented target, or output in another Scope. It is not passive raw material: its existing Relations and Constraints participate in what the Transformations can produce.

A Substrate remains distinct from a Representation, Invariant, Entity, or function carried through it. Persistence of the Substrate does not entail Persistence of what it carries, and preservation of a carried Invariant does not require identity of Substrate across every State.

## Relation signatures

These signatures make the ontology operational. They are schemas, not executable syntax.

| Relation | Inputs | Result or constraint |
| --- | --- | --- |
| `directs` | Relation, input State, output State | forward ordering excludes reverse ordering under the same Relation |
| `feeds` | output State, input State, Specification of contribution | part of one State supplies part of the other without requiring equality |
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
| `recognizes` | Order, Entity, Rule, Scope | Standing in that Order |
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
| `attests` | Witness, Claim, Specification, Order | scoped Claim about Observation or Evidence |
| `institutes` | Roles, Records, Interfaces, recurring Flows | persistent Order |
| `constitutes` | Polity, coordinated Agency, existing Order | transformed Order |
| `attributesConsciousness` | Agent, target Entity, State, Representation, candidate Specification, Language, meaning Rule, Map, Claim Scope | Consciousness Attribution; no entailment that the candidate condition obtains |
| `designatesConsciousness` | Order, Rule, institutional purpose, admitted Consciousness Attribution, institutional Scope | one CountsAs event for the Attribution's target Entity and State; no downstream institutional effect without a separate Rule |
| `operationalizes` | Representation, Rule, Interface, Scope, selected Transformation, Causal path | Rule discriminates the Representation, Interface exposes the selected Transformation, and that Transformation occurs in the path; no entailment of representational identity, Map fidelity, or Evidence |
| `composesWorld` | Entities, selected Environment, Scope, Constraints, included Causal paths, named Invariant | participant-scoped World whose distinct access paths bear on the common Invariant; no identity with Reality, Environment, Map, or Reference |
| `servesAsSubstrate` | Configuration, Scope, persistent input States, Feeds, Constraints, family of Transformations | contextual Substrate; no entailment that carrier and carried Configuration are identical or persist together |

## Binding consistency rules

1. <!-- organon:claim C1 --> **Dependency closure:** A binding definition may use only the metalanguage, Absence and its axioms, or terms defined earlier in the dependency order.

2. <!-- organon:claim C2 --> **One term, one meaning:** A term cannot change meaning between technical, political, and editorial contexts without an explicit new term or projection.

3. <!-- organon:claim C3 --> **No projection inflation:** Different descriptions of one Entity do not create different Entities or kinds of Agency.

4. <!-- organon:claim C4 --> **No Absence collapse:** Missingness, zero, omission, silence, shadow, gap, and exception are Presences inside fields. None is Absence.

5. <!-- organon:claim C5 --> **No map-Reality collapse:** A Perception, Model, Map, Canonical system, or Ledger never equals Reality.

6. <!-- organon:claim C6 --> **No claim-evidence collapse:** An Agent's report of its own Action remains a Claim unless an admissible Observation supplies Evidence.

7. <!-- organon:claim C7 --> **No capability-authority collapse:** Technical possibility does not supply institutional standing, and institutional standing does not supply technical possibility.

8. <!-- organon:claim C8 --> **No privacy-consciousness collapse:** Interiority does not prove consciousness, and accountability does not require total Exposure.

9. <!-- organon:claim C9 --> **No metaphor promotion:** A metaphor may reveal a Relation, but resemblance alone cannot establish an Entity, causal claim, or Invariant.

10. <!-- organon:claim C10 --> **No consciousness discourse collapse:** A Consciousness Attribution does not establish its candidate condition; a Consciousness Designation does not establish that condition or independently alter Standing, Personhood, Permissions, protections, Interfaces, or Consequences; and failure to attribute or designate establishes neither Absence nor negation. Missingness obtains only in a field or Order that represents or expects the relevant Attribution or Designation.

11. <!-- organon:claim C11 --> **No representational efficacy collapse:** Rule-mediated participation by a Representation in a real Transformation establishes neither identity with its target or Reality, nor fidelity of its Map, nor Evidence for its Claim merely because the selected Transformation or a later Consequence occurred.

12. <!-- organon:claim C12 --> **No World collapse:** A World is neither Reality as a whole, an Entity's Environment, nor any Map or Reference through which the World is encountered. Convergence across access paths supports Claims about a common scoped Invariant; it does not provide unmediated access or make consensus constitutive of the World.

13. <!-- organon:claim C13 --> **No Substrate collapse:** Substrate is a scoped function of a Configuration in a named family of Transformations, not a fundamental substance or intrinsic kind. The Substrate is not identical with a Representation, Invariant, Entity, or function carried through it, and Persistence of carrier and carried Configuration do not entail each other.

## Quarantined vocabulary

These terms occur in the corpus but have no binding definition yet. They may be used in ordinary or quoted language, but no argument may depend on their ontological meaning until they are defined and placed in the dependency order.

- **Consciousness:** the underlying condition remains quarantined and is not inferable from Entity, Agent, Memory, Model, Interior, Consciousness Attribution, or Consciousness Designation. The two discourse terms govern Claims and institutional status without defining consciousness itself.
- **Intelligence:** no binding definition; corpus uses include search, interpretation, generalization, coherence, and capacity to alter an Environment.
- **Knowledge:** no binding definition; corpus uses include persistent Model, warranted Claim, transmissible Record, and practiced capability.
- **Truth:** no binding definition; Evidence bears on Claims without establishing truth conditions.
- **Trust:** no binding definition; corpus uses include prediction, relationship, delegated exposure, and institutional acceptance.
- **Alignment:** no binding definition; corpus uses include behavioral similarity, faithful representation of a Principal, incentive compatibility, and bounded Authority.
- **Moral personhood:** no binding definition; it remains distinct from institutional Person.
- **Sovereignty:** no binding definition distinct from Authority, Constituent power, and exceptional Action.
- **Value:** no binding definition distinguishing preference, price, utility, moral worth, and institutional recognition.

## Intellectual shadows and contribution

This ontology does not claim that its local machinery is unprecedented. Nearly every region has a stronger established shadow. These references discipline the definitions and prevent structural resemblance from being presented as invention.

| Region in this ontology | Strongest local shadows | What this ontology inherits | Boundary of the resemblance |
| --- | --- | --- | --- |
| Absence, Presence, and the performative mark | [G. Spencer-Brown, *Laws of Form*](https://lof50.com/) and [Alain Badiou, *Being and Event*](https://www.bloomsbury.com/being-and-event-9781472511065/) | From Spencer-Brown: beginning through a performed distinction rather than deriving the mark from an unmarked state. From Badiou: the rigor of relating void, presentation, and the operation by which something counts. | Absence is not Spencer-Brown's unmarked state or Badiou's set-theoretic void. Presence is not Badiou's presented multiple. These are local shadows, not interchangeable terms. |
| Missingness, holes, gaps, and shadows | [Roberto Casati and Achille Varzi, *Holes and Other Superficialities*](https://mitpress.mit.edu/9780262531337/holes-and-other-superficialities/) | A hole is not absolute nothing; it is a dependent, structured phenomenon involving a host, boundary, identity, causal role, and perception. This supports distinguishing present signs of Missingness from Absence. | Missingness is broader than holes and does not inherit Casati and Varzi's mereology or geometry. |
| Entity, Boundary, Environment, Interior, and Observation | [Niklas Luhmann, *Social Systems*](https://www.sup.org/books/sociology/social-systems) | The system/environment distinction, operational boundary, self-reference, and the observer's inability to occupy an unmediated view from nowhere. | Entity here is not restricted to an autopoietic system of communications. These definitions are more general and therefore less rigorous than Luhmann's within his domain. |
| Entity, State, Transformation, Persistence, and Relation | [Basic Formal Ontology 2020](https://bfo-ontology.github.io/bfo-2020.html), standardized as [ISO/IEC 21838-2:2021](https://www.iso.org/standard/74572.html), and the [DOLCE foundational ontology](https://www.loa.istc.cnr.it/index.php/dolce/) | The discipline of an upper ontology: explicit categories, typed Relations, dependency order, axiomatization, and consistency testing across domains. | This ontology is not BFO- or DOLCE-conformant and should not borrow their formal credibility. They are rigor benchmarks until an explicit mapping and contradiction audit exist. |
| Declaration, Permission, Authority, Standing, Role, Person, Institution, and political Order | [John Searle, *Making the Social World*](https://academic.oup.com/book/5336) | Status functions, constitutive rules, declarations, deontic powers, and the form “X counts as Y in context C” strongly shadow the institutional stack. | A Declaration here is insufficient by utterance alone: it requires an Agent with Authority, a Specification, and an Order that records its Scope. The ontology also connects institutional counting to Capability, Boundary, Observation, Evidence, Ledger, and Constituent exercise. |
| Representation, Rule, and Operationalization | [P. W. Bridgman, *The Logic of Modern Physics*](https://www.gutenberg.org/ebooks/70620), [John Searle, “Human Social Reality and Language”](https://doi.org/10.13128/Phe_Mi-19621), and [Terrence Deacon, *Incomplete Nature*](https://books.google.com/books?id=aT_y7ao96LgC) | Bridgman makes abstract concepts answerable to operations; Searle shows linguistic Representations creating institutional powers through constitutive Rules; Deacon argues that representational and purposive phenomena can have physical causal efficacy. | Operationalization here is broader than measurement, narrower than unconstrained causal influence, and neutral about Deacon's account of mind. It requires a discriminating Rule, exposed Transformation, Scope, and actual Causal-path witness; it does not make every operation semantic or every Representation institutionally constitutive. |
| World and Substrate | [Jakob von Uexküll, *A Foray into the Worlds of Animals and Humans*](https://www.upress.umn.edu/9781452903798/a-foray-into-the-worlds-of-animals-and-humans/), [James J. Gibson, *The Ecological Approach to Visual Perception*](https://www.routledge.com/The-Ecological-Approach-to-Visual-Perception-Classic-Edition/Gibson/p/book/9781848725782), [Aristotle, *Physics*, Book I](https://classics.mit.edu/Aristotle/physics.1.i.html), and [Gilbert Simondon, *On the Mode of Existence of Technical Objects*](https://www.upress.umn.edu/9781517904876/on-the-mode-of-existence-of-technical-objects/) | Uexküll makes accessible worlds participant-relative; Gibson joins environment to possible perception and action; Aristotle identifies an underlying subject persisting through change; Simondon makes the associated milieu an active condition of technical operation rather than passive matter. | World here is not a private phenomenal bubble and does not adopt Gibson's direct realism: its common Invariant remains available only through constrained paths. Substrate is neither Aristotelian prime matter nor Simondon's associated milieu wholesale; it is a contextual Configuration specified by the input States it supplies and the Constraints it contributes to a named family of Transformations. |

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

In the [Long-Form Editorial Grammar](../editorial/long-form.md), **Missingness** names the felt gap an article makes consequential. **Absence** remains reserved for the absolute primitive defined here.
