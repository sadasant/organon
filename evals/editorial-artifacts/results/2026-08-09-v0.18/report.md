---
type: organon-evaluation
evaluation: editorial-artifacts
model: gpt-5.6-sol
generated_at: 2026-08-09T17:31:17+00:00
complete: true
passed: true
---

# Long-form editorial artifacts

> [!summary]
> Generated 4 long-form artifacts under the current ontology, canonical short-form instrument, and provisional long-form grammar. Deterministic checks and three separate judge calls evaluated each final draft. These remain generated proposals for Daniel's review.

## Run

| Field | Value |
|---|---|
| Generator | `gpt-5.6-sol` / `high` |
| Judges | `gpt-5.6-sol` / `high` |
| Ontology SHA-256 | `b187ea9298909b8b36cbc36bc8f05d980e8bab376eba036588f01f60737a9ec9` |
| Short-form SHA-256 | `7ac9254f6f8964a1776f2eeacbfe36fdaad591701174116c0527c1f2c1b472be` |
| Long-form SHA-256 | `fb8f21b7dc03e2e44737fef723d94abdbb62a044ead89a6a7579d07d23b55d68` |
| Complete gate | 4 pass / 0 revise |

## The Instrument That Refuses to Win by Definition

> Target: `organon-project` · Gate: **pass** · Attempt: 1

# The Instrument That Refuses to Win by Definition

Software can pass every test and still describe itself incorrectly.

One repository calls an operation a permission. Another calls the same operation a capability. A third calls it policy, then accepts the governed component’s own report that the policy succeeded. Each sentence may be plausible in isolation. The assembled system is harder to reason about because its words changed obligations while crossing repository boundaries.

This is not primarily a style problem. If Capability and Permission are interchangeable, technical possibility can be mistaken for institutional authorization. If a Record is automatically Evidence, the actor being evaluated can certify its own performance. If output means completion, producing bytes can silently become equivalent to satisfying a responsibility.

Organon exists for this failure. As the repository [README](README.md) explains, it is a collection of instruments: an ontology for stabilizing meaning, an editorial grammar for carrying difficult ideas, and formal artifacts for exposing decisions that fluent prose can hide. Its name follows the traditional title for Aristotle’s collected works on logic. The intended posture is instrument, not doctrine.

**A system becomes impossible to govern when its terms remain locally plausible but their correspondences disappear at repository boundaries.**

## When technical language begins carrying authority

Developer infrastructure often starts with apparently mechanical questions. Can this component invoke the tool? Did the request return? Was a record written? Those questions remain technical, but they stop being sufficient when an output is allowed to count on someone’s behalf.

At that point the system also has institutional questions. Who was allowed to request the action? On whose behalf did it occur? What Rule makes the result count as complete? Who can observe the action without being controlled by the claimant? What happens if the authorization remains valid but the system lacks the Capability to exercise it?

Organon keeps these distinctions in one dependency chain rather than allowing the technical and institutional descriptions to drift apart. Capability does not create Permission or Authority. Permission does not manufacture Capability. A component’s report about its own action remains a Claim unless the required Observation, Witness independence, admission Rule, and governing Order are supplied for Evidence.

The ontology does not establish that any particular system has those relations. It supplies stable terms and asks a project to identify the mechanisms and witnesses that would make its local Claims inspectable. That difference matters: vocabulary can structure an investigation, but it cannot substitute for the project’s facts.

## Three instruments with different jobs

The ontology is the binding vocabulary where Organon is explicitly adopted. It defines terms in dependency order, assigns stable identifiers, states relation signatures, and records anti-collapses: the implications that must not be smuggled from one term into another. Its readable Markdown remains canonical. Registries and generated projections make that structure inspectable, but they do not silently replace the prose.

The ontology also has a quarantine. A familiar word does not receive technical force merely because it appears in an essay or sounds important. Candidate terms can remain proposed, disputed, or deliberately undefined. Capitalization is not adoption, and resemblance is not a mapping.

The editorial grammar solves a different problem. An exact definition can still arrive before a reader has any use for it. Long-form work therefore begins in a world the reader recognizes, makes a consequential gap perceptible, negotiates reasonable resistance, delivers a distinction, and returns that distinction to the original situation. Short form governs the compressed sentence once the idea has been earned. Neither editorial instrument may redefine what the ontology says exists.

That editorial language also has provenance. The canonical Short Form emerged through generated samples, Daniel’s inline feedback, a four-person review panel, and three review rounds. The private intermediate artifacts named in [Editorial Provenance](provenance/editorial.md) record process history but are not dependencies of the public document and carry no binding authority over the adopted result. Adoption establishes the current editorial status; it does not erase the tools and reviewers that contributed.

Formal work applies pressure to the definitions. Lean encodes selected high-risk regions where prose can conceal dependent structure, missing witnesses, or illicit substitutions. Finite witnesses show that a proposed structure can be inhabited under an encoding. Countermodels test whether two nearby terms have accidentally been made to entail one another. Other experiments mutate witness structures and search for collapse.

None of this makes Lean canonical. A successful build shows that declarations elaborate under the pinned compiler. It does not show that the encoding exhausted the prose, that the prose exhausted Reality, or that a proof assistant has settled the philosophical question.

**Formalization does not certify the ontology. It makes hidden commitments expensive enough to inspect, reject, or revise before they become inherited confusion.**

The instruments constrain one another without becoming interchangeable. The ontology prevents editorial fluency from changing definitions. Editorial grammar prevents definition lists from masquerading as explanations. Formal artifacts force selected commitments into shapes that can fail more explicitly. Human review retains the decision about what becomes binding.

