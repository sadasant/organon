---
type: project-ontology
status: generated-candidate
project: Kenogram
repository: https://github.com/idolum-ai/kenogram
branch: main
commit: 8c00104bb4b666d844715bf9840634cf92e571e2
organon_version: 0.18.0
---

# Kenogram Project Ontology

## Scope and nonclaims

This candidate describes Kenogram at repository `https://github.com/idolum-ai/kenogram`, branch `main`, commit `8c00104bb4b666d844715bf9840634cf92e571e2`. It covers the declaration, planning, materialization, replacement, network, governed-job, history, and verification mechanisms visible in the pinned dossier. It is not a feature inventory.

The repository describes Kenogram as an execution boundary for untrusted agent processes and distinguishes that boundary from a prompt filter (`README.md:27-31`). Those descriptions remain project Claims for this review. This document does not turn them into proof of security, effectiveness, adoption, completion, Truth, independent Evidence, or institutional Authority.

In particular:

- Kenogram is evaluation software and makes no production-stability claim (`README.md:55-62`).
- It does not claim to prevent prompt injection, protect admitted writable mounts or secrets from world processes, prevent exfiltration to admitted destinations, secure `kenogram connect` traffic, harden a hostile multi-tenant host, or independently prevent kernel or runtime escape (`README.md:41-47`).
- Mandatory tests are replayable project observations, not endorsements, universal compatibility, certification, or a production-stability claim (`README.md:116-133`).
- The project says it does not implement Kaehr's formalism or claim equivalence beyond finite observation contracts (`docs/design.md:28-41`; `docs/kenogrammatics.md:78-85`).
- Nothing in the dossier is an Organon adoption manifest. Every mapping below is a review candidate scoped to this commit.

## Project purpose

Kenogram gives an AI agent or other process a small rootless Linux environment without giving it the operator's ambient computer. A host-authored declaration selects the image and explicitly admits files, mounts, secrets, resource limits, TCP destinations, loopback interfaces, and services (`README.md:7-25`).

The operational sequence is to read and validate one declaration, resolve it into a canonical plan, materialize a generation, inspect the runtime, and only then record the generation as applied. Later configuration changes occur through replacement rather than mutation of the existing generation (`docs/design.md:6-25`; `internal/app/app.go:207-232`). Network reachability is introduced through host-held exact-destination proxies rather than an exterior route inside the world (`docs/design.md:16-21`).

Kenogram also supports governed jobs: one noninteractive bounded execution in a fresh generation, with request authority kept separate from target outcomes and retained observations (`requirements/jobs.md:10-30`).

## Local vocabulary

The following meanings are local to Kenogram and precede any Organon mapping.

| Local term | Kenogram meaning | Source |
| --- | --- | --- |
| **world** | A rootless Linux environment materialized from one host-authored declaration. The inhabitant can use what the image and declaration make visible. | `docs/design.md:6-9`; `README.md:10-14` |
| **declaration** | The single host-authored configuration input. Version 1 names the world, image, resources, workspace, copies, mounts, network destinations, interfaces, and services. Unknown or malformed constructs fail validation. | `internal/decl/types.go:3-16`; `requirements/declaration.md:5-21` |
| **plan** | The fully resolved canonical provisioning intent, carrying resolved resources and admissions together with plan, declaration, and evidence digests. | `internal/plan/plan.go:21-83` |
| **generation** | A numbered material realization named `kenogram-<world>-g<N>`. During replacement and recovery, a generation can be authoritative, candidate, or displaced. | `internal/backend/backend.go:158-159`; `requirements/lifecycle.md:25-32` |
| **replacement** | The universal configuration-change mechanism. It stages a successor, carries and digests workspace data, regenerates configuration, verifies the successor, and records a recovery direction. | `docs/design.md:11-14`; `requirements/lifecycle.md:7-23` |
| **world-pattern** | The required observable properties specified by a declaration and its contracts. Different mechanisms or generations may satisfy the same finite pattern without byte or structural identity. | `docs/kenogrammatics.md:50-56`; `docs/kenogrammatics.md:67-76` |
| **runtime invariant** | A normative acceptance condition evaluated at the real runtime boundary. The network set covers absence, visibility, reachability, exact admission, failure, expiry, and reapplication behavior. | `requirements/network.md:9-31` |
| **authority** | Kenogram's term for configuration or transition input that controls admitted facilities and which generation operations treat as current. It includes declaration-backed authority and authoritative-generation state. | `docs/design.md:11-14`; `requirements/lifecycle.md:25-32` |
| **absence** | Operational nonavailability in a declared or inspected field, such as no route, resolver, undeclared mount, runtime socket, or capability. | `README.md:33-39`; `requirements/network.md:9-23` |
| **allow / revoke** | Live operations that add or remove time-bounded TCP egress. Reapplication restores declaration-backed allowances and clears ephemeral grants. | `README.md:16-21`; `requirements/network.md:25-27` |
| **operator interface** | A named operator-facing byte stream to one declared loopback service. Descriptor transfer exposes that service without publishing a host port or general host-to-world address. | `internal/decl/types.go:57-62`; `requirements/network.md:62-66` |
| **runtime evidence / observation** | Structured inspection fields concerning container, image, namespace, capability, seccomp, device, mount, and resource facts. Missing-runtime status remains explicit. | `internal/backend/backend.go:413-453`; `internal/app/app.go:174-187` |
| **governed job** | One bounded noninteractive execution whose request, result, runtime observations, streams, cleanup, provenance, and sealed inventory remain separately typed. | `requirements/jobs.md:10-30`; `internal/jobcontract/types.go:23-139` |
| **history record** | A timestamped, hash-chained JSON record of an operation, its digests, outcome, detail, and previous hash, appended and fsynced to per-world history. | `internal/history/history.go:18-29`; `internal/history/history.go:42-70` |

