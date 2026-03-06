import 'package:flutter/material.dart';
import 'package:moneyup/features/mywallet/widgets/wallet_card.dart';

Widget emptyWalletState() {
  return Column(
    children: [
      SizedBox(
        height: 250,
        child: Center(
          child: WalletCard(
            cardId: 3,
            bankName: "No Card Linked",
            mask: "XXXX",
            currentAmount: 0,
            cardholderName: "Add your first card",
          ),
        ),
      ),

      const SizedBox(height: 50),

      const Text(
        "No cards linked yet",
        style: TextStyle(
          fontSize: 26, 
          fontWeight: FontWeight.w600
        ),
      ),

      const SizedBox(height: 6),

      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Text(
          "Tap the + button to connect a bank account and start tracking your spending.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            height: 1.2,
          ),
        ),
      ),
      const SizedBox(height: 10),
    ],
  );
}
