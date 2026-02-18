import 'package:flutter/material.dart';

import '/features/budgettracker/screens/budget_home.dart';

class NoBudgetView extends StatelessWidget {

  const NoBudgetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "No budgets available yet.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
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
                  "Create a Budget",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}