import 'package:flutter/material.dart';
import '../models/service_type.dart';
import '../theme/app_theme.dart';
import '../widgets/selection_button.dart';
import 'bond_calculator_screen.dart';
import 'securities_selection_screen.dart';

/// 서비스 선택 화면
class ServiceSelectionScreen extends StatelessWidget {
  const ServiceSelectionScreen({super.key});

  void _onServiceSelected(BuildContext context, ServiceType type) {
    Widget screen;
    switch (type) {
      case ServiceType.calculator:
        screen = const BondCalculatorScreen();
        break;
      case ServiceType.investment:
        screen = const SecuritiesSelectionScreen();
        break;
    }

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                '어떤 서비스를\n이용하시겠어요?',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                '원하는 흐름을 선택하면 필요한 입력 값과 가이드를 단계별로 안내해 드려요.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: ServiceType.values.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final type = ServiceType.values[index];
                    return SelectionButton(
                      title: type.title,
                      subtitle: type.subtitle,
                      accentColor:
                          type == ServiceType.calculator ? AppColors.primary : null,
                      onTap: () => _onServiceSelected(context, type),
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
