# 디자인 시스템 (Toss 스타일)

## 개요
GoodPB Mate 앱은 Toss의 세련되고 현대적인 디자인 언어를 채택하여 일관성 있고 직관적인 사용자 경험을 제공합니다.

## 색상 팔레트 (Color Palette)

### 다크 테마 (Dark Theme)
앱은 다크 모드를 기본으로 사용하며, 깊이감 있는 블루-그레이 톤을 활용합니다.

#### 배경 색상 (Background Colors)
- **Background**: `#0B111A` - 메인 배경색 (가장 어두운 레이어)
- **Surface**: `#111927` - 서페이스 레이어
- **Card**: `#151F32` - 카드 배경색
- **Card Elevated**: `#1C283D` - 강조된 카드 배경색

#### 경계선 색상 (Border Colors)
- **Border**: `#222D3F` - 기본 경계선
- **Border Muted**: `#2F384C` - 연한 경계선

#### 주요 색상 (Primary Colors)
- **Primary**: `#4F8BFF` - 메인 브랜드 색상 (밝은 블루)
- **Primary Soft**: `#74A5FF` - 부드러운 블루
- **Accent**: `#5EEAD4` - 강조 색상 (민트/터키시)

#### 텍스트 색상 (Text Colors)
- **Text Primary**: `#FFFFFF` - 주요 텍스트 (흰색)
- **Text Secondary**: `#9AA6C3` - 보조 텍스트 (연한 블루-그레이)
- **Text Muted**: `#6F7B96` - 희미한 텍스트 (어두운 그레이)

#### 기타 색상
- **Divider**: `#1F2735` - 구분선
- **Error**: `#FF6B6B` - 에러 상태

## 타이포그래피 (Typography)

### 헤드라인 (Headlines)
- **Headline Large**: 32px, Bold (700), 줄간격 1.25
- **Headline Medium**: 28px, Bold (700), 줄간격 1.3

### 제목 (Titles)
- **Title Large**: 20px, SemiBold (600)

### 본문 (Body)
- **Body Large**: 16px, Medium (500), 줄간격 1.5
- **Body Medium**: 15px, Regular (400), 줄간격 1.5
- **Body Small**: 13px, Regular (400)

### 라벨 (Labels)
- **Label Large**: 15px, SemiBold (600)

## 컴포넌트 스타일

### 버튼 (Buttons)

#### Elevated Button (주요 액션 버튼)
- **배경색**: Primary Blue (`#4F8BFF`)
- **텍스트**: 16px, Bold (700), White
- **패딩**: 세로 16px
- **Border Radius**: 14px
- **예시**: "선택완료", "계산하기" 등

#### Outlined Button (보조 버튼)
- **배경색**: 투명
- **테두리**: Border Color (`#222D3F`)
- **텍스트**: 15px, SemiBold (600), White
- **패딩**: 세로 14px, 가로 16px
- **Border Radius**: 14px
- **예시**: 필터 버튼

#### Text Button
- **텍스트 색상**: Primary Soft (`#74A5FF`)
- **폰트**: SemiBold (600)

### 카드 (Cards)

#### Selection Button (선택 버튼)
- **배경색**: Card (`#151F32`)
- **테두리**: Border (`#222D3F`)
- **Border Radius**: 18px
- **패딩**: 18px
- **그림자**:
  - 색상: `rgba(0, 0, 0, 0.25)`
  - 블러: 20px
  - 오프셋: (0, 12)
- **아이콘 영역**:
  - 크기: 52×52
  - Border Radius: 12px
  - Gradient 배경 (Primary 색상)
- **화살표**: 18px, Text Muted 색상

#### Bond List Item (채권 리스트 아이템)
- **크기**: 272×94
- **배경색**: White (다크 모드에서는 Card)
- **Border Radius**: 12px
- **테두리**: Border Color
- **패딩**: 12px

### 입력 필드 (Input Fields)

#### Text Field
- **배경색**: Card Elevated (`#1C283D`)
- **테두리**: Border (`#222D3F`)
- **Border Radius**: 14px
- **패딩**: 세로 14px, 가로 16px
- **포커스 상태**: Primary 색상, 두께 2px

#### Dropdown
- **배경색**: Card Elevated
- **Border Radius**: 14px
- **메뉴 배경색**: Card Elevated
- **그림자**: Elevation 8

### Chip (선택 태그)
- **기본 배경색**: Card (`#151F32`)
- **선택 시**: Primary 색상 + 20% 투명도
- **Border Radius**: 20px (완전 둥근 모서리)
- **패딩**: 세로 8px, 가로 12px
- **테두리**: Border Muted

## 간격 및 레이아웃 (Spacing & Layout)

### 표준 간격 (Standard Spacing)
- **화면 좌우 패딩**: 24px
- **섹션 간 간격**: 32px
- **요소 간 간격**:
  - 대: 24px
  - 중: 16px
  - 소: 12px
  - 최소: 8px

### Border Radius
- **카드/버튼**: 14-18px (부드러운 모서리)
- **태그/Chip**: 20px (완전 둥근)
- **아이콘 컨테이너**: 12px

## 인터랙션 (Interactions)

### 애니메이션
- **스크롤**: BouncingScrollPhysics (iOS 스타일)
- **전환**: Material 기본 애니메이션

### 터치 피드백
- **InkWell**: borderRadius에 맞춘 리플 효과
- **투명도 변화**: hover/press 상태

## Toss 스타일 특징

### 1. 깊이감 있는 다크 모드
- 여러 레이어의 블루-그레이 톤으로 깊이감 표현
- 미묘한 그림자와 경계선으로 요소 구분

### 2. 부드러운 모서리
- 모든 카드와 버튼에 14-18px의 큰 border radius 적용
- 현대적이고 친근한 느낌

### 3. 명확한 계층 구조
- 배경 → Surface → Card → Card Elevated 순서로 레이어링
- 색상 차이로 시각적 계층 표현

### 4. 그라디언트 아이콘
- 선택 버튼의 아이콘 영역에 Primary 색상 그라디언트 적용
- 시각적 포인트 제공

### 5. 일관된 간격
- 24px 기본 패딩
- 16-18px 내부 여백
- 규칙적인 간격으로 정돈된 느낌

### 6. 타이포그래피 강조
- Bold(700)와 SemiBold(600) 적극 활용
- 명확한 정보 전달

## 적용 방법

### 테마 사용
```dart
import 'package:flutter/material.dart';
import 'src/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      // ...
    );
  }
}
```

### 색상 사용
```dart
import '../theme/app_theme.dart';

Container(
  color: AppColors.card,
  child: Text(
    'Hello',
    style: TextStyle(color: AppColors.textPrimary),
  ),
)
```

### 테마 스타일 사용
```dart
final theme = Theme.of(context);

Text(
  '제목',
  style: theme.textTheme.headlineMedium,
)
```

## 참고 사항

- 모든 화면은 다크 모드 기준으로 디자인됨
- Toss의 디자인 철학: 명확성, 일관성, 단순함
- 접근성을 고려한 충분한 색상 대비
- Material Design 3 기반

## 향후 개선 사항

- [ ] 라이트 모드 테마 추가
- [ ] 커스텀 폰트 적용 (예: Pretendard)
- [ ] 애니메이션 세부 조정
- [ ] 접근성(Accessibility) 개선
- [ ] 반응형 디자인 최적화
