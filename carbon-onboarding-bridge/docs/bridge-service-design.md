# carbon-onboarding-bridge 설계

## 1. 목적

carbon-daemon에 ConfigService / SetupService가 통합되기 전까지, chat-ui가 동일한 gRPC 인터페이스로 통신할 수 있는 임시 브리지 서비스다.

최종 migration 시 chat-ui 변경이 최소화되도록 **proto 인터페이스를 carbon-daemon 최종 설계와 동일하게** 정의한다. 전환 시 chat-ui는 gRPC 소켓 경로 상수 하나만 변경하면 된다.

---

## 2. 전체 구조

```
chat-ui
  │  gRPC over Unix socket
  │  /run/user/5001/carbon/onboarding.sock
  ▼
carbon-onboarding-bridge
  ├── ConfigService  ← GetConfig / SetConfig
  │     └── config.yaml 직접 읽기/쓰기 + systemctl restart carbon-daemon
  └── SetupService   ← StartSetup / StopSetup / WatchSetup
        └── Tokio HTTP 서버 (GET/POST /setup)
              └── config.yaml 읽기/쓰기 + systemctl restart carbon-daemon

[폰 브라우저]
  │  HTTP LAN (18181)
  ▼
carbon-onboarding-bridge (SetupModule HTTP 서버)
```

carbon-daemon과 소켓 경로가 달라서 동시에 실행해도 충돌하지 않는다.

---

## 3. gRPC 인터페이스 (proto)

carbon-daemon 최종 설계와 동일한 파일명 / 서비스명 / 필드명을 사용한다. carbon-daemon에 통합될 때 proto 파일 자체를 그대로 이전하면 된다.

### `proto/carbon/v1/config.proto`

```protobuf
syntax = "proto3";
package carbon.v1;

service ConfigService {
  rpc GetConfig(GetConfigRequest) returns (GetConfigResponse);
  rpc SetConfig(SetConfigRequest) returns (SetConfigResponse);
}

message GetConfigRequest {}

message GetConfigResponse {
  string yaml  = 1;
  bool   ready = 2;  // provider가 하나라도 설정되어 있으면 true
  string hint  = 3;  // ready=false일 때 사람이 읽을 수 있는 안내
}

message SetConfigRequest {
  string yaml = 1;
}

message SetConfigResponse {
  bool   success         = 1;
  string message         = 2;  // 예: "config saved and carbon-daemon restarted."
  bool   restart_success = 3;  // systemctl restart 성공 여부
}
```

### `proto/carbon/v1/setup.proto`

```protobuf
syntax = "proto3";
package carbon.v1;

service SetupService {
  rpc StartSetup(StartSetupRequest)   returns (StartSetupResponse);
  rpc StopSetup(StopSetupRequest)     returns (StopSetupResponse);
  rpc WatchSetup(WatchSetupRequest)   returns (stream SetupEvent);
}

message StartSetupRequest {
  int32  preferred_port = 1;  // 기본 18181
  string title          = 2;
  string description    = 3;
}

message StartSetupResponse {
  string url = 1;  // 바인드된 LAN URL (예: http://192.168.1.10:18181/setup)
}

message StopSetupRequest  {}
message StopSetupResponse {}
message WatchSetupRequest {}

message SetupEvent {
  enum Kind {
    UNKNOWN   = 0;
    COMPLETED = 1;  // 폰에서 설정 저장 완료
    STOPPED   = 2;  // StopSetup 호출로 종료
  }
  Kind   kind = 1;
  string url  = 2;
}
```

---

## 4. 소켓 경로

| 대상 | 소켓 경로 |
|------|---------|
| 브리지 (임시) | `/run/user/5001/carbon/onboarding.sock` |
| carbon-daemon (최종) | `/run/user/5001/carbon/carbon.sock` |

경로는 환경변수 `CARBON_ONBOARDING_SOCK`으로 재정의 가능하게 한다. chat-ui도 동일한 환경변수를 참조하면 소켓 경로 변경을 배포 설정으로 처리할 수 있다.

---

## 5. 파일 구조

기존 `carbon-onboarding` 레포 내에 새 Rust crate로 추가한다. carbon-0509와 기술 스택을 맞춰 마이그레이션 시 코드 이전이 쉽도록 한다.

