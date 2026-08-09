---
project: Engram
repository: https://github.com/idolum-ai/engram
branch: main
commit: 1b56983ac658f10bfbd76c44bfc99c20b1355ebe
organon_version: 0.18.0
status: generated-candidate
---
# Engram project ontology

## Scope and nonclaims

This candidate describes Engram at repository `https://github.com/idolum-ai/engram`, branch `main`, commit `1b56983ac658f10bfbd76c44bfc99c20b1355ebe`. It covers the single-user Telegram-to-tmux control surface, its local state and presentation mechanisms, its guarded input path, and the included GitHub credential broker.

The source snapshot contains project descriptions, design rules, requirements, and implementation excerpts. They do not all carry the same force. Code excerpts show mechanisms present in the pinned tree. Requirements describe intended runtime contracts and call themselves binding for implementation (`requirements/INDEX.md:1-27`); that is a repository-governance claim, not proof that every contract is satisfied. Design claims such as safe, trusted, durable, or source of truth are preserved as local language and are not promoted into Organon security, Trust, Truth, Evidence, adoption, completion, or institutional Authority.

This document does not claim:

- that Engram adopts Organon merely because this external candidate maps some terms;
- that the repository is secure, private, correct, complete, deployed, or widely used;
- that tests or checks passed at the pinned commit;
- that tmux or any stored record is Reality or semantic Truth;
- that a frame, audit entry, model response, requirement, or source excerpt is independent Evidence;
- that Telegram authorization or a GitHub approval establishes Organon Permission or Authority;
- that a model summary faithfully represents terminal state; or
- that a successful send, capture, approval, or token request occurred outside the cited source mechanisms.

## Project purpose

Engram describes itself as a single-user Telegram control surface for local tmux sessions. It creates or attaches to tmux windows, routes Telegram messages into panes, and presents each pane through a stable pinned Telegram anchor (`README.md:9-31`). The project treats tmux, rather than Engram, as the durable workspace. Engram's stated contribution is a handle for a watched pane, a bounded capture, a stable current view able to route a reply, and conservative recovery when intermediate work fails (`docs/protocol-posture.md:15-66`).

Two presentation choices are described. Guide mode sends bounded terminal text to a configured model and returns compact prose; the project explicitly warns that the model can misunderstand the pane. Snapshot mode renders a bounded terminal frame locally with Chromium and uploads the resulting image to Telegram. The snapshot remains accompanied by literal raw text (`README.md:9-31`, `docs/design-principles.md:67-103`). These are presentation paths over the same tmux workspace, not alternate sources of terminal state.

The principal operational objective is orientation and a safe next input across multiple panes. Ordinary input is intended to remain independent of delays or failures in model, browser, or presentation work (`docs/design-principles.md:67-103`).

## Local vocabulary

The following terms retain Engram's own meanings before any Organon correspondence is considered.

| Local term | Engram-local meaning | Source |
| --- | --- | --- |
| tmux workspace | The terminal workspace Engram attaches to, captures, and sends input into. Engram says it should not emulate terminal state. | `docs/design-principles.md:37-62` |
| pane identity | In the protocol prose, the immutable `%pane_id` and `@window_id` pair validated at effect time. | `docs/protocol-posture.md:15-66` |
| validated terminal binding | The implementation-level server incarnation, window ID, and pane ID checked before pane-bound operations. This is deliberately narrower and stronger than relying on a mutable index. | `requirements/tmux.md:27-46`, `internal/tmux/tmux.go:507-563` |
| watch | A local record binding an Engram session ID to pane identity, provenance, lifecycle, and observation state. It is explicitly not a tmux session. | `docs/protocol-posture.md:15-66` |
| frame | One bounded physical ANSI capture and joined logical capture over shared coordinates. | `docs/protocol-posture.md:15-66`, `internal/tmux/tmux.go:677-776` |
| current view | The one canonical presentation for a watch in the selected frontend. | `docs/protocol-posture.md:15-66` |
| anchor | The editable and normally pinned Telegram message that identifies a session, presents its pane, and exposes controls. An expanded session is intended to have one canonical anchor. | `docs/design-principles.md:37-62` |
| route | A current view or latest alternate that may request input for its watch. A superseded route is stale and must not route input. | `docs/protocol-posture.md:15-66` |
| shelf | A shared pinned presentation for collapsed sessions. Its status lines are cached, and it is not an input route. | `docs/design-principles.md:67-103` |
| input action | Command plus Enter, literal text without Enter, or validated keys. These kinds remain distinct. | `docs/protocol-posture.md:15-66` |
| attention record | A bounded, terminal-authored request to look, carrying a random deduplication ID but no sender identity. It is one-way, best effort, and untrusted. | `docs/protocol-posture.md:15-66`, `docs/protocol-posture.md:75-87` |
| guide presentation | Model-produced prose derived from bounded terminal text. It is presentation, may misunderstand the pane, and is not executed automatically. | `README.md:9-31`, `docs/design-principles.md:213-236` |
| snapshot presentation | A locally rendered image of the bounded terminal frame, with literal raw text available separately. | `README.md:9-31`, `docs/design-principles.md:67-103` |
| GitHub approval | A pending broker interaction presented through Telegram and resolved, denied, canceled, expired, or invalidated before token minting or grant creation. | `internal/app/github_auth.go:63-212`, `internal/app/github_auth.go:271-390` |
| GitHub grant | A stored renewable local mechanism containing a binding, enrolled application information, repository and permission scopes, purpose, creation time, and expiry. | `internal/app/github_grant.go:67-98`, `internal/githubauth/types.go:26-70` |
| lease | A bounded token result associated with an application, installation, repository set, permission set, expiry, and optionally a local grant ID. | `internal/githubauth/types.go:26-70` |

