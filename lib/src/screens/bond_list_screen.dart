import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/bond.dart';
import '../theme/app_theme.dart';
import '../widgets/bond_list_item.dart';

/// 채권 목록 화면
class BondListScreen extends StatefulWidget {
  const BondListScreen({super.key});

  @override
  State<BondListScreen> createState() => _BondListScreenState();
}

class _BondListScreenState extends State<BondListScreen> {
  DateTimeRange? _selectedDateRange;
  String _selectedCreditRating = '전체';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Bond> get _filteredBonds {
    return Bond.mockData.where((bond) {
      final matchesSearch = _searchQuery.isEmpty ||
          bond.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          bond.securitiesCompanyName
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      final matchesCreditRating = _selectedCreditRating == '전체' ||
          bond.creditRating == _selectedCreditRating;

      return matchesSearch && matchesCreditRating;
    }).toList();
  }

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
                  TextField(
                    controller: _searchController,
                    style: theme.textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: '채권명 또는 증권사 검색',
                      prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: AppColors.textSecondary),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
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
                final filteredBonds = _filteredBonds;
                if (filteredBonds.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(48.0),
                    child: Center(
                      child: Text(
                        '검색 결과가 없습니다',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                  );
                }
                final bond = filteredBonds[index];
                final isLast = index == filteredBonds.length - 1;
                return Padding(
                  padding: EdgeInsets.fromLTRB(24, 0, 24, isLast ? 24 : 12),
                  child: BondListItem(
                    bond: bond,
                    onTap: () {
                      Navigator.of(context).pop(bond);
                    },
                  ),
                );
              },
              childCount: _filteredBonds.isEmpty ? 1 : _filteredBonds.length,
            ),
          ),
        ],
      ),
    );
  }
}
