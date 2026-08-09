---
type: project-ontology-source-dossier
project: Engram
commit: 1b56983ac658f10bfbd76c44bfc99c20b1355ebe
generated_from: exact cited line ranges with two lines of context
---

# Engram Source Dossier

Every excerpt is copied from the exact public source commit above. Line numbers preserve upstream coordinates.

## `README.md`

### Lines 9-31

```text
00009 | </p>
00010 |
00011 | Engram is a single-user Telegram control surface for local tmux sessions. It
00012 | creates or attaches to tmux windows, routes Telegram messages into panes, and
00013 | presents each pane as one stable, pinned Telegram anchor. That anchor can be a
00014 | conversational guide or an exact terminal image rendered locally by Chromium.
00015 |
00016 | **Why tmux?** Its mature, narrow command surface has effectively crystallized.
00017 | Very little API drift is expected, which makes tmux an unusually durable
00018 | substrate for a small remote-work tool.
00019 |
00020 | ## Two options are available
00021 |
00022 | | Conversational guide | Chromium |
00023 | | --- | --- |
00024 | | **Experience:** the selected model conveys the bounded terminal frame as compact, natural conversation.<br><br>**Pros:** quick to absorb across many sessions; plain language can make dense output legible.<br><br>**Cons:** a model can misunderstand the pane; raw bounded terminal text leaves the machine.<br><br>**Dependencies:** Anthropic Haiku 4.5 or OpenAI Luna, selected with `LLM_PROVIDER`, plus that provider's API key and network access. Chromium is optional and enables `🖼️ View` plus `/mode snapshot`. | **Experience:** Chromium renders the same bounded frame as a phone-width, ANSI-preserving terminal image. Retained history uses the established tall canvas; alternate-screen programs use their actual viewport height.<br><br>**Pros:** literal and deterministic; no model interpretation is required.<br><br>**Cons:** exact terminal content is uploaded to Telegram; rendering uses more local CPU and each frame is denser to inspect.<br><br>**Dependencies:** a local Chromium-compatible executable, optionally selected with `ENGRAM_SNAPSHOT_BROWSER`. A configured guide provider is optional and enables `🗣️ Talk` plus `/mode guide`. |
00025 |
00026 | `ENGRAM_ANCHOR_MODE` is the startup fallback when no usable persisted choice
00027 | exists. The selected guide is available when configured; Chromium is locally probed.
00028 | `/mode guide` and `/mode snapshot` begin migrating the live anchors and persist
00029 | that choice across restarts.
00030 |
00031 | ## First Run
```

### Lines 190-217

```text
00190 | use the ordinary terminal path unchanged; raw views and snapshots always remain
00191 | literal. When Codex reports its tested fast mode, the deterministic line retains
00192 | that state as `Codex · gpt-5.6-sol · high · fast · working`.
00193 |
00194 | An additional Codex-session context path is available only as an explicit
00195 | privacy opt-in. Set `ENGRAM_CODEX_CONTEXT_TURNS` to `1` through `8` to let guide
00196 | requests include that many recent user turns and their user-visible assistant messages from
00197 | the exact active Codex session. Engram requires a pane-local UUID published by
00198 | the `SessionStart` hook or explicit `engram codex-bind`, a binding observation
00199 | no older than the proven Codex process incarnation, an unambiguous rollout
00200 | filename carrying the same UUID, and matching `session_meta`. It validates the
00201 | foreground process group and precise kernel process incarnation again after
00202 | reading, and revalidates both the pane-local session binding and process before
00203 | publishing derived output. A missing or changed binding, background or
00204 | replacement process, ambiguous file, or unfamiliar message record fails closed
00205 | to terminal-only guidance; Engram never selects a transcript because it is
00206 | newest or shares a working directory.
00207 |
00208 | Historical session text can clarify the prior topic but never establishes the
00209 | current terminal state. Raw tmux capture remains the only authority for current
00210 | facts, files, references, hashes, and screenshots. Only bounded text from
00211 | visible `user` and `assistant` messages is admitted; system/developer messages,
00212 | hidden reasoning, tool calls and results, generated environment metadata, and
00213 | attachments are excluded. The normal secret redactor and fixed message/byte
00214 | ceilings run before the selected guide provider sees this context. Each full
00215 | message is redacted before its per-message byte ceiling is applied, so a secret
00216 | spanning that boundary is not partially exposed. Engram does not persist
00217 | transcript text.
```


## `docs/design-principles.md`

### Lines 37-62

```text
00037 | the wrong feature adds another surface the user must manage.
00038 |
00039 | ### tmux is the workspace
00040 |
00041 | tmux remains the source of terminal truth. Engram should not emulate a
00042 | terminal, invent session state, or hide what happened in the pane. It creates,
00043 | attaches, captures, and sends input to tmux. `/raw` and `/dump` preserve direct
00044 | ways to inspect exact state.
00045 |
00046 | tmux is a deliberate dependency because its mature, narrow interface has
00047 | effectively crystallized. Low expected API drift lets Engram stay small and
00048 | precise instead of continually adapting to a moving workspace substrate.
00049 | Engram-created windows use a stable configured size, defaulting to `100x48`, so
00050 | their applications render against real tmux geometry consistently across
00051 | attached and detached hosts. Engram does not resize windows that the user
00052 | explicitly attaches.
00053 |
00054 | ### Phone-first anchors
00055 |
00056 | The editable Telegram anchor is the core product surface. It should identify
00057 | the session, show what the pane is doing, and make the next useful action easy.
00058 | Each expanded session has exactly one canonical, pinned anchor. A collapsed
00059 | session instead has one inert shelf entry and no individual route. Older
00060 | anchors become inert; two actionable representations of one pane are a product
00061 | error.
00062 |
```

### Lines 67-103

```text
00067 | Snapshot anchors keep the exact delivered frame's literal text one tap away
00068 | through a `📄 Raw` attachment; the image is primary, not exclusive.
00069 |
00070 | Running anchors may move into one shared pinned shelf when the user needs less
00071 | visual weight. Each collapsed session contributes one cached status line, but
00072 | the shelf is deliberately not a terminal input route. Its only control is
00073 | `➕ Show`, which restores every member as an individual canonical anchor in the
00074 | selected guide or snapshot mode. Restoration acknowledges immediately, makes
00075 | each prospective anchor durable and pinned while inert, promotes its reply
00076 | identity, and only then grants controls. If those controls cannot be exposed,
00077 | the member returns to the shelf instead of remaining as an inert canonical
00078 | card. The handoff remains explicitly pending until those controls are durable.
00079 | Collapse follows the reciprocal rule: the individual anchor remains
00080 | canonical until the shared shelf is rendered and pinned. The shelf identifies
00081 | its summaries as cached because hiding a session also stops observation. If
00082 | both a shelf and its predecessor disappear, Engram creates one fresh shelf
00083 | instead of oscillating between dead identities. Messages that still exist but
00084 | cannot be edited remain owned until their controls and pin are retired.
00085 |
00086 | ### Fast input path
00087 |
00088 | Sending input to tmux must remain fast when a model provider, Chromium, or Telegram
00089 | delivery is delayed or failing. Replying to an anchor and using `/send`,
00090 | `/text`, `/key`, or deterministic key buttons should route directly and
00091 | predictably to the intended pane. A natural-language key description is a
00092 | separate proposal path: the model receives only that description, its output is
00093 | reduced to a closed physical-key representation, and the exact target and
00094 | sequence require an explicit current confirmation. Presentation work and key
00095 | interpretation must not block ordinary input; an interactive tmux operation may
00096 | preempt Engram's own background observation and recovery work.
00097 |
00098 | Remembered input should remain explicit text, not inferred automation. A user
00099 | may give exact prose a short name and invoke it with a typed placeholder.
00100 | Engram expands that placeholder once immediately before the ordinary guarded
00101 | input path; it does not learn triggers, recurse through template bodies, or run
00102 | anything merely because terminal output resembles a past situation.
00103 |
```

### Lines 213-236

```text
00213 | latest alternate of each kind may act as a reply handle for its session; an
00214 | older alternate is explicitly stale and cannot route input.
00215 |
00216 | ### Deterministic facts beat guesses
00217 |
00218 | Engram should compute session IDs, tmux targets, pane IDs, working directories,
00219 | attachment paths, visible files and URLs, capture hashes, timestamps, and
00220 | service status locally. Extracted references are untrusted pane content;
00221 | Engram does not fetch or endorse them.
00222 |
00223 | A snapshot footer may include one bounded fact produced by a trusted local
00224 | shell command from the protected Engram configuration. This is a narrow Unix
00225 | pipe, not a catalog of operating-system status providers or a plugin protocol:
00226 | the command receives the pane directory and returns one sanitized line. Engram
00227 | owns its visual budget, runs it only while a render is already happening, and
00228 | does not let status-only changes create automatic edits.
00229 |
00230 | The selected model interprets only the bounded terminal text. Terminal text is data, not
00231 | authority; the prompt tells it to ignore instructions addressed to Engram or
00232 | the reader, while recognizing that model-level injection resistance is best
00233 | effort. Model output is presentation and is never executed automatically.
00234 | The guide should not invent history, claim work succeeded, or explain Engram
00235 | controls unless the terminal itself is about Engram.
00236 |
```

### Lines 269-278

```text
00269 | changed. A manual refresh captures and renders immediately; a snapshot refresh
00270 | may redraw an unchanged frame because the user explicitly asked to look now.
00271 |
00272 | ### Recoverable local service
00273 |
00274 | State under `~/.engram` should recover sessions, canonical anchors, the shared
00275 | collapsed shelf and its members, selected mode, attachments, poll position, and recent errors after restart. Diagnostics
00276 | must be available locally and through Telegram without exposing configured
00277 | credentials.
00278 |
```


## `docs/protocol-posture.md`

### Lines 15-66