## Participants and worlds

The **host operator** authors or edits declarations and invokes Kenogram. Terminal prose from inside a world does not alter declaration authority (`docs/design.md:11-14`). This local participant description is not yet an `organon:Agent` or `organon:Authority` claim.

The **Kenogram provisioner** parses declarations, builds plans, acquires the world mutation lock, revalidates reviewed predecessor material, performs recovery, and applies replacement (`internal/app/app.go:239-289`). The dossier does not establish Kenogram itself as a persistent Organon Entity or Agent.

The **world inhabitant or world process** can use whatever the image and declaration make visible while remaining untrusted relative to the host (`README.md:10-14`; `requirements/security.md:111-117`). Process execution does not establish Interpretation, Agency, consciousness, or institutional Standing.

The **Linux kernel and rootless Podman** are external runtime dependencies. Kenogram observes aspects of their isolation but does not independently establish it (`requirements/security.md:111-117`). Exact TCP destinations and operator-facing loopback services participate in particular network paths.

A local world includes a materialized generation and its visible filesystem, processes, devices, credentials, routes, names, and services. Kenogram distinguishes the world-pattern from any one generation and says names and digests record addressing and provenance rather than an ontology of sameness (`docs/design.md:30-41`). Neither the local world nor its inhabitant is therefore promoted to an Organon Entity or World in this candidate.

## Load-bearing relations

### Declaration and application path

1. The operator supplies one declaration.
2. Kenogram parses and validates it, rejecting malformed input and unknown schema elements (`requirements/declaration.md:5-21`; `internal/app/app.go:207-232`).
3. Planning resolves paths, copies, mounts, network allowances, interfaces, and services, then computes canonical plan, declaration, and evidence digests (`internal/plan/plan.go:97-189`).
4. Before reviewed application, Kenogram acquires the world lock and recomputes the predecessor comparison. A changed snapshot, workspace, recovery state, or change list forces review again (`internal/app/app.go:239-289`).
5. Runtime preflight and inspection precede recording a generation as applied (`internal/app/app.go:248-266`; `docs/design.md:23-26`).

This is Kenogram's technical authority path. It does not establish an Organon Order, Principal, Standing relation, or institutional Authority.

### Replacement and recovery path

A successor is staged before its predecessor stops, but the two do not run concurrently over one workspace. The predecessor remains workspace authority while staging; after it stops, Kenogram captures and fsyncs the handoff tree before starting the successor. Failure restores the predecessor (`requirements/lifecycle.md:7-15`).

A durable transition record identifies rollback or commit direction. Recovery completes that direction idempotently before another generation is planned. During recovery, status preserves separate authoritative and candidate roles (`requirements/lifecycle.md:17-32`).

### Network path

A base world has loopback only, no resolver, no exterior route, and no direct UDP or exterior TCP path. Declared destinations create a host-held proxy door reachable on world loopback; the proxy resolves and dials only exact declared host-and-port pairs. Direct dialing remains unroutable, and proxy death or grant expiry restores closure (`requirements/network.md:9-27`).

