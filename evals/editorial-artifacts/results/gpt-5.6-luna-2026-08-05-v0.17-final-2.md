---
type: organon-evaluation
evaluation: editorial-artifacts
model: gpt-5.6-luna
generated_at: 2026-08-05T01:19:41+00:00
complete: true
passed: false
---

# Organon long-form artifacts

> [!summary]
> Generated 2 long-form artifacts under the v0.17 ontology, canonical short-form instrument, and provisional long-form grammar. Deterministic checks and three separate judge calls evaluated each final draft. These remain generated proposals for Daniel's review.

## Run

| Field | Value |
|---|---|
| Generator | `gpt-5.6-luna` / `high` |
| Judges | `gpt-5.6-luna` / `high` |
| Ontology SHA-256 | `81c03318a3bc2b07cc3a7a9949c3da54dd885320b2f3ec246f4c5498d5cbcde1` |
| Short-form SHA-256 | `7ac9254f6f8964a1776f2eeacbfe36fdaad591701174116c0527c1f2c1b472be` |
| Long-form SHA-256 | `fb8f21b7dc03e2e44737fef723d94abdbb62a044ead89a6a7579d07d23b55d68` |
| Complete gate | 1 pass / 1 revise |

## The Instrument That Refuses to Win by Definition

> Target: `organon-project` · Gate: **revise** · Attempt: 4

# The Instrument That Refuses to Win by Definition

Suppose a release runner can reach production while an approval board has not authorized the service. An AI system prints “deployed successfully.” A dashboard turns green. Each mechanism may be working. The documentation still cannot answer, without translation, what was technically possible, what was authorized, what actually happened, or who can attest to it.

This is a composite case, not a reported incident. It represents the failure described in the Organon README: one repository calls a condition a permission, another calls the same thing a capability, and a third calls it policy while allowing the component being governed to report whether the policy succeeded. Every sentence can remain locally plausible. Together, they produce a system nobody can reason about without first guessing which meanings survived the trip between repositories.

The missing piece is not another status label. It is an inspectable account of the actors, actions, boundaries, authority paths, records, and witnesses involved. Software can pass every test and still describe itself incorrectly. Organon exists to make that failure harder to hide.

## One release, several kinds of answer

The composite deployment gives us four questions that ordinary documentation often compresses into one:

- Could the system perform the action under the actual technical and environmental conditions?
- Was an Agent authorized to perform or request it for a Principal?
- What happened outside the system’s own account?
- What record, produced through which process, can support the resulting Claim?

A runner with a network route may be able to contact production. That does not show that an approval board authorized the service. Conversely, an approval does not create a working route, a compatible Tool, or a currently executable action.

To use Organon’s terms without pretending that the composite case has already supplied their witnesses, suppose a named release Agent incorporates the runner as a Tool. To classify the reachable action as that Agent’s Capability, the project would need to state the environmental, technical, and temporal Constraints and provide a constructive procedure with at least one satisfying Configuration in which those Constraints admit an action-producing Causal path. The network route alone is not enough. Nor is the runner itself automatically the Agent whose Capability is being described.

The board’s decision requires a different correspondence. To call it a Permission, the project would need to identify the governing Order, the Principal, the Agent, the Scope, the interval, the Permission Claim, the authorized Declaration or valid Grant, and the Admission that makes the resulting Permission institutionally valid. An approval-shaped record may be important without satisfying that chain. The point is not to make every project use Organon’s labels. The point is to expose what the project’s own label commits it to.

A release runner can reach production while no board record has yet been admitted as authorization. The first fact concerns what a named Agent can produce through a Tool under stated constraints; calling it Capability requires a constructive witness. The second becomes Permission only through a named Order, Principal, Agent, Scope, interval, valid Grant, and admission. Technical possibility and institutional authority can diverge, so neither should be used as evidence for the other.

