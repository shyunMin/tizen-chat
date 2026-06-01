# TODOs

Deferred work surfaced while making Carbon and Argot runtime backends
switchable.

---

## 1. Restore richer turn lifecycle signals when Argot exposes them

Argot v1 currently exposes `Chat` and `ChatStream` only. `AgentGrpcService`
keeps common adapter types for steer, queue, approval, validation, and
session-end events so Carbon can keep working and Argot can grow into the same
surface later.

## 2. Add reconnect replay when Argot streams expose event cursors

Argot `ChatStream` has no `resume_from` cursor today. If the stream drops
mid-turn, the client can only reconnect at the session level and may miss
deltas emitted during the gap.

## 3. Replace setup no-op with real Argot setup API

`AgentOnboardingService` delegates to Carbon's existing setup RPC, but Argot
currently returns `ready=true` and logs for config reads/writes because Argot v1
does not provide setup/config gRPC methods. When Argot adds that surface, wire
it into the existing QR setup UI.

## 4. Broaden backend adapter tests

Current tests cover Carbon's restored adapter behavior and Argot's core
`ChatEvent` mapping. Add coverage for `AgentGrpcService` facade backend
selection, live connection failure, session id reuse, stream cancellation, and
reconnect behavior.