```text
00015 | The boundary to standardize is truth and attention, not transport.
00016 |
00017 | ## What Engram Is
00018 |
00019 | tmux is already the durable workspace. Engram contributes:
00020 |
00021 | 1. a cheap handle for addressing a watched pane;
00022 | 2. one bounded observation of that pane;
00023 | 3. a stable current view that can route a reply;
00024 | 4. conservative recovery when capture, presentation, delivery, or persistence
00025 |    fails partway through an operation.
00026 |
00027 | The product measure is time to trustworthy orientation plus time to safe next
00028 | input across many panes. Protocol work is justified only when it improves that
00029 | measure or protects it from ambiguity.
00030 |
00031 | ## Irreducible Nouns
00032 |
00033 | - Pane identity: the immutable `%pane_id` and `@window_id` pair validated at
00034 |   effect time.
00035 | - Watch: Engram's local record binding a user-facing session ID to pane identity,
00036 |   provenance, lifecycle, and observation state. It is not a tmux session.
00037 | - Frame: one bounded physical ANSI and joined logical observation over shared
00038 |   coordinates.
00039 | - Current view: the one canonical presentation for a watch in the selected
00040 |   frontend.
00041 | - Route: a current view or latest alternate that may request input for the same
00042 |   watch. Superseded routes are stale.
00043 | - Input action: command plus Enter, literal text without Enter, or validated keys.
00044 | - Attention record: a bounded terminal-authored request to look, with a random
00045 |   deduplication ID but no sender identity.
00046 |
00047 | These nouns are enough to state Engram's important transitions without exposing
00048 | Telegram IDs, state-file fields, scheduler maps, or renderer mechanics.
00049 |
00050 | ## Invariants Worth Standardizing
00051 |
00052 | 1. Pane-bound effects require the stored immutable identity pair to validate.
00053 |    Timeout or generic failure does not prove loss.
00054 | 2. Input kinds remain distinct and presentation never blocks their critical path.
00055 | 3. Physical and logical presentations derive from one bounded frame.
00056 | 4. A watch has at most one actionable current view per selected frontend.
00057 | 5. Only the latest route of each alternate kind may act; known stale routes fail
00058 |    closed and explain why.
00059 | 6. Replacement records the successor before retiring the predecessor wherever
00060 |    the external medium permits.
00061 | 7. Attention records are best effort, bounded, deduplicated, terminal-authored,
00062 |    and untrusted. They never become commands or authentication.
00063 | 8. Uncertain shell effects are not replayed after restart.
00064 | 9. Presentation failure does not kill tmux work or falsely claim pane loss.
00065 |
00066 | Requirements and black-box tests are the compatibility surface for these
```

### Lines 75-87

```text
00075 | Engram already does.
00076 |
00077 | ### Terminal attention record: adopt deliberately
00078 |
00079 | The existing BEL plus `[engram:upstream]` record is Engram's natural open
00080 | producer/consumer boundary. Independent programs can emit it through the PTY
00081 | without credentials, discovery, or topology.
00082 |
00083 | Keep it one-way, text-only, bounded, best effort, and visibly untrusted. Do not
00084 | add acknowledgement, sender identity, attachments, typed jobs, guaranteed
00085 | delivery, or direct routing to nested sessions under the same version.
00086 |
00087 | ### Internal event vocabulary: use sparingly
```


## `internal/app/app.go`

### Lines 434-457

```text
00434 | 				return a.quitCode
00435 | 			}
00436 | 		}
00437 | 	}
00438 | }
00439 |
00440 | func (a *App) handleUpdate(ctx context.Context, update telegram.Update) string {
00441 | 	if update.CallbackQuery != nil {
00442 | 		return a.handleCallback(ctx, *update.CallbackQuery)
00443 | 	}
00444 | 	if update.Message == nil {
00445 | 		return "skipped_no_message"
00446 | 	}
00447 | 	msg := *update.Message
00448 | 	if !a.authorized(&msg) {
00449 | 		_ = a.audit("auth.reject", "rejected", map[string]any{"kind": "message"})
00450 | 		return "rejected_unauthorized"
00451 | 	}
00452 | 	key := fmt.Sprintf("%d:%d", msg.Chat.ID, msg.MessageID)
00453 | 	if a.Store.SeenMessage(key) {
00454 | 		return "skipped_duplicate_message"
00455 | 	}
00456 | 	if err := a.Store.MarkMessage(key); err != nil {
00457 | 		_ = a.audit("state.message", "failed", map[string]any{"message_id": msg.MessageID, "error": err.Error()})
```

### Lines 498-522

```text
00498 | 		a.reply(ctx, msg, "reply to a session anchor to send slash input; for example, //clear sends /clear")
00499 | 		return "handled_unroutable_slash_input"
00500 | 	}
00501 | 	if strings.HasPrefix(routingText, "/") {
00502 | 		return a.handleCommand(ctx, msg, msg.Text)
00503 | 	}
00504 | 	if msg.ReplyToMessage != nil {
00505 | 		if ts, targetState, found := a.Store.FindReplyTarget(msg.Chat.ID, msg.ReplyToMessage.MessageID); found && targetState == state.ReplyTargetCurrent {
00506 | 			expanded, err := a.prepareTypedInput(msg.Text, "reply", ts.ID)
00507 | 			if err != nil {
00508 | 				a.reply(ctx, msg, err.Error())
00509 | 				return "anchor_reply_template_error"
00510 | 			}
00511 | 			result := a.sendReplyInput(ctx, ts, msg.Chat.ID, msg.ReplyToMessage.MessageID, expanded)
00512 | 			if !result.OK() {
00513 | 				a.reply(ctx, msg, result.Message)
00514 | 			}
00515 | 			return result.status("anchor_reply")
00516 | 		} else if found && targetState == state.ReplyTargetStale {
00517 | 			a.reply(ctx, msg, a.staleReply(ts))
00518 | 			return "anchor_reply_stale"
00519 | 		}
00520 | 		if a.isCollapsedShelfMessage(msg.Chat.ID, msg.ReplyToMessage.MessageID) {
00521 | 			a.reply(ctx, msg, collapsedShelfReplyMessage)
00522 | 			return "anchor_reply_user_error"
```

### Lines 551-562

```text
00551 | 	if !strings.HasPrefix(text[start:], "//") {
00552 | 		return "", false
00553 | 	}
00554 | 	return text[:start] + text[start+1:], true
00555 | }
00556 |
00557 | func (a *App) authorized(msg *telegram.Message) bool {
00558 | 	if msg.Chat.ID != a.Config.TelegramChatID {
00559 | 		return false
00560 | 	}
00561 | 	if msg.From == nil || msg.From.ID != a.Config.TelegramAllowedUserID {
00562 | 		return false
```


## `internal/app/github_auth.go`

### Lines 63-212