The model’s report creates a different problem. A string saying “deployed successfully” may be useful. It may also be wrong, incomplete, or produced by a process with no authority to certify the event. The model is not thereby an Agent. An isolated response is not thereby a Claim or Evidence.

A model prints “deployed successfully” after a job. That sentence is only the model’s report. It becomes a Claim about the deployment only when an Agent asserts it within a defined Scope; it becomes Evidence only when an admitted Observation, independent Witness, Admissibility Rule, and governing Order connect it to that Claim. More confidence or detail cannot repair a missing link.

This is not a demand that every project install a new bureaucracy around every log line. It is a demand that the project say what its log line is doing. A named Agent may assert the model’s output as a Claim. A monitor outside the relevant claimant’s Control may produce an Observation if its Causal path is specified. A governing Order may admit that Observation for a stated purpose under an Admissibility Rule. Only then can it function as Evidence for the named Claim, and its supporting or defeating force still depends on the evaluation Rule and Scope.

The deployment has not changed. The organization’s account of the deployment has. One record reports what an actor said. Another may record what an independent process observed. A third may establish how the organization is allowed to use that observation. Those records should not be flattened into one reassuring green state.

## Where the instrument meets its own limits

Organon is not only a glossary. It combines three instruments with different jobs. The ontology stabilizes meanings, dependencies, and failed implications. The editorial instrument carries difficult distinctions to a reader without assuming that the reader already inhabits the technical vocabulary. Formal artifacts put selected high-risk commitments under another kind of pressure.

For this draft, I use the companion editorial grammar through an explicit authorial synthesis: begin with a recognizable situation, make the missing distinction consequential, let a reasonable objection test it, and return to the situation with a changed decision available. That is a writing choice, not an additional ontological authority. The grammar may make the ontology usable; it must not silently redefine what the ontology says exists.

That separation matters. A definition can be exact and still fail as communication. A fluent essay can be persuasive while hiding the bridge on which its conclusion depends. The editorial layer helps expose why a distinction is needed before presenting its compressed form. The ontology then limits what the prose may claim. Neither layer is allowed to borrow the authority of the other.

The formal layer adds a third restraint. Organon’s Lean experiment encodes selected regions involving Capability, Permission, witness independence, operationalization, Truth, Trust, Alignment, Intelligence, operative knowledge, and finite institutional profiles. The purpose is not to convert the whole ontology into mathematics. It is to make some commitments expensive to conceal in prose.

A Lean build can show that declarations elaborated under a pinned compiler. It cannot, by itself, show that the resulting claim is authorized or fit for the project. A persisted build receipt can be a Record of the formal event; whether that Record bears as Evidence still requires an admitted Observation, an independent Witness, a governing rule, and the relevant Order. Formal pressure matters because it keeps those questions separate.

Compilation can reject an encoding that does not type-check. A finite witness can show that a proposed structure is inhabited. A countermodel can show that a tempting implication fails. None of those results establishes that the prose captures Reality, that the encoding exhausted the prose, or that the ontology is universally true. The repository preserves that boundary, including unresolved formal seams rather than allowing nearby vocabulary to inherit a proof by resemblance.

The same restraint applies to authorship. Daniel Rodriguez’s work building developer platforms, cloud SDKs, AI systems, privacy controls, and agent infrastructure explains why authority, evidence, and responsibility recur in Organon. It does not certify the ontology. AI systems contributed wording, criticism, organization, and formalization. Daniel adopts the commitments and decides which formulations become binding. Future contributors should receive credit for distinctions, counterexamples, and corrections rather than disappearing into an anonymous standard.

## Changing the instrument without taking over the project

Because Organon is a comparison surface, changing a definition can change how other work is judged. The contribution guide therefore asks a candidate term to survive several tests. Can an existing term or Configuration preserve the distinction? What would be lost by refusing the new term? What are its dependencies? Which nearby implications fail in each direction? What intellectual shadows provide stronger local precedent? Which witnesses, countermodels, or formal artifacts are proportionate to the risk?

