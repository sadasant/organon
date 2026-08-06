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
