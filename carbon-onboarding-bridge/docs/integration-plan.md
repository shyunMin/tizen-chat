# Carbon 아키텍처 통합 분석

## 현재 기능 목록과 통합 대상

| 현재 구현 | 담당 컴포넌트 | 성격 |
|-----------|-------------|------|
| config.yaml 읽기 | carbon-config-service | 인프라 |
| config.yaml 쓰기 | carbon-config-service | 인프라 |
| carbon-daemon 재시작 | carbon-config-service | 인프라 |
| 모바일 설정 HTML 서빙 | SetupHttpServer (qr-code-setup 내부) | 프레젠테이션 |
| QR 코드 TV 표시 | SetupQrView (qr-code-setup) | 프레젠테이션 |
| AppControl 인터페이스 | AppControlHandler (qr-code-setup) | 플랫폼 어댑터 |

---

## 1. config.yaml 읽기/쓰기 → `carbon-daemon` + `carbon-proto`

`carbon-daemon`이 이미 `config.yaml`을 읽어서 사용하고 있으므로, 설정 변경 gRPC endpoint를 daemon에 추가하면 별도의 C 서비스가 필요 없어진다.

```protobuf
// carbon-proto에 추가
service ConfigService {
  rpc GetConfig(GetConfigRequest)  returns (GetConfigResponse);
  rpc SetConfig(SetConfigRequest)  returns (SetConfigResponse);
}
```

`carbon-config-service` 전체가 이 두 RPC로 대체된다.

---

## 2. carbon-daemon 재시작 → config hot-reload로 대체

현재 `systemctl restart`는 모든 세션이 끊어지는 문제가 있다. 통합 시에는 `SetConfig` RPC를 받은 daemon이 config.yaml을 저장하고 in-process hot-reload를 수행한다. 세션이 끊어지지 않으며 재시작도 필요 없다.

코드 분석 결과, `AnthropicClient` / `GeminiClient` / `OpenAIClient` 모두 생성 시 API key를 `String`으로 복사해 저장하고 config 참조를 보관하지 않는다. `WebSearchTool`도 `WebSearchConfig`를 값으로 복사해 저장한다. 즉 config를 파일에 쓰는 것만으로는 실행 중인 registry에 반영되지 않는다.

해결책은 **`ArcSwap<ModelClientRegistry>` 패턴**이다. `SetConfig` 호출 시 새 API key 값으로 `AnthropicClient`, `GeminiClient` 등의 인스턴스를 새로 생성해 registry를 만들고, `ArcSwap::store()`로 기존 registry와 atomic하게 교체한다. 현재 실행 중인 세션은 교체 전 registry 스냅샷을 계속 쓰고, 다음 LLM 요청부터 새 registry가 적용된다. 세션 중단 없이 API key 변경이 적용된다.

---

## 3. 모바일 설정 페이지 서빙 → `carbon-daemon` 내장 `SetupModule`

`carbon-port-cli`, `carbon-port-telegram`은 사용자가 직접 실행하는 독립 클라이언트라 외부 프로세스가 적합하다. 반면 setup HTTP 서버는 필요할 때만 켜고 끄는 서비스에 가깝기 때문에, 별도 프로세스보다 **daemon 내부 모듈**로 두는 것이 더 자연스럽다.

`chat-ui`가 `StartSetup` RPC를 호출하면 daemon이 HTTP 서버를 시작하고 URL을 반환한다. setup이 끝나면 `StopSetup` RPC로 서버를 내린다.

```protobuf
// carbon-proto에 추가
service SetupService {
  rpc StartSetup(StartSetupRequest)  returns (StartSetupResponse);  // HTTP 서버 시작, URL 반환
  rpc StopSetup(StopSetupRequest)   returns (StopSetupResponse);   // HTTP 서버 종료
}
```

`SetupModule`이 담당하는 일:
- `StartSetup` 수신 시 HTTP 서버 시작, LAN IP 탐색 후 URL 반환
- 폰 브라우저의 `GET /setup` 요청에 설정 폼 HTML 서빙
- 폰 브라우저의 `POST /setup` 수신 시 config 저장 함수를 **gRPC 없이 내부 직접 호출**해 설정 저장
- `StopSetup` 수신 시 HTTP 서버 종료

기존 `SetupHttpServer` + `CarbonSetupService`가 이 모듈로 이동한다. SetupModule과 config 저장 로직이 같은 daemon 프로세스 안에 있으므로 gRPC를 경유하지 않고 Rust 함수를 직접 호출한다. 이로 인해 loopback HTTP 브리지(포트 18182)도 사라진다.

