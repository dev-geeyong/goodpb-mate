import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../models/bond.dart';
import '../services/bond_api_service.dart';
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
      TextEditingController(text: '100000000');
  final TextEditingController _purchasePriceController =
      TextEditingController();
  final TextEditingController _sellPriceController =
      TextEditingController(text: '만기상환');
  String _selectedTaxRate = '기본(15.4%)';
  Bond? _selectedBond;
  bool _isEarlyRedemption = false;
  DateTime? _sellDate;

  final BondApiService _apiService = BondApiService();
  bool _isCalculating = false;
  String? _errorMessage;

  // 계산 결과
  double _actualInvestment = 0;
  double _preTaxProfit = 0;
  double _tax = 0;
  double _afterTaxInterest = 0;
  double _preTaxYield = 0;
  double _afterTaxYield = 0;
  double _totalPaymentAfterTax = 0;
  double _bankEquivalentYield = 0;
  double _interestIncome = 0;
  double _capitalIncome = 0;

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

  Future<void> _calculate() async {
    final purchaseAmount = double.tryParse(_purchaseAmountController.text) ?? 0;
    final purchasePrice = double.tryParse(_purchasePriceController.text) ?? 0;

    if (purchaseAmount == 0 || purchasePrice == 0 || _selectedBond == null) {
      return;
    }

    setState(() {
      _isCalculating = true;
      _errorMessage = null;
    });

    try {
      final taxRate = _getTaxRateValue();

      // 매도 정보 준비
      String? sellDateStr;
      double? sellPrice;

      if (_isEarlyRedemption && _sellDate != null) {
        // 중도매도인 경우
        final dateFormat = DateFormat('yyyyMMdd');
        sellDateStr = dateFormat.format(_sellDate!);

        final sellPriceText = _sellPriceController.text;
        if (sellPriceText != '만기상환') {
          sellPrice = double.tryParse(sellPriceText);
        }
      }

      // API 호출
      final result = await _apiService.calculateBond(
        pdno: _selectedBond!.id,
        amountWon: purchaseAmount,
        incomeTaxRate: taxRate,
        buyPrice: purchasePrice,
        sellPrice: sellPrice,
        sellDate: sellDateStr,
      );

      // 결과 반영
      setState(() {
        _actualInvestment = result.realInvestment;
        _interestIncome = result.interestIncome;
        _capitalIncome = result.capitalIncome;
        _preTaxProfit = result.beforeTaxInterest;
        _tax = result.comprehensiveTax;
        _afterTaxInterest = result.afterTaxComprehensive;
        _preTaxYield = result.beforeTaxRate;
        _afterTaxYield = result.afterTaxRate;
        _totalPaymentAfterTax = result.totalAmount;
        _bankEquivalentYield = result.depositEquivalentRate;
        _isCalculating = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'API 계산 오류: $e';
        _isCalculating = false;
      });

      // 에러 메시지 표시
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('계산 중 오류가 발생했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _purchaseAmountController.dispose();
    _purchasePriceController.dispose();
    _sellPriceController.dispose();
    super.dispose();
  }

  Future<void> _selectSellDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _sellDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: _selectedBond?.maturityDate ?? DateTime.now().add(const Duration(days: 3650)),
      builder: (context, child) {
        final base = Theme.of(context);
        return Theme(
          data: base.copyWith(
            colorScheme: base.colorScheme.copyWith(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.card,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: AppColors.cardElevated,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _sellDate) {
      setState(() {
        _sellDate = picked;
      });
    }
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
                final selectedBond = await showModalBottomSheet<Bond>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const BondListScreen(),
                );
                if (selectedBond != null) {
                  setState(() {
                    _selectedBond = selectedBond;
                    // 매수 단가를 액면가로 설정 (채권 액면가는 일반적으로 10,000원)
                    _purchasePriceController.text = '10000';
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    '매도일자',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: _isEarlyRedemption,
                      onChanged: (value) {
                        setState(() {
                          _isEarlyRedemption = value ?? false;
                          if (!_isEarlyRedemption) {
                            _sellDate = null;
                            _sellPriceController.text = '만기상환';
                          } else {
                            _sellPriceController.text = '0';
                          }
                        });
                      },
                      activeColor: AppColors.primary,
                    ),
                    Text(
                      '중도상환',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildSellDateField(theme),
            const SizedBox(height: 20),
            _buildSellPriceField(theme),
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
                onPressed: _isCalculating ? null : _calculate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: _isCalculating
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
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
            const SizedBox(height: 32),
            _buildSectionHeader(
              context,
              title: '추천 채권',
              subtitle: '예금과 같이 안정성이 높은 채권의 수익률을 확인해보세요.',
            ),
            _buildRecommendedBonds(theme),
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

  Widget _buildSellDateField(ThemeData theme) {
    String displayText;
    if (_isEarlyRedemption) {
      if (_sellDate != null) {
        displayText = '${_sellDate!.year}.${_sellDate!.month.toString().padLeft(2, '0')}.${_sellDate!.day.toString().padLeft(2, '0')}';
      } else {
        displayText = '날짜 선택';
      }
    } else {
      displayText = '만기상환';
    }

    return InkWell(
      onTap: _isEarlyRedemption ? _selectSellDate : null,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: _isEarlyRedemption ? AppColors.cardElevated : AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 18,
              color: _isEarlyRedemption && _sellDate != null
                  ? AppColors.primary
                  : AppColors.textSecondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                displayText,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: _isEarlyRedemption && _sellDate != null
                      ? Colors.white
                      : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSellPriceField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '매도 단가(원)',
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _sellPriceController,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: _isEarlyRedemption ? Colors.white : AppColors.textSecondary,
          ),
          keyboardType: _isEarlyRedemption ? TextInputType.number : TextInputType.none,
          enabled: _isEarlyRedemption,
          inputFormatters: _isEarlyRedemption
              ? [FilteringTextInputFormatter.digitsOnly]
              : [],
          decoration: InputDecoration(
            hintText: '0',
            suffixText: _isEarlyRedemption ? '원' : null,
            suffixStyle: theme.textTheme.bodySmall,
            filled: true,
            fillColor: _isEarlyRedemption ? AppColors.cardElevated : AppColors.card,
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

  List<Bond> _getRecommendedBonds() {
    // 현재 선택된 채권을 제외하고 3개 추천
    // 신용등급이 비슷한 채권 우선 추천
    final allBonds = Bond.mockData.where((bond) => bond.id != _selectedBond?.id).toList();

    if (_selectedBond != null && allBonds.isNotEmpty) {
      // 같은 신용등급의 채권을 우선 추천
      final sameCreditRating = allBonds
          .where((bond) => bond.creditRating == _selectedBond!.creditRating)
          .toList();

      if (sameCreditRating.length >= 3) {
        return sameCreditRating.take(3).toList();
      }

      // 신용등급이 같은 채권이 부족하면 나머지로 채움
      final others = allBonds
          .where((bond) => bond.creditRating != _selectedBond!.creditRating)
          .toList();

      return [...sameCreditRating, ...others].take(3).toList();
    }

    return allBonds.take(3).toList();
  }

  Widget _buildRecommendedBonds(ThemeData theme) {
    final recommendedBonds = _getRecommendedBonds();

    return Column(
      children: recommendedBonds.map((bond) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedBond = bond;
                // 계산 결과 초기화
                _actualInvestment = 0;
                _preTaxProfit = 0;
                _tax = 0;
                _afterTaxInterest = 0;
                _preTaxYield = 0;
                _afterTaxYield = 0;
                _totalPaymentAfterTax = 0;
                _bankEquivalentYield = 0;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardElevated,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.8),
                          AppColors.primarySoft.withOpacity(0.6),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.account_balance,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bond.name,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          bond.securitiesCompanyName,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${bond.interestRate.toStringAsFixed(2)}%',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          bond.creditRating,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildResultSection(ThemeData theme) {
    final rows = <Map<String, String>>[
      {'label': '실 투자금', 'value': _formatCurrency(_actualInvestment)},
      {'label': '이자 수익', 'value': _formatCurrency(_interestIncome)},
      {'label': '자본 수익', 'value': _formatCurrency(_capitalIncome)},
      {'label': '세전 수익', 'value': _formatCurrency(_preTaxProfit)},
      {'label': '세금', 'value': _formatCurrency(_tax)},
      {'label': '세후 이자', 'value': _formatCurrency(_afterTaxInterest)},
      {'label': '연 수익률(세전)', 'value': _formatPercent(_preTaxYield)},
      {'label': '연 수익률(세후)', 'value': _formatPercent(_afterTaxYield)},
      {'label': '총 지급금액(세후)', 'value': _formatCurrency(_totalPaymentAfterTax)},
      {'label': '최대주주', 'value': _selectedBond?.seller ?? '-'},
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
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isHighlight ? AppColors.accent : AppColors.textSecondary,
                fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 4,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: isHighlight ? AppColors.accent : Colors.white,
              ),
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