## The objection Organon has to survive

The strongest objection is not that shared vocabulary is useless. It is that the author of the vocabulary can use it to control every disagreement.

Organon is not an anonymous standard. [Who is Daniel?](DANIEL.md) records the experience and perspective behind it, including work on developer platforms, cloud SDKs, AI systems, and governed agent execution. That history helps explain why Organon repeatedly attends to identity, authority, operational evidence, and the boundary between an agent’s action and its account of that action. The biography does not certify the ontology.

The conflict is sharper because Daniel is both the author of the comparison surface and a maintainer of systems that may be compared against it. Naming that conflict does not remove it. It makes the authority path reviewable.

Project mechanisms remain the primary evidence about what a project does. Project maintainers retain authority over their repositories. When a project and Organon disagree, the result must remain open to at least three diagnoses: the project documentation is defective, the project contains a legitimate distinction Organon does not yet represent, or Organon is defective. The ontology does not win by being the ontology.

The same boundary applies to collaborative authorship. AI systems have contributed wording, criticism, organization, and formalization. Daniel is responsible for adopting the commitments. Generated language remains a proposal until adopted, while future contributors should receive credit for the distinctions, counterexamples, and corrections they introduce. Anonymous collaboration must not harden into anonymous authority.

## Using Organon without surrendering local judgment

Adoption begins with the project, not with a search-and-replace over its nouns.

First, identify the actual actors, boundaries, transformations, records, and authority paths. Ask who can perform each action under which technical constraints, who may authorize it, whose interests count as the Principal’s, and which observations are outside the claimant’s relevant control.

Next, choose the Organon version and any profiles the repository intends to adopt. Declare the governed paths. Map local vocabulary explicitly rather than assuming that matching words have matching meanings.

Each proposed correspondence can then be classified as:

- **Exact:** the local mechanism satisfies the Organon definition within the declared Scope.
- **Refinement:** the local term adds constraints while preserving the mapped distinction.
- **Conflict:** the local and Organon terms make incompatible commitments.
- **Unmapped:** the project needs a distinction for which no responsible correspondence has been established.

Unmapped is not automatic failure. It may be the most accurate result available. A useful review preserves the location of disagreement long enough to decide whether the project, the mapping, or Organon should change.

An adoption manifest records the version, profiles, governed paths, and local mappings. The repository checker expands selected profiles through the ontology’s dependency closure and validates the declared contract:

```sh
python3 scripts/check-adoption.py path/to/organon-adoption.json --repo-root path/to/repository
```

Passing that check establishes agreement with the declared machine-readable contract. It does not establish that the mapping is philosophically correct, that the project has implemented every documented mechanism, or that a human maintainer has approved adoption. Automated gates produce review material; they do not grant themselves authority.

## A vocabulary that can be changed without quietly changing

Because Organon may influence how other repositories are judged, binding changes carry a larger burden than ordinary wording edits. [Contributing to Organon](CONTRIBUTING.md) requires a proposed term to survive a termhood challenge, explicit dependency ordering, collapse audits in both directions, comparison with strong intellectual precedents, proportionate formal pressure, witnesses and countermodels, and a complete rereading of the readable ontology.

Governed surfaces must then be updated together. Objections must be separated into those resolved and those that remain open gates. Passing CI establishes local verification, not adversarial review or philosophical truth. The exact promoted content becomes binding only when it enters the canonical ontology and its governed projections agree.

That revision process is part of the instrument’s meaning. Organon v0.18 is provisional and binding only where explicitly adopted. It does not claim completeness, universal truth, or immunity to correction. Its narrower promise is that named distinctions will not quietly change halfway through an argument—and that changing them later will leave an inspectable record of who changed what, under which procedure, and with which unresolved objections.

A project can therefore use Organon without yielding its own judgment. It can adopt a distinction, refine it, reject a mapping, expose an unrepresented mechanism, or return a counterexample to the ontology. The common vocabulary becomes useful precisely because disagreement remains typed rather than suppressed.

**A shared vocabulary is infrastructure only when its correspondences, authority, and revision conditions remain inspectable.**

### Evaluation

| Layer | Minimum score | Critical violations | Revision |
|---|---:|---|---|
| Deterministic | pass | — | — |
| Ontology | 3/4 | none | Replace the Evidence shorthand with: “A component’s report about its own Action remains a Claim unless an Observation produced by a Witness IndependentFor the claimant and that Claim is admitted by a named Order under an Admissibility Rule whose Scope includes both.” Replace “Project mechanisms remain the primary evidence about what a project does” with “Project mechanisms remain the primary objects of factual review when determining what a project does.” Preserve the rest of the artifact. |
| Short-form delivery | 3/4 | none | Optional clarity revision for the first delivery: "A system becomes impossible to govern when its terms remain locally plausible but no longer correspond across repository boundaries." The other deliveries need no revision. |
| Long-form grammar | 3/4 | none | Make the revaluation concrete by returning to the opening repositories after the adoption walkthrough: classify one disputed term, identify the authority or witness that is missing, and show which governance decision changes. Cut or qualify “impossible to govern,” allowing the formalization sentence to remain a local delivery and the final inspectability criterion to stand clearly as the global one. This would reduce competition among polished turns while proving that the inherited frame operates on the original situation. |

**Reader start:** Software can pass its tests while the repositories around it quietly disagree about what its permissions, evidence, and completion records mean. Organon begins with that familiar infrastructure failure rather than with a demand for philosophical agreement.

