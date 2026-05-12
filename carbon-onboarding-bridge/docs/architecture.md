# Carbon Onboarding 아키텍처

## 전체 구조 요약

```
┌──────────────────────────────────────────────────────────────────┐
│ 폰 브라우저 (같은 Wi-Fi)                                          │
└────────────────────────┬─────────────────────────────────────────┘
                         │ HTTP GET/POST  (LAN IP:18181/setup)
                         ▼
┌──────────────────────────────────────────────────────────────────┐
│ qr-code-setup  (Tizen .NET NUI 앱)                               │
│                                                                  │
│  SetupHttpServer ──► SetupQrView (TV 화면에 QR 오버레이)          │
│       │                                                          │
│  CarbonSetupService                                              │
└────────────────────────┬─────────────────────────────────────────┘
                         │ HTTP GET/POST  (127.0.0.1:18182)
                         ▼
┌──────────────────────────────────────────────────────────────────┐
│ carbon-config-service  (C systemd 서비스)                         │
└────────────────────────┬─────────────────────────────────────────┘
                         │ 파일 read/write
                         ▼
        /opt/usr/home/owner/.carbon/config.yaml
                         │ systemctl restart
                         ▼
                   carbon-daemon
```

---

## 1. carbon-config-service

### 역할

Carbon 설정 파일을 읽고 쓰는 **특권 로컬 HTTP 헬퍼 서비스**다. 직접 `config.yaml`에 접근하고 `carbon-daemon`을 재시작하는 권한이 필요하기 때문에 systemd 서비스로 분리되어 있다. qr-code-setup 앱은 이 서비스를 경유해서만 설정을 변경한다.

### 구현

- 언어: C (단일 파일 `src/main.c`, 외부 의존성 없음)
- 바이너리: `/usr/bin/carbon-config-service`
- 동작 방식: 단일 스레드, 요청당 순차 처리 (accept → handle → close 반복)

### 포트 및 가용 시점

| 항목 | 값 |
|------|-----|
| 주소 | `127.0.0.1:18182` (루프백만, 외부 노출 없음) |
| 시작 시점 | **디바이스 부팅 시** systemd가 자동 시작 |
| 종료 시점 | 수동 종료 또는 시스템 종료 |
| 재시작 정책 | `Restart=always`, `RestartSec=3` (충돌 시 자동 재시작) |
| systemd unit | `multi-user.target.wants/carbon-config-service.service` |

즉, **이 포트는 디바이스가 켜진 후부터 항상 열려 있다.** qr-code-setup 앱의 동작 여부와 무관하다.

### API

```
GET  /health        → 200 "ok\n"
GET  /config        → 200 (config.yaml 전체 내용) | 404 (파일 없을 때)
POST /config        → body: YAML 전문 → 저장 + carbon-daemon restart
```

### config.yaml 쓰기 시퀀스

```
1. config.yaml → config.yaml.bak  (기존 파일이 있을 때만)
2. body → config.yaml.tmp
3. rename config.yaml.tmp → config.yaml  (atomic)
4. system("systemctl restart carbon-daemon")
```

원자적 rename으로 중간 실패 시 파일이 손상되지 않는다. `.bak`은 롤백용이 아니라 디버그용이다.

---

## 2. qr-code-setup

### 역할

두 가지 역할을 동시에 수행한다.

1. **TV 화면에 QR 코드 오버레이 표시** — 폰 사용자가 스캔할 수 있도록
2. **모바일 설정 페이지 호스팅** — 폰 브라우저가 접속하면 Carbon 설정 폼을 서빙하고, 제출된 값을 carbon-config-service에 전달

### 구현

- 언어: C# / Tizen .NET NUI (`net8.0-tizen10.0`, `api-version="10.0"`)
- 앱 ID: `org.tizen.qr-code-setup`
- 앱 타입: `dotnet-nui` (NUI UIApplication 기반)
- Tizen 권한: `internet`, `network.get`

### 포트 및 가용 시점

| 항목 | 값 |
|------|-----|
| 주소 | `{LAN_IP}:18181` (모든 인터페이스에서 바인드, 폴백 시 루프백) |
| 시작 시점 | **`ShowSetupQr` AppControl을 받는 순간** |
| 종료 시점 | **`HideSetupQr` AppControl을 받거나 앱이 종료될 때** |
| 포트 충돌 시 | 18181~18200 범위에서 순차 탐색하여 사용 가능한 포트 자동 선택 |

즉, **앱이 설치되어 있어도 `ShowSetupQr`를 받기 전에는 18181 포트가 열리지 않는다.**

