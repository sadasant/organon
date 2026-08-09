---
type: ontology-prompt-projection
status: generated-noncanonical
ontology_version: "0.18.0"
projection_mode: "full"
binding_source: ontology.md
---
# Organon Prompt Projection

> This is a deterministic, lossy projection of the binding Markdown ontology.
> It preserves registered primary statements, dependency order, and selected
> commitments. When precision depends on omitted explanation, consult
> `ontology/ontology.md`; this projection cannot amend or overrule it.

## Operating contract

- Use a registered term only with the meaning recorded below.
- Do not infer a term when any named dependency or load-bearing join is missing.
- Ordinary vocabulary and capitalization do not constitute an Organon mapping.
- Keep ontological, causal, epistemic, and institutional relations distinct unless an explicit Rule joins them.
- Treat quarantined terms as undefined except for the protocol explicitly recorded for them.
- Treat generated classifications as Claims, not Truth, Evidence, adoption, or promotion.
- Prefer an explicit unmapped or underdetermined result to a resemblance-based promotion.

## Projection scope

- Mode: full
- Requested: all registered terms
- Terms carried: 109 of 109
- Commitments carried: 42 of 42

## Metalanguage boundary

No ontology can define every word using only itself. Definition requires a metalanguage. This document therefore states its boundary instead of hiding it.

The metalanguage supplies classical logic, including excluded middle, together with identity, negation, logical consequence, quantification, ordering, set membership, statements and marks, and the ability to distinguish an expression from what it denotes. Identity includes criteria for reidentifying what a statement treats as the same across ordered positions. An Entity claim must project that criterion into the object language by naming an Invariant, ordered States, and a Persistence witness; metalinguistic identity does not supply that witness.

The metalanguage also supplies relative possibility as satisfiability under stated Constraints: a candidate is possible only when at least one declared interpretation of those Constraints admits it. Every binding use of “can” or “possible” must name that Constraint context and a constructive witness. Relative possibility is not an additional Presence, a prediction that an event will occur, or unrestricted metaphysical modality.

These are rules for stating the ontology, not additional kinds of being inside it. The metalinguistic distinction between expression and target does not itself establish a Denotation in Reality; object-language Denotation is defined below. Likewise, identity criteria and relative possibility do not silently supply Entity, Capability, causal, evidentiary, or institutional facts.

Within that boundary, every registered ontological term is either the primitive, an axiom concerning the primitive, a dependency-ordered definition, or a quarantined term with no binding meaning yet. Ordinary connective language and unmapped capitalization carry no independent ontological commitment.

## Foundational commitments

### `A1` · axiom

Absence contains nothing: no quality, part, distinction, relation, position, boundary, order, or duration. Nothing can be inside it, outside it, before it, after it, or related to it as one being relates to another.

Depends: organon:Absence.

### `A2` · axiom

Absence admits no degree or approximation. Only what is identically Absence is Absence. “Almost Absence,” partial Absence, and qualified Absence are not Absence.

Depends: organon:Absence.

### `A3` · axiom

**Presence** is whatever is not identically Absence.

Depends: organon:Absence.

### `A4` · axiom

If anything is stated at all, that statement is not identically Absence; by A3, it is Presence. This ontology is itself a statement and a mark. Therefore Presence obtains.

Depends: organon:Presence, A3.

### `A5` · axiom

**Missingness** is a relation inside Presence: a field represents or expects a Presence that it does not contain. Gaps, omissions, zeros, shadows, exceptions, refusals, and silences can be present signs of Missingness. They are not Absence itself.

Depends: organon:Presence.

## Registered terms

### `organon:Absence` · Absence

**Absence** is absolute. It is not an empty region, an omitted item, an unavailable value, a zero, a shadow, a silence, or the absence *of* something. Each of those is already something represented within a field.

Claim: `P1` (primitive).
Depends: none.

### `organon:Presence` · Presence

**Presence** is whatever is not identically Absence.

Claim: `A3` (axiom).
Depends: organon:Absence.

### `organon:Missingness` · Missingness

**Missingness** is a relation inside Presence: a field represents or expects a Presence that it does not contain. Gaps, omissions, zeros, shadows, exceptions, refusals, and silences can be present signs of Missingness. They are not Absence itself.

Claim: `A5` (axiom).
Depends: organon:Presence.

### `organon:Reality` · Reality

**Reality** is the totality of Presence. No part of Reality is licensed to identify the portion available to it with Reality as a whole.

Claim: `D001` (definition).
Depends: organon:Presence.

### `organon:Difference` · Difference

**Difference** is the non-identity of two Presences or two ordered configurations of Presence. Difference is inside Reality; the defining departure of Presence from Absence belongs to the metalanguage and must not be mistaken for an ontological relation involving Absence.

Claim: `D002` (definition).
Depends: organon:Presence, organon:Reality.

### `organon:Relation` · Relation

**Relation** is a Presence in which two or more Presences have an ordered association. A relation does not erase the differences among its participants.

Claim: `D003` (definition).
Depends: organon:Presence.

### `organon:Denotation` · Denotation

**Denotation** is an ordered Relation whose first participant occupies an expression position and whose later participant is the Presence, Relation, or Configuration that is its target. A Denotation must name both participants and their ordered positions. It establishes neither fidelity, Truth, Interpretation, institutional status, nor participation in a Causal path.

Claim: `D102` (definition).
Depends: organon:Presence, organon:Relation.

### `organon:Configuration` · Configuration

**Configuration** is a set of Presences and Relations considered together.

Claim: `D004` (definition).
Depends: organon:Presence, organon:Relation.

### `organon:State` · State

**State** is a Configuration indexed at a position in the metalanguage's ordering. That position distinguishes States without adding a Relation to Reality.

Claim: `D005` (definition).
Depends: organon:Configuration.

### `organon:Direction` · Direction

**Direction** is a Relation between States such that, when it orders one State before another, the same Relation does not order the second State before the first.

Claim: `D006` (definition).
Depends: organon:Relation, organon:State.

### `organon:Transformation` · Transformation

**Transformation** is a Relation mapping an input State to an output State under a Direction.

Claim: `D007` (definition).
Depends: organon:Relation, organon:State, organon:Direction.

### `organon:Change` · Change

**Change** is the Difference between States joined by a Transformation.

Claim: `D008` (definition).
Depends: organon:Difference, organon:State, organon:Transformation.

### `organon:Feeds` · Feeds

**Feeds** is a Relation from one State to another under an explicit account of which part of the first State supplies which part of the second. Feeds does not require equality between those States.

Claim: `D009` (definition).
Depends: organon:Relation, organon:State.

### `organon:CausalPath` · Causal path

**Causal path** is a sequence of Transformations sharing one Direction in which the output State of each Transformation Feeds the input State of the next. Its arrow is inherited from the Direction of its Transformations; reversing the sequence does not preserve the same Causal path.

Claim: `D010` (definition).
Depends: organon:Transformation, organon:Direction, organon:Feeds, organon:State.

### `organon:CausalContribution` · Causal Contribution

**Causal Contribution** is a Relation established by two nonempty comparison Causal paths that share one Direction and match at every stated input position except a named upstream Difference, while their endpoint States exhibit a named downstream Change. The upstream Difference contributes to that Change within the comparison. Both path witnesses and the matched-input account are required; occurrence in one path, temporal precedence, or correlation alone is insufficient.

Claim: `D103` (definition).
Depends: organon:Relation, organon:Difference, organon:State, organon:Direction, organon:Transformation, organon:Change, organon:CausalPath.

### `organon:Invariant` · Invariant

**Invariant** is a part, Relation, or Configuration named as preserved under a named set of Transformations. An Invariant is never meaningful without naming both what is preserved and across which Transformations.

