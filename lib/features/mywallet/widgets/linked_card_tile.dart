import 'package:flutter/material.dart';
import 'package:moneyup/models/linked_card.dart';
import 'package:moneyup/shared/utils/card_gradients.dart';

class LinkedCardTile extends StatelessWidget {
  final LinkedCard card;
  final int cardId;

  final VoidCallback onDelete;

  const LinkedCardTile({
    super.key,
    required this.card,
    required this.cardId,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
      padding: const EdgeInsets.fromLTRB(0, 2.5, 0, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Card design
          Container(
            width: 80,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: CardGradients.gradientForCardId(cardId),
            ),
          ),

          const SizedBox(width: 20),

          // CardHolders information
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  card.accountName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                  ),
                ),

                Text(
                  "**** **** **** ${card.mask}",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),

          const SizedBox(width: 20),

          // Delete button
          SizedBox(
            height: 35,
            child: OutlinedButton(
              onPressed: onDelete,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(200),
                ),
                side: BorderSide(
                  width: 2,
                  color: Colors.black,
                  style: BorderStyle.solid,
                ),
              ),
              child: SizedBox(
                width: 100,
                height: 25,
                child: Center(
                  child: Text(
                    "Delete",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
