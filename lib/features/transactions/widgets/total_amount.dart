import 'package:flutter/material.dart';

import '/core/utils/formatters.dart';
import '/models/transaction.dart';

class TotalAmountView extends StatelessWidget {
  final TransactionType selectedFilter;
  final double totalDebit;
  final double totalCredit;
  final double availableCredit;

  const TotalAmountView({
    super.key,
    required this.selectedFilter,
    required this.totalDebit,
    required this.totalCredit,
    required this.availableCredit,
  });

  @override
  Widget build(BuildContext context) {
    final isDebit = selectedFilter == TransactionType.debit;
    final isCredit = selectedFilter == TransactionType.credit;
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
        if (isCredit) ...[
          Text(
            '${Formatters.currency(availableCredit)} Total Available Credit',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: const Color.fromARGB(114, 255, 255, 255),
            ),
          ),
          SizedBox(height: 20),
        ],
      ],
    );
  }
}