The pane terminology contains a source-visible seam. The protocol's irreducible noun names a pane/window pair, while requirements and implementation guard effects with a server/window/pane triple. This candidate maps only the validated triple. It does not silently rewrite the protocol noun.

## Participants and worlds

The operational participants are:

- the configured Telegram user and configured Telegram chat;
- Telegram as the external message and delivery service;
- the Engram process, its configuration, scheduler, local state, and audit output;
- the tmux server, windows, panes, foreground processes, and terminal content;
- optional guide providers receiving bounded text;
- optional local Chromium used for snapshot rendering;
- the local GitHub broker client and Engram broker endpoint;
- enrolled GitHub Apps and the GitHub token API; and
- child commands that may receive a validated installation token.

The main local boundaries are concrete mechanism boundaries rather than assumed institutional ones:

1. **Telegram admission boundary.** A message must match both configured chat ID and configured user ID before ordinary handling (`internal/app/app.go:434-457`, `internal/app/app.go:551-562`).
2. **Current-route boundary.** A reply must resolve to a current target. A known stale target produces a stale response rather than pane input (`internal/app/app.go:498-522`).
3. **Terminal-mechanics boundary.** Pane-bound effects are routed through mechanics that validate the terminal binding immediately before the tmux operation (`requirements/tmux.md:27-46`).
4. **Presentation boundary.** Bounded pane content may be rendered literally or sent to a guide provider. Presentation output is kept off the ordinary input critical path (`docs/design-principles.md:67-103`).
5. **Persistence boundary.** Local state under `~/.engram` is intended to recover sessions, anchors, shelf membership, selected mode, attachments, poll position, and recent errors after restart (`docs/design-principles.md:269-278`).
6. **GitHub broker boundary.** A broker request carries a terminal binding and explicit application, installation, repository, permission, command or grant fields. Binding, enrollment, approval continuation, expiry, and token scope are checked at different stages (`internal/githubauth/types.go:26-70`, `internal/app/github_auth.go:63-212`).

These participants and boundaries do not yet form a promoted `organon:World`. The dossier does not provide one complete packet naming participating Entities, their identity witnesses, selected Environments, available causal paths, common Invariant, Constraints, and Scope.

## Load-bearing relations

### Message admission and deduplication

`handleUpdate` distinguishes callback updates, missing messages, unauthorized messages, and already processed messages before later routing (`internal/app/app.go:434-457`). Authorization compares the incoming chat and sender IDs with configured values (`internal/app/app.go:551-562`). This is a local admission predicate. It is not, without an institutional packet, Organon Standing, Recognition, Permission, or Authority.

### Capture and presentation

A styled capture reads metadata, captures physical ANSI and joined logical buffers, reads metadata again, and rejects identity or boundary changes observed across the operation. The returned frame carries physical text, joined text, hyperlinks, and pane metadata (`internal/tmux/tmux.go:677-776`). Guide generation later checks that the session and context remain current before and, for contextual paths, after model work; returned prose is redacted (`internal/app/refresh.go:236-302`).

The frame is the local basis for presentation. A guide summary is a transformation of bounded text, while a snapshot is a literal rendering path. Neither presentation is silently promoted to terminal fact, Truth, or Evidence.

### Current and stale routing

A current view or latest eligible alternate may route input. Older alternates are stale. The store lookup in the reply path distinguishes current and stale targets, and the input function repeats current-target and terminal-binding checks while holding session and anchor locks (`internal/app/app.go:498-522`, `internal/app/input.go:54-182`). The repeated check matters because a message that was once current may become stale before the effect.

