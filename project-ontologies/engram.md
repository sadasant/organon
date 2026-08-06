---
type: project-ontology
project: Engram
repository: https://github.com/idolum-ai/engram
branch: main
commit: 645c76c624cbb6e21f9d4187b3fc093f36b6cf38
reviewed_at: "2026-08-06"
organon_version: "0.17.0"
status: generated-candidate
sensitivity: public
evidence_basis: public-repository-source-and-documentation
---

# Engram Project Ontology

## Scope and nonclaims

This candidate describes Engram as represented by the public repository at the exact revision named above. The inspected evidence includes the binding requirements, design documents, runtime state and routing structures, tmux mechanics, and GitHub capability broker.

This document does **not** claim:

- deployment, adoption, production use, reliability, security, or user outcomes beyond what the repository demonstrates;
- that a requirement is implemented merely because it is written;
- that a test or audit entry is independent Evidence in Organon's binding sense;
- that Engram's ordinary-language uses of “truth,” “evidence,” “authority,” “permission,” “agent,” or “session” adopt the corresponding `organon:*` term;
- that every process visible through Engram is an Agent;
- that the repository, application binary, running process, installation, watch, pane, and Telegram anchor are one Entity.

The repository declares its requirements “draft but binding for implementation” and identifies them as the source of truth (`requirements/INDEX.md:1-7`). This is evidence of the project's own governing Reference, not evidence that those requirements are True, satisfied, or independently warranted under Organon.

## Project purpose

Engram is a single-user Telegram control surface for local tmux sessions. It creates or attaches to tmux windows, routes messages into panes, and maintains one pinned Telegram anchor per watched pane (`README.md:11-18`). Its narrower protocol posture is to provide a handle for a pane, one bounded observation, one stable current view that routes replies, and conservative recovery (`docs/protocol-posture.md:17-29`).

Its defining architectural commitment is that tmux remains the workspace and the source of current terminal facts. Engram captures and acts through tmux rather than emulating terminal state (`docs/design-principles.md:39-51`). Conversational guide prose and Chromium snapshots are alternative presentations of the same bounded frame (`README.md:20-29`); model output is presentation and is never automatically executed (`docs/design-principles.md:215-234`).

The intended function is therefore:

> Preserve a small, inspectable, identity-bound path between one admitted remote human action and one local terminal effect, while making the resulting bounded terminal state quickly legible without allowing presentation to become authority.

## Local vocabulary

The project supplies a particularly useful local vocabulary in `docs/protocol-posture.md:31-48`.

| Local term | Repository meaning | Source | Ontological reading |
| --- | --- | --- | --- |
| Pane identity | Immutable tmux server-lifetime `%pane_id` and `@window_id` pair; the implementation also carries a server incarnation | `docs/protocol-posture.md:31-35`; `internal/tmux/tmux.go:92-103`; `internal/state/state.go:110-120` | An object-language identity criterion for a pane during one tmux server incarnation; necessary but not alone a complete Persistence witness. |
| Watch | Local Record binding a user-facing ID to pane identity, provenance, lifecycle, and observation state | `docs/protocol-posture.md:33-37`; `internal/state/state.go:110-163` | A persistent governance Map about a pane, not the pane itself. |
| Frame | One bounded physical ANSI and joined logical capture over shared coordinates | `docs/protocol-posture.md:36-38`; `internal/tmux/tmux.go:105-122` | A causally produced Sign representing pane State. It is not automatically an Organon Observation because the capture value need not persist as a Record. |
| Current view | The single canonical presentation for a watch in the selected frontend | `docs/protocol-posture.md:39-40` | An Interface state whose permitted reply Transformation is represented. |
| Route | A current view or latest alternate allowed to request input for the same watch; superseded routes are stale | `docs/protocol-posture.md:41-42` | A project-local routing eligibility. It is not by itself an Organon Permission or Authority. |
| Input action | Command plus Enter, literal text without Enter, or validated keys | `docs/protocol-posture.md:43-44` | A typed refinement of Action at the Engram-to-tmux boundary. |
| Attention record | Bounded terminal-authored request to look, with deduplication ID but no sender identity | `docs/protocol-posture.md:44-45` | A causally produced Sign. Without an identified asserting Agent it is not a Claim. |
| Canonical anchor | One current pinned Telegram representation for an expanded watch | `docs/design-principles.md:53-60` | A persistent Interface/Representation, distinct from the watched pane and captured frame. |
| Collapsed shelf | One inert shared representation of multiple watches, without per-pane input routes | `docs/design-principles.md:69-83` | A Map and Interface whose Constraints deliberately exclude terminal Action. |
| Requirements | Runtime contracts expected to be executable | `requirements/INDEX.md:3-7` | Specifications and Rules when they provide constructive decision procedures; prose aspiration alone is only a Claim. |
| Audit event | A local typed account of a runtime transition or failure | `internal/app/input.go:112-161` | A Record. It is not a Receipt unless Agent, Authority, Permission, Scope, and observed Consequence are joined; it is not Evidence without an independent Witness and Admission. |
| GitHub capability request | Pane-bound request naming App, repositories, permissions, command or bounded grant purpose | `internal/githubauth/types.go:28-47`; `internal/githubauth/types.go:92-171` | A scoped Claim candidate within Engram's authorization Order. It remains short of Permission Claim because named Agent, Principal, Order, and—in exact-command form—interval are not carried explicitly. |
| Lease / renewable grant | Process-local record of a scoped GitHub token or approved renewable authority envelope | `internal/githubauth/types.go:49-68`; `internal/app/github_grant.go:69-96` | A scoped Record of local capability. It is not an Organon Grant or Permission until Principal, Agent, Authority, Permission Claim, Admission, Order, Scope, and interval are joined explicitly. |

