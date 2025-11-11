/// 서비스 유형
enum ServiceType {
  calculator('수익률 계산', '보유 중인 채권의\n수익률을 계산해보세요'),
  investment('채권 투자', '새로운 채권 투자를\n계획하고 있어요');

  const ServiceType(this.title, this.subtitle);

  final String title;
  final String subtitle;
}
