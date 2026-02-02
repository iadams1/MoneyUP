import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  // Access the Supabase client
  final SupabaseClient _supabase = Supabase.instance.client;

  // SIGN UP
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        // You can add more metadata here (e.g., 'created_at')
      },
    );
  }

  // LOGIN
  Future<AuthResponse> login(String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // SIGN OUT
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // GET CURRENT USER
  User? get currentUser => _supabase.auth.currentUser;
}