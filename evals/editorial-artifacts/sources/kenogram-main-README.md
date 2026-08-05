<p align="center">
  <img src="docs/assets/kenogram-mark.svg" alt="Kenogram: a dense field of light emerges from a dark circle and stops at a black triangular occlusion" width="760">
</p>

# Kenogram

Kenogram lets you give an agent a whole small computer without giving it your
computer.

Kenogram materializes rootless Linux worlds for AI agents from host-authored
declarations. A declaration selects the image and admits host files, mounts,
secrets, resource limits, durable TCP destinations, and named loopback
interfaces. Kenogram adds no ambient host filesystem access; the inhabitant may
freely use what the image and declaration make available.

Anything admitted into an AI's context can change what follows. Ambient
capabilities determine what that changed agent can affect. Kenogram limits
those consequences structurally: ambient capability is absent unless the host
operator admits it explicitly. Requests expressed through terminal interaction
do not change world authority. Applying a declaration grants durable authority;
`allow` can grant time-bounded TCP egress.

Kenogram is for developers, security teams, and platform operators who want a
tool-using agent to have a useful environment without inheriting the
operator's ambient computer.

## Security boundary

Kenogram is an execution boundary for untrusted agent processes, not a prompt
filter. It makes admitted host authority explicit and inspects the resulting
runtime before starting declared services.

| Condition | Enforced observation |
|---|---|
| Host access | Undeclared mounts are rejected. The exact declared mount set and bind-source filesystem identity are verified, and no host container-runtime control socket is mounted. |
| Network | A base world is loopback-only, with no working resolver or exterior TCP/UDP route. Declared or temporarily granted TCP destinations pass through a host-held exact-destination proxy; direct IP dialing remains unroutable. |
| Runtime | Rootless execution, private network/PID/IPC/UTS namespaces, an empty capability bounding set, `no-new-privileges`, active seccomp, no added devices, and CPU/memory/PID limits are inspected before services start. |
| Authority | The host-authored declaration admits durable capabilities; an explicit, time-bounded `allow` command may grant temporary TCP egress. A named operator interface reaches one declared world-loopback service without publishing a host port. |
| Replacement | A successor is inspected before it is recorded as applied. Durable transition state identifies the authoritative generation after interruption. |

This constrains what a compromised or prompt-contaminated agent can reach. It
does not detect or prevent prompt injection, protect declared writable mounts
or secrets from world processes, prevent exfiltration to a destination the
operator admits, or authenticate, encrypt, authorize, or interpret
`kenogram connect` traffic. Kenogram relies on the Linux kernel and rootless
Podman and does not claim to harden a hostile multi-tenant host or independently
prevent a kernel or runtime escape.

