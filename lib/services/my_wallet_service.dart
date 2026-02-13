import 'package:flutter/material.dart';
import 'package:moneyup/models/linked_card.dart';
import 'package:moneyup/services/service_locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyWalletService {
  final SupabaseClient _client = Supabase.instance.client;

  final user = supabaseService.currentUserId!;
  
  Future<List<LinkedCard>> fetchLinkedCards() async {
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
          is_active
        ''')
        .eq('user_id', user);

    return (rows as List)
        .map((r) => LinkedCard.fromMap(r as Map<String, dynamic>))
        .toList();
  }

  Future<LinkedCard?> fetchPrimaryCard() async {
    final cards = await fetchLinkedCards();
    if (cards.isEmpty) return null;
    return cards.first;
  }

  Future<void> deleteCardAccount({required dynamic accountId}) async {
    try {
      await _client
        .from('plaid_accounts')
        .update({
          'is_active': false,
        })
        .eq('account_id', accountId)
        .eq('user_id', user);
      
      debugPrint('Deletion was successful!');
    } catch (error) {
      debugPrint('Error Deleting rows: $error');
        rethrow;
    }
  }
}