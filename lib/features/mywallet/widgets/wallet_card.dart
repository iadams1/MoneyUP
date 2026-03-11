import 'package:flutter/material.dart';
import 'package:moneyup/core/utils/formatters.dart';
import 'package:moneyup/shared/utils/card_gradients.dart';

class WalletCard extends StatelessWidget {
  final int? cardId;

  final String bankName;
  final String mask;
  final double currentAmount;
  final String cardholderName;

  const WalletCard({
    super.key,
    this.cardId,
    required this.bankName,
    required this.mask,
    required this.currentAmount,
    required this.cardholderName,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = CardGradients.gradientForCardId(cardId!);

    return Padding(
      padding: EdgeInsets.fromLTRB(8, 8, 8, 25),
      child: Container(
        width: 340,
        height: 200,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: gradient,
          boxShadow: [
            const BoxShadow(
              color: Color.fromARGB(65, 0, 0, 0),
              offset: Offset(0, 8),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // BankName with card symbol
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    bankName,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 25,
                    ),
                  ),
                ),

                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.all(5),
                  child: Image.asset('assets/icons/cardReader.png'),
                ),
              ],
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current Amount
                SizedBox(height: 24),

                Text(
                  Formatters.currency(currentAmount),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                // Card Mask
                Text(
                  "****  ****  ****  $mask",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            // Users Full Name
            Text(
              cardholderName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
