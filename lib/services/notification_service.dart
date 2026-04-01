import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/timezone.dart' as tz;

import '/models/notification_item.dart';
import '/services/service_locator.dart';

class NotificationService {
  static final SupabaseClient _client = Supabase.instance.client;

  String get user => supabaseService.currentUserId!;

  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  FlutterLocalNotificationsPlugin? _notificationsPlugin;

  Future<void> initialize() async 
  {
    _notificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidInitSettings);

    //FIXED (named parameter)
    await _notificationsPlugin!.initialize(
      settings: initSettings,
    );

    //CREATE NOTIFICATION CHANNEL
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'moneyup_channel',
      'MoneyUP Notifications',
      description: 'Important alerts and updates',
      importance: Importance.max,
    );

    final androidPlugin = _notificationsPlugin!
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(channel);

    //REQUEST PERMISSION (Android 13+)
    final granted = await androidPlugin?.requestNotificationsPermission();
    debugPrint("🔔 Notification permission granted: $granted"); //FORCE
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    if (_notificationsPlugin == null) {
      debugPrint('❌ Notifications plugin not initialized');
      return;
    }
    
    debugPrint("📢 SHOWING NOTIFICATION: $title");

  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails
  (
  'moneyup_channel',
  'MoneyUP Notifications',
  channelDescription: 'Important alerts and updates',
  importance: Importance.max,
  priority: Priority.high,
  playSound: true,
  enableVibration: true,
  ticker: 'ticker',
  fullScreenIntent: true,
  );


    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    // ✅ FIXED (named parameters)
    await _notificationsPlugin?.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
    );
  }

    /// Schedule a notification for a future date/time
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    await _notificationsPlugin?.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'moneyup_channel',
          'MoneyUP Notifications',
          channelDescription: 'Important alerts and updates',
          importance: Importance.max, // HIGH importance ensures it shows
          priority: Priority.high,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

  /// Cancel a specific notification – use NAMED 'id'
  Future<void> cancel(int id) async {
    await _notificationsPlugin?.cancel(id: id);
  }

  /// Cancel all notifications
  Future<void> cancelAll() async {
    await _notificationsPlugin?.cancelAll();
  }

  Future<List<NotificationItem>> fetchNotifications({int? limit}) async {
    var query = _client
      .from('notifications')
      .select('*')
      .eq('user_id', user)
      .order('created_at', ascending: false);

    if (limit != null) {
      query = query.limit(limit);
    }

    final response = await query;

    return (response as List).map((data) => NotificationItem(
      id: data['id'],
      title: data['title'],
      message: data['body'],
      time: DateTime.parse(data['created_at']),
      isUnread: !(data['is_read'] ?? false),
    )).toList();
  }

  Future<void> markAsRead({
      required String notificationId,
      required bool currentIsRead,
    }) async {
    await _client
      .from('notifications')
      .update({'is_read': currentIsRead})
      .eq('id', notificationId)
      .eq('user_id', user);
  }
}