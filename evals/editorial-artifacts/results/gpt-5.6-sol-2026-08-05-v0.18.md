---
type: organon-evaluation
evaluation: editorial-artifacts
model: gpt-5.6-sol
generated_at: 2026-08-05T05:51:44+00:00
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

> Target: `engram-main-readme` · Gate: **pass** · Attempt: 2

<p align="center">
  <img src="docs/assets/engram-mark.svg" alt="Engram: a monochrome moire aperture over a dark terminal field" width="760">
</p>

<h1 align="center">Engram</h1>

<p align="center">
  <strong>Remote tmux, rendered as a quiet signal.</strong>
</p>

Engram is a single-user Telegram control surface for local tmux sessions. It creates or attaches to tmux windows, routes authorized Telegram messages into panes, and gives each watched pane one stable, pinned Telegram anchor.

That anchor can be a conversational guide or an exact terminal image rendered locally by Chromium. The distinction matters: the guide interprets a bounded terminal frame, while the snapshot preserves it literally. Neither changes the fact that Telegram is a remote control channel for the configured local user.

Engram supports tmux 3.2 or newer and confines its integration to tmux's mature, narrow command surface. Compatibility is checked through the project gates described below.

## Choose how panes appear

| Conversational guide | Chromium snapshot |
| --- | --- |
| The selected model turns a bounded terminal frame into compact prose. It can make dense output easier to absorb across several sessions, but it can misunderstand the pane. Raw bounded terminal text leaves the machine for the selected provider. | A local Chromium-compatible executable renders the same bounded frame as an ANSI-preserving, phone-width image. No model interpretation is required, but the exact unredacted image is uploaded to Telegram and can be denser to inspect. |
| Requires Anthropic Haiku 4.5 or OpenAI Luna, selected with `LLM_PROVIDER`, the corresponding API key, and network access. Chromium is optional and enables `🖼️ View`. | Requires a Chromium-compatible executable, optionally selected with `ENGRAM_SNAPSHOT_BROWSER`. A configured guide provider is optional and enables `🗣️ Talk`. |

`ENGRAM_ANCHOR_MODE` supplies the startup choice and fallback when no usable persisted choice exists. `/mode guide` and `/mode snapshot` migrate live anchors when the requested capability is available, and the runtime choice persists across restarts.

The guide is not the terminal. Model prose, prior guide prose, and optional Codex history may help explain what is visible, but raw tmux capture remains the authority for current terminal facts, files, references, hashes, and screenshots.

## Read the control boundary first

Engram deliberately connects a Telegram bot, a local shell, and—when guide or transcription features are enabled—external APIs.

- Compromise of the authorized Telegram account can become shell access for the configured local operating-system user.
- A stolen bot token can expose or disrupt the bot channel. Revoke it immediately.
- Telegram bot chats are not end-to-end encrypted.
- Guide captures are not credential-redacted before being sent to the selected model provider.
- Snapshot mode sends exact, unredacted changed frames to Telegram automatically, at most once every ten seconds.
- `/raw`, `/dump`, `/logs`, `/templates export`, `/download`, requested files, and snapshot photos send data through Telegram.
- `/download <absolute-path>` is an intentional file-exfiltration command. It rejects symlinks, but you must review the exact path.
- Pattern-based redaction can miss unfamiliar secrets and sensitive prose. It does not sanitize raw captures, downloads, attachments, existing Telegram history, or captures sent to the selected guide provider.

Give this bot access only after those boundaries match the host and account you intend to use.

## First run

### 1. Install prerequisites

You need:

- Linux or macOS
- Go 1.22 or newer
- tmux 3.2 or newer, Git, Make, and curl
- A Telegram account
- For guide mode, either an Anthropic API key with access to Claude Haiku 4.5 or an OpenAI API key with access to Luna
- For snapshot mode, a Chromium-compatible executable
- For automatic voice transcription, an OpenAI API key with access to `gpt-4o-transcribe`

Linux with a systemd user session is the supported service installation. macOS is compile-checked and runs manually in the foreground; Engram does not install a launchd service.

