import 'package:flutter/material.dart';
import 'package:moneyup/models/budget.dart';
import 'package:moneyup/models/budget_type.dart';
import 'package:moneyup/services/service_locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BudgetService {
  final SupabaseClient _client = Supabase.instance.client;

  final user = supabaseService.currentUserId!;

  Future<Budget?> getRandomBudget() async {
    try {

      final response = await _client.rpc(
        'get_random_budget', 
        params: {'p_user_id': user},
      );

      if (response == null) return null;

      if (response is List && response.isEmpty) return null;

      final data = (response as List).first;
      return Budget.fromJson(data);
    } catch (e) {
      debugPrint("RPC ERROR: $e");
      rethrow;
    }
  }

  Future<void> insertBudget(
    String title,
    double goal,
    double saved,
    BudgetType type,
  ) async {
    try {
      await _client.from('budgets').insert({
        'user_ID': user,
        'Title': title,
        'Goal': goal,
        'AmountSaved': saved,
        'AmountNeeded': (goal - saved),
        'Category': type.label,
      });
    } catch (e) {
      debugPrint('Error inserting budget: $e');
    }
  }

  Future<List<Budget>> getUserBudgets() async {

    final budgetsResponse = await _client
        .from('budgets')
        .select('*')
        .eq('user_ID', user as Object);

    final categoriesResponse = await _client
        .from('category_table')
        .select('category_ID, Title');

    final budgets = List<Map<String, dynamic>>.from(budgetsResponse);
    final categories = List<Map<String, dynamic>>.from(categoriesResponse);

    final budgetsWithId = budgets.map((budget) {
      final matchingCategory = categories.firstWhere(
        (c) => c['Title'] == budget['Category'],
        orElse: () => {'category_ID': 0},
      );

      final categoryID = (matchingCategory['category_ID'] ?? 0);

      return {
        ...budget, 
        'category_ID': categoryID
      };
    }).toList();
    
    return budgetsWithId.map((row) => Budget.fromJson(row)).toList();
  }

  Future<void> deleteBudget(dynamic budgetId) async {
    try {
      await Supabase.instance.client
          .from('budgets')
          .delete()
          .eq('budget_ID', budgetId)
          .eq('user_ID', user as Object);

      debugPrint('Deletion was successful!');

    } catch (error) {
      debugPrint('Error Deleting rows: $error');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getSpendingRows({
    required DateTime start,
    required DateTime end,
  }) async {
    
    final response = await _client
        .from('budget_transactions')
        .select(
          'category_table!inner(category_ID, Title), spendingAmount, transactionDate',
        )
        .eq('user_ID', user)
        .gte('transactionDate', start.toIso8601String().split("T")[0])
        .lt('transactionDate', end.toIso8601String().split("T")[0]);
    
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Budget?> getSpecificBudget(dynamic budgetId) async {
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

  Future<void> updateBudget({
    required budgetId, 
    required double amountSaved, 
    required double amountNeeded
  }) async {
    try {
      await _client
          .from('budgets')
          .update({
            'AmountSaved': amountSaved,
            'AmountNeeded': amountNeeded,
          })
          .eq('budget_ID', budgetId)
          .select();
    } catch (e) {
      debugPrint('Error updating budget: $e');
    }
  }

}