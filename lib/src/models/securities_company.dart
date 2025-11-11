/// 증권사 정보
class SecuritiesCompany {
  const SecuritiesCompany({
    required this.id,
    required this.name,
    required this.imagePath,
  });

  final String id;
  final String name;
  final String imagePath;

  // 샘플 증권사 목록
  static final List<SecuritiesCompany> samples = [
    const SecuritiesCompany(
      id: 'mirae_asset',
      name: '미래에셋증권',
      imagePath: 'assets/images/securities/mirae_asset.png',
    ),
    const SecuritiesCompany(
      id: 'samsung',
      name: '삼성증권',
      imagePath: 'assets/images/securities/samsung.png',
    ),
    const SecuritiesCompany(
      id: 'kb',
      name: 'KB증권',
      imagePath: 'assets/images/securities/kb.png',
    ),
    const SecuritiesCompany(
      id: 'daeshin',
      name: '대신증권',
      imagePath: 'assets/images/securities/daeshin.png',
    ),
    const SecuritiesCompany(
      id: 'kiwoom',
      name: '키움증권',
      imagePath: 'assets/images/securities/kiwoom.png',
    ),
    const SecuritiesCompany(
      id: 'nh',
      name: 'NH투자증권',
      imagePath: 'assets/images/securities/nh.png',
    ),
    const SecuritiesCompany(
      id: 'hana',
      name: '하나증권',
      imagePath: 'assets/images/securities/hana.png',
    ),
    const SecuritiesCompany(
      id: 'shinhan',
      name: '신한투자증권',
      imagePath: 'assets/images/securities/shinhan.png',
    ),
    const SecuritiesCompany(
      id: 'hanwha',
      name: '한화투자증권',
      imagePath: 'assets/images/securities/hanwha.png',
    ),
  ];
}
