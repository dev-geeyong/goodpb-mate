# 개발 진행 현황

## 프로젝트 개요
- **앱 이름**: GoodPB Mate (채권 투자 도우미)
- **플랫폼**: iOS/Android
- **프레임워크**: Flutter 3.35.3, Dart 3.9.2

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

## 화면 흐름
```
투자자 유형 선택
    ↓
서비스 선택
    ↓
  ┌─────────┬─────────┐
  ↓                   ↓
채권 계산기      증권사 선택
```

## 기술 스택
- **상태 관리**: StatefulWidget (추후 필요시 Provider/Riverpod 고려)
- **로컬 저장소**: SharedPreferences
- **네비게이션**: Navigator 2.0 (기본)

## 개발 진행 사항

### 2025-11-11
- [x] 프로젝트 초기 설정 완료
- [x] CLAUDE.md, AGENTS.md, DEVELOPMENT.md 작성 완료
- [x] 프로젝트 구조 설계 (screens, widgets, models, services)
- [x] SharedPreferences 기반 로컬 저장소 서비스 구현
- [x] 투자자 유형 선택 화면 구현
- [x] 서비스 선택 화면 구현
- [x] 채권 계산기 화면 구현 (UI만, 계산 로직은 추후 구현)
- [x] 증권사 선택 화면 구현 (다중 선택 가능)
- [x] SelectionButton 공통 위젯 구현
- [x] 모델 클래스 구현 (InvestorType, ServiceType, SecuritiesCompany)
- [x] Git 커밋 및 푸시 완료

## 구현된 파일 구조

```
lib/
  main.dart                           # 앱 진입점
  src/
    models/
      investor_type.dart              # 투자자 유형 enum
      service_type.dart               # 서비스 유형 enum
      securities_company.dart         # 증권사 정보 모델
    screens/
      investor_type_screen.dart       # 투자자 유형 선택 화면
      service_selection_screen.dart   # 서비스 선택 화면
      bond_calculator_screen.dart     # 채권 계산기 화면
      securities_selection_screen.dart # 증권사 선택 화면
    widgets/
      selection_button.dart           # 공통 선택 버튼 위젯
    services/
      storage_service.dart            # 로컬 저장소 서비스
```

## 디자인 가이드

### 버튼 스타일
- 왼쪽 아이콘: 48x48px
- 오른쪽 화살표: 24x24px
- 제목 + 부제목 레이아웃

### 증권사 그리드
- 3열 그리드 레이아웃
- 셀 크기: 86x95
- 증권사 로고 + 이름

## TODO
- [ ] 실제 채권 데이터 연동
- [ ] 계산 로직 구현
- [ ] 증권사 목록 데이터 연동
- [ ] 에러 핸들링
- [ ] 로딩 상태 처리