## Participants and worlds

Classification is relational and scoped. The same Presence can occupy different profiles under different Scopes without those terms collapsing.

| Presence | Organon profile | Basis and limit |
| --- | --- | --- |
| Authorized human operator | `organon:Agent` | The operator interprets presented States and selects Telegram Actions. The project admits exactly one user and chat (`requirements/security.md:7-14`); authorization does not imply Truth, expertise, or unrestricted Authority. |
| Running Engram installation | `organon:Agent` candidate; `organon:Entity` candidate | It transforms Telegram and tmux Perceptions through Rules into selected Actions. Persistence across process restart is carried by bounded state (`docs/design-principles.md:271-276`), but the repository does not declare one complete identity Invariant across binary, configuration, home, and service incarnations. Promotion therefore remains gated. |
| Watched tmux pane | `organon:Entity` refinement | Immutable pane/window/server identifiers are validated before effects (`requirements/tmux.md:29-44`). A pane is not identical to its Watch, anchor, process, or content. |
| tmux | `organon:Substrate` refinement and `organon:Tool` refinement | It persistently supplies terminal States to capture/input Transformations under its own constraints (`docs/design-principles.md:39-51`). Relative to the operator, it is also incorporated into Action without becoming the operator. These are scoped profiles, not synonymy. |
| Telegram Bot API | External `organon:Entity`; part of Engram's `organon:Environment` | It carries remote messages and anchors across Engram's boundary. The public API is not an internal Organ of Engram. |
| Telegram anchor | `organon:Interface` refinement | It explicitly represents allowed Transformations for coordination; only the current route may cause input (`docs/protocol-posture.md:50-64`). |
| Guide model/provider | `organon:Tool` candidate | Engram incorporates the configured provider service only into presentation. Terminal text is untrusted data, and guide prose never executes (`requirements/security.md:102-123`). An isolated model is not an Agent under Organon; promotion also requires the provider Entity's identity criterion. |
| Chromium renderer | `organon:Tool` refinement | It renders a literal bounded frame and does not select terminal Actions (`README.md:22-29`). |
| State store | `organon:Organ` candidate of an Engram installation | It persistently maintains watches, anchors, attachments, update position, and recovery data (`internal/state/state.go:36-57`, `internal/state/state.go:370-396`). This assumes the larger installation is accepted as an Entity. |
| Terminal-mechanics subsystem | `organon:Organ` candidate | It performs recurring identity-guarded tmux Transformations for Engram (`requirements/tmux.md:38-40`; `internal/tmux/tmux.go:509-561`). It is not the external tmux Entity. |
| GitHub capability broker | `organon:Organ` candidate | It performs a specialized recurring authorization path for Engram (`internal/app/github_auth.go:65-103`). Its Unix socket is an Interface, not the Authority itself. |
| Engram authorization regime | `organon:Order` candidate | Configured identity, binding checks, approval records, Rules, and interfaces coordinate the human operator, Engram, tmux, and GitHub. The public evidence does not establish persistence through changing participants sufficient to call it an Institution. |
| GitHub | External `organon:Institution` candidate | GitHub supplies the external App installation, repositories, permissions, and token-issuing Order. This ontology does not attempt to model GitHub's complete institution. |
| One watch's bounded actionable terminal domain | `organon:World` refinement | The frame, selected references, current route, and reachable Actions form a scoped Configuration available to operator Perception and Action. It is not the entire host and never Reality. |
| Local files, terminal processes, network services, provider APIs | `organon:Environment` relative to Engram | They are related to but not included in a narrowly drawn Engram installation identity. Individual components may become Tools when deliberately incorporated into a Causal path. |
| Local filesystem | `organon:Substrate` candidate for persistence paths | It supplies input States to state, attachment, audit, and credential-vault transformations. That classification is Scope-specific and does not make every file part of Engram. |

