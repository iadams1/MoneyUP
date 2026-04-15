import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  /* 
  ====================================
    AUTH SECTION
  ====================================
  */
  String? get currentUserId {
    return _client.auth.currentUser?.id;
  }

  bool get isAuthenticated {
    return _client.auth.currentUser != null;
  }

  /*
  ====================================
    DATABASE SECTION
  ====================================
  */

  /// Sync accounts + transactions in the correct order (Recommended)
  /// This is the main method you should call most of the time
  Future<void> syncAll() async {
    try {
      final response = await _client.functions.invoke(
        'sync-plaid-data',
         // You can pass item_id later if you want to sync only one account
      );

      print('sync-plaid-data completed successfully');
      print('Response: ${response.data}');
    } catch (e) {
      print('sync-plaid-data failed: $e');
      rethrow; // Let the caller handle the error if needed
    }
  }

  /// Sync only transactions (cursor-based) - kept for backward compatibility
  Future<void> syncTransactions({String? itemId}) async {
    try {
      final body = itemId != null ? {'item_id': itemId} : {};
      final response = await _client.functions.invoke(
        'sync-plaid-transactions',
        body: body,
      );

      print('syncTransactions completed');
      print('Response: ${response.data}');
    } catch (e) {
      print('syncTransactions failed: $e');
      rethrow;
    }
  }

  /// Sync only accounts (balances) - kept for backward compatibility
  Future<void> syncAccounts({String? itemId}) async {
    try {
      final body = itemId != null ? {'item_id': itemId} : {};
      final response = await _client.functions.invoke(
        'sync-plaid-accounts',
        body: body,
      );

      print('syncAccounts completed');
      print('Response: ${response.data}');
    } catch (e) {
      print('syncAccounts failed: $e');
      rethrow;
    }
  }

  /// Optional: New method for full sync with better error handling
  Future<Map<String, dynamic>?> syncAllWithResult() async {
    try {
      final response = await _client.functions.invoke(
        'sync-plaid-data',
        body: {},
      );

      print('Full sync completed');
      return response.data as Map<String, dynamic>?;
    } catch (e) {
      print('Full sync failed: $e');
      return null;
    }
  }
}