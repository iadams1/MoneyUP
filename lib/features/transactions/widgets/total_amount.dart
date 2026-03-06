import 'package:flutter/material.dart';

import '/core/utils/formatters.dart';
import '/models/transaction.dart';

class TotalAmountView extends StatelessWidget {
  final TransactionType selectedFilter;
  final double totalDebit;
  final double totalCredit;

  const TotalAmountView({
    super.key,
    required this.selectedFilter,
    required this.totalDebit,
    required this.totalCredit,
  });

  @override
  Widget build(BuildContext context) {
    final isDebit = selectedFilter == TransactionType.debit;
    final amount = isDebit ? totalDebit : totalCredit;
    final title = isDebit ? 'Total Debit Balance' : 'Total Current Credit';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        Text(
          Formatters.currency(amount),
          style: TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}