---
title: Kenogram Project Ontology
project: Kenogram
repository: https://github.com/idolum-ai/kenogram
branch: main
commit: 8c00104bb4b666d844715bf9840634cf92e571e2
review_date: "2026-08-06"
organon_version: "0.17.0"
status: generated-candidate
sensitivity: public
---

# Kenogram Project Ontology

This is a candidate application of Organon v0.17 to Kenogram at the exact source revision above. It describes what the public repository currently represents and implements. It does not amend Organon, certify Kenogram, establish production adoption, or convert repository self-description into independent Evidence.

## Scope and nonclaims

The review covers Kenogram's public source, binding requirements, design documents, and executable contracts at `8c00104bb4b666d844715bf9840634cf92e571e2`. The repository describes Kenogram as evaluation software and explicitly disclaims production stability, multi-tenant hardening, compliance, and certification ([README.md:55-70](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/README.md#L55-L70), [README.md:118-133](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/README.md#L118-L133)). Those limits bind this candidate ontology.

This document therefore distinguishes four epistemic levels:

1. **Declared**: the repository states a contract or intended relation.
2. **Implemented**: source contains a mechanism realizing part of that contract.
3. **Observed**: a record is produced from a runtime inspection or execution.
4. **Organon Evidence**: an Observation is produced by an IndependentFor Witness and admitted by an Order under an Admissibility Rule.

The first three do not automatically become the fourth. Kenogram's local use of “evidence” is preserved as project vocabulary but mapped carefully below.

## Project purpose

