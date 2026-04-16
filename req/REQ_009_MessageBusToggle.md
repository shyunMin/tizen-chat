# [REQ_009] _startHttpMessageBus Refactoring (Toggle Option)

## 1. 개요
현재 `TizenChatHomeScreen`에서 앱 시작 시 무조건 실행되는 `_startHttpMessageBus` 기능을, 초기화 옵션을 통해 켜고 끌 수 있도록 리팩토링합니다. 이는 디버깅이나 특정 환경에서의 불필요한 서버 실행을 방지하기 위함입니다.

## 2. 분석 및 설계
### 2.1 대상 객체 및 관계
- `TizenChatHomeScreen`: 초기화 시 `HttpMessageBus` 시작 여부를 결정하는 주체입니다.
- `main.dart`: `TizenChatHomeScreen`을 생성할 때 설정을 전달하는 진입점입니다.

### 2.2 수정 사항
1. **`TizenChatHomeScreen`**:
   - 생성자에 `bool enableHttpMessageBus` 파라미터를 추가합니다. (기본값: true)
   - `initState`에서 해당 플래그를 확인하여 `_startHttpMessageBus()` 호출 여부를 결정합니다.
2. **`main.dart`**:
   - `runApp` 단계에서 `TizenChatApp` 및 `TizenChatHomeScreen`으로 설정을 전달할 수 있도록 구조를 확장합니다.
   - 환경 변수(Environment Variable)를 통해 실행 시점에 동적으로 결정할 수 있는 옵션도 고려합니다.

---

## 3. 구현 가이드 (Step-by-Step)

### Step 1: TizenChatHomeScreen 생성자 및 로직 수정
- `lib/screens/tizen_chat_home_screen.dart` 파일 수정
- `TizenChatHomeScreen` 클래스에 `final bool enableHttpMessageBus` 필드 추가.
- `initState`에서 `if (widget.enableHttpMessageBus) { _startHttpMessageBus(); }` 적용.

### Step 2: main.dart에서 옵션 전달
- `lib/main.dart` 수정.
- 환경 변수 `String.fromEnvironment('ENABLE_HTTP_BUS', defaultValue: 'true') == 'true'` 형태의 로직을 추가하여 옵션 결정 가능하게 함.
- `TizenChatHomeScreen(enableHttpMessageBus: ...)` 호출.

---

## 4. 구현용 프롬프트 (Implementation Prompt)

```markdown
다음 요구사항을 바탕으로 코드를 수정해줘:

1. `lib/screens/tizen_chat_home_screen.dart`:
   - `TizenChatHomeScreen` 클래스 생성자에 `bool enableHttpMessageBus = true` 파라미터를 추가한다.
   - `_TizenChatHomeScreenState.initState`에서 `widget.enableHttpMessageBus`가 `true`일 때만 `_startHttpMessageBus()`가 실행되도록 수정한다.

2. `lib/main.dart`:
   - `bool enableHttpBus = const bool.fromEnvironment('ENABLE_HTTP_BUS', defaultValue: true);` 로직을 추가하여 실행 시 옵션을 결정할 수 있게 한다.
   - `TizenChatHomeScreen`에 위 플래그를 전달한다.
   - `TizenChatApp` 클래스에도 필요한 경우 파라미터를 전달하도록 구조를 수정한다.
```