### Institution finding

No Engram-internal Institution is established by the inspected revision. Engram is explicitly single-user, and its stable runtime Order is evident, but the stronger requirement—persistence through Roles, Records, Interfaces, and recurring Flows despite changes in participating Agents—is not demonstrated. Calling the application itself an Institution would overstate the evidence.

## Load-bearing relations

### Technical relations

1. A Watch **denotes and maps** one currently bound tmux pane but is not identical with it. The state carries separate watch ID, tmux session name, window ID, pane ID, server ID, lifecycle, and anchor data (`internal/state/state.go:110-163`).
2. A Frame **is produced from** one tmux capture interval. Physical ANSI and joined text are captured in one tmux command batch, with metadata sampled before and after; changed identity or boundary rejects the frame (`internal/tmux/tmux.go:701-774`).
3. A current anchor **represents and permits routing through** one Watch. Two actionable representations of one pane are a product error (`docs/design-principles.md:53-60`). “Permits” here is ordinary project language; the relation is an Interface constraint unless an Organon Permission chain is supplied.
4. An input Transformation **crosses** the Engram/tmux boundary only after current-route and immutable-binding checks. A stale reply fails before the terminal operation (`internal/app/input.go:56-70`), and tmux performs the effect behind the same server/window/pane condition (`internal/tmux/tmux.go:509-561`).
5. A guide rendering **represents** a Frame but does not establish current terminal State. Engram rechecks the current session and conversation boundary before and after model work (`internal/app/refresh.go:238-300`).
6. Persisted State **supports recovery** across service restarts, while raw terminal captures remain process-local or bounded in specific fields. The state schema distinguishes identity, provenance, lifecycle, presentation, anchors, and recovery (`internal/state/state.go:36-57`, `internal/state/state.go:110-163`).

### Institutional relations

1. Configured Telegram user and chat identity define admission to Engram's command Order. Unauthorized messages are rejected before duplicate registration or routing (`internal/app/app.go:436-455`, `internal/app/app.go:553-560`).
2. A current anchor establishes routing eligibility only while its chat/message and terminal binding remain current (`internal/app/input.go:56-70`). This is narrower than general Authority over the pane.
3. A GitHub broker request names the App, installation, repositories, permissions, command or grant duration, purpose, and exact tmux binding (`internal/githubauth/types.go:28-47`). Validation rejects implicit repositories or permissions and bounds renewable authority (`internal/githubauth/types.go:92-171`).
4. Human approval is recorded through a current Telegram approval message; the requesting pane and enrollment are revalidated before the credential is unlocked and token minted (`internal/app/github_auth.go:149-185`).
5. GitHub's returned installation token is checked for exact repository and permission scope; unrequested authority fails (`internal/githubauth/client.go:189-216`). Thus capability is downstream of the admitted scope rather than substituted for it.

### Load-bearing paths

### Causal path: remote input to terminal consequence

The load-bearing path is:

