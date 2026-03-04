import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    required String username,
  }) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'username': username,
      },
    );
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

// VERIFCATION CODE HERE
Future<AuthResponse> verifyOtp({
  required String email,
  required String token,
  required OtpType type,
}) async {
  final cleanEmail = email.trim().toLowerCase();           // lowercase helps consistency
  print("Verifying OTP for cleaned email: '$cleanEmail' (length: ${cleanEmail.length})");
  
  // Optional: add very basic sanity check (helps debugging)
  if (!cleanEmail.contains('@') || !cleanEmail.contains('.')) {
    throw Exception("Email appears invalid before sending to Supabase");
  }

  return await _supabase.auth.verifyOTP(
    email: cleanEmail,
    token: token.trim(),  // also trim token just in case
    type: type,
  );
}

  Future<void> resendOtp({
    required String email,
    required OtpType type,
  }) async {
    await _supabase.auth.resend(
      type: type,
      email: email,
    );
  }
  User? get currentUser => _supabase.auth.currentUser;
}