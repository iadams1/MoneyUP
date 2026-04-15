import 'package:flutter/material.dart';
import 'package:moneyup/models/linked_card.dart';
import 'package:moneyup/services/service_locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyWalletService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Current logged-in user ID
  String? get user => supabaseService.currentUserId;

  /// Fetch all linked cards for the current user
  Future<List<LinkedCard>> fetchLinkedCards() async {
    final currentUser = user;
    if (currentUser == null) return [];

    final rows = await _client
        .from('plaid_accounts')
        .select('''
          account_id, 
          name, 
          mask, 
          type, 
          available_balance, 
          current_balance, 
          credit_limit, 
          plaid_items!left(institution_name), 
          profiles!left(full_name),
          is_active, 
          card_color
        ''')
        .eq('user_id', currentUser);

    return rows
        .map((r) => LinkedCard.fromMap(r))
        .toList();
  }

  /// Fetch the primary (first) linked card
  Future<LinkedCard?> fetchPrimaryCard() async {
    final cards = await fetchLinkedCards();
    return cards.isNotEmpty ? cards.first : null;
  }

  /// Soft-delete a card account (mark as inactive)
  Future<void> deleteCardAccount({required String accountId}) async {
    final currentUser = user;
    if (currentUser == null) return;

    try {
      await _client
          .from('plaid_accounts')
          .update({'is_active': false})
          .eq('account_id', accountId)
          .eq('user_id', currentUser);

      debugPrint('✅ Card marked as inactive successfully');
    } catch (error, stack) {
      debugPrint('❌ Error deleting card: $error\n$stack');
      rethrow;
    }
  }
}