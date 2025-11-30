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

  // 계산 결과
  double _actualInvestment = 0;
  double _preTaxProfit = 0;
  double _tax = 0;
  double _afterTaxInterest = 0;
  double _preTaxYield = 0;
  double _afterTaxYield = 0;
  double _totalPaymentAfterTax = 0;
  double _bankEquivalentYield = 0;

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

  double _getTaxRateValue() {
    switch (_selectedTaxRate) {
      case '기본(15.4%)':
        return 0.154;
      case '6.6%':
        return 0.066;
      case '16.5%':
        return 0.165;
      case '26.4%':
        return 0.264;
      case '38.5%':
        return 0.385;
      case '41.8%':
        return 0.418;
      case '49.5%':
        return 0.495;
      default:
        return 0.154;
    }
  }

  void _calculate() {
    final purchaseAmount = double.tryParse(_purchaseAmountController.text) ?? 0;
    final purchasePrice = double.tryParse(_purchasePriceController.text) ?? 0;

    if (purchaseAmount == 0 || purchasePrice == 0 || _selectedBond == null) {
      return;
    }

    final taxRate = _getTaxRateValue();
    final faceValue = 10000.0; // 액면가
    final quantity = purchaseAmount / faceValue; // 매수 수량

    // 실 투자금 = 매수금액 * 매수단가 / 100
    _actualInvestment = quantity * purchasePrice;

    // 세전 수익 = 매수금액 - 실투자금
    _preTaxProfit = purchaseAmount - _actualInvestment;

    // 세금 = 세전수익 * 세율
    _tax = _preTaxProfit * taxRate;

    // 세후 이자 = 세전수익 - 세금
    _afterTaxInterest = _preTaxProfit - _tax;

    // 만기일까지의 일수 계산
    final daysToMaturity = _selectedBond!.maturityDate.difference(DateTime.now()).inDays;
    final yearsToMaturity = daysToMaturity / 365.0;

    if (yearsToMaturity > 0) {
      // 연 수익률(세전) = (세전수익 / 실투자금) / 년수 * 100
      _preTaxYield = (_preTaxProfit / _actualInvestment) / yearsToMaturity * 100;

      // 연 수익률(세후) = (세후이자 / 실투자금) / 년수 * 100
      _afterTaxYield = (_afterTaxInterest / _actualInvestment) / yearsToMaturity * 100;

      // 은행예금 환산수익률 = 세후 연수익률 / (1 - 0.154)
      _bankEquivalentYield = _afterTaxYield / (1 - 0.154);
    }

    // 총 지급금액(세후) = 실투자금 + 세후이자
    _totalPaymentAfterTax = _actualInvestment + _afterTaxInterest;

    setState(() {});
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
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _calculate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  '계산하기',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
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

  String _formatCurrency(double value) {
    return '${value.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        )}원';
  }

  String _formatPercent(double value) {
    return '${value.toStringAsFixed(2)}%';
  }

  Widget _buildResultSection(ThemeData theme) {
    final rows = <Map<String, String>>[
      {'label': '실 투자금', 'value': _formatCurrency(_actualInvestment)},
      {'label': '세전 수익', 'value': _formatCurrency(_preTaxProfit)},
      {'label': '세금', 'value': _formatCurrency(_tax)},
      {'label': '세후 이자', 'value': _formatCurrency(_afterTaxInterest)},
      {'label': '연 수익률(세전)', 'value': _formatPercent(_preTaxYield)},
      {'label': '연 수익률(세후)', 'value': _formatPercent(_afterTaxYield)},
      {'label': '총 지급금액(세후)', 'value': _formatCurrency(_totalPaymentAfterTax)},
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
            _formatPercent(_bankEquivalentYield),
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