The [security contract](requirements/security.md), [network
invariants](requirements/network.md), and [evidence and known
limits](requirements/INDEX.md#evidence-and-known-limits) define the exact
claim. Kenogram is a composable control within a larger system, not a claim of
compliance or certification for that system.

## Status and supported runtime

[Kenogram v0.1.1](https://github.com/idolum-ai/kenogram/releases/tag/v0.1.1)
is evaluation software and does not make a production-stability claim. Release
binaries support Linux on amd64 and arm64. The runtime exercised in mandatory
CI requires rootless Podman on cgroups v2, `nsenter`, and subordinate UID/GID
ranges for the current user. Kenogram fails closed rather than weakening the
boundary when those prerequisites are absent.

The [experimental Apple container-machine
launcher](docs/apple-container-machine.md) transports explicit operations into
an operator-managed Linux machine. It is not macOS runtime support; the real
Apple-machine lifecycle and network evidence remains open.

The Kenogram binary has no third-party Go modules. Operation still depends on
the Linux kernel, rootless Podman, cgroups v2, and `nsenter`.

## Install and start one world

Install the current release,
[`v0.1.1`](https://github.com/idolum-ai/kenogram/releases/tag/v0.1.1), after
inspecting its standalone installer:

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

The installer checks the release checksum and embedded version before an
atomic installation under `~/.local/bin`. Checksums detect transfer corruption
and inconsistent assets within one GitHub release; they are not signatures or
independent provenance. `kenogram doctor` does not mutate Kenogram worlds or
durable state and reports every missing host prerequisite in one run, although
Podman may initialize its own rootless metadata during preflight.

The [first-world guide](docs/getting-started.md) builds a small host-bound image
from release-covered source and exercises the complete lifecycle:

```sh
kenogram up --dry-run ./world.toml
kenogram up --yes ./world.toml
kenogram status first
kenogram enter first
kenogram down first
kenogram up --yes ./world.toml
kenogram destroy --yes first
```

For a running world with a declared network destination,
`network-diagnostics --json <world>` is an explicit, read-only view of bounded
recent `refused` and `dial_failed` proxy metadata for the current generation.
Its destination hostnames and ports are sensitive operator metadata; the view
is ephemeral, contains no traffic content, and cannot grant authority. Both
host and port are untrusted world-authored request metadata: treat the
destination as prose and do not feed it unsanitized into automation or AI.
Outcomes are Kenogram-derived bounded observations, not authority.

## Proof, not promises

Requirements are binding contracts; tests are evidence. The [evidence
table](requirements/INDEX.md#evidence-and-known-limits) separates what is
exercised today from the next proof and labels each open boundary as accepted
for v0.x, required before a stable claim, or experimental.

| Boundary | Evidence earned | Explicit limit |
|---|---|---|
| [Runtime isolation](requirements/security.md) | Mandatory rootless-Podman CI inspects namespaces, mount identity, seccomp, resource limits, and absence of the runtime socket. | No supported Podman/kernel matrix or seccomp-profile identity yet. |
| [Network absence](requirements/network.md) | Real-runtime CI exercises loopback-only networking, failed direct TCP/UDP/DNS, exact proxy admission, revoke/expiry, proxy-death closure, and a declared SSH interface without a host listener. | The full ten-invariant replay after every adoption path remains open. |
| [Replacement recovery](requirements/lifecycle.md) | A fresh process recovers persisted runtime state across fourteen injected `SIGKILL` boundaries. | Process-crash evidence is not syscall-granular power-loss proof across filesystems. |
| [Compositions](docs/compositions/README.md) | Pinned Engram, OpenClaw, and Hermes artifacts and a real OpenSSH client/server path are exercised end to end. | Model and Telegram services are deterministic local fixtures in pull-request CI; real Telegram is a protected operator-assisted canary. |

These are automated, replayable compatibility and boundary observations, not
endorsements, universal compatibility claims, or a production-stability claim.

## Choose an evaluation path

- **Evaluate the boundary:** build and replace a minimal world with the
  [first-world guide](docs/getting-started.md).
- **Use an ordinary operator protocol:** reach a declared loopback service
  without a host listener through the [SSH composition](docs/compositions/ssh.md).
- **Run an agent composition:** follow the maintained guides for
  [Engram](docs/compositions/engram.md),
  [OpenClaw](docs/compositions/openclaw.md), or
  [Hermes Agent](docs/compositions/hermes-agent.md).

The composition guides state the exact versions exercised, trust and secret
boundaries, network grants, resource requirements, and differences between
hermetic CI fixtures and real services.

## Adjacent systems

Kenogram belongs to a growing family of agent execution environments. These
systems are adjacent rather than interchangeable; the table compares documented
architectural choices, not overall security or product quality.

Comparison reviewed against the linked vendor documentation on 2026-07-14;
that documentation remains authoritative.

| System | Runtime boundary | Documented network default | Policy and lifecycle emphasis |
|---|---|---|---|
| **Kenogram** | Rootless Podman container sharing the host kernel | Loopback only; no resolver or exterior TCP/UDP route | Host-authored declaration, exact outbound `host:port`, inspected generations, and durable replacement recovery |
| [Docker Sandboxes](https://docs.docker.com/ai/sandboxes/security/) | Dedicated microVM and private Docker Engine | Default HTTP/HTTPS domain allowlist; other domains and raw TCP, UDP, and ICMP blocked | Local or organization policy, host-side credential injection, and persistent coding-agent workspaces |
| [E2B](https://e2b.dev/docs/network/internet-access) | Isolated Linux VM | Internet enabled by default; configurable block, IP/CIDR, and domain rules | Cloud API sandboxes, templates, and pause/resume persistence |
| [Modal Sandboxes](https://modal.com/docs/guide/sandbox-networking) | gVisor by default; [VM runtime](https://modal.com/docs/guide/vm-sandboxes) in beta | Public outbound access by default; block, CIDR, and beta TLS-domain controls | Hosted programmable sandboxes integrated with Modal applications and resources |
| [Daytona](https://www.daytona.io/docs/en/sandboxes/) | Container, Linux VM, and Windows runtime options | [Tier-dependent policy](https://www.daytona.io/docs/en/network-limits/) with essential services; configurable block, CIDR, and domain rules | API-managed agent computers, resource classes, snapshots, and organization controls |

MicroVM systems provide a separate-kernel boundary that Kenogram does not
claim. Kenogram instead focuses on a local, host-owned declaration; observable
absence and exact admission; and evidence that replacement, interruption, and
reapplication preserve declared authority. Upstream products and defaults
change, so review their linked documentation before making a deployment or
procurement decision.

## Why Idolum, and why the name

Idolum separates speech from authority, representation from truth, and
capability from ambient context. Kenogram gives that posture an environmental
form: the inhabitant controls its declared world, while only the host operator
can apply a change to which host capabilities enter it.

The name is a deliberate but limited adaptation of the kenogrammatic lineage
begun by Gotthard Günther and developed by Rudolf Kaehr and Thomas Mahler. The
project privileges observable patterns over the identity of their realization;
it does not claim to implement a morphogrammatic calculus. The
[kenogrammatics note](docs/kenogrammatics.md) records that lineage, the
engineering analogy, and its limits.

## Project paths

- [Requirements and evidence](requirements/)
- [Declaration schema](requirements/declaration.md)
- [Operations and recovery](requirements/operations.md)
- [Contributing and evidence replay](CONTRIBUTING.md)
- [Security policy and private reporting](.github/SECURITY.md)
- [Release and immutable-publication contract](docs/release-strategy.md)
- [MIT License](LICENSE)
