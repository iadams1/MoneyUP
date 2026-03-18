class NotificationItem {
  final dynamic id;
  final String title;
  final String message;
  final DateTime time;
  bool isUnread;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    this.isUnread = true,
  });
}