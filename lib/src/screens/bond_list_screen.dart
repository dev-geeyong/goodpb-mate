import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/bond.dart';
import '../theme/app_theme.dart';
import '../widgets/bond_list_item.dart';
import 'bond_calculator_screen.dart';

/// 채권 목록 화면
class BondListScreen extends StatefulWidget {
  const BondListScreen({super.key});

  @override
  State<BondListScreen> createState() => _BondListScreenState();
}

class _BondListScreenState extends State<BondListScreen> {
  DateTimeRange? _selectedDateRange;
  String _selectedCreditRating = '전체';

  final List<String> _creditRatings = [
    '전체',
    'AAA',
    'AA+',
    'AA',
    'AA-',
    'A+',
    'A',
    'A-',
    'BBB+',
    'BBB',
  ];

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      initialDateRange: _selectedDateRange,
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

    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  String _getDateRangeText() {
    if (_selectedDateRange == null) {
      return '투자기간 선택';
    }
    final format = DateFormat('yy.MM.dd');
    return '${format.format(_selectedDateRange!.start)} - ${format.format(_selectedDateRange!.end)}';
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
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '채권 수익률을 계산해보세요',
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '투자기간과 신용등급을 선택하면 알맞은 채권과 계산기를 바로 확인할 수 있어요.',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: _selectDateRange,
                          child: Container(
                            height: 56,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: AppColors.cardElevated,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: _selectedDateRange != null
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _getDateRangeText(),
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: _selectedDateRange != null
                                          ? AppColors.primary
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 56,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppColors.cardElevated,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedCreditRating,
                              isExpanded: true,
                              dropdownColor: AppColors.cardElevated,
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white70,
                              ),
                              style: theme.textTheme.bodyMedium,
                              items: _creditRatings.map((String rating) {
                                return DropdownMenuItem<String>(
                                  value: rating,
                                  child: Text(rating),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _selectedCreditRating = newValue;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final bond = Bond.mockData[index];
                final isLast = index == Bond.mockData.length - 1;
                return Padding(
                  padding: EdgeInsets.fromLTRB(24, 0, 24, isLast ? 24 : 12),
                  child: BondListItem(
                    bond: bond,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const BondCalculatorScreen(),
                        ),
                      );
                    },
                  ),
                );
              },
              childCount: Bond.mockData.length,
            ),
          ),
        ],
      ),
    );
  }
}