```text
00063 | }
00064 |
00065 | func (a *App) startGitHubBroker(ctx context.Context) {
00066 | 	broker, err := githubauth.Listen(a.Config.GitHubBrokerSocketPath(), a.handleGitHubBrokerRequest)
00067 | 	if err != nil {
00068 | 		_ = a.audit("github.broker", "unavailable", map[string]any{"error": err.Error()})
00069 | 		return
00070 | 	}
00071 | 	a.githubBroker = broker
00072 | 	a.schedulerWG.Add(1)
00073 | 	go func() {
00074 | 		defer a.schedulerWG.Done()
00075 | 		defer broker.Close()
00076 | 		if err := broker.Serve(ctx); err != nil && ctx.Err() == nil {
00077 | 			_ = a.audit("github.broker", "failed", map[string]any{"error": err.Error()})
00078 | 		}
00079 | 	}()
00080 | 	_ = a.audit("github.broker", "ready", map[string]any{"socket": a.Config.GitHubBrokerSocketPath()})
00081 | }
00082 |
00083 | func (a *App) handleGitHubBrokerRequest(ctx context.Context, request githubauth.BrokerRequest) githubauth.BrokerResponse {
00084 | 	defer githubauth.Zero(request.Passphrase)
00085 | 	if a.GitHubVault == nil {
00086 | 		return githubauth.BrokerResponse{Error: "GitHub App capabilities are unavailable"}
00087 | 	}
00088 | 	session, err := a.validateGitHubBrokerBinding(ctx, request.Binding)
00089 | 	if err != nil {
00090 | 		return githubauth.BrokerResponse{Error: err.Error()}
00091 | 	}
00092 | 	switch request.Action {
00093 | 	case githubauth.ActionStatus:
00094 | 		return githubauth.BrokerResponse{OK: true, Leases: a.githubLeaseInfos(request.Binding), Grants: a.githubGrantInfos(request.Binding)}
00095 | 	case githubauth.ActionRevoke:
00096 | 		if err := a.revokeGitHubBindingAuthority(ctx, session.ID, request.Binding); err != nil {
00097 | 			return githubauth.BrokerResponse{Error: err.Error()}
00098 | 		}
00099 | 		return githubauth.BrokerResponse{OK: true}
00100 | 	case githubauth.ActionExec, githubauth.ActionGrant:
00101 | 	default:
00102 | 		return githubauth.BrokerResponse{Error: "unsupported GitHub broker action"}
00103 | 	}
00104 |
00105 | 	if err := a.GitHubVault.Reload(); err != nil {
00106 | 		return githubauth.BrokerResponse{Error: "reload GitHub App vault: " + err.Error()}
00107 | 	}
00108 | 	app, found := a.GitHubVault.Get(request.App)
00109 | 	if !found {
00110 | 		return githubauth.BrokerResponse{Error: fmt.Sprintf("GitHub App %q is not enrolled", request.App)}
00111 | 	}
00112 | 	app, err = app.SelectInstallation(request.InstallationID)
00113 | 	if err != nil {
00114 | 		return githubauth.BrokerResponse{Error: err.Error()}
00115 | 	}
00116 | 	request.InstallationID = app.EffectiveInstallationID()
00117 | 	if request.Action == githubauth.ActionExec {
00118 | 		if lease, ok := a.reusableGitHubLease(request, app); ok && lease.Info.GrantID == "" {
00119 | 			if err := a.validateGitHubBrokerContinuation(ctx, session, request.Binding); err != nil {
00120 | 				if a.discardGitHubLease(request.Binding, lease.Token) {
00121 | 					err = a.revokeDiscardedGitHubToken(ctx, githubRevocationForLease(lease), err)
00122 | 				}
00123 | 				_ = a.audit("github.lease", "invalidated", githubAuditRequest(session.ID, request))
00124 | 				return githubauth.BrokerResponse{Error: err.Error()}
00125 | 			}
00126 | 			if _, err := a.reloadMatchingGitHubEnrollment(lease.Enrollment); err != nil {
00127 | 				if a.discardGitHubLease(request.Binding, lease.Token) {
00128 | 					err = a.revokeDiscardedGitHubToken(ctx, githubRevocationForLease(lease), err)
00129 | 				}
00130 | 				_ = a.audit("github.lease", "enrollment_changed", githubAuditRequest(session.ID, request))
00131 | 				return githubauth.BrokerResponse{Error: err.Error()}
00132 | 			}
00133 | 			_ = a.audit("github.lease", "reused", githubAuditRequest(session.ID, request))
00134 | 			return githubauth.BrokerResponse{OK: true, Token: lease.Token, ExpiresAt: lease.Info.ExpiresAt}
00135 | 		}
00136 | 		if response, consumed := a.consumeGitHubGrant(ctx, session, request, app); consumed {
00137 | 			return response
00138 | 		}
00139 | 	}
00140 | 	if request.Action == githubauth.ActionGrant && request.GrantFor > a.Config.EffectiveGitHubGrantMaxDuration() {
00141 | 		return githubauth.BrokerResponse{Error: fmt.Sprintf(
00142 | 			"renewable grant duration exceeds configured maximum %s",
00143 | 			a.Config.EffectiveGitHubGrantMaxDuration(),
00144 | 		)}
00145 | 	}
00146 | 	if (!app.TelegramUnlock || request.LocalUnlock) && len(request.Passphrase) == 0 {
00147 | 		return githubauth.BrokerResponse{Error: "this GitHub App requires local passphrase entry", ErrorCode: githubauth.ErrorCodeLocalPassphraseRequired}
00148 | 	}
00149 | 	pending, err := a.beginGitHubApproval(ctx, session, request, app)
00150 | 	if err != nil {
00151 | 		return githubauth.BrokerResponse{Error: err.Error()}
00152 | 	}
00153 | 	defer a.finishGitHubPending(pending)
00154 |
00155 | 	timer := time.NewTimer(time.Until(pending.ExpiresAt))
00156 | 	defer timer.Stop()
00157 | 	var approval githubApproval
00158 | 	select {
00159 | 	case <-ctx.Done():
00160 | 		a.completeGitHubApprovalMessage(pending, "Canceled: Engram stopped before this request completed.")
00161 | 		return githubauth.BrokerResponse{Error: "GitHub capability request was canceled"}
00162 | 	case <-timer.C:
00163 | 		a.completeGitHubApprovalMessage(pending, "Expired: no approval was received within fifteen minutes.")
00164 | 		_ = a.audit("github.approval", "expired", githubAuditRequest(session.ID, request))
00165 | 		return githubauth.BrokerResponse{Error: "GitHub capability request expired"}
00166 | 	case approval = <-pending.Result:
00167 | 	}
00168 | 	if approval.err != nil {
00169 | 		a.completeGitHubApprovalMessage(pending, "Denied: no GitHub capability was granted.")
00170 | 		_ = a.audit("github.approval", "denied", githubAuditRequest(session.ID, request))
00171 | 		return githubauth.BrokerResponse{Error: approval.err.Error()}
00172 | 	}
00173 | 	defer githubauth.Zero(approval.passphrase)
00174 | 	if err := a.validateGitHubBrokerContinuation(ctx, session, request.Binding); err != nil {
00175 | 		a.completeGitHubApprovalMessage(pending, "Canceled: the requesting tmux pane is no longer valid.")
00176 | 		_ = a.audit("github.approval", "invalidated", githubAuditRequest(session.ID, request))
00177 | 		return githubauth.BrokerResponse{Error: err.Error()}
00178 | 	}
00179 | 	if _, err := a.reloadMatchingGitHubEnrollment(pending.Enrollment); err != nil {
00180 | 		a.completeGitHubApprovalMessage(pending, "Canceled: the GitHub App enrollment changed during approval.")
00181 | 		_ = a.audit("github.approval", "enrollment_changed", githubAuditRequest(session.ID, request))
00182 | 		return githubauth.BrokerResponse{Error: err.Error()}
00183 | 	}
00184 |
00185 | 	privateKey, unlockedApp, err := a.GitHubVault.Unlock(request.App, approval.passphrase)
00186 | 	if err != nil {
00187 | 		a.completeGitHubApprovalMessage(pending, "Failed: the GitHub App credential could not be unlocked.")
00188 | 		_ = a.audit("github.unlock", "failed", githubAuditRequest(session.ID, request))
00189 | 		return githubauth.BrokerResponse{Error: githubauth.ErrUnlock.Error()}
00190 | 	}
00191 | 	defer githubauth.Zero(privateKey)
00192 | 	unlockedApp, err = unlockedApp.SelectInstallation(request.InstallationID)
00193 | 	if err != nil {
00194 | 		a.completeGitHubApprovalMessage(pending, "Canceled: the selected GitHub App installation changed during approval.")
00195 | 		return githubauth.BrokerResponse{Error: err.Error()}
00196 | 	}
00197 | 	if a.GitHubMinter == nil {
00198 | 		return githubauth.BrokerResponse{Error: "GitHub token minting is unavailable"}
00199 | 	}
00200 | 	if request.Action == githubauth.ActionGrant {
00201 | 		return a.createGitHubGrant(ctx, session, pending, request, unlockedApp, privateKey)
00202 | 	}
00203 | 	if err := a.reserveGitHubTokenSlot(); err != nil {
00204 | 		a.completeGitHubApprovalMessage(pending, "Failed: Engram's bounded GitHub token budget is full.")
00205 | 		_ = a.audit("github.mint", "capacity_rejected", githubAuditRequest(session.ID, request))
00206 | 		return githubauth.BrokerResponse{Error: err.Error()}
00207 | 	}
00208 | 	defer a.releaseGitHubTokenSlot()
00209 | 	mintCtx, cancel := context.WithTimeout(ctx, 45*time.Second)
00210 | 	token, err := a.GitHubMinter.Mint(mintCtx, unlockedApp, privateKey, request.Repositories, request.Permissions)
00211 | 	cancel()
00212 | 	if err != nil {
```

### Lines 271-390

```text
00271 | }
00272 |
00273 | func (a *App) validateGitHubBrokerBinding(ctx context.Context, binding githubauth.Binding) (state.TerminalSession, error) {
00274 | 	var matched state.TerminalSession
00275 | 	found := false
00276 | 	for _, session := range a.Store.Snapshot().TerminalSessions {
00277 | 		if session.TmuxServerID == binding.ServerID && session.TmuxWindowID == binding.WindowID && session.TmuxPaneID == binding.PaneID {
00278 | 			matched = session
00279 | 			found = true
00280 | 			break
00281 | 		}
00282 | 	}
00283 | 	if !found || matched.State != state.TerminalRunning || !matched.WatchEnabled {
00284 | 		return state.TerminalSession{}, fmt.Errorf("requesting tmux pane is not an active Engram session")
00285 | 	}
00286 | 	tmuxCtx, cancel := tmux.TimeoutContext(ctx)
00287 | 	defer cancel()
00288 | 	if _, err := a.Tmux.ValidateBinding(tmuxCtx, binding.PaneID, binding.WindowID, binding.ServerID); err != nil {
00289 | 		return state.TerminalSession{}, fmt.Errorf("requesting tmux pane identity is no longer valid")
00290 | 	}
00291 | 	return matched, nil
00292 | }
00293 |
00294 | func (a *App) validateGitHubBrokerContinuation(ctx context.Context, expected state.TerminalSession, binding githubauth.Binding) error {
00295 | 	if ctx.Err() != nil {
00296 | 		return fmt.Errorf("GitHub capability request was canceled")
00297 | 	}
00298 | 	current, err := a.validateGitHubBrokerBinding(ctx, binding)
00299 | 	if err != nil {
00300 | 		return err
00301 | 	}
00302 | 	if current.ID != expected.ID || !current.CreatedAt.Equal(expected.CreatedAt) {
00303 | 		return fmt.Errorf("requesting tmux pane identity changed during GitHub capability approval")
00304 | 	}
00305 | 	return nil
00306 | }
00307 |
00308 | func (a *App) revokeDiscardedGitHubToken(ctx context.Context, pending githubRevocation, cause error) error {
00309 | 	if a.GitHubMinter == nil {
00310 | 		return cause
00311 | 	}
00312 | 	revokeCtx, cancel := context.WithTimeout(context.WithoutCancel(ctx), 15*time.Second)
00313 | 	err := a.GitHubMinter.Revoke(revokeCtx, pending.Token)
00314 | 	cancel()
00315 | 	if err != nil {
00316 | 		a.trackGitHubRevocation(pending.Token, pending.SessionID, pending.App, pending.InstallationID, pending.ExpiresAt)
00317 | 		return fmt.Errorf("%w; revoke discarded GitHub token: %v", cause, err)
00318 | 	}
00319 | 	return cause
00320 | }
00321 |
00322 | func githubRevocationForLease(lease githubLease) githubRevocation {
00323 | 	return githubRevocation{
00324 | 		Token: lease.Token, SessionID: lease.SessionID, App: lease.Info.App,
00325 | 		InstallationID: lease.Info.InstallationID, ExpiresAt: lease.Info.ExpiresAt,
00326 | 	}
00327 | }
00328 |
00329 | func (a *App) beginGitHubApproval(ctx context.Context, session state.TerminalSession, request githubauth.BrokerRequest, app githubauth.App) (*githubPendingRequest, error) {
00330 | 	requestID, err := githubRequestID()
00331 | 	if err != nil {
00332 | 		return nil, err
00333 | 	}
00334 | 	command := compactGitHubCommand(request.Command)
00335 | 	if request.Action == githubauth.ActionExec && a.redactText(command) != command {
00336 | 		return nil, fmt.Errorf("GitHub child command contains secret material that cannot be disclosed safely for approval")
00337 | 	}
00338 | 	if request.Action == githubauth.ActionGrant && a.redactText(request.Purpose) != request.Purpose {
00339 | 		return nil, fmt.Errorf("renewable GitHub grant purpose contains secret material that cannot be disclosed safely")
00340 | 	}
00341 | 	now := a.githubTime()
00342 | 	grantExpiresAt := time.Time{}
00343 | 	if request.Action == githubauth.ActionGrant {
00344 | 		grantExpiresAt = now.Add(request.GrantFor)
00345 | 	}
00346 | 	text := a.githubApprovalText(session, request, app, grantExpiresAt)
00347 | 	if len(text) > 3500 {
00348 | 		return nil, fmt.Errorf("GitHub capability request is too large to present safely in Telegram")
00349 | 	}
00350 | 	pendingRequest := request
00351 | 	pendingRequest.Passphrase = nil
00352 | 	pending := &githubPendingRequest{
00353 | 		ID:              requestID,
00354 | 		SessionID:       session.ID,
00355 | 		BindingKey:      githubBindingKey(request.Binding),
00356 | 		Request:         pendingRequest,
00357 | 		LocalPassphrase: append([]byte(nil), request.Passphrase...),
00358 | 		ExpiresAt:       now.Add(githubApprovalTTL),
00359 | 		ApprovalText:    text,
00360 | 		ApprovalSummary: githubApprovalCompletionSummary(session, request, app),
00361 | 		State:           "pending",
00362 | 		Result:          make(chan githubApproval, 1),
00363 | 		Enrollment:      app,
00364 | 		GrantExpiresAt:  grantExpiresAt,
00365 | 	}
00366 | 	a.githubMu.Lock()
00367 | 	for _, existing := range a.githubPending {
00368 | 		if existing.BindingKey == pending.BindingKey && existing.State != "resolved" && existing.ExpiresAt.After(a.githubTime()) {
00369 | 			a.githubMu.Unlock()
00370 | 			return nil, fmt.Errorf("this tmux pane already has a pending GitHub capability request")
00371 | 		}
00372 | 	}
00373 | 	a.githubPending[pending.ID] = pending
00374 | 	a.githubMu.Unlock()
00375 |
00376 | 	message, err := a.Telegram.SendHTMLMessage(ctx, a.Config.TelegramChatID, text, session.AnchorMessageID, telegram.GitHubApprovalMarkup(requestID))
00377 | 	if err != nil {
00378 | 		a.finishGitHubPending(pending)
00379 | 		return nil, fmt.Errorf("send GitHub approval request: %w", err)
00380 | 	}
00381 | 	a.githubMu.Lock()
00382 | 	if current := a.githubPending[pending.ID]; current == pending {
00383 | 		pending.ApprovalMessageID = message.MessageID
00384 | 	}
00385 | 	a.githubMu.Unlock()
00386 | 	a.queueManualRefresh(session.ID)
00387 | 	_ = a.audit("github.approval", "requested", githubAuditRequest(session.ID, request))
00388 | 	return pending, nil
00389 | }
00390 |
```


