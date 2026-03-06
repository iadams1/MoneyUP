import 'package:flutter/material.dart';
import 'filter_section_header.dart';

class BankFilterSection extends StatelessWidget {
  final List<String> banks;
  final Set<String> selectedBanks;
  final Function(String) onToggle;
  final VoidCallback onClear;

  const BankFilterSection({
    super.key,
    required this.banks,
    required this.selectedBanks,
    required this.onToggle,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilterSectionHeader(
          title: "Bank Accounts",
          showClear: selectedBanks.isNotEmpty,
          onClear: onClear,
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: banks.map((bank) {
            return FilterChip(
              label: Text(bank),
              selected: selectedBanks.contains(bank),
              onSelected: (_) => onToggle(bank),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              backgroundColor: Colors.white,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            );
          }).toList(),
        ),
      ],
    );
  }
}