import 'package:flutter/material.dart';

class NoSpendingOverview extends StatelessWidget {

  const NoSpendingOverview({ super.key });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "No transactions recorded for this month. Add spending transactions to get started!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}