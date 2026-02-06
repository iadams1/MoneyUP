import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  /* 
  ====================================
    AUTH SECTION
  ====================================
  */
  String? get currentUserId {
    return _client.auth.currentUser?.id;
  }

  bool get isAuthenticated {
    return _client.auth.currentUser != null;
  }

  /*
  ====================================
    DATABASE SECTION
  ====================================
  */

}