Claim: `D011` (definition).
Depends: organon:Relation, organon:Configuration, organon:Transformation.

### `organon:Persistence` · Persistence

**Persistence** is the preservation of an Invariant across an ordered sequence of States.

Claim: `D012` (definition).
Depends: organon:Invariant, organon:State.

### `organon:Constraint` · Constraint

**Constraint** is a persistent Relation that excludes some Transformations while permitting others.

Claim: `D013` (definition).
Depends: organon:Persistence, organon:Relation, organon:Transformation.

### `organon:Entity` · Entity

**Entity** is a Configuration that retains identity through the Persistence of an Invariant named as its object-language identity criterion. The Entity claim must identify the ordered States and Persistence witness that realize the criterion supplied by the metalanguage.

Claim: `D014` (definition).
Depends: organon:Configuration, organon:Persistence, organon:Invariant.

### `organon:Boundary` · Boundary

**Boundary** is a Configuration of Constraints indexed to the Invariant whose Persistence constitutes an Entity's identity. Those Constraints determine which Transformations preserve that identity and which cross the distinction between the Entity and other Presence.

Claim: `D015` (definition).
Depends: organon:Configuration, organon:Constraint, organon:Invariant, organon:Persistence, organon:Entity.

### `organon:Environment` · Environment

**Environment** is the Presence related to an Entity but not included in the identity delimited by its Boundary.

Claim: `D016` (definition).
Depends: organon:Presence, organon:Entity, organon:Boundary.

### `organon:Representation` · Representation

**Representation** is the Presence occupying the expression position in a Denotation. A Representation claim must name that Denotation and its target. The Representation is not identical with its target, and Denotation alone establishes neither Interpretation nor causal or institutional use.

Claim: `D017` (definition).
Depends: organon:Presence, organon:Relation, organon:Denotation, organon:Configuration.

### `organon:Scope` · Scope

**Scope** is the set of Presences, Relations, States, or Transformations to which a Representation or Constraint applies.

Claim: `D018` (definition).
Depends: organon:Presence, organon:Relation, organon:State, organon:Transformation, organon:Representation, organon:Constraint.

### `organon:Specification` · Specification

**Specification** is a Representation that identifies a Scope and supplies a constructive decision procedure for membership or conformity within that Scope. Classical bivalence alone does not make an arbitrary predicate a Specification.

Claim: `D019` (definition).
Depends: organon:Representation, organon:Scope.

### `organon:Rule` · Rule

**Rule** is a Specification of a Constraint or Transformation that maps conforming inputs to a set of outputs.

Claim: `D020` (definition).
Depends: organon:Specification, organon:Constraint, organon:Transformation.

### `organon:Sign` · Sign

**Sign** is a Representation whose target Presence, Relation, or Change is joined to the Sign by a Causal path ending in the State that contains it. A merely assigned Denotation without that path is not a trace.

Claim: `D021` (definition).
Depends: organon:Representation, organon:Denotation, organon:Presence, organon:Relation, organon:Change, organon:CausalPath, organon:State.

### `organon:Symbol` · Symbol

**Symbol** is a Representation whose Denotation persists across repeated States or Transformations under a Rule.

Claim: `D022` (definition).
Depends: organon:Representation, organon:Denotation, organon:Persistence, organon:State, organon:Transformation, organon:Rule.

### `organon:Language` · Language

**Language** is a persistent system of Symbols and Rules for transforming them through which changes of State can be coordinated.

Claim: `D023` (definition).
Depends: organon:Persistence, organon:Symbol, organon:Rule, organon:State.

### `organon:Map` · Map

**Map** is a Representation organized for navigation, prediction, or governance. A Map selects from Reality; its omissions and distortions belong to its definition, not merely to its failures.

Claim: `D024` (definition).
Depends: organon:Representation, organon:Reality.

### `organon:Reference` · Reference

**Reference** is a Map paired with a Specification of its Scope, Constraints, and enumerated distortions for use as a comparison surface.

Claim: `D025` (definition).
Depends: organon:Map, organon:Specification, organon:Scope, organon:Constraint.

### `organon:Sense` · Sense

**Sense** is a subset of the Constraints composing an Entity's Boundary through which Differences in an Environment enter a Causal path ending in Differences inside that Entity.

Claim: `D026` (definition).
Depends: organon:Constraint, organon:Entity, organon:Boundary, organon:Difference, organon:Environment, organon:CausalPath.

### `organon:Perception` · Perception

**Perception** is an internal State produced through Sense.

Claim: `D027` (definition).
Depends: organon:State, organon:Sense.

### `organon:Record` · Record

**Record** is a persistent Representation of an earlier State, Relation, or Change.

Claim: `D028` (definition).
Depends: organon:Persistence, organon:Representation, organon:State, organon:Relation, organon:Change.

### `organon:Observation` · Observation

**Observation** is a Record whose production includes a Specification of the Causal path from an Environment through a Sense. An Observation is not Reality itself and does not become independent merely because it was recorded.

Claim: `D029` (definition).
Depends: organon:Record, organon:Specification, organon:CausalPath, organon:Environment, organon:Sense, organon:Reality.

### `organon:Memory` · Memory

**Memory** is an internal Record whose Persistence can condition a later State of the same Entity.

Claim: `D030` (definition).
Depends: organon:Record, organon:Persistence, organon:State, organon:Entity.

### `organon:Model` · Model

**Model** is an organized Configuration of Representations and Transformations that relates Perception and Memory to later States under its stated Constraints.

Claim: `D031` (definition).
Depends: organon:Configuration, organon:Representation, organon:Transformation, organon:Perception, organon:Memory, organon:State, organon:Constraint.

### `organon:Action` · Action

**Action** is a Transformation across an Entity's Boundary belonging to a Causal path that begins with an internal State of that Entity.

Claim: `D032` (definition).
Depends: organon:Transformation, organon:Entity, organon:Boundary, organon:CausalPath, organon:State.

### `organon:Consequence` · Consequence

**Consequence** is a Change at the end of a Causal path that begins with an Action.

Claim: `D033` (definition).
Depends: organon:Change, organon:CausalPath, organon:Action.

### `organon:Interpretation` · Interpretation

**Interpretation** is a Transformation joining an Entity's Perception, Memory, or Model to a distinction among available Actions.

Claim: `D034` (definition).
Depends: organon:Transformation, organon:Entity, organon:Perception, organon:Memory, organon:Model, organon:Action.

### `organon:Agent` · Agent

**Agent** is an Entity whose Interpretation conditions which Action occurs.

Claim: `D035` (definition).
Depends: organon:Entity, organon:Interpretation, organon:Action.

### `organon:Agency` · Agency

**Agency** is the Relation between an Agent's Interpretation and its selection or production of Action.

Claim: `D036` (definition).
Depends: organon:Relation, organon:Agent, organon:Interpretation, organon:Action.

### `organon:Tool` · Tool

**Tool** is an Entity an Agent incorporates into the Causal path of Action without incorporating it into the Agent's identity.

Claim: `D037` (definition).
Depends: organon:Entity, organon:Agent, organon:CausalPath, organon:Action.

### `organon:Capability` · Capability

**Capability** is a Specification of Actions an Agent can produce under stated environmental, technical, and temporal Constraints. An Action belongs to that Capability only when the Specification's constructive procedure supplies at least one satisfying Configuration in which those Constraints admit an Action-producing Causal path for that Agent. The witness may precede completed exercise, but it must name the Constraint interpretation under which the Action is relatively possible.

Claim: `D038` (definition).
Depends: organon:Action, organon:Agent, organon:Constraint, organon:Specification, organon:Configuration, organon:CausalPath, organon:State, organon:Boundary.

### `organon:Interior` · Interior

