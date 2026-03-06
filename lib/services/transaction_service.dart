import 'package:supabase_flutter/supabase_flutter.dart';

import '/services/service_locator.dart';
import '/models/transaction.dart';
import '/models/filter_state.dart';

class TransactionService {
  final SupabaseClient _client = Supabase.instance.client;
  final user = supabaseService.currentUserId!;

  Future<List<Transaction>> fetchTransactions({
      TransactionType? filter,
      FilterState? filters,
    }) async {
    final accountType = filter == TransactionType.credit ? 'credit' : 'depository';
    final response = await _client
        .from('plaid_transactions')
        .select('''
          name,
          amount,
          category,
          authorized_date,
          plaid_accounts!inner(type)
          ''')
        .eq('user_id', user)
        .eq('plaid_accounts.type', accountType)
        .order('authorized_date', ascending: false);

    final rows = List<Map<String, dynamic>>.from(response);
    return rows.map(Transaction.fromJson).toList();
  }

  Future<Map<String, double>> fetchTotals() async {
    final response = await _client
      .from('plaid_accounts')
      .select('type, current_balance, is_active')
      .eq('user_id', user);

    double totalCredit = 0;
    double totalDebit = 0;

    for (final row in response as List) {
      final amount = (row['current_balance'] as num).toDouble();
      final accountType = row['type'];

      if (accountType == 'depository') {
        totalDebit += amount;
      } else if (accountType == 'credit') {
        totalCredit += amount;
      }
    }

    return {
      'credit': totalCredit,
      'debit': totalDebit
    };
  }

  Future<FilterData> fetchFilters(TransactionType? filter) async {
    final accountType = filter == TransactionType.credit ? 'credit' : 'depository';

    final response = await _client
        .from('plaid_transactions')
        .select('''
          category,
          authorized_date,
          plaid_items!inner(institution_name),
          plaid_accounts!inner(type)
        ''')
        .eq('user_id', user)
        .eq('plaid_accounts.type', accountType);
    
    final categories = <String>{};
    final institutions = <String>{};
    final dates = <DateTime>{};
    final rows = List<Map<String, dynamic>>.from(response);

    for (final row in rows) {
      categories.add(row['category'] ?? '');
      institutions.add(row['plaid_items']['institution_name']);
    }

    return FilterData(
      categories: categories.toList()..sort(), 
      institutions: institutions.toList()..sort(), 
      dates: dates.toList()..sort(),
    );
  }
}