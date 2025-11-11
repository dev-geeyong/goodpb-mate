/// 투자자 유형
enum InvestorType {
  financialEmployee('금융사 임직원', '은행, 증권사, 보험사 등\n금융기관 종사자'),
  individualInvestor('개인투자자', '개인 자산을 운용하는\n일반 투자자'),
  corporateInvestor('법인투자자', '기업 및 기관의\n자금 운용 담당자');

  const InvestorType(this.title, this.subtitle);

  final String title;
  final String subtitle;
}