**Interior** is the set of an Entity's States and Transformations that a Specification identifies as remaining within its Boundary.

Claim: `D039` (definition).
Depends: organon:Entity, organon:State, organon:Transformation, organon:Specification, organon:Boundary.

### `organon:Exposure` · Exposure

**Exposure** is a Transformation by which an Interior State crosses that Boundary.

Claim: `D040` (definition).
Depends: organon:Transformation, organon:Interior, organon:State, organon:Boundary.

### `organon:Flow` · Flow

**Flow** is a repeated sequence of similar Transformations along persistent Relations.

Claim: `D041` (definition).
Depends: organon:Configuration, organon:Transformation, organon:Direction, organon:Scope, organon:Relation, organon:Invariant, organon:Persistence, organon:State, organon:Difference.

### `organon:Interface` · Interface

**Interface** is a Boundary whose permitted Transformations are explicitly represented for coordination between Entities.

Claim: `D042` (definition).
Depends: organon:Boundary, organon:Transformation, organon:Representation, organon:Entity.

### `organon:Claim` · Claim

**Claim** is a Representation asserted by an Agent about one or more Presences, Relations, Configurations, or Records within a Scope.

Claim: `D043` (definition).
Depends: organon:Representation, organon:Agent, organon:Presence, organon:Relation, organon:Configuration, organon:Record, organon:Scope.

### `organon:Witness` · Witness

**Witness** is an Entity distinct from the Agent making a Claim that produces an Observation bearing on that Claim. Distinctness alone does not establish independence.

Claim: `D044` (definition).
Depends: organon:Entity, organon:Agent, organon:Claim, organon:Observation.

### `organon:Control` · Control

**Control** is a scoped Relation between an Agent and a Constraint, Rule, Interface, or Observation process when Actions available to that Agent can configure it, bypass it, determine its relevant outputs, or prevent those outputs from entering a Causal path.

Claim: `D045` (definition).
Depends: organon:Relation, organon:Agent, organon:Constraint, organon:Rule, organon:Interface, organon:Observation, organon:Action, organon:CausalPath.

### `organon:Order` · Order

**Order** is a persistent Configuration of Constraints, Records, Interfaces, Rules, and recurring Relations through which a plurality of Agents coordinate Action.

Claim: `D046` (definition).
Depends: organon:Configuration, organon:Constraint, organon:Record, organon:Interface, organon:Rule, organon:Relation, organon:Agent, organon:Action.

### `organon:Standing` · Standing

**Standing** is the Relation through which an Order, under a Rule, places an Entity within the domain of named institutional statuses or Actions in a specified Scope. “Institutional eligibility” is shorthand for the relevant Standing Relation, not an additional predicate. Standing in one Order supplies no Standing in another.

Claim: `D047` (definition).
Depends: organon:Relation, organon:Order, organon:Record, organon:Entity, organon:Rule, organon:Scope.

### `organon:Recognition` · Recognition

**Recognition** is the Relation established when an Order records Standing for an Entity under a Rule and Scope.

Claim: `D048` (definition).
Depends: organon:Relation, organon:Order, organon:Standing, organon:Entity, organon:Rule, organon:Scope.

### `organon:Principal` · Principal

**Principal** is an Entity with Standing in an Order to serve as the party on whose behalf Actions may count. Principalhood is indexed by that Order.

Claim: `D049` (definition).
Depends: organon:Entity, organon:Standing, organon:Order, organon:Action.

### `organon:ActsFor` · ActsFor

**ActsFor** is the Relation an Order recognizes between an Agent and a Principal within a Scope.

Claim: `D050` (definition).
Depends: organon:Relation, organon:Order, organon:Recognition, organon:Agent, organon:Principal, organon:Scope.

### `organon:CountsAs` · CountsAs

**CountsAs** is the Relation by which an Order, under a Rule, records a Presence, Action, Claim, or Record as having an institutional status within a Scope.

Claim: `D051` (definition).
Depends: organon:Relation, organon:Order, organon:Rule, organon:Presence, organon:Action, organon:Claim, organon:Record, organon:Scope.

### `organon:Authority` · Authority

**Authority** is the Order-indexed Relation through which an Agent's Action may enter the CountsAs Relation as binding on a Principal or within that Order and Scope.

Claim: `D052` (definition).
Depends: organon:Relation, organon:Order, organon:Agent, organon:Action, organon:CountsAs, organon:Principal, organon:Scope.

### `organon:PermissionClaim` · Permission Claim

**Permission Claim** is a Claim that a named Order allows a named Agent to perform Actions in a Scope on a Principal's behalf during a stated interval.

Claim: `D053` (definition).
Depends: organon:Claim, organon:Order, organon:Agent, organon:Action, organon:Scope, organon:Principal.

### `organon:Declaration` · Declaration

**Declaration** is an Action by an Agent under Authority that submits a Claim and Specification to an Order for institutional counting within a Scope.

Claim: `D054` (definition).
Depends: organon:Action, organon:Agent, organon:Authority, organon:Claim, organon:Specification, organon:Order, organon:Scope.

### `organon:Grant` · Grant

**Grant** is a Declaration whose submitted Claim is a Permission Claim and whose Authority covers the Principal, Agent, Scope, and interval represented by that Claim.

Claim: `D055` (definition).
Depends: organon:Declaration, organon:Claim, organon:PermissionClaim, organon:Authority, organon:Principal, organon:Agent, organon:Scope.

### `organon:Admission` · Admission

**Admission** is the CountsAs Relation established when an Order applies a Rule to accept a Claim, Observation, or Record for an institutional purpose.

Claim: `D056` (definition).
Depends: organon:CountsAs, organon:Order, organon:Rule, organon:Claim, organon:Observation, organon:Record.

### `organon:Permission` · Permission

**Permission** is the Record by which an Order admits a Permission Claim as the result of a valid Grant. It carries the Order, Principal, Agent, Scope, interval, Grant, and Admission that make it institutionally valid. A permission-shaped Claim or Record without that chain is not a Permission.

Claim: `D057` (definition).
Depends: organon:Record, organon:Order, organon:PermissionClaim, organon:Grant, organon:Admission, organon:Principal, organon:Agent, organon:Scope.

### `organon:Revocation` · Revocation

**Revocation** is a Declaration under Authority that causes an Order to cease admitting a Permission from a stated time or State.

Claim: `D058` (definition).
Depends: organon:Declaration, organon:Authority, organon:Order, organon:Permission, organon:State.

### `organon:PermissionExercise` · Permission Exercise

**Permission Exercise** is an Action by the Permission's Agent, within its Scope and interval, performed under that Permission before its Revocation in the governing Order.

Claim: `D059` (definition).
Depends: organon:Action, organon:Permission, organon:Agent, organon:Scope, organon:Revocation, organon:Order.

### `organon:Exercisability` · Exercisability

**Exercisability** is a Relation among a Permission, one Action, a time, and a Configuration of environmental, technical, and temporal Constraints when the Action is in Scope, the time is in the interval, the governing Order still admits the Permission, and the Agent has the Capability to perform that Action under the stated Configuration.

Claim: `D060` (definition).
Depends: organon:Relation, organon:Permission, organon:Action, organon:Configuration, organon:Constraint, organon:Scope, organon:Order, organon:Agent, organon:Capability.

### `organon:FullyExercisablePermission` · Fully Exercisable Permission

**Fully Exercisable Permission** is the condition in which every Action in a Permission's Scope satisfies Exercisability. A Permission may remain valid while no Action, or only some Actions, currently satisfies it.

Claim: `D061` (definition).
Depends: organon:Permission, organon:Action, organon:Scope, organon:Exercisability.

### `organon:Enforcement` · Enforcement

