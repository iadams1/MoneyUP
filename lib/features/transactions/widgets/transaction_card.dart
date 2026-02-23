import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/models/transaction.dart';
import '/features/transactions/widgets/category_color.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final formatedDate = DateFormat('yyyy-MM-dd').format(transaction.authorizedDate);
    final formattedAmount = NumberFormat.currency(symbol: '\$').format(transaction.amount);
    final categoryColor = categoryColors[transaction.category] ?? defaultColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.black,
              width: 2.0
            )
          ),
          height: 85,
          width: 380,
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsetsGeometry.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Transaction Icon
                Container(
                  height: 60,
                  width: 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade200,
                    border: Border.all(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.grey,
                  )
                ),
                const SizedBox(width: 14,),
                Expanded( // MERCHANT NAME AND AUTHORIZED DATE
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        formatedDate,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  )
                ),
                // CATEGORY BOX
                SizedBox(
                width: 110,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: categoryColor.backgroundColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      transaction.category,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: categoryColor.textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                // SHOWS MONEY SPENT
                SizedBox(
                  width: 70,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      formattedAmount,
                      style:TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}