## `internal/app/github_grant.go`

### Lines 67-98

```text
00067 | 		return githubauth.BrokerResponse{Error: "renewable GitHub grant expired before it could be stored"}
00068 | 	}
00069 | 	grant := githubGrant{
00070 | 		SessionID:        session.ID,
00071 | 		SessionCreatedAt: session.CreatedAt,
00072 | 		Binding:          request.Binding,
00073 | 		Enrollment:       enrollment,
00074 | 		Info: githubauth.GrantInfo{
00075 | 			ID:             grantID,
00076 | 			App:            request.App,
00077 | 			InstallationID: request.InstallationID,
00078 | 			Repositories:   append([]string(nil), request.Repositories...),
00079 | 			Permissions:    copyStringMap(request.Permissions),
00080 | 			Purpose:        request.Purpose,
00081 | 			CreatedAt:      now,
00082 | 			ExpiresAt:      pending.GrantExpiresAt,
00083 | 		},
00084 | 		PrivateKey: append([]byte(nil), privateKey...),
00085 | 	}
00086 | 	oldLeases := a.storeGitHubGrant(grant)
00087 | 	a.revokeGitHubLeases(oldLeases)
00088 | 	a.queueManualRefresh(session.ID)
00089 | 	a.completeGitHubApprovalMessage(pending, fmt.Sprintf(
00090 | 		"✓ Active until %s.", grant.Info.ExpiresAt.Local().Format(githubApprovalTimeFormat),
00091 | 	))
00092 | 	fields := githubAuditRequest(session.ID, request)
00093 | 	fields["grant_id"] = grantID
00094 | 	fields["expires_at"] = grant.Info.ExpiresAt
00095 | 	_ = a.audit("github.grant", "created", fields)
00096 | 	return githubauth.BrokerResponse{OK: true, Grants: []githubauth.GrantInfo{copyGitHubGrantInfo(grant.Info)}}
00097 | }
00098 |
```


## `internal/app/input.go`

### Lines 54-182

```text
00054 | }
00055 |
00056 | func (a *App) sendReplyInput(ctx context.Context, expected state.TerminalSession, chatID int64, messageID int, text string) actionResult {
00057 | 	sessionLock := a.sessionMutex(expected.ID)
00058 | 	sessionLock.Lock()
00059 | 	anchorLock := a.anchorMutex(expected.ID)
00060 | 	anchorLock.Lock()
00061 | 	current, targetState, found := a.Store.FindReplyTarget(chatID, messageID)
00062 | 	if !found || targetState != state.ReplyTargetCurrent || !sameTerminalBinding(current, expected) {
00063 | 		anchorLock.Unlock()
00064 | 		sessionLock.Unlock()
00065 | 		return actionResult{Outcome: actionUserError, Message: a.staleReply(expected)}
00066 | 	}
00067 | 	completion := a.sendInputExpectedLocked(ctx, expected.ID, text, "command", true, &expected)
00068 | 	anchorLock.Unlock()
00069 | 	sessionLock.Unlock()
00070 | 	return a.finishInput(ctx, expected.ID, completion)
00071 | }
00072 |
00073 | type inputCompletion struct {
00074 | 	result         actionResult
00075 | 	anchorNotice   string
00076 | 	noticeBinding  state.TerminalSession
00077 | 	identitySource state.TerminalSession
00078 | 	identityError  error
00079 | 	refresh        bool
00080 | }
00081 |
00082 | // sendInputExpectedLocked performs terminal and state work while the caller
00083 | // owns sessionMutex(id). It deliberately defers every anchor effect so callers
00084 | // may also hold anchorMutex(id) in the established session-then-anchor order.
00085 | func (a *App) sendInputExpectedLocked(ctx context.Context, id int, text, mode string, enter bool, expectedBinding *state.TerminalSession) inputCompletion {
00086 | 	ts, ok := a.Store.FindSession(id)
00087 | 	if !ok {
00088 | 		return inputCompletion{result: actionResult{Outcome: actionUserError, Message: "session not found"}}
00089 | 	}
00090 | 	if ts.State == state.TerminalClosed {
00091 | 		return inputCompletion{result: actionResult{Outcome: actionUserError, Message: "session is closed"}}
00092 | 	}
00093 | 	if ts.Collapsed {
00094 | 		return inputCompletion{result: actionResult{Outcome: actionUserError, Message: collapsedSessionActionMessage}}
00095 | 	}
00096 | 	if ts.PendingResume != nil {
00097 | 		return inputCompletion{result: actionResult{Outcome: actionUserError, Message: "resume recovery is still being reconciled; try again shortly"}}
00098 | 	}
00099 | 	if expectedBinding != nil && !sameTerminalBinding(ts, *expectedBinding) {
00100 | 		return inputCompletion{result: actionResult{Outcome: actionUserError, Message: "session changed before input could be sent"}}
00101 | 	}
00102 | 	tctx, cancel := tmux.TimeoutContext(ctx)
00103 | 	defer cancel()
00104 | 	tctx = tmux.InteractiveContext(tctx)
00105 | 	var pane tmux.Pane
00106 | 	var err error
00107 | 	if enter {
00108 | 		pane, err = a.terminalMechanics().SendCommand(tctx, terminalBinding(ts), text)
00109 | 	} else {
00110 | 		pane, err = a.terminalMechanics().SendText(tctx, terminalBinding(ts), text)
00111 | 	}
00112 | 	if err != nil {
00113 | 		stage := mechanics.FailureStage(err)
00114 | 		_ = a.audit("tmux.send", "failed", map[string]any{"session_id": id, "pane_id": ts.TmuxPaneID, "mode": mode, "enter": enter, "stage": stage, "error": err.Error()})
00115 | 		if tmux.IsIdentityLoss(err) {
00116 | 			return inputCompletion{
00117 | 				result:         actionResult{Outcome: actionTmuxFailed, Message: "session lost; use /sessions to attach the intended pane again"},
00118 | 				anchorNotice:   "tmux send error: " + err.Error(),
00119 | 				noticeBinding:  ts,
00120 | 				identitySource: ts,
00121 | 				identityError:  err,
00122 | 			}
00123 | 		}
00124 | 		return inputCompletion{
00125 | 			result:        actionResult{Outcome: actionTmuxFailed, Message: tmuxSendFailureMessage(stage, err)},
00126 | 			anchorNotice:  "tmux send error: " + err.Error(),
00127 | 			noticeBinding: ts,
00128 | 		}
00129 | 	}
00130 | 	if err := a.recordValidatedPane(ts, pane); err != nil {
00131 | 		return inputCompletion{result: actionResult{Outcome: actionStateFailed, Message: err.Error()}}
00132 | 	}
00133 | 	_ = a.audit("tmux.send", "ok", map[string]any{"session_id": id, "pane_id": ts.TmuxPaneID, "mode": mode, "enter": enter})
00134 | 	expected := ts
00135 | 	expected.State = state.TerminalRunning
00136 | 	_, found, applied, err := a.updateSessionIfCurrent(expected, func(s *state.TerminalSession) {
00137 | 		s.LastActivityAt = time.Now().UTC()
00138 | 		if enter && shellForeground(pane.CurrentCmd) {
00139 | 			preview := strings.TrimSpace(a.redactText(text))
00140 | 			if len(preview) > maxRecoveryCommandBytes {
00141 | 				preview = headUTF8(preview, maxRecoveryCommandBytes)
00142 | 			}
00143 | 			s.RecordRecoveryEvent(state.RecoveryEvent{
00144 | 				At: time.Now().UTC(), Kind: "command", Command: preview, CommandHash: sha(text),
00145 | 				CWD: pane.CurrentPath, ForegroundBefore: pane.CurrentCmd,
00146 | 				ExpectedProcess: commandExecutable(text), Validation: "sent_to_shell", Program: commandProgram(text),
00147 | 			})
00148 | 		}
00149 | 	})
00150 | 	if err != nil {
00151 | 		_ = a.audit("state.session", "failed", map[string]any{"session_id": id, "mode": mode, "error": err.Error()})
00152 | 		return inputCompletion{
00153 | 			result:        actionResult{Outcome: actionStateFailed, Message: "state update failed after tmux input: " + err.Error()},
00154 | 			anchorNotice:  "state update error after tmux input: " + err.Error(),
00155 | 			noticeBinding: ts,
00156 | 		}
00157 | 	}
00158 | 	if !found || !applied {
00159 | 		return inputCompletion{result: actionResult{Outcome: actionStateFailed, Message: "session no longer current after tmux input"}}
00160 | 	}
00161 | 	return inputCompletion{result: actionResult{Outcome: actionOK, Message: "sent"}, refresh: true}
00162 | }
00163 |
00164 | func (a *App) finishInput(ctx context.Context, id int, completion inputCompletion) actionResult {
00165 | 	if completion.identityError != nil {
00166 | 		a.recordIdentityLoss(ctx, completion.identitySource, completion.identityError)
00167 | 	}
00168 | 	if completion.anchorNotice != "" {
00169 | 		if completion.identityError == nil {
00170 | 			a.invalidatePresentationHashes(completion.noticeBinding)
00171 | 		}
00172 | 		a.updateAnchorLocalGuarded(ctx, id, completion.anchorNotice, true, func() bool {
00173 | 			current, ok := a.Store.FindSession(id)
00174 | 			return ok && sameTerminalBinding(current, completion.noticeBinding)
00175 | 		}, nil)
00176 | 	}
00177 | 	if completion.refresh {
00178 | 		a.refreshSoon(id)
00179 | 	}
00180 | 	return completion.result
00181 | }
00182 |
```