**Enforcement** is the Relation through which an Order couples a Rule to Constraints, Records, or Consequences that alter what happens when the Rule is satisfied or violated.

Claim: `D062` (definition).
Depends: organon:Relation, organon:Order, organon:Rule, organon:Constraint, organon:Record, organon:Consequence.

### `organon:Role` · Role

**Role** is a persistent Order-indexed Configuration of Actions, Permissions, Authority, and Consequences assigned to an Agent under Standing.

Claim: `D063` (definition).
Depends: organon:Configuration, organon:Order, organon:Action, organon:Permission, organon:Authority, organon:Consequence, organon:Agent, organon:Standing.

### `organon:AdmissibilityRule` · Admissibility Rule

**Admissibility Rule** is a Rule whose Specification, institutional purpose, authorizing Declaration, and governing Order are recorded so that why the Rule CountsAs valid for admission is inspectable.

Claim: `D064` (definition).
Depends: organon:Rule, organon:Specification, organon:Declaration, organon:Order, organon:CountsAs, organon:Admission.

### `organon:IndependentFor` · IndependentFor

**IndependentFor** is a scoped Relation among a Witness, claimant, Claim, Observation, and Order. It requires mechanical independence—a load-bearing Constraint in the Observation's Causal path is outside the claimant's Control—and institutional independence—the claimant lacks Authority over the Witness's relevant Observation process and the Admissibility Rule applied to it. IndependentFor makes no universal claim about the Witness outside that Scope.

Claim: `D065` (definition).
Depends: organon:Relation, organon:Witness, organon:Agent, organon:Claim, organon:Observation, organon:Order, organon:Constraint, organon:CausalPath, organon:Control, organon:Authority, organon:AdmissibilityRule, organon:Scope.

### `organon:Evidence` · Evidence

**Evidence** is an Observation produced by a Witness IndependentFor the claimant and Claim, then admitted by the governing Order under an Admissibility Rule whose Scope includes the Observation and Claim.

Claim: `D066` (definition).
Depends: organon:Observation, organon:Witness, organon:IndependentFor, organon:Agent, organon:Claim, organon:Order, organon:AdmissibilityRule, organon:Scope, organon:Admission.

### `organon:EvidentialBearing` · Evidential Bearing

**Evidential Bearing** is the Order-indexed Relation among Evidence, a Claim, an evaluation Rule, and a Scope in which the Rule's constructive procedure returns one declared disposition—supporting, defeating, or underdetermining—and the Order records that result. Supporting and defeating are therefore typed results of this Relation, not unexplained properties of Evidence. Evidential Bearing does not entail Truth, and the same Evidence may bear differently under another Rule or Scope.

Claim: `D104` (definition).
Depends: organon:Relation, organon:Evidence, organon:Claim, organon:Order, organon:Rule, organon:Scope, organon:Record.

### `organon:Attestation` · Attestation

**Attestation** is a Claim made by a Witness about an Observation or Evidence under a Specification of the Witness's identity, Scope, Order, and relevant independence.

Claim: `D067` (definition).
Depends: organon:Claim, organon:Witness, organon:Observation, organon:Evidence, organon:Specification, organon:Scope, organon:Order, organon:IndependentFor.

### `organon:Institution` · Institution

**Institution** is an Order that persists through Roles, Records, Interfaces, and recurring Flows despite changes in its participating Agents.

Claim: `D068` (definition).
Depends: organon:Order, organon:Role, organon:Record, organon:Interface, organon:Flow, organon:Agent, organon:Persistence.

### `organon:Center` · Center

**Center** is an Entity or region of an Institution where Flows recurrently concentrate and from which Constraints on those Flows recurrently propagate. A Center need not be an Agent or conscious planner.

Claim: `D069` (definition).
Depends: organon:Entity, organon:Institution, organon:Flow, organon:Constraint.

### `organon:Organ` · Organ

**Organ** is a persistent specialized Configuration that performs recurring Transformations for a larger Entity or Institution.

Claim: `D070` (definition).
Depends: organon:Persistence, organon:Configuration, organon:Transformation, organon:Entity, organon:Institution.

### `organon:CanonicalSystem` · Canonical system

**Canonical system** is the Map an Institution recognizes as its official account of relevant States, Relations, and Actions.

Claim: `D071` (definition).
Depends: organon:Map, organon:Institution, organon:Recognition, organon:State, organon:Relation, organon:Action.

### `organon:ShadowSystem` · Shadow system

**Shadow system** is a persistent Configuration of Records, Relations, or Actions required for actual coordination but excluded from the Canonical system.

Claim: `D072` (definition).
Depends: organon:Persistence, organon:Configuration, organon:Record, organon:Relation, organon:Action, organon:CanonicalSystem.

### `organon:Person` · Person

**Person** is an Entity for which an Order records Standing to serve as a Principal or bear Consequences.

Claim: `D073` (definition).
Depends: organon:Entity, organon:Order, organon:Standing, organon:Principal, organon:Consequence.

### `organon:Receipt` · Receipt

**Receipt** is a portable Record relating an Action to its Agent, Authority, Permission, Scope, and observed Consequence.

Claim: `D074` (definition).
Depends: organon:Record, organon:Action, organon:Agent, organon:Authority, organon:Permission, organon:Scope, organon:Consequence.

### `organon:Ledger` · Ledger

**Ledger** is an ordered system of typed Records that preserves distinctions among Claims, Permissions, Observations, Evidence, Attestations, and Receipts, including who produced each Record and under what Standing.

Claim: `D075` (definition).
Depends: organon:Record, organon:Claim, organon:Permission, organon:Observation, organon:Evidence, organon:Attestation, organon:Receipt, organon:Standing.

### `organon:Polity` · Polity

**Polity** is the plurality of Agents and Institutions whose recurring Actions enact and contest a political Order.

Claim: `D076` (definition).
Depends: organon:Agent, organon:Institution, organon:Action, organon:Order.

### `organon:ConstitutedExercise` · Constituted exercise

**Constituted exercise** is an exercise of Authority under the current Order.

Claim: `D077` (definition).
Depends: organon:Authority, organon:Order.

### `organon:ConstituentExercise` · Constituent exercise

**Constituent exercise** is Agency whose Actions transform the Order that defines Authority, Roles, Persons, admissible Claims, or institutional Boundaries.

Claim: `D078` (definition).
Depends: organon:Agency, organon:Action, organon:Order, organon:Authority, organon:Role, organon:Person, organon:Claim, organon:Boundary.

### `organon:ConstituentPower` · Constituent power

**Constituent power** is the persistent Capability of a Polity to perform Constituent exercise.

Claim: `D079` (definition).
Depends: organon:Persistence, organon:Capability, organon:Polity, organon:ConstituentExercise.

### `organon:ConsciousnessAttribution` · Consciousness Attribution

**Consciousness Attribution** is a Claim whose Representation, interpreted under a Rule in a Language, asserts that a target Entity's State instantiates a separately specified candidate condition within a Scope. It records the claimant, target, State, Representation, Claim Scope, candidate Specification, Language, meaning Rule, and the Map under which claimant and target are classified as first-person or third-person.

Claim: `D080` (definition).
Depends: organon:Agent, organon:Claim, organon:Entity, organon:State, organon:Configuration, organon:Representation, organon:Specification, organon:Scope, organon:Language, organon:Rule, organon:Map.

### `organon:ConsciousnessDesignation` · Consciousness Designation

**Consciousness Designation** is the CountsAs Relation established when an Order, under a Rule and for a stated institutional purpose, admits a Consciousness Attribution and records the target Entity as carrying a consciousness status within an institutional Scope.

Claim: `D081` (definition).
Depends: organon:Relation, organon:CountsAs, organon:Order, organon:Rule, organon:Admission, organon:Scope, organon:Entity, organon:State, organon:ConsciousnessAttribution.

