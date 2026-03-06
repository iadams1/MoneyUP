import 'package:flutter/material.dart';
import 'package:moneyup/core/utils/formatters.dart';
import '/models/filter_state.dart';

class ActiveFilterChips extends StatelessWidget {
  final FilterState filters;
  final VoidCallback onClearAll;
  final Function(String) onRemoveBank;
  final Function(String) onRemoveCategory;
  final VoidCallback onRemoveStartDate;
  final VoidCallback onRemoveEndDate;

  const ActiveFilterChips({
    super.key,
    required this.filters,
    required this.onClearAll,
    required this.onRemoveBank,
    required this.onRemoveCategory,
    required this.onRemoveStartDate,
    required this.onRemoveEndDate,
  });

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[];

    for (final bank in filters.selectedBanks) {
      chips.add(
        Chip(
          label: Text(bank),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          backgroundColor: Colors.white,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onDeleted: () => onRemoveBank(bank),
        ),
      );
    }

    for (final category in filters.selectedCategories) {
      chips.add(
        Chip(
          label: Text(Formatters.category(category)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          backgroundColor: Colors.white,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onDeleted: () => onRemoveCategory(category),
        ),
      );
    }

    if (filters.startDate != null) {
      chips.add(
        Chip(
          label: Text(
            "From ${filters.startDate!.toLocal().toString().split(' ')[0]}"),
          onDeleted: onRemoveStartDate,
        ),
      );
    }

    if (filters.endDate != null) {
      chips.add(
        Chip(
          label: Text("To ${filters.endDate!.toLocal().toString().split(' ')[0]}"),
          onDeleted: onRemoveEndDate,
        ),
      );
    }

    if (chips.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: chips,
        ),
        TextButton(
          onPressed: onClearAll,
          child: const Text("Clear Filters"),
        )
      ],
    );
  }
}