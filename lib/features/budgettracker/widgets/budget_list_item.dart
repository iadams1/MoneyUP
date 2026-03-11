import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:moneyup/features/budgettracker/screens/budget_goaltracker.dart';
import 'package:moneyup/features/budgettracker/utils/category_colors.dart';
import 'package:moneyup/models/budget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class BudgetListItem extends StatelessWidget {
  final Budget budget;
  final void Function(BuildContext context, dynamic budgetId) confirmDelete;
  final Future<void> Function() onUpdated;

  const BudgetListItem({
    super.key,
    required this.budget,
    required this.confirmDelete,
    required this.onUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final String title = budget.title;
    final double saved = budget.amountSaved;
    final double needed = budget.amountNeeded;
    final double percent = budget.percentComplete;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: Slidable(
        key: ValueKey(budget.budgetId),
        startActionPane: ActionPane(
          motion: const BehindMotion(),
          extentRatio: 0.20,
          dragDismissible: false,
          children: [
            SlidableAction(
              onPressed: (_) =>
                  confirmDelete(context, budget.budgetId),
              icon: Icons.delete,
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            color: Colors.white,
            child: Row(
              children: [
                // Progress Indicator
                SizedBox(
                  height: 90,
                  width: 90,
                  child: CircularPercentIndicator(
                    radius: 28,
                    lineWidth: 9,
                    percent: percent,
                    backgroundColor:
                        const Color.fromARGB(6, 227, 50, 50),
                    progressColor:
                        getCategoryColor(budget.categoryId),
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                ),

                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "\$${saved.toStringAsFixed(2)} Saved",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "\$${needed.toStringAsFixed(2)} Needed",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(107, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                ),

                IconButton(
                  icon: Image.asset(
                    'assets/icons/chevronRightArrow.png',
                  ),
                  onPressed: () async {
                    final didUpdate = await Navigator.push<bool>(context, MaterialPageRoute (
                      builder: (_) => BudgetPage (
                        budgetId: budget.budgetId,
                        categoryId: budget.categoryId,
                      ),
                    ),
                  );

                  if (didUpdate == true) {
                    await onUpdated();
                  }
                  },
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