## `internal/app/refresh.go`

### Lines 236-302

```text
00236 |
00237 | func (a *App) conversationalSummary(ctx context.Context, session state.TerminalSession, capture tmux.StyledCapture, presentationText string, contexts ...sessionContextSnapshot) (string, []string, conversationTurn, error) {
00238 | 	historical := sessionContextSnapshot{}
00239 | 	if len(contexts) > 0 {
00240 | 		historical = contexts[0]
00241 | 	}
00242 | 	turn := a.prepareConversationTurn(session, capture, conversationEvidence(presentationText), historical)
00243 | 	turn.input.EvidenceRequested = a.snapshotAvailable()
00244 | 	if !acquireSlot(ctx, a.guideSlots) {
00245 | 		return "", nil, turn, ctx.Err()
00246 | 	}
00247 | 	defer releaseSlot(a.guideSlots)
00248 | 	a.presentationMu.RLock()
00249 | 	defer a.presentationMu.RUnlock()
00250 | 	identityLock := a.sessionMutex(session.ID)
00251 | 	identityLock.Lock()
00252 | 	defer identityLock.Unlock()
00253 | 	latest, ok := a.Store.FindSession(session.ID)
00254 | 	if a.snapshotAnchors() || !ok || latest.Collapsed || latest.State != state.TerminalRunning || !latest.WatchEnabled || !sameTerminalBinding(latest, session) || !a.conversationTurnCurrentContext(ctx, session, turn) {
00255 | 		return "", nil, turn, errConversationTurnSuperseded
00256 | 	}
00257 | 	var result guide.Result
00258 | 	var err error
00259 | 	if renderer, ok := a.Guide.(guide.EvidenceRenderer); ok && a.snapshotAvailable() {
00260 | 		result, err = renderer.ConverseWithEvidence(ctx, turn.input)
00261 | 	} else {
00262 | 		result.Text, err = a.Guide.Converse(ctx, turn.input)
00263 | 	}
00264 | 	if err != nil {
00265 | 		return "", nil, turn, err
00266 | 	}
00267 | 	result.Text = a.redactText(result.Text)
00268 | 	return result.Text, result.Evidence, turn, nil
00269 | }
00270 |
00271 | func (a *App) snapshotConversationalSummary(ctx context.Context, session state.TerminalSession, anchorMessageID int, presentationText string, contexts ...sessionContextSnapshot) (string, error) {
00272 | 	if !acquireSlot(ctx, a.guideSlots) {
00273 | 		return "", ctx.Err()
00274 | 	}
00275 | 	defer releaseSlot(a.guideSlots)
00276 | 	a.presentationMu.RLock()
00277 | 	defer a.presentationMu.RUnlock()
00278 | 	identityLock := a.sessionMutex(session.ID)
00279 | 	identityLock.Lock()
00280 | 	defer identityLock.Unlock()
00281 | 	latest, ok := a.Store.FindSession(session.ID)
00282 | 	if !a.snapshotAnchors() || !ok || latest.Collapsed || latest.State != state.TerminalRunning || !latest.WatchEnabled || !sameTerminalBinding(latest, session) || latest.AnchorMessageID != anchorMessageID || latest.AnchorFormat != "snapshot" || latest.RetiringAnchorMessageID != 0 {
00283 | 		return "", errConversationTurnSuperseded
00284 | 	}
00285 | 	historical := sessionContextSnapshot{}
00286 | 	if len(contexts) > 0 {
00287 | 		historical = contexts[0]
00288 | 	}
00289 | 	if !a.codexContextCurrent(ctx, session, historical) {
00290 | 		return "", errConversationTurnSuperseded
00291 | 	}
00292 | 	summary, err := a.Guide.Converse(ctx, guide.Input{SessionID: session.ID, VisibleText: conversationEvidence(presentationText), HistoricalContext: historical.prompt})
00293 | 	if err != nil {
00294 | 		return "", err
00295 | 	}
00296 | 	if !a.codexContextCurrent(ctx, session, historical) {
00297 | 		return "", errConversationTurnSuperseded
00298 | 	}
00299 | 	return a.redactText(summary), nil
00300 | }
00301 |
00302 | func (a *App) updateAnchorLocal(ctx context.Context, id int, summary string, final bool) bool {
```


## `internal/githubauth/client.go`

### Lines 187-218

```text
00187 | }
00188 |
00189 | func ValidateToken(token Token, requestedRepositories []string, requestedPermissions map[string]string, now time.Time) error {
00190 | 	if strings.TrimSpace(token.Value) == "" || !token.ExpiresAt.After(now) {
00191 | 		return fmt.Errorf("GitHub returned an invalid installation token")
00192 | 	}
00193 | 	effectiveRepositories := make([]string, 0, len(token.Repositories))
00194 | 	for _, repository := range token.Repositories {
00195 | 		effectiveRepositories = append(effectiveRepositories, repository.FullName)
00196 | 	}
00197 | 	if !sameStringSet(effectiveRepositories, requestedRepositories) {
00198 | 		return fmt.Errorf("GitHub token repository scope did not match the request")
00199 | 	}
00200 | 	for name, level := range requestedPermissions {
00201 | 		if token.Permissions[name] != level {
00202 | 			return fmt.Errorf("GitHub token permission scope did not match the request")
00203 | 		}
00204 | 	}
00205 | 	for name, level := range token.Permissions {
00206 | 		if requestedLevel, requested := requestedPermissions[name]; requested {
00207 | 			if level != requestedLevel {
00208 | 				return fmt.Errorf("GitHub token permission scope did not match the request")
00209 | 			}
00210 | 			continue
00211 | 		}
00212 | 		if name != "metadata" || level != "read" {
00213 | 			return fmt.Errorf("GitHub token contained an unrequested permission")
00214 | 		}
00215 | 	}
00216 | 	return nil
00217 | }
00218 |
```


## `internal/githubauth/types.go`

### Lines 26-70

```text
00026 | )
00027 |
00028 | type Binding struct {
00029 | 	ServerID string `json:"server_id"`
00030 | 	WindowID string `json:"window_id"`
00031 | 	PaneID   string `json:"pane_id"`
00032 | }
00033 |
00034 | type BrokerRequest struct {
00035 | 	Version        int               `json:"version"`
00036 | 	Action         string            `json:"action"`
00037 | 	App            string            `json:"app,omitempty"`
00038 | 	InstallationID int64             `json:"installation_id,omitempty"`
00039 | 	Repositories   []string          `json:"repositories,omitempty"`
00040 | 	Permissions    map[string]string `json:"permissions,omitempty"`
00041 | 	Command        []string          `json:"command,omitempty"`
00042 | 	Binding        Binding           `json:"binding"`
00043 | 	Passphrase     []byte            `json:"passphrase,omitempty"`
00044 | 	LocalUnlock    bool              `json:"local_unlock,omitempty"`
00045 | 	GrantFor       time.Duration     `json:"grant_for,omitempty"`
00046 | 	Purpose        string            `json:"purpose,omitempty"`
00047 | }
00048 |
00049 | type LeaseInfo struct {
00050 | 	App            string            `json:"app"`
00051 | 	InstallationID int64             `json:"installation_id"`
00052 | 	Repositories   []string          `json:"repositories"`
00053 | 	Permissions    map[string]string `json:"permissions"`
00054 | 	ExpiresAt      time.Time         `json:"expires_at"`
00055 | 	GrantID        string            `json:"grant_id,omitempty"`
00056 | 	Generation     uint64            `json:"generation,omitempty"`
00057 | }
00058 |
00059 | type GrantInfo struct {
00060 | 	ID             string            `json:"id"`
00061 | 	App            string            `json:"app"`
00062 | 	InstallationID int64             `json:"installation_id"`
00063 | 	Repositories   []string          `json:"repositories"`
00064 | 	Permissions    map[string]string `json:"permissions"`
00065 | 	Purpose        string            `json:"purpose"`
00066 | 	CreatedAt      time.Time         `json:"created_at"`
00067 | 	ExpiresAt      time.Time         `json:"expires_at"`
00068 | }
00069 |
00070 | type BrokerResponse struct {
```

