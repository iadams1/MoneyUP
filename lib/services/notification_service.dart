import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
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
    print("🔔 Notification permission granted: $granted"); //FORCE
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    print("📢 SHOWING NOTIFICATION: $title");

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
}