1. Telegram delivers a message from Engram's Environment.
2. The configured user/chat Rule admits or rejects it (`internal/app/app.go:436-447`, `internal/app/app.go:553-560`).
3. For a reply, the Store resolves the Telegram message to the current Watch route (`internal/app/app.go:500-520`).
4. `sendReplyInput` rechecks current-route identity and serializes session/anchor access (`internal/app/input.go:56-70`).
5. `sendInputExpectedLocked` rechecks lifecycle, collapsed state, recovery state, and expected terminal binding before selecting command or text Action (`internal/app/input.go:85-111`).
6. Terminal mechanics place the text or keys behind a tmux-side server/window/pane identity condition (`internal/tmux/tmux.go:509-561`).
7. A successful tmux Transformation is recorded, session activity is updated, and refresh is scheduled (`internal/app/input.go:130-180`).
8. A later capture samples one bounded tmux interval and rejects identity/boundary drift (`internal/tmux/tmux.go:701-774`).
9. The accepted frame feeds either guide or snapshot presentation while remaining subordinate to the terminal capture.

Removing the immutable-binding checks breaks the relation between admitted remote intent and the intended terminal Entity. Removing current-route checks permits stale Representations to cause Action. Removing post-model/current-context checks permits an old Perception to replace a newer view. These joins are load-bearing, not decorative parameters.

### Authority path: pane-bound GitHub capability

The strongest institutional path is:

1. A local requesting Agent constructs a broker request with an exact tmux binding, repositories, permissions, and command or bounded purpose (`internal/githubauth/types.go:28-47`).
2. Request validation rejects missing binding, implicit repository/permission scope, malformed command, or excessive renewable duration (`internal/githubauth/types.go:92-171`).
3. Engram joins the request to one active watched pane and validates its live tmux identity (`internal/app/github_auth.go:273-305`).
4. Engram presents the exact scope to the authorized human through Telegram and records the pending approval (`internal/app/github_auth.go:329-388`).
5. After approval, Engram revalidates the pane and App enrollment before unlocking the encrypted key and minting (`internal/app/github_auth.go:149-210`).
6. GitHub returns a token; Engram verifies exact repository and permission equality and rejects additional authority (`internal/githubauth/client.go:189-216`).
7. Engram records a bounded lease or grant and exposes it only to the child process; expiration, revocation, binding loss, or enrollment change removes its standing in the local Order.

This is a credible project-local authorization path, but it is not yet a refinement of Organon's complete Claim → Declaration/Grant → Admission/Permission → Exercise chain. Agent, Principal, Authority, Admission, and—in the exact-command form—interval are not carried through one typed join; an executed GitHub operation's observed Consequence is also not joined into a portable Receipt. Therefore this candidate does not claim `organon:PermissionClaim`, `organon:Grant`, `organon:Permission`, `organon:PermissionExercise`, or `organon:Receipt` conformance for these local structures.

### Evidence path and its limit

Requirements feed tests; runtime transitions feed audit Records. The requirements say contracts should be tested directly or checked by `make check` (`requirements/INDEX.md:3-24`). Those outputs may support project Claims in ordinary engineering practice. Under Organon, however, repository-owned tests and audit machinery remain within the claimant project's Control. No `IndependentFor` witness or Order-indexed Admission is established. They are Records and Observations candidates, not binding `organon:Evidence` merely because Engram uses the word “evidence.”

## Invariants and prohibited collapses

### Invariants

1. **One current actionable representation.** Each expanded Watch has at most one canonical actionable anchor; known stale routes fail closed (`docs/protocol-posture.md:50-64`).
2. **Immutable target at effect time.** Pane-bound input, capture, and destructive close validate server/window/pane identity immediately before effect (`requirements/tmux.md:29-44`).
3. **One frame, two presentations.** Physical and logical presentations derive from one bounded frame (`docs/protocol-posture.md:50-56`).
4. **Presentation is off the critical authority path.** Model or Chromium delay/failure must not block ordinary guarded input (`docs/design-principles.md:85-101`).
5. **Current tmux capture outranks historical or generated prose.** Historical context cannot establish current files, effects, completion, hashes, or references (`README.md:192-215`).
6. **Uncertain shell effects are not replayed.** A failed or interrupted effect does not license automatic repetition (`docs/protocol-posture.md:50-64`).
7. **Failure does not overstate identity loss.** Generic tmux failure is distinct from proved loss (`requirements/tmux.md:29-44`; `internal/app/input.go:112-128`).
8. **Attention is not command.** Attention records are bounded, deduplicated, untrusted, and never authentication or input authority (`docs/protocol-posture.md:50-64`).
9. **Explicit scope precedes GitHub capability.** Every request names repository and permissions, and the returned token must match them exactly (`internal/githubauth/types.go:112-170`; `internal/githubauth/client.go:189-216`).
10. **State and pane remain distinct.** Persisted identity and observation Records do not become the live terminal Entity.

