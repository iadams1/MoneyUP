import 'package:flutter/material.dart';

import '/features/budgettracker/widgets/budget_list_item.dart';
import '/models/budget.dart';

class BudgetListingView extends StatelessWidget {
  final List<Budget> budgets;
  final void Function(BuildContext context, dynamic budgetId) confirmDelete;
  final Future<void> Function() onUpdated;

  const BudgetListingView({
    super.key,
    required this.budgets,
    required this.confirmDelete,
    required this.onUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: budgets.length,
        itemBuilder: (context, index) {
          return BudgetListItem(
            budget: budgets[index],
            confirmDelete: confirmDelete,
            onUpdated: onUpdated,
          );
        },
      ),
    );
  }
}
