# WinnersSign iOS

한국어 환경의 전자 계약/서명 앱인 **WinnersSign** iOS 프로젝트입니다. 계약서 작성과 관리, 사용자 인증, 기본 정보 수정 등 업무 흐름을 iOS 14 이상에서 실행되는 UIKit 기반 화면으로 제공합니다.

## 주요 기능
- 이메일/비밀번호 기반 로그인과 자동 로그인(UserDefaults 저장)
- 회원가입, 아이디/비밀번호 찾기, 약관 웹뷰 열람
- 개인/사업자 계약서 작성, 파일 업로드, 전자 서명 캔버스
- 계약서 목록 조회 및 상세 확인, 계좌 정보/주소 입력
- 프로필 및 연락처 정보 수정, 알림/권한 안내

## 기술 스택
- **언어**: Swift (Swift Package Manager 사용)
- **UI**: UIKit, Storyboard, Auto Layout, WebKit 기반 웹뷰
- **네트워킹**: Alamofire (SPM 의존성, `HttpsManager`에서 API 호출 관리)
- **로컬 저장소**: UserDefaults, JSONDecoder/Encoder로 세션 데이터 직렬화
- **플랫폼**: iOS 14 이상 타겟, Xcode 프로젝트(`.xcodeproj`)

## 폴더 구조
- `WinnersSign/` 핵심 앱 소스
  - `Auth`, `Login*`, `Join`, `FindID`, `FindPassWord`: 인증 및 계정 흐름
  - `Business`, `Individual`: 계약서 작성/업로드/서명 등 비즈니스 로직 화면
  - `Manager`: 네트워크(`HttpsManager`), 데이터(`DataManager`), UI 보조(`UIManager`)
  - `Bean`: 데이터 모델 정의(`SessionMb` 등)
  - `MyInfo`, `MyContract`: 내 정보 관리 및 계약 관리 화면
  - `Resource`, `Assets.xcassets`, `Font`, `Image`: 리소스와 에셋
- `WinnersSignTests`, `WinnersSignUITests`: 단위/UITest 템플릿

## 아키텍처
UIKit 기반 MVC 구조에 서비스/매니저 레이어를 추가해 화면과 네트워크 코드를 분리합니다.

```
flowchart TD
    User[사용자 입력] --> UI[ViewController / Storyboard]
    UI --> Manager[Manager 계층 (HttpsManager, DataManager, UIManager)]
    Manager --> Network[네트워크: Alamofire 요청]
    Manager --> Storage[로컬 저장: UserDefaults]
    Network --> Backend[백엔드 API]
    Storage --> UI
    Backend --> UI
```

## 빌드 및 실행
1. Xcode에서 `WinnersSign.xcodeproj`를 엽니다.
2. 필요 시 Swift Package Manager가 Alamofire 의존성을 자동으로 해결합니다.
3. 실제 디바이스 또는 iOS 14+ 시뮬레이터로 실행합니다.

## 추가 개발 팁
- 새 API 연동은 `Manager/HttpsManager.swift`를 통해 추가하고, 응답 모델은 `Bean` 폴더에 정의합니다.
- 네비게이션 흐름은 `ViewControllerManager`를 사용해 화면 전환을 일관되게 처리합니다.
