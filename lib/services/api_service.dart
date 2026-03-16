import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moneyup/services/budget_response.dart';

class PredictionService {
  static const String _baseUrl = 'http://10.0.2.2:8000';

  // Get current logged in user's ID automatically
  String? get _currentUserId => Supabase.instance.client.auth.currentUser?.id;

  Future<PredictionResult> getPrediction({required String budgetId}) async {

    if (_currentUserId == null) {
      throw Exception('No user logged in');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/predict'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'budget_id': budgetId,
        'user_id': _currentUserId,
      }),
    );

    if (response.statusCode == 200) {
      return PredictionResult.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Prediction failed: ${response.body}');
    }
  }


}