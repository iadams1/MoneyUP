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
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: banks.map((bank) {
            return Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: FilterChip(
                label: Text(
                  bank,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                selected: selectedBanks.contains(bank),
                onSelected: (_) => onToggle(bank),
                selectedColor: const Color.fromARGB(255, 231, 221, 255),
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.white,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