The operator interface uses descriptor transfer in the opposite direction: it dials one exact declared loopback address in the authoritative generation without creating a host listener or general address primitive (`requirements/network.md:62-66`).

### Observation and verification path

Runtime inspection produces structured local observations. A governed-job result keeps target outcome, finalization, cleanup, stream retention, and reasons distinct (`internal/jobcontract/types.go:64-121`). The evidence directory is create-only, is never mounted into the target, and receives `manifest.json` last; failure before publication leaves no complete seal (`requirements/jobs.md:172-201`).

The offline verifier reopens descriptor-owned files, recomputes digests, validates typed documents, and cross-checks identities and runtime phases. It neither executes the target nor upgrades runtime-reported fields to host-observed facts (`requirements/jobs.md:239-269`). This is a strong local verification path, but the dossier does not identify the IndependentFor Witness, governing Order, Admissibility Rule, Admission, and Evidential Bearing required by Organon Evidence.

## Invariants and prohibited collapses

The load-bearing local invariants are:

- undeclared host access is rejected, and the runtime mount set and source identity are inspected (`README.md:33-39`);
- base networking has no exterior route or resolver, and admitted egress remains exact-destination proxying (`requirements/network.md:9-23`);
- a successor is inspected before becoming applied, with durable recovery direction across interruption (`requirements/lifecycle.md:7-23`);
- repeated application of one declaration must be observationally indistinguishable under the network invariant set (`requirements/network.md:23-31`);
- complete governed-job publication requires the final manifest seal and required runtime identities (`requirements/jobs.md:172-201`; `requirements/jobs.md:239-269`).

This ontology prohibits the following collapses:

1. **Operational absence is not Organon Absence.** A missing route, socket, mount, resolver, or capability is a represented condition inside a runtime field.
2. **A declaration is not institutional Authority.** It controls Kenogram's technical path but does not establish an Order, Principal, Standing, or CountsAs relation.
3. **`allow` is not Organon Permission.** Technical egress admission lacks the required institutional Grant and Admission chain.
4. **Runtime evidence is not automatically Organon Evidence.** Inspection, replay, hashing, and producer separation do not establish IndependentFor, institutional Admission, or Evidential Bearing by themselves.
5. **A generation is not the world as persistent substance.** The project treats it as one inscription and disclaims ontological identity from names or digests (`requirements/lifecycle.md:43-46`).
6. **Hash equality is not Truth or Entity identity.** Kenogram limits hash comparisons to provenance and conservative operational sameness (`docs/kenogrammatics.md:65-76`).
7. **A complete result is not successful, safe, true, or authorized by its producer.** Target lifecycle, finalization, cleanup, and observation completeness remain separate (`requirements/jobs.md:140-170`).
8. **The security contract is not proof of universal security.** Declared writable mounts and secrets cross the boundary intentionally, and kernel/runtime isolation remains a dependency (`requirements/security.md:62-80`; `requirements/security.md:111-117`).

## Organon mappings

`exact` would assert coextensive local and Organon meanings. `refinement` identifies a narrower local construction that satisfies the complete Organon constructor. `conflict` records incompatible load-bearing meanings. `unmapped` records a plausible target whose required packet is incomplete. Plausible analogy alone is not refinement. No exact mapping is promoted in this candidate.

| ID | Local term | Organon target | Classification | Disposition |
| --- | --- | --- | --- | --- |
| K1 | operational absence | `organon:Missingness` | refinement | promoted |
| K2 | version-1 declaration contract | `organon:Specification` | refinement | promoted |
| K3 | generation as an indexed runtime configuration | `organon:State` | refinement | promoted |
| K4 | successful replacement | `organon:Transformation` | refinement | promoted |
| K5 | required-observation world-pattern | `organon:Invariant` | refinement | promoted |
| K6 | hash-chained history record | `organon:Record` | refinement | promoted |
| K7 | local authority | `organon:Authority` | conflict | gated |
| K8 | `allow` / `revoke` | `organon:Permission` | conflict | gated |
| K9 | runtime evidence and tests | `organon:Evidence` | conflict | gated |
| K10 | world | `organon:World` | unmapped | gated |
| K11 | execution or security boundary | `organon:Boundary` | unmapped | gated |
| K12 | operator interface | `organon:Interface` | unmapped | gated |
| K13 | AI agent or world process | `organon:Agent` | unmapped | gated |

