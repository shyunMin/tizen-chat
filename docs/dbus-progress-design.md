# Carbon 에이전트 루프 & D-Bus 진행 이벤트 설계

---

## 범례

| 색상 | 의미 |
|------|------|
| 기본 (흰 배경) | 기존 컴포넌트 — 변경 없음 |
| 🟡 노랑 | 기존 컴포넌트 — 수정 필요 |
| 🟢 초록 | 신규 추가 |
| 실선 `→` | 기존 연결 |
| 점선 `⇢` | 신규 연결 |

---

## 1. 컴포넌트 구조

```mermaid
flowchart LR
    AppA["App A\ngRPC 클라이언트"]
    AppB["App B\n진행 상황 UI"]:::new

    subgraph Daemon["carbon-daemon"]
        Svc["service.rs\nAgentServiceImpl"]:::modified

        subgraph Runtime["carbon-runtime"]
            AM["agent_main()"]
            Turn["run_turn_inner()"]:::modified
            Ctx["ContextBuilder\nbuild_request()"]
        end
    end

    LLM["ModelProvider\nAnthropic / Gemini"]

    subgraph ToolSet["Tools (Rust)"]
        Bash["bash"]
        RW["read / write\nglob / grep"]
        SkillT["SkillTool"]
        UP["update_plan\n(인터셉트)"]
        EP["emit_progress\n(인터셉트)"]:::new
    end

    SkillFS["SKILL.md\n파일시스템"]
    DBus["D-Bus"]:::new

    AppA     -->  |"UserMessage"| Svc
    Svc      -->  AM
    AM       -->  |"spawn"| Turn
    Turn     -->  Ctx
    Ctx      -->  |"CompletionRequest"| LLM
    LLM      -->  |"text / tool_use"| Turn
    Turn     -->  |"execute"| Bash
    Turn     -->  |"execute"| RW
    Turn     -->  |"execute"| SkillT
    Turn     -->  |"인터셉트"| UP
    SkillT   -->  |"read"| SkillFS
    Turn     -->  |"AgentEvent"| Svc
    Svc      -->  |"ServerEvent"| AppA

    Turn     -.-> |"인터셉트"| EP
    EP       -.-> |"AgentEvent::\nProgressUpdate"| Svc
    Svc      -.-> |"D-Bus signal"| DBus
    DBus     -.-> |"신호"| AppB

    classDef new      fill:#d4edda,stroke:#28a745,color:#155724,font-weight:bold
    classDef modified fill:#fff3cd,stroke:#ffc107,color:#856404,font-weight:bold
```

---

## 2. 현재 실행 순서

```mermaid
sequenceDiagram
    actor AppA as App A
    participant Svc as service.rs
    participant AM as agent_main()
    participant Turn as run_turn_inner()
    participant LLM as ModelProvider
    participant SkillT as SkillTool
    participant FS as SKILL.md
    participant Tool as bash / read / ...

    AppA->>Svc: Session RPC → UserMessage
    Svc->>AM: IngressMessage { intent: RunTurn }
    AM->>Turn: tokio::spawn (background task)

    Note over Turn: ContextBuilder::build_request()<br/>system prompt + history + skills 목록 + plan 조립

    loop LLM 응답 루프

        Turn->>LLM: CompletionRequest
        LLM-->>Turn: Response

        opt 텍스트 응답
            Turn->>Svc: AgentEvent::TextDelta
            Svc->>AppA: ServerEvent::TextDelta
        end

        loop 툴 실행 (직렬)

            alt Skill("name") 호출
                Turn->>Svc: AgentEvent::ToolUseStart
                Svc->>AppA: ServerEvent::ToolUseStart
                Turn->>SkillT: execute({ name })
                SkillT->>FS: SKILL.md 파일 읽기
                FS-->>SkillT: 스킬 본문 (마크다운 지시문)
                SkillT-->>Turn: ToolResult { output: 스킬 본문 }
                Turn->>Svc: AgentEvent::ToolResult
                Svc->>AppA: ServerEvent::ToolResult
                Note over Turn,LLM: LLM이 스킬 지시문을 받아<br/>다음 응답부터 해당 패턴으로 동작

            else update_plan 호출 (인터셉트)
                Turn->>Svc: AgentEvent::ToolUseStart
                Svc->>AppA: ServerEvent::ToolUseStart
                Note over Turn: Thread.plan 내부 갱신<br/>(파일 저장 없음, 다음 턴에 반영)
                Turn->>Svc: AgentEvent::ToolResult
                Svc->>AppA: ServerEvent::ToolResult

            else 일반 툴 (bash 등)
                Turn->>Svc: AgentEvent::ToolUseStart
                Svc->>AppA: ServerEvent::ToolUseStart
                Turn->>Tool: execute(input)
                Tool-->>Turn: ToolResult
                Turn->>Svc: AgentEvent::ToolResult
                Svc->>AppA: ServerEvent::ToolResult
            end

        end

        Note over Turn: after_turn() 판단 — Complete / Continue / Pause
    end

    Turn->>Svc: AgentEvent::TurnComplete
    Svc->>AppA: ServerEvent::TurnComplete
```

---

## 3. D-Bus 추가 후 실행 순서

> 초록 배경 박스 = 신규 추가 영역

