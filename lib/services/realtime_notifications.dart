import 'package:supabase_flutter/supabase_flutter.dart';
import 'notification_service.dart';

class RealtimeNotificationService {

  final _supabase = Supabase.instance.client;

  void startListening(String userId) {

    _supabase
        .channel('notifications_channel')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) {

            final data = payload.newRecord;

            NotificationService().showNotification(
              id: DateTime.now().millisecondsSinceEpoch,
              title: data['title'],
              body: data['body'],
            );

          },
        )
        .subscribe();
  }
}
