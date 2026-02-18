import 'package:flutter/material.dart';

class NoTransactionView extends StatelessWidget{
  const NoTransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 10,),
          Text(
            'No Transactions Yet',
            style: TextStyle(
              fontFamily: 'SF Pro',
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }
}