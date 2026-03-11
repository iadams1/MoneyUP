
import 'package:flutter/material.dart';
import 'package:moneyup/features/budgettracker/screens/budget_home.dart';
import 'package:moneyup/models/budget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class BudgetView extends StatelessWidget{
  final Budget budget;
  const BudgetView({super.key, required this.budget});

  @override
  Widget build(BuildContext context) {
    final percent = budget.goal <= 0
        ? 0.0
        : (budget.amountSaved / budget.goal).clamp(0.0, 1.0);

    return Row(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 140,
              height: 140,
              child: CircularPercentIndicator(
                radius: 60,
                lineWidth: 18,
                percent: percent,
                center: Text(
                  "${(percent * 100).toStringAsFixed(0)}%",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                  ),
                ),
                backgroundColor: const Color.fromARGB(6, 0, 0, 0),
                progressColor: const Color.fromRGBO(47, 52, 126, 1),
                circularStrokeCap: CircularStrokeCap.round,
              ),
            ),
          ],
        ),
        const SizedBox(width: 30),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                budget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(200),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(builder: (_) => const BudgetGoalPage()),
                  );
                },
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromRGBO(25, 50, 100, 1),
                        Color.fromRGBO(47, 52, 126, 1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(200),
                  ),
                  child: const SizedBox(
                    width: 220,
                    height: 40,
                    child: Center(
                      child: Text(
                        "See All",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}