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
