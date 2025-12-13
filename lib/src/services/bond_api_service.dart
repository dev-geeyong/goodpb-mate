import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/bond.dart';

/// 채권 API 서비스
class BondApiService {
  static const String baseUrl = 'http://13.124.234.154:8888';

  /// 채권마스터 기본정보 조회
  Future<List<Bond>> fetchBonds({
    String? ptDt,
    String? prdtName,
    String? creditRating,
    int? minRemainDays,
    int? maxRemainDays,
    double? minSrfcInrt,
    double? maxSrfcInrt,
    int limit = 100,
    int offset = 0,
  }) async {
    try {
      // 쿼리 파라미터 구성
      final queryParams = <String, String>{
        'limit': limit.toString(),
        'offset': offset.toString(),
      };

      if (ptDt != null) queryParams['pt_dt'] = ptDt;
      if (prdtName != null) queryParams['prdt_name'] = prdtName;
      if (creditRating != null) queryParams['credit_rating'] = creditRating;
      if (minRemainDays != null) queryParams['min_remain_days'] = minRemainDays.toString();
      if (maxRemainDays != null) queryParams['max_remain_days'] = maxRemainDays.toString();
      if (minSrfcInrt != null) queryParams['min_srfc_inrt'] = minSrfcInrt.toString();
      if (maxSrfcInrt != null) queryParams['max_srfc_inrt'] = maxSrfcInrt.toString();

      final uri = Uri.parse('$baseUrl/bond-master-basic').replace(queryParameters: queryParams);

      print('API Request: $uri'); // 디버깅용

      final response = await http.get(uri);

      print('API Response Status: ${response.statusCode}'); // 디버깅용
      print('API Response Body: ${response.body.substring(0, response.body.length > 500 ? 500 : response.body.length)}'); // 디버깅용

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // success 필드 확인
        if (jsonData['success'] != true) {
          throw Exception('API returned success=false');
        }

        final List<dynamic> bondList = jsonData['data'] ?? [];

        print('Bonds count: ${bondList.length}'); // 디버깅용

        return bondList.map((item) => _parseBondFromApi(item)).toList();
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e, stackTrace) {
      print('Error in fetchBonds: $e'); // 디버깅용
      print('Stack trace: $stackTrace'); // 디버깅용
      throw Exception('Error fetching bonds: $e');
    }
  }

  /// API 응답을 Bond 모델로 변환
  Bond _parseBondFromApi(Map<String, dynamic> json) {
    return Bond(
      id: json['pdno'] ?? '',
      name: json['prdt_name'] ?? '',
      securitiesCompanyName: json['exchange_company_name'] ?? '',
      securitiesCompanyLogo: 'assets/images/securities/default.png',
      maturityDate: _parseDate(json['expd_dt']),
      interestRate: _parseDouble(json['return_rate']) ?? 0.0,
      faceInterestRate: _parseDouble(json['srfc_inrt']) ?? 0.0,
      creditRating: json['credit_rating'] ?? '',
      seller: json['exchange_company_name'] ?? '',
    );
  }

  /// 날짜 파싱 (YYYYMMDD -> DateTime)
  DateTime _parseDate(dynamic dateStr) {
    if (dateStr == null || dateStr.toString().isEmpty) {
      return DateTime.now().add(const Duration(days: 365));
    }

    final str = dateStr.toString();
    if (str.length == 8) {
      final year = int.parse(str.substring(0, 4));
      final month = int.parse(str.substring(4, 6));
      final day = int.parse(str.substring(6, 8));
      return DateTime(year, month, day);
    }

    return DateTime.now().add(const Duration(days: 365));
  }

  /// double 파싱
  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