On macOS, use the standalone `chrome-headless-shell` published through [Chrome for Testing](https://googlechromelabs.github.io/chrome-for-testing/). Put it on `PATH` or set its absolute path in `ENGRAM_SNAPSHOT_BROWSER`. Automatic macOS detection deliberately excludes desktop Chrome and Chromium applications; setting the variable explicitly opts into another executable. Engram does not download or update the browser.

```sh
git clone https://github.com/idolum-ai/engram.git
cd engram
```

### 2. Create and identify the Telegram bot

1. Open the verified `@BotFather` account in Telegram.
2. Send `/newbot` and follow the prompts.
3. Keep the returned token private. It controls the bot.
4. Open a direct message with the new bot and send `/start`.

Retrieve that DM from the official Bot API before Engram begins polling. This form keeps the token out of shell history and the `curl` argument list:

```bash
read -rsp "Bot token: " BOT_TOKEN; printf '\n'
printf 'url = "https://api.telegram.org/bot%s/getUpdates"\n' "$BOT_TOKEN" \
  | curl --silent --show-error --config -
unset BOT_TOKEN
```

In the JSON response, find the private-chat update and use the integer at `message.from.id`. Do not use `update_id` or the bot's own ID. The response also contains your DM text; do not paste it into an issue.

### 3. Create the protected configuration

```sh
install -d -m 0700 "$HOME/.engram"
install -m 0600 .env.example "$HOME/.engram/.env"
${EDITOR:-vi} "$HOME/.engram/.env"
```

Engram requires its home to be owner-controlled and rejects a foreign-owned, non-directory, or symlinked home. The env file must be a regular file with no group or other permissions. Never commit or post the completed file.

For guide mode with Anthropic:

```dotenv
TELEGRAM_BOT_TOKEN=the-token-from-BotFather
TELEGRAM_ALLOWED_USER_ID=the-message.from.id-integer
ENGRAM_ANCHOR_MODE=guide
LLM_PROVIDER=anthropic
ANTHROPIC_API_KEY=your-Anthropic-key
```

For OpenAI Luna, use `LLM_PROVIDER=openai` and `OPENAI_API_KEY=your-OpenAI-key`. Provider selection is startup configuration; restart Engram after changing it.

For snapshot mode:

```dotenv
TELEGRAM_BOT_TOKEN=the-token-from-BotFather
TELEGRAM_ALLOWED_USER_ID=the-message.from.id-integer
ENGRAM_ANCHOR_MODE=snapshot
```

Leave `TELEGRAM_CHAT_ID` empty for DM-only use. Engram then uses the allowed user ID as the private chat ID. Group operation is unsupported.

Voice replies default to `VOICE_INPUT_MODE=path`: Engram retains the OGG in its private attachment store and sends its absolute path to the pane. `VOICE_INPUT_MODE=transcribe` sends the temporary OGG once to OpenAI's `gpt-4o-transcribe`, delivers one bounded `(transcribed) ...` line, and removes the audio. Engram does not silently fall back to path delivery after a transcription error. Changing the voice mode requires a restart.

[`.env.example`](.env.example) is the complete configuration surface.

### 4. Validate without network calls

These commands validate configuration without contacting Telegram or the selected model provider and without starting polling. `dry-start` also creates and opens the local state surface.

```sh
go run ./cmd/engram preflight --env "$HOME/.engram/.env"
go run ./cmd/engram dry-start --env "$HOME/.engram/.env"
```

Confirm that both end with `status: ok`, that `tmux` is not reported as `missing`, and that the displayed user and chat IDs are the intended private DM IDs.

### 5. Start Engram

On Linux, install the binary and systemd user service:

```sh
make install-service PREFIX="$HOME/.local"
systemctl --user --no-pager --full status engram.service
```

On macOS, install and run Engram in a foreground terminal:

```sh
make install PREFIX="$HOME/.local"
"$HOME/.local/bin/engram" run --env "$HOME/.engram/.env"
```

Only one Engram process may poll a configured bot/user/chat tuple, and only one process may own an `ENGRAM_HOME`. Do not run a foreground copy while the systemd service is active.

### 6. Verify one session

In the bot DM, send:

```text
/new pwd
```

Engram creates a tmux window, runs `pwd`, and replies with an editable session anchor. In guide mode, bounded pane text is sent to the selected provider. In snapshot mode, an exact pane image is sent to Telegram. Review the output path before running commands that may print secrets.

## How control behaves

Reply to a live session anchor to send text to its pane. To send input beginning with a slash, add one extra slash: `//clear` sends `/clear` and presses Enter.

Use `/help` in Telegram for the complete command list or `engram commands` locally for machine-readable metadata. Common commands include:

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

A guide model may propose physical key presses through the `⌨️` control, but it cannot send them. Engram presents the normalized sequence and target for separate confirmation; ambiguous, stale, malformed, unsupported, or oversized proposals fail closed. `/key` remains the exact expert interface.

Each expanded watched session has one canonical live anchor. Replies to stale or retired views produce an error and never reach tmux. Collapsed sessions perform no capture, guide, Chromium, raw/dump, alternate-view, reply, or terminal-control work until restored.

`/close` kills windows created by Engram but only untracks attached or legacy windows. tmux owns terminal history and continues running when Engram stops unless a window is explicitly closed.

## Pane-scoped GitHub App authority

Engram can broker short-lived GitHub App installation tokens to watched panes without printing the bearer token or writing it to disk. `engram github exec` waits for human approval and then starts one child command with `GH_TOKEN` in its environment.

Enroll an App under a local alias:

```sh
engram github app add idolum \
  --app-id 123456 \
  --installation-id 987654 \
  --pem ./github-app.private-key.pem
```

Engram prompts twice for a passphrase of at least 12 bytes. It stores the PEM under `ENGRAM_HOME/github-apps.json` using PBKDF2-HMAC-SHA256 with 600,000 iterations and authenticated AES-256-GCM encryption. The passphrase is not stored. PBKDF2 here is CPU-hard rather than memory-hard, so use a unique high-entropy passphrase. The source PEM remains untouched; secure or remove it separately after confirming enrollment.

Request only the repositories and permissions needed by one child command:

```sh
engram github exec \
  --app idolum \
  --repo idolum-ai/engram \
  --permission contents=read \
  --permission pull_requests=write \
  -- gh pr view 49
```

Repository and permission flags are mandatory. Engram validates the live tmux server, window, and pane identity; sends the complete shell-quoted command and scope to the configured Telegram user; and waits at most fifteen minutes for approval. If the full command or authority cannot fit safely, or would require redaction, Engram refuses rather than asking for approval of an incomplete description.

Each token belongs to one installation. Multi-installation aliases require an explicit `--installation-id`; Engram never guesses or combines scopes across installations. Requested permissions cannot exceed the installation's current grants, omitted scopes do not inherit broader defaults, and GitHub's returned repository and permission scope must match the request apart from its implicit read-only metadata permission.

An active same-pane lease can satisfy later subset requests. Broader authority requires another approval. A renewable `engram github grant` can approve a bounded work-session envelope once; it remains bound to the pane, App, repositories, permissions, enrollment, and expiry. The configurable default maximum is eight hours, the absolute maximum is 24 hours, and grants must last at least 30 minutes.

Inspect or revoke the current pane's authority with:

```sh
engram github status
engram github revoke
```

Leases and grants live only in Engram memory. They disappear on expiry, restart, revocation, enrollment change, or loss or unwatching of the terminal binding. Engram erases retained signing material and attempts to revoke live installation tokens during invalidation and orderly shutdown.

Telegram unlock is an explicit opt-in because the passphrase crosses Telegram's cloud. Engram deletes the forced-reply prompt and response after receiving them and does not record their text, but deletion does not undo cloud transport or exposure to anyone controlling the account or bot token.

The broker socket is owner-only, but these controls do not isolate secrets from root or malicious code already controlling the same operating-system user. A child can print its own environment. Treat every command run under a lease as trusted with the requested authority.

This is not a general credential manager. Engram accepts GitHub App enrollment and installation capabilities, not personal access tokens, OAuth user tokens, arbitrary secrets, or generic cloud credentials. Read the complete [pane-scoped GitHub App capability guide](docs/github-app-capabilities.md) before enrollment.

## Data retained and disclosed

Guide requests contain the complete current bounded semantic frame, capped at 64 rows, after narrow documented exclusions. They use one non-streaming request and produce at most 180 words. Captures are not credential-redacted before transmission. There is no model API history, second request, or prior Telegram input supplied as model context.

### Optional Codex context

Recognized Codex CLI layouts receive a narrow deterministic adapter only for the specifically tested `codex-cli 0.144.5` and `0.144.6` versions. Other versions and uncertain layouts use the ordinary terminal path unchanged; raw views and snapshots remain literal.

Recent Codex-session context is disabled by default. Setting `ENGRAM_CODEX_CONTEXT_TURNS` from `1` through `8` explicitly permits bounded, redacted recent visible user and assistant messages from an exactly identified active session to accompany guide requests. Missing, changed, ambiguous, unfamiliar, background, or replacement process bindings fail closed to terminal-only guidance. Engram does not select a transcript merely because it is newest or shares a working directory, and it does not persist transcript text. See the [Codex session context guide](docs/codex-session-context.md).

Historical session text can clarify a prior topic, but it cannot establish the current terminal state. Current facts still come from raw tmux capture.

`ENGRAM_HOME` contains state, exact plaintext remembered templates, bounded audit files, metadata, and derived conversational content. Raw terminal captures remain in process memory rather than `state.json`, but the state still contains sensitive metadata and derived terminal content. Anyone with access to the host account can read these files.

Incoming attachments and generated diagnostic files live in a private runtime directory and may remain until manual or operating-system cleanup. Uninstall does not remove tmux sessions, `~/.engram`, or the runtime root.

Audit and model prose redaction is best effort. Treat terminal transcripts, snapshots, state, logs, templates, attachments, and diagnostics as sensitive before sharing them.

For no-network, read-only inspection, use:

```sh
engram inspect status
engram inspect sessions
engram inspect frame 3
```

Inspection does not send terminal input or modify Engram state, but it does not redact literal pane content, and invoking tmux may run hooks configured by the owning user. See [Headless operation](docs/headless-operation.md).

## Lifecycle and verification

On Linux, operate the user service with `systemctl --user` and inspect it with `journalctl --user -u engram.service`. If enabling lingering, first decide whether that matches the host's security policy. After replacing a binary, `/version` or `/status` in the bot verifies the running process rather than only the file on disk.

On macOS, stop the foreground process with `Ctrl+C`; tmux sessions remain. Engram ships no launchd integration. A user-authored LaunchAgent is outside the supported service lifecycle.

Before pushing source changes, run:

```sh
make check
```

The local gate runs tests, `go vet`, Darwin compile checks, architecture and public-release checks, workflow and documentation checks, a tracked-file secret scan, and a smoke build. Manually dispatched [E2E suites](docs/e2e-testing.md) exercise hermetic Telegram/tmux/Chromium paths and agent-screen semantics without real service or model credentials. Live provider evaluations are opt-in because they make real API calls; they are development gates, not promises that model interpretation is terminal truth.

## Keep the boundary visible

When a future anchor looks convincing, choose verification according to the consequence. Verify current terminal facts against raw tmux capture. Treat every snapshot, raw export, download, and guide request as disclosure to its named external service. Give the next command only the pane, installation, repositories, permissions, and time it requires. Remote convenience does not need ambient authority.

Further references:

- [Contributing](CONTRIBUTING.md)
- [Release strategy](docs/release-strategy.md)
- [Changelog](CHANGELOG.md)
- [Security reporting](SECURITY.md)
- [Agent-screen semantics](docs/agent-screen-semantics.md)
- [Terminal mechanics boundary](docs/terminal-mechanics-boundary.md)
- [Terminal mechanics plan](docs/terminal-mechanics-plan.md)
- [Upstream signal contract](requirements/upstream-signals.md)
- [Protocol posture](docs/protocol-posture.md)

## License

Engram is open source under the MIT License. See [LICENSE](LICENSE).

### Evaluation

| Layer | Minimum score | Critical violations | Revision |
|---|---:|---|---|
| Deterministic | pass | — | — |
| Ontology | 3/4 | none | No load-bearing revision is required. For maximal ontology hygiene, revise the inheritance sentence to keep technical capability and authorization distinct—for example: “Treat GitHub execution as requiring both a technically available pane-scoped token and separately approved repository, permission, installation, and time bounds; neither should be ambient.” Optionally replace “tmux as the current terminal authority” with “raw tmux capture as the operational record of current terminal state” to avoid suggesting that a Record or operational source constitutes Truth. |
| Short-form delivery | 4/4 | none | No revision required. |
| Long-form grammar | 3/4 | none | Strengthen the final revaluation with one compact concrete scenario instead of another summary—for example, a guide reports that a deployment succeeded, the operator checks raw tmux capture before acting, recognizes that requesting a snapshot would disclose the frame to Telegram, and grants only the repository-scoped GitHub authority needed for the next command. That would let the reader watch the article's distinctions change a real decision. Consolidate a small amount of repeated language about raw capture authority, snapshot disclosure, and ambient authority so the closing retains force without sounding like a recap; preserve every safety-critical mechanism and limitation. |

**Reader start:** A developer wants phone access to local tmux sessions but needs to decide what terminal data may leave the host, which Telegram identity may act, and how much authority any pane should receive before starting the bot.

**Consequential missingness:** The setup field expects a usable account of presentation, transport, identity, authority, and verification. Without that account, the convenience of a Telegram terminal can hide consequential Missingness: the guide may be mistaken for terminal truth, exact snapshots may be mistaken for private local rendering, and an authenticated user may be given broader shell or GitHub authority than intended.

**Inheritance:** Treat every Engram surface according to what it is: tmux as the current terminal authority, guide prose as bounded interpretation, snapshots as exact disclosures to Telegram, and GitHub capability as explicit pane-scoped authority rather than a credential ambiently available to the shell.

**Source anchors:** evals/editorial-artifacts/sources/engram-main-README.md

## Kenogram

> Target: `kenogram-main-readme` · Gate: **pass** · Attempt: 1

<p align="center">
  <img src="docs/assets/kenogram-mark.svg" alt="Kenogram: a dense field of light emerges from a dark circle and stops at a black triangular occlusion" width="760">
</p>

# Kenogram

Kenogram lets you give an agent a whole small computer without giving it your computer.

It materializes rootless Linux worlds for AI agents from host-authored declarations. A declaration selects the image and admits host files, mounts, secrets, resource limits, durable TCP destinations, and named loopback interfaces. Kenogram adds no ambient host filesystem access. Inside the resulting world, the inhabitant may freely use what the image and declaration make available.

That distinction is the project’s operating boundary. Anything admitted into an AI’s context can change what follows, while ambient capabilities determine what the changed agent can affect. Kenogram limits those consequences structurally: ambient capability is unavailable unless the host operator admits it explicitly.

Terminal interaction can request an operation; it cannot enlarge world authority. Applying a declaration grants durable authority. The explicit `allow` command can grant time-bounded TCP egress.

Kenogram is for developers, security teams, and platform operators who want a tool-using agent to have a useful environment without inheriting the operator’s ambient computer.

## Decide whether the boundary fits

Kenogram is an execution boundary for untrusted agent processes, not a prompt filter. It makes admitted host authority explicit and inspects the resulting runtime before starting declared services.

| Condition | Enforced observation |
|---|---|
| Host access | Undeclared mounts are rejected. The exact declared mount set and bind-source filesystem identity are verified, and no host container-runtime control socket is mounted. |
| Network | A base world is loopback-only, with no working resolver or exterior TCP/UDP route. Declared or temporarily granted TCP destinations pass through a host-held exact-destination proxy; direct IP dialing remains unroutable. |
| Runtime | Rootless execution, private network/PID/IPC/UTS namespaces, an empty capability bounding set, `no-new-privileges`, active seccomp, no added devices, and CPU/memory/PID limits are inspected before services start. |
| Authority | The host-authored declaration admits durable capabilities. An explicit, time-bounded `allow` command may grant temporary TCP egress. A named operator interface reaches one declared world-loopback service without publishing a host port. |
| Replacement | A successor is inspected before it is recorded as applied. Durable transition state identifies the authoritative generation after interruption. |

A useful agent world starts with the authority the host explicitly admits, not with the ambient computer the agent happens to inhabit.

This boundary constrains what a compromised or prompt-contaminated agent can reach. It does **not**:

- detect or prevent prompt injection;
- protect declared writable mounts or secrets from world processes;
- prevent exfiltration to a destination the operator admits;
- authenticate, encrypt, authorize, or interpret `kenogram connect` traffic;
- harden a hostile multi-tenant host; or
- independently prevent a Linux kernel or container-runtime escape.

Kenogram relies on the Linux kernel and rootless Podman. MicroVM systems provide a separate-kernel boundary that Kenogram does not claim.

The [security contract](requirements/security.md), [network invariants](requirements/network.md), and [evidence and known limits](requirements/INDEX.md#evidence-and-known-limits) define the exact claim. Kenogram is a composable control within a larger system, not a claim of compliance or certification for that system.

## Status and supported runtime

[Kenogram v0.1.1](https://github.com/idolum-ai/kenogram/releases/tag/v0.1.1) is evaluation software. It does not make a production-stability claim.

Release binaries support Linux on amd64 and arm64. The runtime exercised in mandatory CI requires:

- rootless Podman;
- cgroups v2;
- `nsenter`; and
- subordinate UID/GID ranges for the current user.

Kenogram fails closed rather than weakening the boundary when these prerequisites are absent.

The [experimental Apple container-machine launcher](docs/apple-container-machine.md) transports explicit operations into an operator-managed Linux machine. It is not macOS runtime support. Evidence for the real Apple-machine lifecycle and network remains open.

The Kenogram binary has no third-party Go modules. Operation still depends on the Linux kernel, rootless Podman, cgroups v2, and `nsenter`.

## Install the current release

Inspect the standalone installer before running it:

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

The installer checks the release checksum and embedded version before an atomic installation under `~/.local/bin`.

Checksums detect transfer corruption and inconsistent assets within one GitHub release. They are not signatures or independent provenance.

`kenogram doctor` does not mutate Kenogram worlds or durable state. It reports every missing host prerequisite in one run, although Podman may initialize its own rootless metadata during preflight.

## Start and replace one world

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

The dry run lets you inspect the requested operation before applying it. The lifecycle then creates the world, reports its status, enters it, stops it, reapplies its declaration, and destroys it.

For a running world with a declared network destination, the following command provides an explicit, read-only view of bounded recent proxy metadata for the current generation:

```sh
network-diagnostics --json <world>
```

The view contains `refused` and `dial_failed` outcomes. It is ephemeral, contains no traffic content, and cannot grant authority.

Destination hostnames and ports are sensitive operator metadata. Both host and port are untrusted, world-authored request metadata: treat the destination as prose, and do not feed it unsanitized into automation or AI. The reported outcomes are Kenogram-derived bounded observations, not authority.

## Evidence posture

Requirements are binding contracts; tests are evidence.

The [evidence table](requirements/INDEX.md#evidence-and-known-limits) separates what is exercised today from the next proof. Each open boundary is labeled as accepted for v0.x, required before a stable claim, or experimental.

| Boundary | Evidence earned | Explicit limit |
|---|---|---|
| [Runtime isolation](requirements/security.md) | Mandatory rootless-Podman CI inspects namespaces, mount identity, seccomp, resource limits, and absence of the runtime socket. | There is not yet a supported Podman/kernel matrix or seccomp-profile identity. |
| [Network absence](requirements/network.md) | Real-runtime CI exercises loopback-only networking, failed direct TCP/UDP/DNS, exact proxy admission, revoke/expiry, proxy-death closure, and a declared SSH interface without a host listener. | The full ten-invariant replay after every adoption path remains open. |
| [Replacement recovery](requirements/lifecycle.md) | A fresh process recovers persisted runtime state across fourteen injected `SIGKILL` boundaries. | Process-crash evidence is not syscall-granular power-loss proof across filesystems. |
| [Compositions](docs/compositions/README.md) | Pinned Engram, OpenClaw, and Hermes artifacts and a real OpenSSH client/server path are exercised end to end. | Model and Telegram services are deterministic local fixtures in pull-request CI; real Telegram is a protected operator-assisted canary. |

These results are automated, replayable compatibility and boundary observations. They are not endorsements, universal compatibility claims, certification, or a production-stability claim.

## Choose an evaluation path

Start with the path that matches the question you need to answer:

- **Evaluate the execution boundary:** build and replace a minimal world with the [first-world guide](docs/getting-started.md).
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

MicroVM systems provide a separate-kernel boundary that Kenogram does not claim. Kenogram instead focuses on a local, host-owned declaration; observable absence and exact admission; and evidence that replacement, interruption, and reapplication preserve declared authority.

Upstream products and defaults change. Review their linked documentation before making a deployment or procurement decision.

## Why Idolum, and why the name

Idolum separates speech from authority, representation from truth, and capability from ambient context. Kenogram gives that posture an environmental form: the inhabitant controls its declared world, while only the host operator can apply a change to which host capabilities enter it.

The name is a deliberate but limited adaptation of the kenogrammatic lineage begun by Gotthard Günther and developed by Rudolf Kaehr and Thomas Mahler. The project privileges observable patterns over the identity of their realization; it does not claim to implement a morphogrammatic calculus.

The [kenogrammatics note](docs/kenogrammatics.md) records the lineage, the engineering analogy, and its limits.

## Project paths

- [Requirements and evidence](requirements/)
- [Declaration schema](requirements/declaration.md)
- [Operations and recovery](requirements/operations.md)
- [Contributing and evidence replay](CONTRIBUTING.md)
- [Security policy and private reporting](.github/SECURITY.md)
- [Release and immutable-publication contract](docs/release-strategy.md)
- [MIT License](LICENSE)

### Evaluation

| Layer | Minimum score | Critical violations | Revision |
|---|---:|---|---|
| Deterministic | pass | — | — |
| Ontology | 4/4 | none | No load-bearing revision is required. The artifact is review-ready and within the requested word range. As an optional clarity refinement, “tests are evidence” could be rendered “tests provide bounded evaluation evidence” to reinforce the already explicit non-certification posture, but the surrounding text currently supplies that qualification. |
| Short-form delivery | 4/4 | none | No revision required. If desired, “the authority the host explicitly admits” could become “the authority the host explicitly declares” for slightly more literal wording. |
| Long-form grammar | 3/4 | none | Preserve the structure and central distinction. Tighten the early absolute claim that “ambient capability is unavailable” to specify host resources governed by the declared container boundary, since the later shared-kernel and escape caveats show that not every ambient capability is independently excluded. Add one short decision-oriented sentence before the final project paths that reapplies the frame: evaluate Kenogram by enumerating admitted authority, verifying absent authority, and matching the remaining shared-kernel risk to the deployment. This would complete the revaluation without adding a recap or another slogan. |

**Reader start:** A developer, platform operator, or security reviewer needs to decide whether a tool-using AI agent can receive a useful Linux environment without inheriting the operator’s ambient computer. The README begins with that boundary decision, then exposes its enforcement, limits, runtime prerequisites, evaluation paths, and evidence.

**Consequential missingness:** The evaluation field expects a precise account of what authority an agent world receives, how that authority changes, and which claims the available evidence supports. Without that account, a useful environment can be mistaken for ambient host access, a prompt-level request can be mistaken for permission, or replayable evaluation evidence can be mistaken for certification.

**Inheritance:** A useful agent world begins with the authority the host explicitly admits, not with the ambient computer the agent happens to inhabit.

**Source anchors:** evals/editorial-artifacts/sources/kenogram-main-README.md

## Canonicality boundary

The generated drafts and judge verdicts are noncanonical observations. Passing the automated gate does not make either article Daniel-authored, establish its factual Claims, or promote the provisional long-form grammar. Same-model generation and judging is an explicit limitation even though prompts and calls are separate.