### Guarded input

For a reply to a current anchor, Engram prepares typed input and calls the reply-input path. That path reacquires the current target, compares the terminal binding, rejects closed, collapsed, recovering, or changed sessions, and invokes terminal mechanics. The tmux layer uses a binding-conditioned command before text or keys are applied (`internal/app/input.go:54-182`, `internal/tmux/tmux.go:507-563`).

A successful tmux effect can precede a failed local state update. The code reports that condition rather than proving rollback (`internal/app/input.go:54-182`). Consequently, a returned failure status does not always establish that no terminal effect occurred.

### Anchor replacement and collapse

Anchor migration records and exposes a successor before retiring a predecessor where the external medium permits. During collapse, the individual anchor remains canonical until the shared shelf is rendered and pinned. During restoration, prospective anchors become durable and pinned while inert before controls are granted; failure returns the member to the shelf (`docs/design-principles.md:67-103`). These are ordered handoff rules intended to avoid two actionable representations or no recoverable representation.

### GitHub approval, grants, and token scope

A broker request first validates its terminal binding against an active watched session. It then reloads enrolled application information, checks local-unlock requirements, creates a bounded pending approval, sends that approval through Telegram, and waits for approval, cancellation, expiry, or denial. Before unlocking and minting, Engram revalidates the terminal continuation and enrollment (`internal/app/github_auth.go:63-212`, `internal/app/github_auth.go:271-390`).

Renewable local grants store repository, permission, purpose, and interval fields and trigger revocation of replaced leases (`internal/app/github_grant.go:67-98`). Token responses are compared with requested repositories and permissions, with only GitHub's metadata-read addition tolerated (`internal/githubauth/client.go:187-218`). This is a scoped technical credential path. The dossier does not establish the institutional joins required by Organon Grant, Permission, or Authority.

### Local evidence paths

The repository uses words such as observation, evidence, audit evidence, trusted, and source of truth. Locally, these distinguish captures, model-returned supporting material, audit records, deterministic local values, and normative requirements. None is promoted to `organon:Evidence` in this candidate. That promotion would require an Observation, a distinct Witness, scoped independence from the claimant, a governing Order, an Admissibility Rule, and Admission. The source snapshot supplies no complete instance of that chain.

## Invariants and prohibited collapses

The project states or implements the following load-bearing invariants:

1. Pane-bound effects validate the stored server, window, and pane identifiers; generic failure alone does not prove identity loss (`requirements/tmux.md:27-46`).
2. Input kinds remain distinct, and presentation work does not block their critical path (`docs/protocol-posture.md:15-66`).
3. Physical and logical presentations derive from one bounded frame (`docs/protocol-posture.md:15-66`).
4. A watch has at most one actionable current view per selected frontend (`docs/protocol-posture.md:15-66`).
5. Only the latest route of each alternate kind may act; known stale routes fail closed (`docs/protocol-posture.md:15-66`).
6. Replacement records a successor before retiring its predecessor where the external medium permits (`docs/protocol-posture.md:15-66`).
7. Attention records remain bounded, deduplicated, terminal-authored, best effort, and untrusted; they do not become commands or authentication (`docs/protocol-posture.md:15-66`).
8. Uncertain shell effects are not replayed after restart, and presentation failure does not establish pane loss (`docs/protocol-posture.md:15-66`).

The corresponding prohibited collapses are:

- a mutable pane index is not the validated terminal binding;
- a watch is not its tmux session or pane;
- a current view is not the frame or pane it presents;
- a cached shelf line is not a current observation and cannot route input;
- guide prose is not literal terminal state and model output is not executable authority;
- terminal-authored content is data, not authorization for Engram (`docs/design-principles.md:213-236`);
- an authorization predicate is not Organon Authority;
- GitHub approval is not automatically an Organon Admission or Grant;
- a token is not proof of the requesting Agent's Capability in every environment;
- an audit record, test, requirement, or model-returned evidence item is not independent Evidence;
- local source-of-truth wording is not Organon Truth; and
- repository self-description is not adoption, effectiveness, completion, or security certification.

## Organon mappings

No exact correspondence is promoted. The six promoted mappings are refinements: each local mechanism satisfies a narrower, source-backed instance of an Organon term and adds project-specific restrictions. Other correspondences are conflicts or remain unmapped.