### 내부 클래스 구조

```
App  (UIApplication 진입점)
├── AppControlHandler        ← app_launcher로 오는 외부 제어 처리
│   └── SetupQrManager       ← QR 오버레이 윈도우 + HTTP 서버 생명주기 관리
│       ├── SetupQrView      ← TV 화면에 렌더링되는 QR 코드 UI
│       │   └── QrCode       ← 순수 C# QR 인코더 (Version 3, 최대 53 UTF-8 바이트)
│       └── SetupHttpServer  ← 폰이 접속하는 HTTP 서버
│           └── CarbonSetupService ← carbon-config-service와 통신
└── StateWriter              ← 인메모리 상태 (visible / serverRunning / url)
```

### QR 코드 생성

외부 라이브러리 없이 순수 C#으로 구현된 QR 인코더(`QrCode.cs`)가 URL을 인코딩한다.

- Version 3 (29×29), 최대 53 UTF-8 바이트 고정
- `SetupQrView`가 각 모듈을 `View` 오브젝트로 렌더링

URL이 53바이트를 초과하면 `ArgumentException`이 발생한다. LAN IP가 없으면 `127.0.0.1`로 폴백하고 UI에 경고 텍스트("No LAN IP was found")를 표시한다.

### 투명 오버레이 윈도우

앱은 평소에 화면 밖(`y = screenHeight + 10`)에 위치한 투명 창을 유지한다. `ShowSetupQr`를 받으면 창을 `(0, 0)`으로 이동하고 350ms fade-in 애니메이션을 재생한다. `HideSetupQr`에서는 250ms fade-out 후 다시 화면 밖으로 이동한다. 윈도우는 항상 최상위(`IsAlwaysOnTop = true`)로 설정되어 있다.

---

## 3. 통신 흐름

### 3-1. 앱 제어: AppControl (launcher → qr-code-setup)

외부 프로세스가 `app_launcher` CLI를 통해 앱에 명령을 보낸다. Tizen AppControl 메커니즘을 사용하며, `method` extra-data 키로 동작을 구분한다.

```
app_launcher -s org.tizen.qr-code-setup method ShowSetupQr
                                           ↓
                                   AppControlHandler.Handle()
                                           ↓
                           switch(method) {
                             "ShowSetupQr" → SetupQrManager.Show()
                                             → SetupHttpServer.Start()
                                             → QR 오버레이 표시
                                             → AppControlReply (url 반환)

                             "HideSetupQr" → SetupQrManager.Hide()
                                             → SetupHttpServer.Dispose()
                                             → 오버레이 fade-out

                             "GetStatus"   → StateWriter.GetStatusJson()
                                             → AppControlReply (JSON 반환)
                           }
```

`AppControlReply`는 native P/Invoke(`libcapi-appfw-app-control.so.0`)로 구현되어 있다. 동기적 응답이므로 launcher 쪽에서 결과를 바로 읽을 수 있다.

#### AppControl 파라미터 정리

| method | 입력 extra-data | 출력 extra-data |
|--------|----------------|----------------|
| `ShowSetupQr` | `url` (optional, 직접 URL 지정 시 서버 미시작), `port` (기본 18181), `title`, `description` | `url` (QR에 인코딩된 URL) |
| `HideSetupQr` | — | — |
| `GetStatus` | — | `status` (JSON: `{visible, serverRunning, url}`) |

`url`을 명시적으로 전달하면 SetupHttpServer를 시작하지 않고 해당 URL의 QR 코드만 표시한다 (외부 서버를 가리킬 때 사용).

### 3-2. 폰 접속: SetupHttpServer (폰 브라우저 → qr-code-setup)

폰이 QR 코드를 스캔하면 `http://{LAN_IP}:18181/setup`으로 접속한다.

```
GET  /setup  → BuildSetupPage()
                  ↓
               CarbonSetupService.GetEditableConfig()
                  ↓
               GET http://127.0.0.1:18182/config  (현재 config.yaml 로드)
                  ↓
               config 값이 채워진 HTML 폼 반환

POST /setup  → ParseFormUrlEncoded(body)
                  ↓
               CarbonSetupService.Apply(fields)
                  ↓
               GET http://127.0.0.1:18182/config  (현재 config 로드)
               변경된 필드만 덮어씀
               YAML 직렬화
                  ↓
               POST http://127.0.0.1:18182/config  (저장 + restart)
                  ↓
               결과 HTML 반환 (applied fields / skipped fields 표시)
```

SetupHttpServer는 비동기 `TcpListener` 기반이며 요청마다 별도 Task로 처리한다.