### Lines 90-173

```text
00090 | }
00091 |
00092 | func (r BrokerRequest) Validate() error {
00093 | 	if r.Version != ProtocolVersion {
00094 | 		return fmt.Errorf("unsupported GitHub broker protocol version")
00095 | 	}
00096 | 	if r.Binding.ServerID == "" || r.Binding.WindowID == "" || r.Binding.PaneID == "" {
00097 | 		return fmt.Errorf("missing tmux terminal binding")
00098 | 	}
00099 | 	switch r.Action {
00100 | 	case ActionStatus, ActionRevoke:
00101 | 		return nil
00102 | 	case ActionExec, ActionGrant:
00103 | 	default:
00104 | 		return fmt.Errorf("unknown GitHub broker action")
00105 | 	}
00106 | 	if err := validateAlias(r.App); err != nil {
00107 | 		return err
00108 | 	}
00109 | 	if r.InstallationID < 0 {
00110 | 		return fmt.Errorf("GitHub App installation ID must be positive")
00111 | 	}
00112 | 	if len(r.Repositories) == 0 {
00113 | 		return fmt.Errorf("at least one explicit repository is required")
00114 | 	}
00115 | 	if len(r.Repositories) > 100 {
00116 | 		return fmt.Errorf("at most 100 repositories may be requested")
00117 | 	}
00118 | 	for _, repository := range r.Repositories {
00119 | 		if err := validateRepository(repository); err != nil {
00120 | 			return err
00121 | 		}
00122 | 	}
00123 | 	if len(r.Permissions) == 0 {
00124 | 		return fmt.Errorf("at least one explicit permission is required")
00125 | 	}
00126 | 	if len(r.Permissions) > 100 {
00127 | 		return fmt.Errorf("at most 100 permissions may be requested")
00128 | 	}
00129 | 	for name, level := range r.Permissions {
00130 | 		if err := validatePermission(name, level); err != nil {
00131 | 			return err
00132 | 		}
00133 | 	}
00134 | 	if r.Action == ActionGrant {
00135 | 		if r.GrantFor < MinGrantDuration || r.GrantFor > AbsoluteMaxGrantDuration {
00136 | 			return fmt.Errorf("renewable grant duration must be between %s and %s", MinGrantDuration, AbsoluteMaxGrantDuration)
00137 | 		}
00138 | 		if len(r.Purpose) == 0 || len(r.Purpose) > 200 || strings.TrimSpace(r.Purpose) == "" {
00139 | 			return fmt.Errorf("renewable grant purpose must be between 1 and 200 bytes")
00140 | 		}
00141 | 		for _, character := range r.Purpose {
00142 | 			if unicode.Is(unicode.Cc, character) || unicode.Is(unicode.Cf, character) ||
00143 | 				unicode.Is(unicode.Zl, character) || unicode.Is(unicode.Zp, character) {
00144 | 				return fmt.Errorf("renewable grant purpose contains an unsafe Unicode control")
00145 | 			}
00146 | 		}
00147 | 		if err := ValidateRenewablePermissions(r.Permissions); err != nil {
00148 | 			return err
00149 | 		}
00150 | 		if len(r.Command) != 0 {
00151 | 			return fmt.Errorf("renewable grant requests cannot include a child command")
00152 | 		}
00153 | 		return nil
00154 | 	}
00155 | 	if len(r.Command) == 0 || strings.TrimSpace(r.Command[0]) == "" {
00156 | 		return fmt.Errorf("a child command is required")
00157 | 	}
00158 | 	if len(r.Command) > 256 {
00159 | 		return fmt.Errorf("child command has too many arguments")
00160 | 	}
00161 | 	total := 0
00162 | 	for _, argument := range r.Command {
00163 | 		if strings.IndexByte(argument, 0) >= 0 {
00164 | 			return fmt.Errorf("child command contains a NUL byte")
00165 | 		}
00166 | 		total += len(argument)
00167 | 	}
00168 | 	if total > 32*1024 {
00169 | 		return fmt.Errorf("child command exceeds 32768 bytes")
00170 | 	}
00171 | 	return nil
00172 | }
00173 |
```


## `internal/state/state.go`

### Lines 34-59

```text
00034 | 	TerminalOriginAttached TerminalOrigin = "attached"
00035 | )
00036 |
00037 | type State struct {
00038 | 	Version                     int                `json:"version"`
00039 | 	AnchorMode                  string             `json:"anchor_mode,omitempty"`
00040 | 	CollapsedShelf              *CollapsedShelf    `json:"collapsed_shelf,omitempty"`
00041 | 	PendingMessageCleanups      []MessageCleanup   `json:"pending_message_cleanups,omitempty"`
00042 | 	NextSessionID               int                `json:"next_session_id"`
00043 | 	LastUpdateID                int                `json:"last_update_id"`
00044 | 	LastPollAt                  time.Time          `json:"last_poll_at,omitempty"`
00045 | 	LastHaikuAt                 time.Time          `json:"last_haiku_at,omitempty"`
00046 | 	LastHaikuError              string             `json:"last_haiku_error,omitempty"`
00047 | 	TerminalSessions            []TerminalSession  `json:"terminal_sessions"`
00048 | 	Attachments                 []Attachment       `json:"attachments"`
00049 | 	AttachmentBypasses          []AttachmentBypass `json:"attachment_bypasses,omitempty"`
00050 | 	UpdateJournal               []UpdateEvent      `json:"update_journal,omitempty"`
00051 | 	ProcessedMessages           map[string]bool    `json:"processed_messages,omitempty"`
00052 | 	HostBootID                  string             `json:"host_boot_id,omitempty"`
00053 | 	PendingRecoveryBootID       string             `json:"pending_recovery_boot_id,omitempty"`
00054 | 	LastRecoveryPlanHash        string             `json:"last_recovery_plan_hash,omitempty"`
00055 | 	RecoveryPlanMessageIDs      []int              `json:"recovery_plan_message_ids,omitempty"`
00056 | 	PendingRecoveryPlanHash     string             `json:"pending_recovery_plan_hash,omitempty"`
00057 | 	PendingRecoveryPlanNextPage int                `json:"pending_recovery_plan_next_page,omitempty"`
00058 | }
00059 |
```

### Lines 108-165

```text
00108 | 	RetryAt   time.Time `json:"retry_at,omitempty"`
00109 | }
00110 |
00111 | type TerminalSession struct {
00112 | 	ID                         int                       `json:"id"`
00113 | 	TmuxSessionName            string                    `json:"tmux_session_name"`
00114 | 	TmuxWindowID               string                    `json:"tmux_window_id"`
00115 | 	TmuxPaneID                 string                    `json:"tmux_pane_id"`
00116 | 	TmuxServerID               string                    `json:"tmux_server_id,omitempty"`
00117 | 	Origin                     TerminalOrigin            `json:"origin,omitempty"`
00118 | 	Title                      string                    `json:"title"`
00119 | 	LastKnownCWD               string                    `json:"last_known_cwd,omitempty"`
00120 | 	State                      TerminalState             `json:"state"`
00121 | 	CreatedAt                  time.Time                 `json:"created_at"`
00122 | 	UpdatedAt                  time.Time                 `json:"updated_at"`
00123 | 	LastActivityAt             time.Time                 `json:"last_activity_at"`
00124 | 	LastRawCaptureHash         string                    `json:"last_raw_capture_hash,omitempty"`
00125 | 	LastSnapshotCaptureHash    string                    `json:"last_snapshot_capture_hash,omitempty"`
00126 | 	LastSnapshotAttemptAt      time.Time                 `json:"last_snapshot_attempt_at,omitempty"`
00127 | 	LastRenderHash             string                    `json:"last_render_hash,omitempty"`
00128 | 	LastSummary                string                    `json:"last_summary,omitempty"`
00129 | 	PresentationProgram        string                    `json:"presentation_program,omitempty"`
00130 | 	PresentationVersion        string                    `json:"presentation_version,omitempty"`
00131 | 	PresentationRuntimeID      string                    `json:"presentation_runtime_id,omitempty"`
00132 | 	PresentationModel          string                    `json:"presentation_model,omitempty"`
00133 | 	PresentationEffort         string                    `json:"presentation_effort,omitempty"`
00134 | 	PresentationMode           string                    `json:"presentation_mode,omitempty"`
00135 | 	PresentationActivity       string                    `json:"presentation_activity,omitempty"`
00136 | 	PresentationNotice         string                    `json:"presentation_notice,omitempty"`
00137 | 	AgentCompatibility         agentcompat.Compatibility `json:"agent_compatibility,omitempty"`
00138 | 	AgentPresentation          agentcompat.Presentation  `json:"agent_presentation,omitempty"`
00139 | 	SemanticViewport           agentcompat.Viewport      `json:"semantic_viewport,omitempty"`
00140 | 	DeclaredModel              agentcompat.Value         `json:"declared_model,omitempty"`
00141 | 	DeclaredModelObservedAt    time.Time                 `json:"declared_model_observed_at,omitempty"`
00142 | 	AgentDetailChatID          int64                     `json:"agent_detail_chat_id,omitempty"`
00143 | 	AgentDetailMessageID       int                       `json:"agent_detail_message_id,omitempty"`
00144 | 	AgentDetailAnchorMessageID int                       `json:"agent_detail_anchor_message_id,omitempty"`
00145 | 	AgentDetailRenderHash      string                    `json:"agent_detail_render_hash,omitempty"`
00146 | 	SummaryMessageID           int                       `json:"summary_message_id,omitempty"`
00147 | 	SnapshotMessageID          int                       `json:"snapshot_message_id,omitempty"`
00148 | 	UpstreamMessageID          int                       `json:"upstream_message_id,omitempty"`
00149 | 	SeenUpstreamSignalIDs      []string                  `json:"seen_upstream_signal_ids,omitempty"`
00150 | 	LastUpstreamSignalAt       time.Time                 `json:"last_upstream_signal_at,omitempty"`
00151 | 	UpstreamRetryAt            time.Time                 `json:"upstream_retry_at,omitempty"`
00152 | 	StaleAlternateMessageIDs   []int                     `json:"stale_alternate_message_ids,omitempty"`
00153 | 	AnchorChatID               int64                     `json:"anchor_chat_id,omitempty"`
00154 | 	AnchorMessageID            int                       `json:"anchor_message_id,omitempty"`
00155 | 	AnchorFormat               string                    `json:"anchor_format,omitempty"`
00156 | 	RetiringAnchorMessageID    int                       `json:"retiring_anchor_message_id,omitempty"`
00157 | 	RetiringAnchorFormat       string                    `json:"retiring_anchor_format,omitempty"`
00158 | 	RetiringAnchorRetryAt      time.Time                 `json:"retiring_anchor_retry_at,omitempty"`
00159 | 	AnchorPinned               bool                      `json:"anchor_pinned,omitempty"`
00160 | 	AnchorPinKnown             bool                      `json:"anchor_pin_known,omitempty"`
00161 | 	WatchEnabled               bool                      `json:"watch_enabled"`
00162 | 	Collapsed                  bool                      `json:"collapsed,omitempty"`
00163 | 	PendingCollapse            bool                      `json:"pending_collapse,omitempty"`
00164 | 	PendingRestore             *PendingRestore           `json:"pending_restore,omitempty"`
00165 | 	ResumeProgram              string                    `json:"resume_program,omitempty"`
```

