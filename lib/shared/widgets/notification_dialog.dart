import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import '/models/streak_data.dart';
import '/models/notification_item.dart';
import '/services/notification_service.dart';
import '/services/streak_service.dart';
import '/shared/widgets/notification_card.dart';
import '/shared/widgets/streak_banner.dart';

class NotificationDropdown extends StatefulWidget {
  const NotificationDropdown({super.key});

  @override
  State<NotificationDropdown> createState() => _NotificationDropdownState();
}

class _NotificationDropdownState extends State<NotificationDropdown> {
  late Future<StreakData> _streak;
  late Future<List<NotificationItem>> _allNotifications;
  bool _showSeeAll = false;

  double _dragOffsetY = 0;

  @override
  void initState() {
    super.initState();
    _allNotifications = NotificationService().fetchNotifications();
    _streak = StreakService().fetchUserStreak();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffsetY += details.delta.dy;

      // only allow dragging upward
      if (_dragOffsetY > 0) {
        _dragOffsetY = 0;
      }
    });
  }

  void _onDragEnd(DragEndDetails details) {
    const double closeThreshold = -80;

    if (_dragOffsetY <= closeThreshold) {
      Navigator.pop(context);
    } else {
      setState(() {
        _dragOffsetY = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Material(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.topCenter,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            transform: Matrix4.translationValues(0, _dragOffsetY, 0),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 700),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 16,
                    color: Color.fromARGB(47, 0, 0, 0),
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.5),
                child: Column(
                  children: [
                    const SizedBox(height: 60),
      
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: Text(
                        'Notification Dashboard',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
      
                    FutureBuilder<StreakData>(
                      future: _streak,
                      builder: (context, streakSnapshot) {
                        if (streakSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(color: Colors.black),
                          );
                        }
      
                        if (!streakSnapshot.hasData) {
                          return const SizedBox();
                        }
      
                        final streaks = streakSnapshot.data!;
      
                        return StreakBanner(
                          currentStreak: streaks.currentStreak,
                          longestStreak: streaks.longestStreak,
                          weekLogins: streaks.weekLogins,
                          showLongestStreak: false,
                        );
                      },
                    ),
      
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                      child: Center(
                        child: Text(
                          'Recent Notifications',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(75, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
      
                    Expanded(
                      child: FutureBuilder<List<NotificationItem>>(
                        future: _allNotifications,
                        builder: (context, notifSnapshot) {
                          if (notifSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            );
                          }
      
                          if (notifSnapshot.hasError) {
                            return Center(
                              child: Text('Error: ${notifSnapshot.error}'),
                            );
                          }
      
                          if (!notifSnapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
      
                          final notifications = notifSnapshot.data!;
      
                          if (notifications.isEmpty) {
                            return const Center(
                              child: Text('No recent notifications'),
                            );
                          }
      
                          final preview = notifications.take(2).toList();
                          final hasMore = notifications.length > 2;
                          final visible = _showSeeAll ? notifications : preview;
      
                          return ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              ...visible.map((notif) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 7,
                                    horizontal: 16,
                                  ),
                                  child: NotificationCard(
                                    notifItem: notif,
                                    onTap: () async {
                                      if (notif.isUnread) {
                                        await NotificationService().markAsRead(
                                          notificationId: notif.id, currentIsRead: null,
                                        );
      
                                        setState(() {
                                          notif.isUnread = false;
                                        });
                                      }
                                    },
                                  ),
                                );
                              }),
                              if (hasMore)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 10,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _showSeeAll = !_showSeeAll;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        gradient: LinearGradient(
                                          colors: [
                                            HexColor('#124074'),
                                            HexColor('#332677'),
                                          ],
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          _showSeeAll ? 'Show Less' : 'See All',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
      
                    const SizedBox(height: 12),
      
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onVerticalDragUpdate: _onDragUpdate,
                      onVerticalDragEnd: _onDragEnd,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Center(
                          child: Container(
                            width: 44,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
