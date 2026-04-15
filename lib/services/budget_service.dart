import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '/models/budget.dart';
import '/models/budget_type.dart';
import '/services/service_locator.dart';

class BudgetService {
  final SupabaseClient _client = Supabase.instance.client;

  String? get user => supabaseService.currentUserId;

  /// Fetch a random budget via RPC
  Future<Budget?> getRandomBudget() async {
    try {
      final response = await _client.rpc(
        'get_random_budget',
        params: {'p_user_id': user},
      );

      if (response is! List || response.isEmpty) return null;

      final data = response.first;
      if (data is Map<String, dynamic>) {
        return Budget.fromJson(data);
      } else {
        debugPrint("Unexpected RPC response format: $data");
        return null;
      }
    } catch (e) {
      debugPrint("RPC ERROR: $e");
      rethrow;
    }
  }

  /// Insert a new budget record
  Future<void> insertBudget(
    String title,
    double goal,
    double spent,
    BudgetType type,
  ) async {
    try {
      await _client.from('budgets').insert({
        'user_ID': user,
        'Title': title,
        'Goal': goal,
        'AmountSpent': spent,
        'AmountRemaining': goal - spent,
        'Category': type.label,
      });
    } catch (e) {
      debugPrint('Error inserting budget: $e');
    }
  }

  /// Fetch all budgets with category IDs included
  Future<List<Budget>> getUserBudgets() async {
    if (user == null) return [];

    final budgetsResponse = await _client
        .from('budgets')
        .select('*')
        .eq('user_ID', user as Object);

    final categoriesResponse = await _client
        .from('category_table')
        .select('category_ID, Title');

    final budgets = budgetsResponse;
    final categories = categoriesResponse;

    final budgetsWithId = budgets.map((budget) {
      final matchingCategory = (categories).firstWhere(
        (c) => c['Title'] == budget['Category'],
        orElse: () => {'category_ID': 0},
      );

      return {
        ...budget,
        'category_ID': matchingCategory['category_ID'] ?? 0,
      };
    }).toList();

    return budgetsWithId.map((row) => Budget.fromJson(row)).toList();
  }

  /// Soft-delete a budget by ID
  Future<void> deleteBudget(dynamic budgetId) async {
    if (user == null) return;

    try {
      await _client
          .from('budgets')
          .delete()
          .eq('budget_ID', budgetId)
          .eq('user_ID', user as Object);

      debugPrint('✅ Budget deletion successful');
    } catch (error, stack) {
      debugPrint('❌ Error deleting budget: $error\n$stack');
      rethrow;
    }
  }

  /// Fetch spending rows for a date range
  Future<List<Map<String, dynamic>>> getSpendingRows({
    required DateTime start,
    required DateTime end,
  }) async {
    if (user == null) return [];

    // Convert to date strings (YYYY-MM-DD)
    final startDate = start.toIso8601String().split('T')[0];
    final endDate = end.toIso8601String().split('T')[0];

    final response = await _client
        .from('plaid_transactions')
        .select('category_table!inner(category_ID, Title), amount, authorized_date')
        .eq('user_id', user as dynamic)
        .gte('authorized_date', startDate)
        .lt('authorized_date', endDate);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Fetch a specific budget by ID
  Future<Budget?> getSpecificBudget(dynamic budgetId) async {
    if (user == null) return null;

    final response = await _client
        .from('budgets')
        .select('*')
        .eq('budget_ID', budgetId)
        .eq('user_ID', user as Object)
        .limit(1);

    final rows = List<Map<String, dynamic>>.from(response);
    if (rows.isEmpty) return null;

    return Budget.fromJson(rows.first);
  }

  /// Update budget amounts
  Future<void> updateBudget({
    required dynamic budgetId,
    required double amountSpent,
    required double amountRemaining,
  }) async {
    if (user == null) return;

    try {
      await _client
          .from('budgets')
          .update({
            'AmountSpent': amountSpent,
            'AmountRemaining': amountRemaining,
          })
          .eq('budget_ID', budgetId)
          .select();
    } catch (e) {
      debugPrint('Error updating budget: $e');
    }
  }

  /// Fetch top spending categories in a date range
  Future<List<Map<String, dynamic>>> getMonthlySpending({
    required DateTime start,
    required DateTime end,
  }) async {
    if (user == null) return [];

    final response = await _client.rpc(
      'get_top_spending_categories',
      params: {
        'user_uuid': user,
        'start_date': start.toIso8601String(),
        'end_date': end.toIso8601String(),
      },
    );

    return response is List ? List<Map<String, dynamic>>.from(response) : [];
  }
}