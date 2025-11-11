import 'package:shared_preferences/shared_preferences.dart';

/// 로컬 저장소 관리 서비스
class StorageService {
  static const String _keyInvestorType = 'investor_type';
  static const String _keySelectedSecurities = 'selected_securities';

  /// 투자자 유형 저장
  Future<void> saveInvestorType(String investorType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyInvestorType, investorType);
  }

  /// 투자자 유형 가져오기
  Future<String?> getInvestorType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyInvestorType);
  }

  /// 선택한 증권사 목록 저장
  Future<void> saveSelectedSecurities(List<String> securities) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keySelectedSecurities, securities);
  }

  /// 선택한 증권사 목록 가져오기
  Future<List<String>> getSelectedSecurities() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keySelectedSecurities) ?? [];
  }

  /// 모든 데이터 삭제
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
