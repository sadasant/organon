---
type: project-ontology-source-dossier
project: Kenogram
commit: 8c00104bb4b666d844715bf9840634cf92e571e2
generated_from: exact cited line ranges with two lines of context
---

# Kenogram Source Dossier

Every excerpt is copied from the exact public source commit above. Line numbers preserve upstream coordinates.

## `README.md`

### Lines 5-49

```text
00005 | # Kenogram
00006 |
00007 | Kenogram lets you give an agent a whole small computer without giving it your
00008 | computer.
00009 |
00010 | Kenogram materializes rootless Linux worlds for AI agents from host-authored
00011 | declarations. A declaration selects the image and admits host files, mounts,
00012 | secrets, resource limits, durable TCP destinations, and named loopback
00013 | interfaces. Kenogram adds no ambient host filesystem access; the inhabitant may
00014 | freely use what the image and declaration make available.
00015 |
00016 | Anything admitted into an AI's context can change what follows. Ambient
00017 | capabilities determine what that changed agent can affect. Kenogram limits
00018 | those consequences structurally: ambient capability is absent unless the host
00019 | operator admits it explicitly. Requests expressed through terminal interaction
00020 | do not change world authority. Applying a declaration grants durable authority;
00021 | `allow` can grant time-bounded TCP egress.
00022 |
00023 | Kenogram is for developers, security teams, and platform operators who want a
00024 | tool-using agent to have a useful environment without inheriting the
00025 | operator's ambient computer.
00026 |
00027 | ## Security boundary
00028 |
00029 | Kenogram is an execution boundary for untrusted agent processes, not a prompt
00030 | filter. It makes admitted host authority explicit and inspects the resulting
00031 | runtime before starting declared services.
00032 |
00033 | | Condition | Enforced observation |
00034 | |---|---|
00035 | | Host access | Undeclared mounts are rejected. The exact declared mount set and bind-source filesystem identity are verified, and no host container-runtime control socket is mounted. |
00036 | | Network | A base world is loopback-only, with no working resolver or exterior TCP/UDP route. Declared or temporarily granted TCP destinations pass through a host-held exact-destination proxy; direct IP dialing remains unroutable. |
00037 | | Runtime | Rootless execution, private network/PID/IPC/UTS namespaces, an empty capability bounding set, `no-new-privileges`, active seccomp, no added devices, and CPU/memory/PID limits are inspected before services start. |
00038 | | Authority | The host-authored declaration admits durable capabilities; an explicit, time-bounded `allow` command may grant temporary TCP egress. A named operator interface reaches one declared world-loopback service without publishing a host port. |
00039 | | Replacement | A successor is inspected before it is recorded as applied. Durable transition state identifies the authoritative generation after interruption. |
00040 |
00041 | This constrains what a compromised or prompt-contaminated agent can reach. It
00042 | does not detect or prevent prompt injection, protect declared writable mounts
00043 | or secrets from world processes, prevent exfiltration to a destination the
00044 | operator admits, or authenticate, encrypt, authorize, or interpret
00045 | `kenogram connect` traffic. Kenogram relies on the Linux kernel and rootless
00046 | Podman and does not claim to harden a hostile multi-tenant host or independently
00047 | prevent a kernel or runtime escape.
00048 |
00049 | The [security contract](requirements/security.md), [network
```

### Lines 53-72

```text
00053 | compliance or certification for that system.
00054 |
00055 | ## Status and supported runtime
00056 |
00057 | [Kenogram v0.1.1](https://github.com/idolum-ai/kenogram/releases/tag/v0.1.1)
00058 | is evaluation software and does not make a production-stability claim. Release
00059 | binaries support Linux on amd64 and arm64. The runtime exercised in mandatory
00060 | CI requires rootless Podman on cgroups v2, `nsenter`, and subordinate UID/GID
00061 | ranges for the current user. Kenogram fails closed rather than weakening the
00062 | boundary when those prerequisites are absent.
00063 |
00064 | The [experimental Apple container-machine
00065 | launcher](docs/apple-container-machine.md) transports explicit operations into
00066 | an operator-managed Linux machine. It is not macOS runtime support; the real
00067 | Apple-machine lifecycle and network evidence remains open.
00068 |
00069 | The Kenogram binary has no third-party Go modules. Operation still depends on
00070 | the Linux kernel, rootless Podman, cgroups v2, and `nsenter`.
00071 |
00072 | ## Install and start one world
```

### Lines 116-135

```text
00116 | Outcomes are Kenogram-derived bounded observations, not authority.
00117 |
00118 | ## Proof, not promises
00119 |
00120 | Requirements are binding contracts; tests are evidence. The [evidence
00121 | table](requirements/INDEX.md#evidence-and-known-limits) separates what is
00122 | exercised today from the next proof and labels each open boundary as accepted
00123 | for v0.x, required before a stable claim, or experimental.
00124 |
00125 | | Boundary | Evidence earned | Explicit limit |
00126 | |---|---|---|
00127 | | [Runtime isolation](requirements/security.md) | Mandatory rootless-Podman CI inspects namespaces, mount identity, seccomp, resource limits, and absence of the runtime socket. | No supported Podman/kernel matrix or seccomp-profile identity yet. |
00128 | | [Network absence](requirements/network.md) | Real-runtime CI exercises loopback-only networking, failed direct TCP/UDP/DNS, exact proxy admission, revoke/expiry, proxy-death closure, and a declared SSH interface without a host listener. | The full ten-invariant replay after every adoption path remains open. |
00129 | | [Replacement recovery](requirements/lifecycle.md) | A fresh process recovers persisted runtime state across fourteen injected `SIGKILL` boundaries. | Process-crash evidence is not syscall-granular power-loss proof across filesystems. |
00130 | | [Compositions](docs/compositions/README.md) | Pinned Engram, OpenClaw, and Hermes artifacts and a real OpenSSH client/server path are exercised end to end. | Model and Telegram services are deterministic local fixtures in pull-request CI; real Telegram is a protected operator-assisted canary. |
00131 |
00132 | These are automated, replayable compatibility and boundary observations, not
00133 | endorsements, universal compatibility claims, or a production-stability claim.
00134 |
00135 | ## Choose an evaluation path
```

### Lines 186-199

```text
00186 | engineering analogy, and its limits.
00187 |
00188 | ## Project paths
00189 |
00190 | - [Requirements and evidence](requirements/)
00191 | - [Declaration schema](requirements/declaration.md)
00192 | - [Operations and recovery](requirements/operations.md)
00193 | - [Governed-job guide](docs/governed-jobs.md) and
00194 |   [evidence contract](requirements/jobs.md) — bounded direct Linux execution,
00195 |   create-only evidence, and offline verification.
00196 | - [Contributing and evidence replay](CONTRIBUTING.md)
00197 | - [Security policy and private reporting](.github/SECURITY.md)
00198 | - [Release and immutable-publication contract](docs/release-strategy.md)
00199 | - [MIT License](LICENSE)
```


## `docs/design.md`

### Lines 1-43

