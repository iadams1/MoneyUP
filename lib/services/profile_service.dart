import 'package:flutter/material.dart';
import 'package:moneyup/services/service_locator.dart';
import 'package:moneyup/shared/contrants/user_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final ValueNotifier<int> iconIdNotifier = ValueNotifier<int>(UserImages.defaultId);

  final SupabaseClient _client = Supabase.instance.client;

  final user = supabaseService.currentUserId!;

  Future<void> saveProfileSelection({required int profileIconId}) async {
    await _client.from('profiles')
    .update({'icon_id': profileIconId})
    .eq('id', user)
    .select();

    iconIdNotifier.value = profileIconId;
  }

  Future<int> loadProfileIcon() async {
    await getProfileIconId();
    return iconIdNotifier.value;
  }

  Future<int> getProfileIconId({int fallback = 12}) async {

    final row = await _client
      .from('profiles')
      .select('icon_id')
      .eq('id', user)
      .maybeSingle();
    
    iconIdNotifier.value = (row?['icon_id'] as int?) ?? UserImages.defaultId;
    return iconIdNotifier.value;
  }
}