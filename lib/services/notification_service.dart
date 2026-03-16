import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static FlutterLocalNotificationsPlugin? _notificationsPlugin;

  // Android notification channel
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'moneyup_channel',
    'MoneyUP Notifications',
    description: 'Important alerts and updates from MoneyUP',
    importance: Importance.high,
    playSound: true,
  );

Future<void> initialize() async {
  _notificationsPlugin = FlutterLocalNotificationsPlugin();

  // Initialize timezone
  tz.initializeTimeZones();

  // Android init settings
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // iOS settings
  const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  const InitializationSettings initSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  // Initialize plugin
  await _notificationsPlugin!.initialize(
    settings: initSettings,
    onDidReceiveNotificationResponse: _onNotificationTap,
  );

  // Create Android notification channel
  await _notificationsPlugin!
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(_channel);
}

  // Handle notification tap (when app opens from notification)
  static void _onNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    print('Notification tapped with payload: $payload');
    // Add navigation logic later if needed (e.g., deep link handling)
  }

  /// Show an instant notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'moneyup_channel',
      'MoneyUP Notifications',
      channelDescription: 'Important alerts and updates',
      importance: Importance.max, // HIGH importance ensures it shows in foreground
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);

    await _notificationsPlugin?.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
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
}