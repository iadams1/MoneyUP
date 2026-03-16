import 'package:moneyup/models/streak_data.dart';
import 'package:moneyup/services/service_locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StreakService {
  final SupabaseClient _client = Supabase.instance.client;

  String get user => supabaseService.currentUserId!;
  
  Future<bool> recordUserStreak() async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final result = await _client.rpc(
      'record_user_streak',
      params: {
        'p_user_id': user,
        'p_check_in_date': today,
      },
    );

    return result as bool;
  }

  Future<StreakData> fetchUserStreak() async {
    final response = await _client
        .from('user_streaks')
        .select('current_streak, longest_streak')
        .eq('user_ID', user)
        .single();

    return StreakData(
      currentStreak: response['current_streak'] ?? 0,
      longestStreak: response['longest_streak'] ?? 0,
    );
  }


  String toDateOnly(DateTime date) {
    return date.toIso8601String().split('T').first;
  }

  DateTime getStartOfWeek(DateTime date) {
    return DateTime(date.year, date.month, date.day)
        .subtract(Duration(days: date.weekday - 1));
  }

  Future<List<bool>> fetchWeekLogins() async {
    final now = DateTime.now();
    final startOfWeek = getStartOfWeek(now);
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    final startOfWeekString = toDateOnly(startOfWeek);
    final endOfWeekString = toDateOnly(endOfWeek);

    final rows = await _client
        .from('daily_user_logins')
        .select('login_date')
        .eq('user_ID', user)
        .gte('login_date', startOfWeekString)
        .lte('login_date', endOfWeekString);

    final loginDates = rows
        .map((row) => row['login_date'] as String)
        .toSet();

    return List.generate(7, (index) {
      final day = startOfWeek.add(Duration(days: index));
      return loginDates.contains(toDateOnly(day));
    });
  }
}