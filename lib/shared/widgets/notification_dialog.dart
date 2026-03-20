import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '/models/streak_data.dart';
import '/models/notification_item.dart';
import '/services/notification_service.dart';
import '/services/streak_service.dart';
import '/shared/widgets/notification_card.dart';
import '/shared/widgets/streak_banner.dart';

class NotificationDialog extends StatefulWidget{
  const NotificationDialog({super.key});

  @override
  State<NotificationDialog> createState() => _NotificationDialogState();
}

class _NotificationDialogState extends State<NotificationDialog> {
  late Future<StreakData> _streak;
  late Future<List<NotificationItem>> _allNotifications;
  bool _showSeeAll = false;

  @override
  void initState() {
    super.initState();
    _allNotifications = NotificationService().fetchNotifications();
    _streak = StreakService().fetchUserStreak();
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
                future: _allNotifications,
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

                  if (notifSnapshot.data!.isEmpty) {
                    return Center(
                      child: Text('No recent notifications'),
                    );
                  }
                  final preview = notifications.take(2).toList();
                  final hasMore = notifications.length > 2;
                  final allNotifications = notifSnapshot.data!;
                  final visible = _showSeeAll ? allNotifications : preview;

                  return ListView(
                    children: [
                      ...visible.map((notif) {
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
                            onTap: () {
                              setState(() {
                                _showSeeAll = !_showSeeAll;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  colors: [HexColor('#124074'), HexColor('#332677')],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  _showSeeAll ? 'Show Less' : 'See All',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white
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