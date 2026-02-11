import 'package:flutter/material.dart';
import 'package:moneyup/models/linked_card.dart';
import 'package:moneyup/services/service_locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyWalletService {
  final SupabaseClient _client = Supabase.instance.client;

  final user = supabaseService.currentUserId!;
  
  Future<List<LinkedCard>> fetchLinkedCards() async {
    debugPrint("currentUser: $user");
    debugPrint("currentSession: ${_client.auth.currentSession != null}");
    final rows = await _client
        .from('plaid_accounts') // <-- your table
        .select('''
          account_id, 
          name, 
          mask, 
          type, 
          available_balance, 
          current_balance, 
          credit_limit, 
          plaid_items!left(institution_name), 
          profiles!left(full_name)
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
}