### Prohibited collapses

- **tmux “source of truth” ≠ `organon:Truth`.** It is the canonical operational Reference for current terminal facts within Engram's Scope. It does not prove correspondence with Reality.
- **Frame ≠ Reality.** A bounded capture is selected Presence; it may omit scrollback, transient state, external processes, and hidden effects.
- **Frame ≠ Observation automatically.** Without Persistence as a Record and a declared Causal-path Specification, the runtime capture is only a Perception-like State.
- **Guide output ≠ Evidence, Truth, or Authority.** It is a model-produced Representation used for presentation and is never executed automatically.
- **Watch ≠ pane.** The Watch maps and governs a pane identity; it can become stale or lost while the pane or other tmux Presence remains.
- **Anchor ≠ Watch ≠ Frame.** The anchor is an Interface, the Watch is a persistent Map/Record, and the Frame is a bounded captured State.
- **Route ≠ Permission.** Being the latest actionable Telegram message does not itself provide Organon's Principal, Grant, Admission, Order, Scope, and interval chain.
- **Technical capability ≠ institutional authority.** Possessing a token or reaching a socket does not substitute for scoped approval; the broker deliberately joins both.
- **Audit Record ≠ Receipt.** A complete Receipt must relate Action, Agent, Authority, Permission, Scope, and observed Consequence.
- **Repository test ≠ independent Evidence.** Claimant-controlled validation lacks the required independent Witness and institutional Admission.
- **Tool ≠ Agent.** A guide model or Chromium renderer participates in Engram's Action path without thereby becoming the Entity whose Interpretation selects the terminal Action.
- **Order ≠ Institution.** The local authorization regime can coordinate Agents without evidence that it persists through changing participants and Roles.
- **Substrate ≠ Reality.** tmux and the filesystem provide scoped input States; neither is the totality of Presence.
- **Public self-description ≠ adoption or production.** Repository prose establishes intended purpose and declared contracts only.

## Organon mappings

| Engram term or mechanism | Organon candidate | Relation | Reason |
| --- | --- | --- | --- |
| tmux pane under server/window/pane binding | `organon:Entity` | refinement | Names an identity criterion and revalidates it across ordered operations; a complete Persistence witness remains partly implicit. |
| pane identity tuple | `organon:Invariant` | refinement | The named tuple is preserved across operations and rejects a Transformation when it changes. |
| Watch | `organon:Map` | refinement | Persistent representation organized for navigation and governance of one pane; it is not its target. |
| Frame / `StyledCapture` | `organon:Sign` | refinement | A Representation causally produced from the target pane State through the tmux capture path. |
| Frame called an “observation” | `organon:Observation` | conflict | Runtime `StyledCapture` is not necessarily a persistent Record and the full causal Specification is not carried in the value. |
| current Telegram anchor | `organon:Interface` | refinement | Explicitly represents permitted coordination Transformations between user and watched pane. |
| route | — | unmapped | Project-local currentness/eligibility predicate; mapping it to Permission would omit the institutional chain. |
| input action | `organon:Action` | refinement | Boundary-crossing Transformation selected through operator/Engram Interpretation. |
| attention record | `organon:Sign` | refinement | Representation causally produced through the PTY; lack of identified claimant blocks Claim. |
| terminal “source of truth” | `organon:Reference` | refinement | Canonical scoped comparison surface for current terminal facts, with bounded omissions. |
| terminal “source of truth” | `organon:Truth` | conflict | Operational precedence does not establish correspondence between a Claim and Reality. |
| requirements contract | `organon:Specification` | refinement | Binding when it supplies executable conformity criteria. |
| validation/routing logic | `organon:Rule` | refinement | Maps conforming inputs to admitted/rejected outputs and guarded effects. |
| capture bounds, identity checks, redaction, limits | `organon:Constraint` | refinement | Persistently exclude unsafe or ambiguous Transformations while allowing specified ones. |
| state entry / audit event | `organon:Record` | refinement | Persistent representation of earlier State, Relation, or Change. |
| audit event as “receipt” | `organon:Receipt` | conflict | Required Permission, Authority, Scope, and observed Consequence joins are not all present. |
| repository-owned test result | `organon:Evidence` | conflict | No independent Witness or Order-indexed Admission is established. |
| authorized human | `organon:Agent` | exact | Entity whose Interpretation selects Telegram Actions. |
| Engram runtime | `organon:Agent` | unmapped | Its Rules select effects, but no complete installation-level Entity identity and Persistence witness is declared yet. |
| guide model | `organon:Tool` | unmapped | It is incorporated into presentation, but the configured provider/model Entity identity criterion is not carried by the project. |
| tmux | `organon:Substrate` | refinement | Persistent scoped source of input States for capture and terminal-effect Transformations. |
| one Watch's accessible terminal domain | `organon:World` | refinement | Scoped Configuration of States, Relations, causal paths, Perceptions, and Actions available through named Constraints. |
| GitHub broker request | `organon:Claim` | refinement | A requesting Agent asserts a scoped request about prospective Actions; the local request is structurally explicit and inspectable. |
| GitHub broker request as Permission Claim | `organon:PermissionClaim` | conflict | The exact-command form does not carry a stated interval, and neither form explicitly carries named Agent, Principal, or Order. |
| approved renewable GitHub envelope as Grant | `organon:Grant` | conflict | The approval Action does not formally carry the declarant's Authority over the represented Principal, Agent, Scope, and interval. |
| GitHub lease or grant record as Permission | `organon:Permission` | conflict | It does not carry the complete Order, Principal, Agent, Grant, and Admission chain required by Organon. |
| Engram authorization regime | `organon:Order` | refinement | Persistent Constraints, Records, Interfaces, and Rules coordinate multiple Agents' actions. |
| Engram application as institution | `organon:Institution` | unmapped | Participant-replacement persistence is not demonstrated. |
| terminal mechanics, state store, GitHub broker | `organon:Organ` | unmapped | They are specialized recurring Configurations, but Organ requires a demonstrated larger Entity or Institution and Persistence for each subsystem. |

