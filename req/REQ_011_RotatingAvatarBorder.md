# [REQ_011] RotatingAvatarBorder: Progress Animation for T Icon

## 1. 개요
에이전트가 응답을 생성하는 동안(Waiting 상태) `TypingIndicator` 내의 'T' 아이콘(Avatar) 테두리에 회전하는 프로그레스 애니메이션을 추가하여 진행 상태를 시각적으로 강조합니다.

## 2. 분석 및 설계
### 2.1 대상 객체
- `lib/widgets/typing_indicator.dart`: 'T' 아바타와 타이핑 도트를 포함하는 위젯입니다.

### 2.2 수정 사항
- `CircleAvatar`를 `Stack`으로 감쌉니다.
- 아바타 외곽에 `CircularProgressIndicator` 또는 커스텀 회전 애니메이션을 추가합니다.
- Tizen 디자인 가이드라인에 맞춰 `cyan400` 색상과 미세한 글로우 효과를 적용합니다.

## 3. 구현 단계
1. `TypingIndicator` 위젯의 `build` 메서드 내 아바타 생성 로직을 수정합니다.
2. `Stack`을 사용하여 아바타 뒤쪽이나 테두리에 회전하는 요소를 배치합니다.
3. 아바타 사이즈(radius 16) 보다 약간 큰 영역(예: 36x36)을 프로그레스 영역으로 잡습니다.

## 4. 구현용 프롬프트
```markdown
`lib/widgets/typing_indicator.dart` 파일을 수정하여 다음 기능을 추가해줘:

1. `widget.showAvatar`가 `true`일 때 생성되는 `CircleAvatar`를 `Stack`으로 감싼다.
2. 아바타 테두리를 따라 회전하는 `CircularProgressIndicator`를 추가한다.
3. 프로그레스 바의 `strokeWidth`는 2 정도로 얇게 설정하고, 색상은 `TizenStyles.cyan400`을 사용한다.
4. 아바타와 프로그레스 바가 중심이 잘 맞도록 `alignment: Alignment.center`와 `SizedBox`를 활용한다.
```