```text
00001 | # Kenogram design
00002 |
00003 | Status: binding design. Observable implementation status is recorded in the
00004 | requirements index.
00005 |
00006 | Kenogram writes worlds; it never decides them. A world is a rootless Linux
00007 | environment materialized from one host-authored declaration. The inhabitant owns
00008 | everything visible within it. Undeclared paths, processes, devices, credentials,
00009 | routes, and names are absent.
00010 |
00011 | The declaration is the sole authority input. Requests emitted through a terminal
00012 | are prose, not protocol. A person decides by editing the declaration on the host
00013 | and invoking Kenogram. Replacement is the universal change mechanism: workspace
00014 | data is carried and digested; configuration is regenerated.
00015 |
00016 | Networking begins with a namespace containing loopback and no exterior route or
00017 | resolver. Declared destinations add one visible object: a host-held TCP proxy
00018 | socket bound on the world's loopback. The proxy resolves and dials exact declared
00019 | name-and-port pairs. The implementation transfers that listener descriptor from
00020 | a short-lived namespace helper to the host proxy; no route or in-world forwarder
00021 | is created.
00022 |
00023 | The implementation advances only through observable contracts. In particular,
00024 | no world is called applied until runtime evidence has been inspected, and no
00025 | network mechanism is accepted until all invariants in `requirements/network.md`
00026 | pass against the real rootless runtime boundary.
00027 |
00028 | ## Name and conceptual lineage
00029 |
00030 | Kenogram takes its name from Rudolf Kaehr's account of kenograms and
00031 | morphograms, where the identities of particular marks recede and their pattern
00032 | of differences is what matters. Kenogram does not implement that formalism. It
00033 | adapts one methodological posture: a world is specified by an observable
00034 | pattern, while any mechanism that preserves the required observations is an
00035 | acceptable realization of that pattern.
00036 |
00037 | In this analogy, a declaration describes a world-pattern and a generation is
00038 | one material inscription of it. Replacement may change the inscription without
00039 | changing the observations that define the world. Names, declaration digests,
00040 | plan digests, and workspace digests remain essential operational evidence, but
00041 | they record addressing and provenance rather than an ontology of sameness.
00042 |
00043 | "Absence precedes denial" belongs to Kenogram's own security design. It is not
```


## `docs/kenogrammatics.md`

### Lines 42-86

```text
00042 | decomposition, not identities carried between marks.
00043 |
00044 | ## The engineering adaptation
00045 |
00046 | Kenogram is a Linux world provisioner, not a morphogrammatic calculus. Its name
00047 | commits the project to a methodological analogy rather than a one-to-one formal
00048 | translation:
00049 |
00050 | - A declaration specifies an observable world-pattern.
00051 | - A generation is one material inscription of that pattern.
00052 | - Replacement may change the inscription while preserving the required
00053 |   observations.
00054 | - Runtime invariants judge realizations by behavior, not by an implementation's
00055 |   internal identity. Conforming mechanisms satisfy the same finite observation
00056 |   contract; Kenogram makes no claim of equivalence beyond that contract.
00057 | - The provisioner contributes no request or policy authority from inside the
00058 |   world. It faithfully materializes the host-authored declaration.
00059 |
00060 | This posture is most concrete in the network contract. A mechanism is acceptable
00061 | only if the same absence, visibility, reachability, and failure observations
00062 | hold at the real runtime boundary. The invariant set is deliberately more
00063 | normative than the mechanism used to satisfy it.
00064 |
00065 | ## Provenance is not ontology
00066 |
00067 | Kenogram deliberately computes exact hashes. The declaration digest proves
00068 | which input bytes were read; the plan digest fingerprints the resolved semantic
00069 | plan; workspace and history digests carry evidence across replacement. Exact
00070 | plan-fingerprint equality is also used for safe operational adoption.
00071 |
00072 | Those comparisons establish provenance and conservative operational sameness.
00073 | They do not claim that hashes define what a world ultimately *is*. Two mechanisms
00074 | or generations may differ in bytes and structure while satisfying the same
00075 | observable contract. Conversely, a matching label without matching evidence is
00076 | not enough to adopt runtime state.
00077 |
00078 | ## Where the analogy stops
00079 |
00080 | Kenogram retains stable names, sequential generations, cryptographic hashes,
00081 | host-authored declarations, and ordinary Boolean validation. It defines no
00082 | morphogrammatic operators, retrograde continuations, or formal morphic
00083 | bisimulation. Terms such as *world-pattern* and *inscription* in this repository
00084 | are disciplined analogies, not claims of formal equivalence with Kaehr's
00085 | system.
00086 |
```


## `internal/app/app.go`

### Lines 153-190

```text
00153 | }
00154 |
00155 | // UpComparison is the complete predecessor evidence rendered before an up.
00156 | // The snapshot is opaque to callers; UpReviewed revalidates it under the world
00157 | // mutation lock so the authority reviewed by an operator cannot change between
00158 | // review and application.
00159 | type UpComparison struct {
00160 | 	Changes         []plan.Change
00161 | 	Workspace       string
00162 | 	snapshot        string
00163 | 	recoveryPending bool
00164 | 	workspaceRoot   string
00165 | 	workspaceMode   string
00166 | }
00167 |
00168 | const (
00169 | 	workspaceModeEmpty  = "empty"
00170 | 	workspaceModeExact  = "exact"
00171 | 	workspaceModeActive = "active"
00172 | )
00173 |
00174 | // GenerationObservation keeps recorded authority distinct from runtime
00175 | // observation. A missing runtime is evidence too, so Exists is explicit.
00176 | type GenerationObservation struct {
00177 | 	State    worldfs.State     `json:"state"`
00178 | 	Exists   bool              `json:"runtime_exists"`
00179 | 	Evidence *backend.Evidence `json:"runtime_evidence,omitempty"`
00180 | }
00181 |
00182 | // StatusResult reports transition authority without hiding the generation that
00183 | // is being committed or rolled back.
00184 | type StatusResult struct {
00185 | 	Authoritative *GenerationObservation `json:"authoritative,omitempty"`
00186 | 	Candidate     *GenerationObservation `json:"candidate,omitempty"`
00187 | 	RecoveryPhase string                 `json:"recovery_phase,omitempty"`
00188 | }
00189 |
00190 | type NetworkDiagnosticsResult struct {
```

### Lines 205-234

```text
00205 | }
00206 |
00207 | func Prepare(path string) (Prepared, error) {
00208 | 	raw, err := os.ReadFile(path)
00209 | 	if err != nil {
00210 | 		return Prepared{}, fmt.Errorf("read declaration: %w", err)
00211 | 	}
00212 | 	return PrepareBytes(raw, path)
00213 | }
00214 | func PrepareBytes(raw []byte, path string) (Prepared, error) {
00215 | 	return PrepareBytesContext(context.Background(), raw, path)
00216 | }
00217 |
00218 | // PrepareBytesContext threads cancellation through source-tree validation and
00219 | // digest work while preserving the ordinary preparation API.
00220 | func PrepareBytesContext(ctx context.Context, raw []byte, path string) (Prepared, error) {
00221 | 	if err := ctx.Err(); err != nil {
00222 | 		return Prepared{}, err
00223 | 	}
00224 | 	d, err := decl.Parse(raw)
00225 | 	if err != nil {
00226 | 		return Prepared{}, fmt.Errorf("parse declaration: %w", err)
00227 | 	}
00228 | 	result, err := plan.BuildContext(ctx, d, path, raw)
00229 | 	if err != nil {
00230 | 		return Prepared{}, fmt.Errorf("validate declaration: %w", err)
00231 | 	}
00232 | 	return Prepared{raw, d, result, path}, nil
00233 | }
00234 |
```

### Lines 237-291