```
carbon-onboarding/
└── carbon-onboarding-bridge/ (신규 Rust crate — carbon-config-service, qr-code-setup 대체)
    ├── Cargo.toml
    ├── build.rs               ← tonic-build proto 컴파일
    ├── build.sh               ← GBS 빌드 + RPM 패키징
    ├── proto/
    │   └── carbon/
    │       └── v1/
    │           ├── config.proto
    │           └── setup.proto
    └── src/
        ├── main.rs            ← 소켓 바인드, tonic 서버 기동
        ├── config_service.rs  ← ConfigService gRPC 구현
        ├── setup_service.rs   ← SetupService gRPC + HTTP 서버
        └── config_io.rs       ← config.yaml 읽기/쓰기 (atomic rename)
```

### `Cargo.toml` 핵심 의존성

```toml
[dependencies]
tokio       = { version = "1", features = ["full"] }
tonic       = "0.12"
prost       = "0.13"
serde       = { version = "1", features = ["derive"] }
serde_yaml  = "0.9"
anyhow      = "1"

[build-dependencies]
tonic-build = "0.12"
```

---

## 6. 구현 상세

### 6-1. `config_io.rs` — config.yaml 읽기/쓰기

carbon-config-service의 C 구현과 동일한 파일 경로와 atomic rename 패턴을 사용한다.

```
CONFIG_PATH   = /opt/usr/home/owner/.carbon/config.yaml
CONFIG_TMP    = /opt/usr/home/owner/.carbon/config.yaml.tmp
CONFIG_BACKUP = /opt/usr/home/owner/.carbon/config.yaml.bak
```

쓰기 시퀀스 (carbon-config-service와 동일):
```
1. 기존 config.yaml → config.yaml.bak  (파일이 있을 때만)
2. 새 내용 → config.yaml.tmp
3. rename config.yaml.tmp → config.yaml  (atomic)
```

`ready` / `hint` 판단: carbon-0509의 `onboarding_hint()` 로직을 참고해 동일하게 구현한다. API key 필드가 하나라도 비어 있지 않으면 `ready = true`.

`restart_daemon()`: Rust에서 `std::process::Command::new("systemctl").args(["restart", "carbon-daemon"]).status()`로 호출한다. carbon-config-service의 `system("systemctl restart carbon-daemon")`과 동일한 방식이며, 브리지가 root 권한으로 실행되므로 가능하다. 종료 코드가 0이면 성공, 아니면 실패로 판단한다.

### 6-2. `config_service.rs` — ConfigService 구현

- `GetConfig`: `config.yaml` 읽기 → YAML 문자열 + `ready` / `hint` 반환. 파일 없으면 기본 템플릿 반환.
- `SetConfig`: 아래 시퀀스로 처리한다.
  1. YAML 수신 → `serde_yaml`로 파싱 검증 (형식 오류 시 즉시 에러 반환)
  2. `config_io::write()` — atomic rename으로 config.yaml 저장
  3. `restart_daemon()` — `systemctl restart carbon-daemon` 호출
  4. 응답 반환: `success=true`, `restart_success=<결과>`, `message="config saved and carbon-daemon restarted."` 또는 재시작 실패 시 `"config saved but carbon-daemon restart failed."`
  - carbon-daemon 통합 시에는 3번을 `systemctl restart` 대신 ArcSwap registry 교체로 대체한다.

### 6-3. `setup_service.rs` — SetupService + HTTP 서버

**내부 상태 공유 구조:**

gRPC 핸들러(`SetupServiceImpl`)와 HTTP accept loop(`tokio::spawn` 내부)가 상태를 공유하려면 `Arc`가 필요하다.

```rust
struct SetupState {
    handle: Option<tokio::task::JoinHandle<()>>,  // HTTP accept loop 핸들
    listener_abort: Option<tokio::sync::oneshot::Sender<()>>,  // 종료 신호
    url: Option<String>,                           // 현재 바인드된 URL
    last_event: Option<SetupEventKind>,            // 최신 이벤트 (WatchSetup timing 처리용)
    event_tx: tokio::sync::broadcast::Sender<SetupEvent>,
}

struct SetupServiceImpl {
    state: Arc<Mutex<SetupState>>,  // gRPC 핸들러 + HTTP 서버 간 공유
}
```

`tokio::spawn`으로 시작하는 HTTP accept loop에 `Arc<Mutex<SetupState>>`의 clone을 넘겨서 `POST /setup` 완료 시 `event_tx`로 broadcast한다.