Kenogram materializes rootless Linux execution environments for AI agents from host-authored declarations. It aims to give an inhabitant a useful bounded computer without inheriting ambient host authority. The declaration selects the image and explicitly admits files, mounts, secrets, resources, network destinations, and loopback interfaces; requests made from inside the world do not alter durable authority ([README.md:7-25](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/README.md#L7-L25)).

The principal design move is structural restriction rather than prompt interpretation. Undeclared capabilities are meant not to occur in the world's observable structure, and runtime observations are checked before declared services start ([README.md:27-47](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/README.md#L27-L47), [docs/design.md:6-26](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/docs/design.md#L6-L26)). Replacement, rather than in-place mutation, is the universal world-change mechanism; a successor is inspected before it becomes the recorded applied generation ([docs/design.md:11-25](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/docs/design.md#L11-L25), [requirements/lifecycle.md:7-23](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/requirements/lifecycle.md#L7-L23)).

Kenogram also implements a governed-job mode: one noninteractive bounded target execution in a fresh generation, with host-authored request authority, bounded output and artifact capture, create-only publication, offline verification, and explicit separation among target outcome, finalization, and cleanup ([requirements/jobs.md:1-30](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/requirements/jobs.md#L1-L30), [requirements/jobs.md:140-178](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/requirements/jobs.md#L140-L178)).

## Local vocabulary

| Local term | Project meaning | Source evidence |
|---|---|---|
| declaration | One host-authored, versioned TOML input selecting a world configuration and admitted capabilities; the Go structure includes world, resources, workspace, copies, mounts, network, interfaces, and services. | [requirements/declaration.md:5-25](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/requirements/declaration.md#L5-L25); [internal/decl/types.go:3-69](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/internal/decl/types.go#L3-L69) |
| plan | The fully resolved canonical provisioning intent, carrying plan, evidence, and declaration digests. | [internal/plan/plan.go:21-83](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/internal/plan/plan.go#L21-L83) |
| world | A rootless Linux environment materialized from one declaration; the inhabitant owns what is visible inside it, while undeclared host presences are intended to be absent from it. | [docs/design.md:3-14](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/docs/design.md#L3-L14) |
| world-pattern | The finite observable contract specified by a declaration; implementations may vary while required observations remain conformant. | [docs/design.md:28-41](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/docs/design.md#L28-L41); [docs/kenogrammatics.md:44-63](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/docs/kenogrammatics.md#L44-L63) |
| generation | One material runtime inscription of a declared world-pattern, addressed as `kenogram-<world>-g<N>`. | [requirements/lifecycle.md:7-10](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/requirements/lifecycle.md#L7-L10); [requirements/lifecycle.md:43-46](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/requirements/lifecycle.md#L43-L46); [internal/backend/backend.go:158-160](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/internal/backend/backend.go#L158-L160) |
| authoritative generation | The generation the durable transition phase designates as current for status and repair; this remains distinct from the displaced or staged candidate. | [requirements/lifecycle.md:17-32](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/requirements/lifecycle.md#L17-L32); [internal/app/app.go:174-188](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/internal/app/app.go#L174-L188) |
| replacement | A transition that stages and inspects a successor, transfers explicit workspace state, records authority, and removes or restores generations according to outcome. | [requirements/lifecycle.md:7-23](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/requirements/lifecycle.md#L7-L23) |
| invariant | A finite required observation defining conformance, especially the ten network observations whose repetition must remain indistinguishable under reapplication. | [requirements/network.md:9-33](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/requirements/network.md#L9-L33) |
| interface | A named operator-facing byte stream to one declared loopback service; it publishes no host port and creates no general host-to-world addressing primitive. | [internal/decl/types.go:57-62](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/internal/decl/types.go#L57-L62); [requirements/network.md:62-66](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/requirements/network.md#L62-L66) |
| allow / network allowance | An exact host-and-port destination admitted durably by the declaration or temporarily by an explicit time-bounded operator action. | [README.md:16-21](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/README.md#L16-L21); [requirements/network.md:15-27](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/requirements/network.md#L15-L27) |
| runtime observation | A closed provider-specific record of public declared identity and observed enforcement facts before or after a governed job. | [internal/jobcontract/types.go:153-190](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/internal/jobcontract/types.go#L153-L190) |
| job request | Host-authored input binding declaration identity, command, environment, bounds, and optional artifact inventory. | [requirements/jobs.md:16-30](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/requirements/jobs.md#L16-L30); [internal/jobcontract/types.go:23-62](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/internal/jobcontract/types.go#L23-L62) |
| result | A typed record separating target outcome, streams, finalization, cleanup, identity, and reasons. | [internal/jobcontract/types.go:64-122](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/internal/jobcontract/types.go#L64-L122) |
| evidence manifest | The final create-only seal over an ordered inventory of retained job artifacts and their digests. | [requirements/jobs.md:172-214](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/requirements/jobs.md#L172-L214); [internal/jobcontract/types.go:124-139](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/internal/jobcontract/types.go#L124-L139) |
| provenance | A bounded report relating an exact executable digest to build kind, version, commit, date, toolchain, and platform. It is not a signature or self-qualification. | [requirements/provenance.md:9-37](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/requirements/provenance.md#L9-L37) |
| history | An fsynced, hash-chained, per-world series of operation records with idempotent immediate-repeat suppression. | [internal/history/history.go:1-29](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/internal/history/history.go#L1-L29); [internal/history/history.go:42-93](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/internal/history/history.go#L42-L93) |

## Participants and worlds

### Entities

- **A materialized generation** is the strongest candidate `organon:Entity`. Its generation name, container identity, plan digest, declaration digest, image identity, mount identity, and runtime observations provide an explicit identity criterion across ordered lifecycle States. The repository distinguishes recorded authority from runtime observation ([internal/app/app.go:174-188](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/internal/app/app.go#L174-L188)) and inspects a concrete runtime Configuration with stable identity and boundary fields ([internal/backend/backend.go:413-453](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/internal/backend/backend.go#L413-L453)). This is a refinement only: an Organon Entity claim still needs the named Invariant and Persistence witness for the intended sequence.
- **The Kenogram software project or executable** can be treated as an Entity only in a declared Scope that names its identity criterion—such as source/release lineage plus executable provenance. A binary digest alone is a Record of one inscription, not proof of project identity.
- **A host operator** and a qualifying AI inhabitant are Entities. A container process is not promoted to Agent merely because the project calls it an agent.

### Agents

- **Host operator** is the strongest positive Agent: the operator interprets a plan comparison and chooses whether to invoke `up`, `allow`, `revoke`, or destruction. `UpReviewed` revalidates the reviewed predecessor snapshot under the mutation lock before application, preserving the causal connection between interpretation and Action ([internal/app/app.go:155-188](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/internal/app/app.go#L155-L188), [internal/app/app.go:239-289](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/internal/app/app.go#L239-L289)).
- **World inhabitant** is an Agent only if its Interpretation conditions Actions. The term “AI agent” in project prose is not enough by itself; no isolated model response, PID, or successful job establishes Organon Agency.
- **Parser, planner, proxy, verifier, and Podman** are not Agents merely because they transform inputs. In the evidenced project Configuration they are Tools or Organs unless an additional Agent-level identity and Interpretation path is shown.

### Tools

- **Kenogram executable** is a Tool used by the host operator in the causal path from declaration to bounded runtime.
- **Rootless Podman, `nsenter`, and Linux kernel mechanisms** are Tools incorporated by Kenogram and ultimately by the operator. The project explicitly names them as dependencies whose isolation it observes but does not independently establish ([requirements/security.md:111-117](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/requirements/security.md#L111-L117)).
- **Offline `verify-job`** is a Tool that applies closed validation Rules to retained Records; it is not by itself an IndependentFor Witness.

### Organs

The declaration parser, semantic planner, rootless backend, network proxy, transition recovery mechanism, governed-job publisher, and offline verifier are candidate `organon:Organ` instances relative to the larger Kenogram Entity or a deploying Institution. Each is a persistent specialized Configuration performing recurring Transformations. The planner, for example, resolves a parsed declaration into a canonical plan and three provenance digests ([internal/plan/plan.go:97-189](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/internal/plan/plan.go#L97-L189)); the backend inspects runtime state into a structured record ([internal/backend/backend.go:413-453](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/internal/backend/backend.go#L413-L453)). They remain Tools relative to the operator and Organs only relative to the named larger whole.

### Institutions and Orders

The repository does not prove a production Institution. Two candidate Orders are nonetheless legible:

1. **Runtime governance Order**: host operator, qualifying inhabitant Agents, declarations, validation Rules, interfaces, runtime Records, and recurring application/replacement Relations coordinate Action. It becomes an Organon Order only when a plurality of actual Agents and their coordination are identified.
2. **Project governance Order**: contributors, repository rules, binding requirements, CI observations, release procedures, and publication Records may coordinate software change. It becomes an Institution only if it is shown to persist through Roles, Records, Interfaces, and Flows despite participant turnover.

“The declaration is the sole authority input” is therefore a local security invariant, not yet an `organon:Authority` theorem. Organon Authority is an Order-indexed Relation through which an Agent's Action may count as binding on a Principal or within an Order and Scope. The repository names trusted inputs and enforcement mechanics, but deployment-specific Standing, Principal, ActsFor, and Admission relations remain to be supplied.

### World, Environment, and Substrate

- **Live inhabited Kenogram world** is a refinement candidate for `organon:World` when its Scope names participating Entities, selected host Presence, available Perception/Interpretation/Action paths, Constraints, and at least one persistent common Invariant. The project's world-pattern and network invariants supply much of this structure. A TOML declaration, stopped empty container, or filesystem tree alone is not an Organon World.
- **Host environment** is the Presence related to but excluded from the generation's identity and Boundary: host filesystem, processes, devices, credentials, routes, and names. Selected mounts, copies, secrets, and proxy doors cross that Boundary by explicit declaration ([docs/design.md:6-21](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/docs/design.md#L6-L21)). Because Environment is Entity-relative, “the host” is not one universal Environment for every participant.
- **Linux kernel and rootless Podman configuration** are candidate Substrates for namespace and container Transformations. **Base image plus admitted sources** are candidate Substrates for generation materialization. The same base image can instead be a represented target, Record, Tool input, or output under another Scope; Substrate is not its intrinsic kind.
- A Kenogram World is not identical to the container generation, declaration, plan, host Environment, or Reality. The project itself says a generation is one inscription and that hashes are provenance rather than an ontology of sameness ([docs/kenogrammatics.md:65-84](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/docs/kenogrammatics.md#L65-L84)).

## Load-bearing relations

| Relation | Organon reading | Kenogram realization and limit |
|---|---|---|
| declaration specifies plan | `denotes`, `specifies`, then `operationalizes` | TOML bytes are parsed and validated into a canonical Plan. The selected runtime Transformation occurs only through application; planning alone is not operationalization. ([internal/app/app.go:207-232](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/internal/app/app.go#L207-L232)) |
| plan constrains generation | `constrains`, `feeds`, `servesAsSubstrate` | Plan fields feed container creation and constrain mounts, resources, network, interfaces, and services. The plan is not the generation or World. ([internal/plan/plan.go:21-83](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/internal/plan/plan.go#L21-L83)) |
| generation realizes world-pattern | `alignsUnder` a finite Specification | Conformance means matching declared observations, not byte identity or universal behavioral equivalence. ([docs/kenogrammatics.md:44-63](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/docs/kenogrammatics.md#L44-L63)) |
| replacement carries workspace | `transforms`, `feeds`, `persists` | Workspace state is explicitly captured and handed off; configuration is regenerated. Persistence of a world-pattern does not imply identity of generations. ([requirements/lifecycle.md:7-23](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/requirements/lifecycle.md#L7-L23), [requirements/lifecycle.md:34-46](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/requirements/lifecycle.md#L34-L46)) |
| operator admits egress | candidate `declares`, `grants`, `permits`, `enforces` chain | The declaration creates durable allowance and `allow` creates time-bounded access. A complete Organon Permission requires deployment-specific Order, Principal, Authority, Grant, and Admission records not proven by the repository. ([README.md:16-21](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/README.md#L16-L21)) |
| runtime inspection records state | `senses`, `observes`, `records` | Podman inspection produces structured runtime observations. Calling the struct `Evidence` does not itself satisfy Organon's Witness independence and institutional Admission requirements. ([internal/backend/backend.go:413-453](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/internal/backend/backend.go#L413-L453)) |
| manifest seals observations | `records`; candidate `attests` | The create-only manifest binds retained artifacts, but cryptographic integrity does not make producer-owned records independent Evidence. ([requirements/jobs.md:172-214](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/requirements/jobs.md#L172-L214)) |
| offline verifier checks bundle | `interprets`, applies `Rule`, produces `Claim` or `Observation` | `verify-job` recomputes and cross-checks retained bytes without contacting a provider, and does not upgrade runtime-reported fields to host-observed facts. ([requirements/jobs.md:239-264](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/requirements/jobs.md#L239-L264)) |

### Load-bearing causal path

The following is one joined path; removing any named join breaks the intended result:

```text
host operator's internal State
  -> edits declaration bytes (Action)
  -> declaration parser (Tool/Organ; fail-closed Rule)
  -> validated declaration Configuration
  -> semantic planner (Tool/Organ)
  -> canonical plan + declaration/plan/evidence digest Records
  -> operator reviews comparison and invokes up (Interpretation -> Action)
  -> rootless backend stages generation from base-image/source Substrates
  -> kernel/Podman namespace and resource Constraints delimit its Boundary
  -> backend inspects the candidate runtime (Sense -> Observation)
  -> inspection is compared with the declared Specification
  -> successor is recorded as applied
  -> declared services begin
```

The code makes the early joins concrete: parsing and plan building occur in `PrepareBytesContext` ([internal/app/app.go:218-232](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/internal/app/app.go#L218-L232)); reviewed application revalidates the predecessor snapshot before mutation ([internal/app/app.go:239-289](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/internal/app/app.go#L239-L289)); the lifecycle contract forbids calling the successor applied until runtime evidence is inspected ([requirements/lifecycle.md:7-23](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/requirements/lifecycle.md#L7-L23)). A plan digest, an existing container, or a successful service command alone cannot substitute for this path.

For governed jobs the path continues through target admission, terminal observation, bounded stream capture, finalization, proof of cleanup absence, create-only artifact publication, final manifest seal, and independent offline replay ([requirements/jobs.md:140-178](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/requirements/jobs.md#L140-L178), [requirements/jobs.md:239-278](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/requirements/jobs.md#L239-L278)).

### Authority and evidence paths

#### Candidate authority path

```text
deployment Order
  -> records operator Standing and Principal scope
  -> operator has Authority for world policy
  -> operator Action submits declaration + Specification
  -> Order admits it as a valid Grant / durable Permission record
  -> Kenogram validation and runtime Constraints enforce the admitted scope
  -> inhabitant Action exercises only technically available paths
```

Kenogram supplies the last two mechanical stages and a host-authored declaration format. The public repository does **not** supply the deployment Order's Standing, Principal, ActsFor, Authority, or Admission records. Accordingly, “request authority” and “authoritative generation” in the code are local terms: they prevent claimant-controlled runtime output from changing technical policy, but do not independently establish Organon Authority.

#### Candidate evidence path

```text
runtime Environment
  -> Podman/kernel inspection Interface
  -> runtime Observation Record
  -> sealed job bundle and provenance Records
  -> verifier distinct from producer reopens exact bytes
  -> verifier applies declared validation Rule
  -> verifier produces an Observation bearing on producer Claim
  -> governing Order checks IndependentFor and admits it
  -> evaluation Rule records supporting / defeating / underdetermining bearing
```

Kenogram implements the record production, sealing, and offline verification surfaces. It explicitly says self-reported provenance is not self-qualification ([requirements/provenance.md:27-37](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/requirements/provenance.md#L27-L37)) and that consumers must independently parse and verify retained bytes ([requirements/jobs.md:276-278](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/requirements/jobs.md#L276-L278)). The last two institutional joins are external promotion gates. Before them, the bundle is a strong Observation/Attestation candidate, not Organon Evidence.

## Invariants and prohibited collapses

### Invariants

1. **Declaration exclusivity:** durable world authority changes only through a host-authored declaration; in-world terminal prose does not alter it ([docs/design.md:11-14](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/docs/design.md#L11-L14)).
2. **Fail-closed admission:** malformed, unknown, duplicate, unbounded, unsafe, or unsupported declaration fields are rejected rather than widened ([requirements/declaration.md:5-21](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/requirements/declaration.md#L5-L21)).
3. **No ambient host access:** only explicitly admitted host presences cross the intended world Boundary ([README.md:7-21](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/README.md#L7-L21)).
4. **Network base absence:** loopback is the only base interface; resolver and exterior routes do not obtain; exact destinations require an admitted proxy path ([requirements/network.md:9-23](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/requirements/network.md#L9-L23)). “Absence” here is Kenogram's name for scoped nonavailability under runtime Constraints, not metaphysical `organon:Absence`. It becomes `organon:Missingness` only relative to a field that represents or expects the capability and does not contain it.
5. **Inscription independence:** generation identity may change while the finite world-pattern observations persist; conformance is not equivalence beyond that contract ([requirements/network.md:23-33](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/requirements/network.md#L23-L33)).
6. **Candidate-before-authority:** a successor is staged and inspected before durable state records it as applied ([requirements/lifecycle.md:7-23](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/requirements/lifecycle.md#L7-L23)).
7. **Claim/observation separation:** target output and runtime-reported fields remain observations and never become authority because the producer labels them successful ([requirements/jobs.md:10-14](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/requirements/jobs.md#L10-L14)).
8. **Outcome/finalization/cleanup separation:** target success, artifact finalization, and cleanup absence are distinct Records and conditions ([requirements/jobs.md:140-169](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/requirements/jobs.md#L140-L169)).
9. **Secret nonprojection:** secret bytes and their digests do not enter plan output, logs, history, or generated public projections ([requirements/security.md:5-10](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/requirements/security.md#L5-L10)).
10. **Provenance modesty:** hashes establish exact-byte provenance and conservative sameness, not semantic identity, signature, truth, or independent qualification ([docs/kenogrammatics.md:65-76](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/docs/kenogrammatics.md#L65-L76), [requirements/provenance.md:27-32](https://github.com/idolum-ai/kenogram/blob/8c00104bb4b666d844715bf9840634cf92e571e2/requirements/provenance.md#L27-L32)).

### Prohibited collapses

- Declaration, Plan, Map, and World are distinct. A host-authored Representation does not become the runtime Configuration it governs (`C5`, `C11`, `C12`).
- A Kenogram generation is not automatically an Organon World; a World requires participating Entities, included causal access paths, Scope, Constraints, and a common persistent Invariant (`C12`).
- Local “absence” of an undeclared capability is not `organon:Absence`. It is a scoped negative runtime observation or Missingness relative to the declared world field (`C4`).
- A target's ability to act does not create Permission or Authority, and a declaration's institutional validity would not guarantee technical Capability (`C7`).
- Local `Evidence` structs, manifests, test results, and self-provenance do not become Organon Evidence without the IndependentFor, Admission, Order, and evaluation-Rule joins (`C6`).
- `authoritative generation` does not denote `organon:Authority`; it is a canonical operational status recorded during a lifecycle transition.
- A digest is a Record and comparison input, not an Entity's entire identity criterion, Truth, or ontological sameness.
- Rootless containment, seccomp, a successful job, or a sealed bundle does not entail production fitness, compliance, certification, or kernel/runtime escape resistance beyond the stated scope.
- Kenogram, Podman, parser, model, and proxy do not become Agents merely because they perform Transformations.
- Tool and Organ are contextual projections: a component may be a Tool in an operator's Action path and an Organ relative to Kenogram without becoming two Entities (`C3`).

## Organon mappings

`exact` means the public definition supplies every load-bearing Organon condition in the stated Scope. `refinement` means it plausibly supplies a domain profile but still needs named witnesses or context. `conflict` marks a local word whose ordinary project use must not be imported as the same Organon term. `unmapped` retains local vocabulary without promotion.

| Local term | Organon ID | Class | Rationale |
|---|---|---|---|
| materialized generation | `organon:Entity` | refinement | Explicit operational identity and ordered lifecycle States exist; the Organon identity Invariant and Persistence witness must still be stated. |
| host presence outside generation | `organon:Environment` | refinement | It is Entity-relative Presence excluded by the generation Boundary; admitted mounts and proxies selectively cross it. |
| declaration | `organon:Specification` | refinement | It represents a Scope and is accepted by a constructive validator; its Go parser is authoritative about schema and defaults. |
| declaration | `organon:Declaration` | conflict | A local TOML artifact lacks, by itself, the Agent, Authority, Claim, Order, and institutional counting required by Organon. |
| semantic planner / validator | `organon:Rule` | refinement | It maps conforming declaration inputs to canonical plan or rejection. |
| plan | `organon:Representation` | refinement | It denotes resolved provisioning intent but is not its runtime target. |
| plan / declaration digest | `organon:Record` | refinement | Persistent representations of exact prior bytes/configuration; they do not prove semantic identity. |
| world-pattern | `organon:Specification` | refinement | A finite constructive observation contract decides realization conformance within a Scope. |
| live inhabited declared world | `organon:World` | refinement | Requires explicit participants, causal availability paths, and common persistent Invariant to close the Organon definition. |
| Kenogram `world` declaration block | `organon:World` | conflict | A configuration subsection containing hostname/base/workdir/user is not by itself an Organon World. |
| generation | `organon:Configuration` | refinement | One material runtime inscription with related namespaces, resources, mounts, services, and records. |
| replacement | `organon:Transformation` | refinement | Ordered cutover changes runtime Configuration and authority Records. |
| network invariant set | `organon:Invariant` | refinement | It names observations intended to persist under reapplication; a particular run needs the ordered-State witness. |
| namespace/container boundary | `organon:Boundary` | refinement | Constraints determine which host-to-world and world-to-host Transformations preserve generation identity. |
| named loopback interface | `organon:Interface` | refinement | Permitted byte-stream Transformations are explicitly represented for operator/world coordination. |
| Kenogram executable | `organon:Tool` | refinement | Operator incorporates it into the causal path of world creation without making it part of operator identity. |
| parser / planner / proxy / verifier | `organon:Organ` | refinement | Persistent specialized Configurations recurring for Kenogram; relative to operator they remain Tools. |
| Linux kernel / Podman / base image | `organon:Substrate` | refinement | They supply persistent input States and Constraints for named namespace, container, and materialization Transformations. |
| host operator | `organon:Agent` | refinement | Interpretation-to-Action path is legible; particular Agent identity remains deployment-specific. |
| AI inhabitant | `organon:Agent` | refinement | Qualifies only if Interpretation conditions Action; process/model labels alone are insufficient. |
| project governance | `organon:Institution` | refinement | Requires proof of plural-Agent persistence through Roles, Records, Interfaces, and recurring Flows. |
| runtime governance configuration | `organon:Order` | refinement | Requires actual plural Agents and named institutional coordination, not only mechanical enforcement. |
| `allow` operation | `organon:Grant` | refinement | Can instantiate a time-bounded Grant only in a deployment Order with operator Authority and an admitted Permission Claim. |
| network allowance | `organon:Permission` | refinement | Mechanically enforced scope resembles Permission, but the complete Order/Principal/Grant/Admission chain is external. |
| “authoritative generation” | `organon:Authority` | conflict | It names lifecycle canonicality, not an Agent's Order-indexed capacity to bind a Principal. |
| backend `Evidence` / runtime observation | `organon:Observation` | refinement | Structured record of an inspected runtime path; the exact Sense/path Specification must be named. |
| backend `Evidence` / sealed manifest | `organon:Evidence` | conflict | Producer records and integrity seals lack automatic IndependentFor and Admission relations. |
| offline verifier result | `organon:Attestation` | refinement | When asserted by a distinct Witness under identity and Scope it can be an Attestation; running code alone is not a Witness. |
| per-world history | `organon:Ledger` | refinement | Ordered typed Records with provenance are present, but it does not preserve every Organon institutional distinction. |
| applied plan/history | `organon:CanonicalSystem` | refinement | The runtime lifecycle recognizes them as its official operational account, not Reality. |
| world-pattern inscription | — | unmapped | Useful local analogy; no stable `organon:*` term is needed beyond Configuration, Representation, Specification, and Alignment. |

## Boundary cases

| Term | Strongest positive | Strongest negative | Difficult boundary case and decision |
|---|---|---|---|
| Entity | One identified generation across staged, running, stopped, and recorded States with a named generation identity and invariant. | “No exterior route,” which is a Constraint/condition rather than a Configuration retaining identity. | The “world” across replacement generations: classify as Entity only after naming a world-level identity Invariant and Persistence witness; the repository explicitly refuses to make hashes its ontology of sameness. |
| Agent | Host operator who reviews a comparison and invokes application. | TOML parser deterministically rejecting an unknown key. | An LLM-backed contained process: classify only if one joined path shows Perception/Memory/Model/Interpretation selecting its Action; model output alone is insufficient. |
| Tool | Kenogram executable in the operator's world-application path. | Host operator, whose Interpretation selects Action. | Podman: Tool relative to Kenogram/operator; not Agent merely because it schedules processes. |
| Organ | Planner or verifier recurring as a specialized component of Kenogram. | One immutable `manifest.json`, which is a Record. | Kenogram executable itself: Tool relative to operator; Organ only relative to a larger persistent platform or Institution for which it performs recurring execution-boundary work. |
| Institution | A demonstrated project governance Order persisting through contributor turnover, release Roles, Records, Interfaces, and CI/release Flows. | One operator and one local run. | Public GitHub repository: documents make an Order candidate visible, but this snapshot alone does not prove plural-Agent persistence through turnover. |
| World | An inhabited live generation whose declared Scope includes an agent, selected host Presence, actual access paths, and a persistent world-pattern Invariant. | The `[world]` TOML table or a plan JSON. | A stopped but retained generation: it may remain an Entity/Configuration, but without available Perception/Interpretation/Action paths it does not presently satisfy World. |
| Environment | Host files, devices, processes, names, and routes outside one generation Boundary. | The generation's declared internal filesystem and processes insofar as included in its identity. | A mounted host directory: host Environment at source, admitted Interior/Interface-related Presence relative to the generation target; classification changes with Entity and Scope. |
| Substrate | Base image and kernel/runtime Configuration supplying States and Constraints for generation materialization. | Plan digest, which records input rather than supplying material input States. | A writable workspace: Substrate for successor materialization, Interior of the current generation, and Environment relative to another Entity; no intrinsic classification. |

## Uncertainties and promotion gates

1. **World identity:** state the exact world-level Invariant and ordered Persistence witness across replacement. Current documents deliberately distinguish world-pattern conformance from ontological sameness.
2. **Agent boundary:** identify which contained systems satisfy the full Interpretation-to-Action definition rather than merely executing commands.
3. **Order and Institution:** identify actual Agents, Roles, Standing, Interfaces, and persistence across participant turnover. Repository structure alone is insufficient.
4. **Authority:** supply deployment-specific Principal, ActsFor, Standing, Authority, Declaration, Grant, Admission, and Permission records. Local “authority input” is currently a technical policy term.
5. **Evidence:** define the Witness running offline verification, prove `IndependentFor` relative to the producer/claim/order, name the Admissibility Rule, and record evaluation Rule output. Until then use Observation, Record, or Attestation candidate.
6. **Observation causal path:** bind each runtime field to the exact inspection mechanism, environmental target, and immutable process/container identity. The source contains strong pieces, but this ontology has not reconstructed every field-level path.
7. **World availability:** show actual Causal paths from Environment through Sense/Perception or from internal State through Action for each declared participant. Files being mounted is not enough.
8. **Substrate persistence:** specify the ordered input States and family of Transformations for kernel, runtime, base image, and workspace profiles independently.
9. **Permission semantics:** decide whether Kenogram should adopt Organon's institutional vocabulary or retain “authority/allow” as deliberately local mechanical terms with explicit non-equivalence.
10. **External claims:** no claim of production adoption, universal security, independent certification, or real-service behavior should be promoted from CI or project prose.

### Machine-consumable mapping manifest

<!-- organon:mapping-manifest -->
```yaml
schema_version: 1
project: Kenogram
commit: 8c00104bb4b666d844715bf9840634cf92e571e2
mappings:
  - local_term: materialized_generation
    organon_id: organon:Entity
    classification: refinement
    evidence: ["requirements/lifecycle.md:7-23", "internal/app/app.go:174-188"]
  - local_term: host_environment
    organon_id: organon:Environment
    classification: refinement
    evidence: ["docs/design.md:6-21", "requirements/security.md:111-117"]
  - local_term: declaration
    organon_id: organon:Specification
    classification: refinement
    evidence: ["requirements/declaration.md:5-25", "internal/decl/types.go:3-69"]
  - local_term: declaration
    organon_id: organon:Declaration
    classification: conflict
    evidence: ["docs/design.md:11-14"]
  - local_term: semantic_validator
    organon_id: organon:Rule
    classification: refinement
    evidence: ["internal/app/app.go:218-232"]
  - local_term: plan
    organon_id: organon:Representation
    classification: refinement
    evidence: ["internal/plan/plan.go:21-83"]
  - local_term: world_pattern
    organon_id: organon:Specification
    classification: refinement
    evidence: ["docs/kenogrammatics.md:44-63"]
  - local_term: live_inhabited_declared_world
    organon_id: organon:World
    classification: refinement
    evidence: ["README.md:7-25", "requirements/network.md:9-33"]
  - local_term: world_declaration_block
    organon_id: organon:World
    classification: conflict
    evidence: ["internal/decl/types.go:18-23"]
  - local_term: namespace_container_boundary
    organon_id: organon:Boundary
    classification: refinement
    evidence: ["README.md:27-47", "requirements/security.md:64-80"]
  - local_term: named_loopback_interface
    organon_id: organon:Interface
    classification: refinement
    evidence: ["internal/decl/types.go:57-62", "requirements/network.md:62-66"]
  - local_term: kenogram_executable
    organon_id: organon:Tool
    classification: refinement
    evidence: ["README.md:7-25"]
  - local_term: planner_proxy_verifier
    organon_id: organon:Organ
    classification: refinement
    evidence: ["internal/plan/plan.go:97-189", "requirements/jobs.md:239-278"]
  - local_term: kernel_podman_base_image
    organon_id: organon:Substrate
    classification: refinement
    evidence: ["README.md:55-70", "requirements/security.md:111-117"]
  - local_term: host_operator
    organon_id: organon:Agent
    classification: refinement
    evidence: ["internal/app/app.go:155-188", "internal/app/app.go:239-289"]
  - local_term: runtime_governance
    organon_id: organon:Order
    classification: refinement
    evidence: ["README.md:16-21", "requirements/security.md:111-117"]
  - local_term: project_governance
    organon_id: organon:Institution
    classification: refinement
    evidence: ["README.md:118-133", "README.md:188-199"]
  - local_term: allow_operation
    organon_id: organon:Grant
    classification: refinement
    evidence: ["README.md:16-21", "requirements/network.md:22-27"]
  - local_term: authoritative_generation
    organon_id: organon:Authority
    classification: conflict
    evidence: ["requirements/lifecycle.md:25-32", "internal/app/app.go:182-188"]
  - local_term: runtime_observation
    organon_id: organon:Observation
    classification: refinement
    evidence: ["internal/jobcontract/types.go:153-190"]
  - local_term: backend_evidence_or_manifest
    organon_id: organon:Evidence
    classification: conflict
    evidence: ["internal/backend/backend.go:413-453", "requirements/jobs.md:172-214"]
  - local_term: verifier_assertion
    organon_id: organon:Attestation
    classification: refinement
    evidence: ["requirements/jobs.md:239-278"]
  - local_term: per_world_history
    organon_id: organon:Ledger
    classification: refinement
    evidence: ["internal/history/history.go:18-40", "internal/history/history.go:42-93"]
  - local_term: world_pattern_inscription
    organon_id: null
    classification: unmapped
    evidence: ["docs/kenogrammatics.md:44-84"]
```

### Candidate conclusion

Kenogram's strongest Organon contribution is not the word “world,” but a disciplined separation among represented intent, materialized Configuration, runtime Observation, and institutional authority. Its source repeatedly refuses several dangerous collapses: request output into authority, digest into identity, conformance into universal equivalence, producer report into independent proof, and capability into ambient permission.

The principal semantic hazards are correspondingly local-name collisions. Kenogram `declaration`, `world`, `authority`, and `evidence` are narrower engineering terms than `organon:Declaration`, `organon:World`, `organon:Authority`, and `organon:Evidence`. Treating them as exact would overstate the public artifact. Treating them as explicit refinements—with deployment-specific gates for Agent, Order, Authority, and Evidence—produces a coherent, useful project ontology without inflating the repository's claims.