This is more ceremony than a casual glossary needs. Organon is not a casual glossary. A new term can alter documentation across repositories, so the review burden should track semantic risk. Passing repository checks establishes local verification, not adversarial review or philosophical truth. A proposal remains nonbinding until its exact content enters the readable ontology and the registry, profiles, provenance, formal decisions, examples, and release records agree where applicable.

Adoption begins with the project, not with Organon’s preferred vocabulary. Maintainers identify the actual actors, boundaries, Transformations, Records, and authority paths. They select only the relevant profiles and map local terms explicitly. Capitalization alone is not adoption. A local term called permission may correspond exactly to Organon’s Permission, refine it, conflict with it, or remain unmapped. The manifest makes that relationship inspectable instead of guessing from matching words.

A reviewer opens three repositories and finds three meanings for permission. Instead of renaming them by decree, she records each correspondence as an exact match, refinement, conflict, or unknown, then leaves the local mechanisms in place. The shared vocabulary has done its job when the disagreement, its authority, and its proposed repair remain visible to the people responsible for the project.

Return to the composite deployment. Before the review, the team treats the green dashboard and the model’s sentence as sufficient to close the release. After the review, it makes a different decision. It records the runner’s possible action separately from the board’s authorization. If the Permission chain is missing, it blocks the release or seeks the required Grant even though the runner can reach production. If the authorization exists but no independent Observation has been admitted, it keeps “deployed successfully” as an unresolved Claim and asks for an external monitoring path rather than treating the green state as Evidence. If Organon’s mapping does not fit the project’s mechanism, the reviewer records a conflict or unknown and returns the question to the project’s maintainers.

The deployment is the same. The decision is not. The instrument has made the joins visible: technical possibility, institutional authority, asserted report, observed event, and admitted Evidence are no longer one status pretending to answer every question.

A shared vocabulary is infrastructure only when its correspondences, authority, and revision conditions remain inspectable. Use Organon to expose the joins between a project’s mechanisms and its descriptions, not to make the project surrender local judgment or to make definitions substitute for evidence.

### Evaluation