---

## 4. QR 코드 표시 + AppControl → `chat-ui` onboarding flow

`chat-ui`는 웹 서버를 띄우지 않는다. `StartSetup` RPC로 daemon에 setup 시작을 요청하고, 반환된 URL을 TV 화면에 QR 코드로 표시하는 역할만 담당한다. setup이 완료되면 `StopSetup`을 호출해 서버를 내린다.

- QR 코드 생성은 Flutter 생태계 라이브러리로 대체 → 현재 53바이트 제한 제거
- AppControl 인터페이스는 Tizen Flutter 플러그인으로 처리

---

## 통합 후 구조

### 역할 분담

| 컴포넌트 | 역할 |
|---------|------|
| `carbon-daemon` | config 읽기/쓰기 + hot-reload, setup HTTP 서버 lifecycle 관리 |
| `chat-ui` | setup 시작/종료 요청, TV 화면에 QR 코드 표시, AppControl 처리 |

### 모듈 배치

```
carbon-proto
  └── ConfigService (GetConfig / SetConfig RPC 추가)
  └── SetupService  (StartSetup / StopSetup RPC 추가)

carbon-daemon
  └── ConfigService 구현 (config.yaml 읽기/쓰기 + hot-reload)
  └── SetupModule   (StartSetup 시 HTTP 서버 시작, StopSetup 시 종료)

chat-ui
  └── StartSetup RPC → URL 수신 → TV 화면에 QR 코드 표시
  └── StopSetup RPC (설정 완료 후)
  └── AppControl 인터페이스 (Tizen Flutter 플러그인)
```

### 통합 후 통신 흐름

```
[setup 시작]
chat-ui
  │  gRPC StartSetup()
  ▼
carbon-daemon (SetupModule)
  │  HTTP 서버 시작, LAN IP 탐색
  │  URL 반환
  ▼
chat-ui → TV 화면에 QR 코드 표시

[폰이 QR 스캔 후 설정]
폰 브라우저
  │  HTTP GET /setup (LAN)
  ▼
carbon-daemon (SetupModule)
  │  config 읽기 함수 직접 호출 (gRPC 없이)
  ▼
설정 폼 HTML 반환

폰 브라우저
  │  HTTP POST /setup
  ▼
carbon-daemon (SetupModule)
  │  config 저장 함수 직접 호출 (gRPC 없이)
  ▼
config.yaml 저장 (provider 설정은 daemon 재시작 후 적용)

[setup 종료]
chat-ui
  │  gRPC StopSetup()
  ▼
carbon-daemon (SetupModule) → HTTP 서버 종료
```

---

## 사라지는 것

| 제거 대상 | 대체 |
|-----------|------|
| `carbon-config-service` 전체 (C 서비스, systemd unit) | `carbon-daemon` ConfigService RPC |
| loopback HTTP 브리지 (포트 18182) | daemon 내부 직접 호출 |
| `SetupHttpServer` + `CarbonSetupService` (qr-code-setup 내부) | `carbon-daemon` SetupModule |
| `systemctl restart carbon-daemon` | config hot-reload (`ArcSwap<ModelClientRegistry>` atomic 교체) |
| 순수 C# QR 인코더 (53바이트 제한) | Flutter QR 라이브러리 |
| `qr-code-setup` Tizen .NET 앱 전체 | `chat-ui` onboarding flow |

---

## 코드 분석 — 현재 carbon-0509 상태

요구사항 작성 전에 최신 코드에서 이미 존재하는 것과 없는 것을 확인했다.

### 이미 존재하는 것

| 항목 | 위치 | 활용 가능 여부 |
|------|------|-------------|
| `CarbonConfig` 구조체 (`Serialize` / `Deserialize`) | `crates/core/runtime/src/config.rs` | `GetConfig` / `SetConfig` 구현에 직접 사용 가능 |
| `config_path()` 함수 | `config.rs` | config.yaml 경로 참조에 사용 |
| `carbon_home()` 함수 | `config.rs` | temp 파일 경로 계산에 사용 |
| `onboarding_hint()` 함수 | `config.rs` | API key 미설정 감지 로직 참조 가능 |
| Tokio async 런타임 | `crates/infra/daemon/src/main.rs` | SetupModule HTTP 서버를 `tokio::spawn`으로 추가 가능 |
| tonic gRPC 서버 | `main.rs` | `.add_service()`로 새 서비스 추가 가능 |
| Unix socket 전송 | `main.rs` | 기존 연결 방식 그대로 재사용 |