### 3-3. 설정 저장: CarbonSetupService → carbon-config-service

`CarbonSetupService`는 `HttpClient`를 사용해 loopback으로 carbon-config-service에 요청을 보낸다.

- `GET /config`: 현재 YAML 로드 → `YamlDotNet`으로 파싱 → `CarbonSetupConfig` 모델로 변환
- `POST /config`: 변경사항을 적용한 모델을 다시 YAML로 직렬화 → body로 전송

필드 비교는 문자열 단위 (`Ordinal`)로 수행되며, 값이 변경된 필드만 `appliedFields`에 기록되고 동일한 값은 `skippedFields`에 기록된다. 변경된 필드가 없으면 POST 자체를 보내지 않는다.

---

## 4. 디바이스 위에서의 전체 실행 흐름

### 4-1. 초기 설치 (`launch.sh`)

```
launch.sh (root 실행)
  ├── rpm -Uvh carbon-config-service-*.armv7l.rpm
  ├── systemctl daemon-reload
  ├── systemctl restart carbon-config-service   ← 18182 포트 OPEN
  ├── rpm -Uvh org.tizen.qr-code-setup-*.armv7l.rpm
  ├── pkgcmd -i -t tpk -p /usr/apps/.preload-rw-tpk/org.tizen.qr-code-setup-1.0.0.tpk
  └── app_launcher -s org.tizen.qr-code-setup method ShowSetupQr
```

### 4-2. 앱 기동 후 상태

```
[항상 실행 중]
  carbon-config-service  → 127.0.0.1:18182  LISTEN

[ShowSetupQr 수신 후]
  qr-code-setup 앱       → 0.0.0.0:18181   LISTEN
  TV 화면                 → QR 코드 오버레이 표시
```

### 4-3. 폰 설정 세션

```
폰이 QR 스캔
  → http://{LAN_IP}:18181/setup GET
    → CarbonSetupService가 현재 config.yaml 로드 (via :18182)
    → 설정 폼 HTML 응답

폰에서 값 입력 후 "Save Config And Restart Carbon" 클릭
  → POST /setup
    → 변경된 필드 계산
    → POST http://127.0.0.1:18182/config (YAML 전문)
      → carbon-config-service가 config.yaml 저장
      → systemctl restart carbon-daemon
    → 결과 페이지 응답 (applied / skipped 필드 목록)
```

### 4-4. 부팅 후 재기동

systemd unit이 `multi-user.target.wants`에 심볼릭 링크되어 있어 부팅 시 `carbon-config-service`가 자동 시작된다. `qr-code-setup` 앱은 자동 시작되지 않으며, 외부에서 `ShowSetupQr` AppControl을 다시 보내야 활성화된다.

---

## 5. 포트 가용 시점 요약

| 포트 | 프로세스 | 바인드 주소 | 열리는 시점 | 닫히는 시점 |
|------|---------|------------|------------|------------|
| **18182** | `carbon-config-service` | `127.0.0.1` | 디바이스 부팅 (systemd) | 시스템 종료 |
| **18181** | `qr-code-setup` (SetupHttpServer) | `0.0.0.0` | `ShowSetupQr` AppControl 수신 | `HideSetupQr` 수신 또는 앱 종료 |

18182는 루프백 전용이라 네트워크 외부에서 직접 접근할 수 없다. 18181은 모든 인터페이스에 바인드되므로 같은 LAN의 폰이 접근할 수 있다.

---

## 6. 설계상 주요 결정

### carbon-config-service를 별도 프로세스로 분리한 이유

`config.yaml`을 쓰고 `systemctl restart`를 실행하려면 root 권한이 필요하다. Tizen .NET 앱은 일반 사용자 권한으로 실행되므로 직접 파일에 접근할 수 없다. 권한이 있는 C systemd 서비스를 로컬 HTTP 브리지로 사용하는 방식으로 이 제약을 우회한다.

### SetupHttpServer를 앱 안에 내장한 이유

폰 브라우저와 TV 앱이 단일 패키지로 작동하게 하기 위해서다. 별도 웹 서버를 설치하지 않아도 된다. 설정 UI가 앱 코드 내에서 관리되므로 설정 가능한 필드와 UI가 항상 동기화된다.

### QR 인코더를 직접 구현한 이유

Tizen .NET 환경에서 사용 가능한 외부 QR 라이브러리가 제한적이어서, URL 인코딩에 필요한 최소 기능(Version 3, byte mode)만을 순수 C#으로 구현했다. 53바이트 제한은 이 PoC 단계에서의 상한이며, URL 길이를 초과하면 예외가 발생한다.