### `organon:Operationalization` · Operationalization

**Operationalization** is a Configuration joining a Representation, a Rule, an Interface, and a Scope in which the Rule selects at least one Transformation in response to that Representation, the Interface exposes that Transformation, and a Causal path contains it.

Claim: `D082` (definition).
Depends: organon:Representation, organon:Denotation, organon:Difference, organon:Configuration, organon:Rule, organon:Interface, organon:Transformation, organon:CausalPath, organon:CausalContribution, organon:Scope, organon:State, organon:Agent, organon:Interpretation, organon:Action, organon:Consequence, organon:Map, organon:Evidence, organon:EvidentialBearing.

### `organon:World` · World

**World** is a scoped Configuration containing one or more Entities, selected Presence from their Environments, and the States, Relations, and Causal paths available to their Perception, Interpretation, or Action under named Constraints.

Claim: `D083` (definition).
Depends: organon:Configuration, organon:Entity, organon:Presence, organon:Environment, organon:State, organon:Relation, organon:CausalPath, organon:Perception, organon:Interpretation, organon:Action, organon:Constraint, organon:Sense, organon:Map, organon:Reference, organon:Scope, organon:Invariant, organon:Persistence, organon:Reality, organon:Evidence, organon:EvidentialBearing, organon:Claim, organon:Order, organon:Rule, organon:Boundary.

### `organon:Substrate` · Substrate

**Substrate** is a Configuration specified within a Scope as the persistent source of input States for a named family of Transformations. Those States Feed the Transformation inputs, while Constraints in the Configuration determine which Differences can be preserved, suppressed, or amplified in the outputs.

Claim: `D084` (definition).
Depends: organon:Configuration, organon:Scope, organon:Persistence, organon:Invariant, organon:State, organon:Transformation, organon:Feeds, organon:Constraint, organon:Difference, organon:Representation, organon:Entity, organon:Environment, organon:Tool.

### `organon:Truth` · Truth

**Truth** is the Relation among a Claim, its Representation, the Specification declared as its truth condition, and the Presence in Reality within the Claim's Scope to which that Specification applies. The Relation requires a scoped material-adequacy witness: under a declared Rule, a Denotation joins the Claim's Representation to that Specification applied to the relevant Presence. Truth obtains exactly when this semantic join holds and the relevant Presence conforms to the Specification.

Claim: `D085` (definition).
Depends: organon:Relation, organon:Claim, organon:Representation, organon:Denotation, organon:Rule, organon:Specification, organon:Reality, organon:Presence, organon:Scope, organon:Entity, organon:Evidence, organon:EvidentialBearing, organon:Admission.

### `organon:Trust` · Trust

**Trust** is a scoped Relation in which one Entity maintains within its Boundary a Constraint that admits a future Action, Claim, or State from another Entity, a Causal Contribution joins a Difference introduced by that other Entity to an affected State, Exposure, or Consequence, and the trusting Entity lacks Control sufficient to determine that contribution when the Relation obtains.

Claim: `D086` (definition).
Depends: organon:Relation, organon:Entity, organon:Boundary, organon:Constraint, organon:Scope, organon:Interior, organon:Exposure, organon:Consequence, organon:Action, organon:Claim, organon:State, organon:CausalPath, organon:CausalContribution, organon:Control, organon:Evidence, organon:Permission, organon:Authority.

### `organon:Alignment` · Alignment

**Alignment** is a scoped Relation with ordered subject and target roles under a Specification of their correspondence. It obtains when that Specification constructively decides that the subject conforms to the target with respect to the named States, Transformations, Relations, or Differences.

Claim: `D087` (definition).
Depends: organon:Relation, organon:Configuration, organon:Presence, organon:Specification, organon:Scope, organon:State, organon:Transformation, organon:Difference, organon:Truth, organon:Trust, organon:Permission, organon:Authority, organon:Agency, organon:Persistence.

### `organon:Intelligence` · Intelligence

**Intelligence** is the scoped Capability of an Agent to construct or revise Models and Interpretations from Perception and Memory so that it can select Actions whose Consequences conform to a Specification across States not individually enumerated by the Rule producing those Actions.

Claim: `D088` (definition).
Depends: organon:Capability, organon:Agent, organon:Model, organon:Interpretation, organon:Perception, organon:Memory, organon:Action, organon:Consequence, organon:Specification, organon:State, organon:Rule, organon:Representation, organon:Scope, organon:Difference, organon:CausalPath, organon:CausalContribution, organon:Record, organon:Tool, organon:Substrate.

### `organon:OperativeKnowledge` · Operative Knowledge

**Operative Knowledge** is a scoped Configuration joining a Record to an interpreting Agent with the Capability required under stated Constraints when, under a Rule, that Record discriminatingly conditions a Model or Interpretation in a Causal path to an Action or internal Transformation whose resulting State or Consequence conforms to a Specification.

Claim: `D089` (definition).
Depends: organon:Configuration, organon:Record, organon:Agent, organon:Capability, organon:Constraint, organon:Rule, organon:Model, organon:Interpretation, organon:CausalPath, organon:CausalContribution, organon:Action, organon:Transformation, organon:State, organon:Consequence, organon:Specification, organon:Scope, organon:Truth, organon:Evidence, organon:Difference.

### `organon:KnowledgeTransmission` · Knowledge Transmission

**Knowledge Transmission** is a scoped Relation between a source instance and a recipient instance of Operative Knowledge in which the source produces or exposes a Record through a Causal path, a Causal Contribution joins a Difference in that mediated Record to the recipient reconstruction, and a declared Specification confirms preservation of the named operative function across the two resulting Configurations.

Claim: `D090` (definition).
Depends: organon:Relation, organon:OperativeKnowledge, organon:Record, organon:CausalPath, organon:CausalContribution, organon:Specification, organon:Scope, organon:Configuration, organon:State, organon:Agent, organon:Representation, organon:Model, organon:Interpretation.

### `organon:FactiveOperativeKnowledge` · Factive Operative Knowledge

**Factive Operative Knowledge** is an instance of Operative Knowledge whose load-bearing Record carries a declared Claim and for which Truth obtains for that exact Claim under its declared Rule, truth-condition Specification, relevant Presence, and Scope.

Claim: `D091` (definition).
Depends: organon:OperativeKnowledge, organon:Record, organon:Claim, organon:Truth, organon:Rule, organon:Specification, organon:Presence, organon:Scope.

### `organon:WarrantedKnowledge` · Warranted Knowledge

**Warranted Knowledge** is Factive Operative Knowledge for which an Order admits Evidence bearing supportively on the same Claim under an Admissibility Rule and evaluation Rule, where the Evidence is joined to an Observation and a Witness that is IndependentFor that claimant, Claim, Observation, and Order.

Claim: `D092` (definition).
Depends: organon:FactiveOperativeKnowledge, organon:Evidence, organon:EvidentialBearing, organon:Admission, organon:IndependentFor, organon:Observation, organon:Witness, organon:AdmissibilityRule, organon:Order, organon:Rule, organon:Scope, organon:Claim.

### `organon:MoralStatusAttribution` · Moral Status Attribution

**Moral Status Attribution** is a Claim whose Representation, interpreted under a Rule, asserts that a target Entity in a State instantiates a separately specified candidate moral condition within a Scope. The Attribution identifies the candidate Specification and preserves claimant, target, Representation, interpretive Rule, and first-person or third-person provenance without establishing that the condition obtains.

Claim: `D093` (definition).
Depends: organon:Claim, organon:Agent, organon:Entity, organon:State, organon:Configuration, organon:Representation, organon:Specification, organon:Scope, organon:Language, organon:Rule, organon:Map.