| Local term or mechanism | Organon target | Classification | Reason |
| --- | --- | --- | --- |
| validated terminal binding | `organon:Invariant` | refinement | The server/window/pane triple is named as preserved and rechecked across pane-bound operations. |
| watch | `organon:Record` | refinement | A persisted watch represents earlier sampled binding, lifecycle, and terminal-session state. |
| frame | `organon:State` | refinement | It is a bounded configuration indexed to one capture occurrence and shared coordinates. |
| current view | `organon:Representation` | refinement | The Telegram presentation occupies an expression position directed at a watch and bounded frame. |
| current-route validity relation | `organon:Constraint` | refinement | It persists while a route is current, permits current-route input transformations, and excludes known stale ones. |
| guarded reply-input chain | `organon:CausalPath` | refinement | Ordered handling, target validation, and tmux-send transformations feed one another toward a pane-bound effect. |
| tmux workspace | `organon:Substrate` | unmapped | Durable-workspace language does not itself supply the required Feeds and transformation-family packet. |
| terminal truth and requirements source of truth | `organon:Truth` | conflict | The local phrases mean operational or normative primacy, not scoped semantic material adequacy. |
| frame described as observation | `organon:Observation` | unmapped | The complete Entity, Sense, causal-production Specification, and Record packet is absent. |
| audit or guide evidence | `organon:Evidence` | unmapped | Independence, Order, Admissibility Rule, and Admission are not established. |
| configured authorization and approval | `organon:Authority` | unmapped | A configuration check or user confirmation does not supply an Order-indexed Authority relation. |
| GitHub grant | `organon:Grant` | conflict | The local object is a renewable credential mechanism, not the defined authorized Declaration. |
| GitHub lease or token | `organon:Capability` | unmapped | Scope validation does not by itself construct an Agent-level action-producing witness. |
| attention record | `organon:Claim` | unmapped | It intentionally lacks sender identity and is not authenticated as an Agent's assertion. |
| current view as coordination surface | `organon:Interface` | unmapped | The required Entity identities, Boundary, and represented permitted transformations are incomplete. |

### Promoted dependency packets

The mapping manifest is authoritative for dependency closure. In summary:

- The terminal-binding packet names the preserved triple and the input, capture, lookup, scrollback, and close transformation family.
- The watch packet distinguishes the serialized representation from its pane and sampled-state targets and names update, save, reload, and recovery transformations.
- The frame packet treats one capture occurrence as its ordering index; it does not turn the frame into an Observation.
- The current-view packet names the Telegram anchor content as expression and the watch plus bounded frame as target; Denotation supplies neither fidelity nor Truth.
- The route-constraint packet names current and stale route states and the excluded stale-input transformation.
- The guarded-input packet names ordered states, the values feeding each next state, and the shared direction toward an attempted pane-bound effect.

## Boundary cases

- **Protocol pair versus guarded triple.** The protocol calls pane/window IDs pane identity, while implementation requirements add server incarnation. The promoted Invariant is the validated triple, not the narrower phrase (`docs/protocol-posture.md:15-66`, `requirements/tmux.md:27-46`).
- **Text before Enter.** A restart between text insertion and Enter can leave text unsubmitted, although the binding condition prevents redirecting either effect into a different server (`internal/tmux/tmux.go:507-563`). The command path is guarded but not represented as one indivisible effect.
- **Effect before state update.** tmux input may succeed before Engram fails to update local state. The resulting status is not proof of no effect (`internal/app/input.go:54-182`).
- **Collapsed sessions.** Hiding a session stops observation; the shelf therefore labels summaries as cached and cannot accept terminal input (`docs/design-principles.md:67-103`).
- **Retiring anchors.** A message that still exists but cannot be edited remains owned until its controls and pin are retired. Existence alone does not make it current or actionable (`docs/design-principles.md:67-103`).
- **Model context.** Historical transcript text may orient a guide but is not accepted as the current terminal state. Missing, changed, ambiguous, or unfamiliar bindings fail closed to terminal-only guidance (`README.md:190-217`).
- **Attention records.** Their random IDs deduplicate records but do not identify a sender, authenticate a command, or grant routing authority (`docs/protocol-posture.md:75-87`).
- **GitHub approval invalidation.** Approval can be canceled when the requesting pane identity or enrolled application changes before completion (`internal/app/github_auth.go:63-212`).
- **Token scope validation.** Matching repository and permission fields supports technical scope checking but does not prove institutional legitimacy, safe command behavior, or successful GitHub action (`internal/githubauth/client.go:187-218`).
- **Best-effort redaction.** Requirements explicitly say redaction is best effort and does not make an artifact safe to share without review (`requirements/security.md:5-38`).

## Uncertainties and promotion gates

A later review should reopen this candidate when any of the following changes:

