import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/bond.dart';
import '../theme/app_theme.dart';
import 'bond_list_screen.dart';

/// 알파본드 채권 계산기 화면
class BondCalculatorScreen extends StatefulWidget {
  const BondCalculatorScreen({super.key, this.selectedBond});

  final Bond? selectedBond;

  @override
  State<BondCalculatorScreen> createState() => _BondCalculatorScreenState();
}

class _BondCalculatorScreenState extends State<BondCalculatorScreen> {
  final TextEditingController _purchaseAmountController =
      TextEditingController();
  final TextEditingController _purchasePriceController =
      TextEditingController();
  String _selectedTaxRate = '기본(15.4%)';
  Bond? _selectedBond;

  final List<String> _taxRates = [
    '기본(15.4%)',
    '6.6%',
    '16.5%',
    '26.4%',
    '38.5%',
    '41.8%',
    '49.5%',
  ];

  @override
  void initState() {
    super.initState();
    _selectedBond = widget.selectedBond;
  }

  @override
  void dispose() {
    _purchaseAmountController.dispose();
    _purchasePriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('계산기'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              context,
              title: '채권 검색',
              subtitle: '조회하고 싶은 채권을 검색하면 기본 값이 자동으로 채워집니다.',
            ),
            InkWell(
              onTap: () async {
                final selectedBond = await Navigator.of(context).push<Bond>(
                  MaterialPageRoute(
                    builder: (context) => const BondListScreen(),
                  ),
                );
                if (selectedBond != null) {
                  setState(() {
                    _selectedBond = selectedBond;
                  });
                }
              },
              borderRadius: BorderRadius.circular(18),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.cardElevated,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: AppColors.textSecondary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _selectedBond?.name ?? '채권명을 입력하세요',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: _selectedBond != null
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                    Text(
                      '검색',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.primarySoft,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildSectionHeader(
              context,
              title: '투자 정보',
              subtitle: '금액과 단가를 입력하면 실투자금과 예상 수익을 바로 비교할 수 있어요.',
            ),
            _buildInputField(
              label: '매수 금액(원)',
              controller: _purchaseAmountController,
              hintText: '0',
            ),
            const SizedBox(height: 20),
            _buildInputField(
              label: '매수 단가(원)',
              controller: _purchasePriceController,
              hintText: '0',
            ),
            const SizedBox(height: 20),
            Text(
              '종합소득 세율',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.cardElevated,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: DropdownButton<String>(
                value: _selectedTaxRate,
                isExpanded: true,
                underline: const SizedBox(),
                dropdownColor: AppColors.cardElevated,
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
                style: theme.textTheme.bodyLarge,
                items: _taxRates.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedTaxRate = newValue;
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 32),
            _buildSectionHeader(
              context,
              title: '계산 결과',
              subtitle: '아래 값은 시뮬레이션 결과입니다. 실제 수익률은 시장 상황에 따라 변동될 수 있습니다.',
            ),
            _buildResultSection(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    String? hintText,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: theme.textTheme.bodyLarge,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            hintText: hintText,
            suffixText: '원',
            suffixStyle: theme.textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  Widget _buildResultSection(ThemeData theme) {
    final rows = <Map<String, String>>[
      {'label': '실 투자금', 'value': '0원'},
      {'label': '세전 수익', 'value': '0원'},
      {'label': '세금', 'value': '0원'},
      {'label': '세후 이자', 'value': '0원'},
      {'label': '연 수익률(세전)', 'value': '0.00%'},
      {'label': '연 수익률(세후)', 'value': '0.00%'},
      {'label': '총 지급금액(세후)', 'value': '0원'},
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.cardElevated,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          ...rows.map(
            (row) => _buildResultRow(
              row['label']!,
              row['value']!,
              theme: theme,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          _buildResultRow(
            '은행예금 환산수익률',
            '0.00%',
            theme: theme,
            isHighlight: true,
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(
    String label,
    String value, {
    bool isHighlight = false,
    required ThemeData theme,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isHighlight ? AppColors.accent : AppColors.textSecondary,
              fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: isHighlight ? AppColors.accent : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required String subtitle,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleLarge),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