### 없는 것 (신규 구현 필요)

| 항목 | 현재 상태 |
|------|---------|
| `ConfigService` / `SetupService` proto | `agent.proto`에 `AgentService` 하나만 존재 |
| config 쓰기 함수 | `load_or_bootstrap()`만 있고 write 없음 |
| config hot-reload | `Arc<CarbonConfig>`가 시작 시 1회 로드 후 불변 |
| SetupModule (HTTP 서버) | 없음 |

### provider 구현체 분석 — hot-reload 가능 여부

provider 구현체가 API key를 config 참조로 들고 있는지, String으로 복사해 저장하는지 확인했다.

| provider | 저장 방식 | 위치 |
|----------|----------|------|
| `AnthropicClient` | `auth: AuthMethod::ApiKey(String)` — 생성 시 String 복사 | `crates/infra/provider/anthropic/src/lib.rs:54` |
| `GeminiClient` | `api_key: String` 필드 — 생성 시 String 복사 | `crates/infra/provider/gemini/src/client.rs:43` |
| `WebSearchTool` | `config: WebSearchConfig` 값 복사 — 전체 config 복사 | `crates/core/runtime/src/tools/web_search.rs:20` |

세 경우 모두 생성 시점에 값을 복사하고 이후 `CarbonConfig` 참조를 보관하지 않는다. `providers.rs`의 `model_client_registry_from_config()`도 `config.providers.anthropic.api_key.clone()` 등으로 값을 복사해 client를 만든다.

**결론: config.yaml만 덮어써서는 실행 중인 registry에 반영되지 않는다.** hot-reload를 위해서는 `SetConfig` 후 새 API key 값으로 provider 인스턴스를 새로 생성하고 `ArcSwap`으로 registry를 교체해야 한다. 세션 중단 없이 구현 가능하다.

---

## 요구사항

### carbon-proto (`crates/core/proto/proto/carbon/v1/`)

- **`config.proto` 신규 추가** — 기존 `agent.proto`와 분리된 파일로 작성
  - `GetConfigRequest` / `GetConfigResponse`
    - `string yaml` — config.yaml 전문
    - `bool ready` — provider가 하나라도 설정되어 있으면 true (daemon이 판단, 기존 `onboarding_hint()` 로직 재사용)
    - `string hint` — `ready=false`일 때 사람이 읽을 수 있는 안내 메시지
  - `SetConfigRequest` (`string yaml`) / `SetConfigResponse` — 저장 성공 여부 + 변경 적용 메시지 (재시작 필요 여부 안내 포함)
  - `ConfigService` 서비스 선언 (`GetConfig` / `SetConfig` RPC)

- **`setup.proto` 신규 추가**
  - `StartSetupRequest` — `int32 preferred_port` (optional, 기본 18181), `string title`, `string description`
  - `StartSetupResponse` — `string url` (바인드된 LAN URL)
  - `StopSetupRequest` / `StopSetupResponse`
  - `SetupEvent` — `enum kind { COMPLETED, STOPPED }` + `string url`
  - `SetupService` 서비스 선언: `StartSetup` / `StopSetup` / `WatchSetup(stream SetupEvent)` RPC

### carbon-daemon (`crates/infra/daemon/`)

- **config 쓰기 함수 추가** (`crates/core/runtime/src/config.rs`)
  - `CarbonConfig`를 YAML로 직렬화 → temp 파일(`config.yaml.tmp`) 쓰기 → atomic `rename` → `config.yaml`
  - 기존 파일을 `config.yaml.bak`으로 백업 후 교체 (현재 `carbon-config-service`와 동일한 패턴)
  - 기존 `load_config_file()` 재사용 가능

- **`ConfigService` gRPC 구현** (`src/config_service.rs` 신규)
  - `GetConfig`: `config_path()`에서 파일 읽기 → YAML 문자열 반환. 파일 없으면 `default_config_template()` 반환. `ready` / `hint` 판단은 기존 `onboarding_hint()` 로직 재사용
  - `SetConfig`: YAML 수신 → `serde_yaml`로 파싱 및 검증 → 파일 저장 → **registry hot-reload** (아래 참고) → 성공 응답 반환
  - `main.rs`에서 `AgentServiceServer`와 함께 `ConfigServiceServer` 등록 (`.add_service()`)