```mermaid
sequenceDiagram
    actor AppA as App A
    actor AppB as App B (진행 상황 UI)
    participant Svc as service.rs
    participant AM as agent_main()
    participant Turn as run_turn_inner()
    participant LLM as ModelProvider
    participant SkillT as SkillTool
    participant FS as SKILL.md
    participant EP as emit_progress Tool
    participant Tool as bash / read / ...
    participant DBus as D-Bus

    rect rgb(209, 231, 221)
        Note over AppB,DBus: 신규: D-Bus 구독
        AppB->>DBus: subscribe "carbon.v1.Progress"
    end

    AppA->>Svc: Session RPC → UserMessage ("최저가 찾아줘")
    Svc->>AM: IngressMessage
    AM->>Turn: tokio::spawn

    Note over Turn: ContextBuilder::build_request()

    Turn->>LLM: CompletionRequest
    LLM-->>Turn: tool_use: Skill("lowest-price-search")

    Turn->>SkillT: execute({ name: "lowest-price-search" })
    SkillT->>FS: SKILL.md 읽기
    FS-->>SkillT: 스킬 본문 (각 단계 전 emit_progress 호출 지시 포함)
    SkillT-->>Turn: ToolResult
    Turn->>Svc: AgentEvent::ToolResult
    Svc->>AppA: ServerEvent::ToolResult

    loop 각 검색 단계 (상품 검색 → 가격 수집 → 비교)

        Turn->>LLM: CompletionRequest
        LLM-->>Turn: tool_use [emit_progress({step, message}), bash(...)]

        rect rgb(209, 231, 221)
            Note over Turn,AppB: 신규: emit_progress 인터셉트 처리
            Turn->>EP: execute({ step, message })
            EP-->>Turn: ToolResult("ok")
            Note over Turn: AgentEvent::ProgressUpdate 생성 (신규 variant)
            Turn->>Svc: AgentEvent::ProgressUpdate
            Note over Svc: ProgressUpdate → App A 전달 안 함 (라우팅 수정)
            Svc->>DBus: emit_signal({ session_id, step, message })
            DBus->>AppB: 진행 상황 알림
        end

        Turn->>Tool: bash execute
        Tool-->>Turn: ToolResult
        Turn->>Svc: AgentEvent::ToolUseStart / ToolResult
        Svc->>AppA: ServerEvent::ToolResult

    end

    Turn->>LLM: CompletionRequest (최종 정리)
    LLM-->>Turn: TextDelta (최저가 결과)
    Turn->>Svc: AgentEvent::TurnComplete
    Svc->>AppA: ServerEvent::TurnComplete
```

---

## 4. 변경 파일 정리

| 파일 | 종류 | 변경 내용 |
|------|------|----------|
| `carbon-runtime/src/tools/emit_progress.rs` | **신규** | `EmitProgressTool` 구현. `execute()`는 `ToolResult("ok")` 반환만 하고 실제 발신은 agent_loop 인터셉트가 처리 |
| `carbon-runtime/src/tools/mod.rs` | **수정** | `pub mod emit_progress` 추가 |
| `carbon-runtime/src/agent_loop.rs` | **수정** | `AgentEvent::ProgressUpdate` variant 추가. 툴 실행 루프에서 `emit_progress` 인터셉트 → `tx.send(ProgressUpdate)` |
| `carbon-daemon/src/service.rs` | **수정** | `event_rx` 라우팅 분기 추가. `ProgressUpdate`는 D-Bus signal 발신만 하고 `grpc_tx`로 전달하지 않음 |
| `carbon-daemon/Cargo.toml` | **수정** | `zbus = "4"` 의존성 추가 |
| `carbon-claw/src/lib.rs` | **수정** | `tools.insert("emit_progress", Box::new(EmitProgressTool))` 등록 |
| `{skill}/SKILL.md` | **선택 신규** | 작업 스킬에서 각 단계 전 `emit_progress` 호출 패턴 지시 추가 |
| `carbon-proto/proto/carbon/v1/agent.proto` | **변경 없음** | D-Bus는 proto 수정 불필요 |
| `carbon-runtime/src/agent_main.rs` | **변경 없음** | |
| `carbon-runtime/src/providers/` | **변경 없음** | |

### 핵심 코드 변경 위치

**`agent_loop.rs` — 인터셉트 추가 위치**

현재 `update_plan` 인터셉트 바로 아래에 추가:

```rust
// 기존 update_plan 인터셉트 패턴
if name == "update_plan" && !result.is_error {
    thread.plan = Plan::from_update_plan_input(input);
}

// 추가
if name == "emit_progress" {
    let step    = input.get("step").and_then(|v| v.as_str()).unwrap_or("").to_string();
    let message = input.get("message").and_then(|v| v.as_str()).unwrap_or("").to_string();
    // tx는 run_turn_inner 파라미터로 이미 존재
    let _ = tx.send(AgentEvent::ProgressUpdate { step, message }).await;
}
```

**`service.rs` — 이벤트 라우팅 분기 위치**

현재 `event_rx.recv()` 처리 블록 (line 384):

```rust
Some(event) = event_rx.recv() => {
    match &event {
        AgentEvent::ProgressUpdate { step, message } => {
            // App A로 전달하지 않음 — D-Bus signal 발신만
            if let Ok(conn) = zbus::blocking::Connection::session() {
                let _ = conn.emit_signal(
                    None::<()>,
                    "/carbon/progress",
                    "carbon.v1.Progress",
                    "ProgressUpdate",
                    &(sid.as_str(), step.as_str(), message.as_str()),
                );
            }
        }
        _ => {
            // 기존 동작 유지
            if let Some(se) = agent_event_to_server_event(&event, &sid) {
                let _ = grpc_tx.send(Ok(se)).await;
            }
        }
    }
}
```
