import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moneyup/services/budget_response.dart';

class PredictionService {
  //static const String _baseUrl = 'http://10.0.2.2:8000';
  //static const String _baseUrl = 'http://127.0.0.1:8000';
  static const String _baseUrl = 'http://172.20.10.7:8000';

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
    if (userId == null) return [];

    final response = await Supabase.instance.client
        .from('budget_logs')
        .select('log_date, amount')
        .eq('budget_id', budgetId)
        .eq('user_id', userId)
        .order('log_date');

    double cumulative = 0;
    final List<Map<String, double>> daily = [];

    for (final log in response) {
      cumulative += (log['amount'] as num).toDouble();
      final date = DateTime.parse(log['log_date']);
      daily.add({'day': date.day.toDouble(), 'cumulative': cumulative});
    }

    return daily;
  }
}