- pane identity ceases to use the server/window/pane triple or gains another incarnation identifier;
- the protocol's pair terminology is reconciled with implementation requirements;
- route eligibility, stale-route handling, or the one-actionable-view rule changes;
- the order of anchor promotion and predecessor retirement changes;
- collapsed shelves become input routes or continue observing hidden sessions;
- the tmux send path changes its identity check, buffering, or Enter sequencing;
- frame capture no longer brackets content with identity and boundary checks;
- guide context begins to influence ordinary input or is treated as current terminal fact;
- local persistence no longer recovers watches and anchors across restart;
- GitHub approvals, grants, leases, revocation, or token-scope validation change; or
- requirements or tests are presented as external certification rather than repository controls.

Promotion gates remain explicit:

1. Map tmux to `organon:Substrate` only after naming persistent input States, Feeds, contributing Constraints, and the exact family of Transformations.
2. Map frame to `organon:Observation` only after identifying an observing Entity, identity Invariant, Boundary, Sense, Environment, production Causal path, constructive Specification, and persistent Record.
3. Map audit or guide material to `organon:Evidence` only after identifying the claimant, distinct Witness, Observation, mechanical and institutional independence, Order, Admissibility Rule, Admission, and Scope.
4. Map Telegram or GitHub approval to institutional terms only after identifying an Order, Standing, Principal, Authority, Permission Claim, authorized Declaration, Grant, Admission, and resulting Permission Record.
5. Map a token or lease to `organon:Capability` only after identifying the Agent, Action scope, environmental and technical Constraints, and a constructive satisfying configuration with an action-producing path.
6. Map the current view to `organon:Interface` only after supplying identity and persistence packets for the coordinating Entities and the Boundary whose permitted transformations are represented.