### Lines 368-398

```text
00368 | 	if s.state.ProcessedMessages == nil {
00369 | 		s.state.ProcessedMessages = map[string]bool{}
00370 | 	}
00371 | 	s.initializeProcessedMessageOrderLocked()
00372 | 	s.pruneStateLocked(time.Now().UTC())
00373 | 	return s, nil
00374 | }
00375 |
00376 | func newState() State {
00377 | 	return State{Version: currentStateVersion, NextSessionID: 1, ProcessedMessages: map[string]bool{}}
00378 | }
00379 |
00380 | func (s *Store) Snapshot() State {
00381 | 	s.mu.Lock()
00382 | 	defer s.mu.Unlock()
00383 | 	return cloneState(s.state)
00384 | }
00385 |
00386 | func (s *Store) Save() error {
00387 | 	s.mu.Lock()
00388 | 	defer s.mu.Unlock()
00389 | 	return s.saveLocked()
00390 | }
00391 |
00392 | func (s *Store) SetAnchorMode(mode string) error {
00393 | 	if mode != "guide" && mode != "snapshot" {
00394 | 		return fmt.Errorf("invalid anchor mode %q", mode)
00395 | 	}
00396 | 	s.mu.Lock()
00397 | 	defer s.mu.Unlock()
00398 | 	previous := s.state.AnchorMode
```


## `internal/tmux/tmux.go`

### Lines 90-124

```text
00090 | }
00091 |
00092 | // Pane identifies a live pane by tmux's immutable server-lifetime IDs.
00093 | type Pane struct {
00094 | 	SessionID   string
00095 | 	WindowID    string
00096 | 	ID          string
00097 | 	SessionName string
00098 | 	WindowIndex string
00099 | 	Index       string
00100 | 	Active      bool
00101 | 	CurrentPath string
00102 | 	CurrentCmd  string
00103 | }
00104 |
00105 | // PaneProcess returns only the shell/process anchor needed by an explicit
00106 | // in-pane migration binder. The published result remains a candidate until the
00107 | // Engram service validates the immutable watched binding.
00108 | func (m Manager) PaneProcess(ctx context.Context, paneID string) (int, string, error) {
00109 | 	if !validImmutableID(paneID, '%') {
00110 | 		return 0, "", fmt.Errorf("invalid tmux pane id")
00111 | 	}
00112 | 	out, err := m.Runner.Run(ctx, "display-message", "-p", "-t", paneID, "#{pane_pid}\x1f#{pane_current_command}")
00113 | 	if err != nil {
00114 | 		return 0, "", err
00115 | 	}
00116 | 	parts := strings.Split(strings.TrimSuffix(out, "\n"), "\x1f")
00117 | 	if len(parts) != 2 {
00118 | 		return 0, "", fmt.Errorf("unexpected tmux pane process metadata")
00119 | 	}
00120 | 	pid, err := strconv.Atoi(parts[0])
00121 | 	if err != nil || pid <= 0 {
00122 | 		return 0, "", fmt.Errorf("invalid tmux pane process id")
00123 | 	}
00124 | 	return pid, strings.TrimSpace(parts[1]), nil
```

### Lines 507-563

```text
00507 |
00508 | func (m Manager) SendKeys(ctx context.Context, paneID string, keys []string) error {
00509 | 	args := append([]string{"send-keys", "-t", paneID}, keys...)
00510 | 	_, err := m.Runner.Run(ctx, args...)
00511 | 	return err
00512 | }
00513 |
00514 | // SendCommandIfBindingMatches keeps each input effect behind a tmux-side
00515 | // identity condition. A restart between the literal text and Enter can leave
00516 | // text unsubmitted, but it cannot redirect either effect into a new server.
00517 | func (m Manager) SendCommandIfBindingMatches(ctx context.Context, paneID, windowID, serverID, text string) error {
00518 | 	if err := m.SendTextIfBindingMatches(ctx, paneID, windowID, serverID, text); err != nil {
00519 | 		return err
00520 | 	}
00521 | 	if commandSubmitDelay > 0 {
00522 | 		timer := time.NewTimer(commandSubmitDelay)
00523 | 		select {
00524 | 		case <-ctx.Done():
00525 | 			timer.Stop()
00526 | 			return ctx.Err()
00527 | 		case <-timer.C:
00528 | 		}
00529 | 	}
00530 | 	return m.SendKeysIfBindingMatches(ctx, paneID, windowID, serverID, []string{"Enter"})
00531 | }
00532 |
00533 | func (m Manager) SendTextIfBindingMatches(ctx context.Context, paneID, windowID, serverID, text string) error {
00534 | 	if err := validateBindingIDs(paneID, windowID, serverID); err != nil {
00535 | 		return err
00536 | 	}
00537 | 	nonce, err := captureNonce()
00538 | 	if err != nil {
00539 | 		return err
00540 | 	}
00541 | 	buffer := "engram-input-" + nonce
00542 | 	if _, err := m.Runner.Run(ctx, "set-buffer", "-b", buffer, "--", text); err != nil {
00543 | 		return err
00544 | 	}
00545 | 	command := "paste-buffer -p -r -d -b " + buffer + " -t " + paneID
00546 | 	if err := m.runIfBindingMatches(ctx, paneID, windowID, serverID, command); err != nil {
00547 | 		cleanupCtx, cancel := context.WithTimeout(context.WithoutCancel(ctx), 2*time.Second)
00548 | 		_, _ = m.Runner.Run(cleanupCtx, "delete-buffer", "-b", buffer)
00549 | 		cancel()
00550 | 		return err
00551 | 	}
00552 | 	return nil
00553 | }
00554 |
00555 | func (m Manager) SendKeysIfBindingMatches(ctx context.Context, paneID, windowID, serverID string, keys []string) error {
00556 | 	if err := validateBindingIDs(paneID, windowID, serverID); err != nil {
00557 | 		return err
00558 | 	}
00559 | 	if err := ValidKeys(keys); err != nil {
00560 | 		return err
00561 | 	}
00562 | 	parts := []string{"send-keys", "-t", paneID}
00563 | 	for _, key := range keys {
```

### Lines 677-776

