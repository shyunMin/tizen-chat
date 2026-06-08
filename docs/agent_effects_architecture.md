# Agent Effects Architecture

본 문서는 Tizen Chat UI의 에이전트 화면(Agent Window)에 적용되는 시각적 효과(Effects) 클래스들의 구조와 역할을 정의합니다. 이후 이펙트를 수정하거나 새로운 효과를 추가할 때 이 문서를 기준으로 진행합니다.

## 핵심 구조 (Orchestrator & Layers)

모든 이펙트는 `lib/widgets/agent_effects.dart` 파일 내에 물리적/시각적 특성별로 분리되어 있으며, 가장 바깥의 컨테이너를 기준으로 겹겹이 쌓이는(Layered) 구조를 가집니다.

### 1. `AgentBackgroundEffects` (Orchestrator)
이펙트들의 상태(Phase)를 관리하고 조율하는 최상위 부모 위젯입니다. 
- **역할:** Chat 상태(`AppState.isPrompting`, `AppState.isGenerating` 등)를 수신하여, 이펙트의 4가지 내부 페이즈(`idle`, `busy`, `slowing`, `cont`) 중 하나로 변환합니다.
- **특징:** 각 이펙트 위젯(OuterGlow, Bloom, BorderStroke)에게 현재 페이즈를 전달하고, 상태 전환 시 자연스러운 애니메이션 타이밍(`_startCompletionSequence`)을 제어합니다.

---

## 개별 이펙트 클래스 (Effect Components)

시각적 역할에 따라 3개의 주요 컴포넌트로 완전히 분리되어 독립적인 애니메이션 컨트롤러와 Painter를 가집니다.

### 2. `AgentOuterGlow` (Base Ambient Aura)
대기(`idle`) 및 진행(`busy`) 상태에서 화면 밖으로 넓고 은은하게 퍼지는 기본 배경 빛 번짐(Glow)을 담당합니다.
- **페이즈별 동작:**
  - `idle`: 옅은 파란색/보라색이 아주 천천히 숨쉬듯(opacity 맥동) 넓게 퍼집니다.
  - `busy`: `idle`과 동일한 색상이지만, 약간 더 또렷하고 빠른 속도로 맥동합니다.
  - `slowing`, `cont`: 서서히 투명해지며 사라집니다 (Bloom 효과에게 자리를 양보).
- **렌더링 특징:** 2개의 `MaskFilter.blur(BlurStyle.outer)` 레이어(반경 3.3, 6.6)를 겹쳐서 자연스러운 빛의 산란을 표현합니다.

### 3. `AgentBloom` (Completion Burst Aura)
요청 처리가 완료(`cont`)되었을 때 뿜어져 나오는 강렬하고 밀도 높은 오로라(무지개 그라데이션) 빛 효과를 담당합니다.
- **페이즈별 동작:**
  - `idle`, `busy`: 나타나지 않습니다 (숨김 처리).
  - `slowing`: 진행이 완료되는 순간 나타나기 시작하며, 강렬한 그라데이션 빛이 테두리 밖으로 확산됩니다.
  - `cont`: 완전한 오로라 그라데이션이 숨쉬듯 맥동하며, 가장자리에는 1.0px 두께의 선명한 정적 무지개 테두리(Sharp border)가 고정됩니다.
- **렌더링 특징:** 서로 반대 방향으로 회전하는 2개의 SweepGradient 블러 레이어를 통해 신비로운 빛의 중첩을 만들며, 시각적 일관성을 위해 BorderStroke의 완료 상태 역할을 이어받습니다.

### 4. `AgentBorderStroke` (Dynamic Edge Border)
컨테이너 가장자리를 따라 도는 날카로운 선(Stroke) 및 꼬리별(Comet) 애니메이션을 전담합니다.
- **페이즈별 동작:**
  - `idle`: 희미한 그라데이션 선이 테두리를 따라 천천히 회전합니다.
  - `busy`: 형광 시안(Cyan)과 퍼플(Purple) 색상의 선(두께 1.6px)이 꼬리별처럼 빠르게 테두리를 돕니다. 양 끝(머리와 꼬리)이 부드럽게 페이드아웃 됩니다.
  - `slowing` (Handoff Transition): 꼬리별이 아주 빠른 속도로 화면을 한 바퀴 돌면서 선이 길어지고, 두께가 1.0px로 얇아지며, 색상도 Bloom의 무지개색으로 크로스페이드 됩니다. 
  - `cont`: 화면에서 사라집니다 (대신 `AgentBloom`의 정적 무지개 테두리가 나타나 자리를 대체함).
- **렌더링 특징:** Path 측정(`PathMetric`)과 `extractPath`를 사용하여 테두리의 정확한 길이와 둥글기(Radius)를 따라 선의 길이, 위치, 굵기를 동적으로 조작합니다.

---

## 향후 확장 및 유지보수 가이드

* **새로운 시각 효과를 추가할 때:** 기존의 클래스를 무리하게 수정하지 말고, 빛 번짐인지(Blur), 테두리 선인지(Stroke) 역할에 따라 `AgentOuterGlow`나 `AgentBorderStroke`에 로직을 추가하거나, 완전히 다른 텍스처라면 제 4의 이펙트 위젯을 `AgentBackgroundEffects`의 `Stack` 내에 추가하세요.
* **성능 튜닝 (Performance):** 모든 Painter는 `shouldRepaint`를 통해 필요한 순간에만 렌더링되도록 최적화되어 있습니다. 애니메이션 프레임 드랍이 발생할 경우, 각 Painter의 복잡도(예: `BorderStroke`의 step 수 또는 `MaskFilter`의 반경)를 조절하세요.
* **상태 흐름 변경:** "진행 중" ➡️ "완료" 사이의 트랜지션 타이밍을 변경하려면 `AgentBackgroundEffects`의 `_startCompletionSequence()` 내의 Timer 값(현 650ms, 450ms)을 수정해야 합니다.