```text
00237 | }
00238 |
00239 | // UpReviewed applies a prepared declaration only while the predecessor
00240 | // evidence still matches a comparison acquired with CompareUp.
00241 | func (a *App) UpReviewed(ctx context.Context, prepared Prepared, comparison UpComparison) error {
00242 | 	if comparison.snapshot == "" {
00243 | 		return fmt.Errorf("reviewed comparison snapshot is empty")
00244 | 	}
00245 | 	return a.up(ctx, prepared, &comparison)
00246 | }
00247 |
00248 | func (a *App) up(ctx context.Context, prepared Prepared, reviewed *UpComparison) (retErr error) {
00249 | 	if err := validatePreparedIntegrity(prepared); err != nil {
00250 | 		return fmt.Errorf("validate prepared candidate: %w", err)
00251 | 	}
00252 | 	if err := naming.World(prepared.Result.Plan.Name); err != nil {
00253 | 		return err
00254 | 	}
00255 | 	if err := a.Backend.Preflight(ctx); err != nil {
00256 | 		return fmt.Errorf("runtime preflight: %w", err)
00257 | 	}
00258 | 	l := worldfs.For(a.BaseDir, prepared.Result.Plan.Name)
00259 | 	if err := l.Ensure(); err != nil {
00260 | 		return err
00261 | 	}
00262 | 	lock, err := lockfile.Acquire(l.Lock)
00263 | 	if err != nil {
00264 | 		return err
00265 | 	}
00266 | 	defer lock.Release()
00267 | 	if reviewed != nil {
00268 | 		current, compareErr := a.CompareUpContext(ctx, prepared)
00269 | 		if compareErr != nil {
00270 | 			return fmt.Errorf("revalidate reviewed comparison: %w", compareErr)
00271 | 		}
00272 | 		if current.snapshot != reviewed.snapshot || current.recoveryPending != reviewed.recoveryPending ||
00273 | 			!slices.Equal(current.Changes, reviewed.Changes) || current.Workspace != reviewed.Workspace {
00274 | 			return fmt.Errorf("reviewed predecessor evidence changed; review the plan again")
00275 | 		}
00276 | 		*reviewed = current
00277 | 	}
00278 | 	if err := a.recoverTransition(ctx, l); err != nil {
00279 | 		return fmt.Errorf("recover interrupted transition: %w", err)
00280 | 	}
00281 | 	if reviewed != nil && reviewed.recoveryPending {
00282 | 		recovered, compareErr := a.CompareUpContext(ctx, prepared)
00283 | 		if compareErr != nil {
00284 | 			return fmt.Errorf("compare recovered predecessor: %w", compareErr)
00285 | 		}
00286 | 		if !slices.Equal(recovered.Changes, reviewed.Changes) || recovered.Workspace != reviewed.Workspace {
00287 | 			return fmt.Errorf("transition recovery changed predecessor evidence; review the plan again")
00288 | 		}
00289 | 		*reviewed = recovered
00290 | 	}
00291 | 	prior, priorErr := l.ReadState()
```


## `internal/backend/backend.go`

### Lines 156-162

```text
00156 | 	}
00157 | }
00158 | func ContainerName(world string, generation int64) string {
00159 | 	return fmt.Sprintf("kenogram-%s-g%d", world, generation)
00160 | }
00161 |
00162 | func (p *Podman) Preflight(ctx context.Context) error {
```

### Lines 411-455

```text
00411 | }
00412 |
00413 | type Evidence struct {
00414 | 	ID                     string
00415 | 	Name                   string
00416 | 	Running                bool
00417 | 	PID                    int
00418 | 	ProcessStart           string
00419 | 	ImageReference         string
00420 | 	ImageDigest            string
00421 | 	NetworkMode            string
00422 | 	IPCMode                string
00423 | 	IPCIsolatedFromHost    bool
00424 | 	PIDMode                string
00425 | 	UTSMode                string
00426 | 	UserNSMode             string
00427 | 	User                   string
00428 | 	Hostname               string
00429 | 	WorkingDir             string
00430 | 	CapDrop                []string
00431 | 	BoundingCaps           []string
00432 | 	SecurityOpt            []string
00433 | 	SeccompMode            int
00434 | 	Devices                int
00435 | 	UIDMap                 []IDMap
00436 | 	GIDMap                 []IDMap
00437 | 	Labels                 map[string]string
00438 | 	Mounts                 []EvidenceMount
00439 | 	Memory, NanoCPUs, PIDs int64
00440 | }
00441 | type IDMap struct {
00442 | 	ContainerID int64
00443 | 	HostID      int64
00444 | 	Size        int64
00445 | }
00446 | type EvidenceMount struct {
00447 | 	Source           string
00448 | 	Destination      string
00449 | 	RW               bool
00450 | 	Mode             string
00451 | 	Options          []string
00452 | 	IdentityVerified bool
00453 | }
00454 | type inspectDocument struct {
00455 | 	ID           string   `json:"Id"`
```


## `internal/decl/types.go`

### Lines 1-69

```text
00001 | package decl
00002 |
00003 | // Declaration is schema version 1 of a Kenogram world declaration.
00004 | type Declaration struct {
00005 | 	Version       int64
00006 | 	Name          string
00007 | 	AllowUnpinned bool
00008 | 	World         World
00009 | 	Resources     Resources
00010 | 	Workspace     Workspace
00011 | 	Copies        []Copy
00012 | 	Mounts        []Mount
00013 | 	Network       Network
00014 | 	Interfaces    []Interface
00015 | 	Services      []Service
00016 | }
00017 |
00018 | type World struct {
00019 | 	Hostname string
00020 | 	Base     string
00021 | 	Workdir  string
00022 | 	User     string
00023 | }
00024 |
00025 | type Resources struct {
00026 | 	CPUs        int64
00027 | 	MemoryBytes int64
00028 | 	PIDs        int64
00029 | }
00030 |
00031 | type Workspace struct {
00032 | 	Paths []string
00033 | }
00034 |
00035 | type Copy struct {
00036 | 	Source string
00037 | 	Target string
00038 | 	Mode   string
00039 | 	Secret bool
00040 | }
00041 |
00042 | type Mount struct {
00043 | 	Source string
00044 | 	Target string
00045 | 	Mode   string
00046 | }
00047 |
00048 | type Network struct {
00049 | 	Allow []NetworkAllow
00050 | }
00051 |
00052 | type NetworkAllow struct {
00053 | 	Host string
00054 | 	Port int64
00055 | }
00056 |
00057 | // Interface names an operator-facing byte stream whose listener remains on
00058 | // loopback inside the world's otherwise isolated network namespace.
00059 | type Interface struct {
00060 | 	Name    string
00061 | 	Address string
00062 | }
00063 |
00064 | type Service struct {
00065 | 	Name      string
00066 | 	Command   []string
00067 | 	Autostart bool
00068 | 	Restart   string
00069 | }
```


## `internal/history/history.go`

### Lines 1-95

