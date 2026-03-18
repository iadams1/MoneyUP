import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:moneyup/services/notification_service.dart';

import '/models/notification_item.dart';

class NotificationCard extends StatelessWidget{
  final NotificationItem notifItem;
  final VoidCallback? onTap;
  const NotificationCard({super.key, required this.notifItem, this.onTap});

  @override
  Widget build(BuildContext context) {
    final formatedDate = DateFormat(
      'yyyy-MM-dd',
    ).format(notifItem.time);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: notifItem.isUnread
              ? Colors.grey.withValues(alpha: .5)
              : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color.fromRGBO(69, 90, 100, 1),
              width: 2.0,
            ),
            // boxShadow: [
            //   BoxShadow(
            //     color: Color.fromARGB(10, 0, 0, 0),
            //     spreadRadius: 0,
            //     blurRadius: 9,
            //     offset: Offset(0, 8),
            //   ),
            // ],
          ),
          // NOTIFICATION CARD HEIGHT & WIDTH
          height: 75,
          width: 380,
          child: Padding(
            padding: EdgeInsetsGeometry.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notifItem.title,
                          style: TextStyle(
                            fontWeight: notifItem.isUnread
                              ? FontWeight.bold
                              : FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Text(
                        notifItem.message,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ), 
                      Text(
                        formatedDate,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
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