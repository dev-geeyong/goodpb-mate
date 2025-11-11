# 개발 진행 현황

## 프로젝트 개요
- **앱 이름**: GoodPB Mate (채권 투자 도우미)
- **플랫폼**: iOS/Android
- **프레임워크**: Flutter 3.35.3, Dart 3.9.2
- **디자인 시스템**: Toss 스타일 다크 테마

## 주요 기능

### 1. 투자자 유형 선택 화면
- 사용자가 본인의 투자자 유형을 선택
- 3가지 옵션: 금융사 임직원, 개인투자자, 법인투자자
- 선택한 값은 로컬 스토리지에 저장

### 2. 서비스 선택 화면
- 2가지 서비스 제공
  - 수익률 계산: 보유 채권의 수익률 계산
  - 채권 투자: 새로운 채권 투자 계획

### 3. 알파본드 채권 계산기 화면
- 채권 검색 기능
- 입력 필드:
  - 매수 금액(원)
  - 매수 단가(원)
  - 종합소득 세율 (드롭다운, 기본값: 15.4%)
- 계산 결과 표시:
  - 실 투자금
  - 세전/세후 수익
  - 세금
  - 연 수익률 (세전/세후)
  - 총 지급금액(세후)
  - 은행예금 환산수익률

### 4. 증권사 선택 화면
- 거래 증권사 선택 (다중 선택 가능)
- 선택된 증권사 표시 및 제거 기능
- 증권사 목록을 3열 그리드로 표시
- 선택 완료 버튼

### 5. 채권 목록 화면
- 투자기간 선택 (DateRangePicker)
- 신용등급 필터 드롭다운
- 채권 리스트 (272×94 사이즈)
- 채권 클릭 시 계산기 화면으로 이동

## 화면 흐름
```
투자자 유형 선택
    ↓
서비스 선택
    ↓
  ┌─────────────┬──────────────┐
  ↓                            ↓
채권 계산기              증권사 선택
  ↑                            ↓
  └────────────────────  채권 목록
```

## 기술 스택
- **상태 관리**: StatefulWidget (추후 필요시 Provider/Riverpod 고려)
- **로컬 저장소**: SharedPreferences
- **네비게이션**: Navigator 2.0 (기본)
- **날짜 처리**: intl 패키지
- **디자인 시스템**: 커스텀 Toss 스타일 테마

## 개발 진행 사항

### 2025-11-11

#### 초기 구현
- [x] 프로젝트 초기 설정 완료
- [x] CLAUDE.md, AGENTS.md, DEVELOPMENT.md 작성 완료
- [x] 프로젝트 구조 설계 (screens, widgets, models, services, theme)
- [x] SharedPreferences 기반 로컬 저장소 서비스 구현
- [x] 투자자 유형 선택 화면 구현
- [x] 서비스 선택 화면 구현
- [x] 채권 계산기 화면 구현 (UI만, 계산 로직은 추후 구현)
- [x] 증권사 선택 화면 구현 (다중 선택 가능)
- [x] SelectionButton 공통 위젯 구현
- [x] 모델 클래스 구현 (InvestorType, ServiceType, SecuritiesCompany, Bond)

#### 디자인 시스템 (Toss 스타일)
- [x] 다크 테마 적용 (깊이감 있는 블루-그레이 톤)
- [x] AppColors 클래스 생성 (Primary, Accent, Background, Surface 등)
- [x] AppTheme 클래스 생성 (Typography, Buttons, Input Fields 등)
- [x] SelectionButton 위젯 Toss 스타일 업데이트
  - 그라디언트 아이콘 배경
  - 부드러운 모서리 (18px border radius)
  - 그림자 효과
- [x] 모든 화면에 테마 적용

#### 채권 목록 기능
- [x] 채권 목록 화면 구현
- [x] 투자기간 선택 (DateRangePicker)
- [x] 신용등급 필터 드롭다운
- [x] 채권 리스트 아이템 위젯 (272×94)
- [x] 채권 모델 및 목 데이터 8개
- [x] 증권사 선택 → 채권 목록 화면 연결
- [x] 채권 클릭 → 계산기 화면 연결

#### UI 개선
- [x] 증권사 선택 영역 전체 너비 사용 (여백 제거)
- [x] intl 패키지 추가 (날짜 포맷팅)

#### 문서화
- [x] DESIGN_SYSTEM.md 생성 (Toss 스타일 가이드)
- [x] Git 커밋 및 푸시 완료

## 구현된 파일 구조

```
lib/
  main.dart                           # 앱 진입점 (테마 적용)
  src/
    theme/
      app_theme.dart                  # Toss 스타일 디자인 시스템
    models/
      investor_type.dart              # 투자자 유형 enum
      service_type.dart               # 서비스 유형 enum
      securities_company.dart         # 증권사 정보 모델
      bond.dart                       # 채권 정보 모델
    screens/
      investor_type_screen.dart       # 투자자 유형 선택 화면
      service_selection_screen.dart   # 서비스 선택 화면
      bond_calculator_screen.dart     # 채권 계산기 화면
      securities_selection_screen.dart # 증권사 선택 화면
      bond_list_screen.dart           # 채권 목록 화면
    widgets/
      selection_button.dart           # 공통 선택 버튼 위젯 (Toss 스타일)
      bond_list_item.dart             # 채권 리스트 아이템 위젯
    services/
      storage_service.dart            # 로컬 저장소 서비스
```

## 디자인 시스템

상세한 디자인 가이드는 [DESIGN_SYSTEM.md](./DESIGN_SYSTEM.md)를 참고하세요.

### 주요 특징
- **다크 테마**: 깊이감 있는 블루-그레이 톤
- **부드러운 모서리**: 14-18px border radius
- **그라디언트 아이콘**: Primary 색상 그라디언트
- **명확한 타이포그래피**: Bold(700), SemiBold(600) 적극 활용
- **일관된 간격**: 24px 기본 패딩

## TODO
- [ ] 실제 채권 데이터 연동
- [ ] 계산 로직 구현
- [ ] 증권사 목록 데이터 연동
- [ ] 에러 핸들링
- [ ] 로딩 상태 처리
