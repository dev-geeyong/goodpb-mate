/// 채권 계산 결과
class BondCalculationResult {
  final double quantity; // 수량
  final double realInvestment; // 실투자금
  final double interestIncome; // 이자수익
  final double capitalIncome; // 자본수익
  final double beforeTaxInterest; // 세전수익
  final double taxAmount; // 세금
  final double afterTaxInterest; // 세후 수익
  final double afterTaxComprehensive; // 종합세율 세후수익
  final double additionalTaxRate; // 추가납부 세율
  final double additionalTax; // 추가납부 세금
  final double comprehensiveTax; // 종합소득 세율 반영 세금
  final double afterTaxRate; // 연 수익률(세후) [%]
  final double beforeTaxRate; // 연 수익률(세전) [%]
  final double totalAmount; // 총 지급액 세후
  final double depositEquivalentRate; // 은행예금 환산 수익률
  final double? nonHoldingPeriodTaxFreeInterest; // 미보유기간 이자 비과세 금액
  final double? holdingPeriodTax; // (중도매도시) 보유기간 세금

  final double couponRate; // 표면금리
  final int investDays; // 투자기간(일)
  final int remainingCouponCount; // 남은 이표 횟수
  final String pdno; // 상품번호
  final String message; // 메시지
  final bool success; // 성공 여부

  BondCalculationResult({
    required this.quantity,
    required this.realInvestment,
    required this.interestIncome,
    required this.capitalIncome,
    required this.beforeTaxInterest,
    required this.taxAmount,
    required this.afterTaxInterest,
    required this.afterTaxComprehensive,
    required this.additionalTaxRate,
    required this.additionalTax,
    required this.comprehensiveTax,
    required this.afterTaxRate,
    required this.beforeTaxRate,
    required this.totalAmount,
    required this.depositEquivalentRate,
    this.nonHoldingPeriodTaxFreeInterest,
    this.holdingPeriodTax,
    required this.couponRate,
    required this.investDays,
    required this.remainingCouponCount,
    required this.pdno,
    required this.message,
    required this.success,
  });

  factory BondCalculationResult.fromJson(Map<String, dynamic> json) {
    final calc = json['calculation_result'];
    return BondCalculationResult(
      quantity: _parseDouble(calc['quantity']) ?? 0.0,
      realInvestment: _parseDouble(calc['real_investment']) ?? 0.0,
      interestIncome: _parseDouble(calc['interest_income']) ?? 0.0,
      capitalIncome: _parseDouble(calc['capital_income']) ?? 0.0,
      beforeTaxInterest: _parseDouble(calc['before_tax_interest']) ?? 0.0,
      taxAmount: _parseDouble(calc['tax_amount']) ?? 0.0,
      afterTaxInterest: _parseDouble(calc['after_tax_interest']) ?? 0.0,
      afterTaxComprehensive: _parseDouble(calc['after_tax_comprehensive']) ?? 0.0,
      additionalTaxRate: _parseDouble(calc['additional_tax_rate']) ?? 0.0,
      additionalTax: _parseDouble(calc['additional_tax']) ?? 0.0,
      comprehensiveTax: _parseDouble(calc['comprehensive_tax']) ?? 0.0,
      afterTaxRate: _parseDouble(calc['after_tax_rate']) ?? 0.0,
      beforeTaxRate: _parseDouble(calc['before_tax_rate']) ?? 0.0,
      totalAmount: _parseDouble(calc['total_amount']) ?? 0.0,
      depositEquivalentRate: _parseDouble(calc['deposit_equivalent_rate']) ?? 0.0,
      nonHoldingPeriodTaxFreeInterest: _parseDouble(calc['non_holding_period_tax_free_interest']),
      holdingPeriodTax: _parseDouble(calc['holding_period_tax']),
      couponRate: _parseDouble(json['coupon_rate']) ?? 0.0,
      investDays: json['invest_days'] ?? 0,
      remainingCouponCount: json['remaining_coupon_count'] ?? 0,
      pdno: json['pdno'] ?? '',
      message: json['message'] ?? '',
      success: json['success'] ?? false,
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
