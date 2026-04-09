import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moneyup/models/budget_response.dart';
import 'package:flutter/foundation.dart';

class PredictionService {
  static const String _baseUrl = 'http://10.0.2.2:8000';
  // Alternative local URLs for testing:
  // static const String _baseUrl = 'http://127.0.0.1:8000';
  // static const String _baseUrl = 'http://172.20.10.7:8000';

  /// Current logged-in user ID
  String? get _currentUserId => Supabase.instance.client.auth.currentUser?.id;

  /// Fetch budget prediction from backend
  Future<PredictionResult> getPrediction({required String budgetId}) async {
    final userId = _currentUserId;
    if (userId == null) {
      throw Exception('No user logged in');
    }

    final uri = Uri.parse('$_baseUrl/predict');
    final body = jsonEncode({'budget_id': budgetId, 'user_id': userId});

    final response = await http.post(uri,
        headers: {'Content-Type': 'application/json'}, body: body);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return PredictionResult.fromJson(decoded);
    } else {
      debugPrint('Prediction failed: ${response.statusCode} ${response.body}');
      throw Exception('Prediction failed: ${response.body}');
    }
  }

  /// Fetch cumulative spending history for a specific budget
  Future<List<Map<String, double>>> getTransactionSpending({
    required String budgetId,
  }) async {
    final userId = _currentUserId;
    if (userId == null) {
      debugPrint('No user logged in');
      return [];
    }

    debugPrint('🔍 Querying budget_history for budgetId: $budgetId, userId: $userId');

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
      try {
        final recordedAt = log['recorded_at'] as String?;
        final amount = log['AmountSpent'];
        if (recordedAt == null || amount == null) continue;

        final date = DateTime.parse(recordedAt);
        daily.add({'day': date.day.toDouble(), 'cumulative': (amount as num).toDouble()});
      } catch (e) {
        debugPrint('Skipping invalid row: $log\nError: $e');
      }
    }

    return daily;
  }
}