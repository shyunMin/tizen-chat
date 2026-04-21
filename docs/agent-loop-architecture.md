# Carbon 에이전트 루프 아키텍처

## 1. 전체 요청 흐름

```
클라이언트 (gRPC)
    ↓
IngressMessage { source, target_agent, content, intent }
    ↓
agent_main() — tokio::select! 이벤트 루프
    ↓  decide_action(): RunTurn → run_turn_message()
    ↓
[백그라운드 태스크 spawn] ← SessionState 소유권 이전
    ↓
run_turn_inner()  ← 핵심 에이전트 루프
    ├─ 컨텍스트 빌드 (system prompt + history 조립)
    ├─ LLM 호출 (provider.complete)
    ├─ 응답 처리 (TextDelta / ToolUse)
    └─ 툴 실행 루프 (직렬, 1회씩)
    ↓
TurnOutcome: Complete | Continue | Pause
    ├─ Continue → Box::pin(run_turn_inner()) 재귀
    └─ Complete → restore_tx로 SessionState 반환
    ↓
AgentEvent 스트림 → EgressPort → 클라이언트
```

---

## 2. 핵심 데이터 구조

### AgentImpl (불변, Arc로 공유)

```rust
pub struct AgentImpl {
    pub context_builder: Arc<dyn ContextBuilder>,   // system prompt + history 조립
    pub controller:      Arc<dyn AgentController>,  // 훅 (before_llm, on_tool_result, after_turn)
    pub tools:           Arc<HashMap<String, Box<dyn Tool>>>,
    pub provider:        Arc<dyn ModelProvider>,    // Anthropic / Gemini
    pub executor:        Arc<dyn Executor>,         // WorkspaceExecutor (경로 재작성 + sandbox)
}
```

### SessionState (턴 동안 소유권 이전)

```rust
pub struct SessionState {
    pub id:                   String,
    pub history:              Vec<Message>,          // 전체 대화 이력
    pub turn_count:           u32,
    pub threads:              Vec<Thread>,           // 작업 에피소드
    pub active_thread_idx:    Option<usize>,
    pub last_frontier_ids:    Vec<String>,           // 연속 턴 판단 기준
    pub total_usage:          Usage,
}
```

### CompletionRequest (LLM 호출마다 생성)

```rust
pub struct CompletionRequest {
    pub model:      String,
    pub system:     String,             // 주입된 섹션들 전부
    pub messages:   Vec<Message>,       // 전체 history
    pub tools:      Vec<ToolDefinition>,
    pub max_tokens: u32,
    pub constraint: ResponseConstraint,
}
```

---

## 3. 에이전트 루프 단계별 상세

### Phase 1: 메시지 수신 (`agent_main`)

```rust
tokio::select! {
    // 완료된 턴에서 SessionState 복원
    Some((session, log)) = restore_rx.recv() => {
        turn_busy = false;
    }
    // 신규 메시지 수신
    msg = ingress_rx.recv() => {
        if turn_busy {
            match policy {
                DropIfBusy  => 에러 이벤트 전송,
                Serialize   => restore_rx 먼저 기다림,
            }
        }
        tokio::spawn(run_turn_message(...));
        turn_busy = true;
    }
}
```

**설계 포인트**: SessionState를 spawn된 태스크로 이전하고 채널로 복원 → `Arc<Mutex<>>` 회피

---

### Phase 2: 컨텍스트 빌드 (`ContextBuilder::build_request`)

system 문자열에 순서대로 주입:

| 주입 섹션 | 출처 |
|-----------|------|
| system_prompt() | 제품 정체성 (Claw 프롬프트) |
| memory_section() | `~/.carbon/memory.md` |
| runtime_context() | 현재 시각, 런타임 정보 |
| skills_section() | 스킬 이름+설명 목록 (본문 제외) |
| plan_section() | 활성 플랜 프론티어 |
| narration_section() | 연속 턴 진입 시 단계 힌트 |

---

### Phase 3: LLM 호출 및 재시도

```rust
// 최대 10회 시도, 기본값은 3회에서 종료
for attempt in 0..max_attempts {
    match provider.complete(request.clone()).await {
        Ok(resp)  => return Ok(resp),
        Err(e)    => match controller.on_error(&e, attempt) {
            Retry     => sleep(1s * 2^attempt).await,  // 1s, 2s, 4s, 8s...
            Terminate => return Err(e),
        }
    }
}
```

---

### Phase 4: 툴 실행 루프 (직렬)

