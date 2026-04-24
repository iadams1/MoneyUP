import 'package:flutter/material.dart';

import '/core/utils/formatters.dart';
import '/models/filter_state.dart';

class ActiveFilterChips extends StatelessWidget {
  final FilterState filters;
  final VoidCallback onClearAll;
  final Function(String) onRemoveBank;
  final Function(String) onRemoveCategory;
  final VoidCallback onRemoveDate;

  const ActiveFilterChips({
    super.key,
    required this.filters,
    required this.onClearAll,
    required this.onRemoveBank,
    required this.onRemoveCategory,
    required this.onRemoveDate,
  });

  String _format(DateTime date) {
    final d = date.toLocal();
    return '${d.month}/${d.day}/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> chips = [];

    for (final bank in filters.selectedBanks) {
      chips.add(
        Padding(
          padding: EdgeInsets.only(right: 6),
          child: Chip(
            label: Text(
              bank,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
              side: BorderSide(color: Colors.transparent),
            ),
            backgroundColor: const Color.fromARGB(255, 225, 225, 225),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            deleteIcon: Icon(Icons.close, size: 18),
            onDeleted: () => onRemoveBank(bank),
          ),
        ),
      );
    }
    for (final category in filters.selectedCategories) {
      chips.add(
        Padding(
          padding: EdgeInsets.only(right: 6),
          child: Chip(
            label: Text(
              Formatters.category(category),
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
              side: BorderSide(color: Colors.transparent),
            ),
            backgroundColor: const Color.fromARGB(255, 225, 225, 225),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            deleteIcon: Icon(Icons.close, size: 18),
            onDeleted: () => onRemoveCategory(category),
          ),
        ),
      );
    }

    if (filters.startDate != null || filters.endDate != null) {
      final start = filters.startDate;
      final end = filters.endDate;

      String dateLabel;
      if (start !=null && end != null) {
        dateLabel = '${_format(start)} - ${_format(end)}';
      } else if (start != null) {
        dateLabel = "From ${_format(start)}";
      } else{
        dateLabel = "Until ${_format(end!)}";
      } 

      chips.add(
        Padding(
          padding: EdgeInsets.only(right: 6),
          child: Chip(
            label: Text(
              dateLabel,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
              side: BorderSide(color: Colors.transparent),
            ),
            backgroundColor: const Color.fromARGB(255, 225, 225, 225),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            deleteIcon: Icon(Icons.close, size: 18),
            onDeleted: onRemoveDate,
          ),
        ),
      );
    }
    if (chips.isEmpty) return const SizedBox();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: chips),
            ),
          ),
          TextButton(
            onPressed: onClearAll,
            child: const Text(
              "Clear Filters",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
