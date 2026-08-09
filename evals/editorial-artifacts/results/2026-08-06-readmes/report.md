---
type: organon-evaluation
evaluation: editorial-artifacts
model: gpt-5.6-sol
generated_at: 2026-08-06T15:42:23+00:00
complete: true
passed: true
---

# Long-form editorial artifacts

> [!summary]
> Generated 2 long-form artifacts under the current ontology, canonical short-form instrument, and provisional long-form grammar. Deterministic checks and three separate judge calls evaluated each final draft. These remain generated proposals for Daniel's review.

## Run

| Field | Value |
|---|---|
| Generator | `gpt-5.6-sol` / `high` |
| Judges | `gpt-5.6-sol` / `high` |
| Ontology SHA-256 | `81c03318a3bc2b07cc3a7a9949c3da54dd885320b2f3ec246f4c5498d5cbcde1` |
| Short-form SHA-256 | `7ac9254f6f8964a1776f2eeacbfe36fdaad591701174116c0527c1f2c1b472be` |
| Long-form SHA-256 | `fb8f21b7dc03e2e44737fef723d94abdbb62a044ead89a6a7579d07d23b55d68` |
| Complete gate | 2 pass / 0 revise |

## Engram

> Target: `engram-main-readme` · Gate: **pass** · Attempt: 1

![Engram: a monochrome moire aperture over a dark terminal field](docs/assets/engram-mark.svg)

# Engram

**Remote tmux, rendered as a quiet signal.**

Engram is a single-user Telegram control surface for local tmux sessions. It creates or attaches to tmux windows, routes Telegram messages into panes, and represents each watched pane with one stable, pinned Telegram anchor.

That anchor can be a conversational guide or a terminal image rendered locally by Chromium. The distinction matters: the guide interprets a bounded terminal frame; the image renders it literally. Neither replaces tmux as the source of current terminal state.

Engram uses tmux because its narrow, mature command surface is expected to have little API drift, making it a durable substrate for a small remote-work tool.

## Choose how the terminal reaches your phone

| Conversational guide | Chromium snapshot |
| --- | --- |
| The selected model turns the bounded terminal frame into compact natural language. It can make dense output easier to scan across sessions, but it can misunderstand the pane. Raw bounded terminal text leaves the machine. | A local Chromium-compatible executable renders the bounded frame as an ANSI-preserving terminal image. The result is literal and requires no model interpretation, but exact terminal content is uploaded to Telegram and rendering uses more local CPU. |
| Requires Anthropic Haiku 4.5 or OpenAI Luna, selected with `LLM_PROVIDER`, plus the selected provider's API key and network access. Chromium is optional and enables `🖼️ View`. | Requires a Chromium-compatible executable, optionally selected with `ENGRAM_SNAPSHOT_BROWSER`. A configured guide provider is optional and enables `🗣️ Talk`. |

`ENGRAM_ANCHOR_MODE` supplies the startup fallback when no usable persisted choice exists. `/mode guide` and `/mode snapshot` migrate live anchors when the target capability is available and persist the choice across restarts.

Guide mode is interpretation. Snapshot mode is literal rendering. In both modes, raw tmux capture remains the authority for current terminal facts.

## Before you connect a bot to a shell

Engram deliberately connects a Telegram chat, local tmux panes, and—when configured—external model APIs. Compromise of the authorized Telegram account can become shell access for the configured local user. A stolen bot token can expose or disrupt the bot channel and must be revoked immediately.

Supported prerequisites are:

- Linux or macOS
- Go 1.22 or newer
- tmux 3.2 or newer, Git, Make, and curl
- A Telegram account
- For guide mode, an Anthropic API key with access to Claude Haiku 4.5 or an OpenAI API key with access to Luna
- For snapshot mode, a Chromium-compatible executable
- For automatic voice transcription, an OpenAI API key with access to `gpt-4o-transcribe`, independently of the selected guide provider

Linux with a systemd user session is the supported service installation. macOS is compile-checked and runs manually in the foreground; Engram does not install a launchd service.