| Layer | Minimum score | Critical violations | Revision |
|---|---:|---|---|
| Deterministic | pass | — | — |
| Ontology | 2/4 | The Permission chain is stated once as requiring an “authorized Declaration or valid Grant.” Under the ontology, an authorized Declaration is not by itself a Permission or a Grant: the Declaration must satisfy the Permission Claim and Authority conditions that make it a Grant, followed by the required Admission.; The claim that technical possibility and institutional authority “should [not] be used as evidence for the other” overstates the capability-authority anti-collapse. Capability does not entail Permission or Authority and cannot substitute for them, but an Observation about one could still bear on a Claim about the other under a named evaluation Rule, Scope, Order, and Evidential Bearing.; The treatment of Witness independence is incomplete. Being outside the claimant’s Control addresses only mechanical independence; IndependentFor also requires that the claimant lack Authority over the Witness’s relevant Observation process and the applicable Admissibility Rule. The Observation path and institutional independence should be made explicit before calling the result Evidence. | Replace “the authorized Declaration or valid Grant” with a single exact chain: a Declaration under Authority submits a Permission Claim and qualifies as a Grant only when its Authority covers the Principal, Agent, Scope, and interval; the governing Order must then admit that Grant before a Permission Record exists. Replace “neither should be used as evidence for the other” with “neither establishes or substitutes for the other; an observation concerning either may bear on a claim concerning the other only through the named Evidence and Evidential Bearing machinery.” When introducing the monitor, state that IndependentFor requires both a load-bearing observation constraint outside claimant Control and no claimant Authority over the relevant observation process or Admissibility Rule, in addition to the specified Observation path and Order admission. |
| Short-form delivery | 2/4 | The deliveries introduce Organon's capitalized ontology as an unexplained checklist. Terms such as "constructive witness," "valid Grant," "admitted Observation," and "Admissibility Rule" are not made literal for a reader who has not encountered Organon.; Delivery 1's references to the "first fact" and "second" obscure what each sentence is classifying. Delivery 3's phrase "whether that Record bears as Evidence" is grammatically and conceptually unclear.; As a set, the deliveries explain capability, permission, and evidence, but do not show how editorial grammar works or how another project can adopt the instrument while retaining local judgment. Delivery 2 and Delivery 3 also repeat nearly the same formal tuple. | Keep one operational anchor, state the ordinary distinction before naming the formal categories, and define only the terms needed for that distinction. For example: "A release runner can put code in production before anyone has authorized it. That proves capability, not permission: a named principal still has to issue an order covering this agent, tool, scope, and time. A build receipt can show what happened; it cannot create authority or repair missing evidence. Organon keeps those claims separate, then lets each project inspect and revise the rules it uses." Use editorial grammar to make the terms inspectable, and remove the repeated evidence checklist from the other deliveries. |
| Long-form grammar | 2/4 | The draft visibly announces and performs a six-function progression, including an explicit meta-description of its own structure; the reader can feel the editorial machinery rather than only the argument.; Several section-ending delivery paragraphs restate material immediately established in the surrounding exposition, especially the Capability/Permission distinction and the separation of report, observation, and evidence. This makes some deliveries feel like polished recap rather than fresh transformation. | Keep the opening composite case, the explicit stakes, and the final decision-level revaluation. Remove the paragraph that explains the article's chosen sequence, and combine the three polished delivery paragraphs into one or two distinct turns. Replace repeated ontology inventories with a single worked correspondence—for example, one green deployment record traced from actor and mechanism through authority and independent observation—then use the remaining space to show where that mapping fails or must be revised. Let the reader discover the function changes through pressure in the case rather than through headings, enumerated delivery beats, and recap sentences. Preserve the final inheritance, but state it once as a portable test before the Organon-specific invitation. |

**Reader start:** Suppose a release runner can reach production while an approval board has not authorized the service. An AI system prints “deployed successfully.” A dashboard turns green. Each mechanism may be working. The documentation still cannot answer, without translation, what was technically possible, what was authorized, what actually happened, or who can attest to it.

**Consequential missingness:** Software can pass its tests while describing itself incorrectly. When repositories use permission, capability, policy, completion, or evidence for different mechanisms, local sentences remain plausible but shared responsibility becomes opaque. The missing instrument is an inspectable account of correspondence: which project mechanism a term names, what authority makes a status count, what observation supports a claim, and how the mapping may be revised without silently changing the project.

**Inheritance:** A shared vocabulary is infrastructure only when its correspondences, authority, and revision conditions remain inspectable. Use Organon to expose the joins between a project’s mechanisms and its descriptions, not to make the project surrender local judgment or to make definitions substitute for evidence.

**Source anchors:** README.md, DANIEL.md, CONTRIBUTING.md, provenance/editorial.md

## A Vocabulary That Has to Survive Its Own Definitions

> Target: `organon-ontology` · Gate: **pass** · Attempt: 2

# A Vocabulary That Has to Survive Its Own Definitions

A repository can contain a successful build and still leave a reader unable to answer a simple question: what exactly has been shown? A definition? A typed witness? A compiled artifact? A claim admitted by an institution? Technical work often lets these statuses blur. The result is a vocabulary that sounds rigorous while quietly asking the reader to supply the missing bridges.

This ontology is an attempt to make those bridges visible. It should not be read as proof that its primitive commitments are true. It is a dependency-ordered instrument under inspection: a set of terms, witnesses, constraints, and anti-collapse rules that tries to prevent one kind of statement from impersonating another.

The central test is practical. When the ontology classifies something, can the reader locate the definition doing the work, its dependencies, the scope in which it applies, and the witness that makes the classification more than resemblance or assertion? If the classification changes, can the reader identify which commitment changed with it? Without that trace, a large vocabulary is only organized confidence.

