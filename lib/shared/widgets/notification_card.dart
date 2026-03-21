import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneyup/core/utils/date_helper.dart';
// import 'package:moneyup/services/notification_service.dart';

import '/models/notification_item.dart';

class NotificationCard extends StatelessWidget {
  final NotificationItem notifItem;
  final VoidCallback? onTap;
  const NotificationCard({super.key, required this.notifItem, this.onTap});

  @override
  Widget build(BuildContext context) {
    final formatedDate = DateFormat('yyyy-MM-dd').format(notifItem.time);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                blurRadius: 12,
                offset: Offset(0, 6),
                color: const Color.fromARGB(40, 0, 0, 0),
              ),
            ],
          ),
          // NOTIFICATION CARD HEIGHT & WIDTH
          width: 380,
          child: Padding(
            padding: EdgeInsetsGeometry.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                  child: notifItem.isUnread
                      ? Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        )
                      : null,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Expanded(
                          child: Text(
                            notifItem.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        notifItem.message,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 15.5,
                          color: Colors.black,
                          height: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
                        child: Text(
                          DateHelper.formatReadable(formatedDate),
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(117, 0, 0, 0),
                          ),
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
