# [REQ_001] PromptBarMode

## 1. 분석 및 가정 사항
*   **요청 목표**: `PromptBar` 위젯에 음성 모드와 키보드 모드를 구분하여 제공하고, 상황에 맞게 UI와 상태를 전환한다.
*   **파일 위치**: `lib/widgets/prompt_bar.dart`
*   **가정 사항**:
    *   음성 모드에서 마이크 아이콘은 단순 장식용 인디케이터로 가정하며, 별도의 버튼/포커스를 가지지 않는다. (실제 음성 입력은 리모컨의 하드웨어 마이크 버튼 등을 통해 처리됨)
    *   음성 모드에서 PromptBar가 외부 포커스(`_outerFocusNode`)를 받았을 때 Enter(Select) 키를 누르면, 입력할 수 있는 텍스트 필드가 없으므로 우측의 **키보드 버튼**으로 바로 포커스를 이동시킨다.
    *   메시지 전송(`onSend` 발생) 시 자동으로 키보드 모드에서 음성 모드로 복귀한다.

## 2. 설계 및 구현 계획

### 2.1 상태 추가 (State)
*   `_PromptBarState` 내에 모드를 관리하는 상태 변수 추가.
    *   `bool _isKeyboardMode = false;` (기본값: false, 즉 음성 모드)
*   우측 버튼용 포커스 노드는 기존 `_sendFocusNode`를 공용으로 재사용하여 애니메이션과 효과를 유지한다.

### 2.2 UI 레이아웃 분기
*   현재 `AnimatedOpacity` 내의 `Row` 및 `Stack` 안의 아이콘 자식들을 `_isKeyboardMode` 값에 따라 조건부 렌더링.

**[음성 모드 (`_isKeyboardMode == false`)]**
*   **좌측 아이콘**: `Icon(Icons.mic, color: Colors.white, size: 24)` (또는 유사한 마이크 아이콘)
*   **중앙 텍스트**: `Text("마이크를 눌러 음성으로 시작하세요", style: TextStyle(color: Colors.white70, fontSize: 18))`
*   **우측 버튼**: `_FocusableActionIcon(icon: Icons.keyboard, ...)`

**[키보드 모드 (`_isKeyboardMode == true`)]**
*   **좌측 아이콘**: `Image.asset('assets/images/bixby.png', ...)` (기존 로직)
*   **중앙 텍스트**: 기존 `TextField` 사용 (`_textController`, `_inputFocusNode` 등 동일 적용).
*   **우측 버튼**: 기존 로직과 동일한 전송/중지 버튼.

### 2.3 포커스 및 모드 전환 이벤트
*   **음성 -> 키보드 전환**:
    *   음성 모드에서 우측 '키보드 버튼' 탭/Enter 시 `setState(() => _isKeyboardMode = true);` 호출.
    *   전환 직후 자동으로 `_inputFocusNode.requestFocus();` 를 호출하여 텍스트 필드로 포커스 이동.
*   **키보드 -> 음성 전환**:
    *   `TextField`나 우측 `전송 버튼`을 통해 `widget.onSend`가 호출된 직후 `setState(() => _isKeyboardMode = false);` 처리.
    *   `_reset()` 메서드 호출 시 `_isKeyboardMode = false;` 로 함께 초기화.
*   **음성 모드에서의 키보드 네비게이션 (`onKeyEvent`)**:
    *   `_outerFocusNode` (바 전체)에서 Enter 시:
        *   키보드 모드면 기존처럼 `_inputFocusNode.requestFocus()`.
        *   음성 모드면 `_sendFocusNode.requestFocus()` (키보드 아이콘 버튼으로 이동).
    *   우측 버튼(`_sendFocusNode`)에서 Left 시:
        *   키보드 모드면 기존처럼 `_inputFocusNode.requestFocus()`.
        *   음성 모드면 `_outerFocusNode.requestFocus()`.

## 3. 구현용 프롬프트 (개발자 지시사항)
```text
`lib/widgets/prompt_bar.dart` 파일을 수정하여 음성 모드와 키보드 모드를 구현하세요.

1. 상태 추가: `_PromptBarState`에 `bool _isKeyboardMode = false;` 추가. `_reset()` 메서드에서 `_isKeyboardMode = false;`로 초기화.
2. 좌측 아이콘 분기: `AnimatedPositioned` 안의 좌측 이미지를 `_isKeyboardMode`에 따라 `Icon(Icons.mic, color: Colors.white, size: 24)` 또는 `Image.asset('assets/images/bixby.png')`로 렌더링.
3. 중앙 영역 분기: `Row` 내부의 `Expanded` 자식을 `_isKeyboardMode`에 따라 분기.
   - 키보드 모드: 기존 `TextField` 사용.
   - 음성 모드: `Text("마이크를 눌러 음성으로 시작하세요", style: TextStyle(color: Colors.white70, fontSize: 18))` 표시 (세로 중앙 정렬 맞출 것).
4. 우측 버튼 분기: `_FocusableActionIcon`의 `icon`과 `onTap`, `onArrowLeft` 콜백을 모드에 따라 분기.
   - 음성 모드: `icon: Icons.keyboard`. `onTap` 시 `setState(() => _isKeyboardMode = true)` 후 `_inputFocusNode.requestFocus()`. `onArrowLeft` 시 `_outerFocusNode.requestFocus()`.
   - 키보드 모드: 기존처럼 전송/중지 아이콘 및 로직 유지. 단, 전송(`onSend`) 직후 `_isKeyboardMode = false`로 변경.
5. 텍스트 필드(`TextField`)의 `onSubmitted`에서도 전송 후 `_isKeyboardMode = false`로 변경.
6. 외부 포커스 분기: `Focus(focusNode: _outerFocusNode)`의 `onKeyEvent`에서 Enter 키를 누를 때, `_isKeyboardMode`가 `false`면 `_sendFocusNode.requestFocus()`를, `true`면 기존처럼 `_inputFocusNode.requestFocus()`를 호출.
```
