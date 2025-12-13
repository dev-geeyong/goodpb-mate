import 'package:flutter/material.dart';
import '../models/securities_company.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import 'bond_list_screen.dart';

/// 증권사 선택 화면
class SecuritiesSelectionScreen extends StatefulWidget {
  const SecuritiesSelectionScreen({super.key});

  @override
  State<SecuritiesSelectionScreen> createState() =>
      _SecuritiesSelectionScreenState();
}

class _SecuritiesSelectionScreenState extends State<SecuritiesSelectionScreen> {
  final List<String> _selectedSecurities = [];
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    _loadSelectedSecurities();
  }

  Future<void> _loadSelectedSecurities() async {
    final securities = await _storageService.getSelectedSecurities();
    setState(() {
      _selectedSecurities.addAll(securities);
    });
  }

  void _toggleSecurities(String securitiesId) {
    setState(() {
      if (_selectedSecurities.contains(securitiesId)) {
        _selectedSecurities.remove(securitiesId);
      } else {
        _selectedSecurities.add(securitiesId);
      }
    });
  }

  Future<void> _onComplete() async {
    await _storageService.saveSelectedSecurities(_selectedSecurities);
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const BondListScreen(isStandalone: true),
        ),
      );
    }
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 타이틀 섹션 (좌우 패딩 있음)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Text(
                          '증권사를 선택해주세요',
                          style: theme.textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '거래 중인 증권사를 선택하면 맞춤 추천과 필터가 자동으로 적용됩니다.',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 선택된 증권사 표시 영역 (좌우 패딩 없음, 전체 너비 사용)
                  _buildSelectedSecuritiesSection(),
                  const SizedBox(height: 24),

                  // 증권사 그리드 (좌우 패딩 있음)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: _buildSecuritiesGrid(),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // 선택완료 버튼
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onComplete,
                child: Text(
                  _selectedSecurities.isEmpty ? '건너뛰고 계속' : '선택완료',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedSecuritiesSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.cardElevated,
        border: Border(
          top: const BorderSide(color: AppColors.border),
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '선택한 증권사',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.start,
              children: [
                if (_selectedSecurities.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Text(
                      '없음 - 모든 채권을 볼래요',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                else
                  ..._selectedSecurities.map((id) {
                    final company = SecuritiesCompany.samples.firstWhere(
                      (s) => s.id == id,
                    );
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            company.name,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () => _toggleSecurities(id),
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritiesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 86 / 95,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: SecuritiesCompany.samples.length,
      itemBuilder: (context, index) {
        final company = SecuritiesCompany.samples[index];
        final isSelected = _selectedSecurities.contains(company.id);

        return GestureDetector(
          onTap: () => _toggleSecurities(company.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.cardElevated : AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withOpacity(0.2)
                        : AppColors.border,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.account_balance,
                    size: 24,
                    color: isSelected ? AppColors.primary : Colors.white70,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  company.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
