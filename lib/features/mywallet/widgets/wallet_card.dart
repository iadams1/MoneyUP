import 'package:flutter/material.dart';

class WalletCard extends StatelessWidget {
  final String bankName;
  final String mask;
  final double currentAmount;
  final String cardholderName;

  const WalletCard({
    super.key,
    required this.bankName,
    required this.mask,
    required this.currentAmount,
    required this.cardholderName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 17, 120, 96),
            Color.fromARGB(255, 0, 0, 0),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
              Text(
                bankName,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 30,
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
            children: [
              // Current Amount
              Text(
                "\$$currentAmount",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                ),
              ),

              // Card Mask
              Text(
                "**** **** **** $mask",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w400,
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
    );
  }
}
