import 'package:flutter/material.dart';
import '../models/investor_type.dart';
import '../services/storage_service.dart';
import '../widgets/selection_button.dart';
import 'service_selection_screen.dart';

/// 투자자 유형 선택 화면
class InvestorTypeScreen extends StatelessWidget {
  const InvestorTypeScreen({super.key});

  Future<void> _onInvestorTypeSelected(
    BuildContext context,
    InvestorType type,
  ) async {
    // 로컬에 저장
    final storageService = StorageService();
    await storageService.saveInvestorType(type.name);

    // 다음 화면으로 이동
    if (context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ServiceSelectionScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // 상단 타이틀
              const Text(
                '당신은 어떤\n투자자신가요?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 40),
              // 투자자 유형 버튼들
              ...InvestorType.values.map((type) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: SelectionButton(
                    title: type.title,
                    subtitle: type.subtitle,
                    onTap: () => _onInvestorTypeSelected(context, type),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