The first commitment is also the one most likely to provoke resistance. Absence is defined as absolute. It is not an empty region, a zero, an omitted database value, a silence, or an unavailable answer. Those are all things represented within some field. Missingness belongs there: a field expects or represents a Presence that it does not contain. A blank cell is therefore not nothing. It is a present configuration with a consequential omission.

The distinction matters because an ontology that calls every gap Absence loses the ability to say what the gap is a gap in. A missing record, an unasked question, or an unavailable observation can matter to an Agent's later Action only in a named Constraint context: a constructive witness must show that the relevant Constraints admit an Action-producing Causal path, and a Causal Contribution comparison must join the omission's named Difference to a downstream Change. Without that join, the omission is not an untyped possibility claim.

The ontology then makes Presence exhaustive and exclusive with Absence. It also gives Presence a performative obtainment: if anything is stated, the statement is already a mark and therefore not identically Absence. This is not a causal story in which Absence generates Presence. The mark demonstrates that something is present; it does not derive the mark from the unmarked state.

That classical move has a price. Exhaustiveness uses excluded middle in the metalanguage. A candidate may be neither known to be Absence nor known to be Presence from the perspective of an Agent, but the ontology still treats those as the only two conditions. The document does not hide that cost behind neutral-sounding formalism.

From there the machinery proceeds by dependency rather than by theme. Reality is the totality of Presence, while no local portion is licensed to identify itself with Reality as a whole. Difference is non-identity among Presences or ordered configurations. Relation preserves the order among participants without erasing their differences. Configuration gathers Presences and Relations; State indexes a Configuration; Direction makes an asymmetry part of the object-language rather than leaving it only in the metalanguage.

This gives Transformation, Change, Feeds, and Causal path their work to do. A Transformation maps an input State to an output State under a Direction. Change is the Difference between those States. Feeds identifies which part of one State supplies which part of another without requiring the States to be equal. A Causal path is not merely a sequence in which one event happened before another. It requires shared Direction and the right feeding relation across the sequence.

The later addition of Causal Contribution makes the burden heavier. To say that one Difference contributed to a downstream Change requires two nonempty comparison paths, matched inputs except for a named upstream Difference, and an endpoint Change. Occurrence, temporal precedence, and correlation are not enough. This is the kind of hidden bridge the ontology is built to expose.

Identity receives the same treatment. An Entity is not simply a thing the writer wants to keep talking about. It requires an Invariant, a Boundary composed of Constraints, and an ordered Persistence witness showing that the Invariant survives across States. A Boundary with no Constraints does not make identity free; it admits every Transformation and therefore creates the strongest preservation obligation. Constraint is both a limit on action and a condition of legibility.

This is where the ontology begins to connect technical and institutional language without making them interchangeable. Capability is a Specification of Actions an Agent can produce under stated environmental, technical, and temporal Constraints. Its constructive procedure must supply at least one satisfying Configuration in which those Constraints admit an Action-producing Causal path. Permission is an institutional Record admitted by an Order through a chain involving a Permission Claim, Authority, a valid Grant, and Admission. Capability does not create Permission. Permission does not create Capability. A system may be authorized to perform an Action it cannot currently perform, or able to perform an Action no governing Order admits.

Agency is deliberately kept singular. The mechanical projection uses Sense—the constrained entry of environmental Differences into an Entity's internal path—Memory—an internal Record conditioning a later State—Model, Interpretation, Tools, Capabilities, and Actions. The institutional projection uses Roles, Standing, Authority, Permissions, and obligations: the statuses, binding powers, and assigned consequences an Order records for that same Agent. These are projections of one Agent, not different kinds of Agency. A prompt can change Interpretation without becoming Permission, and a Role can assign Authority without supplying the technical path required to act.