- **config hot-reload 구현** (`main.rs` / `src/config_service.rs`)
  - `ModelClientRegistry`를 `Arc<ArcSwap<ModelClientRegistry>>`로 래핑해 daemon 전체에서 공유
  - `SetConfig` 성공 시 새 config로 `model_client_registry_from_config()` 재호출 → `ArcSwap::store()`로 atomic 교체
  - `WebSearchTool`도 config 값 복사 방식이므로, `SetConfig` 시 `WebSearchTool` 인스턴스도 새 config 값으로 다시 생성해 교체 필요 (`AgentRegistry` 또는 tool factory를 `ArcSwap`으로 래핑하거나, `WebSearchTool`이 `Arc<ArcSwap<WebSearchConfig>>`를 참조하도록 수정)
  - 현재 실행 중인 세션은 swap 이전 registry 스냅샷을 계속 사용하고, 다음 LLM 요청부터 새 registry 적용 — 세션 중단 없음
  - `arc-swap` crate 의존성 추가 필요

- **`SetupModule` + `SetupService` gRPC 구현** (`src/setup_service.rs` 신규)
  - 내부 상태: `Arc<Mutex<Option<SetupHandle>>>` (현재 실행 중인 HTTP 서버 handle)
  - `StartSetup`:
    - 이미 실행 중이면 기존 URL 반환 (중복 실행 방지)
    - `tokio::net::TcpListener`로 포트 바인드 (18181부터 순차 탐색)
    - LAN IP 탐색 (loopback / link-local 제외)
    - `tokio::spawn`으로 HTTP accept loop 시작
    - URL 반환
  - `GET /setup`: 현재 config.yaml 읽기 → HTML 폼 생성. 노출 필드: `providers.anthropic.api_key`, `providers.gemini.api_key`, `web_search.brave.api_key`, `defaults.provider`, `defaults.model`
  - `POST /setup`: form-urlencoded 파싱 → 변경 필드만 기존 config에 merge → `SetConfig` 내부 호출 → `WatchSetup` 구독자에게 `COMPLETED` 이벤트 broadcast → 결과 HTML 응답
  - `StopSetup`: HTTP 서버 shutdown, 구독자에게 `STOPPED` broadcast
  - `WatchSetup`: `tokio::sync::broadcast` 채널 구독, 이벤트 수신 시 streaming으로 전달
  - `main.rs`에서 `SetupServiceServer` 등록

### chat-ui

- **proto Dart stub 재생성**
  - `config.proto` / `setup.proto` 추가 후 `protoc` 재실행 → `lib/generated/` 갱신

- **온보딩 flow 화면 추가**
  - `chat-ui`는 Tizen 앱 샌드박스 안에서 실행되므로 `config.yaml`에 직접 접근할 수 없다. config 상태 확인은 반드시 `GetConfig` RPC를 통해 daemon에게 위임해야 한다.
  - 앱 초기 진입 시 `GetConfig` RPC 호출 → 응답의 `ready` 필드로 화면 분기:
    - `ready: false` → 온보딩 화면으로 자동 진입. `hint` 메시지를 화면에 표시
    - `ready: true` → 일반 채팅 화면으로 진입
  - `ready: true`인 상태에서도 사용자가 설정 변경을 원할 수 있으므로, 채팅 화면에 설정 진입점(버튼 등)을 두고 언제든 온보딩 화면을 수동으로 열 수 있어야 한다
  - 온보딩 화면 진입 시 `StartSetup` 호출 → URL 수신
  - `WatchSetup` streaming 구독 → `COMPLETED` 이벤트 수신 시 `StopSetup` 호출 → QR 화면 종료 후 `GetConfig`를 다시 호출해 `ready` 상태를 갱신
  - 사용자가 설정 완료 없이 수동으로 화면을 닫거나 앱이 종료될 때도 `StopSetup` 호출 (HTTP 서버가 떠 있는 채로 남지 않도록)

- **QR 코드 표시**
  - Flutter QR 라이브러리 추가 (예: `qr_flutter`) — 현재 53바이트 제한 제거
  - `StartSetup`이 반환한 URL을 QR 코드 위젯으로 렌더링
  - URL이 `127.0.0.1`을 포함하면 "LAN IP를 찾지 못했습니다. TV 네트워크를 확인하세요." 경고 표시

- **AppControl 인터페이스**
  - Tizen Flutter 플러그인으로 AppControl 수신 처리
  - `ShowSetupQr` → 온보딩 화면 진입 + `StartSetup` 호출, 응답 URL을 AppControl reply로 반환
  - `HideSetupQr` → `StopSetup` 호출 + 화면 종료
  - `GetStatus` → 현재 상태 (`visible`, `url`) JSON으로 AppControl reply 반환