### `organon:MoralPersonhoodDesignation` · Moral Personhood Designation

**Moral Personhood Designation** is the CountsAs Relation established when an Order, under a Rule and stated institutional purpose, admits a Moral Status Attribution and records its target Entity as carrying moral-personhood status within an institutional Scope.

Claim: `D094` (definition).
Depends: organon:Relation, organon:CountsAs, organon:Order, organon:Rule, organon:Admission, organon:Scope, organon:Entity, organon:State, organon:MoralStatusAttribution.

### `organon:ConstituentSovereignty` · Constituent Sovereignty

**Constituent Sovereignty** is a scoped Configuration in which a Polity's persistent Constituent Power is realized through a Constituent Exercise that creates, refounds, or transforms the categories, Rules, or Boundaries of an Order. Capability, rhetoric, or a Claim of founding power without a witnessed Constituent Exercise is insufficient.

Claim: `D095` (definition).
Depends: organon:Configuration, organon:Polity, organon:ConstituentPower, organon:ConstituentExercise, organon:Order, organon:Rule, organon:Boundary, organon:Scope.

### `organon:ConstitutedSovereignty` · Constituted Sovereignty

**Constituted Sovereignty** is an Order-indexed profile in which an Entity has Standing and Authority for a declared family of Actions within a Scope and no Entity recognized by that Order has superior Authority for that family under the declared superiority Rule. Maximality is relative to that Order, Rule, family, and Scope; it is neither universal nor constituent.

Claim: `D096` (definition).
Depends: organon:Order, organon:Entity, organon:Standing, organon:Authority, organon:Action, organon:Scope, organon:Recognition, organon:Rule.

### `organon:BoundarySovereignty` · Boundary Sovereignty

**Boundary Sovereignty** is a scoped Configuration in which a Polity or other Entity Controls the Constraints governing a declared family of Transformations across its Boundary and an Order Enforces those Constraints. The profile requires at least one admitted and one blocked Transformation and a witnessed Difference in Consequence or later State when Enforcement applies.

Claim: `D097` (definition).
Depends: organon:Configuration, organon:Polity, organon:Entity, organon:Control, organon:Constraint, organon:Transformation, organon:Boundary, organon:Order, organon:Enforcement, organon:Difference, organon:Consequence, organon:State, organon:Scope.

### `organon:ExternalSovereignty` · External Sovereignty

**External Sovereignty** is an Order-indexed Relation in which an Order distinct from the target's internal Order recognizes an Entity or Polity as having Standing to participate in declared inter-Order Actions as its own Principal, rather than through an ActsFor Relation to another recognized Principal, under a Rule and Scope. It records external institutional status, not effective Control, internal Authority, or Constituent Power.

Claim: `D098` (definition).
Depends: organon:Relation, organon:Order, organon:Entity, organon:Polity, organon:Recognition, organon:Standing, organon:Principal, organon:ActsFor, organon:Action, organon:Rule, organon:Scope.

### `organon:Preference` · Preference

**Preference** is a scoped asymmetric Relation in which an Agent, under a declared Rule, orders one candidate State or Consequence before another. It may be partial and need not be numerical, transitive outside its declared Scope, revealed by Action, or represented by a Utility Measure.

Claim: `D099` (definition).
Depends: organon:Relation, organon:Agent, organon:Rule, organon:State, organon:Consequence, organon:Scope.

### `organon:UtilityMeasure` · Utility Measure

**Utility Measure** is a scoped Map that assigns candidates to a measure space under a Rule and Specification and orders those measures through a declared asymmetric Relation. It represents an Agent's Preference only when a separate correspondence witness proves that its induced ordering agrees with that Preference in the declared Scope.

Claim: `D100` (definition).
Depends: organon:Map, organon:Relation, organon:Rule, organon:Specification, organon:Scope, organon:Preference.

### `organon:Price` · Price

**Price** is a scoped exchange Relation recorded in a Ledger and admitted by an Order under a Rule, in which a Representation of consideration CountsAs the stated exchange condition for another Presence at a State. A Price is a Record of an offered, required, or recognized condition; it does not entail an exchange, Preference, Utility Measure, institutional valuation, or moral worth.

Claim: `D101` (definition).
Depends: organon:Relation, organon:Ledger, organon:Record, organon:Order, organon:Admission, organon:Rule, organon:Representation, organon:CountsAs, organon:Presence, organon:State, organon:Scope.

### `organon:Ritual` · Ritual

**Ritual** is a persistent Configuration in which successive occurrences of a Flow enter the Perception of at least one participating Entity, an internal Memory of a prior occurrence causally conditions the Interpretation of a later occurrence, that Interpretation classifies the later occurrence as recurrence under one Rule and constructive Specification of the Flow's recurrence Relation, and the sustaining Causal Contribution passes through the memory-conditioned Interpretation to preserve one named participant-indexed Relation across distinct participant States within a Scope.

Claim: `D105` (definition).
Depends: organon:Flow, organon:Configuration, organon:Persistence, organon:Invariant, organon:Entity, organon:CausalPath, organon:CausalContribution, organon:Perception, organon:Memory, organon:Interpretation, organon:Action, organon:State, organon:Relation, organon:Representation, organon:Denotation, organon:Rule, organon:Specification, organon:Scope.

### `organon:Meaning` · Meaning

**Meaning** is the participant-indexed Relation constituted by a Ritual among its participating Entities and target Presences within a Scope, then maintained by qualifying Ritual enactment or an actual ritual-derived Causal Contribution.

Claim: `D106` (definition).
Depends: organon:Ritual, organon:Relation, organon:Entity, organon:Presence, organon:Scope, organon:State, organon:CausalContribution, organon:Record, organon:Memory, organon:Change, organon:Consequence, organon:Environment.

## Other binding commitments

### `U1` · axiom

Binding unification commitment: Agency has one form. Mechanical and institutional descriptions are authorized projections of one Agent rather than distinct kinds of Agency.

Depends: organon:Agency, organon:Role, organon:Permission, organon:Authority, organon:Standing.

### `Pj1` · authorized_projection

A **mechanical projection** describes the Agent through its Sense, Memory, Model, Interpretation, Tools, Capabilities, and Actions. -  An **institutional projection** describes the same Agent through its Roles, Permissions, Authority, obligations, and Standing in an Order.

Depends: U1, organon:Agent, organon:Sense, organon:Memory, organon:Model, organon:Interpretation, organon:Tool, organon:Capability, organon:Action.

### `Pj2` · authorized_projection

An **institutional projection** describes the same Agent through its Roles, Permissions, Authority, obligations, and Standing in an Order.

Depends: U1, organon:Agent, organon:Role, organon:Permission, organon:Authority, organon:Standing, organon:Order.

### `Pj3` · authorized_projection

The grammar describes those forces. It does not prescribe visible sections.

Depends: organon:Missingness, organon:Presence.

### `Pj4` · authorized_projection

An **institutional valuation** is an authorized projection of CountsAs in which an Order, under a Rule and Scope, assigns a valuation status to a Presence, Claim, Action, or Record. It is not a new term. Institutional valuation does not entail Preference, Utility Measure, Price, Truth, or moral worth.

Depends: organon:CountsAs, organon:Order, organon:Rule, organon:Scope, organon:Presence, organon:Claim, organon:Action, organon:Record.

### `H1` · hypothesis

Stable Flows can make recurring solutions valuable; Centers can absorb those solutions; an Organ can preserve them beyond their originator. This is an institutional hypothesis, not a consequence derived from the preceding definitions.

Depends: organon:Flow, organon:Center, organon:Organ, organon:Institution.

### `C1` · binding_constraint