```text
00001 | // Package history owns the fsync'd, hash-chained per-world history.
00002 | package history
00003 |
00004 | import (
00005 | 	"bufio"
00006 | 	"context"
00007 | 	"crypto/sha256"
00008 | 	"encoding/hex"
00009 | 	"encoding/json"
00010 | 	"errors"
00011 | 	"fmt"
00012 | 	"os"
00013 | 	"path/filepath"
00014 | 	"strings"
00015 | 	"time"
00016 | )
00017 |
00018 | type Record struct {
00019 | 	Timestamp         string   `json:"timestamp"`
00020 | 	Action            string   `json:"action"`
00021 | 	PlanDigest        string   `json:"plan_digest,omitempty"`
00022 | 	DeclarationDigest string   `json:"declaration_digest,omitempty"`
00023 | 	ImageDigests      []string `json:"image_digests,omitempty"`
00024 | 	WorkspaceDigest   string   `json:"workspace_digest,omitempty"`
00025 | 	Outcome           string   `json:"outcome"`
00026 | 	Detail            string   `json:"detail,omitempty"`
00027 | 	PreviousHash      string   `json:"previous_hash,omitempty"`
00028 | 	Hash              string   `json:"hash"`
00029 | }
00030 | type unsigned struct {
00031 | 	Timestamp         string   `json:"timestamp"`
00032 | 	Action            string   `json:"action"`
00033 | 	PlanDigest        string   `json:"plan_digest,omitempty"`
00034 | 	DeclarationDigest string   `json:"declaration_digest,omitempty"`
00035 | 	ImageDigests      []string `json:"image_digests,omitempty"`
00036 | 	WorkspaceDigest   string   `json:"workspace_digest,omitempty"`
00037 | 	Outcome           string   `json:"outcome"`
00038 | 	Detail            string   `json:"detail,omitempty"`
00039 | 	PreviousHash      string   `json:"previous_hash,omitempty"`
00040 | }
00041 |
00042 | func Append(path string, record Record, now time.Time) (Record, error) {
00043 | 	record.Timestamp = now.UTC().Format(time.RFC3339Nano)
00044 | 	prior, err := Verify(path)
00045 | 	if err != nil && !os.IsNotExist(err) {
00046 | 		return Record{}, err
00047 | 	}
00048 | 	if len(prior) > 0 {
00049 | 		record.PreviousHash = prior[len(prior)-1].Hash
00050 | 	}
00051 | 	record.Hash, err = calculate(record)
00052 | 	if err != nil {
00053 | 		return Record{}, err
00054 | 	}
00055 | 	raw, err := json.Marshal(record)
00056 | 	if err != nil {
00057 | 		return Record{}, err
00058 | 	}
00059 | 	f, err := os.OpenFile(path, os.O_WRONLY|os.O_APPEND|os.O_CREATE, 0o600)
00060 | 	if err != nil {
00061 | 		return Record{}, err
00062 | 	}
00063 | 	defer f.Close()
00064 | 	if _, err := f.Write(append(raw, '\n')); err != nil {
00065 | 		return Record{}, err
00066 | 	}
00067 | 	if err := f.Sync(); err != nil {
00068 | 		return Record{}, err
00069 | 	}
00070 | 	return record, nil
00071 | }
00072 |
00073 | // AppendOnce makes recovery idempotent. It suppresses only an immediately
00074 | // repeated semantic record; a later, genuinely distinct operation is still
00075 | // appended even when it happens to use the same declaration.
00076 | func AppendOnce(path string, record Record, now time.Time) (Record, error) {
00077 | 	prior, err := Verify(path)
00078 | 	if err != nil && !os.IsNotExist(err) {
00079 | 		return Record{}, err
00080 | 	}
00081 | 	if len(prior) > 0 {
00082 | 		last := prior[len(prior)-1]
00083 | 		if last.Action == record.Action &&
00084 | 			last.PlanDigest == record.PlanDigest &&
00085 | 			last.DeclarationDigest == record.DeclarationDigest &&
00086 | 			last.WorkspaceDigest == record.WorkspaceDigest &&
00087 | 			last.Outcome == record.Outcome &&
00088 | 			last.Detail == record.Detail {
00089 | 			return last, nil
00090 | 		}
00091 | 	}
00092 | 	return Append(path, record, now)
00093 | }
00094 | func Verify(path string) ([]Record, error) {
00095 | 	return VerifyContext(context.Background(), path)
```


## `internal/jobcontract/types.go`

### Lines 21-141

```text
00021 | )
00022 |
00023 | type Request struct {
00024 | 	Schema      string             `json:"schema"`
00025 | 	JobID       string             `json:"job_id"`
00026 | 	Declaration DeclarationBinding `json:"declaration"`
00027 | 	Command     Command            `json:"command"`
00028 | 	Limits      Limits             `json:"limits"`
00029 | 	Artifacts   *ArtifactRequest   `json:"artifacts,omitempty"`
00030 | }
00031 |
00032 | type DeclarationBinding struct {
00033 | 	Path   string `json:"path"`
00034 | 	SHA256 string `json:"sha256"`
00035 | }
00036 |
00037 | type Command struct {
00038 | 	Argv             []string          `json:"argv"`
00039 | 	WorkingDirectory string            `json:"working_directory"`
00040 | 	Environment      []EnvironmentItem `json:"environment"`
00041 | }
00042 |
00043 | // EnvironmentItem is exactly one retained public value or one in-world secret
00044 | // file reference. Secret bytes are never duplicated into the request.
00045 | type EnvironmentItem struct {
00046 | 	Name        string  `json:"name"`
00047 | 	PublicValue *string `json:"public_value,omitempty"`
00048 | 	SecretFile  string  `json:"secret_file,omitempty"`
00049 | }
00050 |
00051 | type Limits struct {
00052 | 	TimeoutNS      int64 `json:"timeout_ns"`
00053 | 	FinalizeNS     int64 `json:"finalize_timeout_ns"`
00054 | 	StdoutMaxBytes int64 `json:"stdout_max_bytes"`
00055 | 	StderrMaxBytes int64 `json:"stderr_max_bytes"`
00056 | }
00057 |
00058 | type ArtifactRequest struct {
00059 | 	ContainerRoot string `json:"container_root"`
00060 | 	MaxEntries    int64  `json:"max_entries"`
00061 | 	MaxBytes      int64  `json:"max_bytes"`
00062 | }
00063 |
00064 | type Result struct {
00065 | 	Schema           string             `json:"schema"`
00066 | 	JobID            string             `json:"job_id"`
00067 | 	Status           string             `json:"status"`
00068 | 	RequestSHA256    string             `json:"request_sha256"`
00069 | 	EvidenceManifest string             `json:"evidence_manifest"`
00070 | 	Identity         ExecutionIdentity  `json:"identity"`
00071 | 	Target           TargetResult       `json:"target"`
00072 | 	Stdout           StreamResult       `json:"stdout"`
00073 | 	Stderr           StreamResult       `json:"stderr"`
00074 | 	Finalization     FinalizationResult `json:"finalization"`
00075 | 	Cleanup          CleanupResult      `json:"cleanup"`
00076 | 	Reasons          []string           `json:"reasons"`
00077 | }
00078 |
00079 | type ExecutionIdentity struct {
00080 | 	DeclarationSHA256 string `json:"declaration_sha256"`
00081 | 	PlanSHA256        string `json:"plan_sha256"`
00082 | 	Generation        int64  `json:"generation"`
00083 | 	ImageReference    string `json:"image_reference"`
00084 | 	ImageDigest       string `json:"image_digest"`
00085 | 	RuntimeSHA256     string `json:"runtime_evidence_sha256"`
00086 | 	ProvenanceSHA256  string `json:"provenance_sha256"`
00087 | 	RuntimeProvider   string `json:"runtime_provider"`
00088 | 	EgressSHA256      string `json:"egress_sha256,omitempty"`
00089 | }
00090 |
00091 | type TargetResult struct {
00092 | 	Kind       string `json:"kind"`
00093 | 	ExitStatus *int64 `json:"exit_status,omitempty"`
00094 | 	Signal     *int64 `json:"signal,omitempty"`
00095 | 	StartedAt  string `json:"started_at,omitempty"`
00096 | 	FinishedAt string `json:"finished_at,omitempty"`
00097 | 	DurationNS *int64 `json:"duration_ns,omitempty"`
00098 | }
00099 |
00100 | type StreamResult struct {
00101 | 	Path          string `json:"path"`
00102 | 	SHA256        string `json:"sha256"`
00103 | 	CapturedBytes int64  `json:"captured_bytes"`
00104 | 	TotalBytes    int64  `json:"total_bytes"`
00105 | 	Truncated     bool   `json:"truncated"`
00106 | }
00107 |
00108 | type FinalizationResult struct {
00109 | 	StartedAt  string `json:"started_at"`
00110 | 	FinishedAt string `json:"finished_at"`
00111 | 	DurationNS int64  `json:"duration_ns"`
00112 | }
00113 |
00114 | type CleanupResult struct {
00115 | 	Status            string   `json:"status"`
00116 | 	ContainerAbsent   bool     `json:"container_absent"`
00117 | 	ProxyAbsent       bool     `json:"proxy_absent"`
00118 | 	ProcessGroupEmpty bool     `json:"process_group_empty"`
00119 | 	Forced            bool     `json:"forced"`
00120 | 	DurationNS        int64    `json:"duration_ns"`
00121 | 	Reasons           []string `json:"reasons"`
00122 | }
00123 |
00124 | type Manifest struct {
00125 | 	Schema        string          `json:"schema"`
00126 | 	JobID         string          `json:"job_id"`
00127 | 	RequestSHA256 string          `json:"request_sha256"`
00128 | 	ResultSHA256  string          `json:"result_sha256"`
00129 | 	ContentSHA256 string          `json:"content_sha256"`
00130 | 	SealedAt      string          `json:"sealed_at"`
00131 | 	Entries       []ManifestEntry `json:"entries"`
00132 | }
00133 |
00134 | type ManifestEntry struct {
00135 | 	Path   string `json:"path"`
00136 | 	Kind   string `json:"kind"`
00137 | 	Size   int64  `json:"size"`
00138 | 	SHA256 string `json:"sha256"`
00139 | }
00140 |
00141 | type Provenance struct {
```