**`StartSetup`:**
1. `state.lock()` → 이미 실행 중이면(`url.is_some()`) 기존 URL 반환 (중복 실행 방지)
2. `TcpListener` 바인드 (preferred_port부터 18200까지 순차 탐색, 모두 실패 시 에러)
3. LAN IP 탐색 (loopback / link-local 제외). 없으면 `127.0.0.1` 폴백
4. `state.url = Some(url.clone())`, `state.last_event = None`
5. `tokio::spawn`으로 HTTP accept loop 시작, `state` Arc clone 전달
6. URL 반환

**HTTP 서버 (`GET /setup`):**
- `config_io::read()` → YAML 파싱 → 노출 필드만 추출해 HTML 폼 생성
- 노출 필드: `providers.anthropic.api_key`, `providers.anthropic.oauth_token`, `providers.gemini.api_key`, `web_search.brave.api_key`, `defaults.provider`, `defaults.model`

**HTTP 서버 (`POST /setup`):**
1. form-urlencoded 파싱 → 변경 필드만 기존 config에 merge → `config_io::write()` 호출
2. `restart_daemon()` — `systemctl restart carbon-daemon` 호출
3. `state.lock()` → `state.last_event = Some(COMPLETED)` 기록
4. `state.event_tx.send(SetupEvent { kind: COMPLETED, url })` broadcast
5. 결과 HTML 응답 (적용된 필드 / 변경 없는 필드 / 재시작 성공 여부 표시)

**`StopSetup`:**
1. `state.lock()` → `listener_abort` 채널로 종료 신호 전송, `url = None`, `last_event = Some(STOPPED)` 기록
2. `event_tx.send(SetupEvent { kind: STOPPED })` broadcast

**`WatchSetup` — timing 문제 처리:**

`WatchSetup`을 구독하는 시점이 `StartSetup` 이후일 수 있고, 그 사이에 폰이 이미 설정을 완료(`COMPLETED`)했을 수 있다. `broadcast::Receiver`는 구독 이전 이벤트를 전달하지 않으므로 이벤트를 놓칠 수 있다.

해결: 구독 직후 `state.last_event`를 확인해 이미 발생한 이벤트가 있으면 즉시 스트림으로 전송한다.

```
WatchSetup 호출
  │
  ├─ broadcast::Receiver 구독
  ├─ state.lock() → last_event 확인
  │     이미 COMPLETED/STOPPED → 즉시 해당 이벤트 stream 전송 후 완료
  │     None → broadcast 대기 상태로 진입
  └─ 이후 이벤트를 stream으로 relay
```

### 6-4. `main.rs` — 서버 기동

```
1. 소켓 경로 결정 (CARBON_ONBOARDING_SOCK 환경변수 또는 기본값)
2. 기존 소켓 파일 제거 후 UnixListener 바인드
3. tonic::Server::builder()
     .add_service(ConfigServiceServer::new(...))
     .add_service(SetupServiceServer::new(...))
     .serve_with_incoming(uds_stream)
     .await
```

---

## 7. chat-ui 연동

### 7-1. proto stub 생성

`proto/carbon/v1/config.proto` / `setup.proto`를 `protoc`로 컴파일해 Dart 파일 생성 후 `lib/generated/carbon/v1/`에 추가한다.

### 7-2. gRPC 클라이언트 추가

현재 `CarbonGrpcService`가 `AgentServiceClient`를 단일 Unix socket으로 연결한다. `ConfigServiceClient` / `SetupServiceClient`를 별도 소켓으로 추가한다.

```dart
// 기존 (AgentService)
const _carbonSock = '/run/user/5001/carbon/carbon.sock';

// 추가 (브리지 단계 — ConfigService / SetupService)
const _onboardingSock = '/run/user/5001/carbon/onboarding.sock';
```

### 7-3. 온보딩 flow

chat-ui는 Tizen 앱 샌드박스 안에서 실행되므로 `config.yaml`에 직접 접근할 수 없다. 모든 config 상태 확인과 변경은 브리지 gRPC를 통해 위임한다.

**앱 초기 진입 시:**
```
GetConfig RPC 호출
  │
  ├─ ready: false → 온보딩 화면 자동 진입 (hint 메시지 표시)
  └─ ready: true  → 일반 채팅 화면 진입
```
`ready: true`인 상태에서도 채팅 화면에 설정 진입점(버튼 등)을 두어 언제든 온보딩 화면을 수동으로 열 수 있어야 한다.

**온보딩 화면 진입 시:**
```
StartSetup RPC 호출 → url 수신
  │
  └─ WatchSetup streaming 구독 시작
       │
       ├─ (구독 직후) last_event 확인 → 이미 COMPLETED이면 즉시 처리
       └─ COMPLETED 이벤트 수신
             │
             ├─ StopSetup RPC 호출
             ├─ QR 화면 종료
             └─ GetConfig 재호출 → ready 상태 갱신 후 화면 분기
```