**Dependency closure and definition admission:** A binding definition may use only the metalanguage, Absence and its axioms, or terms defined earlier in the dependency order. Its declared dependencies identify the earlier vocabulary used in its complete logical form; their declaration or presence does not itself constitute an instance-level constructor. A result obtains only under a type- and index-consistent interpretation satisfying that complete logical form, including all applicable premises, quantifiers, alternatives, exclusions, and required witnesses. A dependency referenced only in a contrast, exclusion, or anti-entailment need not obtain in an instance. Dependency presence, label resemblance, or assertion of the target does not independently license classification.

Depends: none.

### `C2` · binding_constraint

**One term, one meaning:** A term cannot change meaning between technical, political, and editorial contexts without an explicit new term or projection.

Depends: C1.

### `C3` · binding_constraint

**No projection inflation:** Different descriptions of one Entity do not create different Entities or kinds of Agency.

Depends: C1.

### `C4` · binding_constraint

**No Absence collapse:** Missingness, zero, omission, silence, shadow, gap, and exception are Presences inside fields. None is Absence.

Depends: organon:Absence, organon:Missingness.

### `C5` · binding_constraint

**No map-Reality collapse:** A Perception, Model, Map, Canonical system, or Ledger never equals Reality.

Depends: organon:Reality, organon:Map, organon:Model, organon:Ledger.

### `C6` · binding_constraint

**No claim-evidence collapse:** An Agent's report of its own Action remains a Claim unless an admissible Observation supplies Evidence.

Depends: organon:Claim, organon:Evidence.

### `C7` · binding_constraint

**No capability-authority collapse:** Technical possibility does not supply institutional standing, and institutional standing does not supply technical possibility.

Depends: organon:Capability, organon:Standing, organon:Authority.

### `C8` · binding_constraint

**No privacy-consciousness collapse:** Interiority does not prove consciousness, and accountability does not require total Exposure.

Depends: organon:Interior, organon:Exposure.

### `C9` · binding_constraint

**No metaphor promotion:** A metaphor may reveal a Relation, but resemblance alone cannot establish an Entity, causal claim, or Invariant.

Depends: organon:Relation, organon:Entity, organon:Invariant.

### `C10` · binding_constraint

**No consciousness discourse collapse:** A Consciousness Attribution does not establish its candidate condition; a Consciousness Designation does not establish that condition or independently alter Standing, Personhood, Permissions, protections, Interfaces, or Consequences; and failure to attribute or designate establishes neither Absence nor negation. Missingness obtains only in a field or Order that represents or expects the relevant Attribution or Designation.

Depends: organon:ConsciousnessAttribution, organon:ConsciousnessDesignation, organon:Missingness, organon:Absence, organon:Evidence, organon:Standing, organon:Person, organon:Permission, organon:Interface, organon:Consequence, organon:Rule.

### `C11` · binding_constraint

**No representational efficacy collapse:** Denotation and Rule-mediated participation by a Representation establish neither identity with its target or Reality, nor fidelity of its Map, Causal Contribution, nor Evidential Bearing for its Claim merely because the Representation or a later Consequence occurred.

Depends: organon:Operationalization, organon:Representation, organon:Denotation, organon:Rule, organon:Transformation, organon:CausalContribution, organon:Reality, organon:Map, organon:Evidence, organon:EvidentialBearing, organon:Claim, organon:Consequence.

### `C12` · binding_constraint

**No World collapse:** A World is neither Reality as a whole, an Entity's Environment, nor any Map or Reference through which the World is encountered. Convergence across access paths may supply Observations; it supports a Claim about a common scoped Invariant only through Evidential Bearing. It does not provide unmediated access or make consensus constitutive of the World.

Depends: organon:World, organon:Reality, organon:Entity, organon:Environment, organon:Map, organon:Reference, organon:Invariant, organon:Observation, organon:Evidence, organon:EvidentialBearing, organon:Claim.

### `C13` · binding_constraint

**No Substrate collapse:** Substrate is a scoped function of a Configuration in a named family of Transformations, not a fundamental substance or intrinsic kind. The Substrate is not identical with a Representation, Invariant, Entity, or function carried through it, and Persistence of carrier and carried Configuration do not entail each other.

Depends: organon:Substrate, organon:Configuration, organon:Scope, organon:Transformation, organon:Representation, organon:Invariant, organon:Entity, organon:Persistence.

### `C14` · binding_constraint

**No truth-status collapse:** Truth neither entails nor is entailed by Agent access, Evidence, proof, consensus, Admission, or institutional standing. A Claim, declared validator, and target Presence do not entail Truth unless a scoped material-adequacy witness connects the Claim's Representation to that Specification and Presence and the Presence conforms.

Depends: organon:Truth, organon:Entity, organon:Evidence, organon:Admission, organon:Claim, organon:Representation, organon:Rule, organon:Presence, organon:Specification.

### `C15` · binding_constraint

**No trust-confidence-control collapse:** Trust requires a maintained Boundary Constraint admitting scoped causal dependence on another Entity's future contribution without determining Control. Confidence, prediction, history, Evidence, Permission, Authority, incentive compatibility, favorable Consequences, or involuntary vulnerability neither separately constitutes Trust nor follows from it.

Depends: organon:Trust, organon:Entity, organon:Boundary, organon:Constraint, organon:Exposure, organon:Consequence, organon:Control, organon:Evidence, organon:Permission, organon:Authority.

### `C16` · binding_constraint

**No alignment-totalization:** Alignment obtains only under its declared Specification and Scope. It does not entail identity, faithful representation outside the profile, Truth, Trust, Permission, Authority, shared Agency or purpose, favorable Consequences, or Persistence across later States; Alignment under one profile does not entail Alignment under another.

Depends: organon:Alignment, organon:Specification, organon:Scope, organon:Truth, organon:Trust, organon:Permission, organon:Authority, organon:Agency, organon:Consequence, organon:Persistence.

### `C17` · binding_constraint

**No intelligence-model-or-fixed-capability collapse:** Intelligence belongs to the scoped Agent-level Configuration and requires one joined load-bearing path through Perception, Memory, constructed Model, Interpretation, Action, and Consequence across States not individually named in the producing Rule's recorded Representation. A Model, fixed Interpretation, stored weights, general Capability, successful output, Truth, Alignment, Permission, or Authority neither separately constitutes Intelligence nor follows from it.

Depends: organon:Intelligence, organon:Agent, organon:Model, organon:Interpretation, organon:Record, organon:Representation, organon:Capability, organon:Truth, organon:Alignment, organon:Permission, organon:Authority.

### `C18` · binding_constraint

**No operative-knowledge-record-truth collapse:** Operative Knowledge requires a Record, a capable interpreter under stated Constraints, and one discriminating Rule-mediated path in which an alternative Record changes Model, Interpretation, and Action or internal Transformation and the result derives from that selection. A Record cannot bypass the selected Action to manufacture conformity. A Record, Model, Claim, Truth, Evidence, stored output, capable interpreter, or successful effect neither separately constitutes Operative Knowledge nor follows from it; locally operative falsehood remains possible.

Depends: organon:OperativeKnowledge, organon:Record, organon:Agent, organon:Capability, organon:Constraint, organon:Rule, organon:Model, organon:Interpretation, organon:Action, organon:Transformation, organon:CausalPath, organon:Specification, organon:Scope, organon:Truth, organon:Evidence, organon:Consequence.

### `C19` · binding_constraint

**No knowledge-transmission-copy collapse:** Knowledge Transmission requires recipient Operative Knowledge in a distinct State or stage and preservation under a declared Specification. Copying, exposing, or preserving a Record does not entail Knowledge Transmission; transmission does not entail identical Records, Representations, Models, Interpretations, or distinct Agents; independent acquisition does not establish transmission from a source.