### Lines 151-192

```text
00151 | }
00152 |
00153 | // RuntimeObservation is the closed, provider-specific public proof retained
00154 | // around a direct governed job. It intentionally contains only public
00155 | // authority and observed enforcement facts; capability material never enters
00156 | // this document.
00157 | type RuntimeObservation struct {
00158 | 	Schema            string                    `json:"schema"`
00159 | 	Phase             string                    `json:"phase"`
00160 | 	ObservedAt        string                    `json:"observed_at"`
00161 | 	Provider          string                    `json:"provider"`
00162 | 	ContainerID       string                    `json:"container_id"`
00163 | 	ContainerName     string                    `json:"container_name"`
00164 | 	Running           bool                      `json:"running"`
00165 | 	ImageReference    string                    `json:"image_reference"`
00166 | 	ImageDigest       string                    `json:"image_digest"`
00167 | 	PlanSHA256        string                    `json:"plan_sha256"`
00168 | 	DeclarationSHA256 string                    `json:"declaration_sha256"`
00169 | 	Generation        int64                     `json:"generation"`
00170 | 	NetworkMode       string                    `json:"network_mode"`
00171 | 	IPCMode           string                    `json:"ipc_mode"`
00172 | 	IPCIsolated       bool                      `json:"ipc_isolated"`
00173 | 	PIDMode           string                    `json:"pid_mode"`
00174 | 	UTSMode           string                    `json:"uts_mode"`
00175 | 	UserNSMode        string                    `json:"userns_mode"`
00176 | 	User              string                    `json:"user"`
00177 | 	Hostname          string                    `json:"hostname"`
00178 | 	WorkingDirectory  string                    `json:"working_directory"`
00179 | 	BoundingCaps      []string                  `json:"bounding_caps"`
00180 | 	NoNewPrivileges   bool                      `json:"no_new_privileges"`
00181 | 	SeccompMode       int64                     `json:"seccomp_mode"`
00182 | 	Devices           int64                     `json:"devices"`
00183 | 	UIDIdentity       bool                      `json:"uid_identity"`
00184 | 	GIDIdentity       bool                      `json:"gid_identity"`
00185 | 	MemoryBytes       int64                     `json:"memory_bytes"`
00186 | 	NanoCPUs          int64                     `json:"nano_cpus"`
00187 | 	PIDs              int64                     `json:"pids"`
00188 | 	Mounts            []RuntimeMountObservation `json:"mounts"`
00189 | 	EgressAdmission   *RuntimeEgressAdmission   `json:"egress_admission,omitempty"`
00190 | }
00191 |
00192 | type RuntimeMountObservation struct {
```


## `internal/plan/plan.go`

### Lines 19-85

```text
00019 | )
00020 |
00021 | // Plan is the fully resolved, canonical provisioning intent at M1.
00022 | type Plan struct {
00023 | 	Version       int64          `json:"version"`
00024 | 	Name          string         `json:"name"`
00025 | 	AllowUnpinned bool           `json:"allow_unpinned"`
00026 | 	World         World          `json:"world"`
00027 | 	Resources     Resources      `json:"resources"`
00028 | 	Workspace     []string       `json:"workspace_paths"`
00029 | 	Copies        []Copy         `json:"copies"`
00030 | 	Mounts        []Mount        `json:"mounts"`
00031 | 	NetworkAllow  []NetworkAllow `json:"network_allow"`
00032 | 	Interfaces    []Interface    `json:"interfaces,omitempty"`
00033 | 	Services      []Service      `json:"services"`
00034 | }
00035 |
00036 | type World struct {
00037 | 	Hostname string `json:"hostname"`
00038 | 	Base     string `json:"base"`
00039 | 	Workdir  string `json:"workdir"`
00040 | 	User     string `json:"user"`
00041 | }
00042 | type Resources struct {
00043 | 	CPUs        int64 `json:"cpus"`
00044 | 	MemoryBytes int64 `json:"memory_bytes"`
00045 | 	PIDs        int64 `json:"pids"`
00046 | }
00047 | type Copy struct {
00048 | 	Source       string `json:"source"`
00049 | 	SourceDigest string `json:"source_digest"`
00050 | 	Target       string `json:"target"`
00051 | 	Mode         string `json:"mode"`
00052 | 	Secret       bool   `json:"secret"`
00053 | }
00054 | type Mount struct {
00055 | 	Source     string `json:"source"`
00056 | 	SourceType string `json:"source_type"`
00057 | 	Target     string `json:"target"`
00058 | 	Mode       string `json:"mode"`
00059 | }
00060 | type NetworkAllow struct {
00061 | 	Host string `json:"host"`
00062 | 	Port int64  `json:"port"`
00063 | }
00064 | type Interface struct {
00065 | 	Name    string `json:"name"`
00066 | 	Address string `json:"address"`
00067 | }
00068 | type Service struct {
00069 | 	Name      string   `json:"name"`
00070 | 	Command   []string `json:"command"`
00071 | 	Autostart bool     `json:"autostart"`
00072 | 	Restart   string   `json:"restart"`
00073 | }
00074 |
00075 | // Result carries semantic intent and both required provenance digests.
00076 | type Result struct {
00077 | 	PlanDigest        string   `json:"plan_digest"`
00078 | 	EvidenceDigest    string   `json:"evidence_digest"`
00079 | 	DeclarationDigest string   `json:"declaration_digest"`
00080 | 	SourceAnchor      string   `json:"source_anchor,omitempty"`
00081 | 	Warnings          []string `json:"warnings"`
00082 | 	Plan              Plan     `json:"plan"`
00083 | }
00084 |
00085 | func (r Result) MarshalJSON() ([]byte, error) {
```

### Lines 95-191

