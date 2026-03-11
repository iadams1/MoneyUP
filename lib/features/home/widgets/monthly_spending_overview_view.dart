import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:moneyup/core/utils/formatters.dart';
import 'package:moneyup/features/budgettracker/utils/category_colors.dart';

class MonthlySpendingOverviewView extends StatelessWidget {
  final Map<int, double> spendingData;
  final Map<int, String> categoryTitles;

  const MonthlySpendingOverviewView({
    super.key,
    required this.spendingData,
    required this.categoryTitles,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Title
        Text(
          "Your Monthly Spending Overview",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
        ),

        const SizedBox(height: 5),

        Row(
          children: [
            // Legend
            Container(
              width: 220,
              color: Colors.transparent,
              child: Column(
                children: spendingData.keys.map((categoryId) {
                  final categoryTitle = categoryTitles[categoryId] ?? "Unknown";
                  final amount = spendingData[categoryId] ?? 0.0;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: SizedBox(
                      width: 250,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        child: Row(
                          children: [
                            // Title side
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 9,
                                    height: 9,
                                    margin: const EdgeInsets.only(top: 3),
                                    decoration: BoxDecoration(
                                      color: getCategoryColor(categoryId),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      categoryTitle,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Text(
                              Formatters.currency(amount),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              flex: 2,
              child: SizedBox(
                height: 120,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 3,
                    centerSpaceRadius: 42,
                    sections: spendingData.entries.map((e) {
                      return PieChartSectionData(
                        value: e.value.abs(),
                        color: getCategoryColor(e.key),
                        radius: 13,
                        titleStyle: const TextStyle(
                          color: Color.fromARGB(0, 0, 0, 0),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
