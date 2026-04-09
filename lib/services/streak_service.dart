import 'package:supabase_flutter/supabase_flutter.dart';

import '/models/streak_data.dart';
import '/services/service_locator.dart';

class StreakService {
  static final SupabaseClient _client = Supabase.instance.client;

  String? get user => supabaseService.currentUserId;

  /// Record the user's streak for today.
  Future<bool> recordUserStreak() async {
    final currentUser = user;
    if (currentUser == null) return false;

    final today = DateTime.now().toIso8601String().split('T').first;

    final result = await _client.rpc(
      'record_user_streak',
      params: {
        'p_user_id': currentUser,
        'p_check_in_date': today,
      },
    );

    // RPC might return null, so safely cast to bool
    return result == true;
  }

  /// Fetch the user's streak data
  Future<StreakData> fetchUserStreak() async {
    final currentUser = user;
    if (currentUser == null) {
      return StreakData(currentStreak: 0, longestStreak: 0, weekLogins: List.filled(7, false));
    }

    final response = await _client
        .from('user_streaks')
        .select('current_streak, longest_streak')
        .eq('user_ID', currentUser)
        .maybeSingle();

    final weekLogins = await fetchWeekLogins();

    return StreakData(
      currentStreak: response?['current_streak'] ?? 0,
      longestStreak: response?['longest_streak'] ?? 0,
      weekLogins: weekLogins,
    );
  }

  /// Format DateTime to YYYY-MM-DD
  String toDateOnly(DateTime date) {
    return date.toIso8601String().split('T').first;
  }

  /// Start of the week (Monday)
  DateTime getStartOfWeek(DateTime date) {
    return DateTime(date.year, date.month, date.day)
        .subtract(Duration(days: date.weekday - 1));
  }

  /// Returns a list of booleans for the current week's login (Mon-Sun)
  Future<List<bool>> fetchWeekLogins() async {
    final currentUser = user;
    if (currentUser == null) return List.filled(7, false);

    final now = DateTime.now();
    final startOfWeek = getStartOfWeek(now);
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    final startOfWeekString = toDateOnly(startOfWeek);
    final endOfWeekString = toDateOnly(endOfWeek);

    final rows = await _client
        .from('daily_user_logins')
        .select('login_date')
        .eq('user_ID', currentUser)
        .gte('login_date', startOfWeekString)
        .lte('login_date', endOfWeekString);

    final loginDates = (rows as List)
        .map((row) => row['login_date'] as String)
        .toSet();

    return List.generate(7, (index) {
      final day = startOfWeek.add(Duration(days: index));
      return loginDates.contains(toDateOnly(day));
    });
  }
}