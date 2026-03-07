import 'package:flutter/material.dart';
import 'package:moneyup/core/utils/formatters.dart';
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

  @override
  Widget build(BuildContext context) {
    List<Widget> chips = [];

    for (final bank in filters.selectedBanks) {
      chips.add(
        Padding(
          padding: EdgeInsets.only(right: 6),
          child: Chip(
            label: Text(bank),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            backgroundColor: Colors.white,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            deleteIcon: Icon(Icons.close, size: 18,),
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
            label: Text(Formatters.category(category)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            backgroundColor: Colors.white,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            deleteIcon: Icon(Icons.close, size: 18,),
            onDeleted: () => onRemoveCategory(category),
          ),
        ),
      );
    }
    if (filters.startDate != null || filters.endDate != null) {
      chips.add(
        Padding(
          padding: EdgeInsets.only(right: 6),
          child: Chip(
            label: Text(
              "${filters.startDate!.toLocal().toString().split(' ')[0]} to "
              "${filters.endDate!.toLocal().toString().split(' ')[0]}",
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            backgroundColor: Colors.white,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            deleteIcon: Icon(Icons.close, size: 18,),
            onDeleted: onRemoveDate,
          ),
        ),
      );
    }
    if (chips.isEmpty) return const SizedBox();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: chips,),
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
          )
        ],
      ),
    );
  }
}