## Boundary cases

| Neighbor | Strongest positive example | Strongest negative example | Hard boundary case |
| --- | --- | --- | --- |
| Entity | A tmux pane tracked by immutable server/window/pane identity across validated operations | A single ephemeral frame | A Watch: it persists, but as a Map/Record *about* the pane rather than the pane itself. |
| Agent | The authorized human selecting a reply; the Engram runtime selecting guarded effects | Chromium rendering deterministic pixels | An interactive shell process: it is an Agent only if an Interpretation in that Entity conditions Action, not merely because it executes commands. |
| Tool | Guide provider used for presentation; Chromium used for rendering | The operator | tmux: Tool relative to operator Action, Substrate relative to Engram's capture/input transformations. |
| Organ | Runtime terminal-mechanics subsystem performing repeated guarded operations for Engram | External tmux server | GitHub broker: an Organ if the enclosing installation is an Entity; otherwise only a specialized Configuration. |
| Institution | No Engram-internal positive case is established | One running single-user Engram process | The authorization regime is clearly an Order, but participant-change persistence needed for Institution is not demonstrated. |
| World | One Watch's bounded frame, references, current route, and reachable terminal Actions | Reality as a whole | The whole local host: much of it is unavailable to Engram Perception or Action and therefore lies outside that World. |
| Environment | tmux, filesystem, Telegram, and providers outside a narrowly drawn Engram runtime boundary | Engram's in-process State structures | A model provider is Environment generally and Tool only while incorporated into a particular presentation path. |
| Substrate | tmux as persistent source of terminal States for capture and input | Guide prose | Filesystem: substrate for persistent state and attachments, but not for the terminal frame unless a named path feeds it. |
| Interface | Current Telegram anchor with represented controls | An inert historical message | Collapsed shelf: Interface for restoration but deliberately not for terminal input. |
| Record | Persisted Watch identity and lifecycle state | Live unpersisted frame | Audit JSON that records an attempted action but cannot establish its consequence. |
| Permission | A fully joined, approved, scoped GitHub grant would qualify | A token-shaped string | Current implementation strongly approximates Permission but leaves Principal and Admission implicit in separate code paths. |
| Evidence | Independently admitted observation—none established here | Claimant-owned passing unit test alone | Hosted CI may be mechanically separate, but independence, governing Order, Admission Rule, and scope must be declared before it qualifies. |

