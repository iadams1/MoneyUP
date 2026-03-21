import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'notification_service.dart';

class RealtimeNotificationService {
  final _supabase = Supabase.instance.client;

  void startListening(String userId) {
    debugPrint("📡 Starting realtime listener for user: $userId");

    final channel = _supabase.channel('notifications_channel');

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) 
          {
            debugPrint("📩 REALTIME EVENT RECEIVED");
            debugPrint("📦 Payload: ${payload.newRecord}");

            final data = payload.newRecord;

            NotificationService().showNotification
            (
              id: DateTime.now().millisecondsSinceEpoch % 2147483647,

              title: data['title'] ?? 'No Title',
              body: data['body'] ?? 'No Body',
            );
          },
        )
        .subscribe((status, [error]) {
          debugPrint("📡 SUB STATUS: $status");

          if (error != null) {
            debugPrint("❌ REALTIME ERROR: $error");
          }

          if (status == RealtimeSubscribeStatus.subscribed) {
            debugPrint("✅ REALTIME CONNECTED");
          }
        });
  }
}