<!-- organon:mapping-manifest -->
```yaml
schema_version: 1
project: Engram
commit: 1b56983ac658f10bfbd76c44bfc99c20b1355ebe
mappings:
  - local_term: validated terminal binding
    organon_id: organon:Invariant
    classification: refinement
    evidence:
      - requirements/tmux.md:27-46
      - internal/tmux/tmux.go:507-563
      - internal/tmux/tmux.go:677-776
    rationale: 'The exact server, window, and pane identifiers are named as preserved and are revalidated across a specified family of pane-bound operations.'
    dependency_packet:
      organon_claim: D011
      scope: 'One watched pane binding during input, capture, cwd lookup, scrollback, or destructive close.'
      dependency_closure:
        - organon:Presence
        - organon:Relation
        - organon:Configuration
        - organon:State
        - organon:Direction
        - organon:Transformation
      dependency_witnesses:
        organon:Presence: 'The stored server, window, and pane identifier values and effect-time sampled values.'
        organon:Relation: 'Exact equality between each stored identifier and its effect-time counterpart.'
        organon:Configuration: 'The server ID, window ID, and pane ID considered together as one terminal binding.'
        organon:State: 'The stored watch configuration and the effect-time tmux configuration.'
        organon:Direction: 'The order from pre-effect identity validation toward the attempted pane-bound operation.'
        organon:Transformation: 'Input, capture, cwd lookup, scrollback, and destructive-close operations guarded by the binding.'
      target_witness:
        preserved: 'Exact server ID, window ID, and pane ID equality.'
        across_transformations: 'Pane-bound input, capture, cwd lookup, scrollback, and destructive close.'
      exclusions:
        - 'Mutable indexes are not identity witnesses.'
        - 'Generic command failure does not prove that the preserved binding was lost.'

  - local_term: watch
    organon_id: organon:Record
    classification: refinement
    evidence:
      - docs/protocol-posture.md:15-66
      - docs/design-principles.md:269-278
      - internal/state/state.go:34-59
      - internal/state/state.go:108-165
      - internal/state/state.go:368-398
    rationale: 'A persisted watch is a project-specific Record of previously sampled terminal binding, lifecycle, presentation, and activity state.'
    dependency_packet:
      organon_claim: D028
      scope: 'A serialized TerminalSession watch across local updates, saves, reloads, and restart recovery.'
      dependency_closure:
        - organon:Presence
        - organon:Reality
        - organon:Difference
        - organon:Relation
        - organon:Denotation
        - organon:Configuration
        - organon:State
        - organon:Direction
        - organon:Transformation
        - organon:Change
        - organon:Invariant
        - organon:Persistence
        - organon:Representation
      dependency_witnesses:
        organon:Presence: 'The serialized watch fields and their stored values.'
        organon:Reality: 'The actual tmux and Engram configurations sampled within this project scope, without identifying them with Reality as a whole.'
        organon:Difference: 'Changed lifecycle, activity, capture, presentation, anchor, or recovery fields between stored positions.'
        organon:Relation: 'The stored association among Engram session ID, terminal binding, lifecycle fields, and presentation fields.'
        organon:Denotation: 'Watch fields occupy the expression position and target the sampled pane binding and session state they record.'
        organon:Configuration: 'The TerminalSession fields considered together as one watch record.'
        organon:State: 'Each saved or loaded watch configuration indexed by its update or persistence position.'
        organon:Direction: 'The order from an earlier sampled configuration to its later stored or recovered configuration.'
        organon:Transformation: 'Watch update, state save, state load, pruning, and restart-recovery operations.'
        organon:Change: 'Differences in stored watch fields joined by those update and persistence transformations.'
        organon:Invariant: 'The watch identity and validated terminal-binding fields preserved while the watch remains attached to the same pane incarnation.'
        organon:Persistence: 'Serialization and restart recovery preserve the watch representation across ordered local states.'
        organon:Representation: 'The watch fields represent the sampled binding, lifecycle, observation, anchor, and presentation state.'
      target_witness:
        earlier_target: 'The tmux binding and Engram session condition sampled before the corresponding state was stored.'
        persistent_representation: 'The serialized TerminalSession entry recoverable from local state.'
      exclusions:
        - 'The watch is not the tmux session, pane, or current terminal state itself.'
        - 'Persistence of the watch does not prove that its represented pane still exists.'

  - local_term: frame
    organon_id: organon:State
    classification: refinement
    evidence:
      - docs/protocol-posture.md:15-66
      - internal/tmux/tmux.go:677-776
    rationale: 'One frame is a bounded configuration of physical ANSI, joined logical text, shared coordinates, and pane metadata indexed to one capture occurrence.'
    dependency_packet:
      organon_claim: D005
      scope: 'One completed bounded styled-capture occurrence.'
      dependency_closure:
        - organon:Presence
        - organon:Relation
        - organon:Configuration
      dependency_witnesses:
        organon:Presence: 'Captured ANSI, physical text, joined text, hyperlinks, and pane metadata.'
        organon:Relation: 'The association of physical and logical captures with shared coordinates and the same validated pane identity.'
        organon:Configuration: 'The returned StyledCapture fields considered together.'
      target_witness:
        ordering_index: 'The individual capture occurrence bracketed by before and after metadata reads.'
        indexed_configuration: 'The bounded StyledCapture returned after identity and capture-boundary checks.'
      exclusions:
        - 'The frame is not promoted to organon:Observation.'
        - 'The frame is not the pane or Reality.'

  - local_term: current view
    organon_id: organon:Representation
    classification: refinement
    evidence:
      - README.md:9-31
      - docs/design-principles.md:37-62
      - docs/protocol-posture.md:15-66
    rationale: 'The current Telegram view is a project-specific expression directed at a watch and its bounded presented frame.'
    dependency_packet:
      organon_claim: D017
      scope: 'The one canonical Telegram presentation for a watch in the selected frontend.'
      dependency_closure:
        - organon:Presence
        - organon:Relation
        - organon:Denotation
        - organon:Configuration
      dependency_witnesses:
        organon:Presence: 'The Telegram message content, image or guide prose, identifiers, and controls.'
        organon:Relation: 'The ordered association from the Telegram presentation to the watch and bounded frame it presents.'
        organon:Denotation: 'The current-view content occupies the expression position; the associated watch and bounded frame occupy the target position.'
        organon:Configuration: 'The watch and bounded frame considered as the compound represented target.'
      target_witness:
        expression: 'The editable canonical Telegram anchor content in guide or snapshot mode.'
        target: 'The associated watch and the bounded frame selected for presentation.'
      exclusions:
        - 'Denotation does not establish fidelity, Truth, currentness outside the route checks, or causal use.'
        - 'The current view is not the watch, frame, pane, or Reality.'

  - local_term: current-route validity relation
    organon_id: organon:Constraint
    classification: refinement
    evidence:
      - docs/design-principles.md:37-62
      - docs/protocol-posture.md:15-66
      - internal/app/app.go:498-522
      - internal/app/input.go:54-182
      - internal/state/state.go:108-165
    rationale: 'Stored route eligibility persists while a route is current, permits routing from that route, and excludes input from known stale or collapsed routes.'
    dependency_packet:
      organon_claim: D013
      scope: 'Reply routing for one watch while a Telegram message is classified as current, stale, or collapsed.'
      dependency_closure:
        - organon:Presence
        - organon:Relation
        - organon:Configuration
        - organon:State
        - organon:Direction
        - organon:Transformation
        - organon:Invariant
        - organon:Persistence
      dependency_witnesses:
        organon:Presence: 'Stored anchor IDs, alternate IDs, stale-route IDs, collapsed status, and lookup results.'
        organon:Relation: 'The association of a Telegram chat and message ID with one watch and one route-eligibility status.'
        organon:Configuration: 'The route identifiers, watch binding, and current, stale, or collapsed status considered together.'
        organon:State: 'Route configurations before lookup, at validation, and at the attempted input position.'
        organon:Direction: 'The order from stored eligibility through current-target validation toward either routing or rejection.'
        organon:Transformation: 'Current-route input routing, stale-route rejection, and collapsed-shelf rejection.'
        organon:Invariant: 'Only the current route or latest eligible alternate remains actionable for the watch.'
        organon:Persistence: 'The route-eligibility relation remains stored and rechecked until replacement, retirement, or collapse changes it.'
      target_witness:
        permitted_transformations:
          - 'Prepare and route input when the reply target is current and the binding still matches.'
        excluded_transformations:
          - 'Route input from a known stale reply target.'
          - 'Route input from the collapsed shelf.'
          - 'Route input after the watch binding has changed.'
      exclusions:
        - 'A Telegram message that still exists is not thereby current.'
        - 'Route eligibility is not institutional Permission or Authority.'

  - local_term: guarded reply-input chain
    organon_id: organon:CausalPath
    classification: refinement
    evidence:
      - internal/app/app.go:498-522
      - internal/app/input.go:54-182
      - internal/tmux/tmux.go:507-563
    rationale: 'For a guarded reply, ordered message handling, current-target validation, session validation, and binding-conditioned tmux send transformations feed one another toward an attempted pane-bound effect.'
    dependency_packet:
      organon_claim: D010
      scope: 'One reply to a current Engram anchor through the attempted tmux input effect.'
      dependency_closure:
        - organon:Presence
        - organon:Relation
        - organon:Configuration
        - organon:State
        - organon:Direction
        - organon:Transformation
        - organon:Feeds
      dependency_witnesses:
        organon:Presence: 'The Telegram message, reply target, prepared text, watch fields, binding identifiers, and tmux command arguments.'
        organon:Relation: 'Associations among reply message, current route, watch, terminal binding, and intended pane.'
        organon:Configuration: 'The values grouped at each handling and validation stage.'
        organon:State: 'The received-reply state, current-target state, validated-session state, and attempted-effect state.'
        organon:Direction: 'The forward order from received reply toward the pane-bound tmux effect.'
        organon:Transformation: 'Reply lookup and input preparation; locked current-target and session validation; binding-conditioned tmux send; local completion handling.'
        organon:Feeds: 'The current watch, prepared input, and binding values output by one stage supply the corresponding inputs to the next stage.'
      target_witness:
        direction: 'Received Telegram reply toward an attempted effect on the validated pane.'
        sequence:
          - input_state: 'An incoming reply message referring to a candidate anchor.'
            transformation: 'Resolve the reply target and prepare typed input.'
            output_state: 'Prepared input associated with an expected current watch.'
            feeds_next: 'Prepared text, watch ID, chat ID, message ID, and expected binding.'
          - input_state: 'Prepared input and expected watch under session and anchor locks.'
            transformation: 'Recheck current-route status, session lifecycle, collapse and recovery status, and terminal binding.'
            output_state: 'A current active watch and validated input request, or a rejected branch.'
            feeds_next: 'Validated text and server, window, and pane identifiers on the continuing branch.'
          - input_state: 'Validated text and terminal binding.'
            transformation: 'Perform binding-conditioned text or command send through terminal mechanics.'
            output_state: 'A tmux result and, on success, sampled pane metadata for local completion handling.'
            feeds_next: 'Outcome, pane metadata, and expected watch identity.'
      exclusions:
        - 'The mapping covers the guarded continuing branch, not every failure branch as one path.'
        - 'A failure returned after the tmux effect does not prove rollback or absence of an effect.'
        - 'The text-plus-Enter command sequence is not claimed to be indivisible.'

  - local_term: tmux workspace
    organon_id: organon:Substrate
    classification: unmapped
    evidence:
      - README.md:9-31
      - docs/design-principles.md:37-62
      - docs/protocol-posture.md:15-66
    rationale: 'Engram calls tmux a durable workspace or substrate, but that self-description does not instantiate the complete Organon definition.'
    promotion_gate:
      missing:
        - 'A named Scope.'
        - 'Persistent input States supplied by the tmux Configuration.'
        - 'Feeds relations from those States into a named family of Transformations.'
        - 'Constraints showing which Differences are preserved, suppressed, or amplified.'

  - local_term: terminal truth and requirements source of truth
    organon_id: organon:Truth
    classification: conflict
    evidence:
      - docs/design-principles.md:37-62
      - README.md:190-217
      - requirements/INDEX.md:1-27
    rationale: 'The project phrases mark operational primacy of tmux and normative primacy of requirements; Organon Truth instead requires a Claim, Representation, truth-condition Specification, relevant Presence, Denotation, conformity, Rule, and scoped material-adequacy witness.'
    conflict_basis:
      - 'Operational or repository authority is not semantic Truth.'
      - 'No exact Claim-to-Specification-to-Presence material-adequacy packet is supplied.'

  - local_term: frame described as observation
    organon_id: organon:Observation
    classification: unmapped
    evidence:
      - docs/protocol-posture.md:15-66
      - internal/tmux/tmux.go:677-776
    rationale: 'The frame is source-backed as a bounded capture, but the complete Organon Observation constructor is not documented.'
    promotion_gate:
      missing:
        - 'An observing Entity with identity Invariant and Persistence witness.'
        - 'A Boundary and Sense through which an environmental Difference enters.'
        - 'An Environment and complete Causal path.'
        - 'A constructive Specification of the production path.'
        - 'A persistent Record of the earlier target State, Relation, or Change.'

  - local_term: audit or guide evidence
    organon_id: organon:Evidence
    classification: unmapped
    evidence:
      - requirements/INDEX.md:1-27
      - internal/app/refresh.go:236-302
    rationale: 'Local evidence labels and audit mechanisms do not establish independent, admitted Organon Evidence.'
    promotion_gate:
      missing:
        - 'The exact claimant and Claim.'
        - 'An Observation and distinct Witness.'
        - 'Mechanical and institutional independence under IndependentFor.'
        - 'A governing Order and Admissibility Rule.'
        - 'Admission of the Observation for the Claim and Scope.'

  - local_term: configured authorization and approval
    organon_id: organon:Authority
    classification: unmapped
    evidence:
      - internal/app/app.go:434-457
      - internal/app/app.go:551-562
      - internal/app/github_auth.go:63-212
      - internal/app/github_auth.go:271-390
    rationale: 'Configured identity checks and a Telegram confirmation path regulate technical actions but do not provide the Order-indexed institutional chain required for Authority.'
    promotion_gate:
      missing:
        - 'A named Order and Scope.'
        - 'The Agent and Principal.'
        - 'Standing and the applicable Rule.'
        - 'A CountsAs relation under which the Agent action may bind the Principal or Order.'

  - local_term: GitHub grant
    organon_id: organon:Grant
    classification: conflict
    evidence:
      - internal/app/github_auth.go:63-212
      - internal/app/github_grant.go:67-98
      - internal/githubauth/types.go:26-70
    rationale: 'Engram uses grant for a stored renewable credential mechanism; Organon Grant is an authorized Declaration whose submitted Claim is a Permission Claim and whose Authority covers all indexed participants.'
    conflict_basis:
      - 'The local object is stored after a technical approval flow rather than documented as the required institutional Declaration.'
      - 'Order, Principal, Standing, Authority, Permission Claim, and Admission are not supplied as one complete packet.'

  - local_term: GitHub lease or token
    organon_id: organon:Capability
    classification: unmapped
    evidence:
      - internal/app/github_auth.go:63-212
      - internal/githubauth/client.go:187-218
      - internal/githubauth/types.go:26-70
    rationale: 'A token with checked repository and permission scope is a technical input to possible actions, not by itself an Agent-level Capability witness.'
    promotion_gate:
      missing:
        - 'The persistent Agent whose Actions are being specified.'
        - 'The exact Action set and Scope.'
        - 'Environmental, technical, and temporal Constraints.'
        - 'A constructive satisfying Configuration containing an Action-producing Causal path.'

  - local_term: attention record
    organon_id: organon:Claim
    classification: unmapped
    evidence:
      - docs/protocol-posture.md:15-66
      - docs/protocol-posture.md:75-87
    rationale: 'The attention record is a bounded terminal-authored request to look, but it deliberately carries no sender identity and is treated as untrusted.'
    promotion_gate:
      missing:
        - 'An identified Agent asserting the Representation.'
        - 'A named target Presence, Relation, Configuration, or Record.'
        - 'A declared Claim Scope.'

  - local_term: current view as coordination surface
    organon_id: organon:Interface
    classification: unmapped
    evidence:
      - docs/design-principles.md:37-62
      - docs/design-principles.md:67-103
      - docs/protocol-posture.md:15-66
    rationale: 'The current view exposes controls and coordinates a user with a watched pane, but the complete Entity, Boundary, and permitted-Transformation packet is absent.'
    promotion_gate:
      missing:
        - 'Identity Invariants and Persistence witnesses for the coordinating Entities.'
        - 'The Boundary that the view instantiates.'
        - 'A complete enumeration or Specification of the permitted Transformations represented at that Boundary.'
```
