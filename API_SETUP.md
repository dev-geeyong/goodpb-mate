# API 설정 가이드

## CORS 문제 해결

웹 브라우저에서 API를 호출할 때 CORS(Cross-Origin Resource Sharing) 에러가 발생할 수 있습니다.

### 해결 방법 1: 서버에 CORS 헤더 추가 (권장)

API 서버에서 다음 헤더를 추가해야 합니다:

```python
# FastAPI 예시
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 또는 특정 도메인만: ["https://dev-geeyong.github.io"]
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

### 해결 방법 2: 개발 환경에서 프록시 사용

로컬 개발 시에만 사용:

```bash
# Chrome을 CORS 비활성화 모드로 실행
# macOS
open -na "Google Chrome" --args --user-data-dir=/tmp/chrome_dev --disable-web-security

# Windows
chrome.exe --user-data-dir=C:\temp\chrome_dev --disable-web-security

# Linux
google-chrome --user-data-dir=/tmp/chrome_dev --disable-web-security
```

### 현재 동작

- API 호출 실패 시 자동으로 샘플 데이터로 전환
- 사용자에게 친화적인 에러 메시지 표시
- 앱 기능은 정상적으로 사용 가능

## API 엔드포인트

- **Base URL**: `http://13.124.234.154:8888`
- **채권 목록**: `GET /bond-master-basic`

### 쿼리 파라미터

| 파라미터 | 타입 | 설명 |
|---------|------|------|
| `sort_by` | string | 정렬 기준 (기본: pt_dt) |
| `sort_order` | string | 정렬 순서 (asc/desc) |
| `limit` | integer | 조회 개수 (기본: 100) |
| `offset` | integer | 오프셋 (기본: 0) |
| `credit_rating` | string | 신용등급 필터 |
| `prdt_name` | string | 상품명 검색 |

### 응답 구조

```json
{
  "success": true,
  "data": [
    {
      "index": 1,
      "data": {
        "pdno": "KR6005612E57",
        "prdt_name": "SPC삼립1",
        "credit_rating": "A+",
        "srfc_inrt": "4.1070",
        "return_rate": "3.2360",
        "expd_dt": "20270510",
        "exchange_company_name": "KB",
        "max_jj": ["㈜파리크라상 (40.66%)"]
      }
    }
  ],
  "total_count": 17428,
  "current_page": 1
}
```

## Mock 데이터

API를 사용할 수 없는 경우 앱은 자동으로 [Bond.mockData](lib/src/models/bond.dart)의 샘플 데이터를 사용합니다.

## API 활성화/비활성화

[bond_list_screen.dart](lib/src/screens/bond_list_screen.dart)에서 설정:

```dart
bool _useApi = true;  // true: API 사용, false: Mock 데이터만 사용
```