On macOS, use the standalone `chrome-headless-shell` from [Chrome for Testing](https://googlechromelabs.github.io/chrome-for-testing/). Put it on `PATH` or set its absolute path in `ENGRAM_SNAPSHOT_BROWSER`. Automatic detection deliberately excludes desktop Chrome and Chromium applications; Engram does not download or update the browser.

## First run

### 1. Clone the repository

```sh
git clone https://github.com/idolum-ai/engram.git
cd engram
```

### 2. Create and identify the Telegram bot

Open the verified `@BotFather` account, send `/newbot`, follow the prompts, and keep the returned token private. Open a direct message with the new bot and send `/start`.

Before Engram starts polling, retrieve that DM from the official Bot API without placing the token in shell history or the `curl` argument list:

```bash
read -rsp "Bot token: " BOT_TOKEN; printf '\n'
printf 'url = "https://api.telegram.org/bot%s/getUpdates"\n' "$BOT_TOKEN" \
  | curl --silent --show-error --config -
unset BOT_TOKEN
```

Find the update whose `message.chat.type` is `private` and use the integer at `message.from.id`. Do not use `update_id` or the bot's own ID. The response contains your DM text; do not paste it into an issue.

### 3. Create the protected configuration

```sh
install -d -m 0700 "$HOME/.engram"
install -m 0600 .env.example "$HOME/.engram/.env"
${EDITOR:-vi} "$HOME/.engram/.env"
```

Engram rejects a foreign-owned, non-directory, or symlinked home. The env file must be a regular file with no group or other permissions. Never commit or post the completed file.

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

Leave `TELEGRAM_CHAT_ID` empty for DM-only use. Engram then uses the allowed user ID as the private chat ID. Group operation is unsupported.

Voice replies default to `VOICE_INPUT_MODE=path`: Engram keeps the OGG in its private attachment store and sends an absolute local path to the pane. With `VOICE_INPUT_MODE=transcribe` and an OpenAI API key, Engram sends the audio once to `gpt-4o-transcribe`, delivers one bounded `(transcribed) ...` input, and removes the audio. Voice-mode changes require a restart, and Engram does not silently fall back from failed transcription to path delivery.

[`.env.example`](.env.example) is the complete configuration surface.

### 4. Validate locally before making network calls

These commands validate configuration without calling Telegram or a model provider and without starting polling. `dry-start` also creates and opens the local state surface.

```sh
go run ./cmd/engram preflight --env "$HOME/.engram/.env"
go run ./cmd/engram dry-start --env "$HOME/.engram/.env"
```

Confirm that both end with `status: ok`, that tmux is not reported as `missing`, and that the displayed user and chat IDs are your private DM IDs.

### 5. Start Engram

On Linux:

```sh
make install-service PREFIX="$HOME/.local"
systemctl --user --no-pager --full status engram.service
```

On macOS:

```sh
make install PREFIX="$HOME/.local"
"$HOME/.local/bin/engram" run --env "$HOME/.engram/.env"
```

Only one Engram process may poll a configured bot/user/chat tuple, and only one process may own an `ENGRAM_HOME`. Do not run a foreground copy while the systemd service is active.

### 6. Prove the first route

In the bot DM, send:

```text
/new pwd
```

Engram creates a tmux window, runs `pwd`, and replies with a live session anchor. In guide mode, bounded pane text is sent to the selected provider. In snapshot mode, an exact image is sent to Telegram. Do not run commands that may print secrets until you accept those boundaries.

## What leaves the machine

### Telegram and tmux

Telegram receives commands, messages, attachments, anchors, requested snapshots, and results from commands such as `/raw`, `/dump`, `/logs`, `/templates export`, and `/download`. In snapshot mode, every changed anchor frame is an exact, unredacted terminal image sent automatically at most once every ten seconds.

Authorized messages can create windows and send literal shell input or key presses. tmux owns terminal history and continues running when Engram stops unless a window is explicitly closed. `/close` kills a window created by Engram, but only untracks an attached or legacy window.

A guide model can propose a normalized physical key sequence, but it cannot send that sequence directly. Engram presents a separate confirmation. `/key` remains the exact expert interface.

### Guide providers and Chromium

Guide requests contain joined terminal text capped at 64 rows. Captures are not credential-redacted before they reach the selected provider. Each render uses one non-streaming request, and completed guide prose is deterministically bounded to 180 words.

Chromium renders locally, and snapshot content is not sent to a model provider. The resulting image still goes to Telegram. Temporary HTML, browser profiles, and PNGs are removed after delivery.

Every media anchor offers `📄 Raw`, which returns the exact delivered snapshot frame or the complete selected guide rows as a bounded text attachment. It does not recapture a newer state.

### Optional Codex session context

Set `ENGRAM_CODEX_CONTEXT_TURNS` from `1` through `8` only if you want guide requests to include recent visible user and assistant messages from an exactly identified active Codex session. The default, `0`, disables this path.

Historical session text can clarify the prior topic but never establishes current terminal state. Raw tmux capture remains the authority for current facts, files, references, hashes, and screenshots. System and developer messages, hidden reasoning, tool calls and results, generated environment metadata, and attachments are excluded. Text is bounded and redacted before reaching the provider, and Engram does not persist transcript text. Missing, changed, stale, ambiguous, or unfamiliar bindings fail closed to terminal-only guidance.

See the [Codex session context guide](docs/codex-session-context.md) for setup, migration, verification, and disclosure details.

### Local files and redaction

`ENGRAM_HOME` contains state, remembered templates, audit files, and locks. Templates retain exact user-authored bodies in plaintext. Raw captures remain in process memory rather than `state.json`, but state still contains sensitive metadata and derived terminal content. Anyone with access to the host account can read these files.

Attachments and generated files use a private runtime directory. Most are not removed automatically by uninstall and may remain until manual or operating-system cleanup.

Audit and model-derived prose use best-effort pattern redaction. It can miss unfamiliar secrets or sensitive prose. It does not sanitize raw captures, `/raw`, `/dump`, `/download`, incoming attachments, existing Telegram history, or captures sent to the guide provider.

`/download <absolute-path>` rejects symlinks, opens a local regular file, copies it into a bounded private snapshot, and uploads it to Telegram. It is still an intentional file-exfiltration command. Review the exact path before sending it.

Treat terminal transcripts, bot history, state, templates, logs, attachments, snapshots, and diagnostic artifacts as sensitive.

## Pane-scoped GitHub App authority

Engram can encrypt a GitHub App private key at rest and broker short-lived installation-token leases to watched tmux panes. The bearer token is never printed by Engram or written to disk. `engram github exec` waits for human approval and then starts one child command with `GH_TOKEN` in its environment.

Enroll an App under a local alias:

```sh
engram github app add idolum \
  --app-id 123456 \
  --installation-id 987654 \
  --pem ./github-app.private-key.pem
```

Engram asks twice for a passphrase of at least 12 bytes. It encrypts the PEM with PBKDF2-HMAC-SHA256 at 600,000 iterations and authenticated AES-256-GCM. The passphrase is not stored. The source PEM is not modified; secure or remove it separately after confirming enrollment. Updating an alias atomically replaces it, so repeat the complete intended installation set and unlock mode.

From a watched pane, request only what one child command needs:

```sh
engram github exec \
  --app idolum \
  --repo idolum-ai/engram \
  --permission contents=read \
  --permission pull_requests=write \
  -- gh pr view 49
```

Repository and permission flags are mandatory. Engram verifies the live tmux server, window, and pane; shows the complete shell-quoted command to the configured Telegram user; and waits up to 15 minutes. If the command or its boundaries cannot fit safely in one approval card—or would require redaction—Engram refuses the request rather than presenting incomplete approval information.

Each token belongs to one GitHub App installation. Multi-installation aliases require an explicit `--installation-id`; Engram never guesses or combines scope across installations. Requested repositories and permissions are inspected against the selected installation, and GitHub's returned token scope must match. Omitted scope does not inherit broader installation defaults.

Three authority modes remain distinct:

| Mode | Approval | Boundary |
| --- | --- | --- |
| New exact command | Required | One displayed command |
| Active token lease | Not repeated for subsets | Same pane, repositories, and permission ceiling; about one hour |
| Renewable work-session grant | Required once | Pane, App, installation, repositories, permissions, purpose, and time; absolute maximum 24 hours |

Create a bounded work-session grant with `engram github grant`, then inspect or revoke the pane's current authority with:

```sh
engram github status
engram github revoke
```

Leases and grants live only in Engram memory. They disappear on expiry, revocation, restart, enrollment change, or loss of the watched terminal binding. Engram attempts to revoke live installation tokens during invalidation and orderly shutdown.

By default, the passphrase is entered locally before Telegram approval. `--telegram-unlock` is an explicit opt-in to sending it through Telegram. Bot chats are not end-to-end encrypted. Engram deletes the forced-reply prompt and reply and does not record their text, but the passphrase still traverses Telegram's cloud and is exposed to anyone controlling the account or bot token.

These controls reduce plaintext credential storage and accidental overreach. They do not protect secrets from root or malicious code already controlling the same operating-system user. A child can print its environment, so a command run under a lease must be trusted with the requested authority. Plain `git push` also needs an explicit credential adapter; Git does not universally consume `GH_TOKEN`.

This is not a general credential manager. Engram accepts GitHub App enrollment and installation-scoped workflows, not personal access tokens, OAuth user tokens, arbitrary secrets, or generic cloud credentials. Read the complete [pane-scoped GitHub App capability guide](docs/github-app-capabilities.md) before enrolling a key.

## Daily operation

Use `/help` in Telegram for the complete command list or `engram commands` for machine-readable metadata. Common commands include:

```text
/sessions
/attach <tmux-target>
/new <text>
/send <id> <text>
/text <id> <text>
/key <id> <keys...>
/raw <id>
/dump <id>
/download <absolute-path>
/logs
/status
/mode [guide|snapshot]
```

Reply to a session anchor to send text to its pane. Prefix a slash with another slash when the intended terminal input begins with `/`: replying with `//clear` sends `/clear` and presses Enter.

`/remember` stores exact reusable input in plaintext `templates.json`; `/templates export` downloads a consistent copy. Keep sensitive bodies out of templates when possible.

Read-only local inspection makes no network calls, sends no terminal input, and leaves Engram state unchanged:

```sh
engram inspect status
engram inspect sessions
engram inspect frame 3
```

Inspection does not redact literal pane content, and invoking tmux may run hooks configured by the owning user. See [headless operation](docs/headless-operation.md) for the exact boundary.

## Lifecycle and verification

On Linux, operate the user service with `systemctl --user` and inspect it with `journalctl --user -u engram.service`. Stop the service before replacing the binary when strict activation timing matters. After restart, `/version` or `/status` verifies the running process rather than only the binary on disk.

On macOS, stop the foreground process with `Ctrl+C`; tmux sessions remain. Engram ships no launchd integration. A user-authored LaunchAgent is outside the supported lifecycle.

Uninstalling does not delete tmux sessions, `~/.engram`, or the private runtime root. Review and remove them separately only when their state, logs, and attachments are no longer needed.

Engram uses only the Go standard library. Run the local gate before pushing:

```sh
make check
```

The gate runs tests, `go vet`, Darwin compile checks, architecture and public-release checks, workflow and documentation checks, a tracked-file secret scan, and a smoke build. Live model evaluations are opt-in because they make provider calls and require credentials. The manually dispatched [E2E suites](docs/e2e-testing.md) retain reviewable evidence without real service or model credentials.

Further review surfaces:

- [Contributing](CONTRIBUTING.md)
- [Release strategy](docs/release-strategy.md)
- [Changelog](CHANGELOG.md)
- [Private vulnerability reporting](SECURITY.md)
- [Agent screen semantics](docs/agent-screen-semantics.md)
- [Terminal mechanics boundary](docs/terminal-mechanics-boundary.md)
- [Terminal mechanics extraction plan](docs/terminal-mechanics-plan.md)
- [Protocol posture](docs/protocol-posture.md)
- [Upstream signal contract](requirements/upstream-signals.md)

## License

Engram is open source under the [MIT License](LICENSE).

### Evaluation

| Layer | Minimum score | Critical violations | Revision |
|---|---:|---|---|
| Deterministic | pass | — | — |
| Ontology | 3/4 | none | Rename the validation section to “Validate without additional network calls” or “Validate without contacting Telegram or a model provider.” Add a short release-verification paragraph stating that users should select a reviewed tag, inspect the installer from that same tag, rely on its archive-checksum and embedded-version checks, and verify the running process with `/version` or `/status` after restart. For maximum precision, consistently call snapshots “literal renderings of the bounded captured frame,” not simply “literal,” and briefly restore the renewable-grant defaults: an eight-hour configurable ceiling, absolute 24-hour limit, and the narrower renewable-write allowlist documented in the capability guide. |
| Short-form delivery | 4/4 | none | No substantive revision needed. |
| Long-form grammar | 3/4 | none | Preserve the operational detail and current sequence. Near the end, add a compact decision test that applies the article's frame rather than merely restating it: when terminal facts are disputed, inspect tmux or the delivered raw frame; when information is sensitive, identify which representation leaves the machine and where it goes; when an action needs external authority, inspect its pane, scope, duration, and revocation path. Placing this just before the review links would turn the many boundaries into a memorable instrument without forcing a rhetorical conclusion or adding a formulaic summary. |

**Reader start:** A developer has local tmux work that should remain available from a phone, but needs to know exactly what Telegram, a guide model, Chromium, and optional GitHub authority can see or do before connecting them.

**Consequential missingness:** Remote terminal convenience can blur three different things: the terminal state, an interpretation of that state, and permission to act. Without those distinctions, a bot token can become ambient shell access, model prose can be mistaken for terminal truth, and authenticated GitHub access can exceed the work a pane was approved to perform.

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

Anything admitted into an AI's context can change what follows. The relevant security question is what that changed agent can affect. Kenogram constrains those consequences structurally: host capability is unavailable unless the operator admits it explicitly.

Requests expressed through terminal interaction do not change world authority. Applying a declaration grants durable authority; `allow` can grant time-bounded TCP egress. The agent may control what happens inside its declared world, but only the host operator can change which host capabilities enter it.

Kenogram is for developers, security teams, and platform operators who want a tool-using agent to have a useful environment without inheriting the operator's ambient computer.

**A useful agent world begins with the authority the host explicitly admits, not with the ambient computer the agent happens to inhabit.**

## The security boundary

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

Kenogram relies on the Linux kernel and rootless Podman. It shares the host kernel and does not claim the separate-kernel boundary provided by a microVM.

The [security contract](requirements/security.md), [network invariants](requirements/network.md), and [evidence and known limits](requirements/INDEX.md#evidence-and-known-limits) define the exact claim. Kenogram is a composable control within a larger system, not a claim of compliance or certification for that system.

## Status and supported runtime

[Kenogram v0.1.1](https://github.com/idolum-ai/kenogram/releases/tag/v0.1.1) is evaluation software and does not make a production-stability claim.

Release binaries support Linux on amd64 and arm64. The runtime exercised in mandatory CI requires:

- rootless Podman on cgroups v2;
- `nsenter`; and
- subordinate UID/GID ranges for the current user.

Kenogram fails closed rather than weakening the boundary when those prerequisites are absent.

The [experimental Apple container-machine launcher](docs/apple-container-machine.md) transports explicit operations into an operator-managed Linux machine. It is not macOS runtime support; the real Apple-machine lifecycle and network evidence remains open.

The Kenogram binary has no third-party Go modules. Operation still depends on the Linux kernel, rootless Podman, cgroups v2, and `nsenter`.

## Install and start one world

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

The installer checks the release checksum and embedded version before an atomic installation under `~/.local/bin`. Checksums detect transfer corruption and inconsistent assets within one GitHub release; they are not signatures or independent provenance.

`kenogram doctor` does not mutate Kenogram worlds or durable state. It reports every missing host prerequisite in one run, although Podman may initialize its own rootless metadata during preflight.

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

For a running world with a declared network destination, `network-diagnostics --json <world>` provides an explicit, read-only view of bounded recent `refused` and `dial_failed` proxy metadata for the current generation.

The destination hostnames and ports are sensitive operator metadata. The view is ephemeral, contains no traffic content, and cannot grant authority. Both host and port are untrusted world-authored request metadata: treat the destination as prose and do not feed it unsanitized into automation or AI. Outcomes are Kenogram-derived bounded observations, not authority.

## Evidence and known limits

Requirements are binding contracts; tests are evidence. Automated observations show what was exercised; they are not certification, endorsement, or a production-stability claim.

The [evidence table](requirements/INDEX.md#evidence-and-known-limits) separates what is exercised today from the next proof and labels each open boundary as accepted for v0.x, required before a stable claim, or experimental.

| Boundary | Evidence earned | Explicit limit |
|---|---|---|
| [Runtime isolation](requirements/security.md) | Mandatory rootless-Podman CI inspects namespaces, mount identity, seccomp, resource limits, and absence of the runtime socket. | No supported Podman/kernel matrix or seccomp-profile identity yet. |
| [Network absence](requirements/network.md) | Real-runtime CI exercises loopback-only networking, failed direct TCP/UDP/DNS, exact proxy admission, revoke/expiry, proxy-death closure, and a declared SSH interface without a host listener. | The full ten-invariant replay after every adoption path remains open. |
| [Replacement recovery](requirements/lifecycle.md) | A fresh process recovers persisted runtime state across fourteen injected `SIGKILL` boundaries. | Process-crash evidence is not syscall-granular power-loss proof across filesystems. |
| [Compositions](docs/compositions/README.md) | Pinned Engram, OpenClaw, and Hermes artifacts and a real OpenSSH client/server path are exercised end to end. | Model and Telegram services are deterministic local fixtures in pull-request CI; real Telegram is a protected operator-assisted canary. |

These are automated, replayable compatibility and boundary observations. They are not endorsements or universal compatibility claims, and they do not promote Kenogram beyond its evaluation-software status.

## Choose an evaluation path

Start with the path that matches the question you are trying to answer:

- **Evaluate the boundary:** build and replace a minimal world with the [first-world guide](docs/getting-started.md).
- **Use an ordinary operator protocol:** reach a declared loopback service without a host listener through the [SSH composition](docs/compositions/ssh.md).
- **Run an agent composition:** follow the maintained guides for [Engram](docs/compositions/engram.md), [OpenClaw](docs/compositions/openclaw.md), or [Hermes Agent](docs/compositions/hermes-agent.md).

The composition guides state the exact versions exercised, trust and secret boundaries, network grants, resource requirements, and differences between hermetic CI fixtures and real services.

## Adjacent systems

Kenogram belongs to a growing family of agent execution environments. These systems are adjacent rather than interchangeable. The following table compares documented architectural choices, not overall security or product quality.

The comparison was reviewed against the linked vendor documentation on 2026-07-14; that documentation remains authoritative.

| System | Runtime boundary | Documented network default | Policy and lifecycle emphasis |
|---|---|---|---|
| **Kenogram** | Rootless Podman container sharing the host kernel | Loopback only; no resolver or exterior TCP/UDP route | Host-authored declaration, exact outbound `host:port`, inspected generations, and durable replacement recovery |
| [Docker Sandboxes](https://docs.docker.com/ai/sandboxes/security/) | Dedicated microVM and private Docker Engine | Default HTTP/HTTPS domain allowlist; other domains and raw TCP, UDP, and ICMP blocked | Local or organization policy, host-side credential injection, and persistent coding-agent workspaces |
| [E2B](https://e2b.dev/docs/network/internet-access) | Isolated Linux VM | Internet enabled by default; configurable block, IP/CIDR, and domain rules | Cloud API sandboxes, templates, and pause/resume persistence |
| [Modal Sandboxes](https://modal.com/docs/guide/sandbox-networking) | gVisor by default; [VM runtime](https://modal.com/docs/guide/vm-sandboxes) in beta | Public outbound access by default; block, CIDR, and beta TLS-domain controls | Hosted programmable sandboxes integrated with Modal applications and resources |
| [Daytona](https://www.daytona.io/docs/en/sandboxes/) | Container, Linux VM, and Windows runtime options | [Tier-dependent policy](https://www.daytona.io/docs/en/network-limits/) with essential services; configurable block, CIDR, and domain rules | API-managed agent computers, resource classes, snapshots, and organization controls |

MicroVM systems provide a separate-kernel boundary that Kenogram does not claim. Kenogram instead focuses on a local, host-owned declaration; observable network absence and exact admission; and evidence that replacement, interruption, and reapplication preserve declared authority.

Upstream products and defaults change. Review their linked documentation before making a deployment or procurement decision.

## Why Idolum, and why the name

Idolum separates speech from authority, representation from truth, and capability from ambient context. Kenogram gives that posture an environmental form: the inhabitant controls its declared world, while only the host operator can apply a change to which host capabilities enter it.

The name is a deliberate but limited adaptation of the kenogrammatic lineage begun by Gotthard Günther and developed by Rudolf Kaehr and Thomas Mahler. The project privileges observable patterns over the identity of their realization; it does not claim to implement a morphogrammatic calculus.

The [kenogrammatics note](docs/kenogrammatics.md) records that lineage, the engineering analogy, and its limits.

## Project paths

- [Requirements and evidence](requirements/)
- [Declaration schema](requirements/declaration.md)
- [Operations and recovery](requirements/operations.md)
- [Governed-job guide](docs/governed-jobs.md) and [evidence contract](requirements/jobs.md) — bounded direct Linux execution, create-only evidence, and offline verification
- [Contributing and evidence replay](CONTRIBUTING.md)
- [Security policy and private reporting](.github/SECURITY.md)
- [Release and immutable-publication contract](docs/release-strategy.md)
- [MIT License](LICENSE)

### Evaluation

| Layer | Minimum score | Critical violations | Revision |
|---|---:|---|---|
| Deterministic | pass | — | — |
| Ontology | 3/4 | none | No mandatory revision; the artifact is review-ready. For maximum semantic hygiene, change “tests are evidence” to “tests produce project-authored, replayable observations,” rename “Evidence earned” to “Observations exercised,” and use “verified lack of exterior network routes” instead of unqualified “network absence” except where preserving a linked requirement title. If Organon Evidence is intentionally claimed, add the required Witness, IndependentFor, governing Order, Admissibility Rule, Admission, evaluation Rule, and Evidential Bearing joins. |
| Short-form delivery | 4/4 | none | No required revision. For slightly greater technical precision, the opening could read: “Kenogram lets you give an agent a small declared Linux world without giving it authority over your host.” |
| Long-form grammar | 3/4 | none | Add a brief decision rule near “Choose an evaluation path” or after the adjacent-systems comparison that explicitly reapplies the authority frame to the opening choice: Kenogram is appropriate when the host is trusted and the required boundary is explicit minimization of admitted host authority; it is inappropriate when the threat model requires a separate kernel or protection from the host/runtime itself. This would complete the revaluation by returning the reader to the original boundary decision with a changed, actionable classification rather than merely another summary of features. |

**Reader start:** A developer, platform operator, or security reviewer begins with a practical decision: whether a rootless, shared-kernel Linux world with explicitly admitted host access is the right boundary for a tool-using AI agent.

**Consequential missingness:** Labels such as “sandbox” or “agent computer” do not reveal which host capabilities are ambient, which are explicitly admitted, how replacement preserves authority, or what evidence supports the boundary. Without those distinctions, the reader cannot evaluate the consequences of running an untrusted or prompt-contaminated agent process.

**Inheritance:** A useful agent world begins with the authority the host explicitly admits, not with the ambient computer the agent happens to inhabit.

**Source anchors:** evals/editorial-artifacts/inputs/sources/kenogram-main-README.md

## Canonicality boundary

The generated drafts and judge verdicts are noncanonical observations. Passing the automated gate does not make either article Daniel-authored, establish its factual Claims, or promote the provisional long-form grammar. Same-model generation and judging is an explicit limitation even though prompts and calls are separate.
