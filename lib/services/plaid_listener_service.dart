import 'package:flutter/material.dart';
import 'package:moneyup/services/supabase_service.dart';
import 'package:plaid_flutter/plaid_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'package:moneyup/main.dart';
import 'package:moneyup/shared/widgets/bank_connection_banner.dart';

class PlaidListenerService {
  static final PlaidListenerService _instance =
      PlaidListenerService._internal();
  factory PlaidListenerService() => _instance;
  PlaidListenerService._internal();

  bool _initialized = false;

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
      debugPrint('Exchange response type: ${response.data.runtimeType}');

      if (response.status != 200) {
        throw Exception('Exchange failed: ${response.status}');
      }

      final rawData = response.data;
      final Map<String, dynamic> data =
          rawData is String ? jsonDecode(rawData) as Map<String, dynamic>
                            : Map<String, dynamic>.from(rawData as Map);

      if (data['success'] != true) {
        throw Exception(data['error'] ?? 'Exchange failed');
      }

      await SupabaseService().syncAll();

      final userId = supabase.auth.currentUser?.id;
      if (userId != null) {
        await supabase
            .from('profiles')
            .update({'has_plaid_connected': true})
            .eq('id', userId);
      }

      debugPrint('Plaid connected and synced successfully');
      debugPrint('About to fire onSuccess callback');

      final navigator = appNavigatorKey.currentState;
      final overlayContext = navigator?.overlay;

      if (navigator == null || overlayContext == null) {
        debugPrint('No valid navigator or overlay context available');
        return;
      }

      debugPrint('Launching banner UI...');
      BankConnectionSuccessBanner.showBankConnectionSuccessBanner(overlayContext);

      navigator.pushNamedAndRemoveUntil('/home', (route) => false);
    } catch (e) {
      debugPrint('Plaid exchange error: $e');
    }
  }
}