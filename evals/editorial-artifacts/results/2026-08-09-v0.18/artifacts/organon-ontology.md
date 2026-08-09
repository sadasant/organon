# A Vocabulary That Has to Survive Its Own Definitions

Suppose two reviewers disagree about whether a system is an Agent, whether its completion report is Evidence, or whether it had Permission to act. Ordinary argument lets each word carry several disputes at once. A formal vocabulary can make this worse: give the ambiguity a capital letter, place it in a diagram, and the uncertainty begins to look architectural.

Organon attempts the opposite. It presents an ontology as a dependency-ordered instrument. A classification is licensed only when a definition’s complete obligations are met. The reader does not have to accept the primitive commitments in advance. The useful first question is smaller and harder: *What exact definition produced this classification, and what would have to change for the classification to change?*

## The price at the entrance

The ontology begins with **Absence**, understood as absolute: not an empty field, omitted value, zero, silence, shadow, or gap. **Presence** is whatever is not identically Absence. The two are exhaustive and exclusive, and the exhaustiveness carries an explicit classical cost because the metalanguage adopts excluded middle.

Presence is not derived from Absence as though nothing caused something. The argument is performative instead: if a mark or statement occurs, that mark is already not Absence and therefore witnesses Presence. **Missingness** remains on the other side of this boundary. It is a relation within Presence: a field represents or expects something that it does not contain. An empty database cell, a rejected request, and an omitted record may represent Missingness. None is absolute Absence.

This opening is a commitment, not a proof supplied by the later vocabulary. The dependency order makes that price visible. A reader may reject the primitive, the classical partition, or the performative move while still asking whether downstream definitions are internally disciplined.

The metalanguage supplies ordering, identity criteria, and Constraint-relative possibility, but it cannot manufacture object-level facts. Calling a Configuration an **Entity** still requires a named identity **Invariant**, ordered **States**, and a **Persistence** witness. Calling an Action possible under a **Capability** still requires stated environmental, technical, and temporal Constraints plus a constructive satisfying Configuration.

> A definition is not a label with better typography. It is a burden: name the types, satisfy the joins, produce the witness.

## From configurations to consequences

The derived machinery proceeds by narrowing ordinary words into typed obligations. A **State** is a Configuration indexed at an ordered position. A **Direction** internalizes asymmetry between States. A **Transformation** maps an input State to an output State under that Direction, and **Change** is the Difference between the joined States.

A **Causal path** is not merely a sequence written with arrows. Its Transformations share a Direction, and each output Feeds the next input under an explicit account of what is supplied. Even that does not establish that one Difference caused a later Change. **Causal Contribution** requires two nonempty comparison paths, matched at every stated input except one named upstream Difference, whose endpoints exhibit a named downstream Change. Occurrence, precedence, and correlation are insufficient.

Entity identity is equally proof-bearing. A Boundary is a Configuration of Constraints indexed to the identity Invariant. Those Constraints distinguish identity-preserving Transformations from identity-breaking ones. An empty Boundary is not freedom from proof: if no Constraint excludes a Transformation, the identity Invariant must survive every Transformation. Constraint-poverty creates the maximal preservation obligation.

This is the pattern repeated throughout the ontology. A Representation must name its ordered Denotation to a target. Truth requires a scoped material-adequacy join among a Claim, its Representation, its truth-condition Specification, and the relevant Presence. Intelligence belongs to an Agent-level adaptive path through Perception, Memory, Model construction, Interpretation, Action, and Consequence—not to a Model or successful output in isolation.

## Institutions do not dissolve mechanics

The institutional layer does not introduce a second kind of Agent. Mechanical and institutional descriptions are projections of the same Entity: one projection describes Sense, Memory, Models, Tools, Capabilities, and Actions; the other describes Standing, Roles, Permissions, Authority, and obligations in an Order.

The distinction matters because the projections do not substitute for one another. **Capability** specifies Actions an Agent can produce under stated Constraints. **Permission** is an Order-indexed Record resulting from a valid Grant and Admission, carrying its Principal, Agent, Scope, and interval. Exercising that Permission additionally requires an in-scope Action, a valid time, continuing admission by the Order, and current Capability.

> An Agent may be capable without Permission, or permitted without current Capability. The first is not Authority. The second is not an executable plan.

The same discipline governs institutional knowledge claims. An Agent’s report remains a Claim. **Evidence** requires an Observation produced by a Witness that is IndependentFor the claimant and Claim, then admitted by an Order under an Admissibility Rule. Whether that Evidence supports, defeats, or underdetermines the Claim is another Relation—**Evidential Bearing**—indexed by an evaluation Rule, Order, and Scope. Evidence does not become Truth, and institutional Admission does not create correspondence with Reality.

These distinctions make the vocabulary usable in technical systems precisely because they prevent a working mechanism from silently acquiring institutional legitimacy, or an institutional Record from silently acquiring technical possibility.

## Anti-collapse is part of the instrument

Organon’s consistency rules are not disclaimers appended after the definitions. They identify tempting shortcuts that would otherwise do the argumentative work.

A Map is not Reality. A Claim is not Evidence. Capability is not Authority. Interiority does not prove consciousness. Alignment under one Specification does not become global Alignment, Truth, Trust, or shared purpose. Copying a Record does not establish Knowledge Transmission. A **Consciousness Designation** or **Moral Personhood Designation** does not establish the candidate condition it records, and it changes no downstream institutional relation without a separate Rule.