```text
00095 | }
00096 |
00097 | // Build validates and resolves a declaration relative to its file location.
00098 | func Build(d decl.Declaration, declarationPath string, declarationBytes []byte) (Result, error) {
00099 | 	return BuildContext(context.Background(), d, declarationPath, declarationBytes)
00100 | }
00101 |
00102 | // BuildContext is Build with cancellation threaded through bounded source-tree
00103 | // digest work.
00104 | func BuildContext(ctx context.Context, d decl.Declaration, declarationPath string, declarationBytes []byte) (Result, error) {
00105 | 	if err := ctx.Err(); err != nil {
00106 | 		return Result{}, err
00107 | 	}
00108 | 	dir, err := filepath.Abs(filepath.Dir(declarationPath))
00109 | 	if err != nil {
00110 | 		return Result{}, fmt.Errorf("resolve declaration directory: %w", err)
00111 | 	}
00112 | 	if err := decl.ValidateContext(ctx, d, dir); err != nil {
00113 | 		return Result{}, err
00114 | 	}
00115 | 	sourceAnchor, err := decl.CanonicalSourceAnchor(dir)
00116 | 	if err != nil {
00117 | 		return Result{}, fmt.Errorf("resolve declaration source anchor: %w", err)
00118 | 	}
00119 | 	p := Plan{
00120 | 		Version: d.Version, Name: d.Name, AllowUnpinned: d.AllowUnpinned,
00121 | 		World:     World{Hostname: d.World.Hostname, Base: d.World.Base, Workdir: filepath.Clean(d.World.Workdir), User: d.World.User},
00122 | 		Resources: Resources{CPUs: d.Resources.CPUs, MemoryBytes: d.Resources.MemoryBytes, PIDs: d.Resources.PIDs},
00123 | 		Workspace: append([]string{}, d.Workspace.Paths...),
00124 | 		Copies:    make([]Copy, 0, len(d.Copies)), Mounts: make([]Mount, 0, len(d.Mounts)),
00125 | 		NetworkAllow: make([]NetworkAllow, 0, len(d.Network.Allow)), Interfaces: make([]Interface, 0, len(d.Interfaces)), Services: make([]Service, 0, len(d.Services)),
00126 | 	}
00127 | 	for _, target := range p.Workspace {
00128 | 		if err := mountpath.Validate(target); err != nil {
00129 | 			return Result{}, fmt.Errorf("workspace target %s: %w", target, err)
00130 | 		}
00131 | 	}
00132 | 	for _, c := range d.Copies {
00133 | 		if err := ctx.Err(); err != nil {
00134 | 			return Result{}, err
00135 | 		}
00136 | 		source, err := decl.ResolveSource(dir, c.Source)
00137 | 		if err != nil {
00138 | 			return Result{}, err
00139 | 		}
00140 | 		digest, err := DigestSourceContext(ctx, source)
00141 | 		if err != nil {
00142 | 			return Result{}, fmt.Errorf("digest copy source %s: %w", c.Source, err)
00143 | 		}
00144 | 		p.Copies = append(p.Copies, Copy{Source: source, SourceDigest: digest, Target: filepath.Clean(c.Target), Mode: c.Mode, Secret: c.Secret})
00145 | 	}
00146 | 	for _, m := range d.Mounts {
00147 | 		if err := ctx.Err(); err != nil {
00148 | 			return Result{}, err
00149 | 		}
00150 | 		source, err := decl.ResolveSource(dir, m.Source)
00151 | 		if err != nil {
00152 | 			return Result{}, err
00153 | 		}
00154 | 		sourceType, err := mountSourceType(source)
00155 | 		if err != nil {
00156 | 			return Result{}, fmt.Errorf("inspect mount source %s: %w", m.Source, err)
00157 | 		}
00158 | 		target := filepath.Clean(m.Target)
00159 | 		if err := mountpath.Validate(source); err != nil {
00160 | 			return Result{}, fmt.Errorf("mount source %s: %w", m.Source, err)
00161 | 		}
00162 | 		if err := mountpath.Validate(target); err != nil {
00163 | 			return Result{}, fmt.Errorf("mount target %s: %w", m.Target, err)
00164 | 		}
00165 | 		p.Mounts = append(p.Mounts, Mount{Source: source, SourceType: sourceType, Target: target, Mode: m.Mode})
00166 | 	}
00167 | 	for _, a := range d.Network.Allow {
00168 | 		p.NetworkAllow = append(p.NetworkAllow, NetworkAllow{Host: a.Host, Port: a.Port})
00169 | 	}
00170 | 	for _, endpoint := range d.Interfaces {
00171 | 		p.Interfaces = append(p.Interfaces, Interface{Name: endpoint.Name, Address: endpoint.Address})
00172 | 	}
00173 | 	for _, s := range d.Services {
00174 | 		p.Services = append(p.Services, Service{Name: s.Name, Command: append([]string{}, s.Command...), Autostart: s.Autostart, Restart: s.Restart})
00175 | 	}
00176 | 	canonical, err := Canonical(p)
00177 | 	if err != nil {
00178 | 		return Result{}, err
00179 | 	}
00180 | 	planSum, declarationSum := sha256.Sum256(canonical), sha256.Sum256(declarationBytes)
00181 | 	_, evidenceDigest, err := EvidenceCanonicalWithAnchor(p, sourceAnchor)
00182 | 	if err != nil {
00183 | 		return Result{}, err
00184 | 	}
00185 | 	result := Result{PlanDigest: hex.EncodeToString(planSum[:]), EvidenceDigest: evidenceDigest, DeclarationDigest: hex.EncodeToString(declarationSum[:]), SourceAnchor: sourceAnchor, Warnings: []string{}, Plan: p}
00186 | 	if !decl.ImagePinned(d.World.Base) {
00187 | 		result.Warnings = append(result.Warnings, "UNPINNED BASE IMAGE: reproducibility depends on mutable external state")
00188 | 	}
00189 | 	return result, nil
00190 | }
00191 |
```


## `requirements/declaration.md`

### Lines 3-27

```text
00003 | Status: binding contract. Evidence and open boundaries are indexed in `INDEX.md`.
00004 |
00005 | Kenogram reads exactly one UTF-8 declaration. The accepted TOML subset contains
00006 | double-quoted strings with TOML-compatible basic escapes, booleans, signed decimal
00007 | integers, homogeneous single-line scalar arrays, bare keys, tables, arrays of tables, and
00008 | comments. Inline tables, floats, dates, multiline strings, dotted assignment
00009 | keys, and quoted keys are rejected.
00010 |
00011 | Unknown keys and tables are errors. Duplicate keys and table declarations are
00012 | errors. Array elements must have one scalar type. Integer overflow, invalid UTF-8,
00013 | trailing material, and malformed escapes are errors with line attribution.
00014 |
00015 | Schema version 1 is the only accepted version. World, service, and interface names are
00016 | unique, targets and workspace paths are absolute and clean, reserved paths cannot
00017 | be covered, mount targets cannot overlap, resources are positive, network ports
00018 | are 1–65535, restart is `never`, `on-failure`, or `always`, and declared source
00019 | paths must exist. Secret file sources must not grant group or other permission.
00020 | Interface addresses are canonical `127.0.0.1:port` endpoints: wildcard, host,
00021 | URL, non-loopback, noncanonical, and caller-selected addresses are rejected.
00022 |
00023 | The world `name` is its stable operational address; changing it addresses a
00024 | different world. This namespace rule does not claim that names determine
00025 | behavioral or ontological identity.
00026 |
00027 | ## Version 1 schema
```


## `requirements/jobs.md`

### Lines 1-32

```text
00001 | # Governed job contract
00002 |
00003 | Status: implemented provider-independent core and direct Linux provider. The
00004 | schemas, independent Go semantic validators, create-only publisher, bounded
00005 | executor, offline verifier, and direct one-shot Podman CLI adapter are active.
00006 | Finite declared egress is implemented through a namespace-pinned, host-owned
00007 | job proxy while the container retains `network=none`. Darwin either hands the exact invocation to an explicitly configured
00008 | Linux Apple container machine or fails closed without namespace claims.
00009 |
00010 | A governed job is one noninteractive, bounded target execution inside a fresh
00011 | Kenogram generation. It is distinct from the persistent-world service model.
00012 | The job request is host-authored authority. Target output, target artifacts,
00013 | and runtime-reported fields are observations and never become authority merely
00014 | because a producer calls the job successful.
00015 |
00016 | The versioned language-neutral documents are:
00017 |
00018 | - `kenogram.job-request.v1`, which binds the exact declaration, target command,
00019 |   public environment, work and output bounds, and optional artifact inventory;
00020 | - `kenogram.job-result.v1`, which keeps the target outcome, finalization, and
00021 |   cleanup as separate observations;
00022 | - `kenogram.job-evidence-manifest.v1`, which seals one closed create-only
00023 |   evidence inventory; and
00024 | - `kenogram.executable-provenance.v1`, which identifies the Kenogram executable
00025 |   that produced the observation; and
00026 | - `kenogram.podman-runtime-observation.v1`, which closes the public K5 runtime
00027 |   proof over immutable container, image, enforcement, and mount identities; and
00028 | - `kenogram.job-egress-evidence.v1`, which conditionally binds the declared
00029 |   allowlist, pinned namespace listener, bounded outcome counters, revocation,
00030 |   active-tunnel closure, and proxy join.
00031 |
00032 | Their JSON Schemas are under [`../schemas/`](../schemas/). The schemas are
```

