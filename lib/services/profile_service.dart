import 'package:flutter/material.dart';
import 'package:moneyup/services/service_locator.dart';
import 'package:moneyup/shared/contrants/user_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final SupabaseClient _client = Supabase.instance.client;

  String get user => supabaseService.currentUserId!;

  final ValueNotifier<int> iconIdNotifier = ValueNotifier<int>(UserImages.defaultId);

  Future<void> saveProfileSelection({required int profileIconId}) async {
    await _client
        .from('profiles')
        .update({'icon_id': profileIconId})
        .eq('id', user);

    iconIdNotifier.value = profileIconId;
  }

  Future<int> loadProfileIcon() async {
    await getProfileIconId();
    return iconIdNotifier.value;
  }

  Future<int> getProfileIconId({int fallback = UserImages.defaultId}) async {
    final row = await _client
        .from('profiles')
        .select('icon_id')
        .eq('id', user)
        .maybeSingle();

    final iconId = (row?['icon_id'] as int?) ?? fallback;
    iconIdNotifier.value = iconId;

    return iconId;
  }

   Future<String?> getUserName() async {
    final response = await _client
        .from('profiles')
        .select('full_name')
        .eq('id', user)
        .maybeSingle();

    return response?['full_name'] as String?;
  }

  Future<bool> hasSeenPlaidConnectDialog() async {
    final row = await _client
        .from('profiles')
        .select('has_plaid_connected')
        .eq('id', user)
        .maybeSingle();

    return row?['has_plaid_connected'] as bool? ?? false;
  }

  Future<void> markPlaidConnectDialogSeen() async {
    await _client
        .from('profiles')
        .update({'has_plaid_connected': true})
        .eq('id', user);
  }

  Future<void> recordUserStreak() async {
    final today = DateTime.now().toIso8601String().split('T').first;

    await _client.rpc(
      'record_user_streak',
      params: {
        'p_user_id': user,
        'p_check_in_date': today,
      },
    );

    final response = await _client
      .from('user_streaks')
      .select()
      .eq('user_ID', user)
      .single();

    print(response);

    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    String toDateOnly(DateTime d) => d.toIso8601String().split('T').first;

    final rows = await _client
        .from('daily_user_logins')
        .select('login_date')
        .eq('user_ID', user)
        .gte('login_date', toDateOnly(startOfWeek))
        .lte('login_date', toDateOnly(endOfWeek))
        .order('login_date');

    print(rows);
  }
}