Version 0.18 strengthens this discipline at the point of definition admission. A dependency declaration records vocabulary used in a definition’s complete logical form; it does not mean every named dependency positively obtains in every instance. Nor can dependency presence, label resemblance, or assertion of the result introduce a term. Classification requires a type- and index-consistent interpretation satisfying the applicable premises, quantifiers, alternatives, exclusions, and witnesses. The [changelog](ontology/changelog.md) records why this distinction was made.

## The strongest objection comes from the formal shadow

If every downstream term truly depends on the Absence/Presence opening, removing that opening should disturb downstream classification. The noncanonical Lean experiment tests exactly that pressure.

Its `OrganonCore` module contains relational Missingness and the currently encoded downstream classifiers without declaring Absence, Presence, or the performative mark. The Absence/Presence experiment is added as a conservative extension. Because core classifiers cannot inspect extension data they cannot name, preservation for the shared formal core is structurally simple. The [reduct report](ontology/formal/organon-core-reduct-report.md) states the warranted conclusion narrowly: absolute Absence is not load-bearing for the classifications currently encoded in Lean or for four challenge classifications—Presence, Missingness, Persistence, and Entity.

That result is serious resistance, not an embarrassment to hide. It blocks the stronger claim that the primitive has already been shown necessary for every applied term. It also does not prove the primitive dispensable from the binding ontology. The registry audit reports four proved challenge classifications, one pending representation decision for Reality, one deliberately excluded primitive, and 103 unknown classifications. Reality is especially difficult because a type-relative inhabited carrier is not automatically the totality of all Presence.

The experiment’s architecture moves the real proof obligation to the right place: term-for-term fidelity between binding prose and formal classifier. A preservation theorem over shared code cannot establish that the code captured the prose correctly.

## What the proof checker can and cannot carry

The [Lean spike](ontology/formal/README.md) is deliberately noncanonical. It encodes selected high-risk regions, constructs finite witnesses and countermodels, and makes several commitments inspectable. `Empty` is only an uninhabited type inside Lean’s already-present metatheory, not absolute Absence. `Present α` means that a particular type is inhabited, not that Reality has been captured. Classical exhaustiveness is marked as classical. Entity carries an explicit ordered Persistence witness rather than relying on present identity alone.

Formalization also exposes choices the prose has not necessarily settled. The current Persistence witness requires at least two States, which is a surfaced interpretation rather than a theorem forced by the binding definition. At one Ritual seam, Lean requires Perception as well as Memory to make a contrastive Difference to Interpretation, making the shadow stricter than the prose. The [formalization decisions](ontology/formal/decisions.md) preserve these discrepancies as open parity gates rather than promoting them by accident.

> The README treats successful pinned-compiler elaboration and its receipt as external support for the claim that the encoded source type-checks. It does not establish term-for-term fidelity or canonical status. Apparently even formal systems need institutional procedure.

Promotion requires term-for-term coverage, removal of `sorry`, `admit`, and undeclared axioms, a complete inhabited model, formal anti-collapse obligations, deterministic Markdown rendering, stable links, and explicit human promotion. Until then, the readable Markdown ontology remains binding and Lean remains a formal shadow.

## A method for disagreement

The ontology makes no broad claim that its machinery is unprecedented. Its entity region stands in the shadows of Luhmann, BFO, and DOLCE; its institutional region bears comparison with Searle; its causal, semantic, epistemic, and ritual regions inherit other established pressures without inheriting whole theories. Its proposed contribution is the unification constraint: these regions must inhabit one dependency chain without changing a term’s meaning at their borders. Even that is identified as an editorial contribution, not a demonstrated philosophical result.

Several ordinary terms therefore remain quarantined. Consciousness, bare Knowledge, moral personhood, generic Sovereignty, generic Value, Beauty, Play, and Love receive no binding ontological meaning. Narrower discourse protocols or profiles may be defined around them without deciding the underlying condition.

Return to the completion report from the opening. Suppose the Agent that performed an Action emits a Record saying the work is complete. That report is a Claim by the Agent; it does not certify itself. Classifying it as Evidence requires a Witness distinct from the claimant to produce an Observation bearing on that Claim, an IndependentFor relation scoped to the Witness, claimant, Claim, Observation, and governing Order, and Admission under an Admissibility Rule. Even then, whether the Evidence supports completion requires a separate Evidential Bearing relation under an evaluation Rule, Order, and Scope.

In the self-report alone, the earliest failed obligation is the independently produced Observation. Admission cannot turn the same unsupported Claim into Evidence. To change the classification, the system must supply the missing witness-and-admission chain, or the ontology must revise its definition of Evidence and its no-claim-evidence-collapse commitment. Renaming the completion file does less work.

> Formal vocabulary becomes useful at the first unmet obligation. It routes disagreement from the label to the fact pattern or definition that would have to change.

A reader can now challenge a classification without accepting the entire system:

1. Locate the stable term, claim type, and binding definition.
2. Follow its declared dependencies, while distinguishing lexical reference from positive instance premises.
3. Demand the named witnesses: Invariant and Persistence for Entity, comparison paths for Causal Contribution, constructive realization for Capability, Denotation for Representation, or Order-indexed Standing for institutional eligibility.
4. Apply the relevant anti-collapse rule before importing a neighboring status.
5. Check whether the formal shadow covers this exact definition or only a weaker local analogue.
6. Name the earliest commitment that would have to be revised for the classification to change.

That last step is the inheritance. An ontology becomes usable when disagreement can reach the load-bearing commitment instead of circling the label.