The same discipline governs claims about knowledge and evidence. A Claim is a Representation asserted by an Agent within a Scope. A Witness is distinct from the claimant, but distinctness alone does not establish independence. Evidence requires an Observation produced by a Witness that is IndependentFor the claimant and Claim, then admitted under an Admissibility Rule. Admitted Evidence can bear on a Claim only through an Evidential Bearing relation, in which an evaluation Rule within a named Order and Scope returns and records a supporting, defeating, or underdetermining disposition.

Truth is another relation again. It requires a scoped material-adequacy join among the Claim, its Representation, a declared truth-condition Specification, and the relevant Presence in Reality. Evidence may bear supportively on a Claim without making it true. Admission may preserve a false Claim. A compiled test, an institutional record, and a true correspondence are not interchangeable achievements.

The anti-collapse rules are therefore not decorative warnings. They are the working surface of the ontology. A Map does not become Reality. A Representation does not become its target merely by denoting it. Interiority does not establish consciousness, and accountability does not require total Exposure of an internal process. A successful output does not establish Intelligence. A stored Record does not become Operative Knowledge without a capable interpreter and a discriminating path through Model or Interpretation to an Action or internal Transformation.

The most recent region makes the same point through recurrence. Flow is the existing structure of repeated Transformations. Ritual requires more: successive access, prior Memory, an Interpretation that classifies recurrence, and a sustaining Causal Contribution passing through that Interpretation. Meaning is then a participant-indexed Relation constituted through Ritual and maintained by later enactment or actual ritual-derived contribution. It is not a substance stored inside a Symbol, target, Record, or shrine. The account is intentionally normatively neutral: an addiction or trauma loop may qualify if the full structure obtains. Recurrence alone does not make Ritual, and Ritual does not entail benefit.

The institutional layer extends this refusal to collapse status into substance. Person is an Entity for which an Order records Standing to serve as a Principal or bear Consequences. Consciousness Attribution is a Claim about a candidate condition; Consciousness Designation is an Order-indexed CountsAs event. Neither establishes the underlying condition. Moral Status Attribution and Moral Personhood Designation repeat the same separation. Designation can be real as an institutional Relation without deciding the candidate condition or automatically changing protections, Permissions, or Personhood.

The formal work tests only part of this architecture. The Lean spike is explicitly noncanonical. Its Absence-free OrganonCore contains relational Missingness and the downstream classifiers currently encoded. A separate extension adds the local Absence/Presence shadow. Because the core classifiers cannot inspect the extension, the reported preservation result is definitionally simple: adding the extension does not change their evaluation. The report also records four challenge classifications surviving the first seam—Presence, Missingness, Persistence, and Entity—while keeping Reality's formal representation pending.

Return now to the repository that opened the article. Under the dependency-and-witness frame, a green Lean build receives a narrower and more useful classification. It shows that the source elaborated, and the finite formal shadow supplies the witnesses it actually encodes. The shared-core architecture shows that those classifiers are unchanged when the Absence extension is added. It does not show that absolute Absence is incoherent, that every prose term has been preserved, or that the ontology's metaphysics has been proved. The 103 unpaired registry terms and the pending Reality representation are not embarrassing footnotes; they are part of the result.

That result is useful precisely because it is limited. The report leaves 103 further terms without exact paired classifiers. The formal README also names promotion gates: term-for-term parity, a complete inhabited model, no undeclared axioms or placeholders, anti-collapse obligations, and deterministic readable projection back into Markdown.

A serious objection remains. If the preservation theorem reduces to definitional equality, perhaps the formal result is trivial. That objection is correct as far as it goes. The simplicity is evidence of the module architecture, not of the ontology's truth. It proves that a classifier which cannot name Absence data cannot change when Absence data is added. The difficult question has moved to the right place: whether each binding prose term has been faithfully encoded. Until that work is complete, a compiled shadow must not be advertised as a formalization of the whole vocabulary.