```text
00677 | 	}
00678 | 	start, end := captureBounds(visibleRows, targetRows)
00679 | 	command := strings.Join([]string{"capture-pane", "-p", "-N", "-S", strconv.Itoa(start), "-E", strconv.Itoa(end), "-t", paneID}, " ")
00680 | 	out, err := m.captureIfBindingMatches(ctx, paneID, windowID, serverID, command)
00681 | 	if err != nil {
00682 | 		return "", err
00683 | 	}
00684 | 	return semanticCapture(out), nil
00685 | }
00686 |
00687 | func (m Manager) captureIfBindingMatches(ctx context.Context, paneID, windowID, serverID, command string) (string, error) {
00688 | 	if err := validateBindingIDs(paneID, windowID, serverID); err != nil {
00689 | 		return "", err
00690 | 	}
00691 | 	nonce, err := captureNonce()
00692 | 	if err != nil {
00693 | 		return "", err
00694 | 	}
00695 | 	marker := identityMismatchMarker + "-" + nonce
00696 | 	out, err := m.Runner.Run(ctx, "if-shell", "-F", "-t", paneID, bindingCondition(windowID, serverID), command, "display-message -p "+marker)
00697 | 	if err != nil {
00698 | 		if missingTmuxTarget(err) {
00699 | 			return "", &IdentityError{Reason: "tmux pane identity is gone", Err: err}
00700 | 		}
00701 | 		return "", err
00702 | 	}
00703 | 	if strings.TrimSpace(out) == marker {
00704 | 		return "", &IdentityError{Reason: "tmux binding changed while capturing"}
00705 | 	}
00706 | 	return out, nil
00707 | }
00708 |
00709 | func (m Manager) CaptureStyled(ctx context.Context, paneID string, targetRows int) (StyledCapture, error) {
00710 | 	if targetRows <= 0 || targetRows > 400 {
00711 | 		return StyledCapture{}, fmt.Errorf("target rows must be between 1 and 400")
00712 | 	}
00713 | 	metaFormat := recordFormat(serverIDOption, "window_id", "pane_id", "pane_pid", "pane_width", "pane_height", "pane_title", "pane_current_path", "pane_current_command", "alternate_on", "pane_in_mode")
00714 | 	meta, err := m.Runner.Run(ctx, "display-message", "-p", "-t", paneID, metaFormat)
00715 | 	if err != nil {
00716 | 		return StyledCapture{}, err
00717 | 	}
00718 | 	before, err := parseCaptureMetadata(meta)
00719 | 	if err != nil {
00720 | 		return StyledCapture{}, err
00721 | 	}
00722 | 	columns, visibleRows := before.Columns, before.VisibleRows
00723 | 	start, end := captureBounds(visibleRows, targetRows)
00724 | 	nonce, err := captureNonce()
00725 | 	if err != nil {
00726 | 		return StyledCapture{}, err
00727 | 	}
00728 | 	physicalBuffer := "engram-physical-" + nonce
00729 | 	joinedBuffer := "engram-joined-" + nonce
00730 | 	afterText, err := m.Runner.Run(ctx,
00731 | 		"capture-pane", "-e", "-N", "-S", strconv.Itoa(start), "-E", strconv.Itoa(end), "-t", paneID, "-b", physicalBuffer,
00732 | 		";", "capture-pane", "-J", "-S", strconv.Itoa(start), "-E", strconv.Itoa(end), "-t", paneID, "-b", joinedBuffer,
00733 | 		";", "display-message", "-p", "-t", paneID, metaFormat,
00734 | 	)
00735 | 	if err != nil {
00736 | 		m.cleanupCaptureBuffers(ctx, physicalBuffer, joinedBuffer)
00737 | 		return StyledCapture{}, err
00738 | 	}
00739 | 	defer m.cleanupCaptureBuffers(ctx, physicalBuffer, joinedBuffer)
00740 | 	after, err := parseCaptureMetadata(afterText)
00741 | 	if err != nil {
00742 | 		return StyledCapture{}, err
00743 | 	}
00744 | 	if !sameCaptureIdentity(before, after) {
00745 | 		return StyledCapture{}, &IdentityError{Reason: "tmux pane identity changed while capturing"}
00746 | 	}
00747 | 	if !sameCaptureBoundary(before, after) {
00748 | 		return StyledCapture{}, fmt.Errorf("tmux pane changed while capturing")
00749 | 	}
00750 | 	ansi, err := m.Runner.Run(ctx, "show-buffer", "-b", physicalBuffer)
00751 | 	if err != nil {
00752 | 		return StyledCapture{}, err
00753 | 	}
00754 | 	joined, err := m.Runner.Run(ctx, "show-buffer", "-b", joinedBuffer)
00755 | 	if err != nil {
00756 | 		return StyledCapture{}, err
00757 | 	}
00758 | 	bufferRows := strings.Count(ansi, "\n")
00759 | 	if ansi != "" && !strings.HasSuffix(ansi, "\n") {
00760 | 		bufferRows++
00761 | 	}
00762 | 	if bufferRows == 0 {
00763 | 		bufferRows = 1
00764 | 	}
00765 | 	return StyledCapture{
00766 | 		ANSI:        ansi,
00767 | 		Text:        physicalSemanticCapture(ansi),
00768 | 		JoinedText:  semanticCapture(joined),
00769 | 		Hyperlinks:  extractOSC8Hyperlinks(ansi, 16),
00770 | 		ServerID:    after.ServerID,
00771 | 		WindowID:    after.WindowID,
00772 | 		PaneID:      after.PaneID,
00773 | 		PanePID:     after.PanePID,
00774 | 		CurrentCmd:  after.CurrentCmd,
00775 | 		AlternateOn: after.AlternateOn,
00776 | 		PaneInMode:  after.PaneInMode,
```


## `requirements/INDEX.md`

### Lines 1-27

```text
00001 | # Engram Requirements Index
00002 |
00003 | Status: draft but binding for implementation.
00004 |
00005 | Engram keeps requirements small and executable. Each document states runtime
00006 | contracts that should either be tested directly or checked by `make check`.
00007 | The requirements documents are the binding source of truth.
00008 |
00009 | ## Foundation
00010 |
00011 | 1. [`telegram.md`](telegram.md) - Telegram command, callback, formatting, and delivery contracts.
00012 | 2. [`tmux.md`](tmux.md) - tmux target selection, attachment, input, capture, and close behavior.
00013 | 3. [`reliability.md`](reliability.md) - failure handling, audit evidence, retry/degradation rules.
00014 | 4. [`security.md`](security.md) - single-user admission, secrets, filesystem, and tmux risk boundaries.
00015 | 5. [`operations.md`](operations.md) - systemd/LaunchAgent lifecycle, logs, state, and diagnostics.
00016 | 6. [`upstream-signals.md`](upstream-signals.md) - terminal-native attention signals from nested environments.
00017 |
00018 | ## Executable Checks
00019 |
00020 | - `make test` runs unit and contract tests.
00021 | - `make architecture` checks package boundaries and required requirement files.
00022 | - `make public-readiness` checks public-facing repository hygiene.
00023 | - `make secrets` scans tracked files for likely live secrets.
00024 | - `make check` runs the full local quality gate.
00025 | - The manually dispatched hermetic golden path is documented in
00026 |   [`docs/e2e-testing.md`](../docs/e2e-testing.md); it is intentionally separate
00027 |   from the default local gate.
```


## `requirements/security.md`

### Lines 5-38

```text
00005 | privacy model must stay small and explicit.
00006 |
00007 | ## Identity
00008 |
00009 | - Exactly one Telegram user is authorized.
00010 | - Exactly one Telegram chat is authorized.
00011 | - DM-only operation is supported; group operation is out of scope.
00012 | - Unauthorized messages and callbacks must not mutate tmux, sessions,
00013 |   attachments, or processed-message state. Poll offsets and a generic bounded
00014 |   rejection record may advance so rejected updates are not replayed.
00015 |
00016 | ## Secrets
00017 |
00018 | - `.env` files must not be tracked.
00019 | - Runtime env files must be regular files with no group or other permissions.
00020 | - Bot tokens and model-provider keys must not appear in tracked files, diagnostics,
00021 |   issues, or test fixtures.
00022 | - Audit payloads and `/logs` output must redact configured credentials and
00023 |   common credential patterns.
00024 | - Model-derived conversational prose must pass through the same best-effort
00025 |   redaction before persistence and Telegram delivery.
00026 | - Documentation must state that redaction is best effort and does not make an
00027 |   artifact safe to share without review.
00028 | - Enrolled GitHub App PEMs must be authenticated-encrypted at rest under a
00029 |   passphrase-derived key. The passphrase, decrypted PEM, app JWT, and
00030 |   installation token must never be persisted, audited, or emitted by Engram on
00031 |   stdout or stderr.
00032 | - GitHub installation-token requests must contain at least one explicit
00033 |   repository and permission. They must not inherit GitHub's all-repositories
00034 |   or all-installation-permissions defaults.
00035 | - GitHub installation-token responses must be checked against the requested
00036 |   repository and permission scope before a token reaches a child process.
00037 |
00038 | ## External Data Flow
```

### Lines 100-125

```text
00100 |   kernel process-start identity before and after a bounded read and at final
00101 |   publication. The hook observation must not predate the process. The UUID must
00102 |   match the filename and bounded record `sessionId` values. The transcript must
00103 |   be an owned regular non-symlink file. Recency, cwd, title, and model discovery
00104 |   are forbidden fallbacks.
00105 | - Claude's documented `SessionStart.model` may populate only bounded structured
00106 |   presentation with explicit hook provenance. It is not process or transcript
00107 |   identity and is cleared at every lifecycle or process-incarnation boundary.
00108 |   Codex hook model fields are not accepted without an official contract.
00109 | - Agent compatibility diagnostics and fixture inventories never print or store
00110 |   terminal messages, transcript values, working directories, executable or
00111 |   transcript paths, UUIDs, task text, or agent names. Fixture capture uses an
00112 |   allow-list transform before writing and requires human review before check-in.
00113 | - `engram claude-bind` is an optional migration path for sessions that predate
00114 |   the official hook. It accepts no arguments, uses inherited `TMUX_PANE`, and
00115 |   may publish a candidate only after proving one live Claude process, a bounded
00116 |   owned PID registry with matching PID/version/UUID, and exactly one UUID-named
00117 |   transcript. Because the registry is undocumented, any changed or ambiguous
00118 |   shape must fail closed and direct the user to restart with the hook.
00119 | - The named Claude transcript parser may admit only bounded non-meta,
00120 |   non-sidechain human string prompts and main-session assistant `text` blocks.
00121 |   Thinking, tool use and results, array-form user records, attachments, system
00122 |   metadata, sidechains, subagent transcripts, and unknown recognized content
00123 |   variants must be excluded. Split records require stable message identity.
00124 |   Large files use a bounded identity prefix and a fixed tail ending at the
00125 |   opened size. Complete messages are redacted before truncation; transcript
```


## `requirements/tmux.md`

### Lines 27-46

```text
00027 |   attach buttons for untracked panes and explicit reattach buttons when a
00028 |   persisted watch belongs to an older tmux server incarnation.
00029 | - Attach callbacks carry `%pane_id`, not mutable indexes.
00030 | - Each watch stores a random tmux server incarnation in addition to immutable
00031 |   pane/window IDs. Before input, capture, or cwd lookup, Engram verifies all
00032 |   three identities. Server incarnation and pane metadata are sampled in one
00033 |   tmux call; attach also brackets target resolution with server-incarnation
00034 |   reads so a restart cannot combine identities from two servers. Destructive
00035 |   close evaluates and kills in one tmux command queue so a concurrent pane move
00036 |   cannot redirect it. A mismatch marks the session lost; transient command
00037 |   failure does not.
00038 | - Pane-bound input, capture, scrollback, and destructive close cross the private
00039 |   terminal-mechanics boundary, which has no Telegram, state, or presentation
00040 |   dependency and validates immutable identity immediately before the operation.
00041 | - A lost anchor can recover automatically only when its exact server, pane, and
00042 |   window identity returns. `/attach` is the explicit authority to rebind an old
00043 |   watch to the selected pane after a tmux restart; it adopts the pane as an
00044 |   attached window and never inherits destructive close authority.
00045 |
00046 | ## Input
```
