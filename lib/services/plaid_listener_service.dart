// lib/services/plaid_listener_service.dart
import 'package:flutter/material.dart';
import 'package:plaid_flutter/plaid_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moneyup/services/supabase_service.dart';

class PlaidListenerService {
  static final PlaidListenerService _instance =
      PlaidListenerService._internal();
  factory PlaidListenerService() => _instance;
  PlaidListenerService._internal();

  bool _initialized = false;
  VoidCallback? onSuccess;

  void init() {
    if (_initialized) return;
    _initialized = true;

    PlaidLink.onSuccess.listen((success) async {
      debugPrint('Global onSuccess fired: ${success.publicToken}');
      await _handleSuccess(success);
    });

    PlaidLink.onExit.listen((exit) {
      debugPrint('Plaid exited: ${exit.error?.message}');
    });

    PlaidLink.onEvent.listen((event) {
      debugPrint('Plaid event: ${event.name}');
    });
  }

  Future<void> _handleSuccess(LinkSuccess success) async {
    try {
      final supabase = Supabase.instance.client;
      final token = supabase.auth.currentSession?.accessToken;
      if (token == null) throw Exception('Not signed in');

      final response = await supabase.functions
          .invoke(
            'exchange-public-token',
            body: {'public_token': success.publicToken},
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 30));

      debugPrint('Exchange response: ${response.data}');

      if (response.status != 200)
        throw Exception('Exchange failed: ${response.status}');

      final data = response.data as Map<String, dynamic>;
      if (data['success'] != true)
        throw Exception(data['error'] ?? 'Exchange failed');

      await SupabaseService().syncAll();

      final userId = supabase.auth.currentUser?.id;
      if (userId != null) {
        await supabase
            .from('profiles')
            .update({'has_plaid_connected': true})
            .eq('id', userId);
      }

      debugPrint('Plaid connected and synced successfully');
      onSuccess?.call();
    } catch (e) {
      debugPrint('Plaid exchange error: $e');
    }
  }
}
