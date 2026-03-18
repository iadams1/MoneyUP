import 'package:flutter/material.dart';
import 'package:moneyup/models/streak_data.dart';
import 'package:moneyup/services/streak_service.dart';

import '/models/notification_item.dart';
import '/services/notification_service.dart';
import '/shared/widgets/notification_card.dart';
import '/shared/widgets/streak_banner.dart';

class NotificationDialog extends StatefulWidget{
  const NotificationDialog({super.key});

  @override
  State<NotificationDialog> createState() => _NotificationDialogState();
}

class _NotificationDialogState extends State<NotificationDialog> {
  late Future<List<NotificationItem>> _notifications;
  late Future<StreakData> _streak;

  @override
  void initState() {
    super.initState();
    _notifications = NotificationService().fetchNotifications(limit: 2);
    _streak = StreakService().fetchUserStreak();
  }

  void _showAllNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return FutureBuilder<List<NotificationItem>>(
          future: NotificationService().fetchNotifications(), 
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              );
            }
            final all = snapshot.data!;

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      'All Notifications',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    SizedBox(height:10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: all.length,
                        itemBuilder: (_, i) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: NotificationCard(notifItem: all[i]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<StreakData>(
              future: _streak,
              builder: (context, streakSnapshot) {
                if (streakSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  );
                }
                if (!streakSnapshot.hasData) {
                  return SizedBox();
                }
                
                final streaks = streakSnapshot.data!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Streak Status',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    StreakBanner(
                      currentStreak: streaks.currentStreak,
                      longestStreak: streaks.longestStreak,
                      weekLogins: streaks.weekLogins,
                      showLongestStreak: false,
                    ),
                    const SizedBox(height: 10,),
                  ],
                );
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<NotificationItem>>(
                future: _notifications,
                builder: (context, notifSnapshot) {
                  if (notifSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.black
                      ),
                    );
                  }
                  if (notifSnapshot.hasError) {
                    return Center(
                      child: Text('Error: ${notifSnapshot.error}'),
                    );
                  }
                  if (!notifSnapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final notifications = notifSnapshot.data!;
                  print(notifications);
                  if (notifSnapshot.data!.isEmpty) {
                    return Center(
                      child: Text('No notifications'),
                    );
                  }

                  final hasMore = notifications.length == 2;

                  return ListView(
                    children: [
                      ...notifications.map((notif) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: NotificationCard(
                              notifItem: notif,
                              onTap: () async {
                                if (notif.isUnread) {
                                  await NotificationService().markAsRead(notif.id);

                                  setState(() {
                                    notif.isUnread = false;
                                  });
                                }
                              },
                            ),
                          ),
                        );
                      }),
                      if (hasMore)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: GestureDetector(
                          onTap: () => _showAllNotifications(context),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white
                            ),
                            child: Center(
                              child: Text(
                                'See All',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                          ),
                        )
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}