**Consequential missingness:** Locally plausible documentation can conceal missing correspondences between technical mechanisms and institutional terms. Without an inspectable way to distinguish Capability from Permission, a Claim from Evidence, or output from completion, maintainers must reconstruct the system's meaning whenever language crosses a repository boundary.

**Inheritance:** A shared vocabulary is infrastructure only when its correspondences, authority, and revision conditions remain inspectable.

**Source anchors:** README.md, DANIEL.md, CONTRIBUTING.md, provenance/editorial.md

## A Vocabulary That Has to Survive Its Own Definitions

> Target: `organon-ontology` · Gate: **pass** · Attempt: 2

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

### Evaluation

| Layer | Minimum score | Critical violations | Revision |
|---|---:|---|---|
| Deterministic | pass | — | — |
| Ontology | 4/4 | none | Review-ready. For maximal precision, the first condensed definition of Evidence could explicitly say that IndependentFor is indexed to the Witness, claimant, Claim, Observation, and governing Order, and the Truth summary could name its declared Rule and Denotation join. These obligations are supplied elsewhere in the draft, so the omissions are not load-bearing. |
| Short-form delivery | 4/4 | none | No revision required. |
| Long-form grammar | 3/4 | none | Keep the argument and ending, but reduce the sense of staged local deliveries. Retain the strongest two blockquotes—the definition-as-burden turn and the first-unmet-obligation turn—and integrate the others into their paragraphs. Consider using the completion report briefly as a running test earlier in the causal and institutional sections; its final return would then feel even more cumulative while trimming some catalogue-like exposition. |

**Reader start:** Begin with a technical reader who has seen capitalized vocabulary conceal an ordinary disagreement. Invite inspection without requiring prior assent: the question is not whether to believe the ontology wholesale, but which definition, witness, and upstream commitment produce a particular classification.

**Consequential missingness:** The reader’s current frame is a field containing either philosophical prose or formal declarations, but not a reliable way to trace a classification between them. The expected Presence is an inspectable account of which definition does the work, which witnesses it requires, and which commitment must change to alter the result. Without that account, disagreement attaches to labels while hidden bridges remain untouched.

**Inheritance:** Carry a classification trace: locate the stable definition and claim type, follow its dependencies, demand every required witness, apply the relevant anti-collapse rule, and identify the earliest commitment whose revision would change the result.

**Source anchors:** ontology/changelog.md, ontology/formal/README.md, ontology/formal/decisions.md, ontology/formal/organon-core-reduct-report.md

## Engram

> Target: `engram-main-readme` · Gate: **pass** · Attempt: 2

<p align="center">
  <img src="docs/assets/engram-mark.svg" alt="Engram: a monochrome moire aperture over a dark terminal field" width="760">
</p>

<h1 align="center">Engram</h1>

<p align="center">
  <strong>Remote tmux, rendered as a quiet signal.</strong>
</p>

Engram is a single-user Telegram control surface for local tmux sessions. It creates or attaches to tmux windows, routes authorized Telegram messages into panes, and represents each watched pane with one stable, pinned Telegram anchor.

That anchor has two presentations: a conversational guide produced by a selected model, or a literal image of a bounded terminal capture rendered locally by Chromium. tmux remains the durable process and terminal-history layer. Its mature, narrow command surface makes it a stable substrate for a small remote-work tool. Engram is the remote control and presentation surface around it.

> **Read the boundary before installing.** Compromise of the authorized Telegram account may become shell access for the configured local user. A stolen bot token may expose or disrupt the bot channel and should be revoked immediately. Telegram bot chats are not end-to-end encrypted.

## Choose how the terminal is represented

| Conversational guide | Chromium snapshot |
| --- | --- |
| Sends the bounded terminal frame to Anthropic Haiku 4.5 or OpenAI Luna and returns compact prose. Dense output may be easier to scan across several sessions, but the model may misunderstand it. Captures are not credential-redacted before transmission to the provider. | Renders the bounded frame locally as an ANSI-preserving phone-width image. No model interpretation is involved and no snapshot content goes to a model provider, but the exact unredacted image of that capture is uploaded to Telegram. Rendering also uses more local CPU. |
| Requires `LLM_PROVIDER` and the selected provider's API key. Chromium is optional and adds `🖼️ View`. | Requires a Chromium-compatible executable. A configured guide provider is optional and adds `🗣️ Talk`. |

`ENGRAM_ANCHOR_MODE` supplies the startup fallback. `/mode guide` and `/mode snapshot` migrate live anchors when the requested dependency is available and persist the choice across restarts.

The guide interprets the terminal. The snapshot shows its captured state. Neither is the terminal itself, but both carry terminal content across the local-to-Telegram privacy boundary.

## Requirements and platform posture

Engram requires:

- Linux or macOS;
- Go 1.22 or newer;
- tmux 3.2 or newer, Git, Make, and curl;
- a Telegram account;
- for guide mode, an Anthropic API key with Claude Haiku 4.5 access or an OpenAI API key with Luna access;
- for snapshots, a Chromium-compatible executable;
- for automatic voice transcription, an OpenAI API key with `gpt-4o-transcribe` access, independently of the guide provider.

Linux with a systemd user session is the primary supported service posture. macOS is compile-checked and can run manually in the foreground; the repository also provides a LaunchAgent path that must be activated explicitly. Do not assume service parity with Linux.