### Lines 138-216

```text
00138 | while retaining a Kenogram claim.
00139 |
00140 | ## Execution result
00141 |
00142 | Target lifecycle and observer lifecycle are separate:
00143 |
00144 | ```text
00145 | target start ───────── target exit/signal
00146 |                          │
00147 |                          └─ finalization ─ output/artifact close
00148 |                                            └─ cleanup ─ proof of absence
00149 | ```
00150 |
00151 | The target result is exactly one of `exited`, `signaled`, `not_started`, or
00152 | `unknown`. `unknown` means the target was admitted but its terminal outcome was
00153 | not observed; it is always incomplete and never invents an exit status or
00154 | signal. `not_started` is reserved for refusal before target admission.
00155 | Observed targets carry wall-clock start and finish times plus a monotonic
00156 | duration. Finalization has its own timestamps and duration. Cleanup is complete
00157 | only when the owned container, proxy, and target process group are all observed
00158 | absent. Forced cleanup is reported independently and does not by itself weaken
00159 | a result when absence is proven.
00160 |
00161 | Stream evidence carries the retained path, exact digest, captured byte count,
00162 | total observed byte count, and truncation. A truncated stream cannot appear in
00163 | a `complete` result. `incomplete` and `refused` results carry one or more stable
00164 | uppercase reason codes; `complete` carries none. A refusal cannot invent a
00165 | target start.
00166 |
00167 | The result binds declaration, plan, generation, declared and observed image,
00168 | runtime-evidence, optional egress-evidence, and executable-provenance identities. Missing observed
00169 | identity is permitted only on a refusal or incomplete execution and must remain
00170 | empty rather than being copied from declaration authority.
00171 |
00172 | ## Evidence publication and verification
00173 |
00174 | The evidence directory leaf MUST NOT exist before execution. Kenogram owns it
00175 | descriptor-relatively, never mounts it into the target, creates every entry
00176 | without replacement, fsyncs completed files, and publishes `manifest.json`
00177 | last. Failure before that final publication leaves no seal and can never be
00178 | interpreted as a complete job.
00179 |
00180 | The mandatory inventory is:
00181 |
00182 | ```text
00183 | declaration.toml
00184 | plan.json
00185 | provenance.json
00186 | request.json
00187 | result.json
00188 | runtime-before.json
00189 | runtime-after.json
00190 | stdout.bin
00191 | stderr.bin
00192 | manifest.json          # written last; does not list itself
00193 | ```
00194 |
00195 | `egress.json` is mandatory for a complete result when the independently
00196 | reprojected plan has a nonempty allowlist and forbidden for a networkless plan.
00197 | A refusal before proxy identity exists may omit it; that absence can never be
00198 | upgraded to complete. Invalid or unrequested runtime egress output is not
00199 | retained as `egress.json`; the sealed result is incomplete with a stable reason
00200 | and remains independently replayable. When present, the artifact's digest is
00201 | bound by the result identity and manifest content root.
00202 |
00203 | The retained outcome counters are producer observations. Exact diagnostic
00204 | events remain bounded and ephemeral because they contain target-authored
00205 | destination metadata. Kenogram does not retain a digest of that discarded
00206 | snapshot: without the preimage such a value would be an unverifiable producer
00207 | claim, not an independently replayable evidence commitment.
00208 |
00209 | Optional target artifacts are copied into the host-owned evidence tree only
00210 | after target execution has ended. Manifest entries are unique and strictly
00211 | ordered by relative path. Each carries a kind, byte size, and lowercase
00212 | SHA-256. The manifest separately binds the request digest, result digest, and a
00213 | canonical content-root digest. It is at most 8 MiB and contains no more than
00214 | 10,032 entries.
00215 |
00216 | When artifacts are requested, the runtime returns open-once readers and
```

### Lines 237-280