### K1 — operational absence refines Missingness

**Target claim:** A5. **Complete registry dependency:** `organon:Presence`.

- **Local bearer and scope:** a named declaration, network contract, or runtime observation field.
- **Expected or represented Presence:** a route, resolver, mount, socket, device, credential, capability, or destination path represented by that field.
- **Noncontainment witness:** declaration validation or runtime inspection records that the named item is not contained in the scoped configuration (`README.md:33-39`; `requirements/network.md:9-23`).
- **Dependency witness:** the declaration, observation, field, and recorded noncontainment are all present structures, satisfying the `organon:Presence` dependency.
- **Exclusion:** the mapping never applies to `organon:Absence`; it applies only to relational missingness in a named field.

### K2 — the version-1 declaration contract refines Specification

**Target claim:** D019. **Complete registry dependencies:** `organon:Representation`, `organon:Scope`.

- **Representation:** the version-1 grammar and schema restrictions represented by the declaration contract.
- **Denoted target:** conformity criteria for candidate Kenogram declaration bytes.
- **Scope:** exactly one UTF-8 version-1 declaration accepted by the documented TOML subset.
- **Constructive decision procedure:** parse, reject unknown or malformed constructs, validate schema and path constraints, and either return a prepared resolved plan or an error (`requirements/declaration.md:5-21`; `internal/app/app.go:207-232`).
- **Exclusion:** an individual declaration is not promoted merely because it was supplied; this mapping concerns the contract and its decision procedure.

### K3 — a generation as an indexed runtime configuration refines State

**Target claim:** D005. **Complete registry dependency:** `organon:Configuration`.

- **Configuration:** the material runtime realization with its image, namespaces, mounts, resources, services, and observed runtime fields (`internal/backend/backend.go:413-440`).
- **Ordering index:** the integer `g<N>` in `kenogram-<world>-g<N>` (`internal/backend/backend.go:158-159`).
- **Distinct-position witness:** predecessor, successor, authoritative, and candidate generations occupy distinct lifecycle positions (`requirements/lifecycle.md:25-32`).
- **Exclusion:** this does not establish an Organon Entity, persistence of a world identity, or equality between generations.

### K4 — successful replacement refines Transformation

**Target claim:** D007. **Complete registry dependencies:** `organon:Relation`, `organon:State`, `organon:Direction`.

- **Input State:** the predecessor generation configuration under K3.
- **Output State:** the verified successor generation configuration under K3.
- **Relation:** the replacement operation joins predecessor and successor through staged materialization, workspace handoff, verification, and durable recording.
- **Direction:** the successful cutover orders predecessor before successor; rollback is a different recovery path and is not silently treated as the same direction.
- **Witness:** the successor is staged and verified before being recorded as applied, while transition state names rollback or commit direction (`requirements/lifecycle.md:7-23`).
- **Exclusion:** failed staging, unresolved recovery, or rollback alone is not an instance of this promoted successful-replacement mapping.

### K5 — the required-observation world-pattern refines Invariant

**Target claim:** D011. **Complete registry dependencies:** `organon:Relation`, `organon:Configuration`, `organon:Transformation`.

- **Preserved Configuration:** the finite required-observation contract, including the named runtime acceptance relations rather than implementation bytes or structure.
- **Named Transformations:** successful replacement under K4 and repeated application of one declaration.
- **Preservation witness:** replacement may change the material inscription while preserving required observations, and reapplication must remain indistinguishable under the network invariant set (`docs/kenogrammatics.md:50-56`; `requirements/network.md:23-31`).
- **Exclusion:** this mapping is limited to the declared finite observation contract. It does not establish formal morphic bisimulation, complete behavioral equivalence, or Entity identity.

### K6 — a hash-chained history record refines Record

**Target claim:** D028. **Complete registry dependencies:** `organon:Persistence`, `organon:Representation`, `organon:State`, `organon:Relation`, `organon:Change`.

- **Representation:** one JSON history entry containing timestamp, action, declaration and plan digests, workspace digest, outcome, detail, previous hash, and current hash.
- **Denoted target:** the completed operation or transition Change and its associated operational State.
- **Relation witness:** `PreviousHash` joins the entry to the immediately preceding verified history entry.
- **Persistence witness:** the entry is appended, the file is fsynced, and subsequent entries retain the preceding hash (`internal/history/history.go:18-29`; `internal/history/history.go:42-70`).
- **Exclusion:** the record supplies provenance and retained history, not Truth, independent Evidence, a Ledger, or institutional Admission.

