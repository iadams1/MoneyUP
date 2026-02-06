import 'package:flutter/material.dart';
import 'package:moneyup/models/budget.dart';
import 'package:moneyup/models/budget_type.dart';
import 'package:moneyup/services/service_locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BudgetService {
  final SupabaseClient _client = Supabase.instance.client;

  final user = supabaseService.currentUserId;

  Future<Budget?> getRandomBudget() async {
    try {

      if(user == null) {
        throw Exception('User not authenticated');
      }

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
  
}