```
for 각 ToolUse in 응답:
    1. controller.before_tool()  → Execute / Skip / Reject(fatal)
    2. executor.execute_tool()   → WorkspaceExecutor 경로 재작성 → tool.execute()
    3. update_plan 인터셉트      → Thread.plan 갱신
    4. controller.on_tool_result() → Terminate(fatal) 여부 확인
    5. session.history에 ToolResult 추가
```

**현재 동작**: 툴은 **1회씩 순차 실행** (병렬화 없음)

---

### Phase 5: 연속 턴 판단 (`DefaultController::after_turn`)

| 조건 | 결과 |
|------|------|
| update_plan만 실행됨 | Continue |
| plan frontier 변경됨 | Continue |
| frontier 미변경 + 미완료 항목 존재 | Continue (3회 후 Pause) |
| depth 한도 초과 | Pause |
| 위 해당 없음 | Complete |

Continue → `Box::pin(run_turn_inner())` 재귀 호출 (스택 깊이 한도: `max_continuation_depth`)

---

## 4. 스킬 시스템 동작 원리

### 로딩 방식 (Progressive Disclosure)

```
1. 시작 시: SkillLoader::load_all()
   └─ 각 SKILL.md YAML 프론트매터만 파싱 (name, description)

2. system prompt 주입: skills_section()
   └─ [이름 + 설명] 목록만 포함 (본문 없음)

3. LLM이 Skill 툴 호출 시:
   └─ SKILL.md 본문을 파일에서 읽어 LLM에 반환
   └─ LLM이 해당 지시를 따라 후속 동작 수행
```

### 스킬 검색 경로 (우선순위 순)

```
~/.carbon/skills/                  # 사용자 설치
$CARBON_SKILLS_DIRS                # 플랫폼 패키지 (환경변수)
$CARGO_MANIFEST_DIR/skills/        # 번들 기본 스킬
```

### 스킬 vs 툴 비교

| 항목 | 스킬 | 툴 |
|------|------|----|
| 정의 방식 | SKILL.md (마크다운 + YAML) | Rust struct + async trait |
| 발견 방식 | 파일시스템 스캔 | AgentImpl에 하드코딩 |
| 실행 비용 | +1 LLM 턴 (본문 fetch) | 즉시 실행 |
| 역할 | 도메인별 워크플로우 지시 | 실제 동작 (I/O, API) |
| 확장성 | 파일 추가만으로 등록 | Rust 코드 수정 필요 |

---

## 5. 레이턴시 분석

### 턴당 단계별 예상 소요 시간

| 단계 | 소요 시간 | 비고 |
|------|----------|------|
| 메시지 수신 → spawn | < 1ms | |
| 컨텍스트 빌드 | 1~10ms | history 크기 비례 |
| **LLM 호출** | **1~30s** | **지배적 병목** |
| 응답 파싱 | 1~5ms | |
| 툴 실행 (1개당) | 10ms~60s | bash, 네트워크 가변 |
| 세션 로그 I/O | 1~10ms | 비동기 JSONL append |
| **단순 턴 합계** | **~2~60s** | LLM + 툴이 대부분 |

### 연속 턴 시 추가 비용

```
연속 3회 × LLM 호출 → 3~90s 추가
각 연속 턴 = 새 컨텍스트 빌드 + 전체 history 재전송
```

### 컴팩션 비용

- 트리거: 입력 토큰 > 컨텍스트 윈도우의 80%
- 비용: 별도 LLM 요약 호출 (+0.5~2s)
- 이후: history가 요약본으로 교체됨

---

## 6. 동시성 구조

```
daemon
  ├─ Session A ─ 백그라운드 턴 태스크 (tokio::spawn)
  ├─ Session B ─ 백그라운드 턴 태스크
  └─ Session C ─ 대기 중 (turn_busy = false)

각 세션 내부:
  단일 턴 = 단일 비동기 흐름 (툴 병렬화 없음)
  이벤트 포워딩은 별도 태스크
```

**병렬화 현황**:
- 세션 간: 병렬 (tokio::spawn)
- 세션 내 LLM ↔ 툴: 불가 (순차)
- 세션 내 툴 ↔ 툴: 불가 (순차)

---

## 7. SKILL을 활용한 응답 속도 개선 방안

### 현황 진단

응답 느림의 원인은 크게 세 가지:

1. **멀티 툴 호출 직렬화**: 10개 툴 × 평균 1s = 10s
2. **불필요한 연속 턴**: `update_plan`만 실행 후 자동 재귀
3. **스킬 본문 fetch 비용**: Skill 툴 호출 시 +1 LLM 턴

