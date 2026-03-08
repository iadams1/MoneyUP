import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/core/utils/formatters.dart';
import '/models/transaction.dart';
import '/features/transactions/widgets/category_color.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final formatedDate = DateFormat(
      'yyyy-MM-dd',
    ).format(transaction.authorizedDate);
    final formattedAmount = NumberFormat.currency(
      symbol: '\$',
    ).format(transaction.amount);
    final categoryColor = categoryColors[transaction.category] ?? defaultColor;
    final isNegative = transaction.amount < 0;
    final amountColor = isNegative
        ? const Color.fromARGB(255, 150, 41, 41)
        : const Color.fromARGB(255, 32, 133, 47);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),

            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(10, 0, 0, 0),
                spreadRadius: 0,
                blurRadius: 9,
                offset: Offset(0, 8),
              ),
            ],
          ),
          // TRANSACTION CARD HEIGHT & WIDTH
          height: 75,
          width: 380,
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsetsGeometry.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // TRANSACTION ICON
                Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color.fromARGB(255, 219, 219, 219),
                    boxShadow: [
                      const BoxShadow(
                        color: Color.fromARGB(31, 0, 0, 0),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  // MERCHANT NAME AND AUTHORIZED DATE
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        formatedDate,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                // CATEGORY BOX
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 13),
                    SizedBox(
                      width: 95,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: categoryColor.backgroundColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          Formatters.category(transaction.category),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: categoryColor.textColor,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                // SHOWS MONEY SPENT
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 12),
                    SizedBox(
                      width: 80,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          formattedAmount,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: amountColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
