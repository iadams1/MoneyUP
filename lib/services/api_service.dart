import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moneyup/services/budget_response.dart';
import 'package:flutter/foundation.dart';

class PredictionService {
  //static const String _baseUrl = 'http://10.0.2.2:8000'; //Android Emulator
  //static const String _baseUrl = 'http://127.0.0.1:8000';  //Localhost
  //static const String _baseUrl = 'http://10.200.230.23:8000';  //university wifi
  static const String _baseUrl =
      'http://172.20.10.2:8000'; //Phone hotspot network

  // Get current logged in user's ID automatically
  String? get _currentUserId => Supabase.instance.client.auth.currentUser?.id;

  Future<PredictionResult> getPrediction({required String budgetId}) async {
    if (_currentUserId == null) {
      throw Exception('No user logged in');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/predict'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'budget_id': budgetId, 'user_id': _currentUserId}),
    );

    if (response.statusCode == 200) {
      return PredictionResult.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Prediction failed: ${response.body}');
    }
  }

  Future<List<Map<String, double>>> getTransactionSpending({
    required String budgetId,
  }) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      debugPrint('No user ID');
      return [];
    }

    debugPrint(
      '🔍 Querying budget_history for budgetId: $budgetId, userId: $userId',
    );

    final response = await Supabase.instance.client
        .from('budget_history')
        .select('recorded_at, AmountSpent')
        .eq('budget_ID', budgetId)
        .eq('user_ID', userId)
        .order('recorded_at', ascending: true);

    debugPrint('Raw response: $response');
    debugPrint('Response length: ${response.length}');

    final List<Map<String, double>> daily = [];

    for (final log in response) {
      final date = DateTime.parse(log['recorded_at']);
      final amount = (log['AmountSpent'] as num).toDouble();
      daily.add({'day': date.day.toDouble(), 'cumulative': amount});
    }

    return daily;
  }
  // Future<List<Map<String, double>>> getTransactionSpending({
  //   required String budgetId,
  // }) async {
  //   final userId = Supabase.instance.client.auth.currentUser?.id;
  //   if (userId == null) return [];

  //   final response = await Supabase.instance.client
  //       .from('budget_history')
  //       .select('recorded_at, AmountSpent')
  //       .eq('budget_ID', budgetId)
  //       .eq('user_ID', userId)
  //       .order('recorded_at');

  //   final List<Map<String, double>> daily = [];

  //   for (final log in response) {
  //   final date = DateTime.parse(log['recorded_at']);
  //   final amount = (log['AmountSpent'] as num).toDouble();
  //   daily.add({'day': date.day.toDouble(), 'cumulative': amount});
  // }

  // return daily;
  // }
}
