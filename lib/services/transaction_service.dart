import 'package:supabase_flutter/supabase_flutter.dart';

import '/services/service_locator.dart';
import '/models/transaction.dart';
import '/models/filter_state.dart';

class TransactionService {
  final SupabaseClient _client = Supabase.instance.client;

  String get user => supabaseService.currentUserId!;

  Future<List<Transaction>> fetchTransactions({
      TransactionType? filter,
      FilterState? filters,
    }) async {
    final accountType = filter == TransactionType.credit ? 'credit' : 'depository';
    var query = _client
        .from('plaid_transactions')
        .select('''
          name,
          amount,
          category,
          authorized_date,
          plaid_accounts!inner(type, is_active),
          plaid_items!inner(institution_name)
          ''')
        .eq('user_id', user)
        .eq('plaid_accounts.type', accountType)
        .eq('plaid_accounts.is_active', true);

    if (filters != null) {
      if (filters.selectedCategories.isNotEmpty) {
        query = query.inFilter('category', filters.selectedCategories.toList());
      }
      if (filters.selectedBanks.isNotEmpty) {
        query = query.inFilter(
          'plaid_items.institution_name',
          filters.selectedBanks.toList(),
        );
      }
      if (filters.startDate != null) {
        query = query.gte(
          'authorized_date',
          filters.startDate!.toIso8601String(),
        );
      }
      if (filters.endDate != null) {
        query = query.lte(
          'authorized_date',
          filters.endDate!.toIso8601String(),
        );
      }
    }
    
    final response = await query.order('authorized_date', ascending: false);
    final rows = List<Map<String, dynamic>>.from(response);
    return rows.map(Transaction.fromJson).toList();
  }

  Future<Map<String, double>> fetchTotals({
    List<String>? bankName,
    String? type,
  }) async {
    
    var query = _client
      .from('plaid_accounts')
      .select('''
            type, 
            available_balance,
            plaid_items!inner(institution_name), 
            is_active''')
      .eq('user_id', user)
      .eq('is_active', true);

    if (type != null && type.isNotEmpty) {
      query = query.eq('type', type);
    }

    if (bankName != null && bankName.isNotEmpty) {
      query = query.inFilter('plaid_items.institution_name', bankName);
    }

    final response = await query;

    double totalCredit = 0;
    double totalDebit = 0;

    for (final row in response as List) {
      double parseBalance(dynamic value) {
        if (value == null) return 0.0;
        if (value is num) return value.toDouble();
        return double.tryParse(value.toString()) ?? 0.0;
      }
      final amount = parseBalance(row['current_balance']);
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

  Future<FilterData> fetchFilters(
    TransactionType? filter, 
    FilterState? filters, {
    List<String>? bankNames,
    String? category,
  }) async {
    
    final accountType = filter == TransactionType.credit ? 'credit' : 'depository';
    
    final transactions = await fetchTransactions(
      filter: filter,
      filters: filters,
    );

    final categories = <String>{};
    final institutions = <String>{};
    final dates = <DateTime>{};

    for (final t in transactions) {
      categories.add(t.category);
      dates.add(t.authorizedDate);
    }

    final response = await _client
        .from('plaid_transactions')
        .select('''
          category,
          plaid_items!inner(institution_name),
          plaid_accounts!inner(type, is_active)
        ''')
        .eq('user_id', user)
        .eq('plaid_accounts.type', accountType)
        .eq('plaid_accounts.is_active', true);

    // final categories = <String>{};
    // final institutions = <String>{};

    final rows = List<Map<String, dynamic>>.from(response);

    for (final row in rows) {
      final category = row['category'];
      final instituion = row['plaid_items']?['institution_name'];
      
      if (category != null && category.isNotEmpty) {
        categories.add(category);
      }
      if (instituion != null && instituion.isNotEmpty) {
        institutions.add(instituion);
      }
    }

    fetchTotals(bankName: bankNames, type: accountType);

    return FilterData(
      categories: categories.toList()..sort(), 
      institutions: institutions.toList()..sort(), 
      dates: [],
    );
  }
}