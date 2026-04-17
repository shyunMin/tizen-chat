# Tizen Chat UI

Tizen 플랫폼을 위한 채팅 UI 애플리케이션입니다.

## 개요

Flutter로 개발된 Tizen 채팅 앱으로, Generative AI와 gRPC를 통합한 대화형 인터페이스를 제공합니다.

## 주요 기능

- **Generative AI 통합**: Google Generative AI를 활용한 지능형 채팅
- **gRPC 통신**: Carbon gRPC 서비스를 통한 백엔드 통신

## 기술 스택

- **Framework**: Flutter 3.10.7+
- **Platform**: Tizen 10.0 (Common Profile)
- **Architecture**: arm, aarch64

## 의존성

| 패키지 | 용도 |
|--------|------|
| flutter_markdown_plus | 마크다운 렌더링 |
| google_generative_ai | Generative AI 통합 |
| grpc | gRPC 통신 |

## 빌드 방법

### Tizen TPK 빌드

```bash
# Release 빌드 (arm)
flutter-tizen build tpk -pcommon --target-arch arm --release

# Release 빌드 (aarch64)
flutter-tizen build tpk -pcommon --target-arch aarch64 --release
```

### 빌드 산출물

- `build/tizen/tpk/org.tizen.chat-ui-1.0.0.tpk`


## 라이선스

Apache-2.0