### 개선안 1: `response-synthesizer` 스킬 활용 (즉시 적용 가능)

현재 `carbon-claw/skills/response-synthesizer/SKILL.md`가 존재함.
이 스킬이 툴 결과 수집 후 최종 응답을 한 번에 합성하도록 유도하면
불필요한 중간 텍스트 출력을 제거하여 체감 속도 향상.

```yaml
# SKILL.md 프론트매터 예시 추가
allowed-tools:
  - bash
  - read
  - glob
  - grep
```

`allowed-tools`가 설정되면 툴 승인 단계를 생략할 수 있어
`before_tool()` 훅 비용이 줄어듦 (현재 미구현이지만 인터페이스 존재).

---

### 개선안 2: 병렬 툴 실행 스킬 패턴 (Skill로 LLM 유도)

에이전트가 독립적인 툴 호출을 **단일 LLM 응답에 여러 ToolUse 블록으로** 묶도록
유도하는 스킬을 만들면, 런타임이 이를 배치로 받아 처리할 준비가 됨.

현재 `agent_loop.rs`의 툴 실행 루프가 직렬이므로,
스킬로 "독립 작업은 한 번에 요청하라"는 지시를 줄 수 있음.
실제 병렬화는 아래 런타임 수정안과 함께 효과를 냄.

---

### 개선안 3: 연속 턴 조건 완화 (런타임 수정 필요, 스킬로 부분 완화)

`update_plan`만 실행된 턴이 자동 연속되는 로직이 주요 원인.
**스킬 수준 완화**: `update_plan`과 핵심 작업을 같은 응답에 묶도록
시스템 프롬프트 또는 스킬로 LLM에 지시.

```
# 스킬 지시 예시 (SKILL.md 본문)
계획 업데이트와 첫 번째 실행 단계를 동일한 응답에 포함하세요.
update_plan 단독 응답은 연속 턴을 유발하므로 지양합니다.
```

---

### 개선안 4: 컨텍스트 캐싱 (Anthropic API 활용, 런타임 수정 필요)

`AnthropicProvider`에 OAuth 경로 존재 시 `cache_control` 힌트가 추가됨.
API 키 경로에서도 system prompt 블록에 `cache_control: {"type": "ephemeral"}` 추가 시
반복 턴에서 system prompt 토큰 비용 및 첫 토큰 지연 감소 (Anthropic Prompt Caching).

현재 코드 위치: `carbon-runtime/src/providers/anthropic.rs` → `build_request_body()`

---

### 개선안 요약

| 방안 | 적용 방법 | 난이도 | 기대 효과 |
|------|----------|--------|----------|
| response-synthesizer 스킬 강화 | SKILL.md 수정 | 낮음 | 체감 응답 향상 |
| 단일 응답에 툴 묶기 유도 | 스킬/시스템 프롬프트 | 낮음 | 연속 턴 감소 |
| update_plan + 실행 통합 지시 | 스킬/시스템 프롬프트 | 낮음 | 연속 턴 1회 제거 |
| 툴 병렬 실행 | `agent_loop.rs` 수정 | 높음 | 툴 많을 때 큰 효과 |
| Anthropic Prompt Caching | `anthropic.rs` 수정 | 중간 | LLM 첫 토큰 단축 |
| 연속 턴 임계값 조정 | `agent_loop.rs` 수정 | 낮음 | 자동 재귀 횟수 제한 |

---

## 8. 참고 파일 경로

| 파일 | 역할 |
|------|------|
| `carbon-runtime/src/agent_main.rs` | 이벤트 루프, 턴 spawn |
| `carbon-runtime/src/agent_loop.rs` | 단일 턴 실행, 툴 루프, 연속 판단 |
| `carbon-runtime/src/agent.rs` | AgentImpl, 세션 복원 |
| `carbon-runtime/src/context_builder.rs` | CompletionRequest 조립 |
| `carbon-runtime/src/providers/anthropic.rs` | Anthropic API 클라이언트 |
| `carbon-runtime/src/tools/skill_tool.rs` | Skill 툴 실행 |
| `carbon-runtime/src/skill.rs` | SkillLoader, 스킬 발견 |
| `carbon-daemon/src/service.rs` | gRPC 세션 관리 |
| `carbon-claw/src/lib.rs` | Claw 제품 정의, 툴 등록 |
| `carbon-claw/skills/` | Claw 번들 스킬 디렉토리 |