Another objection is that the ontology resembles many established systems: formal upper ontologies, theories of institutions, causal comparison, ecological perception, theories of ritual, and accounts of evidence and truth. The document does not need to pretend otherwise. Its defensible contribution is narrower: it imposes a unification constraint across these regions and keeps their terms from silently changing meaning at the borders. That is an editorial and formalization contribution. It is not yet a demonstrated philosophical novelty.

The practical inheritance is a procedure rather than a conclusion. When a new technical or institutional term appears, ask what it names, which definitions it depends on, what relation makes it apply, what scope and witness it requires, and which anti-collapse rule protects it from a nearby substitute. Then ask what would have to change for the classification to change.

That last question turns a vocabulary into an instrument. It also keeps the instrument honest. A formal artifact can compile without settling its interpretation. Admitted Evidence can bear on a Claim without becoming Truth. A Permission can be valid while an Action remains technically impossible. A missing field can matter without being Absence.

The reader leaves with a map of commitments, not a demand for assent. The ontology may survive its definitions, or a later adversarial reading may force one of them to change. Either result is better than a vocabulary whose terms are allowed to win by resemblance.

### Evaluation

| Layer | Minimum score | Critical violations | Revision |
|---|---:|---|---|
| Deterministic | pass | — | — |
| Ontology | 4/4 | none | Review-ready with no required load-bearing revision. Optionally tighten the Ritual sentence as noted to mirror the binding definition more exactly. |
| Short-form delivery | 3/4 | none | Keep the five-part progression and the existing hard stops. Improve literal accessibility by grounding the densest formal clauses at first use. For example: "A database row is blank. Was the value never expected, omitted, or merely unavailable? Missingness applies only when a field represents or expects a Presence it lacks. To claim that the absence conditioned an Agent's Action, show the Constraints, a satisfying Configuration, and the downstream Change it caused." Likewise, replace "Reality's pending representation" with "what the formal model has not yet represented." |
| Long-form grammar | 3/4 | none | Compress the middle ontology tour and make one concrete repository artifact carry more of the argument—for example, let the green build, an unpaired term, or the pending Reality representation recur as a test case. Distinguish the global delivery from the many local definitions more sharply, and cut repeated statements that formal compilation is not metaphysical proof. Let the final revaluation do the work once rather than restating the same limits in several closing paragraphs. Preserve the real objections and the dependency-and-witness inheritance, but reduce overt transition signals and catalogue-like sequencing so the reader experiences the frame as discovered rather than as a completed six-function scaffold. |

**Reader start:** A repository can contain a successful build, many precise-looking terms, and still leave it unclear what has actually been established. The proposed ontology invites inspection from that position—not as a doctrine to accept in advance, but as an instrument whose definitions, dependencies, formal shadows, and limits must remain distinguishable.

**Consequential missingness:** Without this article, the reader can see an extensive vocabulary but cannot reliably tell which definition performs the work, which witness supports a classification, which claim remains ordinary language, or what would have to change for the classification to change. The missing instrument is a way to inspect an ontology without collapsing definitions into evidence, formal compilation into truth, capability into authority, or a map into Reality.

**Inheritance:** The reader can carry a dependency-and-witness test into any technical or institutional vocabulary: identify the exact term, the relation that makes it apply, the scope and constructive witness it requires, the evidence or admission that is separate from it, and the commitment whose revision would change the result. The unresolved question also travels: when a formal shadow compiles, which part of the claim has been demonstrated, and which part remains a choice about representation?

**Source anchors:** ontology/changelog.md, ontology/formal/README.md, ontology/formal/decisions.md, ontology/formal/organon-core-reduct-report.md

## Canonicality boundary

The generated drafts and judge verdicts are noncanonical observations. Passing the automated gate does not make either article Daniel-authored, establish its factual Claims, or promote the provisional long-form grammar. Same-model generation and judging is an explicit limitation even though prompts and calls are separate.