## Uncertainties and promotion gates

1. **Engram Entity identity.** Declare the installation's object-language identity Invariant across process, binary version, configuration, `ENGRAM_HOME`, Telegram identity, and restart; identify which changes preserve or replace it.
2. **Frame typing.** Decide whether a Frame is intentionally ephemeral Perception or should become a persistent Observation. If the latter, carry the capture Causal-path Specification and Persistence witness.
3. **Watch mapping.** Enumerate the Map's Scope, omissions, and distortions. This would permit promotion from Map candidate toward Reference.
4. **Order and Principal.** Make explicit which Principal grants GitHub authority: the human operator, GitHub App owner, installation account, or a joined institutional configuration.
5. **Admission seam.** Identify the exact Rule and Record by which a Telegram approval counts as Admission of the Permission Claim.
6. **Permission exercise and receipt.** Join the minted lease to the exact child Action and an observed Consequence without treating child exit alone as Truth.
7. **Independent evidence.** If hosted CI or external review is to count as Evidence, declare Witness independence, Admissibility Rule, Order, Scope, and evaluation disposition.
8. **Organ classification.** Confirm which runtime subsystem configurations have identity and Persistence, rather than calling Go packages Organs by lexical convenience.
9. **World boundary.** Name whether the relevant World belongs to the human operator, Engram Agent, or both; their available States and Actions differ.
10. **Institution boundary.** Do not promote Engram to Institution until it demonstrates persistence through changes of participating Agents and Roles.
11. **Truth terminology.** Keep “tmux is the source of terminal truth” as project idiom or map it explicitly to scoped Reference/canonical-system authority, never automatically to `organon:Truth`.
12. **No production inference.** Add deployment or adoption claims only with evidence external to repository self-description.

### Machine-consumable mapping

