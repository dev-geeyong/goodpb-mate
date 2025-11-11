import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/bond.dart';

/// 채권 리스트 아이템 위젯
class BondListItem extends StatelessWidget {
  const BondListItem({
    super.key,
    required this.bond,
    this.onTap,
  });

  final Bond bond;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy.MM.dd');

    return InkWell(
      onTap: onTap,
      child: Container(
        width: 272,
        height: 94,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 왼쪽: 증권사 로고
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.account_balance,
                size: 24,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 12),

            // 중앙: 채권 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 채권 이름
                  Text(
                    bond.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  // 만기일
                  Text(
                    '만기 ${dateFormat.format(bond.maturityDate)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  // 하단 정보
                  Text(
                    '신용등급: ${bond.creditRating} | 판매회사: ${bond.seller}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // 오른쪽: 이율 정보
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 이율
                Text(
                  '${bond.interestRate.toStringAsFixed(2)}%',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                // 표면이율
                Text(
                  '표면이율:${bond.faceInterestRate.toStringAsFixed(3)}%',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
