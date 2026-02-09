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
  /// Sync accounts + transactions (most common use)
  Future<void> syncAll() async {
    await _client.functions.invoke('sync-plaid-accounts', body: {});
    await _client.functions.invoke('sync-plaid-transactions', body: {});
  }

  /// Sync only transactions (cursor-based)
  Future<void> syncTransactions({String? itemId}) async {
    final body = itemId != null ? {'item_id': itemId} : {};
    await _client.functions.invoke('sync-plaid-transactions', body: body);
  }

  /// Sync only accounts (balances)
  Future<void> syncAccounts({String? itemId}) async {
    final body = itemId != null ? {'item_id': itemId} : {};
    await _client.functions.invoke('sync-plaid-accounts', body: body);
  }

}