### Gated conflicts and unmapped correspondences

- **K7 — conflict:** Kenogram's declaration and transition authority controls technical application and current-generation selection. Organon Authority is an Order-indexed relation involving an Agent, Actions, CountsAs, a Principal, and Scope. The local meaning deliberately lacks that institutional constructor (`docs/design.md:11-14`; `requirements/lifecycle.md:25-32`).
- **K8 — conflict:** local `allow` and `revoke` change live egress policy. Organon Permission requires a Permission Claim, valid Grant, Admission, governing Order, Principal, Agent, Scope, and interval. The local operations cannot be renamed into that chain (`README.md:16-21`; `requirements/network.md:25-27`).
- **K9 — conflict:** Kenogram uses evidence for structured observations, tests, and sealed replay material. Organon Evidence additionally requires an Observation produced by an IndependentFor Witness and admitted by an Order under an Admissibility Rule; supportive or defeating use requires Evidential Bearing. The repository also warns that self-reported provenance is not self-qualification (`README.md:120-133`; `requirements/provenance.md:29-32`).
- **K10 — unmapped:** the local world is a rootless Linux environment, but an Organon World requires established Entities, participant-available causal paths, named Constraints, and a common Invariant across access paths. K5 supplies only a finite replacement invariant, not the whole packet (`docs/design.md:6-9`; `docs/design.md:30-41`).
- **K11 — unmapped:** the execution boundary has documented constraints and observations, but Organon Boundary must be indexed to an Entity identity Invariant and its preserving or identity-crossing Transformations. No such Entity packet is promoted (`README.md:27-47`; `requirements/security.md:111-117`).
- **K12 — unmapped:** the operator interface explicitly represents one permitted descriptor-transfer path, but Organon Interface is a Boundary coordinated between established Entities. The endpoint mechanism is documented; the Entity and Boundary dependencies remain open (`internal/decl/types.go:57-62`; `requirements/network.md:62-66`).
- **K13 — unmapped:** the repository's AI agent and world process labels establish process roles, not an Organon Agent. Entity identity, Interpretation, and evidence that Interpretation conditions Action are absent (`README.md:7-25`; `requirements/security.md:111-117`).

## Boundary cases

- A failed direct TCP connection can witness local network nonavailability and K1 Missingness. It does not witness absolute Absence, universal isolation, or security against kernel escape.
- A successor container that starts but has not passed inspection is a candidate generation, not an applied successor. It can instantiate K3 as an indexed configuration without completing K4.
- A rollback after failed replacement is a recorded recovery path. It is not the successful predecessor-to-successor Direction used by K4.
- Two generations can satisfy K5 while differing in image structure, runtime identifiers, or bytes. Conversely, equal names or digests do not establish K5 without the required observations.
- A declaration digest records which bytes were read, and a plan digest fingerprints resolved intent. Neither digest creates Truth, Entity identity, or institutional Authority (`docs/kenogrammatics.md:65-76`).
- A governed-job manifest can be locally complete and replayable while remaining a producer artifact rather than Organon Evidence. Completeness does not supply an IndependentFor Witness or admitting Order.
- A target result marked `unknown` preserves missing outcome information rather than inventing success or failure; a missing seal cannot be upgraded to a complete job (`requirements/jobs.md:151-178`).
- A named loopback operator interface exposes one declared byte stream. It does not supply a general host-to-world network relation or, without K11 and participant Entity packets, an Organon Interface.

## Uncertainties and promotion gates

The following gates must be resolved from a later pinned snapshot before promotion:

1. **Institutional packet:** K7 or K8 would require a named Order, Rule, Scope, Principal, Agent, Standing or CountsAs path, authorized Grant, and Admission. Technical configuration control is insufficient.
2. **Evidence packet:** K9 would require a claimant and Claim, a distinct Witness, the relevant Observation path, mechanical and institutional independence, an Admissibility Rule, governing Order, Admission, and any claimed Evidential Bearing disposition.
3. **Entity and World packet:** K10, K11, and K12 require explicit identity Invariants, ordered States, Persistence witnesses, Entity-indexed Constraints, participating Entities, and scoped causal access paths.
4. **Agent packet:** K13 requires a persistent Entity whose Interpretation demonstrably conditions which Action occurs. Process naming or successful command execution is insufficient.
5. **Security scope:** broader security claims require evidence beyond the repository's stated rootless Podman and Linux assumptions and must preserve the explicit exclusions for declared secrets, writable mounts, admitted destinations, hostile hosts, and runtime escape.
6. **Apple runtime:** the repository says the experimental launcher is not macOS runtime support and leaves lifecycle and network evidence open (`README.md:64-67`). No cross-platform boundary mapping is promoted.