<!-- organon:mapping-manifest -->
```yaml
schema_version: 1
project: Engram
commit: 645c76c624cbb6e21f9d4187b3fc093f36b6cf38
mappings:
  - local_term: tmux-pane
    organon_id: organon:Entity
    classification: refinement
    evidence: ["internal/tmux/tmux.go:92-103", "requirements/tmux.md:29-44"]
  - local_term: pane-identity
    organon_id: organon:Invariant
    classification: refinement
    evidence: ["internal/state/state.go:110-120", "internal/app/input.go:99-111"]
  - local_term: watch
    organon_id: organon:Map
    classification: refinement
    evidence: ["docs/protocol-posture.md:33-37", "internal/state/state.go:110-163"]
  - local_term: frame
    organon_id: organon:Sign
    classification: refinement
    evidence: ["docs/protocol-posture.md:36-38", "internal/tmux/tmux.go:701-774"]
  - local_term: frame-as-observation
    organon_id: organon:Observation
    classification: conflict
    evidence: ["internal/tmux/tmux.go:105-122", "internal/tmux/tmux.go:701-774"]
  - local_term: canonical-anchor
    organon_id: organon:Interface
    classification: refinement
    evidence: ["docs/design-principles.md:53-60"]
  - local_term: route
    organon_id: null
    classification: unmapped
    evidence: ["docs/protocol-posture.md:39-45"]
  - local_term: input-action
    organon_id: organon:Action
    classification: refinement
    evidence: ["internal/app/input.go:56-70", "internal/tmux/tmux.go:509-561"]
  - local_term: attention-record
    organon_id: organon:Sign
    classification: refinement
    evidence: ["docs/protocol-posture.md:44-45", "docs/protocol-posture.md:77-85"]
  - local_term: terminal-source-of-truth
    organon_id: organon:Reference
    classification: refinement
    evidence: ["docs/design-principles.md:39-51"]
  - local_term: terminal-source-of-truth-as-Truth
    organon_id: organon:Truth
    classification: conflict
    evidence: ["docs/design-principles.md:39-44", "docs/design-principles.md:215-234"]
  - local_term: requirements-contract
    organon_id: organon:Specification
    classification: refinement
    evidence: ["requirements/INDEX.md:3-24"]
  - local_term: capture-and-routing-guards
    organon_id: organon:Constraint
    classification: refinement
    evidence: ["requirements/tmux.md:29-44", "internal/tmux/tmux.go:679-698"]
  - local_term: state-or-audit-entry
    organon_id: organon:Record
    classification: refinement
    evidence: ["internal/state/state.go:36-57", "internal/app/input.go:112-161"]
  - local_term: repository-owned-test-as-evidence
    organon_id: organon:Evidence
    classification: conflict
    evidence: ["requirements/INDEX.md:18-27"]
  - local_term: authorized-human
    organon_id: organon:Agent
    classification: exact
    evidence: ["requirements/security.md:7-14", "internal/app/app.go:553-560"]
  - local_term: guide-model
    organon_id: null
    classification: unmapped
    evidence: ["docs/design-principles.md:229-234"]
  - local_term: tmux
    organon_id: organon:Substrate
    classification: refinement
    evidence: ["README.md:16-18", "docs/design-principles.md:39-51"]
  - local_term: watch-accessible-domain
    organon_id: organon:World
    classification: refinement
    evidence: ["docs/protocol-posture.md:17-29", "docs/protocol-posture.md:31-48"]
  - local_term: github-capability-request
    organon_id: organon:Claim
    classification: refinement
    evidence: ["internal/githubauth/types.go:28-47", "internal/githubauth/types.go:92-171"]
  - local_term: github-capability-request-as-permission-claim
    organon_id: organon:PermissionClaim
    classification: conflict
    evidence: ["internal/githubauth/types.go:28-47", "internal/githubauth/types.go:92-171"]
  - local_term: approved-renewable-envelope
    organon_id: organon:Grant
    classification: conflict
    evidence: ["internal/app/github_auth.go:329-388", "internal/app/github_grant.go:69-96"]
  - local_term: github-lease-or-grant
    organon_id: organon:Permission
    classification: conflict
    evidence: ["internal/githubauth/types.go:49-68", "internal/app/github_auth.go:149-210"]
  - local_term: authorization-regime
    organon_id: organon:Order
    classification: refinement
    evidence: ["requirements/security.md:7-36", "internal/app/github_auth.go:83-185"]
  - local_term: engram-as-institution
    organon_id: null
    classification: unmapped
    evidence: ["README.md:11-18", "requirements/security.md:7-14"]
  - local_term: terminal-mechanics-subsystem
    organon_id: null
    classification: unmapped
    evidence: ["requirements/tmux.md:38-40", "internal/tmux/tmux.go:509-561"]
causal_paths:
  - id: remote-input-to-terminal-effect
    stages:
      - telegram-update
      - user-chat-admission
      - current-route-resolution
      - immutable-binding-validation
      - tmux-input-transformation
      - state-and-audit-record
      - bounded-recapture
      - canonical-presentation
    evidence:
      - "internal/app/app.go:436-455"
      - "internal/app/input.go:56-180"
      - "internal/tmux/tmux.go:509-561"
      - "internal/tmux/tmux.go:701-774"
authority_paths:
  - id: pane-bound-github-capability
    stages:
      - scoped-request
      - binding-validation
      - telegram-approval
      - binding-and-enrollment-revalidation
      - token-mint
      - exact-scope-validation
      - bounded-lease
    evidence:
      - "internal/githubauth/types.go:92-171"
      - "internal/app/github_auth.go:149-210"
      - "internal/app/github_auth.go:273-388"
      - "internal/githubauth/client.go:189-216"
promotion_gates:
  - installation-identity-invariant
  - persistent-frame-observation-or-explicitly-ephemeral-perception
  - explicit-principal-and-admission
  - exercise-to-consequence-receipt
  - independent-evidence-order
  - participant-persistence-before-institution
```

## Consistency result

This candidate is internally consistent with Organon v0.17 under the stated Scopes if its “candidate” qualifications remain binding. Its core classifications do not require `organon:Truth`, `organon:Evidence`, `organon:Permission`, or `organon:Institution` to be inferred from Engram's ordinary vocabulary. The strongest result is the joined causal and authority architecture: representations become actionable only through currentness, identity, scope, and admission checks; generated presentation never substitutes for those relations.

The largest unresolved question is Entity identity for the Engram installation itself. Until an installation-level Invariant and Persistence witness are declared, downstream Organ classifications remain conditional. That uncertainty does not affect the pane, frame, anchor, routing, or GitHub authorization distinctions above.
