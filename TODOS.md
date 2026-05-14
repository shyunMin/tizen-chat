# TODOs

Deferred work surfaced during the carbon v1→v2 migration eng review
(branch `tizen_aios`, 2026-05-12).

---

## 1. EventService.Subscribe `resume_from` cursor for event recovery

**What.** When the Subscribe server-streaming RPC drops mid-session, currently
we fall through to a full session reconnect (`CreateSession` + new Subscribe)
with `resume_from=""` (live tail). Carbon v2 supports `resume_from=<last_event_id>`
to replay everything the daemon emitted while we were disconnected.

**Why.** Without the cursor, any `MessageDelta` / `ToolResult` / `TurnCompleted`
that fired during the reconnect window is silently lost. The user sees text
truncated mid-paragraph or an "unfinished" turn that the daemon has actually
already completed.

**Pros.** Eliminates the only data-loss path in the chat-ui ↔ carbon contract.
v2 already wires the cursor — daemon stores events in JSONL with monotonic IDs.
Client cost: track `_lastEventId` on each Event, pass it on resubscribe.

**Cons.** Adds another piece of state to the client state machine
(`_lastEventId`). Subtle bug surface around what "last" means across full
session reconnect (where the session_id may change) vs. Subscribe-only reconnect.

**Context.** Deferred from migration review D2 (Subscribe stream loss handling).
The migration chose v1-equivalent behavior (fatal full reconnect) to keep
scope tight. This TODO is the upgrade path once the v2 migration is stable.

**Depends on.** Migration PR landed.

---

## 2. CarbonEvent handler extraction (chat_screen ↔ tizen_chat_home_screen DRY)

**What.** `chat_screen.dart` and `tizen_chat_home_screen.dart` carry near-identical
`switch (event)` blocks dispatching `CarbonTextDelta` / `ToolUseStart` /
`ToolResult` / `TurnComplete` / `Error` / `SessionEnded` / `ToolApprovalRequest`.
Same logic, two physical copies.

**Why.** Any future contract change to `CarbonEvent` (new fields, new variants,
new error policy) requires editing two files in lock-step. The migration PR
already touches both for the `approval_id` change — a maintenance smell that's
guaranteed to bite again.

**Pros.** Single source of truth for agent → UI translation. Lets us add
test coverage in one place. Reduces drift risk dramatically.

**Cons.** Requires understanding why the two screens exist separately
(`chat_screen.dart` looks like a generic Flutter chat; `tizen_chat_home_screen.dart`
is Tizen-specific with home-screen integration, window focus service, etc.).
Naive extraction may collide with each screen's `ChatMessage` state machine
and `_addMessage` patterns.

**Context.** Deferred from migration review D5. The migration principle was
"v1 동작 보존" — refactoring the layout was an explicit out-of-scope expansion.
Best done as its own PR after migration stabilizes.

**Depends on.** Migration PR landed and battle-tested. Reading both screens
to map the actual differences (not just the obvious duplication).

---

## 3. CarbonGrpcService unit-test coverage beyond regression-critical paths

**What.** The migration PR adds 4 regression-critical unit tests:
1. `approveToolCall` uses `approval_id` (not `tool_call_id`)
2. `interruptTurn` uses tracked `_currentTurnId`
3. `DROPPED` `SubmitResponse` disposition → `CarbonError` emitted
4. `client_request_id` correlation filters events correctly

12 GAPs from the coverage diagram remain uncovered:
- Event mapping for every v2 oneof variant (MessageDelta → CarbonTextDelta, etc.)
- `connect()` paths (CreateSession success/failure, Subscribe ready gating)
- `TurnStarted` → `_currentTurnId` update
- `SessionEnded` → reconnect dispatch
- Stream-error → reconnect dispatch
- Cleanup triggers on Error / Interrupt / SessionEnded / disconnect

**Why.** chat-ui currently has zero meaningful test coverage. The 4 regression
tests guard the highest-impact paths but the rest of the new code is held
together by "it compiles." Future refactoring (e.g. TODO #2) loses its safety
net.

**Pros.** Each gap, taken individually, is cheap (inject a v2 Event message,
assert resulting `CarbonEvent` shape). Cumulative confidence is high.

**Cons.** Building out the test fixtures incrementally, agreeing on
naming/structure, paying the upfront cost of `connect()`-path mocking
(path_provider stub, mock channel, ready-state simulation). Not trivial.

**Context.** Deferred from migration review D6. Conservative scope choice —
the migration itself is risky enough; layering on a full test scaffold
would inflate the PR.

**Depends on.** Migration PR landed. Establishing the testing pattern from
the 4 regression tests as a template.

---

## 4. Full `SubmitResponse.Disposition` UX (QUEUED / STEERED visibility)

**What.** v2 `SubmitResponse.disposition` can be:
- `STARTED_NOW` — new turn started (current default UX)
- `STEERED` — joined an in-flight turn (currently invisible — matches v1)
- `QUEUED` — behind an in-flight turn, will start later (currently invisible)
- `OBSERVED` — recorded only, no turn (chat-ui doesn't use OBSERVE intent)
- `DROPPED` — daemon dropped (migration handles this → CarbonError)

**Why.** When the user sends a second prompt while the first is still
generating, the daemon may QUEUE it. The user sees their prompt buble appear
but no typing indicator update, no "queued" feedback. UX silently degraded
vs. a single-prompt-at-a-time mental model. STEERED is similar.

**Pros.** Real visibility into what the daemon is doing. Foundation for
multi-turn UX (queue depth indicator, "your message is up next", etc.).

**Cons.** Requires UI surface design — where does the QUEUED state live in
the message bubble? How does it transition to STARTED_NOW? Two screens to
update (or do TODO #2 first).

**Context.** Deferred from migration review D4. The migration principle
was "v1 UX preserved" — exposing new daemon behavior to the user is a
deliberate scope expansion best done post-migration.

**Depends on.** Migration PR landed. UX design pass.
