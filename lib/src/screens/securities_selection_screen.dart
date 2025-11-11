import 'package:flutter/material.dart';
import '../models/securities_company.dart';
import '../services/storage_service.dart';
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
          builder: (context) => const BondListScreen(),
        ),
      );
    }
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
                        const Text(
                          '증권사를 선택해주세요',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '거래 중인 증권사를 선택하시면\n더 정확한 정보를 제공해드릴 수 있어요',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            height: 1.5,
                          ),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '선택완료',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
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
        color: Colors.grey.shade50,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '선택한 증권사',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Text(
                    '없음 - 모든 채권을 볼래요',
                    style: TextStyle(fontSize: 14),
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
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          company.name,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => _toggleSecurities(id),
                          child: Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.blue.shade700,
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
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue.shade50 : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 증권사 로고 (플레이스홀더)
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.account_balance,
                    size: 28,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                // 증권사 이름
                Text(
                  company.name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.blue.shade700 : Colors.black87,
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
