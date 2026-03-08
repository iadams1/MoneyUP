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
    List<Widget> chips = [];
    if (!filters.hasFilters) return const SizedBox();

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

            //deleteIcon: Icon(Icons.close, size: 18),
            //onDeleted: () => onRemoveBank(bank),
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

            //deleteIcon: Icon(Icons.close, size: 18),
            //onDeleted: () => onRemoveBank(bank),
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
              "From ${filters.startDate!.toLocal().toString().split(' ')[0]} To ${filters.endDate!.toLocal().toString().split(' ')[0]}",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
              side: BorderSide(color: Colors.transparent),
            ),
            backgroundColor: const Color.fromARGB(255, 225, 225, 225),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,

            //deleteIcon: Icon(Icons.close, size: 18),
            //onDeleted: () => onRemoveBank(bank),
          ),
        ),
      );
    }
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
          // TextButton(onPressed: onClearAll, child: const Text("Clear Filters")),
        ],
      ),
    );
  }
}
