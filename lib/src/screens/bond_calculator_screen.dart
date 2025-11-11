import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 알파본드 채권 계산기 화면
class BondCalculatorScreen extends StatefulWidget {
  const BondCalculatorScreen({super.key});

  @override
  State<BondCalculatorScreen> createState() => _BondCalculatorScreenState();
}

class _BondCalculatorScreenState extends State<BondCalculatorScreen> {
  final TextEditingController _purchaseAmountController =
      TextEditingController();
  final TextEditingController _purchasePriceController =
      TextEditingController();
  String _selectedTaxRate = '기본(15.4%)';

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
  void dispose() {
    _purchaseAmountController.dispose();
    _purchasePriceController.dispose();
    super.dispose();
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
        title: const Text(
          '계산기',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 채권 검색 버튼
              InkWell(
                onTap: () {
                  // TODO: 채권 검색 기능 구현
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey.shade600),
                      const SizedBox(width: 12),
                      Text(
                        '채권명을 입력하세요',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 매수 금액 입력
              _buildInputField(
                label: '매수 금액(원)',
                controller: _purchaseAmountController,
              ),
              const SizedBox(height: 20),

              // 매수 단가 입력
              _buildInputField(
                label: '매수 단가(원)',
                controller: _purchasePriceController,
              ),
              const SizedBox(height: 20),

              // 종합소득 세율 드롭다운
              const Text(
                '종합소득 세율',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: _selectedTaxRate,
                  isExpanded: true,
                  underline: const SizedBox(),
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

              // 계산 결과
              _buildResultSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '계산 결과',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildResultRow('실 투자금', '0원'),
          _buildResultRow('세전 수익', '0원'),
          _buildResultRow('세금', '0원'),
          _buildResultRow('세후 이자', '0원'),
          _buildResultRow('연 수익률(세전)', '0.00%'),
          _buildResultRow('연 수익률(세후)', '0.00%'),
          _buildResultRow('총 지급금액(세후)', '0원'),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 12),
          _buildResultRow(
            '은행예금 환산수익률',
            '0.00%',
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
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isHighlight ? Colors.blue.shade700 : Colors.grey.shade700,
              fontWeight: isHighlight ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isHighlight ? Colors.blue.shade700 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
