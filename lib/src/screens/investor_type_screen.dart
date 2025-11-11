import 'package:flutter/material.dart';
import '../models/investor_type.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
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
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                '당신은 어떤\n투자자신가요?',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                '프로필을 기반으로 맞춤형 채권 수익률 정보를 추천해 드려요.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: InvestorType.values.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final type = InvestorType.values[index];
                    return SelectionButton(
                      title: type.title,
                      subtitle: type.subtitle,
                      accentColor: AppColors.primary,
                      onTap: () => _onInvestorTypeSelected(context, type),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
