import 'package:flutter/material.dart';
import '../models/service_type.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // 상단 타이틀
              const Text(
                '어떤 서비스를\n이용하시겠어요?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 40),
              // 서비스 유형 버튼들
              ...ServiceType.values.map((type) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: SelectionButton(
                    title: type.title,
                    subtitle: type.subtitle,
                    onTap: () => _onServiceSelected(context, type),
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