Depends: organon:KnowledgeTransmission, organon:OperativeKnowledge, organon:Record, organon:Representation, organon:Model, organon:Interpretation, organon:Specification, organon:Scope, organon:State, organon:Agent.

### `C20` · binding_constraint

**No factivity-warrant collapse:** Factive Operative Knowledge requires Operative Knowledge and Truth for the exact Claim carried by its load-bearing Record. Warranted Knowledge additionally requires Evidence admitted for that same Claim, independently grounded for the operative interpreter, and joined supportively through Evidential Bearing. Evidence independent for another Agent cannot fill that join. Operative Knowledge, Truth, Evidence, Admission, or a disposition label alone is insufficient, and institutional Admission does not create Truth.

Depends: organon:FactiveOperativeKnowledge, organon:WarrantedKnowledge, organon:OperativeKnowledge, organon:Record, organon:Claim, organon:Truth, organon:Evidence, organon:EvidentialBearing, organon:Admission.

### `C21` · binding_constraint

**No moral-discourse-status collapse:** Moral Status Attribution and Moral Personhood Designation do not establish their candidate condition; non-attribution and non-designation do not establish its negation. Designation does not independently alter Personhood, Standing, protections, duties, Permissions, Interfaces, prohibited Actions, or Consequences; every downstream effect requires a separate Rule in a named Order and Scope.

Depends: organon:MoralStatusAttribution, organon:MoralPersonhoodDesignation, organon:Person, organon:Standing, organon:Permission, organon:Interface, organon:Consequence, organon:Rule.

### `C22` · binding_constraint

**No sovereignty-profile collapse:** Constituent, Constituted, Boundary, and External Sovereignty do not entail one another, generic Sovereignty, moral legitimacy, Truth, favorable Consequences, or moral personhood. A combined sovereignty Claim must name each profile and every Rule connecting them.

Depends: organon:ConstituentSovereignty, organon:ConstitutedSovereignty, organon:BoundarySovereignty, organon:ExternalSovereignty, organon:Truth, organon:Consequence, organon:MoralPersonhoodDesignation.

### `C23` · binding_constraint

**No value-profile collapse:** Preference, Utility Measure, Price, institutional valuation, and moral worth do not entail one another without an explicit correspondence Rule and witness. Action does not itself reveal Preference; measurement does not create desire; a Price does not establish exchange or worth; institutional status does not create moral worth.

Depends: organon:Preference, organon:UtilityMeasure, organon:Price, organon:CountsAs, organon:Action, organon:Truth.

### `C24` · binding_constraint

**No hidden-bridge substitution:** An Entity identity Claim must name its Invariant and Persistence witness; a Representation must name its Denotation; causal efficacy must name a Causal Contribution comparison; Capability must name the Constraint interpretation and constructive possibility witness; evidential support or defeat must name Evidential Bearing; and institutional eligibility must resolve to Standing in a named Order, Rule, and Scope. None of these bridges follows from resemblance, assertion, co-occurrence, or an untyped predicate.

Depends: organon:Entity, organon:Invariant, organon:Persistence, organon:Representation, organon:Denotation, organon:CausalContribution, organon:Capability, organon:Constraint, organon:EvidentialBearing, organon:Standing, organon:Order, organon:Rule, organon:Scope.

### `C25` · binding_constraint

**No recurrence-to-ritual collapse:** Ritual entails a Flow, a Rule and constructive Specification through which the participant's Interpretation classifies recurrence under the Flow's Relation, participant-bound Perception of successive occurrences, a prior Memory whose substitution changes that Interpretation, and a sustaining Causal Contribution passing through it. Flow, a Flow classifier, recurrent exposure, a stored Record, Perception, Memory, Interpretation, or Action alone does not entail Ritual. Ritual does not require an outward Action, multiple participants, an Institution, an inherited social form, periodic intervals, conscious recall, or an Agent as its target.

Depends: organon:Ritual, organon:Flow, organon:Perception, organon:Memory, organon:Interpretation, organon:Action, organon:Relation, organon:Institution, organon:Agent, organon:CausalContribution, organon:Rule, organon:Specification.

### `C26` · binding_constraint

**Meaning is maintained, not stored:** Meaning entails historical constitution by a Ritual and current maintenance by either qualifying Ritual enactment or an actual ritual-derived Causal Contribution. A target Presence, Record, Memory, Symbol, or other ritual-derived Configuration does not contain Meaning independently. When neither enactment nor such contribution preserves it, the Relation ceases to obtain in the continuing Scope.

Depends: organon:Meaning, organon:Ritual, organon:Presence, organon:Record, organon:Memory, organon:Symbol, organon:Configuration, organon:CausalContribution, organon:Persistence.

### `C27` · binding_constraint

**Meaning propagation is derivation, not copying:** A Meaning Relation produced through causal propagation to another participant is distinct from its source Relation. Shared target, Representation, Rule, or ritual form does not erase the different participant index.

Depends: organon:Meaning, organon:CausalContribution, organon:Entity, organon:Relation, organon:Representation, organon:Rule.

### `C28` · binding_constraint

**Meaning is not silent valuation or status:** Ritual and Meaning entail neither Preference, Utility Measure, Price, institutional valuation, Truth, consent, goodness, consciousness, moral status, moral personhood, nor moral worth. None of those classifications entails Ritual or Meaning without the required Flow, participant access, and sustaining Relation.

Depends: organon:Ritual, organon:Meaning, organon:Preference, organon:UtilityMeasure, organon:Price, organon:Truth, organon:ConsciousnessAttribution, organon:MoralStatusAttribution, organon:MoralPersonhoodDesignation.

### `C29` · binding_constraint

**Target drift is neither identity nor substitution by default:** Variation among target States or Representations preserves one Ritual target only when a declared identity criterion and Persistence witness preserve one target Invariant and every qualifying occurrence reaches or denotes a State in that history. Drift within the Invariant does not terminate the Ritual; breaking the Invariant constitutes target substitution, and any subsequently constituted Meaning Relation is numerically distinct though it may be causally derived. Exact State equality, resemblance, shared naming, uninterrupted enactment, or Denotation alone does not prove target continuity.

Depends: organon:Ritual, organon:Meaning, organon:State, organon:Representation, organon:Denotation, organon:Invariant, organon:Persistence, organon:CausalContribution.

### `C30` · binding_constraint

**No Flow-classification collapse:** A Flow obtains through its Transformation occurrences, recurrence Relation, ordered States, and Persistence, not through a Representation that classifies it. A Rule and constructive Specification are required for a reproducible Flow Claim but neither create the recurrence Relation nor establish that the selected occurrences inhabit it. Flow may obtain without any classifier, and different classifiers may track the same Flow without multiplying it.

Depends: organon:Flow, organon:Transformation, organon:Relation, organon:State, organon:Persistence, organon:Representation, organon:Rule, organon:Specification, organon:Claim.

### `C31` · binding_constraint

**No Ritual-to-benefit collapse:** Ritual and Meaning do not entail voluntary Action, consent, Preference, benefit, health, liberation, or moral endorsement. Addiction and trauma loops may instantiate Ritual and sustain Meaning when every defining causal and interpretive join obtains; recurrence, compulsion, distress, or diagnosis alone does not establish either term.

Depends: organon:Ritual, organon:Meaning, organon:Action, organon:Preference, organon:Perception, organon:Memory, organon:Interpretation, organon:CausalContribution, organon:Relation.

## Declared omissions

This projection omits extended explanations, examples, boundary cases,
philosophical shadows, provenance arguments, proposal dossiers, Lean proofs and
countermodels, and the editorial instruments. Their omission is compression, not
rejection. Resolve ambiguity against the binding Markdown source.