On macOS, use the standalone `chrome-headless-shell` from [Chrome for Testing](https://googlechromelabs.github.io/chrome-for-testing/). Put it on `PATH` or set its absolute path in `ENGRAM_SNAPSHOT_BROWSER`. Automatic detection deliberately excludes desktop Chrome and Chromium applications; Engram does not download or update the browser.

## First run

### 1. Clone the repository

```sh
git clone https://github.com/idolum-ai/engram.git
cd engram
```

### 2. Create one private Telegram bot

1. Open the verified `@BotFather` account.
2. Send `/newbot` and follow the prompts.
3. Keep the returned token private; it controls the bot.
4. Open a direct message with the new bot and send `/start`.

Before Engram begins polling, retrieve that direct message from the official Bot API. This form keeps the token out of shell history and the `curl` argument list:

```bash
read -rsp "Bot token: " BOT_TOKEN; printf '\n'
printf 'url = "https://api.telegram.org/bot%s/getUpdates"\n' "$BOT_TOKEN" \
  | curl --silent --show-error --config -
unset BOT_TOKEN
```

In the JSON response, find the update whose `message.chat.type` is `private` and copy the integer at `message.from.id`. Do not use `update_id` or the bot's own ID. The response contains the text of your direct message, so do not paste it into an issue.

### 3. Create the protected configuration

```sh
install -d -m 0700 "$HOME/.engram"
install -m 0600 .env.example "$HOME/.engram/.env"
${EDITOR:-vi} "$HOME/.engram/.env"
```

For guide mode with Anthropic:

```dotenv
TELEGRAM_BOT_TOKEN=the-token-from-BotFather
TELEGRAM_ALLOWED_USER_ID=the-message.from.id-integer
ENGRAM_ANCHOR_MODE=guide
LLM_PROVIDER=anthropic
ANTHROPIC_API_KEY=your-Anthropic-key
```

For OpenAI Luna, use `LLM_PROVIDER=openai` and set `OPENAI_API_KEY`. Provider changes require a restart.

For snapshot mode:

```dotenv
TELEGRAM_BOT_TOKEN=the-token-from-BotFather
TELEGRAM_ALLOWED_USER_ID=the-message.from.id-integer
ENGRAM_ANCHOR_MODE=snapshot
```

Leave `TELEGRAM_CHAT_ID` empty for direct-message use; Engram then uses the allowed user ID as the private chat ID. Group operation is unsupported. Never commit or post the completed env file. The file must be regular and have no group or other permissions. Engram rejects a foreign-owned, non-directory, or symlinked `ENGRAM_HOME`.

Voice replies default to `VOICE_INPUT_MODE=path`: Engram retains the OGG in its private attachment store and sends its absolute path to the pane. `VOICE_INPUT_MODE=transcribe`, together with an OpenAI key, sends the audio once to `gpt-4o-transcribe`, delivers one normalized `(transcribed) ...` input, and removes the temporary audio. Transcription failure sends no terminal input and never silently falls back to path delivery. Voice-mode changes require a restart.

[`.env.example`](.env.example) is the complete configuration surface.

### 4. Validate without external calls

These commands validate configuration without calling Telegram or the selected model provider and without starting polling. `dry-start` also creates and opens the local state surface.

```sh
go run ./cmd/engram preflight --env "$HOME/.engram/.env"
go run ./cmd/engram dry-start --env "$HOME/.engram/.env"
```

Confirm that both finish with `status: ok`, that tmux is not reported as `missing`, and that the displayed user and chat IDs are the intended private-DM IDs.

### 5. Start one Engram process

On Linux:

```sh
make install-service PREFIX="$HOME/.local"
make service-status PREFIX="$HOME/.local"
```

For the repository's macOS LaunchAgent path, activation is explicit:

```sh
make install-service PREFIX="$HOME/.local"
make service-start PREFIX="$HOME/.local"
make service-status PREFIX="$HOME/.local"
```

Only one Engram process may poll a configured bot/user/chat tuple, and only one process may own an `ENGRAM_HOME`. Do not run a foreground copy while the service is active.

### 6. Verify the first session

In the bot DM, send:

```text
/new pwd
```

Engram creates a tmux window, runs `pwd`, and returns an editable session anchor. In guide mode, bounded pane text goes to the selected provider. In snapshot mode, an exact image of the bounded capture goes to Telegram. Review the next section before running anything that may print credentials or sensitive content.

## What crosses each boundary

**Telegram.** Engram receives commands and attachments and sends anchors, snapshots, requested files, raw views, dumps, logs, template exports, and download results. In snapshot mode, each changed live frame is an exact, unredacted image of the bounded terminal capture sent automatically at most once every ten seconds.

**The local shell.** Authorized messages create windows and send literal shell input or key presses. tmux owns terminal history and continues running after Engram stops unless a window is explicitly closed. `/close` kills windows created by Engram, but only untracks attached or legacy windows.

**The guide provider.** Guide requests contain joined logical text from the bottom 96 physical terminal rows. Snapshot captures use the bottom 64 rows. Each guide rendering is one non-streaming request, and delivered prose is deterministically bounded to 180 words. There is no model API conversation history. A guide may propose physical keys, but Engram displays the normalized sequence and target for separate confirmation; the model does not send them directly.

**Local state.** `ENGRAM_HOME` contains state, remembered templates, bounded audit logs, and locks. Templates retain exact user-authored bodies in plaintext. Files are private to the host account, but anyone controlling that account may read them. Raw captures remain in process memory rather than `state.json`; state still contains sensitive metadata and derived terminal content.

**Attachments and downloads.** Incoming files and generated artifacts occupy a private runtime directory and may remain until manual or operating-system cleanup. `/download <absolute-path>` rejects symlinks, opens a local regular file, copies a bounded snapshot, and uploads it to Telegram. It is an intentional file-exfiltration command: inspect the exact path first.

Audit and guide prose receive best-effort pattern redaction. Redaction may miss unfamiliar secrets or sensitive prose. It does not sanitize raw terminal captures, `/raw`, `/dump`, `/download`, incoming attachments, existing Telegram history, snapshots, or ordinary captures sent to the selected guide provider. Treat terminal transcripts and diagnostic artifacts as sensitive.

### Optional Codex and Claude session context

`ENGRAM_CODEX_CONTEXT_TURNS=1..8` and `ENGRAM_CLAUDE_CONTEXT_TURNS=1..8` are separate privacy opt-ins. When exact pane, process-incarnation, hook binding, UUID, and transcript checks succeed, Engram adds a bounded, redacted subset of recent visible user and assistant messages to guide requests. Hidden reasoning, system and developer messages, tools and results, attachments, sidechains, subagents, and generated metadata are excluded. Unknown or ambiguous layouts fail closed to terminal-only guidance, and transcript text is not persisted by Engram.

Raw tmux capture remains the source for current terminal facts. Historical messages may clarify the prior topic; they do not establish current files, hashes, references, screenshots, or process state. See [Agent compatibility](docs/agent-compatibility.md), the [Codex context guide](docs/codex-session-context.md), and the [Claude Code context guide](docs/claude-code-session-context.md).

## Pane-scoped GitHub App access

Engram brokers short-lived GitHub App installation tokens to watched panes. It does not accept personal access tokens, OAuth user tokens, arbitrary secrets, or generic cloud credentials.

Enroll an App under a local alias:

```sh
engram github app add idolum \
  --app-id 123456 \
  --installation-id 987654 \
  --pem ./github-app.private-key.pem
```

Engram prompts twice for a passphrase of at least 12 bytes, stores the App private key encrypted under `ENGRAM_HOME`, and does not store the passphrase. The source PEM remains untouched; secure or remove it separately after confirming enrollment. Updating an alias atomically replaces its enrollment, so repeat the complete intended installation set and unlock mode.

From a watched pane, request an exact repository and permission scope:

```sh
engram github exec \
  --app idolum \
  --repo idolum-ai/engram \
  --permission contents=read \
  --permission pull_requests=write \
  -- gh pr view 49
```

Repository and permission flags are mandatory. Engram validates the live tmux server, window, and pane; sends the configured Telegram user an approval containing the complete shell-quoted command; waits up to fifteen minutes; inspects the selected GitHub installation; and rejects missing, excessive, truncated, ambiguous, or redaction-requiring requests. A multi-installation alias requires `--installation-id`; Engram never guesses or combines authority across installations.

After approval, the bearer token is neither printed by Engram nor written to disk. One child command receives it through `GH_TOKEN`. An active same-pane lease serves only repository-and-permission subsets. Broader requests require another approval.

For a bounded work session, `engram github grant` records a pane, App installation, repository ceiling, permission ceiling, purpose, and expiry. The default configurable ceiling is eight hours and the absolute limit is 24 hours. Grants and leases live only in Engram memory and disappear on expiry, revocation, enrollment change, pane invalidation, unwatching, or restart.

```sh
engram github status
engram github revoke
engram github app list
engram github app remove idolum --yes
```

Local passphrase entry is the default. `--telegram-unlock` explicitly sends the passphrase through Telegram's cloud transport. Engram deletes the forced-reply prompt and response and does not record their text, but deletion does not undo cloud exposure or account compromise.

These controls reduce plaintext credential storage and accidental overreach. They do not isolate secrets from root, malicious code controlling the same operating-system user, or a child command that prints its environment. Commands run under a lease remain trusted with the requested authority. Read the complete [pane-scoped GitHub App capability guide](docs/github-app-capabilities.md) before enrollment.

## Operation, updates, and inspection

Common Telegram commands include `/sessions`, `/attach`, `/new`, `/send`, `/text`, `/key`, `/raw`, `/dump`, `/download`, `/logs`, `/status`, and `/mode`. Use `/help` for the complete list or run `engram commands` for machine-readable metadata. Reply to a current session anchor to send text; stale or retired views fail without reaching tmux.

Operate the service with:

```sh
make service-status PREFIX="$HOME/.local"
make service-stop PREFIX="$HOME/.local"
make service-start PREFIX="$HOME/.local"
make service-restart PREFIX="$HOME/.local"
make service-logs PREFIX="$HOME/.local"
```

Installing or replacing a binary does not restart a running service. For a tagged release, choose a reviewed version, inspect `scripts/install-release.sh` at that tag, and then run it. The installer checks the archive checksum and embedded version before replacing the binary; it does not modify `~/.engram`, create a service, or restart one. After an explicit restart, verify the running process through `/version` or `/status`, not only the binary on disk. See the [release strategy](docs/release-strategy.md).

Read-only local inspection makes no network calls and leaves Engram state unchanged:

```sh
engram inspect status
engram inspect sessions
engram inspect frame 3
```

Inspection does not redact literal pane content, and invoking tmux may execute hooks configured by the owning user. See [Headless operation](docs/headless-operation.md).

## Verification and project status

Run the local gate before pushing:

```sh
make check
```

It runs tests, `go vet`, Darwin compile checks, architecture and release checks, workflow and documentation checks, a tracked-file secret scan, and a smoke build. Live guide, key-composer, tournament, and provider compatibility evaluations are manual opt-ins because they require provider credentials. Their fixture and threshold results are regression checks, not promises of general correctness or proof that a guide rendering is terminal truth.

Before the first real command—and after any change of account, mode, provider, or capability—verify the authorized identity and destination, know whether the anchor is an interpretation or a literal bounded capture, and grant external authority only with an explicit pane, scope, and lifetime. A working remote path is useful. An inspectable one is operable.

For deeper review, see [Contributing](CONTRIBUTING.md), the [changelog](CHANGELOG.md), [E2E testing](docs/e2e-testing.md), and [private vulnerability reporting](SECURITY.md).

Engram is open source under the MIT License. See [LICENSE](LICENSE).

### Evaluation

| Layer | Minimum score | Critical violations | Revision |
|---|---:|---|---|
| Deterministic | pass | — | — |
| Ontology | 4/4 | none | No mandatory revision. As a minor precision edit, replace “`engram github grant` records a pane…” with “creates an in-memory authorization envelope bound to a pane…” to avoid any suggestion that renewable grants are persisted; the following sentence already states that grants and leases live only in memory. The macOS posture could also explicitly note that LaunchAgent installation is repository-provided but activation remains manual, preserving the draft’s careful treatment of the dossier’s uneven platform wording. |
| Short-form delivery | 4/4 | none | No revision required. If greater specificity is desired, replace “local state permissions” with the exact filesystem or session permissions users must verify. |
| Long-form grammar | 3/4 | none | Strengthen the final revaluation by returning explicitly to the first `/new pwd` session and showing how the operator now reads it differently: identify whether its anchor is interpreted prose or a literal capture, name which external service received the content, confirm the authorized identity and destination, and explain why any later GitHub action requires a separate pane-scoped and time-bounded grant. This would demonstrate the central instrument on the opening situation instead of ending primarily with a polished recap. Preserve the candid limitations and operational detail; only trim repeated boundary warnings where a later occurrence adds neither a new actor, mechanism, nor action. |

**Reader start:** A developer has local tmux sessions that need attention away from the desk, but connecting those sessions to Telegram also connects a cloud chat account to the local shell. The README begins at that concrete operating decision: choose an interpreted guide or literal snapshot, understand what each exposes, then configure one private user and verify the boundary before sending commands.

**Consequential missingness:** A Telegram terminal interface can look like a smaller terminal while concealing several consequential distinctions: guide prose is an interpretation rather than terminal state; snapshots are literal but still leave the host; bot identity limits who may ask, not what an authorized request may do; and a GitHub approval is safe only when its pane, installation, repositories, permissions, command, and lifetime remain explicit. Without those distinctions, convenience acquires authority that the operator may not realize was granted.

**Inheritance:** Engram makes remote terminal work legible without pretending that an interpreted guide is the terminal, or that remote convenience should carry ambient authority.

**Source anchors:** evals/editorial-artifacts/inputs/sources/engram-main-README.md

## Kenogram

> Target: `kenogram-main-readme` · Gate: **pass** · Attempt: 1

<p align="center">
  <img src="docs/assets/kenogram-mark.svg" alt="Kenogram: a dense field of light emerges from a dark circle and stops at a black triangular occlusion" width="760">
</p>

# Kenogram

Kenogram lets you give an agent a whole small computer without giving it your computer.

Kenogram materializes rootless Linux worlds for AI agents from host-authored declarations. A declaration selects the image and admits host files, mounts, secrets, resource limits, durable TCP destinations, and named loopback interfaces. Kenogram adds no ambient host filesystem access; the inhabitant may freely use what the image and declaration make available.

Anything admitted into an AI’s context can change what follows. The corresponding security question is what that changed agent can affect. Kenogram limits those consequences structurally: ambient capability is not present unless the host operator admits it explicitly. Requests expressed through terminal interaction do not change world authority. Applying a declaration grants durable authority; `allow` can grant time-bounded TCP egress.

Kenogram is for developers, security teams, and platform operators who want a tool-using agent to have a useful environment without inheriting the operator’s ambient computer.

## The declared-world boundary

Kenogram is an execution boundary for untrusted agent processes, not a prompt filter. It makes admitted host authority explicit and inspects the resulting runtime before starting declared services.

| Condition | Enforced observation |
|---|---|
| Host access | Undeclared mounts are rejected. The exact declared mount set and bind-source filesystem identity are verified, and no host container-runtime control socket is mounted. |
| Network | A base world is loopback-only, with no working resolver or exterior TCP/UDP route. Declared or temporarily granted TCP destinations pass through a host-held exact-destination proxy; direct IP dialing remains unroutable. |
| Runtime | Rootless execution, private network/PID/IPC/UTS namespaces, an empty capability bounding set, `no-new-privileges`, active seccomp, no added devices, and CPU/memory/PID limits are inspected before services start. |
| Authority | The host-authored declaration admits durable capabilities. An explicit, time-bounded `allow` command may grant temporary TCP egress. A named operator interface reaches one declared world-loopback service without publishing a host port. |
| Replacement | A successor is inspected before it is recorded as applied. Durable transition state identifies the authoritative generation after interruption. |

This boundary constrains what a compromised or prompt-contaminated agent can reach. It does **not**:

- detect or prevent prompt injection;
- protect declared writable mounts or secrets from world processes;
- prevent exfiltration to a destination the operator admits;
- authenticate, encrypt, authorize, or interpret `kenogram connect` traffic;
- harden a hostile multi-tenant host; or
- independently prevent a Linux kernel or container-runtime escape.

Kenogram relies on the Linux kernel and rootless Podman. A rootless container shares the host kernel. Reviewers who require a separate-kernel boundary should treat that difference as material rather than reading “agent environment” as a universal security category.

The [security contract](requirements/security.md), [network invariants](requirements/network.md), and [evidence and known limits](requirements/INDEX.md#evidence-and-known-limits) define the exact claim. Kenogram is a composable control within a larger system, not a claim of compliance or certification for that system.

## Status and supported runtime

[Kenogram v0.1.1](https://github.com/idolum-ai/kenogram/releases/tag/v0.1.1) is evaluation software and does not make a production-stability claim.

Release binaries support Linux on amd64 and arm64. The runtime exercised in mandatory CI requires:

- rootless Podman;
- cgroups v2;
- `nsenter`; and
- subordinate UID/GID ranges for the current user.

Kenogram fails closed rather than weakening the boundary when those prerequisites are absent.

The [experimental Apple container-machine launcher](docs/apple-container-machine.md) transports explicit operations into an operator-managed Linux machine. It is not macOS runtime support; the real Apple-machine lifecycle and network evidence remains open.

The Kenogram binary has no third-party Go modules. Operation still depends on the Linux kernel, rootless Podman, cgroups v2, and `nsenter`.

## Install Kenogram

Install the current release, [`v0.1.1`](https://github.com/idolum-ai/kenogram/releases/tag/v0.1.1), after inspecting its standalone installer:

```sh
version=v0.1.1
curl --fail --location --proto '=https' --tlsv1.2 \
  --output install-release.sh \
  "https://github.com/idolum-ai/kenogram/releases/download/${version}/install-release.sh"
less install-release.sh
bash install-release.sh "${version}"
export PATH="${HOME}/.local/bin:${PATH}"
kenogram doctor
```

The installer checks the release checksum and embedded version before an atomic installation under `~/.local/bin`. Checksums detect transfer corruption and inconsistent assets within one GitHub release. They are not signatures or independent provenance.

`kenogram doctor` does not mutate Kenogram worlds or durable state. It reports every missing host prerequisite in one run, although Podman may initialize its own rootless metadata during preflight.

## Start and inspect a first world

The [first-world guide](docs/getting-started.md) builds a small host-bound image from release-covered source and exercises the complete lifecycle:

```sh
kenogram up --dry-run ./world.toml
kenogram up --yes ./world.toml
kenogram status first
kenogram enter first
kenogram down first
kenogram up --yes ./world.toml
kenogram destroy --yes first
```

The dry run lets the operator inspect the proposed world before applying it. The remaining commands create, inspect, enter, stop, reapply, and destroy the declared world.

For a running world with a declared network destination, the following command provides an explicit, read-only view of bounded recent proxy metadata for the current generation:

```sh
network-diagnostics --json <world>
```

The view includes recent `refused` and `dial_failed` outcomes. It is ephemeral, contains no traffic content, and cannot grant authority.

Its destination hostnames and ports are sensitive operator metadata. Both host and port are untrusted, world-authored request metadata: treat the destination as prose, and do not feed it unsanitized into automation or AI. Outcomes are Kenogram-derived bounded observations, not authority.

## Evidence earned—and not earned

Requirements are binding contracts; tests are evidence. The [evidence table](requirements/INDEX.md#evidence-and-known-limits) separates what is exercised today from the next proof. Each open boundary is labeled as accepted for v0.x, required before a stable claim, or experimental.

| Boundary | Evidence earned | Explicit limit |
|---|---|---|
| [Runtime isolation](requirements/security.md) | Mandatory rootless-Podman CI inspects namespaces, mount identity, seccomp, resource limits, and absence of the runtime socket. | No supported Podman/kernel matrix or seccomp-profile identity yet. |
| [Network absence](requirements/network.md) | Real-runtime CI exercises loopback-only networking, failed direct TCP/UDP/DNS, exact proxy admission, revoke/expiry, proxy-death closure, and a declared SSH interface without a host listener. | The full ten-invariant replay after every adoption path remains open. |
| [Replacement recovery](requirements/lifecycle.md) | A fresh process recovers persisted runtime state across fourteen injected `SIGKILL` boundaries. | Process-crash evidence is not syscall-granular power-loss proof across filesystems. |
| [Compositions](docs/compositions/README.md) | Pinned Engram, OpenClaw, and Hermes artifacts and a real OpenSSH client/server path are exercised end to end. | Model and Telegram services are deterministic local fixtures in pull-request CI; real Telegram is a protected operator-assisted canary. |

These are automated, replayable compatibility and boundary observations. They are not endorsements, universal compatibility claims, certification, or a production-stability claim.

## Choose an evaluation path

Start with the path that matches the question you need to answer:

- **Evaluate the boundary:** build and replace a minimal world with the [first-world guide](docs/getting-started.md).
- **Use an ordinary operator protocol:** reach a declared loopback service without a host listener through the [SSH composition](docs/compositions/ssh.md).
- **Run an agent composition:** follow the maintained guides for [Engram](docs/compositions/engram.md), [OpenClaw](docs/compositions/openclaw.md), or [Hermes Agent](docs/compositions/hermes-agent.md).

The composition guides state the exact versions exercised, trust and secret boundaries, network grants, resource requirements, and differences between hermetic CI fixtures and real services.

## Adjacent systems

Kenogram belongs to a growing family of agent execution environments. These systems are adjacent rather than interchangeable. The table compares documented architectural choices, not overall security or product quality.

The comparison was reviewed against the linked vendor documentation on 2026-07-14. That documentation remains authoritative.

| System | Runtime boundary | Documented network default | Policy and lifecycle emphasis |
|---|---|---|---|
| **Kenogram** | Rootless Podman container sharing the host kernel | Loopback only; no resolver or exterior TCP/UDP route | Host-authored declaration, exact outbound `host:port`, inspected generations, and durable replacement recovery |
| [Docker Sandboxes](https://docs.docker.com/ai/sandboxes/security/) | Dedicated microVM and private Docker Engine | Default HTTP/HTTPS domain allowlist; other domains and raw TCP, UDP, and ICMP blocked | Local or organization policy, host-side credential injection, and persistent coding-agent workspaces |
| [E2B](https://e2b.dev/docs/network/internet-access) | Isolated Linux VM | Internet enabled by default; configurable block, IP/CIDR, and domain rules | Cloud API sandboxes, templates, and pause/resume persistence |
| [Modal Sandboxes](https://modal.com/docs/guide/sandbox-networking) | gVisor by default; [VM runtime](https://modal.com/docs/guide/vm-sandboxes) in beta | Public outbound access by default; block, CIDR, and beta TLS-domain controls | Hosted programmable sandboxes integrated with Modal applications and resources |
| [Daytona](https://www.daytona.io/docs/en/sandboxes/) | Container, Linux VM, and Windows runtime options | [Tier-dependent policy](https://www.daytona.io/docs/en/network-limits/) with essential services; configurable block, CIDR, and domain rules | API-managed agent computers, resource classes, snapshots, and organization controls |

MicroVM systems provide a separate-kernel boundary that Kenogram does not claim. Kenogram instead focuses on a local, host-owned declaration; observable network non-availability and exact admission; and evidence that replacement, interruption, and reapplication preserve declared authority.

Upstream products and defaults change. Review their linked documentation before making a deployment or procurement decision.

## Why Idolum, and why the name

Idolum separates speech from authority, representation from truth, and capability from ambient context. Kenogram gives that posture an environmental form: the inhabitant controls its declared world, while only the host operator can apply a change to which host capabilities enter it.

The name is a deliberate but limited adaptation of the kenogrammatic lineage begun by Gotthard Günther and developed by Rudolf Kaehr and Thomas Mahler. The project privileges observable patterns over the identity of their realization; it does not claim to implement a morphogrammatic calculus.

The [kenogrammatics note](docs/kenogrammatics.md) records the lineage, the engineering analogy, and its limits.

## Project paths

- [Requirements and evidence](requirements/)
- [Declaration schema](requirements/declaration.md)
- [Operations and recovery](requirements/operations.md)
- [Governed-job guide](docs/governed-jobs.md) and [evidence contract](requirements/jobs.md) — bounded direct Linux execution, create-only evidence, and offline verification
- [Contributing and evidence replay](CONTRIBUTING.md)
- [Security policy and private reporting](.github/SECURITY.md)
- [Release and immutable-publication contract](docs/release-strategy.md)
- [MIT License](LICENSE)

A useful agent world begins with the authority the host explicitly admits, not with the ambient computer the agent happens to inhabit.

### Evaluation

| Layer | Minimum score | Critical violations | Revision |
|---|---:|---|---|
| Deterministic | pass | — | — |
| Ontology | 4/4 | none | No load-bearing revision is required. If the repository later adopts Organon terms explicitly, add an adoption manifest and either map or rename project-specific uses such as “world,” “authority,” and “evidence”; in particular, the current CI results should not be promoted to `organon:Evidence` without the required independent Witness, Admission, Admissibility Rule, Order, and Evidential Bearing joins. |
| Short-form delivery | 4/4 | none | No required revision. If these deliveries will appear together, consider dropping the fourth because it restates the first; otherwise preserve them as written. |
| Long-form grammar | 3/4 | none | No structural rewrite is needed. Tighten the opening phrase “a whole small computer” to avoid briefly implying the separate-kernel boundary later disclaimed; “a whole small Linux world” would preserve the invitation more precisely. For a stronger final revaluation, add one short sentence before the closing line that converts the frame into an evaluation test—for example: “Before adopting any agent environment, enumerate what the host admits, what the runtime independently excludes, and which observations support those claims.” Then retain the current final sentence as the inheritance. |

**Reader start:** A developer, platform operator, or security reviewer is evaluating whether a tool-using AI agent can receive a useful Linux environment without inheriting the operator’s ambient computer or gaining authority through terminal requests alone.

**Consequential missingness:** Agent “sandbox” descriptions often name a runtime without making the admitted host authority, inspected boundary, failure behavior, and limits legible. Without that account, the reader cannot determine what a compromised or prompt-contaminated process can reach, which claims have replayable evidence, or where Kenogram must remain only one control in a larger system.

**Inheritance:** A useful agent world begins with the authority the host explicitly admits, not with the ambient computer the agent happens to inhabit.

**Source anchors:** evals/editorial-artifacts/inputs/sources/kenogram-main-README.md

## Canonicality boundary

The generated drafts and judge verdicts are noncanonical observations. Passing the automated gate does not make either article Daniel-authored, establish its factual Claims, or promote the provisional long-form grammar. Same-model generation and judging is an explicit limitation even though prompts and calls are separate.
