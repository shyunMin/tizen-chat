# [REQ_010] ChatBusFix: Maintain HTTP Message Bus in Chat Screen

## 1. 개요
`TizenChatHomeScreen`에서 `TizenChatScreen`으로 화면 전환 시, `pushReplacement`로 인해 기존 화면이 `dispose`되면서 `HttpMessageBus` 서버가 중단되는 문제를 해결합니다.

## 2. 분석 및 설계
### 2.1 문제 원인
- `TizenChatHomeScreen.dispose()`에서 `HttpMessageBus.instance.release()`를 호출함.
- `TizenChatScreen`으로 전환될 때 `pushReplacement`를 사용하므로 홈 화면이 즉시 제거됨.
- `TizenChatScreen`은 버스를 `acquire()`하지 않아 참조 카운트가 0이 되고 서버가 닫힘.

### 2.2 해결 방안
- `TizenChatScreen`에서도 `initState` 시점에 `HttpMessageBus.instance.acquire()`를 호출하여 참조 카운트를 유지함.
- `TizenChatScreen`이 `HttpMessageBus.instance.stream`을 직접 구독하여 외부 메시지를 수신하도록 함.
- `TizenChatScreen.dispose()`에서 `release()`를 호출하여 적절히 자원을 해제함.

## 3. 구현 단계
1. `lib/screens/chat_screen.dart`에 `http_message_bus.dart` 임포트 추가.
2. `_TizenChatScreenState`에 `HttpMessageBus` 초기화 및 구독 로직 추가.
3. `dispose` 메서드에서 `release()` 호출 추가.

## 4. 구현용 프롬프트
```markdown
`lib/screens/chat_screen.dart` 파일을 수정하여 다음 기능을 추가해줘:

1. `import '../features/http_message_overlay/http_message_bus.dart';`를 추가한다.
2. `_TizenChatScreenState.initState`에서 `HttpMessageBus.instance.acquire()`를 비동기로 호출한다.
3. `HttpMessageBus.instance.stream`을 구독하여 메시지 수신 시 `_handleUserMessage(msg)`가 실행되도록 한다. (기존 `widget.externalMessageStream` 구독은 유지하거나 대체한다.)
4. `_TizenChatScreenState.dispose`에서 `HttpMessageBus.instance.release()`를 호출하여 참조 카운트를 감소시킨다.
```