Review this ontology again if the repository changes the declaration schema, replacement authority model, network invariant set, runtime provider assumptions, governed-job evidence contract, verifier independence model, or meaning of world, generation, authority, evidence, or interface. A branch move without the pinned commit does not update this candidate.

<!-- organon:mapping-manifest -->
```yaml
schema_version: 1
project: Kenogram
commit: 8c00104bb4b666d844715bf9840634cf92e571e2
mappings:
  - mapping_id: K1
    local_term: 'operational absence'
    organon_id: 'organon:Missingness'
    target_claim: A5
    classification: refinement
    status: promoted
    dependencies:
      - 'organon:Presence'
    packet:
      scope: 'A named declaration, contract, or inspected runtime field.'
      witness: 'The field represents or expects a named route, resolver, mount, socket, device, credential, or capability and records that it is not contained.'
      exclusion: 'Never licenses organon:Absence.'
    evidence:
      - 'README.md:33-39'
      - 'requirements/network.md:9-23'
  - mapping_id: K2
    local_term: 'version-1 declaration contract'
    organon_id: 'organon:Specification'
    target_claim: D019
    classification: refinement
    status: promoted
    dependencies:
      - 'organon:Representation'
      - 'organon:Scope'
    packet:
      representation: 'The represented version-1 grammar and schema restrictions.'
      scope: 'Candidate bytes for exactly one UTF-8 Kenogram version-1 declaration.'
      decision_procedure: 'Parse, reject unsupported or malformed structures, validate constraints, and return a prepared plan or error.'
      exclusion: 'Supplying an individual declaration does not itself establish this mapping.'
    evidence:
      - 'requirements/declaration.md:5-21'
      - 'internal/app/app.go:207-232'
  - mapping_id: K3
    local_term: 'generation as an indexed runtime configuration'
    organon_id: 'organon:State'
    target_claim: D005
    classification: refinement
    status: promoted
    dependencies:
      - 'organon:Configuration'
    packet:
      configuration: 'The material runtime realization and its observed image, namespace, mount, resource, and service fields.'
      index: 'The integer N in kenogram-<world>-g<N>.'
      exclusion: 'Does not establish Entity identity or persistence of a world.'
    evidence:
      - 'internal/backend/backend.go:158-159'
      - 'internal/backend/backend.go:413-440'
      - 'requirements/lifecycle.md:25-32'
  - mapping_id: K4
    local_term: 'successful replacement'
    organon_id: 'organon:Transformation'
    target_claim: D007
    classification: refinement
    status: promoted
    dependencies:
      - 'organon:Relation'
      - 'organon:State'
      - 'organon:Direction'
    packet:
      input_state: 'The predecessor generation configuration under K3.'
      output_state: 'The verified successor generation configuration under K3.'
      direction: 'Successful cutover from predecessor to successor; rollback is a distinct recovery path.'
      exclusion: 'Failed staging and unresolved recovery are outside this promoted mapping.'
    evidence:
      - 'docs/design.md:11-14'
      - 'requirements/lifecycle.md:7-23'
  - mapping_id: K5
    local_term: 'required-observation world-pattern'
    organon_id: 'organon:Invariant'
    target_claim: D011
    classification: refinement
    status: promoted
    dependencies:
      - 'organon:Relation'
      - 'organon:Configuration'
      - 'organon:Transformation'
    packet:
      preserved_configuration: 'The finite required-observation contract and its named acceptance relations.'
      transformations: 'Successful replacement and repeated application of one declaration.'
      exclusion: 'No formal morphic bisimulation, complete behavioral equivalence, or Entity identity follows.'
    evidence:
      - 'docs/kenogrammatics.md:50-56'
      - 'requirements/network.md:23-31'
  - mapping_id: K6
    local_term: 'hash-chained history record'
    organon_id: 'organon:Record'
    target_claim: D028
    classification: refinement
    status: promoted
    dependencies:
      - 'organon:Persistence'
      - 'organon:Representation'
      - 'organon:State'
      - 'organon:Relation'
      - 'organon:Change'
    packet:
      representation: 'A JSON entry carrying operation, digest, outcome, detail, previous-hash, and current-hash fields.'
      target: 'The completed operation or transition Change and associated operational State.'
      persistence: 'Append, fsync, and retention through the next entry previous-hash relation.'
      exclusion: 'Does not establish Truth, independent Evidence, Ledger, or Admission.'
    evidence:
      - 'internal/history/history.go:18-29'
      - 'internal/history/history.go:42-70'
  - mapping_id: K7
    local_term: 'local authority'
    organon_id: 'organon:Authority'
    target_claim: D052
    classification: conflict
    status: gated
    missing_dependencies:
      - 'organon:Order'
      - 'organon:Agent'
      - 'organon:Action'
      - 'organon:CountsAs'
      - 'organon:Principal'
      - 'organon:Scope'
    rationale: 'Kenogram authority is technical configuration and transition control, not an Order-indexed institutional relation.'
    evidence:
      - 'docs/design.md:11-14'
      - 'requirements/lifecycle.md:25-32'
  - mapping_id: K8
    local_term: 'allow / revoke'
    organon_id: 'organon:Permission'
    target_claim: D057
    classification: conflict
    status: gated
    missing_dependencies:
      - 'organon:Order'
      - 'organon:PermissionClaim'
      - 'organon:Grant'
      - 'organon:Admission'
      - 'organon:Principal'
      - 'organon:Agent'
      - 'organon:Scope'
    rationale: 'The commands alter live TCP policy without an institutional Grant and Admission chain.'
    evidence:
      - 'README.md:16-21'
      - 'requirements/network.md:25-27'
  - mapping_id: K9
    local_term: 'runtime evidence and tests'
    organon_id: 'organon:Evidence'
    target_claim: D066
    classification: conflict
    status: gated
    missing_dependencies:
      - 'organon:Observation'
      - 'organon:Witness'
      - 'organon:IndependentFor'
      - 'organon:Claim'
      - 'organon:Order'
      - 'organon:AdmissibilityRule'
      - 'organon:Admission'
    rationale: 'Local inspection and replay artifacts do not supply the complete independent and institutional Evidence constructor.'
    evidence:
      - 'README.md:120-133'
      - 'requirements/jobs.md:239-258'
      - 'requirements/provenance.md:29-32'
  - mapping_id: K10
    local_term: 'world'
    organon_id: 'organon:World'
    target_claim: D083
    classification: unmapped
    status: gated
    missing_dependencies:
      - 'organon:Entity'
      - 'organon:CausalPath'
      - 'organon:Constraint'
      - 'organon:Invariant'
      - 'organon:Persistence'
      - 'organon:Scope'
    rationale: 'The local Linux environment does not yet carry the required participant Entity and common-access-path packet.'
    evidence:
      - 'docs/design.md:6-9'
      - 'docs/design.md:30-41'
  - mapping_id: K11
    local_term: 'execution or security boundary'
    organon_id: 'organon:Boundary'
    target_claim: D015
    classification: unmapped
    status: gated
    missing_dependencies:
      - 'organon:Entity'
      - 'organon:Invariant'
      - 'organon:Persistence'
      - 'organon:Constraint'
    rationale: 'Documented isolation constraints are not indexed to a promoted Entity identity Invariant.'
    evidence:
      - 'README.md:27-47'
      - 'requirements/security.md:111-117'
  - mapping_id: K12
    local_term: 'operator interface'
    organon_id: 'organon:Interface'
    target_claim: D042
    classification: unmapped
    status: gated
    missing_dependencies:
      - 'organon:Boundary'
      - 'organon:Entity'
      - 'organon:Transformation'
      - 'organon:Representation'
    rationale: 'The explicit descriptor-transfer mechanism is documented, but participating Entities and an Entity-indexed Boundary are not established.'
    evidence:
      - 'internal/decl/types.go:57-62'
      - 'requirements/network.md:62-66'
  - mapping_id: K13
    local_term: 'AI agent or world process'
    organon_id: 'organon:Agent'
    target_claim: D035
    classification: unmapped
    status: gated
    missing_dependencies:
      - 'organon:Entity'
      - 'organon:Interpretation'
      - 'organon:Action'
    rationale: 'Process execution and project labeling do not show a persistent Entity whose Interpretation conditions Action.'
    evidence:
      - 'README.md:7-25'
      - 'requirements/security.md:111-117'
```
