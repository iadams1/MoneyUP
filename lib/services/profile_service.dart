import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/services/service_locator.dart';
import '/shared/contrants/user_icons.dart';

class ProfileService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Current logged-in user ID
  String? get user => supabaseService.currentUserId;

  /// Notifier for the user's selected icon
  final ValueNotifier<int> iconIdNotifier = ValueNotifier<int>(UserImages.defaultId);

  /// Save the selected profile icon
  Future<void> saveProfileSelection({required int profileIconId}) async {
    final currentUser = user;
    if (currentUser == null) return;

    await _client
        .from('profiles')
        .update({'icon_id': profileIconId})
        .eq('id', currentUser);

    iconIdNotifier.value = profileIconId;
  }

  /// Load the current profile icon ID
  Future<int> loadProfileIcon() async {
    return await getProfileIconId();
  }

  /// Fetch profile icon ID from database, with fallback
  Future<int> getProfileIconId({int fallback = UserImages.defaultId}) async {
    final currentUser = user;
    if (currentUser == null) return fallback;

    final row = await _client
        .from('profiles')
        .select('icon_id')
        .eq('id', currentUser)
        .maybeSingle();

    final iconId = (row?['icon_id'] as int?) ?? fallback;
    iconIdNotifier.value = iconId;

    return iconId;
  }

  /// Fetch the user's full name
  Future<String?> getUserName() async {
    final currentUser = user;
    if (currentUser == null) return null;

    final response = await _client
        .from('profiles')
        .select('full_name')
        .eq('id', currentUser)
        .maybeSingle();

    return response?['full_name'] as String?;
  }

  /// Check if the user has seen the Plaid connect dialog
  Future<bool> hasSeenPlaidConnectDialog() async {
    final currentUser = user;
    if (currentUser == null) return false;

    final row = await _client
        .from('profiles')
        .select('has_plaid_connected')
        .eq('id', currentUser)
        .maybeSingle();

    return row?['has_plaid_connected'] as bool? ?? false;
  }

  /// Mark that the user has seen the Plaid connect dialog
  Future<void> markPlaidConnectDialogSeen() async {
    final currentUser = user;
    if (currentUser == null) return;

    await _client
        .from('profiles')
        .update({'has_plaid_connected': true})
        .eq('id', currentUser);
  }
}