```text
00237 | ```
00238 |
00239 | `verify-job` is an offline verifier. It reopens only descriptor-owned regular
00240 | files, recomputes every entry and content-root digest, validates every
00241 | versioned document, and cross-checks job/request/result/provenance identities. It never
00242 | starts a target, contacts a provider, or upgrades runtime-reported fields to
00243 | host-observed facts. Every non-placeholder runtime document is strictly
00244 | decoded and cross-bound even when the aggregate result is incomplete or
00245 | refused. The `{}` placeholder is accepted only when observed runtime identity
00246 | is empty and a typed start/observation failure explains the absence. For a
00247 | complete result the verifier requires both runtime phases, requires `before`
00248 | running and `after` stopped, re-derives containment
00249 | and resource constraints, cross-binds plan/result/provider identity, and
00250 | requires stable facts and mount identities to agree across phases. Generic
00251 | JSON cannot substitute for the runtime contract. For declared egress it also
00252 | re-derives the canonical allowlist digest, binds the immutable container and
00253 | generation, and cross-checks the listener, proxy owner, PID/start identity, and
00254 | pinned user/network namespace device and inode identities against the distinct
00255 | pre-target runtime admission. It requires the exact system environment key
00256 | inventory and `network=none`, and checks readiness/revocation against target
00257 | and finalization intervals. Runtime claims cannot strengthen an incomplete
00258 | proxy lifecycle into a complete result.
00259 |
00260 | The verifier never adopts a manifest entry size or kind as allocation or work
00261 | authority. It classifies the fixed inventory first, parses `request.json` under
00262 | its schema byte bound, and only then applies fixed document limits and the
00263 | request's stdout, stderr, artifact-count, and artifact-byte limits. Unknown
00264 | paths and kinds fail closed before payload reads.
00265 |
00266 | `plan.json` cross-binds its declaration digest and recomputable public evidence
00267 | digest. The result retains the declared image reference separately from the
00268 | provider-observed immutable image digest. A pinned-reference mismatch is
00269 | incomplete evidence and can never verify as complete.
00270 |
00271 | Before publishing the seal, Kenogram fsyncs every descriptor-opened artifact
00272 | directory, writes and fsyncs `manifest.json` without replacement, revalidates
00273 | that leaf against the opened file identity, and fsyncs the descriptor-owned
00274 | evidence root. Pathname replacement cannot redirect the durability proof.
00275 |
00276 | Ergograph and other consumers must independently parse and verify the retained
00277 | bytes. They do not import Kenogram packages, and Kenogram does not import their
00278 | model, ledger, qualification, or release code.
00279 |
00280 | ## K5 direct provider
```


## `requirements/lifecycle.md`

### Lines 5-48

```text
00005 | `INDEX.md`.
00006 |
00007 | Generations are named `kenogram-<world>-g<N>`. A successor is staged before the
00008 | predecessor stops; they never run concurrently over one workspace. The successor
00009 | starts and is verified from backend evidence before it is recorded as applied. On
00010 | failure the predecessor is restarted and no hybrid state remains.
00011 | New and inactive worlds must retain their reviewed workspace through cutover. A
00012 | verified active predecessor remains the workspace authority during successor
00013 | staging and may advance it. After that predecessor stops, Kenogram captures and
00014 | fsyncs the stable handoff tree into the rollback transition before the successor
00015 | starts. Capture failure aborts the cutover and restores the predecessor.
00016 |
00017 | Before the first cutover mutation, `up` fsyncs a transition record that retains
00018 | both declarations and identifies the authoritative recovery direction. Before
00019 | durable successor state is written, that record advances from rollback to
00020 | commit. The next `up` completes either direction idempotently before planning a
00021 | new generation. Commit recovery restarts a stopped authoritative successor and
00022 | re-establishes its declared services before completing durable state. An
00023 | unrecoverable observation leaves the record intact.
00024 |
00025 | The transition phase defines authority for `status`, `worlds`, and repair entry.
00026 | During rollback the predecessor remains authoritative and the successor is a
00027 | candidate; during commit the successor is authoritative and the predecessor is
00028 | the displaced candidate. `status` reports both roles and `enter --repair`
00029 | attaches only to the authoritative generation. If rollback has no predecessor,
00030 | Kenogram reports that no authoritative generation exists rather than entering
00031 | the candidate. Confirmed destruction is terminal: it removes every distinct
00032 | generation named by the transition without first starting either one.
00033 |
00034 | Workspace data is host-side, carried, and represented by a deterministic digest
00035 | tree. Recorded trees are accepted as evidence only when their entries are
00036 | canonical, uniquely ordered, and reproduce the recorded root hash. Configuration
00037 | is regenerated from the declaration. Confirmation surfaces workspace drift.
00038 | Rootless operation, private namespaces, capability reduction,
00039 | seccomp, device allowlisting, cgroups v2, and absence of the runtime socket are
00040 | mandatory. Exact mount identity and active seccomp mode are observed before the
00041 | network door or any declared service starts.
00042 |
00043 | A generation is one material inscription of the declared world-pattern, not the
00044 | persistent substance of the world. Replacement is correct when provenance is
00045 | preserved, carried state is handled explicitly, and the successor satisfies the
00046 | same observable contracts.
00047 |
00048 | The unit suite kills a replacement process at fifteen lifecycle boundaries:
```


## `requirements/network.md`

### Lines 7-35

```text
00007 | invariant gaps are indexed in `INDEX.md`.
00008 |
00009 | The normative acceptance invariants are:
00010 |
00011 | 1. A base world has loopback as its only interface.
00012 | 2. Exterior connects are genuinely unroutable except for an explicit
00013 |    host-operator `connect` to a named declared loopback interface.
00014 | 3. No resolver answers and no UDP leaves.
00015 | 4. With destinations, the only non-world-authored socket is the retained
00016 |    loopback proxy door (`127.0.0.1:3128` for persistent worlds; a retained
00017 |    ephemeral loopback port for governed jobs).
00018 | 5. CONNECT succeeds only for exact declared host-and-port pairs.
00019 | 6. Each outward address is resolved by the proxy for that connection.
00020 | 7. Direct dialing an allowed destination's IP remains unroutable.
00021 | 8. Proxy death restores the base case without stopping world processes.
00022 | 9. Ephemeral grants die by deadline or proxy death and removal closes connections.
00023 | 10. Repeated application of one declaration is indistinguishable under 1–9.
00024 |
00025 | Reapplication replaces the proxy's durable allowance set with the declaration
00026 | and clears ephemeral grants. This also restores a declaration-backed allowance
00027 | removed by `revoke`; `revoke` changes live policy, not declaration authority.
00028 |
00029 | The invariants, rather than the internal mechanism, define network conformance.
00030 | Conforming mechanisms satisfy the same finite observation contract; Kenogram
00031 | makes no claim of equivalence beyond that contract. This engineering criterion
00032 | is informed by Kenogram's conceptual lineage; it is not a claim to implement
00033 | formal morphic bisimulation.
00034 |
00035 | The persistent-world and governed-job mechanisms use a short-lived `nsenter` helper to create the listener inside
```

### Lines 60-66

```text
00060 | retention guarantee.
00061 |
00062 | Declared operator interfaces use the same namespace principle in the opposite
00063 | direction: a short-lived helper dials the exact declared loopback address inside
00064 | the authoritative generation and transfers the connected descriptor to
00065 | `kenogram connect`. It creates no listener in the host namespace, publishes no
00066 | container port, and supplies no general host-to-world address primitive.
```


## `requirements/provenance.md`

### Lines 7-39

```text
00007 | later work.
00008 |
00009 | `kenogram.executable-provenance.v1` is a bounded identity report for one exact
00010 | Kenogram executable. It contains:
00011 |
00012 | - `build_kind`: `development` or `release`;
00013 | - product version;
00014 | - full 40-character source commit or the explicit development placeholder
00015 |   `unknown`;
00016 | - canonical UTC source date or the explicit development placeholder `unknown`;
00017 | - Go toolchain string;
00018 | - runtime GOOS and GOARCH; and
00019 | - the lowercase SHA-256 of the executing file.
00020 |
00021 | A release document accepts no placeholders. Its version is a canonical
00022 | `vMAJOR.MINOR.PATCH` Semantic Version, optionally with a prerelease suffix; its
00023 | commit is the full source revision; and its source date is canonical UTC
00024 | RFC3339 with optional fractional seconds. Development provenance remains
00025 | honest by naming placeholders rather than imitating release identity.
00026 |
00027 | The report is no larger than 64 KiB, is strict JSON with no unknown or duplicate
00028 | keys, and is independently digest-bound by each governed-job manifest.
00029 | Self-reported provenance proves byte and metadata consistency only when an
00030 | independent consumer also authenticates the expected release coordinate and
00031 | executable digest. It is not a signature and does not make the executable its
00032 | own qualification authority.
00033 |
00034 | Candidate, ordinary pull-request, and publication workflows independently bind
00035 | the packaged Linux executable's build kind, version, full source commit,
00036 | canonical source date, platform tuple, and SHA-256 to verifier-owned expected
00037 | values, then run governed-job integration with that exact executable.
00038 |
00039 | Release packaging will later publish a canonical manifest binding every supported
```


## `requirements/security.md`

### Lines 3-12

```text
00003 | Status: binding contract. Evidence and open boundaries are indexed in `INDEX.md`.
00004 |
00005 | The declaration is host-authored but still parsed fail-closed. It cannot select
00006 | arbitrary schema extensions. Planning never renders copied, mounted, or secret
00007 | bytes. Copied file and tree contents are deterministically digested into the
00008 | plan; live mounts are not. Secret bytes and their digests are never emitted in
00009 | plan output, logs, history, or generated projections. Host-private recovery
00010 | state may retain a source digest, but never copied bytes.
00011 |
00012 | For governed one-shot jobs, declared read-only mounts are a narrower case: the
```

### Lines 62-82

```text
00062 | provider preflight. Failed materialization removes staged bytes before returning.
00063 |
00064 | Symlinked host source paths are rejected and copied trees reject symlink nodes.
00065 | Declared mounts cannot contain or overlap Kenogram state or known container
00066 | runtime control sockets. Runtime evidence must match the exact declared mount
00067 | set and bind-source filesystem identity; image-authored volumes are ignored.
00068 | Host-specific mount safety is checked during dry-run and apply. A replacement
00069 | also rejects a new source beneath a predecessor-writable host mount.
00070 | Podman evidence must confirm rootless operation, cgroups v2, private none-network
00071 | mode, active seccomp filtering, provenance labels, declared mounts, and resource
00072 | limits before any service starts. Kenogram requests `--ipc private`. For Podman
00073 | versions that report the resulting mode as `shareable`, Kenogram accepts that
00074 | label only when the live holder's IPC namespace identity differs from
00075 | Kenogram's ambient namespace. This proves separation from the IPC namespace
00076 | ambient to the Kenogram process, not that a trusted host process cannot join
00077 | the holder's namespace. No container-runtime control socket is mounted into a
00078 | world. Kenogram protects the host only to the extent provided by the
00079 | kernel, rootless runtime, and its own correctness; declared rw mounts and secrets
00080 | remain world-owned input by design.
00081 |
00082 | Governed-job egress does not add a container route. A descriptor-transferred
```

### Lines 109-119

```text
00109 | or temporary grant.
00110 |
00111 | ## Trust boundary
00112 |
00113 | The host operator and host-authored declaration are trusted authority. World
00114 | processes are untrusted relative to the host. The Linux kernel and rootless
00115 | Podman are dependencies whose isolation Kenogram observes but does not
00116 | independently establish. Declared writable mounts and secrets intentionally
00117 | cross the boundary. Kenogram does not claim to harden a multi-tenant host.
00118 |
00119 | Test credentials remain outside the declaration and durable world state.
```
