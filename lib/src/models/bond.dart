/// 채권 정보 모델
class Bond {
  const Bond({
    required this.id,
    required this.name,
    required this.securitiesCompanyName,
    required this.securitiesCompanyLogo,
    required this.maturityDate,
    required this.interestRate,
    required this.faceInterestRate,
    required this.creditRating,
    required this.seller,
  });

  final String id;
  final String name;
  final String securitiesCompanyName;
  final String securitiesCompanyLogo;
  final DateTime maturityDate;
  final double interestRate;
  final double faceInterestRate;
  final String creditRating;
  final String seller;

  // 목 데이터
  static final List<Bond> mockData = [
    Bond(
      id: '1',
      name: '미래에셋 제19호',
      securitiesCompanyName: '미래에셋증권',
      securitiesCompanyLogo: 'assets/images/securities/mirae_asset.png',
      maturityDate: DateTime(2027, 3, 15),
      interestRate: 4.85,
      faceInterestRate: 1.805,
      creditRating: 'A+',
      seller: '미래에셋',
    ),
    Bond(
      id: '2',
      name: '삼성증권 제25호',
      securitiesCompanyName: '삼성증권',
      securitiesCompanyLogo: 'assets/images/securities/samsung.png',
      maturityDate: DateTime(2026, 12, 20),
      interestRate: 4.52,
      faceInterestRate: 1.650,
      creditRating: 'AA-',
      seller: '삼성증권',
    ),
    Bond(
      id: '3',
      name: 'KB증권 제12호',
      securitiesCompanyName: 'KB증권',
      securitiesCompanyLogo: 'assets/images/securities/kb.png',
      maturityDate: DateTime(2028, 6, 10),
      interestRate: 5.12,
      faceInterestRate: 2.100,
      creditRating: 'AA',
      seller: 'KB증권',
    ),
    Bond(
      id: '4',
      name: '대신증권 제8호',
      securitiesCompanyName: '대신증권',
      securitiesCompanyLogo: 'assets/images/securities/daeshin.png',
      maturityDate: DateTime(2027, 9, 25),
      interestRate: 4.68,
      faceInterestRate: 1.920,
      creditRating: 'A',
      seller: '대신증권',
    ),
    Bond(
      id: '5',
      name: '키움증권 제33호',
      securitiesCompanyName: '키움증권',
      securitiesCompanyLogo: 'assets/images/securities/kiwoom.png',
      maturityDate: DateTime(2026, 11, 5),
      interestRate: 4.35,
      faceInterestRate: 1.550,
      creditRating: 'A+',
      seller: '키움증권',
    ),
    Bond(
      id: '6',
      name: 'NH투자증권 제41호',
      securitiesCompanyName: 'NH투자증권',
      securitiesCompanyLogo: 'assets/images/securities/nh.png',
      maturityDate: DateTime(2027, 5, 18),
      interestRate: 4.92,
      faceInterestRate: 1.975,
      creditRating: 'AA-',
      seller: 'NH투자증권',
    ),
    Bond(
      id: '7',
      name: '하나증권 제16호',
      securitiesCompanyName: '하나증권',
      securitiesCompanyLogo: 'assets/images/securities/hana.png',
      maturityDate: DateTime(2028, 2, 28),
      interestRate: 5.05,
      faceInterestRate: 2.050,
      creditRating: 'AA',
      seller: '하나증권',
    ),
    Bond(
      id: '8',
      name: '신한투자증권 제22호',
      securitiesCompanyName: '신한투자증권',
      securitiesCompanyLogo: 'assets/images/securities/shinhan.png',
      maturityDate: DateTime(2027, 7, 12),
      interestRate: 4.78,
      faceInterestRate: 1.885,
      creditRating: 'AA-',
      seller: '신한투자증권',
    ),
  ];
}