**사용자가 설정 완료 없이 수동으로 화면을 닫거나 앱이 종료될 때:**
```
StopSetup RPC 호출 → HTTP 서버 종료
```

### 7-4. QR 코드 표시

- Flutter QR 라이브러리 추가 (예: `qr_flutter`) — 현재 53바이트 제한 제거
- `StartSetup`이 반환한 URL을 QR 코드 위젯으로 렌더링
- URL이 `127.0.0.1`을 포함하면 "LAN IP를 찾지 못했습니다. TV 네트워크를 확인하세요." 경고 표시

### 7-5. AppControl 인터페이스

Tizen Flutter 플러그인으로 AppControl 수신 처리.

| `method` | 처리 |
|----------|------|
| `ShowSetupQr` | 온보딩 화면 진입 + `StartSetup` 호출, 응답 URL을 AppControl reply로 반환 |
| `HideSetupQr` | `StopSetup` 호출 + 화면 종료 |
| `GetStatus` | 현재 상태(`visible`, `url`) JSON으로 AppControl reply 반환 |

### 7-6. migration 시 chat-ui 변경 범위

carbon-daemon에 ConfigService / SetupService가 통합되면:

```dart
// 변경 전 (브리지)
const _onboardingSock = '/run/user/5001/carbon/onboarding.sock';

// 변경 후 (carbon-daemon 통합)
const _onboardingSock = '/run/user/5001/carbon/carbon.sock';
```

상수 하나 변경이 전부다. proto 인터페이스, 클라이언트 코드, 화면 로직은 변경 없음.

---

## 8. 배포

브리지는 systemd 서비스로 설치한다. 기존 `carbon-config-service`와 `qr-code-setup`은 브리지로 완전히 대체되므로 제거한다.

```
[Unit]
Description=Carbon Onboarding Bridge
After=network.target

[Service]
ExecStart=/usr/bin/carbon-onboarding-bridge
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
```

`launch.sh` (신규):
```bash
#!/bin/sh
set -e

# 기존 서비스 제거
systemctl stop carbon-config-service 2>/dev/null || true
rpm -e carbon-config-service 2>/dev/null || true

# 기존 앱 제거 (qr-code-setup)
pkgcmd -u -n org.tizen.qr-code-setup 2>/dev/null || true
rpm -e org.tizen.qr-code-setup 2>/dev/null || true

# 브리지 설치 및 기동
rpm -Uvh carbon-onboarding-bridge-*.armv7l.rpm
systemctl daemon-reload
systemctl restart carbon-onboarding-bridge   # onboarding.sock OPEN
```

---

## 9. migration 체크리스트

| 단계 | 작업 | 담당 |
|------|------|------|
| 브리지 배포 | `carbon-onboarding-bridge` 설치, `carbon-config-service` / `qr-code-setup` 제거 | onboarding |
| 브리지 배포 | chat-ui `ConfigServiceClient` / `SetupServiceClient` → `onboarding.sock` 연결 추가 | chat-ui |
| carbon-daemon 통합 | `config.proto` / `setup.proto` carbon-proto로 이전, `ConfigService` / `SetupService` daemon에 구현 | carbon |
| carbon-daemon 통합 | `SetConfig` 내 `systemctl restart` → ArcSwap registry 교체로 대체 | carbon |
| chat-ui 전환 | `_onboardingSock` → `_carbonSock` 상수 변경 (한 줄) | chat-ui |
| 정리 | `carbon-onboarding-bridge` systemd unit 제거 | onboarding |

---

## 10. 제약사항

- 브리지는 Tizen 환경에서 root 권한으로 실행해야 `config.yaml` 경로에 쓰고 `systemctl restart`를 호출할 수 있다. carbon-config-service와 동일한 이유이며, systemd unit에 별도 권한 설정 없이 root로 실행하면 된다.
- `systemctl restart carbon-daemon` 후 daemon이 재기동되는 동안 기존 gRPC 연결(`carbon.sock`)이 끊어진다. chat-ui는 AgentService 재연결 로직을 이미 가지고 있으므로 (`_doConnect` 재시도) 별도 처리 불필요.
- hot-reload (ArcSwap registry 교체)는 carbon-daemon 통합 단계에서 구현한다. 브리지 단계에서는 `systemctl restart`가 그 역할을 대신한다.
